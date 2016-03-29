zookeeper:
  prefix: /opt/heystaks/

mine_functions:
  network.get_hostname: []
  network.ip_addrs:
    cidr: '172.16.99.0/24'
  zookeeper_myid:
    - mine_function: grains.get
    - zookeeper_myid
