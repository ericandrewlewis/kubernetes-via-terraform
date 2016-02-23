# Make high availability subnets for public and private resources.

resource "aws_subnet" "kubernetes-public-subnet-a" {
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	cidr_block = "10.0.0.0/24"
	availability_zone = "us-east-1a"

	tags {
		Name = "Public Subnet A"
	}
}

resource "aws_subnet" "kubernetes-public-subnet-b" {
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	cidr_block = "10.0.1.0/24"
	availability_zone = "us-east-1b"

	tags {
		Name = "Public Subnet B"
	}
}

resource "aws_subnet" "kubernetes-public-subnet-c" {
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	cidr_block = "10.0.2.0/24"
	availability_zone = "us-east-1c"

	tags {
		Name = "Public Subnet C"
	}
}

resource "aws_subnet" "kubernetes-private-subnet-a" {
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"
	cidr_block = "10.0.3.0/24"
	availability_zone = "us-east-1a"
	tags {
		Name = "Kubernetes Private Subnet A"
	}
}

resource "aws_subnet" "kubernetes-private-subnet-b" {
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"
	cidr_block = "10.0.4.0/24"
	availability_zone = "us-east-1b"
	tags {
		Name = "Kubernetes Private Subnet B"
	}
}

resource "aws_subnet" "kubernetes-private-subnet-c" {
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"
	cidr_block = "10.0.5.0/24"
	availability_zone = "us-east-1c"
	tags {
		Name = "Kubernetes Private Subnet C"
	}
}
