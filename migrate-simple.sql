CREATE OR REPLACE FUNCTION migrate_sells() RETURNS VOID AS $PROC$
DECLARE
  schema1_cursor CURSOR FOR
    SELECT
      o.id as oid, o.createddate as ocrdate, o.paymentreceiveddate as oprdate,
      o.completeddate as ocodate, o.canceleddate as ocadate, o.refunddate as orfdate,
      op.productid as oppid, op.amount as opam
    FROM branch1_schema.order_product op
      JOIN branch1_schema.orders o on op.orderid = o.id;

  schema2_cursor CURSOR FOR
    SELECT
      o.id as oid, o.createddate as ocrdate, o.paymentreceiveddate as oprdate,
      o.completeddate as ocodate, o.canceleddate as ocadate, o.refunddate as orfdate,
      op.productid as oppid, op.amount as opam
    FROM branch2_schema.order_product op
      JOIN branch2_schema.orders o on op.orderid = o.id;
BEGIN
  FOR iter IN schema1_cursor LOOP
    INSERT
      INTO orders (
          productid, amount, branch,
          createddate, paymentreceiveddate, completeddate,
          canceleddate, refunddate
      ) VALUES (
          iter.oppid, iter.opam, 1,
          iter.ocrdate, iter.oprdate, iter.ocodate,
          iter.ocadate, iter.orfdate
      );
  END LOOP;

  FOR iter IN schema2_cursor LOOP
    INSERT
    INTO orders (
      productid, amount, branch,
      createddate, paymentreceiveddate, completeddate,
      canceleddate, refunddate
    ) VALUES (
      iter.oppid, iter.opam, 2,
      iter.ocrdate, iter.oprdate, iter.ocodate,
      iter.ocadate, iter.orfdate
    );
  END LOOP;
END;
$PROC$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION migrate_simple() RETURNS VOID AS $PROC$
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
    JOIN branch1_schema.manufacturers man ON p.manufacturerid = man.id;

  schema2_cursor CURSOR FOR
    SELECT
      p.id as pid, p.name as pname, p.description as pdescr,
      pr.value as prval, pr.startdate as prstartd,
      man.name as manname, man.website as manweb, man.address as manaddr,
      cat.name as catname
    FROM branch2_schema.prices pr
      JOIN branch2_schema.products p ON pr.productid = p.id
      JOIN branch2_schema.categories cat ON p.categoryid = cat.id
      JOIN branch2_schema.manufacturers man ON p.manufacturerid = man.id;
BEGIN
  -- Purge old data --
  -- TODO we can go without it --
  DELETE FROM orders WHERE id > 0;
  DELETE FROM products WHERE id > 0;
  -- End Purge old data --

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

  PERFORM migrate_sells();
END;
$PROC$ LANGUAGE plpgsql;

SELECT migrate_simple();