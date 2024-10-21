output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "subnet_id" {
  value = aws_subnet.main_subnet.id
}

output "subnet_cidr" {
  value = var.subnet_cidr
}

output "cidr_block" {
  value = var.cidr_block
}

output "availability_zone" {
  value = var.availability_zone
}
