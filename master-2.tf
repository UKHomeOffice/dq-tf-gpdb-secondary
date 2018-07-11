data "aws_ami" "master_2" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "dq-gpdb-master*",
    ]
  }

  owners = [
    "self",
  ]
}

resource "aws_instance" "master_2" {
  ami                  = "${data.aws_ami.master_2.id}"
  instance_type        = "d2.xlarge"
  key_name             = "gp_secondary"
  placement_group      = "${aws_placement_group.greenplum.id}"
  iam_instance_profile = "${element(aws_iam_instance_profile.instance_profile.*.id, 1)}"
  user_data            = "instance_store_secondary_1"
  monitoring           = true

  tags {
    Name = "master-2-${local.naming_suffix}"
  }

  ephemeral_block_device {
    virtual_name = "ephemeral0"
    device_name  = "/dev/sdb"
  }

  ephemeral_block_device {
    virtual_name = "ephemeral1"
    device_name  = "/dev/sdc"
  }

  ephemeral_block_device {
    virtual_name = "ephemeral2"
    device_name  = "/dev/sdd"
  }

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.master_2_0.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.master_2_1.id}"
  }

  network_interface {
    device_index         = 2
    network_interface_id = "${aws_network_interface.master_2_2.id}"
  }

  network_interface {
    device_index         = 3
    network_interface_id = "${aws_network_interface.master_2_3.id}"
  }

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      "ami",
    ]
  }
}

resource "aws_network_interface" "master_2_0" {
  subnet_id = "${aws_subnet.subnets.0.id}"

  private_ips = [
    "10.1.30.4",
  ]

  security_groups = [
    "${aws_security_group.master_sg.id}",
  ]

  depends_on = [
    "aws_subnet.subnets",
  ]
}

resource "aws_network_interface" "master_2_1" {
  subnet_id = "${aws_subnet.subnets.1.id}"

  private_ips = [
    "10.1.31.234",
  ]

  security_groups = [
    "${aws_security_group.master_sg.id}",
  ]

  depends_on = [
    "aws_subnet.subnets",
  ]
}

resource "aws_network_interface" "master_2_2" {
  subnet_id = "${aws_subnet.subnets.2.id}"

  private_ips = [
    "10.1.32.183",
  ]

  security_groups = [
    "${aws_security_group.master_sg.id}",
  ]

  depends_on = [
    "aws_subnet.subnets",
  ]
}

resource "aws_network_interface" "master_2_3" {
  subnet_id = "${aws_subnet.subnets.3.id}"

  private_ips = [
    "10.1.33.86",
  ]

  security_groups = [
    "${aws_security_group.master_sg.id}",
  ]

  depends_on = [
    "aws_subnet.subnets",
  ]
}
