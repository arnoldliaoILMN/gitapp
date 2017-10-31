source /variables.txt 
vcfgz=$1
echo project_dir is $project_dir
echo vcfgz is $vcfgz
filename=`basename $vcfgz|sed -e "s/vcf.gz/vcf/"`
new_filename=`echo $filename |sed -e "s/vcf/filtered.vcf/"`
echo filename is $filename
echo new_filename $new_filename

echo looking at where I am and files
pwd
ls /root/gitapp

zcat $vcfgz > $project_dir/$filename
perl /root/gitapp/filter_SM_from_vcf.pl $project_dir/$filename $project_dir/$new_filename

echo looking at project dir

ls $project_dir

echo 

