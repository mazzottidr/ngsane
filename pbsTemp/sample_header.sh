##############################################################
# System info
##############################################################
SUBMISSIONSYSTEM="PBS"                                  #or SGE
DMGET="YES"                                #empty string for No
TMP=/data/flush/bau04c/TMP                             #TMP dir
. /etc/profile.d/modules.sh   #soucre the module on child nodes

##############################################################
# PROGRAM PATHS
##############################################################
QSUB=$DATASTORE/SeqAna/apps/prod/seqaninf/pbsTemp/pbsTemp.sh
BINQSUB=$DATASTORE/SeqAna/apps/prod/seqaninf/pbsTemp/jobsubmission.sh

#Additional programs not available as module
PATH_SAMTOOLS=$DATASTORE/SeqAna/apps/prod/samtools_svn
PATH_IGVTOOLS=$DATASTORE/SeqAna/apps/prod/IGVTools/
#PATH_PICARD=$DATASTORE/SeqAna/apps/prod/Picard_svn/dist/
PATH_PICARD=$DATASTORE/SeqAna/apps/prod/picard-tools-1.89/
PATH_SAMSTAT=$DATASTORE/SeqAna/apps/dev/samstat/src/

#Fastqc
MODULE_FASTQC="jdk fastqc/0.10.1"
PATH_FASTQC=$DATASTORE/SeqAna/apps/prod/FastQC/
MODULE_LATEX="imagemagick/6.7.5"
PATH_LATEX="/data/flush/apps/texlive/2012/bin/x86_64-linux/"

#Trim adapter with CUTADAPT
MODULE_CUTADAPT=""
PATH_CUTADAPT="$DATASTORE/SeqAna/apps/prod/cutadapt-1.2.1/bin/"

#BWA
MODULE_BWA="jdk bwa/0.6.1 R/2.15.1 samtools/0.1.18 imagemagick/6.7.5"
#PATH_BWA=$DATASTORE/SeqAna/apps/prod/bwa_git:$PATH_SAMTOOLS:$PATH_IGVTOOLS:$PATH_PICARD:$PATH_SAMSTAT
PATH_BWA=$PATH_IGVTOOLS:$PATH_PICARD:$PATH_SAMSTAT

#Bowtie2
MODULE_BOWTIETWO="jdk R/2.15.1 bowtie/2.0.5 samtools/0.1.18 imagemagick/6.7.5"
PATH_BOWTIETWO=$PATH_IGVTOOLS:$PATH_PICARD:$PATH_SAMSTAT

#Snp calling with GATK
PATH_GATKHOME=$DATASTORE/SeqAna/apps/prod/gatk_git
#GATKHOME=$DATASTORE/SeqAna/apps/dev/gatk_git
PATH_GATKJAR=$PATH_GATKHOME/dist/
MODULE_GATKSNP="jdk R/2.15.1"
PATH_GATKSNP=$PATH_GATKHOME:$PATH_GATKJAR:$PATH_IGVTOOLS

# Tophat and cufflinks
MODULE_TOPHATCUFF="boost jdk python R/2.15.1 bowtie/2.0.5 tophat/2.0.4b cufflinks/2.0.2 samtools/0.1.18 imagemagick/6.7.5"
PATH_TOPHATCUFF=$PATH_IGVTOOLS:$PATH_PICARD:$PATH_SAMSTAT

#this gzip waits for the file to migrate completly before unzipping it
#GZIP=$DATASTORE/SeqAna/apps/prod/mygzip/
RSCRIPT=/apps/R/2.14.1/bin/Rscript # module load R
FASTXTK="/clusterdata/hiseq_apps/bin/devel/fastx_toolkit/"
VCFTOOLS="/clusterdata/hiseq_apps/bin/freeze001/VCFtools_0.1.3.2/bin"
SAMUTILS="/clusterdata/hiseq_apps/bin/freeze001/tabix-0.2.3"
BEDTOOLS=$DATASTORE/SeqAna/apps/prod/bedtools/bin/
ANNOVAR="/clusterdata/hiseq_apps/bin/freeze001/annovar"


RRBSMAP="/clusterdata/hiseq_apps/bin/devel/rrbsmap-1.5/rrbsmap"
MACS="/clusterdata/hiseq_apps/bin/devel/MACS_git"
PEAKFINDER="/clusterdata/hiseq_apps/bin/devel/vancouvershortr_svn/"

#
# Need to use 2.0.0b6 or higher because of --sam-RG
# only cherax has this install so far
#BOWTIETWO="$DATASTORE/SeqAna/apps/prod/bowtie2-2.0.0-beta6/" <- buggy
#BOWTIETWO="/apps/bowtie/2.0.0b6/"
#BOWTIETWO="/datastore/cmis/bau04c/SeqAna/apps/prod/bowtie2-2.0.0-beta7-source"
#BOWTIETWO=bowtie/2.0.0b5


VIENNA="/clusterdata/hiseq_apps/bin/devel/ViennaRNA/bin/"
UNAFOLD="/clusterdata/hiseq_apps/bin/devel/unafold/bin/"

##############################################################
# Task Names
##############################################################
TASKFASTQC="fastQC"
TASKBWA="bwa"
TASKBOWTIE="bowtie"
TASKRCA="reCalAln"
TASKMERGE="merged"
TASKVAR="variant"
TASKDINC="dindelC"
TASKDINS="dindelS"
TASKDIN="dindel"
TASKSNP="snp"
TASKIND="indel"
TASKDOWN="downsample"
TASKDOC="coverage"
TASKDIFFEXP="diffexp"
TASKTOPHAT="tophat"
TASKCUFF="cufflinks"
TASKCUFFDIFF="cuffdiff"
TASKRRBS="rrbs"
TASKMACS="macs"
TASKANNOVAR="annovar"
TASKBAMANN="bamann"
TASKSAMVAR="samvar"
TASKCUTADAPT="cutadapt"

#Fileabb
READONE="read1"
READTWO="read2"
FASTQ="fastq.gz"
ALN="aln" # aligned 
ASD="asd" # aligned sorted duplicate-removed
ASR="asdrr" # aligned sorted duplicate-removed raligned reacalibrated


##############################################################
# Resources
##############################################################
# On Cherax
#FASTQC
WALLTIME_FASTQC=10:00:00
MEMORY_FASTQC=20
CPU_FASTQC=16
NODES_FASTQC="nodes=2:ppn=8"
#BWA
WALLTIME_BWA=50:00:00
MEMORY_BWA=50
CPU_BWA=32
NODES_BWA="nodes=4:ppn=8"
#Botie
WALLTIME_BOWTIE=10:00:00
MEMORY_BOWTIE=60
CPU_BOWTIE=8
NODES_BOWTIE="nodes=1:ppn=8"
#TOPHAT
WALLTIME_TOPHAT=60:00:00
MEMORY_TOPHAT=50
CPU_TOPHAT=8
NODES_TOPHAT="nodes=1:ppn=8"
#Recal
WALLTIME_RECAL=60:00:00
MEMORY_RECAL=50
CPU_RECAL=8
NODES_RECAL="nodes=1:ppn=8" 
#COVERAGE
WALLTIME_GATKDOC=50:00:00
MEMORY_GATKDOC=50
CPU_GATKDOC=1
NODES_GATKDOC="nodes=1:ppn=1"
#ANNOTATING BAM
WALLTIME_BAMANN=5:00:00
MEMORY_BAMANN=32
CPU_BAMANN=1
NODES_BAMANN="nodes=1:ppn=1"
#GATK VARCALL
WALLTIME_VAR=100:00:00
MEMORY_VAR=20
CPU_VAR=1
NODES_VAR="nodes=1:ppn=1"
#SAMTOOLS VARCALL
WALLTIME_SAMVAR=40:00:00
MEMORY_SAMVAR=40
CPU_SAMVAR=1
NODES_SAMVAR="nodes=1:ppn=1"
#CUTADAPT
WALLTIME_CUTADAPT=4:00:00
MEMORY_CUTADAPT=40
CPU_CUTADAPT=1
NODES_CUTADAPT="nodes=1:ppn=1"