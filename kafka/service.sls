{%- from 'kafka/map.jinja' import kafka with context %}

include:
  - kafka.config

kafka_service_unit:
  file.managed:
{% if grains.get('init') == 'systemd' %}
    - name: /etc/systemd/system/kafka-server.service
    - source: salt://kafka/files/systemd.jinja
{% elif grains.get('init') == 'upstart' %}
    - name: /etc/init/system/kafka-server.conf
    - source: salt://kafka/files/upstart.jinja
{% endif %}
    - template: jinja
    - defaults:
        description: "Kafka service"
        documentation: "https://kafka.apache.org"
        default: "/etc/default/kafka-server"
        exec: {{ kafka.home }}/bin/kafka-server-start.sh
        exec_stop: {{ kafka.home }}/bin/kafka-server-stop.sh
        user: {{ kafka.user }}
        group: {{ kafka.group }}
        home: {{ kafka.home }}
    - require:
      - file: kafka_server_properties
      - file: kafka_defaults

kafka_service:
  service.running:
    - name: kafka-server
    - enable: true
    - watch:
      - file: kafka_service_unit
      - file: kafka_server_properties
      - file: kafka_defaults
