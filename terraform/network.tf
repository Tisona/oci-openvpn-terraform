resource "oci_core_virtual_network" "vpn_network" {
  cidr_block     = "192.168.0.0/23"
  compartment_id = var.tenancy_ocid
  display_name   = "vpn"
}

resource "oci_core_subnet" "public_subnet" {
  cidr_block        = "192.168.0.0/24"
  compartment_id    = var.tenancy_ocid
  vcn_id            = oci_core_virtual_network.vpn_network.id
  display_name      = "vpnpublicsubnet"
  security_list_ids = [oci_core_security_list.vpn_security_list.id]
  route_table_id    = oci_core_route_table.vpn_route_table.id
  dhcp_options_id   = oci_core_virtual_network.vpn_network.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "vpn_internet_gateway" {
  compartment_id = var.tenancy_ocid
  display_name   = "vpnIG"
  vcn_id         = oci_core_virtual_network.vpn_network.id
}

resource "oci_core_route_table" "vpn_route_table" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_virtual_network.vpn_network.id
  display_name   = "vpnRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.vpn_internet_gateway.id
  }
}

resource "oci_core_security_list" "vpn_security_list" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_virtual_network.vpn_network.id
  display_name   = "vpnSecurityList"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    stateless = true

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    stateless = true

    tcp_options {
      max = var.ovpn_port 
      min = var.ovpn_port
    }
  }
}