variable "projeto" {
  description = "Nome do projeto"
  type        = string
}

variable "candidato" {
  description = "Nome do candidato"
  type        = string
}

variable "subnet_id" {
  description = "ID da Subnet"
  type        = string
}

variable "security_group_id" {
  description = "ID do Security Group"
  type        = string
}

variable "ami_id" {
  description = "ID da AMI para a instancia EC2"
  type        = string
}
