variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ssh_key_name" {
  type    = string
  default = "tf-ec2-key1"
}

variable "ami_owner" {
  type    = string
  default = "099720109477" # Canonical Ubuntu owner for some regions (optional)
}
