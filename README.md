# About

This Terraform module provisions an HAProxy load balancer for a Vault cluster on OpenStack. It is designed to integrate with Vault's architecture, ensuring high availability and efficient load balancing across the Vault nodes.

# Usage

## Variables

This module requires the following variables:

- **name**: Name to assign to the VM. This will also be used as the hostname.
- **image_source**: Specifies the source of the VM's image. It accepts either:
  - **image_id**: ID of an image for a VM with local storage.
  - **volume_id**: ID of a volume containing the OS for the VM.
- **flavor_id**: ID of the VM flavor to use for the instance.
- **network_port**: Network port to assign to the VM. Should be of type `openstack_networking_port_v2`.
- **server_group**: Server group for the VM. Should be of type `openstack_compute_servergroup_v2`.
- **keypair_name**: Name of the SSH keypair for admin access to the VM.
- **chrony**: Configuration for NTP using Chrony. Includes options for servers, pools, and makestep settings. Chrony is installed and configured if enabled; otherwise, default image NTP settings are used.
- **haproxy**: Configuration parameters for HAProxy. Includes settings for the number of Vault nodes, nameserver IPs, Vault domain, and various timeouts (connect, check, idle).
- **install_dependencies**: Indicates whether to install all dependencies during cloud-init. Defaults to `true`.

## Modules

The setup includes the following modules:

- **vault_load_balancer_configs**: Configures the HAProxy for the Vault load balancer.
- **prometheus_node_exporter_configs**: Sets up Prometheus node exporter for monitoring.
- **chrony_configs**: Manages Chrony configuration for NTP synchronization.

## Cloud-Init Configuration

Cloud-init is used to initialize and configure the VM. It includes base configuration, Vault load balancer setup, Prometheus node exporter, and optionally Chrony, based on the provided variables.

## Resource: `openstack_compute_instance_v2`

The `openstack_compute_instance_v2` resource creates the VM instance for the Vault load balancer. It includes configurations for the image, flavor, network port, block devices, scheduler hints, and user data for cloud-init.

# Additional Information

Ensure that all variables are correctly set according to your OpenStack environment and Vault cluster requirements. The HAProxy configuration should align with the specifics of your Vault setup, including the number of nodes and domain configurations.
