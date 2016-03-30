{%- from 'kafka/map.jinja' import kafka with context %}

include:
  - kafka

kafka_server_conf:
  file.managed:
    - name: {{ kafka.home }}/config/server.properties
    - source: salt://kafka/templates/server.properties
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - template: jinja
    - require:
      - file: {{ kafka.home }}

kafka_init:
  file.managed:
    - name: {{ kafka.init_conf }} 
    - source: salt://kafka/templates/{{ kafka.init_file }}
    - mode: 644
    - template: jinja
    - require:
      - file: kafka_server_conf

kafka_service:
  service.running:
    - name: kafka
    - enable: true
    - watch:
      - file: kafka_server_conf
      - file: kafka_init
