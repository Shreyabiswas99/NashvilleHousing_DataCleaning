USE Portfolio;

SELECT *
FROM nashville_housing;

-- Standarditing the Date --

SELECT SaleDate, STR_TO_DATE(SaleDate , '%m/%d/%Y')
FROM nashville_housing;

UPDATE nashville_housing
SET SaleDate = STR_TO_DATE(SaleDate , '%m/%d/%Y');

-- Spliting the propety address into individual columns of address, city and state --

SELECT PropertyAddress
FROM nashville_housing;

SELECT SUBSTRING_INDEX(PropertyAddress,',',1) AS Address, SUBSTRING_INDEX(PropertyAddress,',',-1) AS city
FROM nashville_housing;

ALTER TABLE nashville_housing
Add PropertySplitAddress Nvarchar(255);
Update nashville_housing
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress,',',1);

ALTER TABLE nashville_housing
Add PropertySplitCity Nvarchar(255);
Update nashville_housing
SET PropertySplitCity = SUBSTRING_INDEX(PropertyAddress,',',-1);

SELECT *
FROM nashville_housing;

SELECT SUBSTRING_INDEX(OwnerAddress,',',1) AS Address, SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1) AS city, SUBSTRING_INDEX(OwnerAddress,',',-1) AS state
FROM nashville_housing;

ALTER TABLE nashville_housing
Add OwnerSplitAddress Nvarchar(255);
Update nashville_housing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress,',',1);

ALTER TABLE nashville_housing
Add OwnerSplitCity Nvarchar(255);
Update nashville_housing
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1);

ALTER TABLE nashville_housing
Add OwnerSplitState Nvarchar(255);
Update nashville_housing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress,',',-1);

-- Changing Y and N to Yes and No --

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM nashville_housing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM nashville_housing;

UPDATE nashville_housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END;

-- Removing Duplicates --

WITH RowNum AS(
Select *, 
ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
ORDER BY UniqueID) AS row_num
FROM nashville_housing)
SELECT *
From RowNum
Where row_num > 1;

-- Remove unwanted colums/rows --

SELECT *
FROM nashville_housing;

ALTER TABLE nashville_housing
DROP COLUMN PropertyAddress;

ALTER TABLE nashville_housing
DROP COLUMN OwnerAddress;

ALTER TABLE nashville_housing
DROP COLUMN TaxDistrict;
