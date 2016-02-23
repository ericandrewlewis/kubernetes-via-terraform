# Create a VPC for Kubernetes resources.
resource "aws_vpc" "kubernetes-vpc" {
	# All EC2 instances will have private IPs in the range 10.0.0.0 - 10.0.255.255
	cidr_block = "10.0.0.0/16"

	tags {
		Name = "kubernetes-vpc"
	}
}
