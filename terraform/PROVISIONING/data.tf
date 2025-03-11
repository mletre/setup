# Define Master Instance
data "google_compute_disk" "source_disk" {
  name = "master-instance"
  zone = var.zone
}

# Define your existing IP Address
data "google_compute_address" "scatic_ip" {
  name   = var.static_ip
  region = var.region
}

# Create random string for unique name
resource "random_string" "instance_name" {
  length  = 8
  special = false
  upper   = false
  lifecycle {
    create_before_destroy = true
  }
}
