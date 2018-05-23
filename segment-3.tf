data "aws_ami" "segment_3" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "gp-segment-host-3*",
    ]
  }

  owners = [
    "self",
  ]
}

resource "aws_instance" "segment_3" {
  ami                  = "${data.aws_ami.segment_3.id}"
  instance_type        = "d2.2xlarge"
  key_name             = "gp_secondary"
  placement_group      = "${aws_placement_group.greenplum.id}"
  iam_instance_profile = "${element(aws_iam_instance_profile.instance_profile.*.id, 4)}"
  user_data            = "instance_store_4"
  monitoring           = true

  tags {
    Name = "segment-3-${local.naming_suffix}"
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

  ephemeral_block_device {
    virtual_name = "ephemeral3"
    device_name  = "/dev/sde"
  }

  ephemeral_block_device {
    virtual_name = "ephemeral4"
    device_name  = "/dev/sdf"
  }

  ephemeral_block_device {
    virtual_name = "ephemeral5"
    device_name  = "/dev/sdg"
  }

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.segment_3_0.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.segment_3_1.id}"
  }

  network_interface {
    device_index         = 2
    network_interface_id = "${aws_network_interface.segment_3_2.id}"
  }

  network_interface {
    device_index         = 3
    network_interface_id = "${aws_network_interface.segment_3_3.id}"
  }
}

resource "aws_network_interface" "segment_3_0" {
  subnet_id = "${aws_subnet.subnets.0.id}"

  private_ips = [
    "10.1.30.143",
  ]

  security_groups = [
    "${aws_security_group.segment_sg.id}",
  ]

  depends_on = [
    "aws_subnet.subnets",
  ]
}

resource "aws_network_interface" "segment_3_1" {
  subnet_id = "${aws_subnet.subnets.1.id}"

  private_ips = [
    "10.1.31.168",
  ]

  security_groups = [
    "${aws_security_group.segment_sg.id}",
  ]

  depends_on = [
    "aws_subnet.subnets",
  ]
}

resource "aws_network_interface" "segment_3_2" {
  subnet_id = "${aws_subnet.subnets.2.id}"

  private_ips = [
    "10.1.32.221",
  ]

  security_groups = [
    "${aws_security_group.segment_sg.id}",
  ]

  depends_on = [
    "aws_subnet.subnets",
  ]
}

resource "aws_network_interface" "segment_3_3" {
  subnet_id = "${aws_subnet.subnets.3.id}"

  private_ips = [
    "10.1.33.246",
  ]

  security_groups = [
    "${aws_security_group.segment_sg.id}",
  ]

  depends_on = [
    "aws_subnet.subnets",
  ]
}
