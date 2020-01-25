#!/bin/bash

export GPG_TTY=$(tty)
export LC_TIME=en_US.UTF-8

. $HOME/.profile

PASS=10

cd /home/sk/repo/certificate

./read-best.sh > data.json

rm -f NAME.txt
node app.js > NAME.txt

if [ -e bg2.pdf ]; then
 rm bg2.pdf
fi

cp bg2.pdf.template bg2.pdf

while IFS='' read -r line || [[ -n "$line" ]]; do
 NAME=`echo $line|awk '{print $1}'`
 SURNAME=`echo $line|awk '{print $2}'`
 WPM=`echo $line|awk '{print $3}'`
 ADJWPM=`echo $line|awk '{print $4}'`
 ERR=`echo $line|awk '{print $5}'`

 DAYn=`echo $line|awk '{print $6}'`
 MONTH=`echo $line|awk '{print $7}'`
 DAY=`echo $line|awk '{print $8}'`
 TIME=`echo $line|awk '{print $9}'`
 YEAR=`echo $line|awk '{print $10}'`
 DATE=`date --date="$DAYn $MONTH  $DAY $TIME +07 $YEAR" +"%d %B %Y"`
 DATEISSUE=`date +"%d %B %Y"`

if [ -e out-${NAME}.tex ]; then
 rm  -f out-${NAME}.tex
fi


if (( $(echo "$ADJWPM > $PASS" |bc -l) )); then
 sed "s/#NAME#/$NAME/g" cert.tex.template  \
    |sed "s/#SURNAME#/${SURNAME}/g" \
    |sed "s/#WPM#/${WPM}/g"\
    |sed "s/#ACC#/${ERR}/g" \
    |sed "s/#DATEISSUE#/${DATEISSUE}/g"  \
    |sed "s/#DATETIME#/${DATE}/g" > out-${NAME}.tex
    xelatex out-${NAME}.tex

rm -f out-${NAME}.tex

    if [ -e /var/www/html/certs/out-${NAME}.pdf ]; then
      rm -f /var/www/html/certs/out-${NAME}.pdf
    fi

    mv out-${NAME}.pdf /var/www/html/certs/

    gpg --clearsign -o /var/www/html/certs/signature/out-${NAME}.gpg /var/www/html/certs/out-${NAME}.pdf
 fi
done < "NAME.txt"

rm bg2.pdf
