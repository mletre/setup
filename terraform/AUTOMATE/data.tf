# Define Master Instance
data "google_compute_disk" "source_disk" {
  name = "redhat-master"
  zone = var.zone
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
