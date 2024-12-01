variable "project" {
  type    = string
  default = "project-me"
}
variable "region" {
  type    = string
  default = "asia-southeast2"
}
variable "zone" {
  type    = string
  default = "asia-southeast2-c"
}
variable "compute_sa" {
  type    = string
  default = "xxxxxxx-compute@developer.gserviceaccount.com"
}
variable "vpc" {
  type    = string
  default = "vpc-me"
}
variable "subnet" {
  type    = string
  default = "sub-vpc-me"
}
variable "subnet_proxy" {
  type    = string
  default = "rev-sub"
}
variable "scatic_ip" {
  type    = string
  default = "for-lb"
}
