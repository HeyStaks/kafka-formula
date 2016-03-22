{%- from 'kafka/map.jinja' import kafka with context %}

/etc/init/kafka.conf:
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
      - file: /etc/init/kafka.conf
