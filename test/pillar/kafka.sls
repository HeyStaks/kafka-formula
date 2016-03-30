kafka:
  prefix: /opt

mine_functions:
  network.get_hostname: []
  network.ip_addrs:
    cidr: '172.16.99.0/24'
  kafka_broker_id:
    - mine_function: grains.get
    - 'kafka:broker_id'
  kafka_zk_myid:
    - mine_function: grains.get
    - 'kafka:zk_myid'
