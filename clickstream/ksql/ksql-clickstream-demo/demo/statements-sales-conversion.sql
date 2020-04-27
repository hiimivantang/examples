-- Product id lookup for url
CREATE TABLE product_ids (rowkey STRING KEY, productid varchar, request varchar) with (key='request', kafka_topic = 'productids', value_format = 'json');


-- Orders
CREATE STREAM orders (_time bigint, orderid int, productid varchar, orderunits int, address STRUCT<city varchar, state varchar, zipcode bigint>) with (kafka_topic = 'orders', value_format = 'json', timestamp = '_time'); 


-- Web logs
CREATE STREAM weblogs (ip varchar, userid int, remote_user varchar, _time bigint, request varchar, status varchar, bytes varchar, referrer varchar, agent varchar) with (kafka_topic = 'weblogs', value_format = 'json', timestamp = '_time');


create stream enriched_orders as select productid, orderid, orderunits from orders partition by productid;

-- Enrich web logs with product id
CREATE STREAM enriched_weblogs AS SELECT c.productid as productid, c.request, status, userid, ip, agent from weblogs l INNER JOIN product_ids c on l.request = c.request PARTITION BY productid;


-- Derive view count per 60 secs window  for enriched weblogs
CREATE TABLE views_per_product AS SELECT CAST(WINDOWEND as STRING) + '_' + CAST(productid as STRING) AS KEY, WINDOWEND AS event_ts, productid, count(*) AS views_per_period from enriched_weblogs WINDOW HOPPING (SIZE 60 SECONDS, ADVANCE BY 5 SECONDS)  GROUP BY productid EMIT CHANGES;

-- Derive order count per 60 secs window for enriched orders
CREATE TABLE orders_per_product AS SELECT CAST(WINDOWEND as STRING) + '_' + CAST(productid as STRING) AS KEY, WINDOWEND as event_ts, productid, count_distinct(orderid) AS orders_per_period from orders WINDOW HOPPING ( size 60 second, advance by 5  second) GROUP BY productid EMIT CHANGES;


CREATE TABLE raw_views_output (ROWKEY STRING key, productid varchar, event_ts bigint, views_per_period int) WITH (kafka_topic='VIEWS_PER_PRODUCT', value_format= 'json');


CREATE TABLE raw_orders_output (ROWKEY STRING key, productid varchar, event_ts bigint, orders_per_period int) WITH (kafka_topic='ORDERS_PER_PRODUCT', value_format= 'json');


-- Join above two tables and calculate conversion rate
CREATE TABLE product_conversion_rate as select l.event_ts as EVENT_TS, l.productid, l.views_per_period, r.orders_per_period, cast(l.views_per_period as DOUBLE)/cast(r.orders_per_period as DOUBLE) as conversion_rate from raw_views_output l left join raw_orders_output r on l.ROWKEY=r.ROWKEY emit changes;


