resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "${var.projeto}-${var.candidato}-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_instance" "debian_ec2" {
  ami             = var.ami_id
  instance_type   = "t2.micro"
  subnet_id       = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name        = aws_key_pair.ec2_key_pair.key_name

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  provisioner "file" {
    source      = "nginx/script.sh"
    destination = "/tmp/script.sh"

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = tls_private_key.ec2_key.private_key_pem
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh"
    ]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = tls_private_key.ec2_key.private_key_pem
      host        = self.public_ip
    }
  }

  tags = {
    Name = "${var.projeto}-${var.candidato}-ec2"
  }
}
