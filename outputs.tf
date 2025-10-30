output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "ssh_private_key_path" {
  value = local_file.private_key_pem.filename
}
