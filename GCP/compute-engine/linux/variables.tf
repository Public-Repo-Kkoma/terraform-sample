variable "project_name" {
  type = string
}
variable "region_name" {
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
variable "compute_name" {
  type = string
}
variable "compute_size" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "subnet_name" {
  type = string
}
variable "private_ip" {
  type = string
}
variable "tag_environment" {
  type = string
}
variable "tag_application" {
  type = string
}
variable "tag_category" {
  type = string
}
variable "tag_project" {
  type = string
}
variable "tag_resource" {
  type = string
}
variable "tag_domain" {
  type = string
}
variable "tag_cost" {
  type = string
}
