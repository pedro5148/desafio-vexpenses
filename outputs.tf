output "private_key" {
  description = "Chave privada para acessar a instancia EC2"
  value       = module.ec2.private_key
  sensitive   = true
}

output "ec2_public_ip" {
  description = "Endereco IP publico da instancia EC2"
  value       = module.ec2.public_ip
}
 