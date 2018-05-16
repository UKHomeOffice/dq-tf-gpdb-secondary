output "dq_database_subnet_id_secondary" {
  value = "${aws_subnet.subnets.0.id}"
}

output "master_sg_id_secondary" {
  value = "${aws_security_group.master_sg.id}"
}

output "segment_sg_id_secondary" {
  value = "${aws_security_group.segment_sg.id}"
}

output "dq_database_cidr_block_secondary" {
  value = ["${aws_subnet.subnets.*.cidr_block}"]
}

output "iam_roles" {
  value = ["${aws_iam_role.iam_role.*.id}"]
}
