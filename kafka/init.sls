{%- from 'kafka/map.jinja' import kafka with context %}

kafka_group:
  group.present:
  - name: {{ kafka.group }}

kafka_user:
  user.present:
    - name: {{ kafka.user }}
    - gid: kafka

kafka_source:
  archive.extracted:
    - name: {{ kafka.prefix }}
    - source: {{ kafka.source_url }}
    - source_hash: md5=b71e5cbc78165c1ca483279c27402663
    - archive_format: tar
    - if_missing: {{ kafka.home }}

{{ kafka.home }}:
  file.directory:
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - recurse:
      - user
      - group
    - require:
      - archive: kafka_source

kafka_dirs:
  file.directory:
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - mode: 755
    - makedirs: True
    - names:
    {% for ld in kafka.config.log_dirs %}
      - {{ ld }}
    {% endfor %}
