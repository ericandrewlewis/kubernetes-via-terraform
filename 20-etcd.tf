resource "aws_instance" "kubernetes-etcd-a" {
	ami = "${var.coreos-ami}"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.kubernetes-private-subnet-a.id}"
	security_groups = ["${aws_security_group.allow_ssh_from_within_vpc.id}", "${aws_security_group.allow_etcd_from_within_vpc.id}", "${aws_security_group.allow_all_outgoing_traffic.id}"]
	key_name = "kubernetes"
	user_data = "${file("user-data/etcd-new-cluster.yml")}"
	private_ip = "10.0.3.4"

	root_block_device {
		volume_type = "gp2"
		volume_size = "10"
		delete_on_termination = true
	}

	tags {
		Name = "kubernetes-etcd-a"
	}
}

resource "aws_instance" "kubernetes-etcd-b" {
	ami = "${var.coreos-ami}"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.kubernetes-private-subnet-b.id}"
	security_groups = ["${aws_security_group.allow_ssh_from_within_vpc.id}", "${aws_security_group.allow_etcd_from_within_vpc.id}", "${aws_security_group.allow_all_outgoing_traffic.id}"]
	key_name = "kubernetes"
	user_data = "${file("user-data/etcd-new-cluster.yml")}"
	private_ip = "10.0.4.4"

	root_block_device {
		volume_type = "gp2"
		volume_size = "10"
		delete_on_termination = true
	}

	tags {
		Name = "kubernetes-etcd-b"
	}
}

resource "aws_instance" "kubernetes-etcd-c" {
	ami = "${var.coreos-ami}"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.kubernetes-private-subnet-c.id}"
	security_groups = ["${aws_security_group.allow_ssh_from_within_vpc.id}", "${aws_security_group.allow_etcd_from_within_vpc.id}", "${aws_security_group.allow_all_outgoing_traffic.id}"]
	key_name = "kubernetes"
	user_data = "${file("user-data/etcd-new-cluster.yml")}"
	private_ip = "10.0.5.4"

	root_block_device {
		volume_type = "gp2"
		volume_size = "10"
		delete_on_termination = true
	}

	tags {
		Name = "kubernetes-etcd-c"
	}
}
