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

  intermediate RECORD;
BEGIN
  -- Purge old data --
  -- TODO we can go without it --
  DELETE FROM orders WHERE id > 0;
  DELETE FROM products WHERE id > 0;
  DELETE FROM products_merge WHERE id > 0;
  -- End Purge old data --

  FOR iter IN schema1_cursor LOOP
    INSERT
      INTO products_merge (oldid, branch)
      VALUES (iter.pid, 1) RETURNING id INTO intermediate;

    INSERT
      INTO products (
          id, name, description,
          price, pricestartdate, category,
          manufacturer, manufacturerwebsite, manufactureraddress
        ) VALUES (
          intermediate.id, iter.pname, iter.pdescr, iter.prval,
          iter.prstartd, iter.catname, iter.manname,
          iter.manweb, iter.manaddr
        );
--     RAISE NOTICE 'Value: %', intermediate;
  END LOOP;
END;
$PROC$ LANGUAGE plpgsql;

SELECT migrate_simple();