The script / package is to automatically filter somatic variants from vcf files output from Tumor/Normal app using an unmatched normal. 


** What's included other than this README.txt file:
1. run.sh: A bash wrapper script of filtering all somatic.vcf or somatic.vcf.gz files in a folder. 
2. filter_SM_from_vcf.pl: A perl script which filters somatic variants from somatic.vcf file based on a set of filtering criteria listed under "filter setting" below.
3. snp_exac_all_0.05.txt: ExAC snps which the global frequence >= 0.05.


Filter setting
    General
    - Alt Allele Depth > 1
    
    Population Frequency
    - ExAC ALL < 0.05
    - 1kG ALL < 0.05
    
    Consequence and Impact
    - Stop gained
    - Stop loss
    - Splice donor
    - Frameshift Indels
    - Inframe deletion
    - Inframe insertion
    - Initiator codon (ATG) loss
    - Missense
    - Incomplete terminal codon
    - Splice acceptor
    - Splice region
    

** How to run the script / wrapper for somatic.vcf or somatic.vcf.gz filtering:
1. Copy the package including two scripts and an annotation file into one folder.
2. Download somatic.vcf.gz files from Tumor / Normal app output; Create a folder and save all somatic.vcf or somatic.vcf.gz files under this folder.
3. Execute the wrapper script run.sh.
e.g.
[user@linux_machine]$ ./run.sh path_to_folder_with_somatic.vcf_files path_to_folder_with_filtered_somatic.vcf_files


** What is the output of the script:
1. Filtered somatic.vcf or somatic.vcf.gz files are saved in the folder specified by the second parameter of run.sh. Filtered files would keep the same names as the original ones.
!!Warning: Any file in the output folder with the same file name as the original somatic.vcf or somatic.vcf.gz file will be overwritten. A new output folder is suggested. 
2. log file saved in ./log


Messages from an example run:
[user@linux_machine]$ ./run.sh dir_in dir_out
Output folder dir_out exist! Any file with the same file name as the original somatic.vcf or somatic.vcf.gz file will be overwritten!
Do you wish to overwrite (y or n)? y
Processing starts 2017-10-23_10:51:40
Start filtering file test_sample1.somatic.vcf.gz...
Uncompressing file test_sample1.somatic.vcf.gz...
Re-compressing file test_sample1.somatic.vcf.gz after filtering...
Filtering file test_sample1.somatic.vcf.gz is done
Start filtering file test_sample2.somatic.vcf.gz...
Uncompressing file test_sample2.somatic.vcf.gz...
Re-compressing file test_sample2.somatic.vcf.gz after filtering...
Filtering file test_sample2.somatic.vcf.gz is done
Processing ends 2017-10-23_10:53:22
Filtered files are under folder dir_out
somatic.vcf / somatic.vcf.gz filtering is complete


