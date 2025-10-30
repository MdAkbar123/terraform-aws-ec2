data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [var.ami_owner] # Canonical (use variable)
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
