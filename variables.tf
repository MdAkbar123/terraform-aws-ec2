variable "aws_region" {
  type    = string
  default = "ap-south-1" # Change to your preferred AWS region
}

variable "instance_type" {
  type    = string
  default = "t2.micro" # Change to your preferred instance type
}
variable "ssh_key_name" {
  type    = string
  default = "tf-ec2-key1"
}
variable "ssh_private_key_path" {
  type    = string
  default = "/home/akbar-ali/.ssh/tf-ec2-key1.pem"
  
}
variable "ami_id" {
  type    = string
  default = "ami-02b8269d5e85954ef" # Canonical Ubuntu AMI ID for ap-south-1 region (optional)
}
  variable "ami_owner" {
  type    = string
  default = "099720109477" # Canonical's AWS account ID
}
