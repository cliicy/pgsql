#!/bin/bash

sed -i s/tpcc_scale_size=1800/tpcc_scale_size=700/ ./sysbench-cfg/benchmark.cfg

sed -i s/fillfact=75/fillfact=100/ ./sysbench-cfg/benchmark.cfg
./fulldisk_precond_1_prep_dev.sh ./sysbench-cfg/benchmark.cfg 

pushd fio
sh ./fulldisk_precond.sh
rm -rf /opt/data/intel/fio/*
popd

./2_initdb.sh   ./sysbench-cfg/benchmark.cfg
sh ./run_tpcc.sh sysbench-cfg/benchmark.cfg



####fillfact75
sleep 10
sed -i s/fillfact=100/fillfact=75/ ./sysbench-cfg/benchmark.cfg
./fulldisk_precond_1_prep_dev.sh ./sysbench-cfg/benchmark.cfg

pushd fio
sh ./fulldisk_precond.sh
rm -rf /opt/data/intel/fio/*
popd

./2_initdb.sh   ./sysbench-cfg/benchmark.cfg
sh ./run_tpcc.sh sysbench-cfg/benchmark.cfg

