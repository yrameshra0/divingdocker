# Docker Swarm

We want to make a docker swarm ecosystem from bare metals:

For the sake of completing this learning exercise ended up creating a domain with 4trial.net and provisioned the name servers for the domain in AWS Route53 attaching the Alias record towards and application load balancer.

The whole purpose of the Applicatio Load Balancer was to make sure that we have single Docker Swarm managing multiple enviornments for us as happens in general service architecture, the end result looks like below:

       			        +---------------+
	       		        |      DEV  	|
	       		        |      nA 	|
       		        	|      nB 	|
     	     *.test.------------+      nC   	|
	 	|	        |---------------|
	ALB--*.dev.-------------+ DOCKER SWARM	|
	   	|	        |---------------|
    	   *.training.----------+ TEST   TRAIN  |
       		        	|  nD     nG	|
       		        	|  nE     nH	|
	       		        |  nF     nF	|
       			        +---------------+

1. Terraform for creating _AWS VPC_ with _control-hub_ instance in public subnet with key base restricted access and other instances in the private subnet which would have docker swarm nodes

1. Anisble to provision required upgradations and packages on all the instances

1. Ansible to provision docker swarm by creating a leader and then provisioning managers and workers on the instances created using terraform

1. Finally using docker swarm commands to make sure our swarm is behaving the way intended on this multi node system
