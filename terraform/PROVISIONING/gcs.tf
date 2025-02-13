# Create a Google Cloud Storage bucket
resource "google_storage_bucket" "bucket" {
  name                        = "gcs-testing-cop-nonprod" # Replace with your desired bucket name
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true


  labels = {
    name            = "gcs-testing-cop-nonprod"
    applicationname = "cop"
    environment     = "dev"
  }
}
