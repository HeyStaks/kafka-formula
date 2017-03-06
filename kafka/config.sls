{%- from 'kafka/map.jinja' import kafka with context %}

include:
  - kafka.package

kafka_config_symlink:
  file.symlink:
    - name: /etc/kafka
    - target: {{ kafka.home }}/config
    - require:
        - archive: kafka_tarball

kafka_server_properties:
  file.managed:
    - name: {{ kafka.home }}/config/server.properties
    - source: salt://kafka/files/server.properties.jinja
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - template: jinja
    - defaults:
        config: {{ kafka.server.config }}
    - require:
      - archive: kafka_tarball

kafka_defaults:
  file.managed:
    - name: /etc/default/kafka-server
    - source: salt://kafka/files/default.jinja
    - template: jinja
    - defaults:
        args: {{ kafka.home }}/config/server.properties
    - require:
        - file: kafka_server_properties
