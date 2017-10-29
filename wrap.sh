$vcfgz=$1
filename=`basename $vcfgz|sed -e "s/vcf.gz/filtered.vcf/"`
zcat $vcfgz | perl /gitapp/filter_SM_from_vcf.pl - $project_dir/$filename

