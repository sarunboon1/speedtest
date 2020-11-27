#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/cgn_test/speedtestcsv
user="admin"
pass="comnet@123"
now=`date +"%Y-%m-%d"`
timestamp=`date +"%r"`
profilearray=(BRK_707_public CMI_701_1000M HYI_711_public HYI_PE1_711_1000M KKN_705_1000M KKN_705_public NSW_703_1000M NSW_703_public SDI_712_1000M SDL_712_public)
#profilearray=(BRK_707_public)

getprofile(){
        profile=`sshpass -p $pass ssh -o StrictHostKeyChecking=no $user@10.67.121.115 "ip address print"`
        profile1=`echo "$profile" | awk '{print $5}'`
        profile2=`echo "$profile1" | awk 'END{print}'`
        echo $profile2
}
testspeed()
{
        speedtest -s 13871 -f csv | ts '"%Y-%m-%d %H:%M:%S",' > /home/cgn_test/speedtestcsv/${profilefinal}/${profilefinal}_${now}.csv
        sleep 60
        speedtest -f csv | ts '"%Y-%m-%d %H:%M:%S",' >> /home/cgn_test/speedtestcsv/${profilefinal}/${profilefinal}_${now}.csv
        sleep 60
        sed -i "s/$/,\"$profilefinal\"/" /home/cgn_test/speedtestcsv/${profilefinal}/${profilefinal}_${now}.csv
        awk -F "\",\"|\", \"" 'BEGIN{a=8;b=1000000;OFS="\",\"";} {$7*=a;$7/=b;$8*=a;$8/=b;$9/=b;$10/=b;print $0}' < /home/cgn_test/speedtestcsv/${profilefinal}/${profilefinal}_${now}.csv >> /home/cgn_test/speedtestcsv/${profilefinal}/${profilefinal}_result_${now}.csv
}

profilefinal=$(getprofile)
testspeed
sshpass -p $pass ssh -o StrictHostKeyChecking=no $user@10.67.121.115 "interface pppoe-client;disable 0"
sleep 10
for i in "${profilearray[@]}"
do
        echo "Array is at  "$i
        sshpass -p $pass ssh -o StrictHostKeyChecking=no $user@10.67.121.115 "interface pppoe-client;enable " $i
        sleep 10
        profilefinal=$(getprofile)
        testspeed
        sshpass -p $pass ssh -o StrictHostKeyChecking=no $user@10.67.121.115 "interface pppoe-client;disable " $i
        sleep 10
done
sshpass -p $pass ssh -o StrictHostKeyChecking=no $user@10.67.121.115 "interface pppoe-client;enable 0"
sleep 10


awk -F "\",\"|\", \"" 'NR==1{print $7,$8,$9,$10} NR>1{print $7,$8,$9,$10}'


awk -F "\",\"|\", \"" 'NR==1{print $7","$8","$9","$10} NR>1{print $7","$8","$9","$10}' data_result.csv