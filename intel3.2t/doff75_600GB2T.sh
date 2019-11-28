#!/bin/bash

# re-use vada's prepared and vacuumed data to save time
#mnt_opt=" -o noatime,nodiratime"
#mnt_point_vanda_data="/opt/data/vanda"
#sudo umount /dev/sfdv0n1
#sudo mkfs -t xfs -f /dev/sfdv0n1
#sudo mount /dev/sfdv0n1 ${mnt_opt} ${mnt_point_vanda_data}_2TBK
#cp -r ${mnt_point_vanda_data}bk/postgresql-10.10 ${mnt_point_vanda_data}_2TBK/


sed -i s/run_time=3600/run_time=1800/ ./sysbench-cfg/benchmark.cfg
sed -i s/fillfact=100/fillfact=75/ ./sysbench-cfg/benchmark.cfg
./fulldisk_precond_1_prep_dev.sh ./sysbench-cfg/benchmark.cfg 

pushd fio
sh ./fulldisk_precond.sh
rm -rf /opt/data/intel/fio/*
popd

./2_initdb.sh   ./sysbench-cfg/benchmark.cfg
./3_run.sh      ./sysbench-cfg/benchmark.cfg

./do2runwkloads.sh ./sysbench-cfg/benchmark.cfg

#do 2TB ff75
sed -i s/table_size=1000000000/table_size=300000000/ ./sysbench-cfg/benchmark.cfg
sed -i s/fillfact=100/fillfact=75/ ./sysbench-cfg/benchmark.cfg
./fulldisk_precond_1_prep_dev.sh ./sysbench-cfg/benchmark.cfg 

pushd fio
sh ./fulldisk_precond.sh
rm -rf /opt/data/intel/fio/*
popd

./2_initdb.sh   ./sysbench-cfg/benchmark.cfg
./3_run.sh      ./sysbench-cfg/benchmark.cfg

./do2runwkloads.sh ./sysbench-cfg/benchmark.cfg

####fillfact75
#sleep 10
#sed -i s/fillfact=100/fillfact=75/ ./sysbench-cfg/benchmark.cfg
#./fulldisk_precond_1_prep_dev.sh ./sysbench-cfg/benchmark.cfg
#./2_initdb.sh   ./sysbench-cfg/benchmark.cfg
#./3_run.sh      ./sysbench-cfg/benchmark.cfg

#./do2runwkloads.sh ./sysbench-cfg/benchmark.cfg

sh dovana_600Gnoprecondition.sh
