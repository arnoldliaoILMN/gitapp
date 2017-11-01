vcfgz=$1
project_dir=/data/scratch/parsed
echo project_dir is $project_dir
echo vcfgz is $vcfgz
filename=`basename $vcfgz|sed -e "s/vcf.gz/filtered.vcf/"`
#new_filename=`echo $filename |sed -e "s/vcf/filtered.vcf/"`
echo filename is $filename
#echo new_filename $new_filename

cd /root/gitapp
pwd
zcat $vcfgz |perl /root/gitapp/filter_SM_from_vcf.pl - $project_dir/$filename

echo looking at project_dir $project_dir
ls $project_dir


