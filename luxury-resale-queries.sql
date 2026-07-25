
-- The Luxury Fashion Resale Database
-- Assignment 5, Sem 1, 2026
--
-- Student Name:   Paula Moreno Mappe
-- Student Email:  Paula.MorenoMappe@student.uts.edu.au
-- Student Number: 26177980
--
-- This database is inspired by the website (https://www.resee.com/en/)
-- ReSee is a Paris-based company founded in
-- 2013 that buys, authenticates, and resells high-end designer items such
-- as Chanel handbags, Hermes scarves, and vintage Saint Laurent clothing.
-- Sellers submit their pre-loved designer pieces to ReSee, which then
-- handles photography, authentication, and listing. Buyers can browse and
-- purchase items, with orders containing one or more authenticated pieces.
--
-- The database tracks sellers, buyers, brands, product types, items,
-- orders, and the relationship between orders and items.
--

DROP TABLE ReSee_Order_Item   CASCADE;
DROP TABLE ReSee_Orders       CASCADE;
DROP TABLE ReSee_Item         CASCADE;
DROP TABLE ReSee_Seller       CASCADE;
DROP TABLE ReSee_Buyer        CASCADE;
DROP TABLE ReSee_Brand        CASCADE;
DROP TABLE ReSee_Product_Type CASCADE;


Create table ReSee_Product_Type
(
	typeName	TEXT,
	description	TEXT,
	collectionYear	TEXT,

	CONSTRAINT ReSee_ProductTypePK PRIMARY KEY (typeName)
);


Create table ReSee_Brand
(
	brandName	TEXT,
	countryOrigin	TEXT,

	CONSTRAINT ReSee_BrandPK PRIMARY KEY (brandName)
);


Create table ReSee_Seller
(
	sellerEmail	TEXT,
	sellerName	TEXT	NOT NULL,
	phone		TEXT,
	city		TEXT,
	country		TEXT	NOT NULL,
	joinedDate	DATE	NOT NULL,

	CONSTRAINT ReSee_SellerPK PRIMARY KEY (sellerEmail),

	CONSTRAINT di_seller_joinedDate CHECK
		(joinedDate >= '2013-01-01')
);


Create table ReSee_Buyer
(
	buyerEmail	TEXT,
	buyerName	TEXT	NOT NULL,
	phone		TEXT,
	country		TEXT	NOT NULL,
	joinedDate	DATE	NOT NULL,

	CONSTRAINT ReSee_BuyerPK PRIMARY KEY (buyerEmail),

	CONSTRAINT di_buyer_joinedDate CHECK
		(joinedDate >= '2013-01-01')
);


Create table ReSee_Item
(
	itemNo		integer,
	sellerEmail	TEXT	NOT NULL,
	brandName	TEXT	NOT NULL,
	typeName	TEXT	NOT NULL,
	itemName	TEXT	NOT NULL,
	price		decimal	NOT NULL,
	condition	TEXT	NOT NULL,
	size		TEXT,
	isAuthenticated	char(1)	NOT NULL,
	isSold		char(1)	NOT NULL,
	listedDate	DATE	NOT NULL,

	CONSTRAINT ReSee_ItemPK PRIMARY KEY (itemNo),

	CONSTRAINT ReSee_ItemFK_Seller FOREIGN KEY (sellerEmail)
		REFERENCES ReSee_Seller
		ON DELETE RESTRICT,

	CONSTRAINT ReSee_ItemFK_Brand FOREIGN KEY (brandName)
		REFERENCES ReSee_Brand
		ON DELETE RESTRICT,

	CONSTRAINT ReSee_ItemFK_Type FOREIGN KEY (typeName)
		REFERENCES ReSee_Product_Type
		ON DELETE RESTRICT,

	CONSTRAINT di_item_price CHECK
		(price > 0),

	CONSTRAINT di_item_condition CHECK (condition IN (
		'Excellent',
		'Very Good',
		'Good',
		'Fair'
	)),

	CONSTRAINT di_item_isAuthenticated CHECK (isAuthenticated IN ('Y', 'N')),

	CONSTRAINT di_item_isSold          CHECK (isSold          IN ('Y', 'N'))
);


Create table ReSee_Orders
(
	orderNo		integer,
	buyerEmail	TEXT	NOT NULL,
	orderDate	DATE	NOT NULL,
	shippingAddress	TEXT	NOT NULL,
	status		TEXT	NOT NULL,
	totalAmount	decimal	NOT NULL,

	CONSTRAINT ReSee_OrdersPK PRIMARY KEY (orderNo),

	CONSTRAINT ReSee_OrdersFK_Buyer FOREIGN KEY (buyerEmail)
		REFERENCES ReSee_Buyer
		ON DELETE RESTRICT,

	CONSTRAINT di_order_status CHECK (status IN (
		'Pending',
		'Confirmed',
		'Shipped',
		'Delivered',
		'Cancelled'
	)),

	CONSTRAINT di_order_totalAmount CHECK
		(totalAmount > 0)
);


Create table ReSee_Order_Item
(
	orderNo		integer,
	itemNo		integer,
	priceAtPurchase	decimal	NOT NULL,

	CONSTRAINT ReSee_OrderItemPK PRIMARY KEY (orderNo, itemNo),

	CONSTRAINT ReSee_OrderItemFK_Order FOREIGN KEY (orderNo)
		REFERENCES ReSee_Orders
		ON DELETE CASCADE,

	CONSTRAINT ReSee_OrderItemFK_Item FOREIGN KEY (itemNo)
		REFERENCES ReSee_Item
		ON DELETE RESTRICT,

	CONSTRAINT di_orderitem_price CHECK
		(priceAtPurchase > 0)
);

CREATE VIEW AvailableItems AS
  SELECT  itemNo, itemName,
          brandName, typeName,
          price, condition
  FROM    ReSee_Item
  WHERE   isSold = 'N'
  AND     isAuthenticated = 'Y';


-- ============================================================
-- INSERT DATA
-- ============================================================

INSERT INTO ReSee_Product_Type VALUES ('Handbag',    'Luxury handbags and purses',              '1900s');
INSERT INTO ReSee_Product_Type VALUES ('Clothing',   'Designer clothes',                        '1900s');
INSERT INTO ReSee_Product_Type VALUES ('Shoes',      'Luxury footwear',                         '1900s');
INSERT INTO ReSee_Product_Type VALUES ('Jewellery',  'Fine jewellery',                          '1800s');
INSERT INTO ReSee_Product_Type VALUES ('Scarf',      'Silk and luxury scarves',                 '1800s');
INSERT INTO ReSee_Product_Type VALUES ('Watch',      'Luxury watches',                          '1800s');
INSERT INTO ReSee_Product_Type VALUES ('Accessory',  'Belts, sunglasses and other accessories', '1900s');


INSERT INTO ReSee_Brand VALUES ('Chanel',        'France');
INSERT INTO ReSee_Brand VALUES ('Hermes',         'France');
INSERT INTO ReSee_Brand VALUES ('Louis Vuitton',  'France');
INSERT INTO ReSee_Brand VALUES ('Celine',         'France');
INSERT INTO ReSee_Brand VALUES ('Saint Laurent',  'France');
INSERT INTO ReSee_Brand VALUES ('Prada',          'Italy');
INSERT INTO ReSee_Brand VALUES ('Gucci',          'Italy');
INSERT INTO ReSee_Brand VALUES ('Balenciaga',     'Spain');


INSERT INTO ReSee_Seller VALUES ('sofia.b@email.com',   'Sofia Bernard',  '+33612345678', 'Paris',   'France',    '2015-03-12');
INSERT INTO ReSee_Seller VALUES ('anna.k@email.com',    'Anna Kowalski',  '+44712345678', 'London',  'UK',        '2016-07-22');
INSERT INTO ReSee_Seller VALUES ('giulia.r@email.com',  'Giulia Rossi',   '+39312345678', 'Milan',   'Italy',     '2018-09-30');
INSERT INTO ReSee_Seller VALUES ('priya.s@email.com',   'Priya Sharma',   '+61412345678', 'Sydney',  'Australia', '2020-11-20');


INSERT INTO ReSee_Buyer VALUES ('alice.t@email.com',   'Alice Tan',      '+65912345678', 'Singapore', '2018-05-10');
INSERT INTO ReSee_Buyer VALUES ('jessica.l@email.com', 'Jessica Lee',    '+12125551234', 'USA',       '2019-08-23');
INSERT INTO ReSee_Buyer VALUES ('emma.b@email.com',    'Emma Brown',     '+44771234567', 'UK',        '2020-12-01');
INSERT INTO ReSee_Buyer VALUES ('yuki.m@email.com',    'Yuki Mori',      '+81312345678', 'Japan',     '2021-07-19');


INSERT INTO ReSee_Item VALUES (1, 'sofia.b@email.com',  'Chanel',       'Handbag',  'Chanel Classic Flap Bag Black',    3500.00, 'Excellent', NULL, 'Y', 'N', '2023-01-10');
INSERT INTO ReSee_Item VALUES (2, 'anna.k@email.com',   'Hermes',       'Scarf',    'Hermes Silk Scarf Les Chevaux',     450.00, 'Very Good', NULL, 'Y', 'N', '2023-02-14');
INSERT INTO ReSee_Item VALUES (3, 'anna.k@email.com',   'Celine',       'Handbag',  'Celine Luggage Tote Phoebe Era',   2800.00, 'Very Good', NULL, 'Y', 'N', '2023-03-05');
INSERT INTO ReSee_Item VALUES (4, 'giulia.r@email.com', 'Balenciaga',   'Clothing', 'Balenciaga Blazer Size 38',        1200.00, 'Good',      '38', 'Y', 'N', '2023-03-20');
INSERT INTO ReSee_Item VALUES (5, 'giulia.r@email.com', 'Saint Laurent','Shoes',    'Saint Laurent Sandals Size 37',     750.00, 'Very Good', '37', 'Y', 'Y', '2023-04-02');
INSERT INTO ReSee_Item VALUES (6, 'priya.s@email.com',  'Louis Vuitton','Handbag',  'Louis Vuitton Speedy 30',          1100.00, 'Good',      NULL, 'Y', 'Y', '2023-04-18');
INSERT INTO ReSee_Item VALUES (7, 'priya.s@email.com',  'Prada',        'Handbag',  'Prada Galleria Bag Black',         1800.00, 'Excellent', NULL, 'Y', 'N', '2023-05-07');
INSERT INTO ReSee_Item VALUES (8, 'sofia.b@email.com',  'Chanel',       'Jewellery','Chanel CC Pearl Earrings',          380.00, 'Excellent', NULL, 'Y', 'N', '2023-06-01');
INSERT INTO ReSee_Item VALUES (9, 'anna.k@email.com',   'Hermes',       'Watch',    'Hermes Cape Cod Watch',            2200.00, 'Very Good', NULL, 'Y', 'Y', '2023-06-15');
INSERT INTO ReSee_Item VALUES (10,'giulia.r@email.com', 'Gucci',        'Clothing', 'Gucci Velvet Jacket Size 40',      1500.00, 'Very Good', '40', 'Y', 'N', '2023-07-19');


INSERT INTO ReSee_Orders VALUES (1001, 'alice.t@email.com',   '2023-04-25', '10 Orchard Road, Singapore',    'Delivered',  750.00);
INSERT INTO ReSee_Orders VALUES (1002, 'jessica.l@email.com', '2023-04-30', '350 Fifth Ave, New York',       'Delivered', 1100.00);
INSERT INTO ReSee_Orders VALUES (1003, 'emma.b@email.com',    '2023-06-20', '221B Baker Street, London',     'Shipped',   2200.00);
INSERT INTO ReSee_Orders VALUES (1004, 'yuki.m@email.com',    '2023-07-12', '1-1 Marunouchi, Tokyo',         'Confirmed', 3180.00);
INSERT INTO ReSee_Orders VALUES (1005, 'alice.t@email.com',   '2023-08-01', '10 Orchard Road, Singapore',    'Pending',   1200.00);


-- Order 1001: Alice bought item 5 (Saint Laurent sandals)
INSERT INTO ReSee_Order_Item VALUES (1001, 5,   750.00);

-- Order 1002: Jessica bought item 6 (Louis Vuitton Speedy)
INSERT INTO ReSee_Order_Item VALUES (1002, 6,  1100.00);

-- Order 1003: Emma bought item 9 (Hermes watch)
INSERT INTO ReSee_Order_Item VALUES (1003, 9,  2200.00);

-- Order 1004: Yuki bought items 3 and 8 (Celine bag + Chanel earrings)
INSERT INTO ReSee_Order_Item VALUES (1004, 3,  2800.00);
INSERT INTO ReSee_Order_Item VALUES (1004, 8,   380.00);

-- Order 1005: Alice bought item 4 (Balenciaga blazer)
INSERT INTO ReSee_Order_Item VALUES (1005, 4,  1200.00);

