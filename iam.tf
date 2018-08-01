resource "aws_iam_role" "iam_role" {
  name_prefix = "gp_instance_store_secondary"
  count       = "${local.instance_count}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com",
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
  name_prefix = "gp_instance_store_secondary"
  role        = "${element(aws_iam_role.iam_role.*.name, count.index)}"
  count       = "${local.instance_count}"
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name_prefix = "gp_instance_store_secondary"
  role        = "${element(aws_iam_role.iam_role.*.id, count.index)}"
  count       = "${local.instance_count}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:PutParameter",
                "ssm:GetParameter"
            ],
            "Resource": [
              "arn:aws:ssm:eu-west-2:*:parameter/GP_LOCAL_BACKUP",
              "arn:aws:ssm:eu-west-2:*:parameter/GP_MASTER1_S3_BACKUP",
              "arn:aws:ssm:eu-west-2:*:parameter/GP_SG1_S3_BACKUP",
              "arn:aws:ssm:eu-west-2:*:parameter/GP_SG2_S3_BACKUP",
              "arn:aws:ssm:eu-west-2:*:parameter/GP_SG3_S3_BACKUP",
              "arn:aws:ssm:eu-west-2:*:parameter/GP_SG4_S3_BACKUP",
              "arn:aws:ssm:eu-west-2:*:parameter/GP_SG5_S3_BACKUP",
              "arn:aws:ssm:eu-west-2:*:parameter/GP_SG6_S3_BACKUP",
              "arn:aws:ssm:eu-west-2:*:parameter/${aws_instance.master_1.id}",
              "arn:aws:ssm:eu-west-2:*:parameter/${aws_instance.master_2.id}",
              "arn:aws:ssm:eu-west-2:*:parameter/${aws_instance.segment_1.id}",
              "arn:aws:ssm:eu-west-2:*:parameter/${aws_instance.segment_2.id}",
              "arn:aws:ssm:eu-west-2:*:parameter/${aws_instance.segment_3.id}",
              "arn:aws:ssm:eu-west-2:*:parameter/${aws_instance.segment_4.id}",
              "arn:aws:ssm:eu-west-2:*:parameter/${aws_instance.segment_5.id}",
              "arn:aws:ssm:eu-west-2:*:parameter/${aws_instance.segment_6.id}",
              "arn:aws:ssm:eu-west-2:*:parameter/addomainjoin",
            ]
        },
        {
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": "${var.archive_bucket}"
        },
        {
            "Effect": "Allow",
            "Action": [
              "s3:PutObject",
              "s3:GetObject"
            ],
            "Resource": "${var.archive_bucket}/*"
        },
        {
            "Effect": "Allow",
            "Action": [
              "kms:Encrypt",
              "kms:Decrypt",
              "kms:ReEncrypt*",
              "kms:GenerateDataKey*",
              "kms:DescribeKey"
              ],
              "Resource": "${var.apps_buckets_kms_key}"
        }
    ]
}
EOF
}
