insert into categories (name) values
  ('motherboards'),
  ('CPUs'),
  ('GPUs');

insert into manufacturers (name, website, address) values
  ('ASUS', 'asus.com', null),
  ('AMD', 'amd.com', null),
  ('Intel', 'intel.com', null);

insert into products (name, description, categoryid, manufacturerid) values
  ('Core i3', 'An Intel CPU', 2, 3),
  ('Core i5', 'An Intel CPU', 2, 3),
  ('Core i7', 'An Intel CPU', 2, 3),
  ('Q170', 'An Asus motherboard', 1, 1),
  ('B250', 'An Asus motherboard', 1, 1),
  ('H110', 'An Asus motherboard', 1, 1),
  ('Radeon HD 4000', 'An AMD GPU', 3, 2),
  ('Radeon HD 7000', 'An AMD GPU', 3, 2),
  ('Radeon R9 270', 'An AMD GPU', 3, 2);
