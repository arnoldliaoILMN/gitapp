#!/bin/bash
source /variables.txt
echo from git run.sh variables are
cat /variables.txt

echo in run.sh project_dir is $project_dir

vcf=`find /data/input -name "*.vcf.gz"`
echo found vcf ${vcf[@]}
echo listing root gitapp
ls /root/gitapp

cd /root/gitapp
chmod 777 /root/gitapp/wrap.sh 
# try this find . -name \*.pdf | xargs --max-args=1 --max-procs=$cpus  pdf2ps
# from https://stackoverflow.com/questions/38160/parallelize-bash-script-with-maximum-number-of-processes
mkdir -p /data/scratch/parsed
find /data/input -name "*somatic.vcf.gz" | xargs --max-args=1 --max-procs=16 /root/gitapp/wrap.sh 
bash /txtbox.sh
mv /data/scratch/parsed $project_dir
echo done

