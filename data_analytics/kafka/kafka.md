# **[What is Apache Kafka?](https://www.geeksforgeeks.org/apache-kafka/)**

Apache Kafka is a publish-subscribe messaging system. A messaging system lets you send messages between processes, applications, and servers. Broadly Speaking, Apache Kafka is software where topics (a topic might be a category) can be defined and further processed. Applications may connect to this system and transfer a message onto the topic. A message can include any kind of information from any event on your blog or can be a very simple text message that would trigger any other event.

## What is Kafka?

Kafka is an open-source messaging system that was created by LinkedIn and later donated to the Apache Software Foundation. It's built to handle large amounts of data in real time, making it perfect for creating systems that respond to events as they happen.

Kafka organizes data into categories called "topics." Producers (apps that send data) put messages into these topics, and consumers (apps that read data) receive them. Kafka ensures that the system is reliable and can keep working even if some parts fail.

## Core Components of Apache Kafka

To understand how Kafka works, it's essential to know about its core components. Let’s take a closer look at each of these:

1. Kafka Broker
A **]Kafka broker](<https://www.geeksforgeeks.org/what-is-a-kafka-broker/>)** is a server that runs Kafka and stores data. Typically, a Kafka cluster consists of multiple brokers that work together to provide scalability, fault tolerance, and high availability. Each broker is responsible for storing and serving data related to topics.

2. Producers
A producer is an application or service that sends messages to a Kafka topic. These processes push data into the Kafka system. Producers decide which topic the message should go to, and Kafka efficiently handles it based on the partitioning strategy.

![i1](https://media.geeksforgeeks.org/wp-content/uploads/apache-kafka-cluster.png)

3. Kafka Topic

A topic in Kafka is a category or feed name to which messages are published. Kafka messages are always associated with topics, and when you want to send a message, you send it to a specific topic. Topics are divided into partitions, which allow Kafka to scale horizontally and handle large volumes of data.
