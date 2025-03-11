
resource "google_compute_instance" "sqlinstance" {
  name         = "app-sql-instance"
  machine_type = "e2-standard-2"
  zone         = var.zone
  description  = "Managed by Terraform"
  tags         = ["cop-dev", "cicd-cop-dev"]
  boot_disk {
    auto_delete = true

    kms_key_self_link = var.kms_name

    initialize_params {
      image = "projects/windows-sql-cloud/global/images/sql-2019-standard-windows-2025-dc-v20250213"
      size  = 200
      type  = "pd-balanced"
      resource_policies = [
        # data.google_compute_resource_policy.existing_policy.id
        google_compute_resource_policy.create_snapshot_policy.id
      ]
    }
  }

  network_interface {
    network    = var.vpc
    subnetwork = var.subnet
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email = var.compute_sa
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write"
    ]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }
  labels = {
    name            = "app-sql-instance"
    applicationname = "cop"
    environment     = "dev"
  }
  metadata = {
    enable-oslogin         = true
    block-project-ssh-keys = true
  }
}
