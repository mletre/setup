variable "project" {
  type    = string
  default = "project-id"
}
variable "region" {
  type    = string
  default = "asia-southeast2"
}
variable "zone" {
  type    = string
  default = "asia-southeast2-b"
}
variable "compute_sa" {
  type    = string
  default = "vm-sa-custom@project-id.iam.gserviceaccount.com"
}
variable "vpc" {
  type    = string
  default = "https://www.googleapis.com/compute/v1/projects/project-id/global/networks/net-testing"
}

variable "subnet" {
  type    = string
  default = "https://www.googleapis.com/compute/v1/projects/project-id/regions/asia-southeast2/subnetworks/sub-net-testing"
}

# Subnet Proxy for Regional Load Balancer
variable "subnet_proxy" {
  type    = string
  default = "https://www.googleapis.com/compute/v1/projects/project-id/regions/asia-southeast2/subnetworks/reverse-subnet-for-lb"
}

# Static IP Address Name for LB
variable "static_ip" {
  type    = string
  default = "for-lb-ip"
}

# Assign KMS Self Link
# Example : projects/<project-name>/locations/<location-name>/keyRings/<keyring-name>/cryptoKeys/<key-name>
variable "kms_name" {
  type    = string
  default = "projects/<project-name>/locations/<location-name>/keyRings/<keyring-name>/cryptoKeys/<key-name>"
}
