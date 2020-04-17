#!/bin/bash

pbs_version=19.1.1
filename=pbspro_$pbs_version.centos7.zip
if [ ! -f "$filename" ];then
    wget -q https://github.com/PBSPro/pbspro/releases/download/v$pbs_version/$filename
    unzip $filename
fi
