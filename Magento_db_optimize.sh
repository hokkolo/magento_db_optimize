#/bin/bash
#AUTHOR: GALVIN
#VERSION: 20190605

#Webserver Configuration
HTTP_CONF='/usr/local/apache/conf/httpd.conf'

#Define table size
SIZE='100k'

#Temporary files that are created during the 
#script execution and will be removed after
#execution
DOMAINS='/var/tmp/domains.txt'
FILE='/var/tmp/path.txt'
DBNAME='/var/tmp/dbname.txt'
MAGE1='/var/tmp/mage1.txt'
MAGE2='/var/tmp/mage2.txt'

#Magento database tables that can be truncated
TBL=(log_customer
log_visitor
log_visitor_info
log_url
log_url_info
log_quote
report_viewed_product_index
report_compared_product_index
report_event
catalog_compare_item)

:> $FILE
:> $DBNAME
:> $DOMAINS
:> $MAGE1
:> $MAGE2

for i in `cat /etc/userdomains | awk -F ":" '{print $1}' | grep -v "*" | uniq`; do
    grep -A2 " $i" $HTTP_CONF | grep DocumentRoot | awk {'print $2'} | awk 'NR == 1' >> $DOMAINS
 done;

for j in `cat $DOMAINS`; do
    find $j/app/etc/ -type f -name local.xml  2>/dev/null >> $MAGE1
    find $j/app/etc/ -type f -name env.php  2>/dev/null >> $MAGE2
done;
for i in `cat $MAGE2`; do
    grep dbname $i | awk -F "'" '{print $4}' >> $DBNAME;
done;

for i in `cat $MAGE1`; do
        grep dbname $i | awk -F "[" '{print $3}' | awk -F "]"  '{print $1}' >> $DBNAME;
done;

for i in `cat $DBNAME`; do
    echo "Database: "$i
    for j in ${TBL[*]}; do
         find /var/lib/mysql/$i/ -name "*$j.ibd" -size +$SIZE -exec du -h {} \; 
    done;
  echo -e "\n"
done;

         
rm -f $FILE $DBNAME $DOMAINS $MAGE1 $MAGE2

