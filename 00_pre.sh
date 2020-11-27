#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/cgn_test/speedtestcsv
user="admin"
pass="comnet@123"
now=`date +"%Y-%m-%d"`
profilearray=(BRK_707_1000M BRK_707_public CMI_701_1000M HYI_711_public HYI_PE1_711_1000M KKN_705_1000M KKN_705_public NSW_703_1000M NSW_703_public SDI_712_1000M SDL_712_public)
##################################################################################
for i in "${profilearray[@]}"
do
	echo """Date/time","server name","server id","latency","jitter","packet loss","download Mbps","upload Mbps","download bytes","upload bytes","share url","account" >> /home/cgn_test/speedtestcsv/${i}/${i}_result_${now}.csv
done
##################################################################################
