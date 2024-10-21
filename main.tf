terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.72.1"
    }
  }

  backend "s3" {
    # Configuração do backend para armazenar o estado no S3
    bucket = "bucket-aws-pedro5148"
    key    = "terraform-test.tfstate"
    region = "us-west-2"
    encrypt = true
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "debian12" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"]
}

module "dynamodb" {
  source         = "./modules/dynamodb"
  table_name     = "terraform-state-lock-dynamo"
  read_capacity  = 2
  write_capacity = 2
}

module "vpc" {
  source  = "./modules/vpc"
  projeto = var.projeto
  candidato = var.candidato
  subnet_cidr = "10.0.1.0/24"
  cidr_block = "10.0.0.0/16"
  availability_zone = "us-west-2a"
}

module "security" {
  source  = "./modules/security"
  projeto = var.projeto
  candidato = var.candidato
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source  = "./modules/ec2"
  projeto = var.projeto
  candidato = var.candidato
  subnet_id = module.vpc.subnet_id
  security_group_id = module.security.security_group_id
  ami_id = data.aws_ami.debian12.id
}
