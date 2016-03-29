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
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - source: {{ kafka.source_url }}
    - source_hash: md5=b71e5cbc78165c1ca483279c27402663
    - archive_format: tar
    - if_missing: {{ kafka.home }}

kafka_home:
  file.directory:
    - name: {{ kafka.home }}
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - recurse:
      - user
      - group
    - require:
      - archive: kafka_source

kafka_env:
  file.managed:
    - name: /etc/profile.d/kafka.sh
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - contents:
      - export KAFKA_HOME={{ kafka.home }}

kafka_dirs:
  file.directory:
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - mode: 755
    - makedirs: True
    - names:
    {% for logdir in kafka.config.log_dirs %}
      - {{ logdir }}
    {% endfor %}
