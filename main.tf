# AWS settings - key / secret key from AWS config
provider "aws" {
	region = var.ec2_default_region
}

# generate a security group that allows SSH (port 22)
resource "aws_security_group" "main" {
	description = "DDP Security Group"
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}

data "cloudinit_config" "user_data" {
  base64_encode = true
	part {
    content_type = "text/cloud-config"
		content = file("${path.module}/cloud-config.yml")
	}

}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "juno_kp_temp" {
  key_name = var.aws_key_name
  public_key = tls_private_key.pk.public_key_openssh

  # Copy the private key to folder
  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ${var.aws_key_name}.pem && chmod 400 ./${var.aws_key_name}.pem"
  }
}
resource aws_instance "ec2_example" {
	ami = var.ec2_ami
	instance_type = var.ec2_instance_type
	key_name = var.aws_key_name
	user_data = data.cloudinit_config.user_data.rendered
	vpc_security_group_ids = [aws_security_group.main.id]
	tags ={
		Name = var.ec2_default_name
	}
}

output "instance_id" {
	value = aws_instance.ec2_example.id
}
