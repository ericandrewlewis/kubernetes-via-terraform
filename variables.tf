# Define the existence of various Terraform input variables.

variable "aws_access_key" {
  description = "The AWS access key."
}

variable "aws_secret_key" {
  description = "The AWS secret key."
}

variable "coreos-ami" {
  default = "ami-dfb699b5"
}
