#!/bin/sh -eux

(
sudo rpm -i --replacepkgs https://downloads.adsw.io/ADB/6.26.2_arenadata55/centos/7/community/x86_64/librdkafka-1.9.2-2980.el7.x86_64.rpm
sudo rpm -i --replacepkgs https://downloads.adsw.io/ADB/6.26.2_arenadata55/centos/7/community/x86_64/librdkafka-devel-1.9.2-2980.el7.x86_64.rpm
cd "$HOME/src/kafka-adb"
make -j"$(nproc)" clean
make -j"$(nproc)" install
#gpstop -afr
) 2>&1 | tee "$HOME/kafka-adb.log"
