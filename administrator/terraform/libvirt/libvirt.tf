provider "libvirt" {
    uri = "${var.libvirt_url}"
}

resource "libvirt_volume" "mastervol" {
  name             = "disk-master.img"
  base_volume_name = "${var.base_image}"
  size             = "${var.osdisk}"
}

resource "libvirt_volume" "datavols" {
    name  = "disk-data-${count.index}.img"
    size  = "${var.pvs_disk_size}"
    count = 5
}

data "template_file" "user_data_kubemaster" {
  template = "${file("${path.module}/cloud-init.cfg")}"
  vars {
    host_name          = "${var.hostname_prefix}-kubemaster"
    cluster_dns_domain = "${var.dns_domain_name}"
    cloud_ssh_key      = "${var.ssh_pub_key}"
  }
}

data "template_file" "network_config" {
  template = "${file("${path.module}/network_config.cfg")}"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = "${data.template_file.user_data_kubemaster.rendered}"
  network_config = "${data.template_file.network_config.rendered}"
}

resource "libvirt_domain" "kubemaster" {
  name = "kubemaster"
  memory = "${var.memory}"
  vcpu = "${var.vcpus}"
  cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"
  qemu_agent = true

  disk {
    volume_id = "${libvirt_volume.mastervol.id}"
  }

  disk {
    volume_id = "${element(libvirt_volume.datavols.*.id, 0)}"
  }

  disk {
    volume_id = "${element(libvirt_volume.datavols.*.id, 1)}"
  }

  disk {
    volume_id = "${element(libvirt_volume.datavols.*.id, 2)}"
  }

  disk {
    volume_id = "${element(libvirt_volume.datavols.*.id, 3)}"
  }

  disk {
    volume_id = "${element(libvirt_volume.datavols.*.id, 4)}"
  }

  cpu {
    mode = "host-passthrough"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }

  network_interface {
    bridge         = "${var.host_bridge_iface}"
    hostname       = "${var.hostname_prefix}-kubemaster"
    mac            = "${var.master_mac_address}"
    wait_for_lease = true
  }

  network_interface {
    bridge = "${var.host_bridge_iface}"
  }
}
