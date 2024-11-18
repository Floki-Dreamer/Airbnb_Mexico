-- Crear tabla
CREATE TABLE airbnb_datos (
    id BIGINT PRIMARY KEY,
    name VARCHAR(255),
    host_id INT,
    host_name VARCHAR(255),
    neighbourhood_group VARCHAR(255),
    neighbourhood VARCHAR(255),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    room_type VARCHAR(50),
    price DECIMAL(10, 2),
    minimum_nights INT,
    number_of_reviews INT,
    last_review DATE,
    reviews_per_month DECIMAL(5, 2),
    calculated_host_listings_count INT,
    availability_365 INT,
    number_of_reviews_ltm INT,
    license VARCHAR(255)
);

-- importar datos --
COPY airbnb_datos
FROM 'C:\Mis_Archivos\airbnb_mexico.csv'
DELIMITER ',' 
CSV HEAD

-- identifico valores nulos --
SELECT 
    COUNT(*) AS total_rows,
    COUNT(price) AS non_null_price
   
FROM 
    airbnb_datos;

-- reemplazo valores nulos por 0 --
UPDATE airbnb_datos
SET price = 0
WHERE price IS NULL;


-- Reviso que no haya duplicados en columnas que no deben --
SELECT
	COUNT(DISTINCT (id))
FROM airbnb_datos
;
SELECT
	DISTINCT (room_type)
FROM airbnb_datos
;

-- Agrupo host_id y sumo price para verificar que no haya resultados muy elevados que sean incorrectos --
SELECT
    host_id,
    SUM(price) AS total_price
FROM 
    airbnb_datos
GROUP BY 
    host_id
ORDER BY 
    total_price DESC;

-- Promedio por alcaldia --
SELECT 
	neighbourhood,
	ROUND(AVG(price),0) AS promedio_avg
FROM airbnb_datos
GROUP BY neighbourhood
ORDER BY promedio_avg DESC

-- Total de airbnb por alcaldia --
CREATE VIEW totalairbnb_alcadia AS
SELECT 
    neighbourhood, 
    COUNT(DISTINCT host_id) AS total_airbnb
FROM 
    airbnb_datos
GROUP BY 
    neighbourhood
ORDER BY 
    total_airbnb DESC;

-- total de tipo de habitación y por alcaldía --
CREATE VIEW roomtype_alcaldia_totalairbnb AS
SELECT 
	room_type,
    neighbourhood, 
    COUNT(DISTINCT host_id) AS total_airbnb
FROM 
    airbnb_datos
GROUP BY 
    neighbourhood,room_type
ORDER BY 
    total_airbnb DESC;

















