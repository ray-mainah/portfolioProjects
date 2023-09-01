	--Populating property address data 
	SELECT [SaleDate], CONVERT(Date, SaleDate) as [Date of Sale]
	FROM [MAINNAH].[dbo].[Nashvillehousing]
	

	Update Nashvillehousing

	SET SaleDate = CONVERT(Date, SaleDate)

	--Populate property address
	
	SELECT *
	FROM [MAINNAH].[dbo].[Nashvillehousing]
	--WHERE [PropertyAddress] is null
	ORDER BY [ParcelID]


	
	SELECT A.[ParcelID], B.[ParcelID], A.[PropertyAddress], B.[PropertyAddress], ISNULL(A.[PropertyAddress], B.[PropertyAddress])
	FROM [MAINNAH].[dbo].[Nashvillehousing] A
	JOIN [MAINNAH].[dbo].[Nashvillehousing] B
	     on A.[ParcelID] = B.[ParcelID]
		 AND A.[UniqueID ] <> B.[UniqueID ]
	WHERE A.[PropertyAddress] is null

	update A
	SET PropertyAddress = ISNULL(A.[PropertyAddress], B.[PropertyAddress])
	FROM [MAINNAH].[dbo].[Nashvillehousing] A
	JOIN [MAINNAH].[dbo].[Nashvillehousing] B
	     on A.[ParcelID] = B.[ParcelID]
		 AND A.[UniqueID ] <> B.[UniqueID ]
	WHERE A.[PropertyAddress] is null


-------------------------------------------------------------------------------------------------------------------
	
	--Breaking out address into individual columns (address, city, state)
	
	SELECT PropertyAddress
	FROM [MAINNAH].[dbo].[Nashvillehousing]
	--WHERE [PropertyAddress] is null
	ORDER BY [ParcelID]

	SELECT 
	SUBSTRING([PropertyAddress], 1, CHARINDEX(',', [PropertyAddress])-1) as Address
	,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))  as Address


	FROM  [MAINNAH].[dbo].[Nashvillehousing]

	ALTER TABLE [MAINNAH].[dbo].[Nashvillehousing]
	Add PropertySplitAddress Nvarchar(255);

	Update  [MAINNAH].[dbo].[Nashvillehousing]
	SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)
	
	
	ALTER TABLE [MAINNAH].[dbo].[Nashvillehousing]
	Add PropertySplitCity Nvarchar(255);

	Update  [MAINNAH].[dbo].[Nashvillehousing]
	SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) 

	SELECT
	PARSENAME(REPLACE([OwnerAddress],',','.'), 3)
	,PARSENAME(REPLACE([OwnerAddress],',','.'), 2)
	,PARSENAME(REPLACE([OwnerAddress],',','.'), 1)
	FROM  [MAINNAH].[dbo].[Nashvillehousing]

	ALTER TABLE [MAINNAH].[dbo].[Nashvillehousing]
	Add OwnerSplitAddress Nvarchar(255);

	Update  [MAINNAH].[dbo].[Nashvillehousing]
	SET OwnerSplitAddress = PARSENAME(REPLACE([OwnerAddress],',','.'), 3)
	
	
	ALTER TABLE [MAINNAH].[dbo].[Nashvillehousing]
	Add OwnerSplitCity Nvarchar(255);

	Update  [MAINNAH].[dbo].[Nashvillehousing]
	SET OwnerSplitCity = PARSENAME(REPLACE([OwnerAddress],',','.'), 2) 
	
	ALTER TABLE [MAINNAH].[dbo].[Nashvillehousing]
	Add OwnerSplitState Nvarchar(255);

	Update  [MAINNAH].[dbo].[Nashvillehousing]
	SET OwnerSplitState = PARSENAME(REPLACE([OwnerAddress],',','.'), 1)

	SELECT *
	FROM [MAINNAH].[dbo].[Nashvillehousing]
	

	--Change Y and N to yes and No in “Sold as vacant” field.
	SELECT  DISTINCT([SoldAsVacant]), COUNT([SoldAsVacant])
	FROM [MAINNAH].[dbo].[Nashvillehousing]
	GROUP BY [SoldAsVacant]
	ORDER BY 2


	SELECT [SoldAsVacant]
	, CASE WHEN [SoldAsVacant] = 'Y' THEN 'Yes'
	WHEN [SoldAsVacant] ='N' THEN 'No'
	ELSE [SoldAsVacant]
	END

	FROM [MAINNAH].[dbo].[Nashvillehousing]

	Update [MAINNAH].[dbo].[Nashvillehousing]
	SET SoldAsVacant = CASE WHEN [SoldAsVacant] = 'Y' THEN 'Yes'
	WHEN [SoldAsVacant] ='N' THEN 'No'
	ELSE [SoldAsVacant]
	END
	
	--Remove duplicates

	WITH RowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY [ParcelID],
					 [PropertyAddress],
					 [SalePrice],
					 [SaleDate],
					 [LegalReference]
					 ORDER BY 
						[UniqueID ]
						) row_num

	
	FROM [MAINNAH].[dbo].[Nashvillehousing]
	--ORDER BY [ParcelID]
	)
	SELECT *
	FROM RowNumCTE
	WHERE row_num > 1
	--ORDER BY [PropertyAddress]
	
	
	--Delete unused columns
	
	SELECT *
	FROM [MAINNAH].[dbo].[Nashvillehousing]

	ALTER TABLE  [MAINNAH].[dbo].[Nashvillehousing]
	DROP COLUMN [OwnerAddress],[TaxDistrict],[PropertyAddress], [SaleDate]

