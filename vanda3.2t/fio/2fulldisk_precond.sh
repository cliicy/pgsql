#!/bin/bash

dev_list=("sfdv0n1")
vendor_list=("vanda")
mkfs_opt="-t xfs -f"
mnt_opt=" "
mntpnt_base=/opt/data


date -Iseconds >> size.txt
echo "2precondition starts ..." >> size.txt
df -h /dev/sfdv0n1 >> size.txt

fio jobs/precondition.fio

df -h /dev/sfdv0n1 >> size.txt
echo "2precondition completed ..." >> size.txt
date -Iseconds >> size.txt
