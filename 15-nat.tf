# The NAT (Network Address Translation) is an instance in the VPC that sits
# in the public subnet with a public IP address. Any requests bound for the
# public internet made by private instances in the VPC go through the NAT.

variable "nat_ami" {
	default = "ami-184dc970"
}

# The NAT instance should only be allowed to receive communication from within
# other instances in the VPC, and communicate with the rest of the internet.
resource "aws_security_group" "nat" {
	name = "vpc-nat"
	description = "nat"
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	ingress {
		from_port = 0
		to_port = 65535
		protocol = "tcp"
		cidr_blocks = ["10.0.0.0/8"]
	}

	ingress {
		from_port = 0
		to_port = 65535
		protocol = "udp"
		cidr_blocks = ["10.0.0.0/8"]
	}

	egress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 1024
		to_port = 65535
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 1024
		to_port = 65535
		protocol = "udp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_instance" "nat" {
	ami = "${var.nat_ami}"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.kubernetes-public-subnet-a.id}"
	security_groups = ["${aws_security_group.nat.id}"]
	source_dest_check = false
	key_name = "kubernetes"
	tags {
		Name = "nat"
	}
}

# The NAT needs an elastic IP for some reason.
resource "aws_eip" "nat" {
	instance = "${aws_instance.nat.id}"
	vpc = true
}

# For some reason output the NAT's public IP address.
output "nat address" {
	value = "${aws_eip.nat.public_ip}"
}

# Create a route table that will push all non-VPC traffic to the VPC's NAT instance.
resource "aws_route_table" "nat" {
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"
	route {
		cidr_block = "0.0.0.0/0"
		instance_id = "${aws_instance.nat.id}"
	}
}

# Link the route table to all instances in the private subnet.
resource "aws_route_table_association" "kubernetes-private-subnet-table-assoc-a" {
	subnet_id = "${aws_subnet.kubernetes-private-subnet-a.id}"
	route_table_id = "${aws_route_table.nat.id}"
}

resource "aws_route_table_association" "kubernetes-private-subnet-table-assoc-b" {
	subnet_id = "${aws_subnet.kubernetes-private-subnet-b.id}"
	route_table_id = "${aws_route_table.nat.id}"
}

resource "aws_route_table_association" "kubernetes-private-subnet-table-assoc-c" {
	subnet_id = "${aws_subnet.kubernetes-private-subnet-c.id}"
	route_table_id = "${aws_route_table.nat.id}"
}
