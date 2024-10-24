variable "project_name" {
  type = string
}
variable "zone_name" {
  type = string
}
variable "osdisk_size_gb" {
  type = string
}
variable "osdisk_type" {
  type = string
  default = "pd-balanced"
}
variable "network_tags" {
  type = list(string)
  default = []
}
variable "compute_size" {
  type = string
}