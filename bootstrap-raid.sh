#!/bin/bash
export INSTANCE_ID=$(curl http://169.254.169.254/latest/user-data)
export PATH=/sbin:/bin:/usr/sbin:/usr/bin

set -e

if [ -b /dev/md0 ]; then
  aws --region eu-west-2 ssm get-parameter --name ${INSTANCE_ID} --with-decryption --query 'Parameter.Value' --output text | cryptsetup luksOpen /dev/md0 secure
  mount -o nodev,noatime,inode64,allocsize=16m /dev/mapper/secure /gpdb
else
  mdadm --create /dev/md0 --level=0 --raid-devices=$(echo /dev/xvd[b-z] | wc -w) $(echo /dev/xvd[b-z])
  aws --region eu-west-2 ssm put-parameter --name ${INSTANCE_ID} --value "$(uuidgen)" --overwrite --type "SecureString"
  aws --region eu-west-2 ssm get-parameter --name ${INSTANCE_ID} --with-decryption --query 'Parameter.Value' --output text | cryptsetup -y --cipher=aes-cbc-essiv:sha256 luksFormat /dev/md0
  aws --region eu-west-2 ssm get-parameter --name ${INSTANCE_ID} --with-decryption --query 'Parameter.Value' --output text | cryptsetup luksOpen /dev/md0 secure
  mkfs.xfs /dev/mapper/secure
  mount -o nodev,noatime,inode64,allocsize=16m /dev/mapper/secure /gpdb
  tar -C / -xzvf /home/centos/md0.tgz
fi


