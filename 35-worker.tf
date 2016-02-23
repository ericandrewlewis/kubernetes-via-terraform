resource "aws_instance" "kubernetes-worker-a" {
	ami = "${var.coreos-ami}"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.kubernetes-private-subnet-a.id}"
	# todo: I don't think a worker needs to talk directly to etcd (over 2379),
	# it should be speaking to it over the HTTP API.
	# But, we are allowing this instance to make all outgoing traffic, so that negates the issue.
	security_groups = ["${aws_security_group.allow_ssh_from_within_vpc.id}", "${aws_security_group.allow_etcd_to_within_vpc.id}", "${aws_security_group.allow_flannel_traffic.id}",
	"${aws_security_group.allow_all_outgoing_traffic.id}", "${aws_security_group.allow_incoming_http_and_https.id}"]
	key_name = "kubernetes"
	user_data = "${file("user-data/worker.yml")}"
	private_ip = "10.0.3.5"

	root_block_device {
		volume_type = "gp2"
		volume_size = "20"
		delete_on_termination = true
	}

	tags {
		Name = "kubernetes-worker-a"
	}
}

resource "aws_instance" "kubernetes-worker-b" {
	ami = "${var.coreos-ami}"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.kubernetes-private-subnet-b.id}"
	# todo: I don't think a worker needs to talk directly to etcd (over 2379),
	# it should be speaking to it over the HTTP API.
	# But, we are allowing this instance to make all outgoing traffic, so that negates the issue.
	security_groups = ["${aws_security_group.allow_ssh_from_within_vpc.id}", "${aws_security_group.allow_etcd_to_within_vpc.id}", "${aws_security_group.allow_flannel_traffic.id}",
	"${aws_security_group.allow_all_outgoing_traffic.id}", "${aws_security_group.allow_incoming_http_and_https.id}"]
	key_name = "kubernetes"
	user_data = "${file("user-data/worker.yml")}"
	private_ip = "10.0.4.5"

	root_block_device {
		volume_type = "gp2"
		volume_size = "20"
		delete_on_termination = true
	}

	tags {
		Name = "kubernetes-worker-a"
	}
}
