-- Let's see our data table
SELECT * FROM nashville
LIMIT 1000;

-- Let's fix our saledate column
SELECT saledate FROM nashville
LIMIT 1000;

ALTER TABLE nashville ALTER COLUMN saledate TYPE DATE USING (saledate::DATE);

-- Populate Property Address data
SELECT propertyaddress FROM nashville
LIMIT 1000;

-- How many rows are with NULL propertyaddress?
SELECT propertyaddress FROM nashville
WHERE propertyaddress IS NULL;

-- Let's see the null rows of property address
SELECT * FROM nashville
WHERE propertyaddress IS NULL
ORDER BY parcelid;

-- Observing a specific parcelid
SELECT * FROM nashville
WHERE parcelid = '025 07 0 031.00'
ORDER BY parcelid;

-- Self joining to find out the propertyaddresses to replace null values
SELECT a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress
FROM nashville AS a
JOIN nashville AS b 
ON a.parcelid = b.parcelid
AND a.uniqueid <> b.uniqueid
WHERE a.propertyaddress IS NULL;

-- Updating the table after replacing the null values with proper propertyaddress
UPDATE nashville AS a
SET propertyaddress = c.propertyaddress
FROM (
SELECT parcelid, propertyaddress
FROM nashville
WHERE propertyaddress IS NOT NULL
) c
WHERE a.propertyaddress IS NULL;

-- Let's see the data table
SELECT uniqueid,parcelid, propertyaddress
FROM nashville
LIMIT 2000;

-- Breaking out address into individual columns (Address, City, State)
SELECT parcelid, propertyaddress FROM nashville
ORDER BY parcelid
LIMIT 1000;

SELECT 
SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress) -1) AS address,
SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress) +1, LENGTH(propertyaddress)) AS CITY
FROM nashville
LIMIT 1000;

-- Adding into the data table
ALTER TABLE nashville
ADD Address varchar(500); 

UPDATE nashville
SET address = SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress) -1);

ALTER TABLE nashville
ADD city varchar(500); 

UPDATE nashville
SET city = SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress) +1, LENGTH(propertyaddress));

-- Now, let's see
SELECT address, city FROM nashville
ORDER BY parcelid
LIMIT 1000;

-- Let's try to get STATE
SELECT owneraddress FROM nashville
LIMIT 1000;

-- Different method
SELECT 
split_part(owneraddress, ',', 3)
FROM nashville
LIMIT 1000;

ALTER TABLE nashville
ADD state varchar(500); 

UPDATE nashville
SET state = split_part(owneraddress, ',', 3);

SELECT state FROM nashville
ORDER BY parcelid
LIMIT 1000;

-- Change Y and N to Yes and No in "Sold as Vacant" field
SELECT DISTINCT soldasvacant 
FROM nashville;

SELECT DISTINCT soldasvacant, COUNT(soldasvacant)
FROM nashville
GROUP BY soldasvacant
ORDER BY 2;

SELECT soldasvacant
, CASE WHEN soldasvacant = 'Y' THEN 'Yes'
       WHEN soldasvacant = 'N' THEN 'No'
       ELSE soldasvacant
       END
FROM nashville;

UPDATE nashville
SET soldasvacant = (CASE WHEN soldasvacant = 'Y' THEN 'Yes'
       WHEN soldasvacant = 'N' THEN 'No'
       ELSE soldasvacant
       END);

SELECT DISTINCT soldasvacant, COUNT(soldasvacant)
FROM nashville
GROUP BY soldasvacant
ORDER BY 2;

-- Removing duplicates
WITH RowNumCTE AS(
    SELECT *,
        row_number() OVER (
            PARTITION BY parcelid,
                         propertyaddress,
                         saledate,
                         saleprice,
                         legalreference
                         ORDER BY uniqueid
        ) row_num
    FROM nashville
        )
SELECT * FROM RoWNumCTE 
WHERE row_num > 1
ORDER BY propertyaddress;

-- DELETING those duplicate rows
WITH RowNumCTE AS(
    SELECT uniqueid
    FROM(
        SELECT uniqueid,
        row_number() OVER (
            PARTITION BY parcelid,
                         propertyaddress,
                         saledate,
                         saleprice,
                         legalreference
                         ORDER BY uniqueid
        ) row_num
    FROM nashville) s
    WHERE row_num > 1 )
DELETE FROM nashville
WHERE uniqueid IN (SELECT * FROM RowNumCTE)

-- Delete Unused COLUMNS
SELECT * FROM nashville
LIMIT 1000;

ALTER TABLE nashville
DROP COLUMN owneraddress ,
DROP COLUMN taxdistrict,
DROP COLUMN propertyaddress;
