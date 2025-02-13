
# Create forwarding rule [Frontend]
resource "google_compute_forwarding_rule" "google_compute_forwarding_rule" {
  project               = var.project
  description           = "Managed By Terraform"
  name                  = "app-lb-frontend-http"
  ip_address            = data.google_compute_address.scatic_ip.address
  provider              = google-beta
  region                = var.region
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.default.id
  network               = var.vpc
  subnetwork            = var.subnet
  network_tier          = "PREMIUM"
  labels = {
    name            = "app-lb-frontend-http"
    applicationname = "cop"
    environment     = "dev"
  }
}

# Forwarding Rule for HTTPS (Port 443)
resource "google_compute_forwarding_rule" "https_forwarding_rule" {
  project               = var.project
  description           = "Managed By Terraform"
  name                  = "app-lb-frontend-https"
  ip_address            = data.google_compute_address.scatic_ip.address
  provider              = google-beta
  region                = var.region
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "443" # HTTPS port
  target                = google_compute_region_target_https_proxy.https_proxy.id
  network               = var.vpc
  subnetwork            = var.subnet
  network_tier          = "PREMIUM"
  labels = {
    name            = "app-lb-frontend-https"
    applicationname = "cop"
    environment     = "dev"
  }
}


# Create Load Balancer
resource "google_compute_region_url_map" "default" {
  project         = var.project
  name            = "app-lb"
  description     = "Managed By Terraform"
  provider        = google-beta
  region          = var.region
  default_service = google_compute_region_backend_service.default.id

}

# HTTP target proxy
resource "google_compute_region_target_http_proxy" "default" {
  project     = var.project
  name        = "app-lb-target-http-proxy"
  description = "Managed By Terraform"
  provider    = google-beta
  region      = var.region
  url_map     = google_compute_region_url_map.default.id
}

# # HTTPS Target Proxy (uses SSL certificate)
resource "google_compute_region_target_https_proxy" "https_proxy" {
  project     = var.project
  name        = "app-lb-target-https-proxy"
  description = "Managed By Terraform"
  provider    = google-beta
  region      = var.region
  url_map     = google_compute_region_url_map.default.id
  ssl_certificates = [
    google_compute_region_ssl_certificate.default.id # Self-managed certificate
    # google_compute_managed_ssl_certificate.default.id  # Uncomment if using Google-managed certificate
    # data.google_compute_ssl_certificate.existing_certificate.id
  ]
}

# backend service
resource "google_compute_region_backend_service" "default" {
  project               = var.project
  name                  = "app-lb-backend"
  description           = "Managed By Terraform"
  provider              = google-beta
  region                = var.region
  protocol              = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  timeout_sec           = 10
  health_checks         = [google_compute_region_health_check.default.id]
  backend {
    group           = google_compute_region_instance_group_manager.mig.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
  log_config {
    enable      = true
    sample_rate = 1.0 # Log every request (optional, defaults to 1.0)
  }
}

# Create Health Check for the Load Balancer
resource "google_compute_region_health_check" "default" {
  project             = var.project
  name                = "app-lb-hc"
  description         = "Managed By Terraform"
  provider            = google-beta
  region              = var.region
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 3
  unhealthy_threshold = 3
  http_health_check {
    port         = 8080
    request_path = "/"
  }
}
