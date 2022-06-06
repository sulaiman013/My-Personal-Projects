CREATE TABLE nashville(		
UniqueID 	varchar(500),
ParcelID	varchar(500),
LandUse	varchar(500),
PropertyAddress	varchar(500),
SaleDate	varchar(500),
SalePrice	varchar(500),
LegalReference	varchar(500),
SoldAsVacant	varchar(500),
OwnerName	varchar(500),
OwnerAddress	varchar(500),
Acreage	varchar(500),
TaxDistrict	varchar(500),
LandValue	varchar(500),
BuildingValue	varchar(500),
TotalValue	varchar(500),
YearBuilt	varchar(500),
Bedrooms	varchar(500),
FullBath	varchar(500),
HalfBath	varchar(500)	
);

COPY nashville FROM 'F:\My-Personal-Projects-master\Nashville Housing SQL Data Cleaning\Nashville Housing Data for Data Cleaning.csv' 
HEADER CSV;

SELECT * FROM nashville
LIMIT 1000;

--DROP TABLE nashville;

