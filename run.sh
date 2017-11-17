#!/bin/bash
# we need to alter the "Internal File Separater" due to some spaces in BSSH file system
# ie subfolder like "Somatic Variants"
IFS=$(echo -en "\n\b")
# project_dir where results are uploaded are in /variables.txt created by /run.py so we need to source it
# we use /run.py because all the input variables are stored in /data/input/AppSession.json file which is json
source /variables.txt

echo in run.sh project_dir is $project_dir

# input vcf.gz on BSSH are in /data/input, so we do a search and put it in an array
vcf=`find /data/input -name "*somatic.vcf.gz"`
echo found vcf ${vcf[@]}

# we already cloned gitapp in the docker image python script /run.py
# we need to run wrap.sh in /root/gitapp
cd /root/gitapp
chmod 777 /root/gitapp/wrap.sh 
# try this find . -name \*.pdf | xargs --max-args=1 --max-procs=$cpus  pdf2ps
# from https://stackoverflow.com/questions/38160/parallelize-bash-script-with-maximum-number-of-processes
# We will store filtered vcf in /data/scratch/parsed and copy it later to $project_dir
# due to space in BSSH, we needed to use -d '\n' as space delimiter for xargs
mkdir -p /data/scratch/parsed
mkdir -p /data/scratch/SV
#find /data/input -name "*somatic.vcf.gz" | xargs -d '\n' --max-args=1 --max-procs=16 /root/gitapp/wrap.sh 
find /data/input -name "*somatic.SV.vcf.gz*" | xargs -d '\n' --max-args=1 -I '{}' --max-procs=16 cp /data/scratch/SV 
# now we run whatever command is in txtbox from the input form
bash /txtbox.sh
#mv /data/scratch/parsed $project_dir
mv /data/scratch/SV $project_dir
echo done run.sh

