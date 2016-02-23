# Configure the AWS Provider. AWS credentials are filled via Terraform variables
# in the `terraform.tfvars` file.
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "us-east-1"
}
