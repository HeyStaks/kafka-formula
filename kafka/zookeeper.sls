{%- from 'kafka/map.jinja' import kafka with context %}

include:
  - kafka
  - zookeeper.config

extend:
  zookeeper_config:
    file:
      - name: {{ kafka.home }}/config/zookeeper.properties
      - user: {{ kafka.user }}
      - group: {{ kafka.group }}
  zookeeper_datadir:
    file:
      - user: {{ kafka.user }}
      - group: {{ kafka.group }}
  zookeeper_myid:
    file:
      - user: {{ kafka.user }}
      - group: {{ kafka.group }}

kafka_zookeeper_init:
  file.managed:
    - name: /etc/init/kafka_zookeeper.conf
    - source: salt://kafka/templates/kafka_zookeeper.conf-upstart
    - template: jinja
    - require:
      - file: kafka_server_conf

kafka_zookeeper_service:
  service.running:
    - name: kafka_zookeeper
    - enable: true
    - watch:
      - file: zookeeper_config
      - file: kafka_zookeeper_init
