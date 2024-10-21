resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name         = var.table_name
  hash_key     = var.hash_key
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity

  attribute {
    name = var.hash_key
    type = "S"
  }

  tags = var.tags
}
