-- Creazione database
create database ToysGroup;

-- Creazione delle tabelle
CREATE TABLE Product (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    category VARCHAR(50)
);

CREATE TABLE Region (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE Sales (
    id INT PRIMARY KEY,
    product_id INT,
    region_id INT,
    sale_date DATE,
    amount DECIMAL,
    FOREIGN KEY (product_id) REFERENCES Product(id),
    FOREIGN KEY (region_id) REFERENCES Region(id)
);

-- Inserimento dei dati di esempio
INSERT INTO Product (id, name, category) VALUES 
(1, 'Action Figure', 'Toys'),
(2, 'Board Game', 'Games'),
(3, 'Stuffed Animal', 'Toys'),
(4, 'Water Gun', 'Toys'),
(5, 'Lego Set', 'Games'),
(6, 'Light Saber', 'Toys');

INSERT INTO Region (id, name) VALUES 
(1, 'North America'),
(2, 'Europe'),
(3, 'Asia'),
(4, 'Caribbean'),
(5, 'Middle East'),
(6, 'Oceania');

INSERT INTO Sales (id, product_id, region_id, sale_date, amount) VALUES 
(1, 1, 1, '2024-01-10', 50.00),
(2, 2, 1, '2024-01-15', 30.00),
(3, 1, 2, '2024-02-05', 40.00),
(4, 3, 3, '2024-03-20', 20.00),
(5, 4, 6, '2024-02-15', 10.00),
(6, 6, 5, '2024-03-12', 40.00);

-- Verifichiamo che le varie PK siano univoche
SELECT COUNT(*) AS duplicate_count
FROM (
    SELECT id, COUNT(*) AS cnt
    FROM (
        SELECT id FROM Product
        UNION ALL
        SELECT id FROM Region
        UNION ALL
        SELECT id FROM Sales
    ) AS subquery
    GROUP BY id
    HAVING cnt > 1
) AS duplicates;

-- Elenco dei prodotti venduti e il fatturato totale per anno
SELECT p.name AS product_name, YEAR(s.sale_date) AS sale_year, SUM(s.amount) AS total_revenue
FROM Sales s
INNER JOIN Product p ON s.product_id = p.id
GROUP BY p.name, YEAR(s.sale_date);

-- Fatturato totale per regione per anno ordinato per data e fatturato decrescente
SELECT r.name AS region_name, YEAR(s.sale_date) AS sale_year, SUM(s.amount) AS total_revenue
FROM Sales s
INNER JOIN Region r ON s.region_id = r.id
GROUP BY r.name, YEAR(s.sale_date)
ORDER BY sale_year ASC, total_revenue DESC;

-- Categoria di articoli maggiormente richiesta dal mercato
SELECT p.category, COUNT(*) AS sales_count
FROM Sales s
INNER JOIN Product p ON s.product_id = p.id
GROUP BY p.category
ORDER BY sales_count DESC
LIMIT 1;

-- Prodotti invenduti (LEFT JOIN)
SELECT p.id, p.name
FROM Product p
LEFT JOIN Sales s ON p.id = s.product_id
WHERE s.id IS NULL;

-- Prodotti invenduti (NOT IN)
SELECT id, name
FROM Product
WHERE id NOT IN (SELECT DISTINCT product_id FROM Sales);

-- Elenco dei prodotti con la rispettiva ultima data di vendita
SELECT p.name AS product_name, MAX(s.sale_date) AS last_sale_date
FROM Product p
LEFT JOIN Sales s ON p.id = s.product_id
GROUP BY p.name;
