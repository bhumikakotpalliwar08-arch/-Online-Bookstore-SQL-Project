CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

 
-- 1) Retrieve all books in the "Fiction" genre:

SELECT * FROM Books 
WHERE Genre='Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books 
WHERE Published_year>1950;

-- 3) List all customers from the Canada:
SELECT * FROM Customers 
WHERE country='Canada';

 --4) Show orders placed in November 2023:
SELECT * FROM ORDERS
WHERE order_date BETWEEN '2023-09-01' AND '2023-09-30' ;
 
 --5) total books available
 SELECT
	SUM(STOCK) AS TOTALSTOCK
FROM
	BOOKS;

-- 6) Find the details of the most expensive book:
SELECT
	*
FROM
	BOOKS
ORDER BY
	PRICE DESC
LIMIT
	1;

--more than 1 quantity
SELECT
	*
FROM
	ORDERS
WHERE
	QUANTITY > 1;

--amount total is greater than 20
SELECT
	*
FROM
	ORDERS
WHERE
	TOTAL_AMOUNT > 20;

--all genres of books
SELECT DISTINCT
	GENRE
FROM
	BOOKS;

-
OR
SELECT ALL
	GENRE
FROM
	BOOKS;

 SELECT
	*
FROM
	BOOKS
ORDER BY
	STOCK
LIMIT
	5;

--TOTAL REVENUE 

SELECT SUM(total_amount) As Revenue 
FROM Orders;


Select b.genre,o.Quantity
from orders o
JOIN Books b ON o.book_id = b.book_id;

--sum of total books sold in each genre
Select b.genre,sum(o.Quantity)
from orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.Genre;

---- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) as averageprice FROM BOOKS
WHERE GENRE = 'Fantasy'; 

--  3) List customers who have placed at least 2 orders:
SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;


--
-- 4) Find the most frequently ordered book:
SELECT book_id,count(order_id) as order_count
From Orders
Group By book_id
ORDER BY order_count desc limit 1;

--with  boook title 
SELECT o.book_id,b.title,count(order_id) as order_count
From Orders o
join books b on o.book_id=b.book_id
Group By o.book_id,b.title
ORDER BY order_count desc limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM BOOKS 
WHERE GENRE='Fantasy'
ORDER BY price DESC
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.author,sum(o.quantity) as Total_quantity
from orders o
JOIN books b on b.book_id=o.book_id
group by b.author;

-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;


-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;


--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;




