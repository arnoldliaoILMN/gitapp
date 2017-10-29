#!/bin/bash
source /var.conf
echo hi
echo 10:33pm
echo finding genomes
find /genomes -name "*"
echo project_dir is $project_dir
for i in ` find /data/input "*.vcf*"; 
do 
  filename=`basename $i|sed -e "s/vcf/filtered.vcf/"`
  perl /gitapp/filter_SM_from_vcf.pl $i $project_dir/$filename
done
