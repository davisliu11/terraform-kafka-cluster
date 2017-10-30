#!/bin/bash
set -e

# dump parameters to a tmp file
echo ${app_type} > /tmp/app.txt
echo ${zookeeper_ips} >> /tmp/app.txt
echo ${hosted_zone_id} >> /tmp/app.txt
echo ${hosted_zone_name} >> /tmp/app.txt

function install_confluent() {
    yum update -y
    rpm --import http://packages.confluent.io/rpm/3.2/archive.key

    echo '
[Confluent.dist]
name=Confluent repository (dist)
baseurl=http://packages.confluent.io/rpm/3.2/6
gpgcheck=1
gpgkey=http://packages.confluent.io/rpm/3.2/archive.key
enabled=1

[Confluent]
name=Confluent repository
baseurl=http://packages.confluent.io/rpm/3.2
gpgcheck=1
gpgkey=http://packages.confluent.io/rpm/3.2/archive.key
enabled=1 
    ' > /etc/yum.repos.d/confluent.repo
    yum clean all -y
    yum install -y confluent-platform-oss-2.11

}

function update_kafka_dns() {    
    # get availability zone: eg. ap-southeast-2a
    az=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
    
    # get number from az tail value. ap-southeast-2a => a => 1
    launch_index=$(echo -n $az | tail -c 1 | tr abcdef 123456)
    
    private_ip=$(curl "http://169.254.169.254/latest/meta-data/local-ipv4")

    tmp_file_name=tmp-record.json

    echo '{
    "Comment": "DNS updated by kafka autoscaling group",
    "Changes": [
        {
        "Action": "UPSERT",
        "ResourceRecordSet": {
            "Name": "'kafka$launch_index'.${hosted_zone_name}",
            "Type": "A",
            "TTL": 30,
            "ResourceRecords": [
            {
                "Value": "'$private_ip'"
            }
            ]
        }
        }
    ]
    }' > $tmp_file_name

    aws route53 change-resource-record-sets --hosted-zone-id ${hosted_zone_id} --change-batch file://$tmp_file_name

    sed -i "s#broker.id=0#broker.id=$launch_index#g" /etc/kafka/server.properties
}

function update_configurations() {
    # update zookeeper IP address
    sed -i "s#localhost:2181#${zookeeper_ips}#g" /etc/kafka/server.properties
    sed -i "s#localhost:2181#${zookeeper_ips}#g" /etc/kafka/consumer.properties
    sed -i "s#localhost:2181#${zookeeper_ips}#g" /etc/schema-registry/schema-registry.properties

    # add both PLAINTEXT and PLAINTEXTSASL listeners
    #echo '' > /etc/kafka/kafka_server_jaas.conf
    #echo "listeners=PLAINTEXT://:9092, PLAINTEXTSASL://:19092" >> /etc/kafka/server.properties
    #echo "sasl.kerberos.service.name=kafka"  >> /etc/kafka/server.properties
}

echo "Application type is ${app_type}."
install_confluent

if [ "${app_type}" == "kafka" ]; then
    update_kafka_dns
    update_configurations
    cmd="(kafka-server-start /etc/kafka/server.properties 2>&1 > /var/log/kafka.log  & ) ; sleep 5;
         (schema-registry-start /etc/schema-registry/schema-registry.properties 2>&1 > /var/log/schema-registry.log  & )"
    action=poweroff # let ASG spins a new one
elif [ "${app_type}" == "zookeeper" ]; then
    cmd="zookeeper-server-start /etc/kafka/zookeeper.properties > /var/log/zookeeper.log"
    action=reboot # restart zookeeper on failure

    # put cmd to /etc/rc.local so it can start when system reboot
    echo "$cmd" >> /etc/rc.local
else
    echo "Invalid application type: ${app_type}"
    exit 1
fi

# instsall crontab daemon for java process
# take action on the OS only if system started more than 100 seconds and doesn't have application process
#echo '* * * * * root [ "$(ps -ef | grep '${app_type}' | grep -v grep)" == "" ] && [ $(cat /proc/uptime | cut -d "." -f 1) -ge 300 ] && /sbin/'$action > /etc/cron.d/java-daemon

# execute command
eval "$cmd"

