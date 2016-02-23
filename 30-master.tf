# Todo probably drop this because i should interact w it over https
resource "aws_security_group" "kubernetes-master-a" {
	name = "kubernetes-master-a"
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	ingress {
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["10.0.0.0/8"]
	}
}

# Todo probably drop this.
resource "aws_security_group" "allow_all_incoming_traffic_from_local_network" {
	name = "allow_all_incoming_traffic_from_local_network"
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	ingress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["10.0.0.0/8"]
	}
}

resource "aws_instance" "kubernetes-master-a" {
	ami = "${var.coreos-ami}"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.kubernetes-public-subnet-a.id}"
	security_groups = ["${aws_security_group.allow_ssh_from_within_vpc.id}", "${aws_security_group.allow_etcd_to_within_vpc.id}", "${aws_security_group.allow_all_outgoing_traffic.id}", "${aws_security_group.allow_flannel_traffic.id}",  "${aws_security_group.allow_all_incoming_traffic_from_local_network.id}",  "${aws_security_group.allow_incoming_http_and_https.id}",
	"${aws_security_group.kubernetes-master-a.id}"]
	associate_public_ip_address = true
	key_name = "kubernetes"
	user_data = "${file("user-data/master.yml")}"
	private_ip = "10.0.0.4"

	root_block_device {
		volume_type = "gp2"
		volume_size = "20"
		delete_on_termination = true
	}

	tags {
		Name = "kubernetes-master-a"
	}
}

resource "aws_instance" "kubernetes-master-b" {
	ami = "${var.coreos-ami}"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.kubernetes-public-subnet-b.id}"
	security_groups = ["${aws_security_group.allow_ssh_from_within_vpc.id}", "${aws_security_group.allow_etcd_to_within_vpc.id}", "${aws_security_group.allow_all_outgoing_traffic.id}", "${aws_security_group.allow_flannel_traffic.id}",  "${aws_security_group.allow_all_incoming_traffic_from_local_network.id}",  "${aws_security_group.allow_incoming_http_and_https.id}",
	"${aws_security_group.kubernetes-master-a.id}"]
	associate_public_ip_address = true
	key_name = "kubernetes"
	user_data = "${file("user-data/master.yml")}"
	private_ip = "10.0.1.4"

	root_block_device {
		volume_type = "gp2"
		volume_size = "20"
		delete_on_termination = true
	}

	tags {
		Name = "kubernetes-master-b"
	}
}

resource "aws_security_group" "kubernetes-master-elb" {
	name = "kubernetes-master-elb"
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["10.0.0.0/8"]
	}
}

resource "aws_security_group" "kubernetes-api-server-elb" {
	name = "kubernetes-api-server-elb"
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["10.0.0.0/8"]
	}
}

# todo maybe change this to kubernetes-api-elb for clarity
resource "aws_elb" "kubernetes-master-elb" {
	name = "kubernetes-master-elb"
	subnets = ["${aws_subnet.kubernetes-public-subnet-a.id}", "${aws_subnet.kubernetes-public-subnet-b.id}", "${aws_subnet.kubernetes-public-subnet-c.id}"]
	security_groups = ["${aws_security_group.kubernetes-master-elb.id}"]
	instances = ["${aws_instance.kubernetes-master-a.id}", "${aws_instance.kubernetes-master-b.id}"]
	cross_zone_load_balancing = true

	listener {
		instance_port = 443
		instance_protocol = "tcp"
		lb_port = 443
		lb_protocol = "tcp"
	}

	# todo add health check
	/*health_check {
		healthy_threshold = 2
		unhealthy_threshold = 2
		timeout = 3
		target = "HTTP:8080/healthz"
		interval = 5
	}*/
}

resource "aws_elb" "kubernetes-api-server-elb" {
	name = "kubernetes-api-server-elb"
	subnets = ["${aws_subnet.kubernetes-public-subnet-a.id}", "${aws_subnet.kubernetes-public-subnet-b.id}", "${aws_subnet.kubernetes-public-subnet-c.id}"]
	security_groups = ["${aws_security_group.kubernetes-api-server-elb.id}"]
	instances = ["${aws_instance.kubernetes-master-a.id}", "${aws_instance.kubernetes-master-b.id}"]
	cross_zone_load_balancing = true

	listener {
		instance_port = 443
		instance_protocol = "tcp"
		lb_port = 443
		lb_protocol = "tcp"
	}

	# todo add health check
	/*health_check {
		healthy_threshold = 2
		unhealthy_threshold = 2
		timeout = 3
		target = "HTTP:8080/healthz"
		interval = 5
	}*/
}

output "Kubernetes API ELB hostname" {
	value = "${aws_elb.kubernetes-api-server-elb.dns_name}"
}
