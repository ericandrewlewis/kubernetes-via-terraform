# The internet gateway allows instances in the VPC's public subnet that have
# public IP addresses to communicate with the internet.

resource "aws_internet_gateway" "kubernetes-internet-gateway" {
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"
}

# Create a route table that will push all non-VPC traffic
# to the VPC's internet gateway.
resource "aws_route_table" "public-route-table" {
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.kubernetes-internet-gateway.id}"
	}

	tags {
		Name = "Public Route Table"
	}
}

resource "aws_route_table_association" "public-route-table-association-a" {
	subnet_id = "${aws_subnet.kubernetes-public-subnet-a.id}"
	route_table_id = "${aws_route_table.public-route-table.id}"
}

resource "aws_route_table_association" "public-route-table-association-b" {
	subnet_id = "${aws_subnet.kubernetes-public-subnet-b.id}"
	route_table_id = "${aws_route_table.public-route-table.id}"
}

resource "aws_route_table_association" "public-route-table-association-c" {
	subnet_id = "${aws_subnet.kubernetes-public-subnet-c.id}"
	route_table_id = "${aws_route_table.public-route-table.id}"
}
