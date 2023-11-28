#!/bin/sh -eux

(
cd "$HOME/src/kafka"
bin/kafka-server-stop.sh || echo $?
bin/zookeeper-server-stop.sh || echo $?
#rm /tmp/kafka-logs/*/* || echo $?
#rm -rf /tmp/kafka-logs || echo $?
bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
#KAFKA_OPTS=-Dsun.security.krb5.debug=true 
bin/kafka-server-start.sh -daemon config/server.properties
#tail -F logs/*.log logs/*.out
#bin/kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9093 --command-config config/client.properties
#bin/kafka-console-producer.sh --topic test-topic --bootstrap-server localhost:9093 --producer.config config/client.properties
#bin/kafka-console-consumer.sh --topic test-topic --from-beginning --bootstrap-server localhost:9093 --consumer.config config/client.properties
#bin/kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092
#bin/kafka-console-producer.sh --topic test-topic --bootstrap-server localhost:9092
#bin/kafka-console-consumer.sh --topic test-topic --from-beginning --bootstrap-server localhost:9092
tail -F logs/*.log
) 2>&1 | tee "$HOME/kafka.log"
