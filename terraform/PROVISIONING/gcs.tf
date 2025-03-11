
# Create a Google Cloud Storage bucket
resource "google_storage_bucket" "bucket-logs" {
  name                        = "gcs-logging-cop-nonprod" # Replace with your desired bucket name
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = var.kms_name
  }

  labels = {
    name            = "gcs-logging-cop-nonprod"
    applicationname = "cop"
    environment     = "dev"
  }
}

resource "google_storage_bucket" "bucket" {
  name                        = "gcs-cop-nonprod" # Replace with your desired bucket name
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
  logging {
    log_bucket        = "gcs-logging-cop-nonprod"
    log_object_prefix = "audit-logs/"
  }

  encryption {
    default_kms_key_name = var.kms_name
  }

  labels = {
    name            = "gcs-cop-nonprod"
    applicationname = "cop"
    environment     = "dev"
  }
}
