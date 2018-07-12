data "aws_ami" "segment_2" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "dq-gpdb-base*",
    ]
  }

  owners = [
    "self",
  ]
}

resource "aws_instance" "segment_2" {
  ami                  = "${data.aws_ami.segment_2.id}"
  instance_type        = "d2.xlarge"
  key_name             = "gp_secondary"
  placement_group      = "${aws_placement_group.greenplum.id}"
  iam_instance_profile = "${element(aws_iam_instance_profile.instance_profile.*.id, 3)}"
  user_data            = "instance_store_secondary_3"
  monitoring           = true

  tags {
    Name = "segment-2-${local.naming_suffix}"
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
    network_interface_id = "${aws_network_interface.segment_2_0.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.segment_2_1.id}"
  }

  network_interface {
    device_index         = 2
    network_interface_id = "${aws_network_interface.segment_2_2.id}"
  }

  network_interface {
    device_index         = 3
    network_interface_id = "${aws_network_interface.segment_2_3.id}"
  }
}

resource "aws_network_interface" "segment_2_0" {
  subnet_id = "${aws_subnet.subnets.0.id}"

  private_ips = [
    "10.1.30.9",
  ]

  security_groups = [
    "${aws_security_group.segment_sg.id}",
  ]

  depends_on = [
    "aws_subnet.subnets",
  ]
}

resource "aws_network_interface" "segment_2_1" {
  subnet_id = "${aws_subnet.subnets.1.id}"

  private_ips = [
    "10.1.31.159",
  ]

  security_groups = [
    "${aws_security_group.segment_sg.id}",
  ]

  depends_on = [
    "aws_subnet.subnets",
  ]
}

resource "aws_network_interface" "segment_2_2" {
  subnet_id = "${aws_subnet.subnets.2.id}"

  private_ips = [
    "10.1.32.164",
  ]

  security_groups = [
    "${aws_security_group.segment_sg.id}",
  ]

  depends_on = [
    "aws_subnet.subnets",
  ]
}

resource "aws_network_interface" "segment_2_3" {
  subnet_id = "${aws_subnet.subnets.3.id}"

  private_ips = [
    "10.1.33.14",
  ]

  security_groups = [
    "${aws_security_group.segment_sg.id}",
  ]

  depends_on = [
    "aws_subnet.subnets",
  ]
}
