variable "aws_key_name" {
	description = "Key name (AWS) - have local copy in dir."
	type = string
}

variable "ec2_ami" {
	description = "AMI for Ubuntu 22.04"
	type = string
}

variable "ec2_instance_type" {
	description = "Instance type of EC2 instance"
	type = string
}

variable "ec2_default_region" {
	description = "Default region for EC2"
	type = string
}

variable "ec2_default_name" {
	description = "Default name for EC2"
	type = string
}
