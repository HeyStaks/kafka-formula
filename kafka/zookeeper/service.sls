{%- from 'kafka/map.jinja' import kafka with context %}

include:
  - kafka.zookeeper.config

kafka_zk_service_unit:
  file.managed:
{% if grains.get('init') == 'systemd' %}
    - name: /etc/systemd/system/kafka-zookeeper.service
    - source: salt://kafka/files/systemd.jinja
{% elif grains.get('init') == 'upstart' %}
    - name: /etc/init/system/kafka-zookeeper.conf
    - source: salt://kafka/files/upstart.jinja
{% endif %}
    - template: jinja
    - defaults:
        description: "Kafka Zookeper service"
        documentation: "https://kafka.apache.org"
        default: "/etc/default/kafka-zookeeper"
        exec: {{ kafka.home }}/bin/zookeeper-server-start.sh
        exec_stop: {{ kafka.home }}/bin/zookeeper-server-stop.sh
        user: {{ kafka.user }}
        group: {{ kafka.group }}
        home: {{ kafka.home }}
    - require:
      - file: kafka_zk_properties
      - file: kafka_zk_defaults

kafka_zk_service:
  service.running:
    - name: kafka-zookeeper
    - enable: true
    - watch:
      - file: kafka_zk_service_unit
      - file: kafka_zk_properties
      - file: kafka_zk_defaults
