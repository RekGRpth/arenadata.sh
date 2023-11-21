#!/bin/sh -eux

killall krb5kdc || echo $?
killall kadmin || echo $?

rm /var/kerberos/krb5kdc/* /etc/krb5.keytab || echo $?

cat >/var/kerberos/krb5kdc/kdc.conf <<EOF
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88
 default_realm = ADS-KAFKA.LOCAL

[realms]
 ADS-KAFKA.LOCAL = {
  acl_file = /var/kerberos/krb5kdc/kadm5.acl
  dict_file = /usr/share/dict/words
  admin_keytab = /etc/krb5.keytab
  supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal camellia256-cts:normal camellia128-cts:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal
 }
EOF
#admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab

cat >/var/kerberos/krb5kdc/kadm5.acl <<EOF
$SUDO_USER@ADS-KAFKA.LOCAL *
EOF
#*/admin@ADS-KAFKA.LOCAL *
#root/admin@ADS-KAFKA.LOCAL *

cat >/etc/krb5.conf <<EOF
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 default_realm = ADS-KAFKA.LOCAL
 kdc_timesync = 1
 ticket_lifetime = 24h

[realms]
 ADS-KAFKA.LOCAL = {
  admin_server = localhost
  kdc = localhost
 }
EOF

kdb5_util create -s -r ADS-KAFKA.LOCAL -P admin

#kadmin.local -q "add_principal -pw admin admin/admin"
#kadmin.local -q "add_principal -pw admin root/admin"
#kadmin.local -q "add_principal -pw admin $SUDO_USER"
#kadmin.local -q "add_principal -pw admin kafka"
#kadmin.local -q "add_principal -pw admin zookeeper"
#kadmin.local -q "add_principal -pw admin reader"
#kadmin.local -q "add_principal -pw admin writer"
#kadmin.local -q "ktadd -k /etc/krb5.keytab root/admin@ADS-KAFKA.LOCAL"

#kadmin.local -q 'addprinc -randkey kafka/localhost@ADS-KAFKA.LOCAL'
#kadmin.local -q "ktadd -k /etc/krb5.keytab kafka/localhost@ADS-KAFKA.LOCAL"

#kadmin.local -q "ktadd -k /etc/krb5.keytab $SUDO_USER"
#kadmin.local -q "ktadd $SUDO_USER"

kadmin.local <<EOF
list_principals
add_principal -pw admin $SUDO_USER
list_principals
ktadd $SUDO_USER
EOF
#add_principal -pw admin root/admin
#ktadd -k /var/kerberos/krb5kdc/kadm5.keytab $SUDO_USER

chown "$SUDO_USER":"$SUDO_USER" /etc/krb5.keytab || echo $?
#ls -lan /etc/krb5.keytab || echo $?
ls -lan /etc/krb5.keytab /var/kerberos/krb5kdc || echo $?

krb5kdc
#kadmin
