{%- from 'kafka/map.jinja' import kafka with context %}

kafka_server_conf:
  file.managed:
    - name: {{ kafka.home }}/config/server.properties
    - source: salt://kafka/templates/server.properties
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - mode: 644
    - template: jinja
    - require:
      - archive: kafka_source
