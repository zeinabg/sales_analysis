WITH
-- top 20 product categories	
TopCategory AS (
SELECT 
   	pc.category_id,
    COALESCE(SUM(product_list_price*(1-s.discount)),0) AS total_TopCategory
FROM 
    Sales s 
    LEFT JOIN Products pr
      ON pr.product_id = s.product_id
    JOIN Product_Category pc
      ON pr.product_id = pc.product_id
GROUP BY pc.category_id
ORDER BY total_TopCategory DESC
LIMIT 20
),

-- rank by category
rank_category AS (
	SELECT
         ROW_NUMBER() OVER (ORDER BY total_TopCategory DESC) AS rank_category,
         category_id,
         total_TopCategory
    FROM 
	     TopCategory
),

-- top 20 customers
TopCustomers AS (
  SELECT 
	  cu.customer_id,
	  COALESCE(SUM(product_list_price*(1-s.discount)),0) AS total_TopCustomers
  FROM 
	  Customers cu
	  LEFT JOIN Sales s
	    ON cu.customer_id = s.customer_id
	  LEFT JOIN Products pr 
	    ON pr.product_id = s.product_id
  GROUP BY cu.customer_id
  ORDER BY total_TopCustomers DESC
  LIMIT 20
),

-- rank by customer
rank_customer AS (
	SELECT
         ROW_NUMBER() OVER (ORDER BY total_TopCustomers DESC) AS rank_customer,
         customer_id,
         total_TopCustomers
    FROM 
	     TopCustomers
),

-- category-aware sales
ProductSales AS (
  SELECT
    s.customer_id,
    s.product_id,
    pc.category_id,
    s.product_quantity,
    s.discount,
	s.sales_id,
    pr.product_list_price
  FROM
    Sales s
    JOIN Products pr
	  ON s.product_id = pr.product_id
	JOIN Product_Category pc
      ON pr.product_id = pc.product_id
      
)

SELECT 
	 rank_category.category_id, 
	 rank_category.rank_category,
	 rank_customer.customer_id,
	 rank_customer.rank_customer,
	 COALESCE(SUM(s.product_quantity),0) AS quantity,
	 COALESCE(SUM(s.product_list_price*(1-s.discount)),0) AS dollar_value
  
FROM 
  rank_customer
 CROSS JOIN
  rank_category
 LEFT JOIN 
  ProductSales s 
	ON rank_customer.customer_id = s.customer_id
	AND rank_category.category_id = s.category_id
GROUP BY
  rank_category.category_id,
  rank_category.rank_category, 
  rank_customer.customer_id,
  rank_customer.rank_customer
ORDER BY 
  rank_customer.rank_customer,
  rank_category.rank_category;
