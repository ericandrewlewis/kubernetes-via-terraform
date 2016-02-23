# A utility instance that we can ssh to from anywhere on the internet
# and manage the cluster.
resource "aws_instance" "kubernetes-utility" {
	ami = "${var.coreos-ami}"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.kubernetes-public-subnet-a.id}"
	associate_public_ip_address = true
	#
	security_groups = ["${aws_security_group.allow_ssh_from_the_internet.id}", "${aws_security_group.allow_ssh_to_within_vpc.id}", "${aws_security_group.allow_etcd_to_within_vpc.id}", "${aws_security_group.allow_all_outgoing_traffic.id}",
	"${aws_security_group.allow_traffic_from_the_internet_for_prometheus.id}"]
	key_name = "kubernetes"
	user_data = "${file("user-data/utility.yml")}"

	tags {
		Name = "kubernetes-utility"
	}
}

# For some reason output the NAT's public IP address.
output "Utility Server Address" {
	value = "${aws_instance.kubernetes-utility.public_ip}"
}
