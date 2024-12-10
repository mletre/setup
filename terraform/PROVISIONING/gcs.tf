# Create a Google Cloud Storage bucket
resource "google_storage_bucket" "bucket" {
  name          = "bucket-gcs-name-3" # Replace with your desired bucket name
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
  labels = {
    name               = "bucket-name-gcs"
    applicationname    = "application-name"
    projectname        = "ap-xxxx"
    environment        = "dev"
    costcenter         = "cc-1234"
    ownerteam          = "ops"
    ownerteamtmail     = "ownermail"
    dataclassification = "private"
    backuppolicy       = "production"
    downtime           = "weekend-only"
  }
}
