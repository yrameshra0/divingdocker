# Docker Swarm

We want to make a docker swarm ecosystem from bare metals:

1. Terraform for creating _AWS VPC_ with _control-hub_ instance in public subnet with key base restricted access and other instances in the private subnet which would have docker swarm nodes

1. Anisble to provision required upgradations and packages on all the instances

1. Ansible to provision docker swarm by creating a leader and then provisioning managers and workers on the instances created using terraform

1. Finally using docker swarm commands to make sure our swarm is behaving the way intended on this multi node system