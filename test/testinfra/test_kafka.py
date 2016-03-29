def test_kafka_user(User):
    assert User("kafka").exists

def test_kafka_group(Group):
    assert Group("kafka").exists

def test_kafka_service(Service):
    assert Service("kafka").is_enabled
    assert Service("kafka").is_running

def test_zookeeper_kafka_service(Service):
    assert Service("kafka_zookeeper").is_enabled
    assert Service("kafka_zookeeper").is_running

# def test_kafka_create_topic(Command)
