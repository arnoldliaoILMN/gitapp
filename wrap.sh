vcfgz=$1
IFS=$(echo -en "\n\b")
temp_dir=/data/scratch/parsed
#echo temp_dir is $temp_dir
#echo vcfgz is $vcfgz
filename=`basename $vcfgz|sed -e "s/vcf.gz/${RANDOM}_filtered.vcf/"`
#echo new_filename $new_filename

cd /root/gitapp
zcat $vcfgz |perl /root/gitapp/filter_SM_from_vcf.pl - $temp_dir/$filename
# debug below.  comment out when done
#echo looking at project_dir $project_dir
#ls $project_dir
## need to include code here to bgzip and tabix vcf files
# for i in *vcf; do echo working on $i;/illumina/thirdparty/tabix/tabix-0.2.6/bgzip $i; 
#/illumina/thirdparty/tabix/tabix-0.2.6/tabix -f -p vcf ${i}.gz; done
# tabix in /opt/tabix-0.2.6
/opt/tabix-0.2.6/bgzip $temp_dir/$filename
/opt/tabix-0.2.6/tabix -f -p vcf $temp_dir/${filename}.gz



    
