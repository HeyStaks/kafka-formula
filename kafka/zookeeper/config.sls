{%- from 'kafka/map.jinja' import kafka with context %}

include:
  - kafka.package

kafka_zk_defaults:
  file.managed:
    - name: /etc/default/kafka-zookeeper
    - source: salt://kafka/files/default.jinja
    - template: jinja
    - defaults:
        args: {{ kafka.home }}/config/zookeeper.properties
    - require:
        - file: kafka_zk_properties

kafka_zk_properties:
  file.managed:
    - name: {{ kafka.home }}/config/zookeeper.properties
    - source: salt://kafka/files/server.properties.jinja
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - template: jinja
    - defaults:
        config: {{ kafka.zookeeper.config }}
    - require:
      - archive: kafka_tarball

kafka_zk_datadir:
  file.directory:
    - name: {{ kafka.zookeeper.config.dataDir }}
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - makedirs: True
    - require:
        - file: kafka_zk_properties

kafka_zk_myid:
  file.managed:
    - name: {{ kafka.zookeeper.config.dataDir }}/myid
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - contents: {{ kafka.zookeeper.get('myid', 0) }}
    - require:
      - file: kafka_zk_datadir
