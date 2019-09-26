#!/bin/sh
#PlateTo10XFastq ../fastqFolder unfiltered_barcodes.tsv
#This script is designed by krzysztof polański and Peng He to convert paired-end plate-based ATAC-seq fastq reads into cellranger-compatible format
#unfiltered_barcodes.tsv should be a cell barcode file from a cellranger-ATAC output folder

count=1
for FID in $1/*R1.fastq
        do
                BARCODE=`head -n $count $2 | tail -n 1`
                sed "s/\(@.*\)/\1 1:N:0:CCTACCAT+$BARCODE/" $FID | gzip -c >> Undetermined_S0_L001_R1_001.fastq.gz
                grep "@" $FID | sed "s/$/ 1:N:0:CCTACCAT+$BARCODE\nCCTACCAT\n+\nZZZZZZZZ/" | gzip -c >> Undetermined_S0_L001_I1_001.fastq.gz
                FID=$(sed 's/R1/R2/g' <<< $FID)
                sed "s/\(@.*\)/\1 2:N:0:CCTACCAT+$BARCODE/" $FID | gzip -c >> Undetermined_S0_L001_R3_001.fastq.gz
                grep "@" $FID | sed "s/$/ 2:N:0:CCTACCAT+$BARCODE\n$BARCODE\n+\nZZZZZZZZZZZZZZZZ/" | gzip -c >> Undetermined_S0_L001_R2_001.fastq.gz 
                (( count++ ))
        done
