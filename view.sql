CREATE OR REPLACE VIEW DATAMART AS
  SELECT
    p.name as name,
    SUM(o.amount) as sold,
    p.branch as branch,
    SUM(p.price * o.amount) as income
  FROM orders o
    JOIN products p ON o.branch = p.branch
      AND o.productid = p.oldid
      AND p.pricestartdate = (SELECT max(p2.pricestartdate)
                              FROM products p2
                              WHERE p2.pricestartdate < o.createddate
                                AND p2.id = p.id
                              LIMIT 1)
    WHERE o.canceleddate IS NULL AND o.refunddate is NULL
    GROUP BY p.name, p.branch