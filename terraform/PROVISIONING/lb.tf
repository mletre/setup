
# Create forwarding rule [Frontend]
resource "google_compute_forwarding_rule" "google_compute_forwarding_rule" {
  project               = var.project
  name                  = "app-lb-frontend"
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
}

# Create Load Balancer
resource "google_compute_region_url_map" "default" {
  project         = var.project
  name            = "app-lb"
  provider        = google-beta
  region          = var.region
  default_service = google_compute_region_backend_service.default.id
}

# HTTP target proxy
resource "google_compute_region_target_http_proxy" "default" {
  project  = var.project
  name     = "app-lb-target-http-proxy"
  provider = google-beta
  region   = var.region
  url_map  = google_compute_region_url_map.default.id
}

# backend service
resource "google_compute_region_backend_service" "default" {
  project               = var.project
  name                  = "app-lb-backend"
  provider              = google-beta
  region                = var.region
  protocol              = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  timeout_sec           = 10
  health_checks         = [google_compute_region_health_check.default.id]
  backend {
    group           = google_compute_instance_group_manager.mig.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

# Create Health Check for the Load Balancer
resource "google_compute_region_health_check" "default" {
  project             = var.project
  name                = "app-lb-hc"
  provider            = google-beta
  region              = var.region
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}
