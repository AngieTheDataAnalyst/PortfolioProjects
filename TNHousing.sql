-- 1.  Start


Select *
From PortfolioProject.dbo.TNHousing

-- 2. Standardize Date Format (Remove :00:00:00)


Select SaleDateConverted, Convert(Date,SaleDate)
From PortfolioProject.dbo.TNHousing

Alter Table TNHousing 
Add SaleDateConverted Date; 
Update TNHousing 
Set SaleDateConverted = Convert(Date,SaleDate)


-- 3. Property Address (Update Nulls)

Select 
From PortfolioProject.dbo.TNHousing
--Where PropertyAddress Is Null
Order By ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IsNull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.TNHousing a
Join PortfolioProject.dbo.TNHousing b
	On a.ParcelID =b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress Is Null

Update a 
Set PropertyAddress = IsNull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.TNHousing a
Join PortfolioProject.dbo.TNHousing b
	On a.ParcelID =b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress Is Null


-- 4. Removing the Comma and everything after from Address

Select PropertyAddress
From PortfolioProject.dbo.TNHousing
--Where PropertyAddress Is Null
--Order By ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) As Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) As Address
From PortfolioProject.dbo.TNHousing

Alter Table TNHousing 
Add PropertySplitAddress Nvarchar(255); 
Update TNHousing 
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table TNHousing 
Add PropertySplitCity Nvarchar(255); 
Update TNHousing 
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress))

Select *
From PortfolioProject.dbo.TNHousing


-- 5. Update Owner Address

Select OwnerAddress
From PortfolioProject.dbo.TNHousing

Select
PARSENAME(Replace(OwnerAddress,',', '.'),3),
PARSENAME(Replace(OwnerAddress,',', '.'), 2),
PARSENAME(Replace(OwnerAddress,',', '.'), 1)
From PortfolioProject.dbo.TNHousing

Alter Table TNHousing 
Add OwnerSplitAddress Nvarchar(255); 
Update TNHousing 
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',', '.'),3)

Alter Table TNHousing 
Add OwnerSplitCity Nvarchar(255); 
Update TNHousing 
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',', '.'), 2)

Alter Table TNHousing 
Add OwnerSplitState Nvarchar(255); 
Update TNHousing 
Set OwnerSplitState= PARSENAME(Replace(OwnerAddress,',', '.'), 1)

Select *
From PortfolioProject.dbo.TNHousing


-- 6. Change Y and N to 'Yes' and 'No' in Sold As Vacant field.

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.TNHousing
Group By SoldAsVacant
Order By 2

Select SoldAsVacant,
	Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End
From PortfolioProject.dbo.TNHousing

Update TNHousing
Set SoldAsVacant =
	Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End

-- 7. Remove Duplicates

With RowNumCTE As(
Select *,
	ROW_NUMBER() Over (
	Partition By ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By 
				UniqueID
				) row_num
From PortfolioProject.dbo.TNHousing
--Order By ParcelID
)

Select *
--Delete
From RowNumCTE
Where row_num >1
Order By PropertyAddress


-- 8. Delete Unused Columns

Select *
From PortfolioProject.dbo.TNHousing

Alter Table PortfolioProject.dbo.TNHousing
Drop Column SaleDate
--OwnerAddress, TaxDistrict, PropertyAddress