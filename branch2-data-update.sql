insert into prices (productid, value, startdate) values
  (1, 100.00, clock_timestamp()),
  (8, 150.00, clock_timestamp()),
  (6, 200.00, clock_timestamp());

update orders set completeddate = clock_timestamp() where id = 5;