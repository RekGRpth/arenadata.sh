#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/kafka-adb.log")

#(
#sudo rpm -i --replacepkgs https://downloads.adsw.io/ADB/6.26.2_arenadata55/centos/7/community/x86_64/librdkafka-1.9.2-2980.el7.x86_64.rpm
#sudo rpm -i --replacepkgs https://downloads.adsw.io/ADB/6.26.2_arenadata55/centos/7/community/x86_64/librdkafka-devel-1.9.2-2980.el7.x86_64.rpm
pushd /tmp
LIBRDKAFKA_URL="https://downloads.adsw.io/ADB-develop/CI-3156/ubuntu/22.04/community/x86_64/packages"
LIBRDKAFKA_VERSION="1.9.2-3689_amd64"
LIBAVRO_C_RELEASE_URL="https://downloads.adsw.io/ADB/6.27.1_arenadata56/ubuntu/22.04/community/x86_64/packages"
LIBAVRO_C_RELEASE_VERSION="1.10.2-arenadata1-3304%2Bgit197fc96_amd64"
wget "$LIBRDKAFKA_URL/librdkafka_$LIBRDKAFKA_VERSION.deb" \
     "$LIBRDKAFKA_URL/librdkafka-dev_$LIBRDKAFKA_VERSION.deb" \
     "$LIBAVRO_C_RELEASE_URL/libavro_$LIBAVRO_C_RELEASE_VERSION.deb" \
     "$LIBAVRO_C_RELEASE_URL/libavro-dev_$LIBAVRO_C_RELEASE_VERSION.deb"
sudo apt update
sudo apt install -y python3-pip sshpass libcsv-dev libgmp-dev ./*.deb
rm ./*.deb
popd
pushd "$HOME/src/kafka-adb"
make -j"$(nproc)" clean
make -j"$(nproc)" install
#gpstop -afr
#) 2>&1 | tee "$HOME/kafka-adb.log"
popd
