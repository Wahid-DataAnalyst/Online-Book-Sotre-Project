CREATE TABLE Books(
	Book_id SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(102),
	Genre VARCHAR (85),
	Publish_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);

CREATE TABLE Customers(
	Customer_id Serial PRIMARY KEY,
	Name VARCHAR (100),
	Email VARCHAR(100),
	Phone VARCHAR(25),
	City VARCHAR(145),
	Country VARCHAR(155)
);

CREATE TABLE Orders(
	Order_id Serial PRIMARY KEY,
	Customer_id INT REFERENCES Customers(Customer_id),
	Book_id INT REFERENCES Books(Book_id),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);

Select * from Books;
Select * from Customers;
Select * from Orders;

-- BASIC QUERY question
--1) Retrive all books in the "fiction" genre:
Select * from Books
where Genre = 'Fiction';
--2) Find books published after the year 1950:
Select * from Books
where Publish_Year > '1950';
--3) List all customers from the canda
Select * from Customers
where Country = 'Canada';
--4) show order placed in november 2023
Select * from Orders
where Order_date Between '2023-11-01' and '2023-11-30';
--5) Retrive the total stock of book availble
Select sum(stock) as total_stock from Books;
--6) Find the details of the most expensive book
Select Max(Price) As Most_Expensive_Book from Books
--7) show all customer who ordered more then 1 quantity of a book
Select * from Orders
where Quantity>1;
--8) Retrive all order where the total amount exceed $20
Select * from Orders
where Total_Amount>20;
--9) List all geners availble in the book table
Select Distinct(Genre) from Books
 --10) Find the book with the lowest stock
Select min(stock) as lowest_stock from Books;
--11) Calculate the total revenue generated from all orders
Select Sum(Total_Amount) As Total_Revnue from Orders

--ADVANCE QUERY question

--1) Retrive the total number of book sold for each gener
SELECT b.Genre,sum(o.Quantity) As total_sold_book
from Orders o
JOIN Books b ON o.Book_id=b.Book_id
Group by b.Genre;
--2) find the average price of book in the "fentasy" gener 
SELECT Round(Avg(Price),2) as avg_price FROM Books
where Genre='Fantasy';

--3) List customer who have placed atleast 2 orders
SELECT Customer_id,count(Order_id) From Orders 
Group by Customer_id
Having count(Order_id)>=2;

--4) List the most frequenttly order book
SELECT Book_id,Count(Order_id) as order_count
from orders
Group by Book_id
order by order_count desc limit 1;
--5) Show the top 3 most expensive books 'fantasy' gener
SELECT * from Books
where Genre='Fantasy'
order by Price desc limit 3;
--6) Retrive the total quantity of  book sold by each author
SELECT b.Author,sum(o.Quantity) AS total_book
from orders o
JOIN Books b on  o.Book_id=b.Book_id 
group by b.author;
--7) List the cities where customers who spent over $30 are located
SELECT Distinct c.City,o.customer_id from orders o
Join customers c on o.Customer_id=c.Customer_id 
where o.Total_Amount>30;

--8) find the customer who spent the most on orders
SELECT c.customer_id,c.name,sum(o.Total_Amount) as Total_spent from orders o
join Customers c on o.customer_id=c.customer_id
group by c.customer_id,c.name
order by Total_spent desc limit 3;
--9) Calculate the stock remaining after fulfiling all orders
SELECT b.Book_id,b.Title,b.Stock, COALESCE(SUM(o.Quantity),0) as order_quantity ,
	b.Stock-COALESCE(SUM(o.Quantity),0) as Remaining_Quantity
from Books b
LEFT JOIN orders o ON  b.Book_id=o.Book_id
GROUP BY b.Book_id  
ORDER BY b.Book_id;
