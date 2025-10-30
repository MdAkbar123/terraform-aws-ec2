resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = tolist(data.aws_subnets.default.ids)[0]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated.key_name
  vpc_security_group_ids      = [aws_security_group.ssh_http.id]

  tags = {
    Name = "tf-ec2-instance"
  }

  # Optional: cloud-init user_data to install nginx on first boot
  user_data = <<-EOF
              #cloud-config
              package_update: true
              packages:
                - nginx
              runcmd:
                - systemctl enable nginx
                - systemctl start nginx
              EOF
}
