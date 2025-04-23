alter table production_products
add constraint fk_production_products
	foreign key (brand_id) references production_brands (brand_id);
    
alter table production_products
add constraint fk_production_products_category
	foreign key (category_id) references production_categories (category_id);
    
alter table production_stocks
add constraint fk_production_stocks_store
	foreign key (store_id) references sales_stores (store_id)
    on delete cascade on update cascade;
    
alter table production_stocks
add constraint fk_production_stocks_product
	foreign key (product_id) references production_products (product_id)
    on delete cascade on update cascade;
    
alter table sales_orders
add constraint fk_sales_orders_customer
	foreign key (customer_id) references sales_customers (customer_id) on delete cascade on update cascade;
    
alter table sales_orders
add constraint fk_sales_orders_store
	foreign key (store_id) references sales_stores (store_id) on delete cascade on update cascade;
    
alter table sales_orders
add constraint fk_sales_orders_staff
	foreign key (staff_id) references sales_staffs (staff_id) on delete cascade on update cascade;
    
alter table sales_orders
add constraint fk_sales_orders_order
	foreign key (order_id) references sales_order_items (order_id) on delete cascade on update cascade;
    
alter table sales_staffs
add constraint fk_sales_staff_store
	foreign key (store_id) references sales_stores (store_id) on delete cascade on update cascade;
    
alter table sales_orders
rename column order_status_id to order_status;    
    
alter table sales_orders
add constraint fk_order_status
	foreign key (order_status_id) references order_status (order_status_id) on delete cascade on update cascade;