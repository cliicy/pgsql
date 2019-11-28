#!/bin/bash

cfg_file=./sysbench-cfg/benchmark.cfg
source ${cfg_file}
sed -i s/fillfact=75/fillfact=100/ ${cfg_file}
####fillfact100 VandaFF100  (~5TB data set) 6.4TB-disk-capacity
./1_prep_dev.sh ${cfg_file}
if [ "${app_datadir}" != "" ] && [ ! -e ${app_datadir} ];
then
sudo mkdir -p ${app_datadir};
fi
sudo chown -R `whoami`:`whoami` ${app_datadir}
cp -r ${mnt_point_data}bk/* ${mnt_point_data}
echo " will start postgreSQL server " >${app_dbglog}
chmod -R 0700 ${app_datadir}
./start.sh ${cfg_file}
sleep 5

# echo "will start postgreSQL server " > /opt/data/vandabk/postgresql-10.10/pgq.log
#./start.sh ${cfg_file}
#./3_run.sh      ${cfg_file} 

./dorunwkloads.sh ${cfg_file} 

