variable "project" {
  type    = string
  default = "cop-nonprod"
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
  default = "vm-sa-custom@cop-nonprod.iam.gserviceaccount.com"
}
variable "vpc" {
  type    = string
  default = "https://www.googleapis.com/compute/v1/projects/shared-host-nonprod/global/networks/shared-host-nonprod"
}

variable "subnet" {
  type    = string
  default = "https://www.googleapis.com/compute/v1/projects/shared-host-nonprod/regions/asia-southeast2/subnetworks/sub-shared-host-nonprod"
}

# Subnet Proxy for Regional Load Balance
variable "subnet_proxy" {
  type    = string
  default = "https://www.googleapis.com/compute/v1/projects/shared-host-nonprod/regions/asia-southeast2/subnetworks/gcp-dev-proxylb-riplay"
}

# Static IP Address Name for LB
# variable "scatic_ip" {
#   type    = string
#   default = "for-lb-ip"
# }
