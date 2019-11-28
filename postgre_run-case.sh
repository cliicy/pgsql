#!/bin/bash

cfg_file=./sysbench-cfg/benchmark.cfg

#sed -i s/fillfact=75/fillfact=100/ ${cfg_file}
#pushd /home/tcn/software/vanda/rc_3.0.4.0-r49228/bin_pkg/centos7.5/sfx_qual_suite
#sudo ./initcard.sh --blk --cl --capacity=6400
#popd
####fillfact100 VandaFF100  (~5TB data set) 6.4TB-disk-capacity
./1_prep_dev.sh ${cfg_file}
./2_initdb.sh   ${cfg_file} 
./3_run.sh      ${cfg_file} 

./dorunwkloads.sh ${cfg_file} 

####fillfact75 Vanda FF75 (~5TB data set) 8TB-disk-capacity
#sleep 600
#sed -i s/fillfact=100/fillfact=75/ ${cfg_file}
#pushd /home/tcn/software/vanda/rc_3.0.4.0-r49228/bin_pkg/centos7.5/sfx_qual_suite
#sudo ./initcard.sh --blk --cl --capacity=8000
#popd

#./1_prep_dev.sh ${cfg_file} 
#./2_initdb.sh   ${cfg_file}
#./3_run.sh      ${cfg_file}

#./dorunwkloads.sh ${cfg_file}
