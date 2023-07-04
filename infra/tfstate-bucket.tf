terraform {
 backend "gcs" {
   bucket  = "pipeline-lais"
   prefix  = "terraform/state"
 }
}