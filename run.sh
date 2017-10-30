#!/bin/bash
source /variables.txt
echo from git run.sh variables are
cat /variables.txt
echo hi
echo it is 945am
echo project_dir is $project_dir

vcf=`find /data/input -name "*.vcf"`
echo found vcf ${vcf[@]}
echo listing root gitapp
ls /root
ls /root/gitapp

ls /root/gitapp/filter_SM_from_vcf.pl
cd /root/gitapp
for i in ${vcf[@]}
do 
  filename=`basename $i`
  new_filename=`echo $filename |sed -e "s/vcf/filtered.vcf/"`
  echo perl /root/gitapp/filter_SM_from_vcf.pl $i $project_dir/$new_filename
  perl /root/gitapp/filter_SM_from_vcf.pl $i $project_dir/$new_filename
done

echo done

