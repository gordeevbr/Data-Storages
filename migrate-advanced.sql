-- Migrates all new product prices from both branches since 'last_migration' timestamp.
CREATE OR REPLACE FUNCTION migrate_advanced_products(last_migration TIMESTAMP) RETURNS VOID AS $PROC$
DECLARE
  schema1_cursor CURSOR FOR
    SELECT
      p.id as pid, p.name as pname, p.description as pdescr,
      pr.value as prval, pr.startdate as prstartd,
      man.name as manname, man.website as manweb, man.address as manaddr,
      cat.name as catname
    FROM branch1_schema.prices pr
      JOIN branch1_schema.products p ON pr.productid = p.id
      JOIN branch1_schema.categories cat ON p.categoryid = cat.id
      JOIN branch1_schema.manufacturers man ON p.manufacturerid = man.id
    WHERE pr.startdate > last_migration;

  schema2_cursor CURSOR FOR
    SELECT
      p.id as pid, p.name as pname, p.description as pdescr,
      pr.value as prval, pr.startdate as prstartd,
      man.name as manname, man.website as manweb, man.address as manaddr,
      cat.name as catname
    FROM branch2_schema.prices pr
      JOIN branch2_schema.products p ON pr.productid = p.id
      JOIN branch2_schema.categories cat ON p.categoryid = cat.id
      JOIN branch2_schema.manufacturers man ON p.manufacturerid = man.id
    WHERE pr.startdate > last_migration;
BEGIN
  FOR iter IN schema1_cursor LOOP
    INSERT
    INTO products (
      oldid, name, description, price,
      pricestartdate, category, manufacturer,
      manufacturerwebsite, manufactureraddress, branch
    ) VALUES (
      iter.pid, iter.pname, iter.pdescr, iter.prval,
      iter.prstartd, iter.catname, iter.manname,
      iter.manweb, iter.manaddr, 1
    );
  END LOOP;

  FOR iter IN schema2_cursor LOOP
    INSERT
    INTO products (
      oldid, name, description, price,
      pricestartdate, category, manufacturer,
      manufacturerwebsite, manufactureraddress, branch
    ) VALUES (
      iter.pid, iter.pname, iter.pdescr, iter.prval,
      iter.prstartd, iter.catname, iter.manname,
      iter.manweb, iter.manaddr, 2
    );
  END LOOP;
END;
$PROC$ LANGUAGE plpgsql;

-- Migrates all old orders from both branches which were updated since 'last_migration' timestamp.
-- (order creation date is sooner than 'last_migration' but any other date is later)
CREATE OR REPLACE FUNCTION migrate_advanced_sells_update(last_migration TIMESTAMP) RETURNS VOID AS $PROC$
DECLARE
    schema1_cursor CURSOR FOR
    SELECT
      o.id as oldid, o.createddate as ocrdate, o.paymentreceiveddate as oprdate,
      o.completeddate as ocodate, o.canceleddate as ocadate, o.refunddate as orfdate,
      op.productid as oppid, op.amount as opam
    FROM branch1_schema.order_product op
      JOIN branch1_schema.orders o on op.orderid = o.id
    WHERE o.createddate < last_migration AND (
      o.paymentreceiveddate > last_migration
      OR o.completeddate > last_migration
      OR o.canceleddate > last_migration
      OR o.refunddate > last_migration
    );

    schema2_cursor CURSOR FOR
    SELECT
      o.id as oldid, o.createddate as ocrdate, o.paymentreceiveddate as oprdate,
      o.completeddate as ocodate, o.canceleddate as ocadate, o.refunddate as orfdate,
      op.productid as oppid, op.amount as opam
    FROM branch2_schema.order_product op
      JOIN branch2_schema.orders o on op.orderid = o.id
    WHERE o.createddate < last_migration AND (
      o.paymentreceiveddate > last_migration
      OR o.completeddate > last_migration
      OR o.canceleddate > last_migration
      OR o.refunddate > last_migration
    );
BEGIN
  FOR iter IN schema1_cursor LOOP
    INSERT
    INTO orders (
      productid, amount, branch,
      createddate, paymentreceiveddate, completeddate,
      canceleddate, refunddate, oldid
    ) VALUES (
      iter.oppid, iter.opam, 1,
      iter.ocrdate, iter.oprdate, iter.ocodate,
      iter.ocadate, iter.orfdate, iter.oldid
    );
  END LOOP;

  FOR iter IN schema2_cursor LOOP
    INSERT
    INTO orders (
      productid, amount, branch,
      createddate, paymentreceiveddate, completeddate,
      canceleddate, refunddate, oldid
    ) VALUES (
      iter.oppid, iter.opam, 2,
      iter.ocrdate, iter.oprdate, iter.ocodate,
      iter.ocadate, iter.orfdate, iter.oldid
    );
  END LOOP;
END;
$PROC$ LANGUAGE plpgsql;

-- Migrates all new orders from both branches since 'last_migration' timestamp.
CREATE OR REPLACE FUNCTION migrate_advanced_sells_insert(last_migration TIMESTAMP) RETURNS VOID AS $PROC$
DECLARE
  schema1_cursor CURSOR FOR
    SELECT
      o.id as oldid, o.createddate as ocrdate, o.paymentreceiveddate as oprdate,
      o.completeddate as ocodate, o.canceleddate as ocadate, o.refunddate as orfdate,
      op.productid as oppid, op.amount as opam
    FROM branch1_schema.order_product op
      JOIN branch1_schema.orders o on op.orderid = o.id
    WHERE o.createddate > last_migration;

  schema2_cursor CURSOR FOR
    SELECT
      o.id as oldid, o.createddate as ocrdate, o.paymentreceiveddate as oprdate,
      o.completeddate as ocodate, o.canceleddate as ocadate, o.refunddate as orfdate,
      op.productid as oppid, op.amount as opam
    FROM branch2_schema.order_product op
      JOIN branch2_schema.orders o on op.orderid = o.id
    WHERE o.createddate > last_migration;
BEGIN
  FOR iter IN schema1_cursor LOOP
    INSERT
    INTO orders (
      productid, amount, branch,
      createddate, paymentreceiveddate, completeddate,
      canceleddate, refunddate, oldid
    ) VALUES (
      iter.oppid, iter.opam, 1,
      iter.ocrdate, iter.oprdate, iter.ocodate,
      iter.ocadate, iter.orfdate, iter.oldid
    );
  END LOOP;

  FOR iter IN schema2_cursor LOOP
    INSERT
    INTO orders (
      productid, amount, branch,
      createddate, paymentreceiveddate, completeddate,
      canceleddate, refunddate, oldid
    ) VALUES (
      iter.oppid, iter.opam, 2,
      iter.ocrdate, iter.oprdate, iter.ocodate,
      iter.ocadate, iter.orfdate, iter.oldid
    );
  END LOOP;
END;
$PROC$ LANGUAGE plpgsql;

-- Selects the last migration date
-- (or the start of UNIX epoch if this is the first migration),
-- migrates all new data since that date from both branches
-- and then updates the migration log.
CREATE OR REPLACE FUNCTION migrate_advanced() RETURNS VOID AS $PROC$
DECLARE
  last_migration TIMESTAMP;
BEGIN
  SELECT migration_date INTO last_migration
    FROM migration_log
    ORDER BY migration_date DESC
    LIMIT 1;

  IF last_migration IS NULL THEN
    last_migration = '01-01-1970 00:00:00'::TIMESTAMP;
  END IF;

  PERFORM migrate_advanced_products(last_migration);
  PERFORM migrate_advanced_sells_update(last_migration);
  PERFORM migrate_advanced_sells_insert(last_migration);

  INSERT INTO migration_log (migration_date) VALUES (clock_timestamp());
END;
$PROC$ LANGUAGE plpgsql;

-- Entry point for migration script.
-- Selects all new data since previous migration from both branches and inserts it into storage.
SELECT migrate_advanced();