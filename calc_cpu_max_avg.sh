#!/bin/bash


##########################################################
#                 Script to calculate CPU max and avg    #
#                     Author ~ Kishan M                  #
##########################################################

sardir=/var/log/sa
cd $sardir
d=$1
var=0
max=0
if [[ $# -eq 0 ]]
then
    echo "Provide arguments for number of days in d format"
    :
fi
if [[ $d -gt 30 ]]
then
    echo "Provide number of days for report less than 31"
else
for cpu in `ls -lrt $sardir|grep 'sa'|grep -v 'sar'|tail -$d|awk '{print $NF}'`;
do
    high=`sar -f $cpu|awk '{print $NF}'|grep -Eo "[0-9]+\.[0-9]+"|awk '{print 100 - $1}'|sort -nr|head -1`
if [[ `echo "$high > $max"|bc` -eq 1 ]]
then
    max=$high
fi
avgx=`sar -f $cpu|awk '{print $NF}'|grep -Eo "[0-9]+\.[0-9]+"|awk '{sum+=$1;} END{ if ( NR > 0 );{print 100-(sum/NR)};}'`
avgy=`echo "$var + $avgx"|bc`
var=`echo "$var + $avgx"|bc`
done
res=`echo "$var / $d"|bc`
echo "*************************************"
echo "average cpu = $res || max cpu = $max"
echo "*************************************"
fi