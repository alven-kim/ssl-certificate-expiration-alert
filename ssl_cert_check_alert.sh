#!/usr/bin/env bash

## certs list
# *.alvenkim.com
# *.alvenkim.kr
# *.alvenkim.co.kr
# www.alvenkim.com
# embrace.alvenkim.com # EV
# order.alvenkim.com # EV


MAIL_ADDR=$(cat mail_address.txt)
CHECK_FILE=$(cat fqdn.txt)

if [[ -z $MAIL_ADDR || -z $CHECK_FILE ]]; then
        echo -e "########## Script Failed --- Please Your Check mail_address.txt File"
        exit 1
fi

while read FQDN
do

    CERTEXPIRE=$(echo | openssl s_client -showcerts -servername $FQDN -connect $FQDN:443 2> /dev/null | date --date="$(openssl x509 -noout -enddate | cut -d= -f 2)" +%F)
    SVRTIME=$(date -d '1 month' +%F) # SVRTIME NOW + 1 month
    QUERY=$(echo | awk -v certtime=$CERTEXPIRE -v svrtime=$SVRTIME '{if(svrtime > certtime){print"MAIL"}else{print"NO"}}')
    

    if [ $QUERY = "MAIL" ]; then
        COMMON_NAME+=$(echo | openssl s_client -showcerts -servername $FQDN -connect $FQDN:443 2> /dev/null | openssl x509 -noout -subject | awk -F "=" '{print$NF"\t"}')
    else
        echo "No Alert - $FQDN"
    fi

done < fqdn.txt

if [ -n "$COMMON_NAME" ]; then
    echo -e "The SSL certificate is due to expire within 1-month.\n Please Check your SSL Certification.\n $COMMON_NAME" | mailx -a "From: nms01@alvenkim.org" -s "SSL Cert Expire 1-Month." $MAIL_ADDR
else
    echo -e "$(date +%FT%T) SSL Cert Check - The expiration date of the ssl certificate is more than a month away." >> /var/log/syslog
fi

