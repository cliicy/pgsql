#!/bin/bash

cfg_file=./sysbench-cfg/benchmark.cfg
./1_prep_dev.sh ${cfg_file}
./2_initdb.sh   ${cfg_file} 
./3_run.sh      ${cfg_file} 

./dorunwkloads.sh ${cfg_file} 
