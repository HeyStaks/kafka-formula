include:
  - kafka.zookeeper
  - kafka.server

extend:
  kafka_service:
    service:
      - watch:
        - service: kafka_zookeeper_service
