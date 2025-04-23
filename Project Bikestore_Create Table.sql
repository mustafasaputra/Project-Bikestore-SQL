-- create table --
create table production_categories 
(
	category_id		int				auto_increment,
	category_name		varchar (255)	not null,
    	primary key (category_id)
);

create table production_brands 
(
	brand_id		int				auto_increment,
    	brand_name		varchar (255)	not null,
    	primary key (brand_id)
);

create table production_products 
(
	product_id		int				auto_increment,
    	product_name		varchar (255)	not null,
    	brand_id		int		not null,
    	category_id		int		not null,
    	model_year		smallint	not null,
    	list_price		decimal (10,2)	not null,
    	primary key (product_id)
);

create table production_stocks 
(
	store_id int,
	product_id int,
	quantity int,
	primary key (store_id, product_id)
);

create table sales_customers 
(
	customer_id		int				auto_increment,
    	first_name		varchar (255)	not null,
    	last_name		varchar (255)	not null,
    	phone			varchar (25),
    	email			varchar (255)	not null,
    	street 			varchar (255),
	city 			varchar (50),
	state 			varchar (25),
	zip_code 		varchar (5),
    	primary key (customer_id)
);

CREATE TABLE sales_stores 
(
	store_id	int				auto_increment,
	store_name 	varchar (255) 	not null,
	phone 		varchar (25),
	email 		varchar (255),
	street 		varchar (255),
	city 		varchar (255),
	state 		varchar (10),
	zip_code 	varchar (5),
    	primary key (store_id)
);

CREATE TABLE sales_staffs 
(
	staff_id 			int				auto_increment,
	first_name 			varchar (50) 	not null,
	last_name 			varchar (50) 	not null,
	email 				varchar (255) 	not null	unique,
	phone 				varchar (25),
	active 				tinyint 	not null,
	store_id 			int 		not null,
	manager_id 			int,
	primary key (staff_id)
);

CREATE TABLE sales_orders 
(
	order_id			int				auto_increment,
	customer_id 			int,
	order_status			tinyint 	not null,
	order_date 			date 		not null,
	required_date 			date 		not null,
	shipped_date 			date,
	store_id 			int 		not null,
	staff_id 			int 		not null,
	primary key (order_id)
);

CREATE TABLE sales_order_items (
	order_id 			int,
	item_id 			int,
	product_id 			int 		not null,
	quantity 			int 		not null,
	list_price 			decimal (10, 2) not null,
	discount 			decimal (4, 2) 	not null 	default 0,
	PRIMARY KEY (order_id, item_id)
);










