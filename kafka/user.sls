{%- from 'kafka/map.jinja' import kafka with context %}

kafka_group:
  group.present:
   - name: {{ kafka.group }}
   - system: True  

kafka_user:
  user.present:
    - name: {{ kafka.user }}
    - gid: {{ kafka.group }}
    - home: {{ kafka.home }}
    - system: True
