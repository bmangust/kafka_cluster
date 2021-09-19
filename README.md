Docker-compose for kafka cluster

# FEATURES
* Configured listeners for inside-docker and outside communications with kafka
* Command list for console utilites

# PREPARING

## prepare your .env file
See **.env-example** for mandatory variables


## install **make** if needed
You can use **docker-compose** commands instead of **make**. See **Makefile** for reference.


## build and run cluster
```
make up
```

## (optional) start local kafka cluster
Check server and zookeeper properties in **config** folder. You can update **dataDir** and **log.dirs** directories. Now it is considered that local kafka is placed in this repo in it's own folder, so **make** will be able to clean local and docker log datafiles if needed. **Java** is required.
```
curl -#L https://apache-mirror.rbc.ru/pub/apache/kafka/2.8.0/kafka_2.13-2.8.0.tgz > kafka_2.13-2.8.0.tgz
tar -xf kafka_2.13-2.8.0.tgz
cd kafka_2.13-2.8.0
bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
bin/kafka-server-start.sh -daemon config/server1.properties
bin/kafka-server-start.sh -daemon config/server2.properties
bin/kafka-server-start.sh -daemon config/server3.properties
```

Check logs
```
less logs/server.log
less logs/zookeeper.out
```


## install kcat
kcat (former *kafkacat*) is a swiss-army knife for CLI kafka management. You can easely produce, consume messages and control state of your cluster.

### On recent enough Debian systems
```
apt-get install kafkacat
```

### On Mac OS X
```
brew install kafkacat
```

### On Fedora
```
dnf copr enable bvn13/kafkacat
dnf update
dnf install kafkacat
```

# WOKING

## connect to Kafka docker cluster from local machine
**ATTENTION** Local distributive of Kakfa is required. See **PREPARING** section to get one.

### create topic *test*
```
bin/kafka-topics.sh --bootstrap-server=localhost:2091,localhost:2092,localhost:2093 --create --topic=test --partitions=3 --replication-factor=3
```

### list topics
```
bin/kafka-topics.sh --bootstrap-server=localhost:2091,localhost:2092,localhost:2093 --list
```

### post some messages
```
bin/kafka-console-producer.sh --bootstrap-server=localhost:2091,localhost:2092,localhost:2093 --topic=test
```

### read messages
```
bin/kafka-console-consumer.sh --bootstrap-server=localhost:2091,localhost:2092,localhost:2093 --topic=test --from-beginning
```

## the same with kcat
```
kcat -b localhost:2091,localhost:2092,localhost:2093 -L
kcat -b localhost:2091,localhost:2092,localhost:2093 -P -t test
kcat -b localhost:2091,localhost:2092,localhost:2093 -C -t test
```
Go for [docs](https://github.com/edenhill/kcat) for more.

## connect to kafka from a broker's containter

### dive into container with bash
```
docker exec -it kafka1 bash
```

### check topics
(notice `kafka#` host here instead of `localhost`)
```
bin/kafka-topics.sh --bootstrap-server=kafka1:9092,kafka2:9092,kafka3:9092 --create --topic=test --partitions=3 --replication-factor=3
bin/kafka-topics.sh --bootstrap-server=kafka1:9092,kafka2:9092,kafka3:9092 --list
bin/kafka-console-producer.sh --bootstrap-server=kafka1:9092,kafka2:9092,kafka3:9092 --topic=test
bin/kafka-console-consumer.sh --bootstrap-server=kafka1:9092,kafka2:9092,kafka3:9092 --topic=test --from-beginning
```
