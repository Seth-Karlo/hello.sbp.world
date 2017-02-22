variable "bootstrap_pubkey" {}

variable "counts" {
  default = {
    "server" = "3"
  }
}

variable "server_offering" {
  default = {
    "0" = "MCC_v2.2vCPU.8GB.SBP1"
    "1" = "MCC_v2.2vCPU.8GB.EQXAMS2"
    "2" = "MCC_v2.2vCPU.8GB.SBP1"
  }
}
variable "names" { 
  default = {
    "server" = "sbppdisco-app" 
  }
}

variable "node_names" {
  default = {
    "0" = "node1"
    "1" = "node2"
    "2" = "node3"
  }
}
variable "cs_zones" {
  default = {
    "0" = "NL2"
    "1" = "NL2"
    "2" = "NL2"
  }
}

variable "vpc_offerings" {
  default = {
    "0" = "MCC-KVM-VPC-SBP1"
    "1" = "MCC-KVM-VPC-EQXAMS2"
    "2" = "MCC-KVM-VPC-SBP1"
  }
}
variable "vpcname" { default = "SBP_PVPC_DISCOVERY" }
variable "network_name" { default = "SBP_PDISCOVERY_NET" }
variable "offering_network_lb" { default = "MCC-VPC-LB"}
variable "cs_template" { default = "Coreos-beta-x86_64-Community-KVM-latest" }
