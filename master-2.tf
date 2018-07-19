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
  instance_type        = "i3.xlarge"
  key_name             = "gp_secondary"
  placement_group      = "${aws_placement_group.greenplum.id}"
  iam_instance_profile = "${element(aws_iam_instance_profile.instance_profile.*.id, 1)}"
  monitoring           = true

  user_data = <<EOF
#!/bin/bash

if [ ! -f /bin/aws ]; then
    curl https://bootstrap.pypa.io/get-pip.py | python
    pip install awscli
fi

export DOMAIN_JOIN=`aws --region eu-west-2 ssm get-parameter --name addomainjoin --query 'Parameter.Value' --output text --with-decryption`
yum -y install sssd realmd krb5-workstation adcli samba-common-tools expect
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl reload sshd
chkconfig sssd on
systemctl start sssd.service
echo "%Domain\\ Admins@dq.homeoffice.gov.uk ALL=(ALL:ALL) ALL" >>  /etc/sudoers
expect -c "spawn realm join -U domain.join@dq.homeoffice.gov.uk DQ.HOMEOFFICE.GOV.UK; expect \"*?assword for domain.join@DQ.HOMEOFFICE.GOV.UK:*\"; send -- \"$DOMAIN_JOIN\r\" ; expect eof"
systemctl restart sssd.service
EOF

  tags {
    Name = "master-2-${local.naming_suffix}"
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
