

/*
Cleaning Data in SQL Queries
*/

select *
from Housing

-- Standardize Date Format

select DateConverted, convert (date,SaleDate) 
from Housing 

update [Housing ]
set Sale Date=convert (date,SaleDate)

alter table [Housing ]
add DateConverted date 

update [Housing ]
set DateConverted =convert (date,SaleDate)


select PropertyAddress
from Housing 
where PropertyAddress is  not null
--order by PropertyAddress desc

-- Populate Property Address data

select a.ParcelID , a.PropertyAddress, b.ParcelID ,b.PropertyAddress,isnull (a.PropertyAddress, b.PropertyAddress) 
from [Housing ] a 
join [Housing ] b 
on a.ParcelID = b.ParcelID 
 AND a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 update a
 set PropertyAddress=isnull (a.PropertyAddress, b.PropertyAddress) 
 from [Housing ] a 
join [Housing ] b 
on a.ParcelID = b.ParcelID 
 AND a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 select PropertyAddress
from Housing 


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From Housing 
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From Housing


ALTER TABLE Housing
Add PropertySplitAddress Nvarchar(255);

Update Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Housing
Add PropertySplitCity Nvarchar(255);

Update Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From Housing







Select OwnerAddress
From Housing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Housing



ALTER TABLE Housing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Housing
Add OwnerSplitCity Nvarchar(255);

Update Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Housing
Add OwnerSplitState Nvarchar(255);

Update Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Housing


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Housing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Housing


Update Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
Select *
From Housing

-- Remove Duplicates

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

From [Housing ]

)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Housing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From Housing


ALTER TABLE Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From Housing







