/*
Cleaning Data in SQL Queries

*/

select *
from PortfolioProject.dbo.NashvilleHousing


---------------------------------------------------------------------------------------------------------------------------
--Standarize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Nashvillehousing
Add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


----------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
order by ParcelID




Select a.ParcelID,a.PropertyAddress, b.ParcelID , b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
     AND a.[UniqueID ] <> b.[UniqueID ]
     where a.PropertyAddress is null



Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,'No Address')
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
     AND a.[UniqueID ] <> b.[UniqueID ]
     where a.PropertyAddress is null



-------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual columns(Address, city, State)
SELECT SUBSTRING(PropertyAddress, 1,Charindex(',', PropertyAddress)-1) as Address,Substring(PropertyAddress,Charindex(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
from PortfolioProject.dbo.NashvilleHousing 

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = Substring(PropertyAddress,Charindex(',', PropertyAddress)+1, LEN(PropertyAddress)) 

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress= SUBSTRING(PropertyAddress, 1,Charindex(',', PropertyAddress)-1)


select *
from PortfolioProject.dbo.NashvilleHousing


SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3)  ,PARSENAME(REPLACE(OwnerAddress,',','.'),2),PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing




ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress=  PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET  OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET  OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select *
from PortfolioProject.dbo.NashvilleHousing

select Distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant


select SoldAsVacant,
 CASE When SoldAsVacant= 'Y' then 'Yes'
      When SoldAsVacant= 'N' then 'No'
	  ELSE SoldAsVacant
      END
From  PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant=  CASE When SoldAsVacant= 'Y' then 'Yes'
      When SoldAsVacant= 'N' then 'No'
	  ELSE SoldAsVacant
      END


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

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
				 )row_num

From PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
DELETE
From RowNumCTE
Where row_num >1
--Order by PropertyAddress


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
				 )row_num

From PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
Select *
From RowNumCTE
Where row_num >1
Order by PropertyAddress



------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused column

select *
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

