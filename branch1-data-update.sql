insert into prices (productid, value, startdate) values
  (2, 100.00, '01-01-2017 00:00:00'),
  (5, 150.00, '01-01-2017 00:00:00'),
  (9, 200.00, '01-01-2017 00:00:00');

insert into orders (createddate, paymentreceiveddate, completeddate, canceleddate, refunddate) values
  ('01-02-2017 00:00:00', '01-02-2017 00:01:00', '01-03-2017 00:00:00', null, null),
  ('01-02-2017 00:00:00', '01-02-2017 00:01:00', null, '01-03-2017 00:00:00', null);

update orders set refunddate = '02-04-2017 00:00:00' where id = 1;