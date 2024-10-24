resource "google_compute_instance" "default_compute" {
    project = var.project_name
    zone = var.zone_name

    name = var.compute_name
    machine_type = var.compute_size # machine_type

    # OS Image
    boot_disk {
      initialize_params {
        size = var.osdisk_size_gb
        type = var.osdisk_type

        # default os ubuntu 20.04 LTS
        image = ""
      }
    }

    # Network
    network_interface {
      network = var.vpc_name
      subnetwork = var.subnet_name
      subnetwork_project = var.project_name
      network_ip = var.private_ip
    }
}