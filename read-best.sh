#!/bin/bash

users=`docker exec gtypist find /home/ -name '.gtypist'|awk -F '/' '{print $3}'`

echo "users,date,exam,wpm,adj_wpm,error" > a.txt
for u in ${users}; do
 score=`docker exec gtypist find /home/${u} -name '.gtypist' -exec grep  '_S_R_L28'  {} \;|sort -n -k9 -r|head -1`
 DATE=`echo $score|awk '{print $1,$2,$3,$4,$5}'`
 LESSON=`echo $score|awk '{print $6}'`
 SCORE=`echo $score|awk '{if (!$8) {print 0","0","0} else {print $8","$9","$10}}'`
 echo $u,$DATE,$LESSON,$SCORE >> a.txt
done

#jq -r -s -R -f filter.jq a.txt  > /var/www/html/sp/data.json
#jq -r -s -R -f filter.jq a.txt  > data.json
#jq -r -s -R -f filter.jq a.txt|jq 'sort_by(-.adj_wpm)'  
#jq -r -s -R -f filter.jq a.txt  

#jq -r -s -R -f filter.jq a.txt|jq 'sort_by(-.adj_wpm)'  > data.json
jq -r -s -R -f filter.jq a.txt|jq 'sort_by(-.adj_wpm)' 
