--PRACTICE JOINS

SELECT *
FROM invoice AS i
JOIN invoice_line AS il ON i.invoice_id = il.invoice_id
WHERE il.unit_price > 0.99;


SELECT i.invoice_date,
       c.first_name,
       c.last_name,
       i.total
FROM customer AS c
JOIN invoice AS i ON c.customer_id = i.customer_id ;


SELECT c.first_name,
       c.last_name,
       e.first_name,
       e.last_name
FROM customer c
JOIN employee e ON c.support_rep_id = e.employee_id;


SELECT al.title,
       ar.name
FROM album al
JOIN artist ar ON al.artist_id = ar.artist_id;


SELECT pt.track_id
FROM playlist_track pt
JOIN playlist p ON pt.playlist_id = p.playlist_id
WHERE p.name = 'Music';


SELECT t.name
FROM track t
JOIN playlist_track pt ON t.track_id = pt.track_id
WHERE pt.playlist_id = 5;


SELECT t.name,
       p.name
FROM track t
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p ON pt.playlist_id = p.playlist_id;


SELECT t.name,
       al.title
FROM track t
JOIN album al ON t.album_id = al.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Alternative & Punk';


SELECT t.name,
       g.name,
       al.title,
       ar.name
FROM track t
JOIN genre g ON t.genre_id = g.genre_id
JOIN album al on t.album_id = al.album_id
JOIN artist ar on al.artist_id = ar.artist_id
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p on pt.playlist_id = p.playlist_id
WHERE p.name = 'Music';

--PRACTICE NESTED QUERIES

SELECT *
FROM invoice
WHERE invoice_id IN
    (SELECT invoice_id
     FROM invoice_line
     where unit_price > 0.99);


SELECT *
FROM playlist_track
where playlist_id IN
    (SELECT playlist_id
     FROM playlist
     where name ='Music');


SELECT name
FROM track
WHERE track_id IN
    (SELECT track_id
     FROM playlist_track
     WHERE playlist_id = 5);


SELECT *
FROM track
WHERE genre_id IN
    (SELECT genre_id
     FROM genre
     WHERE name = 'Comedy');


SELECT *
FROM track
WHERE album_id IN
    (SELECT album_id
     FROM album
     WHERE title = 'Fireball');


SELECT *
FROM track
WHERE album_id IN
    (SELECT album_id
     FROM album
     WHERE artist_id IN
         (SELECT artist_id
          from artist
          WHERE name = 'Queen'));

--PRACTICE UPDATING ROWS

UPDATE customer
SET fax = null
WHERE fax IS NOT null;


UPDATE customer
SET company = 'Self'
WHERE company IS null;


UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia'
  AND last_name = 'Barnett';


UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';


UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id =
    (SELECT genre_id
     FROM genre
     WHERE name = 'Metal')
  AND composer IS null;

--GROUP BY

SELECT g.name,
       COUNT(*)
FROM track t
JOIN genre g ON g.genre_id = t.genre_id
GROUP BY g.name;


SELECT g.name,
       COUNT(*)
FROM track t
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Pop'
  OR g.name = 'Rock'
GROUP BY g.name;


SELECT ar.name,
       COUNT(*)
FROM album al
JOIN artist ar ON ar.artist_id = al.artist_id
GROUP BY ar.name;

--USE DISTINCT

SELECT DISTINCT composer
FROM track;


SELECT DISTINCT billing_postal_code
FROM invoice;


SELECT DISTINCT company
FROM customer;

--DELETE ROWS

DELETE
FROM practice_delete WHER type = 'bronze';


DELETE
FROM practice_delete
WHERE type = 'silver';


DELETE
FROM practice_delete
WHERE value = 150;

--ECOMMERCE SIMULATION

CREATE TABLE users (user_id SERIAL PRIMARY KEY,
                                           name TEXT NOT null,
                                                     email TEXT UNIQUE NOT null);


CREATE TABLE product (product_id SERIAL PRIMARY KEY,
                                                name TEXT NOT null,
                                                          price NUMERIC NOT null);


CREATE TABLE orders (order_id serial PRIMARY KEY,
                                             order_name VARCHAR(50));


CREATE TABLE orders_products (order_id INT REFERENCES order(order_id),
                                                      product_id INT REFERENCES product(product_id))
INSERT INTO users (name,
                   email)
VALUES ('Jorge',
        'jorge@gmail.com'), ('Alex',
                             'alex@gmail.com'), ('Adriana',
                                                 'adriana@gmail.com');


INSERT INTO product (name, price)
VALUES ('guitar',
        19.99), ('sketchbook',
                 3.99), ('camera',
                         29.99);


INSERT INTO orders (order_name, order_id)
VALUES ('order 1',
        1),('order 2',
            2),('order_3',
                3)
INSERT INTO orders_products (order_id, product_id)
VALUES (1,
        1), (1,
             2), (1,
                  3), (2,
                       1), (2,
                            3), (3,
                                 2), (3,
                                      3)
SELECT orders.order_id,
       product.name
FROM orders
INNER JOIN orders_products on orders.order_id = orders_products.order_id
INNER JOIN product ON orders_products.product_id = product.product_id
WHERE orders.order_id = 1;


SELECT orders.order_id,
       product.name
FROM orders
INNER JOIN orders_products on orders.order_id = orders_products.order_id
INNER JOIN product ON orders_products.product_id = product.product_id;


SELECT sum(product.price)
FROM orders
INNER JOIN orders_products on orders.order_id = orders_products.order_id
INNER JOIN product ON orders_products.product_id = product.product_id
WHERE orders.order_id = 1;


ALTER TABLE orders ADD COLUMN user_id INT REFERENCES users(user_id);


UPDATE orders
SET user_id = 1
where order_id = 1;


UPDATE orders
SET user_id = 2
where order_id = 2;


UPDATE orders
SET user_id = 3
where order_id = 3;


SELECT orders.order_name
FROM orders
INNER JOIN users on orders.user_id = users.user_id
WHERE users.user_id = 2;


SELECT COUNT(orders.order_name)
FROM orders
INNER JOIN users on orders.user_id = users.user_id
GROUP BY users.name;


SELECT SUM(product.price)
FROM orders
INNER JOIN orders_products on orders.order_id = orders_products.order_id
INNER JOIN product ON orders_products.product_id = product.product_id;