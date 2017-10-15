insert into prices (productid, value, startdate) values
  (2, 120.00, '01-01-2017 00:00:00'),
  (5, 170.00, '01-01-2017 00:00:00'),
  (9, 220.00, '01-01-2017 00:00:00'),
  (3, 130.00, '01-01-2017 00:00:00'),
  (1, 150.00, '01-01-2017 00:00:00'),
  (4, 130.00, '01-01-2017 00:00:00'),
  (6, 150.00, '01-01-2017 00:00:00'),
  (7, 130.00, '01-01-2017 00:00:00'),
  (8, 140.00, '01-01-2017 00:00:00');

insert into orders (createddate, paymentreceiveddate, completeddate, canceleddate, refunddate) values
  ('01-02-2017 00:00:00', '01-02-2017 00:01:00', '01-03-2017 00:00:00', null, null),
  ('01-02-2017 00:00:00', '01-02-2017 00:01:00', null, '01-03-2017 00:00:00', null),
  ('01-03-2017 00:00:00', null, null, '01-03-2017 00:00:00', null),
  ('02-03-2017 00:00:00', '02-03-2017 00:00:00', null, '02-03-2017 00:00:00', '02-04-2017 00:00:00'),
  ('02-03-2017 00:00:00', null, null, null, null);

insert into order_product (productid, orderid, amount) values
  (5, 1, 2),
  (9, 1, 3),
  (3, 2, 1),
  (7, 3, 1),
  (6, 4, 2),
  (2, 5, 1),
  (1, 5, 2);