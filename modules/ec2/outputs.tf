output "public_ip" {
  description = "Endereco IP público da instancia EC2"
  value       = aws_instance.debian_ec2.public_ip
}

output "private_key" {
  description = "Chave privada para acessar a instância EC2"
  value       = tls_private_key.ec2_key.private_key_pem
  sensitive   = true
}

output "key_name" {
  description = "Nome do par de chaves da EC2"
  value       = aws_key_pair.ec2_key_pair.key_name
}