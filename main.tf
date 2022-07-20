provider "aws" {
	region = "eu-west-2"
}

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

resource aws_instance "ec2_example" {
	ami = "ami-064db92110f58350d"
	instance_type = "t2.small"
	key_name = "aws_tf_test"
	user_data = data.cloudinit_config.user_data.rendered
	vpc_security_group_ids = [aws_security_group.main.id]
	tags ={
		Name = "ddp_test"
	}
}

output "instance_id" {
	value = aws_instance.ec2_example.id
}
