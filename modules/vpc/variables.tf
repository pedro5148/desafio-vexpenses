variable "projeto" {
  description = "Nome do projeto"
  type        = string
}

variable "candidato" {
  description = "Nome do candidato"
  type        = string
}

variable "cidr_block" {
  description = "Bloco CIDR da VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "Bloco CIDR da Subnet"
  type        = string
}

variable "availability_zone" {
  description = "Zona de disponibilidade da Subnet"
  type        = string
}