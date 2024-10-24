variable "project_name" {
  type = string
}
variable "region_name" {
  type = string
  default = "asia-northeast3"
}
variable "zone_name" {
  type = string
  default = "asia-northeast3-a"
}
variable "network_tags" {
  type = list(string)
  default = []
}
variable "tag_project" {
  type = string
}
variable "tag_resource" {
  type = string
}
variable "tag_application" {
  type = string
}
variable "tag_category" {
  type = string
}
variable "tag_environment" {
  type = string
}
variable "tag_cost" {
  type = string
}
variable "tag_domain" {
  type = string
}
variable "tag_scheduletag" {
  type = string
}