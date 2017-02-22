resource "template_file" "cloud-config" {
    count = 3
    
    template = "${file("cloud_config.tpl")}"
    vars {
      public_ip = "${element(cloudstack_ipaddress.ip.*.ip_address, count.index)}"
      public_ip1 = "${cloudstack_ipaddress.ip.0.ip_address}"
      public_ip2 = "${cloudstack_ipaddress.ip.1.ip_address}"
      public_ip3 = "${cloudstack_ipaddress.ip.2.ip_address}"
      node_name = "${lookup(var.node_names, count.index)}"
      vault_token = "${var.vault_token}"
    }
}

resource "cloudstack_instance" "server" {
    count            = "${lookup(var.counts, "server")}"
    expunge          = true
    name             = "${lookup(var.names, "server")}0${count.index+1}"
    service_offering = "${lookup(var.server_offering, count.index % lookup(var.counts, "server"))}"
    template         = "${var.cs_template}"
    zone             = "${lookup(var.cs_zones, count.index % lookup(var.counts, "server"))}"
    network_id       = "${element(cloudstack_network.network.*.id, count.index % lookup(var.counts, "server"))}"
    keypair          = "deployment"
    user_data        = "${element(template_file.cloud-config.*.rendered, count.index)}"
}

output "addresses" {
  value = "IP addresses are ${join(", ", cloudstack_ipaddress.ip.*.ip_address)}"
}
