provider "google" {
    project = "${var.gcp_project}"
    region  = "${var.gcp_region}"
    zone    = "${var.gcp_zone}" 
}

resource "google_compute_network" "default" {
    name                    = "${var.gcp_network_name}"
    auto_create_subnetworks = "false"
}

resource "google_compute_firewall" "default" {
    name         = "${var.gcp_firewall_rule_name}"
    description  = "Firewall rules for Kubevirt lab"
    #network      = "${google_compute_network.default.name}"
    network      = "default"

    allow {
      protocol   = "icmp"
    }

    allow {
      protocol   = "tcp"
      ports      = ["80", "443", "8443", "30300", "30000", "30090"]
    }
    
    target_tags  = ["${var.gcp_instance_tag}"]
}

#module "google-dns-managed-zone" {
#    source      = "github.com/Eimert/terraform-google-dns-managed-zone"
#    dns_name    = "${var.gcp_network_name}"
#    dns_zone    = "${var.dns_domain_name}"
#    description = "Kubevirt Laboratory for ${var.lab_description}"
#}

module "gcp_kubevirt_lab" {
    source          = "github.com/jparrill/terraform-google-compute-engine-instance"
    amount          = "${var.gcp_instances}"
    region          = "${var.gcp_region}"
    zone            = "${var.gcp_zone}"
    # hostname format: name_prefix-amount
    name_prefix     = "${var.hostname_prefix}"
    machine_type    = "${var.gcp_instance_size}"
    disk_type       = "pd-ssd"
    disk_size       = "${var.gcp_boot_image_size_gb}"
    disk_image      = "${var.gcp_boot_image}"
    
    dns_name        = "${var.gcp_network_name}"
    dns_zone        = "${var.dns_domain_name}"
    hostname_prefix = "${var.hostname_prefix}"
    
    user_data       = "Kubevirt Laboratory for ${var.lab_description}"
    username        = "${var.lab_username}"
    public_key_path = "~/.ssh/cnv_lab_new.pub"
    instance_tag    = "${var.gcp_instance_tag}" 
}
