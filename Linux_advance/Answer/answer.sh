#! /bin/bash 

iyy=2001
WORKDIR="/home/onishi/mydocument/Linux_advance/Answer"
SRCDIR="/home/onishi/mydocument/Linux_advance"
while [ $iyy -le 2009 ]
do
 if [ ! -d Test ]; then 
   mkdir -p "$WORKDIR/Test"
 fi
 
 cp $SRCDIR/$iyy/test_${iyy}.txt  $WORKDIR/Test
 iyy=$(( iyy + 1))

done
