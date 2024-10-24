module "essential" {
  source = "../essential"

  project_name = "kkoma-billing"
  region_name = "asia-northeast3"  # default value is seoul region(asia-northeast3)
  zone_name = "asis-northeast3-a"  # default value is asia-northeast3-a zone

  network_tags = ["default"]

  tag_project = "kkoma-billing"
  tag_resource = "bastion"
  tag_application = "bastion"
  tag_category = "pay"
  tag_environment = "dev"
  tag_cost = "dev-service"
  tag_domain = "cloud"
  tag_scheduletag = "office-hours_8_to_22"
}

module "dev-pay-bastion-101" {
  source = "../compute-engine/linux"

  project_name = "${module.essential.project_name}"
  zone_name = "${module.essential.zone_name}"
  region_name = "${module.essential.region_name}"
  # svc_account_name = "${module.essential.svc_account_name}"

  compute_name = "dev-pay-bastion-101"
  compute_size = "n2-highcpu-2"

  # os disk
  osdisk_size_gb = "128"
  osdisk_type = "pd-ssd"  # default value is pd-balanced

  # Networks
  vpc_name = "default"        # "wavve-dev-service-vpc-01"
  subnet_name = "default"     # "service-dev-mgmt-subnet"(10.178.0.0/20)
  private_id = "10.178.0.11"  # 10.178.0.11
  network_tags = "${module.essential.network_tags}"

  # ssh key
  # gce_ssh_pub_key_file = "~/keys/gcp/dev.pub"

  # labels
  tag_project = "${module.essential.tag_project}"
}