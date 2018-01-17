resource "aws_instance" "control_hub" {
  ami                    = "ami-f3e5aa9c"
  instance_type          = "t2.micro"
  key_name               = "<your_key_name>"
  subnet_id              = "${aws_subnet.public_sn_1.id}"
  vpc_security_group_ids = ["${aws_security_group.public_limited_sg.id}"]

  # Key file copy
  provisioner "file" {
    source      = "<your_key_name>.pem"
    destination = "/tmp/<your_key_name>.pem"
  }

  # Ansible files copy
  provisioner "file" {
    source      = "../ansible"
    destination = "/tmp/"
  }

  # Docker compose files copy
  provisioner "file" {
    source      = "../compose"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt-get install software-properties-common",
      "sudo apt-add-repository ppa:ansible/ansible -y",
      "sudo apt update",
      "sudo apt-get install ansible -y",
      "sudo apt-get install python-pip -y",
      "sudo pip install 'boto==2.46.1'",
      "sudo chmod 400 /tmp/<your_key_name>.pem",
      "sudo mv /tmp/<your_key_name>.pem /home/ubuntu/",
      "sudo mv /tmp/ansible /home/ubuntu",
      "sudo mv /tmp/compose /home/ubuntu",
      "sudo mv /home/ubuntu/ansible/dynamic_inventory/ec2.py /etc/ansible/hosts",
      "sudo chmod +x /etc/ansible/hosts",
      "sudo mv /home/ubuntu/ansible/dynamic_inventory/ec2.ini /etc/ansible/",
      "export ANSIBLE_HOST_KEY_CHECKING=False",
      "ansible-playbook ./ansible/docker_swarm_setup.yml --private-key <your_key_name>.pem",
    ]
  }

  connection {
    user        = "ubuntu"
    private_key = "${file("<your_key_name>.pem")}"
  }

  tags {
    Name = "control_hub"
  }
}

output "ip" {
  value = "\n\r Control Hub - ${aws_instance.control_hub.public_ip}"
}

resource "aws_instance" "minions_1a" {
  ami                    = "ami-f3e5aa9c"
  instance_type          = "t2.micro"
  key_name               = "<your_key_name>"
  count                  = 2
  subnet_id              = "${aws_subnet.private_sn_1.id}"
  vpc_security_group_ids = ["${aws_security_group.private_dmz_sg.id}"]

  tags {
    Name = "minions"
  }
}

resource "aws_instance" "minions_1b" {
  ami                    = "ami-f3e5aa9c"
  instance_type          = "t2.micro"
  key_name               = "<your_key_name>"
  count                  = 2
  subnet_id              = "${aws_subnet.private_sn_2.id}"
  vpc_security_group_ids = ["${aws_security_group.private_dmz_sg.id}"]

  tags {
    Name = "minions"
  }
}

resource "aws_lb_target_group_attachment" "dev_tga_1a" {
  count            = 2
  target_group_arn = "${aws_alb_target_group.alb_targets.0.arn}"
  target_id        = "${element(aws_instance.minions_1a.*.id, count.index)}"
  port             = 10000
}

resource "aws_lb_target_group_attachment" "dev_tga_1b" {
  count            = 2
  target_group_arn = "${aws_alb_target_group.alb_targets.0.arn}"
  target_id        = "${element(aws_instance.minions_1b.*.id, count.index)}"
  port             = 10000
}

resource "aws_lb_target_group_attachment" "test_tga_1a" {
  count            = 2
  target_group_arn = "${aws_alb_target_group.alb_targets.1.arn}"
  target_id        = "${element(aws_instance.minions_1a.*.id, count.index)}"
  port             = 11000
}

resource "aws_lb_target_group_attachment" "test_tga_1b" {
  count            = 2
  target_group_arn = "${aws_alb_target_group.alb_targets.1.arn}"
  target_id        = "${element(aws_instance.minions_1b.*.id, count.index)}"
  port             = 11000
}

resource "aws_lb_target_group_attachment" "training_tga_1a" {
  count            = 2
  target_group_arn = "${aws_alb_target_group.alb_targets.2.arn}"
  target_id        = "${element(aws_instance.minions_1a.*.id, count.index)}"
  port             = 12000
}

resource "aws_lb_target_group_attachment" "training_tga_1b" {
  count            = 2
  target_group_arn = "${aws_alb_target_group.alb_targets.2.arn}"
  target_id        = "${element(aws_instance.minions_1b.*.id, count.index)}"
  port             = 12000
}
