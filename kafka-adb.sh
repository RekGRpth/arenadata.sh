#!/bin/sh -eux

(
cd "$HOME/src/kafka-adb"
make -j"$(nproc)" install
cd "$HOME/src/kafka"
bin/kafka-server-stop.sh || echo $?
bin/zookeeper-server-stop.sh || echo $?
bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
bin/kafka-server-start.sh -daemon config/server.properties
tail -F logs/server.log
) 2>&1 | tee "$HOME/kafka-adb.log"
