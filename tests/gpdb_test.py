# pylint: disable=missing-docstring, line-too-long, protected-access, E1101, C0202, E0602, W0109
import unittest
from runner import Runner


class TestE2E(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.snippet = """

            provider "aws" {
              region = "eu-west-2"
              skip_credentials_validation = true
              skip_get_ec2_platforms = true
            }

            module "gpdb" {
              source = "./mymodule"

              providers = {
                aws = "aws"
              }

                appsvpc_id                    = "12345"
                internal_dashboard_cidr_block = "10.1.12.0/24"
                external_dashboard_cidr_block = "10.1.14.0/24"
                data_ingest_cidr_block        = "10.1.6.0/24"
                data_pipe_apps_cidr_block     = "10.1.8.0/24"
                data_feeds_cidr_block         = "10.1.4.0/24"
                opssubnet_cidr_block          = "10.2.0.0/24"
                peering_cidr_block            = "1.1.1.0/24"
                az                            = "eu-west-2a"
                naming_suffix                 = "apps-preprod-dq"
                route_table_id                = "12345"
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_az_dq_subnet_0(self):
        self.assertEqual(self.result['gpdb']["aws_subnet.subnets.0"]["availability_zone"], "eu-west-2a")

    def test_az_dq_subnet_1(self):
        self.assertEqual(self.result['gpdb']["aws_subnet.subnets.1"]["availability_zone"], "eu-west-2a")

    def test_az_dq_subnet_2(self):
        self.assertEqual(self.result['gpdb']["aws_subnet.subnets.2"]["availability_zone"], "eu-west-2a")

    def test_az_dq_subnet_3(self):
        self.assertEqual(self.result['gpdb']["aws_subnet.subnets.3"]["availability_zone"], "eu-west-2a")

    def test_name_suffix_master_sg(self):
        self.assertEqual(self.result['gpdb']["aws_security_group.master_sg"]["tags.Name"],
                         "sg-master-secondary-gpdb-apps-preprod-dq")

    def test_name_prefix_segment_sg(self):
        self.assertEqual(self.result['gpdb']["aws_security_group.segment_sg"]["tags.Name"],
                         "sg-segment-secondary-gpdb-apps-preprod-dq")

    def test_name_prefix_subnet0(self):
        self.assertEqual(self.result['gpdb']["aws_subnet.subnets.0"]["tags.Name"],
                         "subnet-secondary-gpdb-apps-preprod-dq")

    def test_name_prefix_subnet1(self):
        self.assertEqual(self.result['gpdb']["aws_subnet.subnets.1"]["tags.Name"],
                         "subnet-secondary-gpdb-apps-preprod-dq")

    def test_name_prefix_subnet2(self):
        self.assertEqual(self.result['gpdb']["aws_subnet.subnets.2"]["tags.Name"],
                         "subnet-secondary-gpdb-apps-preprod-dq")

    def test_name_prefix_subnet3(self):
        self.assertEqual(self.result['gpdb']["aws_subnet.subnets.3"]["tags.Name"],
                         "subnet-secondary-gpdb-apps-preprod-dq")

    def test_name_prefix_master2(self):
        self.assertEqual(self.result['gpdb']["aws_instance.master_2"]["tags.Name"],
                         "master-2-secondary-gpdb-apps-preprod-dq")

    def test_name_prefix_master1(self):
        self.assertEqual(self.result['gpdb']["aws_instance.master_1"]["tags.Name"],
                         "master-1-secondary-gpdb-apps-preprod-dq")

    def test_name_prefix_segment1(self):
        self.assertEqual(self.result['gpdb']["aws_instance.segment_1"]["tags.Name"],
                         "segment-1-secondary-gpdb-apps-preprod-dq")

    def test_name_prefix_segment2(self):
        self.assertEqual(self.result['gpdb']["aws_instance.segment_2"]["tags.Name"],
                         "segment-2-secondary-gpdb-apps-preprod-dq")

    def test_name_prefix_segment3(self):
        self.assertEqual(self.result['gpdb']["aws_instance.segment_3"]["tags.Name"],
                         "segment-3-secondary-gpdb-apps-preprod-dq")


if __name__ == '__main__':
    unittest.main()
