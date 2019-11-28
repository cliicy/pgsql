#!/bin/bash

pushd /opt/app/benchmark/postgresql/intel3.2t
sh fulldisk-fio_postgre_run-case.sh 
popd

