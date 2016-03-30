{%- from 'kafka/map.jinja' import kafka with context %}

include:
  - kafka

kafka_zk_config:
  file.managed:
    - name: {{ kafka.home }}/config/zookeeper.properties
    - source: salt://kafka/templates/zookeeper.properties
    - template: jinja
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}

kafka_zk_datadir:
  file.directory:
    - name: {{ kafka.zookeeper.data_dir }}
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}

kafka_zk_myid:
  file.managed:
    - name: {{ kafka.zookeeper.data_dir}}/myid
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - contents: {{ salt['grains.get']('kafka:zk_myid', '0') }}
    - require:
      - file: kafka_zk_datadir

kafka_zookeeper_init:
  file.managed:
    - name: /etc/init/kafka_zookeeper.conf
    - source: salt://kafka/templates/kafka_zookeeper.conf-upstart
    - template: jinja

kafka_zookeeper_service:
  service.running:
    - name: kafka_zookeeper
    - enable: true
    - watch:
      - file: kafka_zk_config
      - file: kafka_zookeeper_init
