resource "aws_security_group" "allow_ssh_from_the_internet" {
	name = "allow_ssh_from_the_internet"
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "allow_ssh_to_within_vpc" {
	name = "allow_ssh_to_within_vpc"
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	egress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "allow_traffic_from_the_internet_for_prometheus" {
	name = "allow_traffic_from_the_internet_for_prometheus"
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	ingress {
		from_port = 9090
		to_port = 9090
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "allow_ssh_from_within_vpc" {
	name = "allow_ssh_from_within_vpc"
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["10.0.0.0/8"]
	}
}

resource "aws_security_group" "allow_all_outgoing_traffic" {
	name = "allow_all_outgoing_traffic"
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_security_group" "allow_etcd_from_within_vpc" {
	name = "allow_etcd_from_within_vpc"
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	ingress {
		from_port = 2379
		to_port = 2380
		protocol = "tcp"
		cidr_blocks = ["10.0.0.0/8"]
	}
}

resource "aws_security_group" "allow_etcd_to_within_vpc" {
	name = "allow_etcd_to_within_vpc"
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	egress {
		from_port = 2379
		to_port = 2380
		protocol = "tcp"
		cidr_blocks = ["10.0.0.0/8"]
	}
}

resource "aws_security_group" "allow_incoming_http_and_https" {
	name = "allow_incoming_http_and_https"
	vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "allow_flannel_traffic" {
  name = "allow_kubernetes_flannel"
  description = "allow_kubernetes_flannel"
  vpc_id = "${aws_vpc.kubernetes-vpc.id}"

	# cadvisor
  /*ingress {
    from_port = 4194
    to_port = 4194
    protocol = "tcp"
    self = true
  }*/

  ingress {
    from_port = 8285
    to_port = 8285
    protocol = "udp"
		cidr_blocks = ["10.0.0.0/8"]
  }

	#worker node kubelet health check port
  /*ingress {
    from_port = 10250
    to_port = 10250
    protocol = "tcp"
    self = "true"
  }*/

  egress {
    from_port = 8285
    to_port = 8285
    protocol = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }
}
