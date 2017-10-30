resource "aws_key_pair" "deployer" {
  key_name   = "confluent-deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCeJOrQy/S8LcwuGmqaLthdS5dj6M91ImSEp8s56npHKM3+w0/pQO/woGuiN5jnmts/wqdYy6Jm+9/ClJE99fpN6dLukh/m7DaT/cUTV5gp2Au9cRd4xARV17WCSHzBAntv307LebA07MlMprkIXL0GHMMXZ1aF1bD8OY/HPSRUiL5+ZoxWEMkxMaV5nrBvKuwvrSYhYDVhTI0bsDeQINs9/8CY8snD3m1D7UPHnxOgj3sXNmGDHdHGPYQrOilOodJ4dYKsz1Z90B5r0YyjH++NYKcHtD28QtDxJWXjlWFUteZrO4cQLPqvEx61DEtlhzuVwbYPV8tVSdqVp3q5sr89 davis@XLW-5CG6451VJ6"
}
