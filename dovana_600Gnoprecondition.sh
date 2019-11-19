#!/bin/bash

pushd /opt/app/benchmark/postgresql/vanda3.2t

sed -i s/fillfact=75/fillfact=100/ ./sysbench-cfg/benchmark.cfg
sh postgre_run-case.sh


####fillfact75
sleep 10
sed -i s/fillfact=100/fillfact=75/ ./sysbench-cfg/benchmark.cfg
sh postgre_run-case.sh

sh donormal600G.sh
popd


