terraform {
 backend "gcs" {
   bucket  = "lais-tfstate-df"
   prefix  = "terraform/state"
 }
}