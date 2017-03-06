include:
  - kafka.zookeeper
  - kafka

extend:
  kafka_service:
    service:
      - watch:
        - service: kafka_zk_service
