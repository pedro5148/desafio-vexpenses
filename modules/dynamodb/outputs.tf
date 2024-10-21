output "table_name" {
  description = "Nome da tabela DynamoDB para lock do estado"
  value       = aws_dynamodb_table.dynamodb_terraform_state_lock.name
}