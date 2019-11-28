#!/bin/bash

cfg_file=./sysbench-cfg/benchmark.cfg

####fillfact100 VandaFF100  (~5TB data set) 6.4TB-disk-capacity
#./1_prep_dev.sh ${cfg_file}
source ${cfg_file}
if [ "${app_datadir}" != "" ] && [ ! -e ${app_datadir} ];
    then
        sudo mkdir -p ${app_datadir};
fi
sudo chown -R `whoami`:`whoami` ${app_datadir}

cp -r ${mnt_point_data}bk/* ${mnt_point_data}
chmod -R 0700 ${app_datadir}
./start.sh ${cfg_file}

./3_run.sh      ${cfg_file} 

./dorunwkloads.sh ${cfg_file} 

####fillfact75 Vanda FF75 (~5TB data set) 8TB-disk-capacity
sh do5Tleftcases_vanda8T.sh
