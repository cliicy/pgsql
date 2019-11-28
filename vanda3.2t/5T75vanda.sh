#!/bin/bash

cfg_file=./sysbench-cfg/benchmark.cfg
source ./output.dir
./3_run.sh      ${cfg_file} 
sed -i s/workload_set=oltp_read_only/workload_set=prepare/ ${cfg_file} 
sh postgre_run-case.sh
