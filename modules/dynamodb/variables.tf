variable "table_name" {
  description = "Nome da tabela DynamoDB usada para lock do estado do Terraform"
  type        = string
}

variable "hash_key" {
  description = "Nome do atributo hash key da tabela DynamoDB"
  type        = string
  default     = "LockID"
}

variable "read_capacity" {
  description = "Capacidade de leitura da tabela DynamoDB"
  type        = number
  default     = 2
}

variable "write_capacity" {
  description = "Capacidade de escrita da tabela DynamoDB"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags para a tabela DynamoDB"
  type        = map(string)
  default     = {
    Name = "Terraform State Lock"
  }
}
