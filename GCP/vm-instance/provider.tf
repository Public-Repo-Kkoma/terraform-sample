provider "google" {
  credentials = "${file("../gcp-credential/kkoma-billing-a0788ffd6fb8.json")}"
  project = "kkoma-billing"
}