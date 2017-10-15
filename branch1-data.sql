insert into prices (productid, value, startdate) values
  (2, 100.00, '01-01-2017 00:00:00'),
  (5, 150.00, '01-01-2017 00:00:00'),
  (9, 200.00, '01-01-2017 00:00:00'),
  (3, 110.00, '01-01-2017 00:00:00'),
  (1, 120.00, '01-01-2017 00:00:00'),
  (4, 110.00, '01-01-2017 00:00:00'),
  (6, 130.00, '01-01-2017 00:00:00'),
  (7, 110.00, '01-01-2017 00:00:00'),
  (8, 120.00, '01-01-2017 00:00:00'),
  (3, 100.00, '02-01-2017 00:00:00'),
  (1, 130.00, '03-01-2017 00:00:00'),
  (4, 120.00, '04-01-2017 00:00:00'),
  (6, 140.00, '05-01-2017 00:00:00');

insert into orders (createddate, paymentreceiveddate, completeddate, canceleddate, refunddate) values
  ('01-02-2017 00:00:00', '01-02-2017 00:01:00', '01-03-2017 00:00:00', null, null),
  ('01-02-2017 00:00:00', '01-02-2017 00:01:00', null, '01-03-2017 00:00:00', null),
  ('01-03-2017 00:00:00', null, null, '01-03-2017 00:00:00', null),
  ('02-03-2017 00:00:00', '02-03-2017 00:00:00', null, '02-03-2017 00:00:00', '02-04-2017 00:00:00'),
  ('02-03-2017 00:00:00', null, null, null, null);

insert into order_product (productid, orderid, amount) values
  (2, 1, 2),
  (4, 1, 3),
  (1, 2, 1),
  (4, 3, 1),
  (2, 4, 2),
  (6, 5, 1),
  (7, 5, 2);