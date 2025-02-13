variable "project" {
  type    = string
  default = "xxx"
}
variable "region" {
  type    = string
  default = "asia-southeast2"
}
variable "zone" {
  type    = string
  default = "asia-southeast2-a"
}
variable "compute_sa" {
  type    = string
  default = "vm-sa-custom@xxx.iam.gserviceaccount.com"
}
variable "vpc" {
  type    = string
  default = "https://www.googleapis.com/compute/v1/projects/net-project/global/networks/net-project"
}

variable "subnet" {
  type    = string
  default = "https://www.googleapis.com/compute/v1/projects/net-project/regions/asia-southeast2/subnetworks/sub-net-project"
}

# Subnet Proxy for Regional Load Balance
variable "subnet_proxy" {
  type    = string
  default = "https://www.googleapis.com/compute/v1/projects/shared-host-nonprod/regions/asia-southeast2/subnetworks/gcp-dev-proxylb-riplay"
}

# Static IP Address Name for LB
variable "scatic_ip" {
  type    = string
  default = "for-lb-ip"
}
