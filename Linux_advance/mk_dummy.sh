#! /bin/bash 

iyy=2001
WORKDIR=$(pwd)
while [ $iyy -le 2009 ]
do
 cd $WORKDIR/$iyy
 echo "This is ${iyy} file " >  test_${iyy}.txt
 iyy=$(( iyy + 1))

done
