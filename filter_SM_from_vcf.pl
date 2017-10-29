#!/usr/bin/perl -w
use strict;

if (@ARGV != 2) {
    warn "USAGE: 1) ./run.sh path_to_folder_with_vcf_files path_to_folder_with_filtered_vcf_files\n";
    warn "       2) ./filter_SM_from_vcf.pl original_vcf filtered_vcf\n";
    exit(1);
}


my $vcf_before=$ARGV[0];
my $vcf_after=$ARGV[1];

####### read exac snp into hash #######
my %common_snp;
open(IN, "snp_exac_all_0.05.txt") or die $!;
while (<IN>) {
    chomp;
    my $line=$_;
    if ($line=~/^chromosomeid/) {
        next;
    }
    my @all=split(/\t/,$line);
    if ($all[6] eq "Y") {
        next;
    }
    my $snp_id=$all[0] . "_" . $all[1] . "_" . $all[2] . "_" . $all[3];
    $common_snp{$snp_id}++;
}
close(IN);


open(OUT, ">$vcf_after") or die $!;
open(IN, $vcf_before) or die $!;
while (<IN>) {
    chomp;
    my $line=$_;
    if ($line=~/^#/) {
        print OUT"$line\n";
        next;
    }
    ######## skip variants which are not in coding and splicing region #########
    if ($line!~/stop_gained|stop_lost|splice_acceptor_variant|splice_region_variant|splice_donor_variant|frameshift_variant|inframe_insertion|inframe_deletion|missense_variant|incomplete_terminal_codon_variant|start_lost|initiator_codon/) {
        next;
    }
    my ($chr,$start,$id,$ref,$alt,$col6,$filter,$info,$format,$normal,$tumor)=split(/\t/,$line);
    ######## skip variants without alternative allele #####
    if ($alt eq ".") {
        next;
    }
    if ($alt=~/,/) { ##### multiple alternative allele  #######
        if ($line=~/AF1000G=([0|1]\.?\d*),([0|1]\.?\d*);/) {
            my $freq1=$1;
            my $freq2=$2; ### get allele frequence when there are two alternative allele  ####
            if ($freq1>=0.05&&$freq2>=0.05) {
                next;
            }
        }
        if ($line=~/AF1000G=([0|1]\.?\d*),([0|1]\.?\d*),([0|1]\.?\d*);/) { ### get allele frequence when there are three alternative allele  ####
            my $freq1=$1;
            my $freq2=$2;
            my $freq3=$3;
            if ($freq1>=0.05&&$freq2>=0.05&&$freq3>=0.05) {
                next;
            }
        }
        my @alts=split(/,/,$alt);
        my $flag_variant=0;
        foreach my $oneofalts (@alts)
        {
            my $flag_ad=0;
            my $flag_exac=0;
            if ($line=~/SOMATIC;QSS=/) {
                my @tmp1=split(/[:,]/,$tumor);
                my $ad; ####### alternative allele depth for snp ######
                if ($oneofalts eq "A") {
                    $ad=$tmp1[4];
                }
                elsif($oneofalts eq "C")
                {
                    $ad=$tmp1[6];
                }
                elsif($oneofalts eq "G")
                {
                    $ad=$tmp1[8];
                }
                elsif($oneofalts eq "T")
                {
                    $ad=$tmp1[10];
                }
                if ($ad<=1) {
                    $flag_ad++;
                }
                my $stop=$start+1;
                my $snp_id=$chr . "_" . $start . "_" . $stop . "_" . $oneofalts;
                if (defined $common_snp{$snp_id}) {
                    $flag_exac++;
                }
                if ($flag_ad==0&&$flag_exac==0) {
                    $flag_variant++;
                }
            }
            elsif($line=~/SOMATIC;QSI=/)
            {
                my @tmp1=split(/[:,]/,$tumor);
                my $ad=$tmp1[4]; #### alternative allele depth for indel #######
                if (defined $ad && $ad<=1) {
                    $flag_ad++;
                }
                my $refl=length($ref);
                my $altl=length($oneofalts);
                if ($altl>$refl) {
                    my $alt_str=substr($oneofalts,1);
                    my $snp_id=$chr . "_" . $start . "_" . $start . "_" . $alt_str;
                    if (defined $common_snp{$snp_id}) {
                        $flag_exac++;
                    }   
                }
                else
                {
                    my $str_length=$refl-$altl;
                    my $newstart=$start+1;
                    my $newstop=$newstart+$str_length;
                    my $snp_id=$chr . "_" . $newstart . "_" . $newstop . "_" ."-";
                    if (defined $common_snp{$snp_id}) {
                        $flag_exac++;
                    } 
                }
                if ($flag_ad==0&&$flag_exac==0) {
                    $flag_variant++;
                }
            }
        }
        if ($flag_variant==0) {
            next;
        }    
    }
    else  ##### only one alternative allele ####
    {
        if ($line=~/AF1000G=([0|1]\.?\d*);/) {
            my $freq=$1;
            if ($freq>=0.05) {
                next; ### skip variant when its 1000G frequence > 0.05 ####
            }
        }
        if ($line=~/SOMATIC;QSS=/) {
            my @all=split(/\t/,$line);
            my @tmp1=split(/[:,]/,$all[10]);
            my $ad;
            if ($all[4] eq "A") {
                $ad=$tmp1[4];
            }
            elsif($all[4] eq "C")
            {
                $ad=$tmp1[6];
            }
            elsif($all[4] eq "G")
            {
                $ad=$tmp1[8];
            }
            elsif($all[4] eq "T")
            {
                $ad=$tmp1[10];
            }
            if (defined $ad && $ad<=1) {
                next; ### skip variant when its alternative allele depth <= 1 ####
            }
            my $stop=$all[1]+1;
            my $snp_id=$all[0] . "_" . $all[1] . "_" . $stop . "_" . $all[4];
            if (defined $common_snp{$snp_id}) {
                next; ### skip variant when its exac frequence > 0.05 ####
            }   
        }
        elsif($line=~/SOMATIC;QSI=/)
        {
            my @all=split(/\t/,$line);
            my @tmp1=split(/[:,]/,$all[10]);
            my $ad=$tmp1[4];
            if (defined $ad && $ad<=1) {
                next; ### skip variant when its alternative allele depth <= 1 ####
            }
            my $refl=length($all[3]);
            my $altl=length($all[4]);
            if ($altl>$refl) { ### insertion ###
                my $alt_str=substr($all[4],1);
                my $snp_id=$all[0] . "_" . $all[1] . "_" . $all[1] . "_" . $alt_str;
                if (defined $common_snp{$snp_id}) {
                    next; ### skip variant when its exac frequence > 0.05 ####
                }   
            }
            else #### deletion ####
            {
                my $str_length=$refl-$altl;
                my $newstart=$all[1]+1;
                my $newstop=$newstart+$str_length;
                my $snp_id=$all[0] . "_" . $newstart . "_" . $newstop . "_" ."-";
                if (defined $common_snp{$snp_id}) {
                    next; ### skip variant when its exac frequence > 0.05 ####
                } 
            }
        }
    }
    print OUT"$line\n";
}
close(IN);
close(OUT);



