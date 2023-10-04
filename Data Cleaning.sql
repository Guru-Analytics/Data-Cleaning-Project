/*

Cleaning Data in SQL Queries

*/

SELECT * 
FROM Portfolio_Project_SQL.DBO.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SALEDATE, CONVERT(DATE, SALEDATE) AS CONVERTEDSALE_DATE
FROM Portfolio_Project_SQL.DBO.NashvilleHousing

ALTER TABLE Portfolio_Project_SQL.DBO.NashvilleHousing
ADD  CONVERTEDSALE_DATE DATE

UPDATE Portfolio_Project_SQL.DBO.NashvilleHousing
SET CONVERTEDSALE_DATE = CONVERT(DATE, SALEDATE)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From Portfolio_Project_SQL.DBO.NashvilleHousing
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio_Project_SQL.DBO.NashvilleHousing a
JOIN Portfolio_Project_SQL.DBO.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio_Project_SQL.DBO.NashvilleHousing a
JOIN Portfolio_Project_SQL.DBO.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From Portfolio_Project_SQL.DBO.NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From Portfolio_Project_SQL.DBO.NashvilleHousing


ALTER TABLE NashvilleHousing
Add New_PropertyAddress Nvarchar(255);

Update NashvilleHousing
SET New_PropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertytCity Nvarchar(255);

Update NashvilleHousing
SET PropertytCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From Portfolio_Project_SQL.DBO.NashvilleHousing





Select OwnerAddress
From Portfolio_Project_SQL.DBO.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Portfolio_Project_SQL.DBO.NashvilleHousing


ALTER TABLE NashvilleHousing
Add New_OwnerAddress Nvarchar(255);

Update NashvilleHousing
SET New_OwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerCity Nvarchar(255);

Update NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerState Nvarchar(255);

Update NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Portfolio_Project_SQL.DBO.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT SoldAsVacant ,COUNT(SoldAsVacant)
FROM Portfolio_Project_SQL.DBO.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Portfolio_Project_SQL.DBO.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
						When SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

-- check duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing
)
select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

-- Revmove duplicate records
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing
)
Delete
From RowNumCTE
Where row_num > 1


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select *
from NashvilleHousing



ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

select *
from NashvilleHousing





-----------------------------------------------------------------------------------------------