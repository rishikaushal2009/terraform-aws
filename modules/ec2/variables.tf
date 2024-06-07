variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
}

variable "key_name" {
  description = "SSH Key name for the instance"
}

variable "region" {
  description = "AWS Region"
}
