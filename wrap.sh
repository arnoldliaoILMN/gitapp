source /variables.txt 
vcfgz=$1
echo project_dir is $project_dir
echo vcfgz is $vcfgz
filename=`basename $vcfgz|sed -e "s/vcf.gz/filtered.vcf/"`
echo filename is $filename

echo looking at where I am and files
pwd
ls /root/gitapp

zcat $vcfgz | perl /root/gitapp/filter_SM_from_vcf.pl - $project_dir/$filename

