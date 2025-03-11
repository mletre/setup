# # Self-managed SSL Certificate (if you have your own certificate and key)
# resource "google_compute_ssl_certificate" "default" {
#   name        = "app-lb-ssl-cert"
#   private_key = file("path_to_your_private_key.pem")
#   certificate = file("path_to_your_certificate.pem")
#   project     = var.project
# }

# # Reference to an existing SSL certificate from Certificate Manager
# data "google_compute_ssl_certificate" "existing_certificate" {
#   name     = "lahacia-cert" # Replace with the name of your existing certificate in the Certificate Manager
#   project  = var.project
#   provider = google-beta
# }

resource "google_compute_region_ssl_certificate" "default" {
  name        = "certificate"
  description = "a description"
  private_key = file("server.key")
  certificate = file("server.crt")
  region      = var.region

  lifecycle {
    create_before_destroy = true
  }
}
