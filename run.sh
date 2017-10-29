#!/bin/bash
source /variables.txt
echo hi
echo it is 2pm

echo project_dir is $project_dir
for i in ` find /data/input "*.vcf*"; 
do 
  filename=`basename $i|sed -e "s/vcf/filtered.vcf/"`
  perl /root/gitapp/filter_SM_from_vcf.pl $i $project_dir/$filename
done
