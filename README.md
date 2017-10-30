# Description

This is a terraform project to create kafka, zookeeper stacks by AWS EC2, ASG, Route53, VPC ...

# Test commands

kafka-avro-console-producer \
         --broker-list localhost:9092 --topic test \
         --property value.schema='{"type":"record","name":"myrecord","fields":[{"name":"f1","type":"string"}]}'

{"f1": "value1"}
{"f1": "value2"}
{"f1": "value3"}


kafka-avro-console-consumer --topic test \
         --zookeeper localhost:2181 \
         --from-beginning
         

# Reference
https://docs.confluent.io/current/quickstart.html
https://docs.confluent.io/current/control-center/docs/security/sasl.html
https://aws.amazon.com/quickstart/architecture/confluent-platform/

