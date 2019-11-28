#!/bin/bash

cfg_file=$1
if [ "$1" = "" ]; then echo -e "Usage:\n\t2_initdb.sh cfg_file"; exit 1; fi
if [ ! -e ${cfg_file} ]; then echo "can't find configuration file [${cfg_file}]", exit 2; fi
source ${cfg_file}

if [ "${cp_data}" == "1" ]; then
# cleanup Intel/Micron to save Vanda-data-after-Vacuumed-loaded
sudo umount /dev/nvme0n1
sudo nvme format /dev/nvme0n1
sudo mkfs -t ${fs_type} -f /dev/nvme0n1

if [ "${mnt_point_data}bk" != "" ] && [ ! -e ${mnt_point_data}bk ];
then
        sudo mkdir -p ${mnt_point_data}bk;
fi

sudo mount /dev/nvme0n1 ${mnt_opt} ${mnt_point_data}bk
sudo chown -R `whoami`:`whoami` ${mnt_point_data}bk
bkdataset=${mnt_point_data}bk/${app_version}.tar.lz4
#cp -r ${mnt_point_data}/* ${mnt_point_data}bk/
pushd ${mnt_point_data}
tar -jcvf ${bkdataset} ./*
popd
echo "done copy ${mnt_point_data}'s prepared data to nvme to backup"
fi

source ./output.dir
wllast=`echo ${workload_set} | awk '{print $NF}'`
runningwl=oltp_point_select
echo "workload_set=${wllast} rworkload_set=${rworkload_set}" >> ${output_dir}/wl.opts

lastwl=`echo ${rworkload_set} | awk '{print $NF}'`
for workload in ${rworkload_set};
do
    sed -i s/workload_set=${runningwl}/workload_set=${workload}/ ${cfg_file}
    cat ${cfg_file} | grep workload_set
    ./3_run.sh ${cfg_file}
    runningwl=${workload}

    sleep 10
    if [ "${workload}" != "${lastwl}" ]; then
         # preparing the vacuumed-loaded data from the other disk
        ./1_prep_dev.sh ${cfg_file} 
        if [ "${app_datadir}" != "" ] && [ ! -e ${app_datadir} ];
        then
            sudo mkdir -p ${app_datadir};
        fi
        sudo chown -R `whoami`:`whoami` ${app_datadir}
#        cp -r ${mnt_point_data}bk/* ${mnt_point_data}
        tar -jxvf ${bkdataset} -C ${mnt_point_data}
        echo "do ${workload} and will start postgreSQL server " >${app_dbglog}
        chmod -R 0700 ${app_datadir}
        ./start.sh ${cfg_file}
        sleep 5
    fi
done

sed -i s/workload_set=${runningwl}/workload_set=prepare/ ${cfg_file} 

source ../lib/bench-lib
info=`cat ${output_dir}/ben.info | head -1`
gen_benchinfo_postgres ${info} 


