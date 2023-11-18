variable "name" {
  description = "Name to give to the vm."
  type        = string
}

variable "network_port" {
  description = "Network port to assign to the node. Should be of type openstack_networking_port_v2"
  type        = any
}

variable "server_group" {
  description = "Server group to assign to the node. Should be of type openstack_compute_servergroup_v2"
  type        = any
}

variable "image_source" {
  description = "Source of the vm's image"
  type = object({
    image_id = string
    volume_id = string
  })
}

variable "flavor_id" {
  description = "ID of the VM flavor"
  type = string
}

variable "keypair_name" {
  description = "Name of the keypair that will be used by admins to ssh to the node"
  type = string
}

variable "chrony" {
  description = "Chrony configuration for ntp. If enabled, chrony is installed and configured, else the default image ntp settings are kept"
  type        = object({
    enabled = bool,
    //https://chrony.tuxfamily.org/doc/4.2/chrony.conf.html#server
    servers = list(object({
      url = string,
      options = list(string)
    })),
    //https://chrony.tuxfamily.org/doc/4.2/chrony.conf.html#pool
    pools = list(object({
      url = string,
      options = list(string)
    })),
    //https://chrony.tuxfamily.org/doc/4.2/chrony.conf.html#makestep
    makestep = object({
      threshold = number,
      limit = number
    })
  })
  default = {
    enabled = false
    servers = []
    pools = []
    makestep = {
      threshold = 0,
      limit = 0
    }
  }
}

variable "haproxy" {
  description = "Haproxy configuration parameters"
  sensitive   = true
  type        = object({
    vault_nodes_max_count = number
    vault_nameserver_ips  = list(string)
    vault_domain          = string
    timeouts              = object({
      connect = string
      check   = string
      idle    = string
    })
  })
}

variable "install_dependencies" {
  description = "Whether to install all dependencies in cloud-init"
  type = bool
  default = true
}

variable "tls" {
  description = "Configuration for a secure vault communication over tls"
  type        = object({
    ca_certificate     = string
    client_certificate = string
    client_key         = string
    client_auth        = bool
  })
  default = {
    ca_certificate     = ""
    client_certificate = ""
    client_key         = ""
    client_auth        = false
  }
}

variable "ssh_host_key_rsa" {
  description = "Predefined rsa ssh host key"
  type        = object({
    public  = string
    private = string
  })
  default     = {
    public  = ""
    private = ""
  }
}

variable "ssh_host_key_ecdsa" {
  description = "Predefined ecdsa ssh host key"
  type        = object({
    public  = string
    private = string
  })
  default     = {
    public  = ""
    private = ""
  }
}

variable "ssh_tunnel" {
  description = "Setting for restricting the bastion access via an ssh tunnel only"
  type        = object({
    enabled = bool
    ssh     = object({
      user           = string
      authorized_key = string
    })
  })
  default     = {
    enabled = false
    ssh     = {
      user           = ""
      authorized_key = ""
    }
  }
}
