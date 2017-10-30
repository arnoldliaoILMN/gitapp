#!/bin/bash
source /variables.txt
echo from git run.sh variables are
cat /variables.txt
echo hi
echo it is 945am
echo project_dir is $project_dir

vcf=`find /data/input "*.vcf"`
echo found vcf ${vcf[@]}
echo listing root gitapp
ls /root
ls /root/gitapp


for i in ${vcf[@]}
do 
  filename=`basename $i`
  new_filename=`echo $filename |sed -e "s/vcf/filtered.vcf/"`
  perl /root/gitapp/filter_SM_from_vcf.pl $i $project_dir/$filename
done
