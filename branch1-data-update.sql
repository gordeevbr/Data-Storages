insert into prices (productid, value, startdate) values
  (2, 100.00, clock_timestamp()),
  (5, 150.00, clock_timestamp()),
  (9, 200.00, clock_timestamp());

insert into orders (createddate, paymentreceiveddate, completeddate, canceleddate, refunddate) values
  (clock_timestamp(), clock_timestamp(), clock_timestamp(), null, null),
  (clock_timestamp(), clock_timestamp(), null, clock_timestamp(), null);

insert into order_product (productid, orderid, amount) VALUES
  (2, 6, 1),
  (5, 7, 3);

update orders set refunddate = clock_timestamp() where id = 1;