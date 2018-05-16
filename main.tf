locals {
  naming_suffix  = "secondary-gpdb-${var.naming_suffix}"
  master_count   = 2
  segment_count  = 3
  instance_count = "${local.master_count + local.segment_count}"
}

resource "aws_subnet" "subnets" {
  vpc_id                  = "${var.appsvpc_id}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"
  count                   = 4
  cidr_block              = "10.1.${count.index + 30}.0/24"

  tags {
    Name = "subnet-${local.naming_suffix}"
  }
}

resource "aws_route_table_association" "dq_database_rt_association" {
  subnet_id      = "${element(aws_subnet.subnets.*.id, count.index)}"
  route_table_id = "${var.route_table_id}"
  count          = 4
}

resource "random_string" "aws_placement_group" {
  length  = 8
  special = false
}

resource "aws_placement_group" "greenplum" {
  name     = "greenplum-secondary-${random_string.aws_placement_group.result}"
  strategy = "cluster"
}

resource "aws_security_group" "master_sg" {
  vpc_id = "${var.appsvpc_id}"

  tags {
    Name = "sg-master-${local.naming_suffix}"
  }

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = [
      "${var.internal_dashboard_cidr_block}",
      "${var.external_dashboard_cidr_block}",
      "${var.data_ingest_cidr_block}",
      "${var.data_pipe_apps_cidr_block}",
      "${var.data_feeds_cidr_block}",
      "${var.opssubnet_cidr_block}",
      "${var.peering_cidr_block}",
      "${aws_subnet.subnets.*.cidr_block}",
    ]
  }

  ingress {
    from_port = 9000
    to_port   = 9000
    protocol  = "tcp"

    cidr_blocks = [
      "${var.opssubnet_cidr_block}",
      "${aws_subnet.subnets.*.cidr_block}",
      "${var.peering_cidr_block}",
    ]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "${var.opssubnet_cidr_block}",
      "${var.peering_cidr_block}",
      "${var.data_pipe_apps_cidr_block}",
      "${var.data_ingest_cidr_block}",
      "${aws_subnet.subnets.*.cidr_block}",
    ]
  }

  ingress {
    from_port = 28090
    to_port   = 28090
    protocol  = "tcp"

    cidr_blocks = [
      "${var.opssubnet_cidr_block}",
      "${var.peering_cidr_block}",
      "${aws_subnet.subnets.*.cidr_block}",
    ]
  }

  ingress {
    from_port = 1025
    to_port   = 65535
    protocol  = "tcp"

    cidr_blocks = [
      "${aws_subnet.subnets.*.cidr_block}",
    ]
  }

  ingress {
    from_port = 1025
    to_port   = 65535
    protocol  = "udp"

    cidr_blocks = [
      "${aws_subnet.subnets.*.cidr_block}",
    ]
  }

  ingress {
    from_port = 8
    to_port   = -1
    protocol  = "icmp"

    cidr_blocks = [
      "${aws_subnet.subnets.*.cidr_block}",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group" "segment_sg" {
  vpc_id = "${var.appsvpc_id}"

  tags {
    Name = "sg-segment-${local.naming_suffix}"
  }

  ingress {
    from_port = 1025
    to_port   = 65535
    protocol  = "tcp"

    cidr_blocks = [
      "${aws_subnet.subnets.*.cidr_block}",
    ]
  }

  ingress {
    from_port = 1025
    to_port   = 65535
    protocol  = "udp"

    cidr_blocks = [
      "${aws_subnet.subnets.*.cidr_block}",
    ]
  }

  ingress {
    from_port = 8
    to_port   = -1
    protocol  = "icmp"

    cidr_blocks = [
      "${aws_subnet.subnets.*.cidr_block}",
    ]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "${aws_subnet.subnets.*.cidr_block}",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
