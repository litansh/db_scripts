host    all             all             192.168.181.0/24            md5
host    all             all             192.168.191.0/24            md5
host    all             all             192.168.77.0/24             md5
host    all             all             192.168.99.0/24             md5
host    all             all             192.168.60.122/32           md5



host    all             all             192.168.60.71/32            md5
host    all             all             52.214.140.66/32            md5
host    all             all             52.209.153.236/32           md5
host    all             all             18.196.210.97/32            md5
host    all             all             18.195.125.136/32           md5
host    all             all             34.253.177.165/32           md5
host    all             all             35.156.66.243/32            md5
host    all             all             65.18.217.206/32            md5
host    all             all             212.50.99.123/32            md5
host    all             all             54.171.230.125/32           md5






host    all             all             192.168.181.0/24        md5
host    all             all             192.168.191.0/24        md5
host    all             all             192.168.77.0/24         md5
host    all             all             192.168.99.0/24         md5
host    all             all             192.168.60.122/32	md5
host    all             all             192.168.60.71/32        md5
host    all             all             52.214.140.66/32        md5
host    all             all             52.209.153.236/32	md5
host    all             all             18.196.210.97/32        md5
host    all             all             18.195.125.136/32	md5
host    all             all             34.253.177.165/32	md5
host    all             all             35.156.66.243/32        md5
host    all             all             65.18.217.206/32        md5
host    all             all             212.50.99.123/32        md5
host    all             all             54.171.230.125/32	md5
host    all             all             84.228.113.135/32	md5



remove postgres completely:

yum remove postgresql-* -y
yum remove postgresql -y
yum remove postgres\* -y
rm -rf /var/lib/postgresql
rm -rf /var/log/postgresql
rm -rf /etc/postgresql
rm -rf /var/lib/pgsql


mount -t cifs -o username=walter //192.168.181.118/backup_Sata$ /home
mount.cifs //192.168.181.118/backup_Sata$ /home/BCKP -o user=walter




echo '127.0.0.1/32 md5
192.168.77.0/24 md5
92.168.99.0/24 md5
192.168.3.0/24 ident
192.168.2.1/32 md5
192.168.1.1/32 md5
192.168.6.0/24 md5' > hu


function create_readonlyuser_ () {
Enter username

CREATE USER $USERNAME WITH password $PASSWORD;
GRANT CONNECT ON DATABASE mydb TO myReadolyUser;
}


Menu Create Users

Create User with Database     4 (sed -i "/$USERNAME" /tmp/helpme/.pguserplusdbcount && echo "DB+USR = $USERNAME" >> /tmp/helpme/.pgcount)
POINTER=UPLD
Create User for Backup        1 (sed -i "/$USERNAME" /tmp/helpme/.pguserplusdbcount && echo "DB+USR = $USERNAME" >> /tmp/helpme/.pgcount)
Create User readonly per DBs    (For spesific database or for all? dropdown menu)
Create User Super Admin
Create User and asign to DBs
Assign user to database
Reset password to User
Delete User


A=DBplusUser
B=ReadUser
C=SuperAdmin
D=BackupUser

DDATE="$(date +"Created:%d.%m.%Y")"


function mysql_create_user_query_(parameter) {
if [[ $POINTER == UPLD ]]; then
  #statements
  REATE USER $USERNAME WITH password $PASSWORD;
  RANT CONNECT ON DATABASE mydb TO myReadolyUser;
  USERNAME=avgad
  sed -i "/$USERNAME/d"  /tmp/helpme/.pgcount
  echo "$B - $USERNAME - $DDATE - DB=tradenet - PASSWORD=yes - PermitedHost=192.168.60.0,10.0.0.0/24" >> /tmp/helpme/.pgcount
fi

}


function create_readonlyuser_ () {
  A=DBplusUser
  B=ReadUser
  C=SuperAdmin
  D=BackupUser
clear
echo "Title"
echo "Logo litan manyak"
read -e -p "Enter username " USERNAME
clear
echo "Title"
echo "Logo litan manyak"
echo "User: $USERNAME"
read -e -p "Enter upassword " PASSWORD #drop down menu Enter password or generate password
clear
echo "Title"
echo "Logo litan manyak"
echo "User: $USERNAME"
echo "Pass: XXXXXXXXXXXXX"
read -e -p "Enter DB or [Enter] for dbname $USERNAME " DBNAME
if [[ -z $DBNAME ]]; then
DBNAME="$USERNAME"
fi
add dropdown menu
Allow from any IP
From permited IP (or subnet)
echo "Title"
echo "Logo litan manyak"
echo "User: $USERNAME"
echo "Pass: XXXXXXXXXXXXX"
echo "DB  : $DBNAME"
read -e -p "To Proceed press [Enter]" CHOICE


clear
echo "Title"
echo "Logo litan manyak"
All Done
${menu}To view password press [${number}p${menu}]
echo "User: $USERNAME"
echo "Pass: XXXXXXXXXXXXX"
echo "DB  : $DBNAME"
echo "IP  : $IPSUB"
${menu}To view password press [${number}p${menu}]
read -e -p "Enter to finish" CHOICE
if [[ $CHOICE == p ]]; then
  clear
  echo "Title"
  echo "Logo litan manyak"
  All Done
  echo "User: $USERNAME"
  echo "Pass: XXXXXXXXXXXXX"
  echo "DB  : $DBNAME"
pause_
fi

}


Roles
A=DBplusUser
B=ReadUser
C=SuperAdmin
D=BackupUser

sed 's/$/ , is a great language/' string
awk '{print $0 " is a great language"}' input

mkdir -p /tmp/helpme
touch /tmp/helpme/.pgcount

DDATE="$(date +"Created:%d.%m.%Y")"
USERNAME=litan
sed -i "/$USERNAME/d" /tmp/helpme/.pgcount
echo "$A - $USERNAME - $DDATE" >> /tmp/helpme/.pgcount

USERNAME=avgad
sed -i "/$USERNAME/d"  /tmp/helpme/.pgcount
echo "$B - $USERNAME - $DDATE" >> /tmp/helpme/.pgcount

USERNAME=hen
sed -i "/$USERNAME/d"  /tmp/helpme/.pgcount
echo "$C - $USERNAME - $DDATE" >> /tmp/helpme/.pgcount
USERNAME=backup
sed -i "/$USERNAME/d"  /tmp/helpme/.pgcount
echo "$D - $USERNAME - $DDATE" >> /tmp/helpme/.pgcount
USERNAME=gennady
sed -i "/$USERNAME/d" /tmp/helpme/.pgcount
echo "$C - $USERNAME - $DDATE" >> /tmp/helpme/.pgcount

USERNAME=avgad
sed -i "/$USERNAME/d"  /tmp/helpme/.pgcount
echo "$B - $USERNAME - $DDATE" >> /tmp/helpme/.pgcount

USERNAME=tradenet
sed -i "/$USERNAME/d" /tmp/helpme/.pgcount
echo "$A - $USERNAME - $DDATE" >> /tmp/helpme/.pgcount

USERNAME=powerbi
sed -i "/$USERNAME/d"  /tmp/helpme/.pgcount
echo "$B - $USERNAME - $DDATE" >> /tmp/helpme/.pgcount


USERNAME=avgad
sed -i "/$USERNAME/d"  /tmp/helpme/.pgcount
echo "READONLY - $USERNAME - $DDATE" >> /tmp/helpme/.pgcount



user restriction:
host    bacula100       bacula          10.0.44.100/32          trust

local OPT1=`echo -e "Create User with Database"`
username + password + database                  [ privilege for DB ]
checkuuu=1

local OPT2=`echo -e "Create User for Backup "`
username + password                    [ database (all) + privilege to backup ]
checkuuu=2

local OPT3=`echo -e "Create User read per DBs"`
username + password + database                  [ privilege readonly ]
checkuuu=3

# local OPT4=`echo -e "Create User Super Admin"`
# username + password                            [ privilege superadmin ]
# checkuuu=4

# local OPT5=`echo -e "Assign user to database"`
# existing user + database
# checkuuu=5

local OPT6=`echo -e "Reset password to User"`
user + password

local OPT7=`echo -e "Delete User"`
user [ checkbox menu ]

local EXIT=`echo -e "Back"`


echo > finaltableinfo
echo > users
i=0
PGPASSWORD=myPassword psql -U postgres -c "\l" | awk '{print $1, $3, $11, $12, $6}' | grep -v 'Name' | grep -v 'List' | sed 1d | column -t > tableinfo
cat tableinfo | while read line; do
 checker=`echo $line | awk '{print $1}' | grep '|' | wc -l`
 if [[ $checker != 0 ]]; then
  checkerb=`echo $line | awk '{print $3}' | grep '|' | wc -l`
  if [[ $checkerb == 0 ]] && [[ $i != 0 ]]; then
   i=$((i+1))
   echo $line | tr '|' " " >> temptableinfo
  elif [[ $checkerb == 0 ]] && [[ $i == 0 ]]; then
   echo $line | tr '|' " " > temptableinfo
   i=$((i+1))
  else
   i=0
   echo $line | awk '{print $1, $2, "No Permissions"}' >> finaltableinfo
  fi
 else
  if [[ $i != 0 ]]; then
   cat temptableinfo >> finaltableinfo
  fi
  i=0
  echo $line | awk '{print $1, $2, $3}' >> finaltableinfo
 fi
done



PGPASSWORD=myPassword psql -U postgres -c "\l" | awk '{print $1, $3}' | grep -v 'Name' | grep -v 'List' | sed 1d | column -t > tableinfo


PGPASSWORD=myPassword psql -U postgres -c "\l" | awk '{print $1, $3}' | grep -v 'Name' | grep -v 'List' | grep -v '|' | sed 1d | column -t > tableinfo


Postgres Tasks:

main menu:

Manage Access IPs:

1. add\remove and go to Manage IPs
2. b for back
3. escape for back
4. counter for t+p ips

Manage Databases:

1. fix db border
2. b for back
3. escape for back
4. fix Press [ENTER] to Remove or [ESC] / [b] to go back
5. Drop and go back to manage db
6. show drop db
7. show added db

Users indication when creating
move MENUS
move cursor to left
"allow access"
enter to finish -> pause_witout_exit_
menu spaces
lgreen user created




function grepegreen_ () {
    GREP_COLOR='5;01;32'  grep --color -E -i "$1|$" $2
}



echo "***" | grepegreen_ ***




nextcloud


php 8
move 20 to 10 + WAN IP

<VirtualHost *:443>
  SSLEngine On
  SSLCertificateFile /etc/SSLtoWWW/devtradenetcom.crt
  SSLCertificateKeyFile /etc/SSLtoWWW/devtradenetcom.key
  DocumentRoot /var/www/nextcloud/
  ServerName cloud.tradenet.com
  SSLProtocol all -SSLv2 -SSLv3
  SSLHonorCipherOrder on
  SSLCipherSuite "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS"
  #Header edit Set-Cookie ^(.*)$ $1;HttpOnly;Secure
  <Directory /var/www/nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>

  </Directory>
</VirtualHost>



mkdir /home/nextcloud/data

chown -R apache:apache /var/www/nextcloud
chown -R apache:apache /home/nextcloud/data


semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/nextcloud/data(/.*)?'
semanage fcontext -a -t httpd_sys_rw_content_t '/home/nextcloud/data(/.*)?'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/nextcloud/config(/.*)?'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/nextcloud/apps(/.*)?'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/nextcloud/.htaccess'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/nextcloud/.user.ini'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/nextcloud/3rdparty/aws/aws-sdk-php/src/data/logs(/.*)?'

restorecon -R '/var/www/nextcloud/'
restorecon -R '/home/nextcloud/data/'

setsebool -P httpd_can_network_connect on



sudo echo '
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0
wsrep_on=1
wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_name="nxtcloudclu01"
wsrep_cluster_address="gcomm://192.168.60.27,192.168.10.27,192.168.10.28"
wsrep_node_address="192.168.60.27"
wsrep_slave_threads=1
wsrep_certify_nonPK=1
wsrep_max_ws_rows=0
wsrep_max_ws_size=2147483647
wsrep_debug=0
wsrep_convert_LOCK_to_trx=0
wsrep_retry_autocommit=1
wsrep_auto_increment_control=1
wsrep_drupal_282555_workaround=0
wsrep_causal_reads=0
wsrep_notify_cmd=
wsrep_sst_method=rsync
# SST authentication string. This will be used to send SST to joining nodes.
# Depends on SST method. For mysqldump method it is root:
wsrep_sst_auth=root:' > /etc/my.cnf.d/galera.cnf


sudo echo '
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0
wsrep_on=1
wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_name="nxtcloudclu01"
wsrep_cluster_address="gcomm://192.168.60.27,192.168.10.27,192.168.10.28"
wsrep_node_address="192.168.10.27"
wsrep_slave_threads=1
wsrep_certify_nonPK=1
wsrep_max_ws_rows=0
wsrep_max_ws_size=2147483647
wsrep_debug=0
wsrep_convert_LOCK_to_trx=0
wsrep_retry_autocommit=1
wsrep_auto_increment_control=1
wsrep_drupal_282555_workaround=0
wsrep_causal_reads=0
wsrep_notify_cmd=
wsrep_sst_method=rsync
# SST authentication string. This will be used to send SST to joining nodes.
# Depends on SST method. For mysqldump method it is root:
wsrep_sst_auth=root:' > /etc/my.cnf.d/galera.cnf


sudo echo '
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0
wsrep_on=1
wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_name="nxtcloudclu01"
wsrep_cluster_address="gcomm://192.168.60.27,192.168.10.27,192.168.10.28"
wsrep_node_address="192.168.10.28"
wsrep_slave_threads=1
wsrep_certify_nonPK=1
wsrep_max_ws_rows=0
wsrep_max_ws_size=2147483647
wsrep_debug=0
wsrep_convert_LOCK_to_trx=0
wsrep_retry_autocommit=1
wsrep_auto_increment_control=1
wsrep_drupal_282555_workaround=0
wsrep_causal_reads=0
wsrep_notify_cmd=
wsrep_sst_method=rsync
# SST authentication string. This will be used to send SST to joining nodes.
# Depends on SST method. For mysqldump method it is root:
wsrep_sst_auth=root:' > /etc/my.cnf.d/galera.cnf




PG

kops create cluster \
--name=litanshamir.com \
--state=s3://litanshamir.com \
--authorization RBAC \
--zones=eu-west-2a \
--node-count=2 \
--node-size=t2.micro \
--master-size=t2.micro \
--master-count=1 \
--dns-zone=litanshamir.com\
--out=litanshamir_terraform \
--target=terraform \
--ssh-public-key=/Users/litanshamir/.ssh/litanshamir.pub

ulitanshamir
AKIA4VX2FAV3OFPJQGN5
dmkOWrgDrISQ7tTXAXVG7LSOjbaic/vGzM96SUHo















51111
IDRAC smtp


174.3 add IDRAC addresses
Firewall allow from Permitted IPs















function check_users_ () {
cat tmpusers | while read liner; do
 checkexist=`echo $line | grep $liner | wc -l`
 x=$((i-1))
 if [[ $checkexist != 0 ]]; then
  sed -i "${x}s/$/ $liner/" dblist
 fi
done
echo -e "$dbname $dbowner" >> dblist
}
#
function merge_rows_ () {
cat tmpdb | while read lineria; do
 checker=`echo $lineria | awk '{print $1}' | grep '|' | wc -l`
 dbl=`echo $lineria | awk '{print $1}'`
 if [[ $checker == 0 ]]; then
  cat dblist | grep $dbl | awk 'length > max_length { max_length = length; longest_line = $0 } END { print longest_line }' >> finaldblist
 fi
done
echo -e "\nDBName       Owner      Allowed Users\n" > dblistview
cat finaldblist | column -t >> dblistview
}
#
function main_check_db_permissions_ () {
rm -rf dblist && rm -rf tmpusers && rm -rf finaldblist && rm -rf dblistview
PGPASSWORD=myPassword psql -U postgres -c "\du" | awk '{print $1}' | grep -v 'Role' | grep -v 'List' | grep -v 'Name' | grep -v '-' | grep -v '|' | grep -v '(' | sed '/^$/d' > tmpusers
PGPASSWORD=myPassword psql -U postgres -c "\l" | awk '{print $1, $3, $11, $6}' | grep -v 'List' | grep -v 'Name' | grep -v '-' | grep -v '(' | sed '/^$/d' > tmpdb
i=1
cat tmpdb | while read line; do
 checkpipe=`echo $line | grep '| |' | wc -l`
 if [[ $checkpipe == 0 ]]; then
  dbname=`echo $line | awk '{print $1}'`
  dbowner=`echo $line | awk '{print $2}'`
 fi
 check_users_
 i=$((i+1))
done
merge_rows_
}
#
main_check_db_permissions_
cat dblistview


DROPDOWN_create_user_menu1_
