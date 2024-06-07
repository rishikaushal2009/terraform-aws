provider "aws" {
  alias  = "useast1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "useast2"
  region = "us-east-2"
}

module "vpc_us_east_1" {
  source = "./modules/vpc"
  providers = {
    aws = aws.useast1
  }
  region      = "us-east-1"
  cidr_block  = "10.0.0.0/16"
}


data "aws_ami" "latest_amazon_linux_us_east_1" {
  provider = aws.useast1
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


data "aws_ami" "latest_amazon_linux_us_east_2" {
  provider = aws.useast2
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_key_pair" "key_pair_us_east_1" {
  provider = aws.useast1
  key_name   = "ec2-keypair-us-east-1"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "aws_key_pair" "key_pair_us_east_2" {
  provider = aws.useast2
  key_name   = "ec2-keypair-us-east-2"
  public_key = tls_private_key.key_pair.public_key_openssh
}


resource "local_file" "key_pair_us_east_1" {
  content  = tls_private_key.key_pair.private_key_pem
  filename = "${path.module}/ec2-keypair-us-east-1.pem"
}


resource "local_file" "key_pair_us_east_2" {
  content  = tls_private_key.key_pair.private_key_pem
  filename = "${path.module}/ec2-keypair-us-east-2.pem"
}


resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


module "vpc_us_east_2" {
  source = "./modules/vpc"
  providers = {
    aws = aws.useast2
  }
  region      = "us-east-2"
  cidr_block  = "10.1.0.0/16"
}

module "ec2_us_east_1" {
  source = "./modules/ec2"
  providers = {
    aws = aws.useast1
  }
  region   = "us-east-1"
  ami_id   = data.aws_ami.latest_amazon_linux_us_east_1.id
  instance_type = "t2.small"
  subnet_id     = module.vpc_us_east_1.subnet_id
  key_name      = aws_key_pair.key_pair_us_east_1.key_name
}

module "ec2_us_east_2" {
  source = "./modules/ec2"
  providers = {
    aws = aws.useast2
  }
  region   = "us-east-2"
  ami_id   = data.aws_ami.latest_amazon_linux_us_east_2.id
  instance_type = "t2.small"
  subnet_id     = module.vpc_us_east_2.subnet_id
  key_name      = aws_key_pair.key_pair_us_east_2.key_name
}
