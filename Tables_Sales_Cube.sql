-- States
CREATE TABLE States (
	state_id INTEGER PRIMARY KEY,
	state_name VARCHAR(30) UNIQUE
);

-- Customers
CREATE TABLE Customers (
	customer_id INTEGER PRIMARY KEY,
	customer_name VARCHAR(255) NOT NULL,
	state_id INTEGER NOT NULL,
	FOREIGN KEY (state_id) REFERENCES States(state_id)
);

-- Categories
CREATE TABLE Categories (
	category_id INTEGER PRIMARY KEY,
	category_name VARCHAR(255) NOT NULL,
	category_description TEXT
);
	
-- Products
CREATE TABLE Products (
	product_id INTEGER PRIMARY KEY,
	product_name VARCHAR(255) NOT NULL,
	product_list_price DECIMAL(5, 2) CHECK (product_list_price >= 0),
	category_id INTEGER NOT NULL,
	FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Sales
CREATE TABLE Sales (
	sales_id INTEGER PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	product_id INTEGER NOT NULL,
	product_quantity INTEGER NOT NULL,
	discount DECIMAL(5, 2) DEFAULT 0.00,
	FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
	FOREIGN KEY (product_id) REFERENCES Products(product_id)
);