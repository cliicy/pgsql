#!/bin/bash

cfg_file=./sysbench-cfg/benchmark.cfg
dev_name=sfdv0n1
disk=/dev/${dev_name}
./stop.sh ${cfg_file}
sudo umount ${disk}

####fillfact75 Vanda FF75 (~5TB data set) 8TB-disk-capacity
sed -i s/fillfact=100/fillfact=75/ ${cfg_file}
pushd /home/tcn/software/vanda/rc_3.0.4.0-r49228/bin_pkg/centos7.5/sfx_qual_suite
sudo ./initcard.sh --blk --cl --capacity=8000

for i in {1..1200};
do
    serinfo=`cat /sys/block/${dev_name}/serial`
    if [ "${serinfo}" != "" ]; then echo started with ${serinfo}; sleep 5; break; fi
    echo "waiting for initcard finish"
    sleep 3
done

popd

./1_prep_dev.sh ${cfg_file} 
./2_initdb.sh   ${cfg_file}
./3_run.sh      ${cfg_file}

./dorunwkloads.sh ${cfg_file}
