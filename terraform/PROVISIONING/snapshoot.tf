
# # Create Snapshot Policy
# resource "google_compute_resource_policy" "create_snapshot_policy" {
#   name   = "snapshot-policy-at-1-am-tf"
#   region = var.region
#   snapshot_schedule_policy {
#     schedule {
#       daily_schedule {
#         days_in_cycle = 1
#         start_time    = "18:00" # UTC time for 1 AM WIB (UTC+7)
#       }
#     }
#   }
# }

# If you have existing policy
data "google_compute_resource_policy" "existing_policy" {
  name   = "snapshot-policy-at-1-am"
  region = var.region
}
