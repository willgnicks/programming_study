# kafka

## linkedin公司开发的产品，现交由apache，是一款高性能的分布式消息队列

## 概念

- topic
- partition
- offset
- consumer
- producer

## 安装

```shell

```

创建uuid
/usr/local/kafka/bin/kafka-storage.sh random-uuid

格式化目录，使用上边输出的uuid
/usr/local/kafka/bin/kafka-storage.sh format -t jKEpC74uSuuhFbdh1Dc-KQ -c /usr/local/kafka/config/kraft/server.properties

后台启动
/usr/local/kafka/bin/kafka-server-start.sh -daemon /usr/local/kafka/config/kraft/server.properties & 

启动
./bin/kafka-server-start.sh ./config/kraft/server.properties

创建topic
/usr/local/kafka/bin/kafka-topics.sh --create --topic custom --partitions 5 --replication-factor 1 --bootstrap-server localhost:9092

查看topic
/usr/local/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092

开启消费者
/usr/local/kafka/bin/kafka-console-consumer.sh --from-beginning --bootstrap-server localhost:9092 --topic custom

开启生产者
/usr/local/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic custom


INTERNAL
