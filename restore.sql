-- For 'target_branch' selects all data from storage that happened before 'migration_date'
-- and inserts it into restoration database.
CREATE OR REPLACE FUNCTION restore_by_date(target_branch INT, migration_date TIMESTAMP) RETURNS VOID AS $PROC$
DECLARE
  products_cursor CURSOR FOR
    SELECT
      p.oldid as oldid, p.pricestartdate as pricestartdate, p.price as price
    FROM public.products p
    WHERE p.pricestartdate < migration_date AND p.branch = target_branch;

  order_cursor CURSOR FOR
    SELECT
      o.oldid as oldid, o.productid as productid,
      o.amount as amount, o.createddate as createddate,
      o.paymentreceiveddate as paymentreceiveddate, o.completeddate as completeddate,
      o.canceleddate as canceleddate, o.refunddate as refunddate
    FROM public.orders o
    WHERE o.createddate < migration_date
      AND (o.paymentreceiveddate IS NULL OR o.paymentreceiveddate < migration_date)
      AND (o.completeddate IS NULL OR o.completeddate < migration_date)
      AND (o.canceleddate IS NULL OR o.canceleddate < migration_date)
      AND (o.refunddate IS NULL OR o.refunddate < migration_date)
      AND o.branch = target_branch;

  price_id BIGINT = 1;
  order_product_id BIGINT = 1;
BEGIN
  FOR iter IN products_cursor LOOP
    INSERT
    INTO restore_schema.prices (
      id, productid, value, startdate
    ) VALUES (
      price_id, iter.oldid, iter.price, iter.pricestartdate
    );
  price_id := price_id + 1;
  END LOOP;

  FOR iter IN order_cursor LOOP
    IF EXISTS (SELECT 1 FROM restore_schema.orders ord WHERE ord.id = iter.oldid) THEN
      UPDATE restore_schema.orders ord SET
        createddate = iter.createddate,
        paymentreceiveddate = iter.paymentreceiveddate,
        completeddate = iter.completeddate,
        canceleddate = iter.canceleddate,
        refunddate = iter.refunddate
      WHERE ord.id = iter.oldid;
    ELSE
      INSERT
        INTO restore_schema.orders (
          id, createddate, paymentreceiveddate,
          completeddate, canceleddate, refunddate
        ) VALUES (
          iter.oldid, iter.createddate, iter.paymentreceiveddate,
          iter.completeddate, iter.canceleddate, iter.refunddate
        ) ON CONFLICT DO NOTHING;
    END IF;

    INSERT
    INTO restore_schema.order_product (
      id, productid, orderid, amount
    ) VALUES (
      order_product_id, iter.productid, iter.oldid, iter.amount
    );
    order_product_id := order_product_id + 1;
  END LOOP;
END;
$PROC$ LANGUAGE plpgsql;

-- Selects migration date from 'migration_log' based on 'target_migration'.
CREATE OR REPLACE FUNCTION restore(target_branch INT, target_migration INT) RETURNS VOID AS $PROC$
DECLARE
  target_migration_date TIMESTAMP;
BEGIN
  SELECT migration_date INTO target_migration_date FROM migration_log WHERE id = target_migration LIMIT 1;
  PERFORM restore_by_date(target_branch, target_migration_date);
END;
$PROC$ LANGUAGE plpgsql;

-- Entry point for branch restoration from snapshot script.
-- Restores 'target_branch' snapshot since 'target_migration'.
-- Terminal usage example: 'psql -f restore.sql -v target_branch=1 -v target_migration=2'.
SELECT restore(:target_branch, :target_migration);