{%- from 'kafka/map.jinja' import kafka with context %}

include:
  - kafka.user

kafka_tarball:
  archive.extracted:
    - name: {{ kafka.install_dir }}
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - source: {{ kafka.source }}
    - source_hash: {{ kafka.source_hash }}
    - archive_format: tar

kafka_env:
  file.managed:
    - name: /etc/profile.d/kafka.sh
    - user: {{ kafka.user }}
    - group: {{ kafka.group }}
    - contents:
      - export KAFKA_HOME={{ kafka.home }}
    - require:
        - archive: kafka_tarball

{% set kafka_scripts = ['kafka-topics.sh'] %}

{% for script in kafka_scripts %}
kafka_{{ script }}_symlink:
  file.symlink:
    - name: /usr/bin/{{ script }}
    - target: {{ kafka.home }}/bin/{{ script }}
    - require:
        - archive: kafka_tarball
{% endfor %}
