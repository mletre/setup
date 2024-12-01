
# Create Image From the Master Instance
resource "google_compute_image" "from_disk" {
  name        = "redhat-disk-image-${random_string.instance_name.result}"
  source_disk = data.google_compute_disk.source_disk.self_link
}

# Create New Template Instance base on the Image
resource "google_compute_instance_template" "new_template" {
  project      = var.project
  provider     = google-beta
  description  = "Managed By Terraform"
  name         = "app-vm-template-${random_string.instance_name.result}"
  machine_type = "e2-small"
  tags         = ["jboss-port"]

  disk {
    source_image = google_compute_image.from_disk.self_link
    auto_delete  = true
    boot         = true
    resource_policies = [
      data.google_compute_resource_policy.existing_policy.id
    ]
  }

  service_account {
    email = var.compute_sa
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/pubsub",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  network_interface {
    network    = var.vpc
    subnetwork = var.subnet
  }
  lifecycle {
    create_before_destroy = true
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }
}

# Create Health Check for Instance Group Manager
resource "google_compute_health_check" "health_check_mig" {
  name                = "health-check-mig"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    request_path = "/"
    port         = "8080"
  }
}

# Create Instance Group Manager 
resource "google_compute_instance_group_manager" "mig" {
  project            = var.project
  zone               = var.zone
  name               = "app-instance-group"
  description        = "Managed By Terraform"
  provider           = google-beta
  base_instance_name = "app-vm"
  target_size        = 1
  version {
    instance_template = google_compute_instance_template.new_template.id
    name              = "primary"
  }
  named_port {
    name = "http"
    port = 8080
  }
  lifecycle {
    create_before_destroy = true
  }
  auto_healing_policies {
    health_check      = google_compute_health_check.health_check_mig.id
    initial_delay_sec = 30
  }
  update_policy {
    type                  = "PROACTIVE"
    minimal_action        = "REPLACE"
    max_surge_fixed       = 1
    max_unavailable_fixed = 0

  }

}

# Create Autoscaler for Instance Group Manager
resource "google_compute_autoscaler" "default" {
  name     = "autoscaler-policy"
  zone     = var.zone
  provider = google-beta
  target   = google_compute_instance_group_manager.mig.self_link

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 1
    cooldown_period = 60
    mode            = "ON"

    cpu_utilization {
      target = 0.90
    }

    scaling_schedules {
      name                  = "office-hours"
      min_required_replicas = 1
      schedule              = "00 8 * * 1-5" # Mon-Fri, 8 AM
      time_zone             = "Asia/Jakarta"
      duration_sec          = 32400 # 9 hours from 8 AM to 5 PM
    }

    scaling_schedules {
      name                  = "off-office-hours"
      min_required_replicas = 0
      schedule              = "00 17 * * 1-5" # Mon-Fri, 5 PM
      time_zone             = "Asia/Jakarta"
      duration_sec          = 54000 # 15 hours from 5 PM to 8 AM
    }
  }
}
