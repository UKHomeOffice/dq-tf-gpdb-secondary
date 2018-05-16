# dq-tf-gpdb-secondary

This Terraform module has one private subnet and deploys a set of EC2 instance representing SQL master and segment instances. Allowing inbound TCP traffic on port 5432, 22, 9000, 28090, 1025-65535. Allowing inbound UDP traffic on port 1025-65535 and ICMP on port 8-65535.


## Connectivity

| In/Out        | Type           | Protocol | FromPort| To Port | Description |
| ------------- |:-------------| :-----:| :-----:|:-----:| -----|
|INBOUND | SSH | TCP | 22 | 22 | Master DB instance |
|INBOUND | PostgreSQL | TCP | 5432 | 5432 | Master DB instance |
|INBOUND | Custom | TCP | 28090 | 28090 | Master DB instance |
|INBOUND | Custom | TCP | 9000 | 9000 | Master DB instance  |
|INBOUND | Custom | TCP | 1025 | 65535 | Segment DB instance  |
|INBOUND | Custom | UDP | 1025 | 65535 | Segment DB instance  |
|INBOUND | Custom | ICMP | 8 | -1 | Segment DB instance  |

## Content overview

This repo controls the deployment of an application module.

It consists of the following core elements:

### main.tf

This file has the basic components for EC2 instances.
- Private subnet and route table association
- Two EC2 instances using the connectivity tester module as master nodes
- Five EC2 instances using the connectivity tester module as segment nodes
- Security groups for the master and segment instances

### outputs.tf

Various data outputs for other modules/consumers.

### variables.tf

Input data for resources within this repo.

### tests/gpdb_test.py

Code and resource tester with mock data. It can be expanded by adding further definitions to the unit.


## User guide

### Prepare your local environment

This project currently depends on:

* drone v0.5+dev
* terraform v0.11.1+
* terragrunt v0.13.21+
* python v3.6.3+

Please ensure that you have the correct versions installed (it is not currently tested against the latest version of Drone)

### How to run/deploy

To run tests using the [tf testsuite](https://github.com/UKHomeOffice/dq-tf-testsuite):
```shell
drone exec --repo.trusted
```
To launch:
```shell
terragrunt plan
terragrunt apply
```

## FAQs

### The remote state isn't updating, what do I do?

If the CI process appears to be stuck with a stale `tf state` then run the following command to force a refresh:

```
terragrunt refresh
```
If the CI process is still failing after a refresh look for errors about items no longer available in AWS - say something that was deleted manually via the AWS console or CLI.
To explicitly delete the stale resource from TF state use the following command below. *Note:*```terragrunt state rm``` will not delete the resource from AWS it will unlink it from state only.

```shell
terragrunt state rm aws_resource_name
```
