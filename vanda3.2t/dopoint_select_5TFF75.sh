
cfg_file=./sysbench-cfg/benchmark.cfg
source ${cfg_file}
sed -i s/fillfact=100/fillfact=75/ ${cfg_file}

./1_prep_dev.sh ${cfg_file}
if [ "${app_datadir}" != "" ] && [ ! -e ${app_datadir} ];
then
sudo mkdir -p ${app_datadir};
fi
sudo chown -R `whoami`:`whoami` ${app_datadir}
unzip -d ${mnt_point_data} /opt/data/vandabk/postgresql-10.10.zip

pushd /opt/app/benchmark/postgresql/lib
sh extractlz4.sh /opt/data/vandabk/postgresql-10.10/base/16384/ /opt/data/vanda/postgresql-10.10/base/16384
popd

echo " will start postgreSQL server " >${app_dbglog}
chmod -R 0700 ${app_datadir}
./start.sh ${cfg_file}
sleep 5
./3_run.sh      ${cfg_file}


