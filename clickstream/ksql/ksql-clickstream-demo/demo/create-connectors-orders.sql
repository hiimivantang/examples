CREATE SOURCE CONNECTOR datagen_product_ids WITH (
  'connector.class'          = 'io.confluent.kafka.connect.datagen.DatagenConnector',
  'kafka.topic'              = 'productids',
  'schema.filename'          = '/scripts/product_ids_schema.avro',
  'schema.keyfield'          = 'request',
  'maxInterval'              = '10',
  'interations'              = '100',
  'format'                   = 'json');


CREATE SOURCE CONNECTOR datagen_salesconversion_orders WITH (
  'connector.class'          = 'io.confluent.kafka.connect.datagen.DatagenConnector',
  'kafka.topic'              = 'orders',
  'schema.filename'          = '/scripts/orders_schema.avro', 
  'schema.keyfield'          = 'productid',
  'maxInterval'              = '20',
  'interations'              = '1000000',
  'format'                   = 'json');

CREATE SOURCE CONNECTOR datagen_salesconversion_weblogs WITH (
  'connector.class'          = 'io.confluent.kafka.connect.datagen.DatagenConnector',
  'kafka.topic'              = 'weblogs',
  'schema.filename'          = '/scripts/weblogs_schema.avro', 
  'schema.keyfield'          = 'request',
  'maxInterval'              = '1',
  'interations'              = '10000000',
  'format'                   = 'json');
