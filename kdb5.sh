#!/bin/sh -eux

cat >/var/kerberos/krb5kdc/kdc.conf <<EOF
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88
 default_realm = ADS-KAFKA.LOCAL

[realms]
 ADS-KAFKA.LOCAL = {
 acl_file = /var/kerberos/krb5kdc/kadm5.acl
 dict_file = /usr/share/dict/words
# admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
 admin_keytab = /etc/krb5.keytab
 supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal camellia256-cts:normal camellia128-cts:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal
 }
EOF

cat >/var/kerberos/krb5kdc/kadm5.acl <<EOF
#*/admin@ADS-KAFKA.LOCAL *
#root/admin@ADS-KAFKA.LOCAL *
$SUDO_USER@ADS-KAFKA.LOCAL *
EOF

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

rm /var/kerberos/krb5kdc/principal* /etc/krb5.keytab || echo $?

kdb5_util create -s -r ADS-KAFKA.LOCAL -P admin

#kadmin.local -q "add_principal -pw admin admin/admin"
#kadmin.local -q "add_principal -pw admin root/admin"
kadmin.local -q "add_principal -pw admin $SUDO_USER"
#kadmin.local -q "ktadd -k /etc/krb5.keytab root/admin@ADS-KAFKA.LOCAL"

#kadmin.local -q "ktadd -k /etc/krb5.keytab $SUDO_USER"

killall krb5kdc || echo $?
#killall kadmin || echo $?

krb5kdc
#kadmin
