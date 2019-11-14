#!/bin/bash


sed -i s/fillfact=100/fillfact=75/ ./sysbench-cfg/benchmark.cfg
./fulldisk_precond_1_prep_dev.sh ./sysbench-cfg/benchmark.cfg 

pushd fio
sh ./fulldisk_precond.sh
rm -rf /opt/data/vanda/fio/*
popd

./2_initdb.sh   ./sysbench-cfg/benchmark.cfg
./3_run.sh      ./sysbench-cfg/benchmark.cfg

./do2runwkloads.sh ./sysbench-cfg/benchmark.cfg

sh doTPCC.sh
