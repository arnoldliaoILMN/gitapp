#!/bin/bash
source /variables.txt
echo from git run.sh variables are
cat /variables.txt
echo hi
echo it is 945am
echo project_dir is $project_dir

vcf=`find /data/input -name "*.vcf.gz"`
echo found vcf ${vcf[@]}
echo listing root gitapp
ls /root
ls /root/gitapp

ls /root/gitapp/filter_SM_from_vcf.pl
cd /root/gitapp
# try this find . -name \*.pdf | xargs --max-args=1 --max-procs=$cpus  pdf2ps
# from https://stackoverflow.com/questions/38160/parallelize-bash-script-with-maximum-number-of-processes
find /data/input -name "*.vcf.gz" | xargs --max-args=1 --max-procs=16 /root/gitapp/wrap.sh 
<<COMMENT
for i in ${vcf[@]}
do 
  filename=`basename $i`
  new_filename=`echo $filename |sed -e "s/vcf/filtered.vcf/"`
  #echo perl /root/gitapp/filter_SM_from_vcf.pl $i $project_dir/$new_filename
  zcat $i | perl /root/gitapp/filter_SM_from_vcf.pl - $project_dir/$new_filename
done
COMMENT

echo done

