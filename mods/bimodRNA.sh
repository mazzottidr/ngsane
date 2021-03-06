#!/bin/bash

# Find novel miRNA by finding genomic regions that do not overlap with known
# annotations (exons, miRNA, ncRNA) but still have a good coverage in RNA seq
# data. 
# author: Denis C. Bauer
# date: Feb.2011

#INPUTS
CONFIG=$1   # location of the NGSANE repository
f=$2          # bam file
FASTA=$3      # reference genome
MIRNA=$4      # all annotated areas in the genome
GENES=$5    # 
CONS=$6
OUT=$7        # output dir

#PROGRAMS
. $CONFIG
. ${NGSANE_BASE}/conf/header.sh
. $CONFIG

# get basename of f
n=${f##*/}
name=${n/.bam/}
GENOME=$(echo $FASTA| sed 's/.fasta/.BEDgenome/' | sed 's/.fa/.BEDgenome/' )
echo ">>>>> identify novel RNAs "
echo ">>>>> startdate "`date`
echo ">>>>> hostname "`hostname`
echo ">>>>> $(basename $0) $CONFIG $f $FASTA $MIRNA $GENES $OUT"

transcrFilter="1"
consFilter="1"
miRBaseFilter="1"


# delete old files

<<EOF

echo "********* bed conversion"
# extract only mapped, (paired) and high quality reads
if [ "$PAIRED" = "1" ]; then echo "PAIRED"; SPEC="-f 0x2"; fi
$SAMTOOLS view -q 10 $SPEC -b $f > $OUT/$name.clean.bam
$BEDTOOLS/bamToBed -i $OUT/$name.clean.bam > $OUT/$name.clean.bed
echo ">>>>> Found "`wc -l $OUT/$name.clean.bed | cut -d " " -f1 `" locations with reads"

echo "********* bed merge window"
# merge the reads to get ones with clear hairpin gap 
$BEDTOOLS/mergeBed -i $OUT/$name.clean.bed -d 20 >  $OUT/$name.clean.merged.bed
echo ">>>>> Found "`wc -l $OUT/$name.clean.merged.bed | cut -d " " -f1 `" locations with reads >30 apart"

echo "********* get coverage"
# get the coverage of these area
$BEDTOOLS/genomeCoverageBed -i $OUT/$name.clean.merged.bed -g $GENOME -d > $OUT/$name.hist


#$SAMTOOLS mpileup $f > $OUT/$name.pileup
#$BEDTOOLS/genomeCoverageBed -ibam $f -g $GENOME -d > $OUT/$name.pileup


echo "********* find out if bimodal"
python picLocs.py $OUT/$name.pileup $OUT/$name.clean.merged.bed $OUT/$name.fastc
python isBimodal.py $OUT/$name.fastc $OUT/$name.bimod.bed >ref

echo ">>>>> Found "`wc -l $OUT/$name.bimod.bed | cut -d " " -f1 `" locations with 10x coverage ( miRBase "`$BEDTOOLS/intersectBed -a $OUT/$name.bimod.bed -b $MIRNA -u | wc -l`")"

echo "********* intersect"
FI=""
if [ -n "$transcrFilter" ]; then
    $BEDTOOLS/subtractBed -a $OUT/$name.bimod.bed -b $GENES -s > $OUT/$name.bimod$FI"T".bed
    FI="T"
    echo ">>>>> "`wc -l $OUT/$name.bimod$FI.bed | cut -d " " -f1 `" pass exon filter ( miRBase "`$BEDTOOLS/intersectBed -a $OUT/$name.bimod$FI.bed -b $MIRNA -u | wc -l`")"
fi

if [ -n "$consFilter" ]; then
    $BEDTOOLS/intersectBed -a $OUT/$name.bimod$FI.bed -b $CONS -u -s > $OUT/$name.bimod$FI"C".bed
    FI=$FI"C"
    echo ">>>>> "`wc -l $OUT/$name.bimod$FI.bed | cut -d " " -f1 `" pass conservation filter ( miRBase "`$BEDTOOLS/intersectBed -a $OUT/$name.bimod$FI.bed -b $MIRNA -u | wc -l`")"
fi

if [ -n "$miRBaseFilter" ]; then
    $BEDTOOLS/intersectBed -a $OUT/$name.bimod$FI.bed -b $MIRNA -v > $OUT/$name.bimod$FI"R".bed
    FI=$FI"R"
    echo ">>>>> "`wc -l $OUT/$name.bimod$FI.bed | cut -d " " -f1 `" are not in miRBase"
fi

FI="TC"

echo "********* extract sequence"
gawk '{OFS="\t"; print $1,$2-60,$3+60,$4}' $OUT/$name.bimod$FI.bed > $OUT/$name.bimod.novel$FI.ext.bed
$BEDTOOLS/fastaFromBed -s -fi $FASTA -bed $OUT/$name.bimod.novel$FI.ext.bed -fo $OUT/$name.bimod.novel$FI.fasta

echo "********* fold miRNA"
if [ ! -e $OUT/pics ]; then mkdir $OUT/pics; else rm -r $OUT/pics/*; fi
cd $OUT/pics
$VIENNA/RNAfold < $OUT/$name.bimod.novel$FI.fasta >$OUT/$name.bimod.novel$FI.fold
for i in $( ls ); do
    mv $i ${i/:/_}
done
cd ../../

EOF

FI="TC"

echo $FI

python countmiRNA.py $OUT/$name.bimod.novel$FI.fold $OUT/$name.bimod.novel$FI"S".bed

FI=$FI"S"

 echo ">>>>> "`wc -l $OUT/$name.bimod.novel$FI.bed | cut -d " " -f1 `" pass structure filter ( miRBase "`$BEDTOOLS/intersectBed -a $OUT/$name.bimod.novel$FI.bed -b $MIRNA -u | wc -l`")"


$BEDTOOLS/intersectBed -a $OUT/$name.bimod.novel$FI.bed -b $MIRNA -v > $OUT/$name.novelmiRNA.bed
echo ">>>>> "`wc -l $OUT/$name.novelmiRNA.bed | cut -d " " -f1 `" are not in miRBase"

echo ">>>>> identify novel RNAs - FINISHED"
echo ">>>>> enddate "`date`
