provider "cloudstack" {
    api_key       =  "${replace("${file("~/.terraform/nl2_cs_api_key")}", "\n", "")}"
    secret_key    =  "${replace("${file("~/.terraform/nl2_cs_secret_key")}", "\n", "")}"
    api_url       =  "https://nl2.mcc.schubergphilis.com/client/api"
}


resource "cloudstack_vpc" "vpc" {
    count = 3
    name = "${var.vpcname}${count.index+1}"
    cidr = "10.0.0.0/24"
    vpc_offering = "${lookup(var.vpc_offerings, count.index)}"
    zone = "${lookup(var.cs_zones, count.index)}"
}

resource "cloudstack_ipaddress" "ip" {
    count = 3
    vpc_id = "${element(cloudstack_vpc.vpc.*.id, count.index)}"
}

resource "cloudstack_port_forward" "forward" {
    count = 3
    ip_address_id = "${element(cloudstack_ipaddress.ip.*.id, count.index)}"
    forward {
        protocol = "tcp"
        private_port = 22
        public_port = 22
        virtual_machine_id = "${element(cloudstack_instance.server.*.id, count.index)}"
    }
    forward {
        protocol = "udp"
        private_port = 53
        public_port = 53
        virtual_machine_id = "${element(cloudstack_instance.server.*.id, count.index)}"
    }
    forward {
	protocol = "tcp"
	private_port = 2379
	public_port = 2379
	virtual_machine_id = "${element(cloudstack_instance.server.*.id, count.index)}"
    }
    forward {
	protocol = "tcp"
	private_port = 2380
	public_port = 2380
	virtual_machine_id = "${element(cloudstack_instance.server.*.id, count.index)}"
    }
}

resource "cloudstack_network" "network" {
    count = 3
    name = "${var.network_name}${count.index+1}"
    cidr = "10.0.0.0/28"
    network_offering = "${var.offering_network_lb}"
    zone = "${lookup(var.cs_zones, count.index)}"
    vpc_id = "${element(cloudstack_vpc.vpc.*.id, count.index)}"
    acl_id = "${element(cloudstack_network_acl.acl.*.id, count.index)}"
}

resource "cloudstack_network_acl" "acl" {
    count = 3
    name = "${var.network_name}_ACL${count.index+1}"
    vpc_id = "${element(cloudstack_vpc.vpc.*.id, count.index)}"
}

resource "cloudstack_network_acl_rule" "acl-rule" {
    count = 3
    acl_id = "${element(cloudstack_network_acl.acl.*.id, count.index)}"

    rule {
      action = "allow"
      cidr_list  = ["${cloudstack_vpc.vpc.0.source_nat_ip}/32","${cloudstack_vpc.vpc.1.source_nat_ip}/32", "${cloudstack_vpc.vpc.2.source_nat_ip}/32", "10.0.0.0/24"]
      protocol = "tcp"
      ports = ["22","2379-2380"]
      traffic_type = "ingress"
    }
    rule {
      action = "allow"
      cidr_list  = ["0.0.0.0/0"]
      protocol = "tcp"
      ports = ["22"]
      traffic_type = "ingress"
    }
    rule {
      action = "allow"
      cidr_list  = ["0.0.0.0/0"]
      protocol = "udp"
      ports = ["53"]
      traffic_type = "ingress"
    }
}
