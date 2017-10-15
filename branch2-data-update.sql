insert into prices (productid, value, startdate) values
  (1, 100.00, '01-01-2017 00:00:00'),
  (8, 150.00, '01-01-2017 00:00:00'),
  (6, 200.00, '01-01-2017 00:00:00');

update orders set completeddate = '02-04-2017 00:00:00' where id = 5;