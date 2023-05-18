/* Formatted on 4/25/2023 8:22:55 PM (QP5 v5.139.911.3011) */
WITH tab AS (SELECT customer_id,
                    recency,
                    monetary,
                    frequancy,
                    fm,
                    r_score,
                    fm_score,
                    r_score + fm_score AS t_score
               FROM (SELECT DISTINCT
                            customer_id,
                            recency,
                            monetary,
                            frequancy,
                            fm,
                            NTILE (5) OVER (ORDER BY recency DESC) AS r_score,
                            NTILE (5) OVER (ORDER BY fm) AS fm_score
                       FROM (SELECT DISTINCT
                                    customer_id,
                                    recency,
                                    monetary,
                                    frequancy,
                                    CAST (
                                       (monetary + frequancy) / 2 AS INTEGER)
                                       AS fm
                               FROM (SELECT DISTINCT
                                            customer_id,
                                            invoicedate,
                                            CAST (
                                               TO_DATE (
                                                  '12/09/2011 16:04:00',
                                                  'MM/DD/YYYY HH24:MI:SS')
                                               - MAX (
                                                    TO_DATE (
                                                       invoicedate,
                                                       'MM/DD/YYYY HH24:MI'))
                                                 OVER (
                                                    PARTITION BY customer_id) AS INTEGER)
                                               AS recency,
                                            SUM (price*quantity)
                                            OVER (PARTITION BY customer_id)
                                               AS monetary,
                                            COUNT (*)
                                            OVER (PARTITION BY customer_id)
                                               AS frequancy
                                       FROM tableretail))))
SELECT customer_id,
       recency,
       monetary,
       frequancy,
       fm,
       r_score,
       fm_score,
       t_score,
       CASE
          WHEN r_score = 5 AND fm_score > 4
          THEN
             'Champions'
          WHEN r_score = 4 AND fm_score = 5
          THEN
             'Champions'
          --
       WHEN r_score = 5 AND fm_score = 3
          THEN
             'Loyal Customer'
          WHEN r_score = 4 AND fm_score = 4
          THEN
             'Loyal Customer'
          WHEN r_score = 3 AND fm_score = 5
          THEN
             'Loyal Customer'
          WHEN r_score = 3 AND fm_score = 4
          THEN
             'Loyal Customer'
          --
       WHEN r_score = 5 AND fm_score = 2
          THEN
             'Potential Loyal List'
          WHEN r_score = 4 AND fm_score = 2
          THEN
             'Potential Loyal List'
          WHEN r_score = 3 AND fm_score = 3
          THEN
             'Potential Loyal List'
          WHEN r_score = 4 AND fm_score = 3
          THEN
             'Potential Loyal List'
          --
       WHEN r_score = 5 AND fm_score = 1
          THEN
             'Recent Customer'
          --
       WHEN r_score = 4 AND fm_score = 1
          THEN
             'Promising Customer'
          WHEN r_score = 3 AND fm_score = 1
          THEN
             'Promising Customer'
          --
       WHEN r_score = 3 AND fm_score = 2
          THEN
             'Customers needing attention'
          WHEN r_score = 2 AND fm_score = 3
          THEN
             'Customers needing attention'
          WHEN r_score = 2 AND fm_score = 2
          THEN
             'Customers needing attention'
          --
       WHEN r_score = 2 AND fm_score = 5
          THEN
             'At Risk'
          WHEN r_score = 2 AND fm_score = 4
          THEN
             'At Risk'
          WHEN r_score = 1 AND fm_score = 3
          THEN
             'At Risk'
          --
       WHEN r_score = 1 AND fm_score = 5
          THEN
             'Can,t Lose Them'
          WHEN r_score = 1 AND fm_score = 4
          THEN
             'Can,t Lose Them'
          --
       WHEN r_score = 1 AND fm_score = 2
          THEN
             'hibernating'
          --
       WHEN r_score = 1 AND fm_score = 1
          THEN
             'Lost'
          ELSE
             'About To Sleep'
       END
       as "Category"
  FROM tab
  
  
  
 ------------------------------------------------------------------------- 
SELECT customer_id FROM tableretail