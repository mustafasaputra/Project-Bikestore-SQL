-- 1. SHOW PRODUCTS IN EACH BRAND
	SELECT 	pp.product_name,
		pb.brand_name,
		pc.category_name
	FROM production_products pp
	JOIN production_brands pb 
		ON (pb.brand_id = pp.brand_id)
	JOIN production_categories pc 
		ON (pc.category_id = pp.category_id)
	ORDER BY pb.brand_name ASC;

-- 2. FIND THE NUMBER OF ITEMS IN THE PRODUCT
	SELECT COUNT(*) AS num_items
	FROM (
		SELECT 	pp.product_name,
			pb.brand_name,
			pc.category_name
		FROM production_products pp
		JOIN production_brands pb 
			ON (pb.brand_id = pp.brand_id)
		JOIN production_categories pc 
			ON (pc.category_id = pp.category_id)
		ORDER BY pb.brand_name ASC
	) AS num_items;
            
-- 3. SHOW THE NUMBER OF PRODUCTS FOR EACH BRAND
	SELECT	pb.brand_name,	
		count(product_name) AS total_products
	FROM production_products pp
	JOIN production_brands pb
		ON pb.brand_id = pp.brand_id
	GROUP BY brand_name;

-- 4. WHAT ARE THE LEAST AND MOST EXPENSIVE ITEMS ON THE PRODUCTS
	SELECT 	pp.product_name,
		pb.brand_name,
		pc.category_name,
		pp.list_price
	FROM production_products pp
	JOIN production_brands pb 
		ON (pb.brand_id = pp.brand_id)
	JOIN production_categories pc 
		ON (pc.category_id = pp.category_id)
	WHERE list_price = (SELECT MIN(list_price) FROM production_products) 
						OR 
						list_price = (SELECT MAX(list_price) FROM production_products);
                        
-- 5. WHAT IS THE AVERAGE PRICE WITHIN EACH BRAND
	SELECT 	pb.brand_name,
		AVG(list_price) AS avg_price
	FROM production_products pp
	JOIN production_brands pb
		ON pb.brand_id = pp.brand_id
	GROUP BY brand_name;

-- 6. WHAT IS THE DATE RANGE OF THE SALES TRANSACTION
	SELECT 	MIN(order_date) AS min_order_date,
		MAX(order_date) AS max_order_date
	FROM sales_orders;

-- 7. HOW MANY ORDERS WERE MADE WITHIN THIS DATE RANGE?
	SELECT COUNT(DISTINCT order_id) AS total_order
	FROM (
		SELECT 	sales_order_items.order_id,
			production_products.product_name
		FROM sales_order_items
		JOIN production_products
			ON production_products.product_id = sales_order_items.product_id) AS total_orders;

-- 8. HOW MANY ITEMS WERE ORDERED WITHIN THIS DATE RANGE?
	SELECT SUM(quantity) AS total_items
	FROM (
		SELECT sales_orders.order_id,
			production_products.product_name,
			sales_order_items.quantity
		FROM sales_orders
		JOIN sales_order_items
			ON sales_order_items.order_id = sales_orders.order_id
		JOIN production_products
			ON production_products.product_id = sales_order_items.product_id) AS total_items;

-- 9. WHAT ARE THE LEAST AND MOST ORDERED PRODUCTS? WHAT BRAND DOES THE PRODUCT BELONG TO?
	WITH LMO AS (
	SELECT 	so.order_id,
		pp.product_name,
		pb.brand_name,
		si.quantity
	FROM sales_orders so
	JOIN sales_order_items si
		ON si.order_id = so.order_id
	JOIN production_products pp
		ON pp.product_id = si.product_id
	JOIN production_brands pb
		ON pb.brand_id = pp.brand_id
	)
	SELECT 	product_name,
		brand_name,
        	SUM(quantity) AS num_products
	FROM LMO
	GROUP BY product_name, brand_name
	ORDER BY num_products DESC;

-- 10. WHAT WERE THE TOP 5 ORDERS THAT SPEND THE MOST MONEY?
	WITH TopOrders AS (
	SELECT	so.order_id, ss.store_name, so.order_date, so.order_status, ss.city, ss.street, 
		pp.product_name, pb.brand_name, pc.category_name, pp.model_year, 
		si.quantity, si.list_price, si.discount,
                (si.quantity * si.list_price) - (si.quantity * si.list_price * si.discount) AS total_price
	FROM sales_customers sc
	JOIN sales_orders so ON (sc.customer_id = so.customer_id)
	JOIN sales_order_items si ON (si.order_id = so.order_id)
	JOIN sales_stores ss ON (ss.store_id = so.store_id)
	JOIN production_products pp ON (pp.product_id = si.product_id)
	JOIN production_brands pb ON (pb.brand_id = pp.brand_id)
	JOIN production_categories pc ON (pc.category_id = pp.category_id)
    	)
   	 SELECT order_id,
		SUM(total_price) AS total_spend
    	FROM TopOrders
    	GROUP BY order_id
    	ORDER BY total_spend DESC
    	LIMIT 5;
    
-- 11. VIEW THE DETAILS OF THE HIGHEST SPEND ORDER. WHAT INSIGHTS CAN YOU GATHER FROM THE RESULTS?
	WITH HighestSpendOrder AS (
	SELECT	so.order_id, ss.store_name, so.order_date, so.order_status, ss.city, ss.street, 
		pp.product_name, pb.brand_name, pc.category_name, pp.model_year, 
		si.quantity, si.list_price, si.discount,
                (si.quantity * si.list_price) - (si.quantity * si.list_price * si.discount) AS total_price
	FROM sales_customers sc
	JOIN sales_orders so ON (sc.customer_id = so.customer_id)
	JOIN sales_order_items si ON (si.order_id = so.order_id)
	JOIN sales_stores ss ON (ss.store_id = so.store_id)
	JOIN production_products pp ON (pp.product_id = si.product_id)
	JOIN production_brands pb ON (pb.brand_id = pp.brand_id)
	JOIN production_categories pc ON (pc.category_id = pp.category_id)
    	)
	SELECT *
    	FROM HighestSpendOrder
   	WHERE order_id = 1541;
    
-- 12. VIEW THE DETAILS OF THE TOP 5 HIGHEST SPEND ORDER. WHAT INSIGHTS CAN YOU GATHER FROM THE RESULTS?
	WITH HighestSpendOrder AS (
	SELECT	so.order_id,
		ss.store_name,
		so.order_date,
		so.order_status,
		ss.city,
		ss.street, 
		pp.product_name, 
		pb.brand_name, 
		pc.category_name, 
		pp.model_year, 
		si.quantity, 
		si.list_price,
		si.discount,
                (si.quantity * si.list_price) - (si.quantity * si.list_price * si.discount) AS total_price
	FROM sales_customers sc
	JOIN sales_orders so
		ON (sc.customer_id = so.customer_id)
	JOIN sales_order_items si 
		ON (si.order_id = so.order_id)
	JOIN sales_stores ss
		ON (ss.store_id = so.store_id)
	JOIN production_products pp 
		ON (pp.product_id = si.product_id)
	JOIN production_brands pb
		ON (pb.brand_id = pp.brand_id)
	JOIN production_categories pc 
		ON (pc.category_id = pp.category_id)
    	)
	SELECT *
    	FROM HighestSpendOrder
    	WHERE order_id IN (1541, 937, 1506, 1482, 1364);
    

    


        

		


