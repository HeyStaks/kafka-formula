/etc/init/kafka.conf:
  file.managed:
    - source: salt://kafka/templates/kafka.conf-upstart
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
