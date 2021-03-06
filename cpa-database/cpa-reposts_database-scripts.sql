USE [master]
GO
/****** Object:  Database [Comparison]    Script Date: 2/25/2016 12:29:02 AM ******/
CREATE DATABASE [Comparison]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Comparison', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Comparison.mdf' , SIZE = 7540736KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Comparison_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Comparison_log.ldf' , SIZE = 17592896KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Comparison] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Comparison].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Comparison] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Comparison] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Comparison] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Comparison] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Comparison] SET ARITHABORT OFF 
GO
ALTER DATABASE [Comparison] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Comparison] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Comparison] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Comparison] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Comparison] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Comparison] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Comparison] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Comparison] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Comparison] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Comparison] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Comparison] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Comparison] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Comparison] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Comparison] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Comparison] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Comparison] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Comparison] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Comparison] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Comparison] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Comparison] SET  MULTI_USER 
GO
ALTER DATABASE [Comparison] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Comparison] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Comparison] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Comparison] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [Comparison]
GO
/****** Object:  User [compuser]    Script Date: 2/25/2016 12:29:02 AM ******/
CREATE USER [compuser] FOR LOGIN [compuser] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [APOLLO-WEBSQL01\w.developer]    Script Date: 2/25/2016 12:29:02 AM ******/
CREATE USER [APOLLO-WEBSQL01\w.developer] FOR LOGIN [APOLLO-WEBSQL01\w.developer] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [APOLLO-WEBSQL01\apollo_admin]    Script Date: 2/25/2016 12:29:02 AM ******/
CREATE USER [APOLLO-WEBSQL01\apollo_admin] FOR LOGIN [APOLLO-WEBSQL01\apollo_admin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [apollosa]    Script Date: 2/25/2016 12:29:02 AM ******/
CREATE USER [apollosa] FOR LOGIN [apollosa] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [apolloqlik]    Script Date: 2/25/2016 12:29:02 AM ******/
CREATE USER [apolloqlik] FOR LOGIN [apolloqlik] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [apolloCPAview]    Script Date: 2/25/2016 12:29:02 AM ******/
CREATE USER [apolloCPAview] FOR LOGIN [apolloCPAview] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [db_executor]    Script Date: 2/25/2016 12:29:02 AM ******/
CREATE ROLE [db_executor]
GO
ALTER ROLE [db_datareader] ADD MEMBER [compuser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [compuser]
GO
ALTER ROLE [db_owner] ADD MEMBER [APOLLO-WEBSQL01\w.developer]
GO
ALTER ROLE [db_owner] ADD MEMBER [apollosa]
GO
ALTER ROLE [db_executor] ADD MEMBER [apolloqlik]
GO
ALTER ROLE [db_datareader] ADD MEMBER [apolloqlik]
GO
ALTER ROLE [db_executor] ADD MEMBER [apolloCPAview]
GO
ALTER ROLE [db_datareader] ADD MEMBER [apolloCPAview]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [apolloCPAview]
GO
/****** Object:  StoredProcedure [dbo].[addExceptionCheckCount]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<Add an exception count>
-- =============================================
CREATE PROCEDURE [dbo].[addExceptionCheckCount]
	@exceptionCount int
AS
BEGIN
	
	INSERT INTO tRefExceptionCheck 	( fDateChecked ,fNumberExceptions)
	VALUES							(getdate(), @exceptionCount)
END


GO
/****** Object:  StoredProcedure [dbo].[addExceptionsPrices]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<add a price exception>
-- =============================================
CREATE PROCEDURE [dbo].[addExceptionsPrices]
	@brand nvarchar(max), 
	@country int, 
	@pickupLocation nvarchar(max), 
	@returnLocation nvarchar(max), 
	@OneWayRentals bit, 
	@startDate smalldatetime,
	@endDate smalldatetime,
	@priceChange decimal (18,2),
	@priceChangePercent decimal (18,2),
	@currency int, 
	@priceChangeNote nvarchar(MAX)

AS
BEGIN

	SET NOCOUNT ON;

	-- set NULLS if dates not set
	DECLARE @startDateFinal nvarchar(20), @endDateFinal nvarchar(20), @currentDate smalldatetime
	SET @currentDate = getdate()
	SET @startDateFinal = 
			CASE
				WHEN @startDate = '' or @startDate IS NULL OR @startDate = '1900-01-01 00:00:00'
					THEN  
						CASE	
							WHEN datepart(dw,@currentDate) = 1 -- when today is a Sunday
								THEN CAST(@currentDate AS nvarchar(20))
							WHEN datepart(dw,@currentDate) = 2 -- when today is a Monday
								THEN  CAST(dateadd(day,-1,@currentDate) AS nvarchar(20))
							WHEN datepart(dw,@currentDate) = 3 -- when today is a Tuesday
								THEN  CAST(dateadd(day,-2,@currentDate) AS nvarchar(20))
							WHEN datepart(dw,@currentDate) = 4 -- when today is a Wednesday
								THEN  CAST(dateadd(day,-3,@currentDate) AS nvarchar(20))
							WHEN datepart(dw,@currentDate) = 5 -- when today is a Thursday
								THEN  CAST(dateadd(day,-4,@currentDate) AS nvarchar(20))
							WHEN datepart(dw,@currentDate) = 6 -- when today is a Friday
								THEN  CAST(dateadd(day,-5,@currentDate) AS nvarchar(20))
							WHEN datepart(dw,@currentDate) = 7 -- when today is a Saturday
								THEN  CAST(dateadd(day,-6,@currentDate) AS nvarchar(20))
						END	
				ELSE @startDate
			END
	SET @endDateFinal =
			CASE
				WHEN @endDate = '' or @endDate IS NULL OR @endDate = '1900-01-01 00:00:00'
					THEN NULL
				ELSE @endDate
			END
	-- set NULLs if INTs are empty

	DECLARE @thisID table ( fID int)

	INSERT INTO tRefPriceException(  
		--fPriceExceptionBrandID,
		fPriceExceptionCountryID
		--,fPriceExceptionPickupLocationID
		--,fPriceExceptionReturnLocationID
		,fPriceExceptionOneWay
		,fPriceExceptionDateStart
		,fPriceExceptionDateEnd
		,fPriceExceptionPriceChange
		,fPriceExceptionPercentage
		,fPriceExceptionCurrencyID
		,fPriceExceptionNote
	)
	output inserted.fID into @thisID

	VALUES (--@brand, 
	@country, 
	--@pickupLocation, 
	--@returnLocation, 
	@OneWayRentals,
    CAST(@startDateFinal AS smalldatetime),
	CAST(@endDateFinal AS smalldatetime),
	@priceChange,
	@priceChangePercent,
	@currency, 
	@priceChangeNote)

	DECLARE @ExceptionID int
	SET @ExceptionID = 
		CASE 
			WHEN (select count(fID) from @thisID) > 0 
			THEN cast((SELECT top 1 fID FROM @thisID) as int)
			ELSE 0
		END	
	
  DECLARE @countLocations int, @totalCountLocations int, @countBrands int, @totalBrands int

  DECLARE  @temp TABLE (
	fID int  IDENTITY(1,1) PRIMARY KEY,
	thisID int,
	pickupOrDropoff int
  )
  
  INSERT INTO @temp (thisID, pickupOrDropoff)
  SELECT val, '1' FROM [dbo].[split](@pickupLocation,',')
  
  INSERT INTO @temp (thisID, pickupOrDropoff)
  SELECT val, '2' FROM [dbo].[split](@returnLocation,',')

  SET @countLocations = 1
  SET @totalCountLocations = (select count(thisID) from @temp)

  WHILE @countLocations <= @totalCountLocations
	BEGIN
		INSERT INTO tRefPriceExceptionLocations
		([fExceptionID],[fLocationID],[fPickupOrDropoff])
		VALUES ( @ExceptionID,
				 (SELECT thisID from @temp WHERE fID = @countLocations),
				 (SELECT pickupOrDropoff from @temp WHERE fID = @countLocations)
			   )

		SET @countLocations = @countLocations + 1
	END
	
--run through list of brands, and add to table
  DECLARE  @tempBrands TABLE (
	fID int  IDENTITY(1,1) PRIMARY KEY,
	thisID int
  )
  
  INSERT INTO @tempBrands (thisID)
  SELECT val FROM [dbo].[split](@brand,',')
  
  SET @countBrands = 1
  SET @totalBrands = (select count(thisID) from @tempBrands)

  WHILE @countBrands <= @totalBrands
	BEGIN
		INSERT INTO tRefPriceExceptionBrands
		(fExceptionID, fBrandID)
		VALUES ( @ExceptionID,
				 (SELECT thisID from @tempBrands WHERE fID = @countBrands)
			   )

		SET @countBrands = @countBrands + 1
	END



END




GO
/****** Object:  StoredProcedure [dbo].[addScanDataClean]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <17/03/15>
-- Description:	<Convert scrape data into clean table>
-- =============================================
CREATE PROCEDURE [dbo].[addScanDataClean]
	@whatToCheck int

AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @oldCount int
	SET @oldCount = (SELECT TOP 1 fID from tDataScanClean ORDER BY fID DESC)
	
	DECLARE @datesToRun smalldatetime
	SET @datesToRun = 
		CASE	
			WHEN @whatToCheck = 0
			THEN (SELECT TOP 1 fScanDate from tDataScanClean ORDER BY fID DESC)
			ELSE dateadd(day,(((7*@whatToCheck)+1)*-1),[dbo].[getFirstDayOfWeek](getdate()))
		END

	DECLARE @tData TABLE(
		 fID int,
		 fScanDate smalldatetime,
		 fScanURL nvarchar(max),
		 fScanTravelCountry nvarchar(100),
		 fScanPickupLocation nvarchar(100),
		 fScanReturnLocation nvarchar(100),
		 fScanPickupDate smalldatetime,
		 fScanReturnDate smalldatetime,
		 fScanLicenceCountry nvarchar(100),
		 fScanBrandName nvarchar(100),
		 fScanVehicleName nvarchar(200),
		 fScanTotalPrice decimal(8, 2),
		 fScanCurrency nvarchar(5),
		 fScanSourceURL nvarchar(max)
	)
	INSERT INTO @tData
	SELECT fID
      ,fScanDate
      ,fScanURL
      ,fScanTravelCountry
      ,fScanPickupLocation
      ,fScanReturnLocation
      ,fScanPickupDate
      ,fScanReturnDate
      ,fScanLicenceCountry
      ,fScanBrandName
      ,fScanVehicleName
      ,fScanTotalPrice
      ,fScanCurrency
      ,fScanSourceURL
  FROM [Comparison].[dbo].[tDataScan]
  WHERE fScanDate >= cast(@datesToRun as date)
	AND fID not in (SELECT fScanID from tDataScanClean)
	AND fActive > 0

  --SELECT * FROM @tData

	--SELECT @datesToRun

	--get brand and vehicle name combos
	DECLARE @tTempTable TABLE (fBrandID int, fBrandName nvarchar(200), fVehicleID int, fVehicleName nvarchar(200))
	-- insert in brand and vehicle name combos
	INSERT INTO @tTempTable
	SELECT tB.fID as fBrandID, tB.fBrandName, tV.fVehicleID ,tV.fVehicleName FROM 
		(SELECT [dbo].[replaceIllegalChar](fVehicleName) as fVehicleName, fVehicleBrandID, fID as fVehicleID from tRefVehicle 
			UNION ALL 
		SELECT Split.a.value('.', 'VARCHAR(100)') AS String, fVehicleBrandID, fID as fVehicleID  from ( SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](fVehicleAlias), ';', '</M><M>') + '</M>' AS XML) AS String, fVehicleBrandID, fID   FROM  tRefVehicle) AS a CROSS APPLY String.nodes ('/M') AS Split(a)) as tV
	LEFT JOIN (
		SELECT [dbo].[replaceIllegalChar](fBrandName) as fBrandName, fID from tRefBrand 
			UNION ALL 
		SELECT Split.a.value('.', 'VARCHAR(100)') AS String, fID  from (SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](fBrandAlias), ';', '</M><M>') + '</M>' AS XML) AS String, fID  FROM  tRefBrand ) AS a CROSS APPLY String.nodes ('/M') AS Split(a)) as tB 
	on tB.fID = tV.fVehicleBrandID
	WHERE NOT tV.fVehicleName = ''
	AND NOT tB.fBrandName = ''


	--get countries
	DECLARE @tTempTableCountries TABLE (fCountryID int, fCountryName nvarchar(200))
	-- insert in brand and vehicle name combos
	INSERT INTO @tTempTableCountries
	SELECT fID, fCountryName from tRefCountry 
	WHERE NOT fActive = 0																				
		UNION ALL 																		
	SELECT fID as fCountryID, fCountryCode as fCountryName from tRefCountry 
	WHERE NOT fActive = 0   																		
		UNION ALL 																		
	SELECT fCountryID, Split.a.value('.', 'VARCHAR(100)') AS String  
	from (SELECT fID as fCountryID, CAST ('<M>' + REPLACE(fCountryAlias, ';', '</M><M>') + '</M>' AS XML) AS String FROM  tRefCountry WHERE NOT fActive = 0) 
	AS a CROSS APPLY String.nodes ('/M') AS Split(a)
	

	--get locations
	DECLARE @tTempTableLocations TABLE (fLocationID int, fLocationName nvarchar(200))
	-- insert in brand and vehicle name combos
	INSERT INTO @tTempTableLocations
	SELECT fID, fLocationName from tRefLocation
	WHERE NOT fActive = 0																				
		UNION ALL 																		
	SELECT fID as fLocationID, fLocationCode as fLocationName from tRefLocation 
	WHERE NOT fActive = 0   																		
		UNION ALL 																		
	SELECT fLocationID, Split.a.value('.', 'VARCHAR(100)') AS String  
	from (SELECT fID as fLocationID, CAST ('<M>' + REPLACE(fLocationAlias, ';', '</M><M>') + '</M>' AS XML) AS String FROM  tRefLocation WHERE NOT fActive = 0) 
	AS a CROSS APPLY String.nodes ('/M') AS Split(a)
	

	--get websites
	DECLARE @tTempTableWebsites TABLE (fWebsiteID int, fWebsiteDomain nvarchar(200))
	-- insert in brand and vehicle name combos
	INSERT INTO @tTempTableWebsites
	SELECT fID, fWebsiteName from tRefWebsite
	WHERE NOT fActive = 0																																					
		UNION ALL 		
	SELECT fID as fWebsiteID, fWebsiteDomain from tRefWebsite
	WHERE NOT fActive = 0																																					
		UNION ALL 																	
	SELECT fWebsiteID, Split.a.value('.', 'VARCHAR(100)') AS String  
	from (SELECT fID as fWebsiteID, CAST ('<M>' + REPLACE(fWebsiteAlias, ';', '</M><M>') + '</M>' AS XML) AS String FROM  tRefWebsite WHERE NOT fActive = 0) 
	AS a CROSS APPLY String.nodes ('/M') AS Split(a)


	INSERT INTO tDataScanClean
		(fScanID
		,fScanDate
		,fScanURL
		,fScanTravelCountryID
		,fScanPickupLocationID
		,fScanReturnLocationID
		,fScanPickupDate
		,fScanReturnDate
		,fScanLicenceCountryID
		,fScanBrandID
		,fScanVehicleID
		,fScanTotalPrice
		,fScanCurrencyID)	  
	SELECT MIN (d.fID)
		, [dbo].[checkScanDate](d.fScanDate)
		, wID.fWebsiteID	
		, cID.fCountryID
		, pID.fLocationID 
		, rID.fLocationID 
		, d.fScanPickupDate
		, d.fScanReturnDate
		, lID.fCountryID 
		, BandV.fBrandID
		, BandV.fVehicleID
		, d.fScanTotalPrice
		, curID.fID 
			
	FROM @tData as d
	-- get id of country
	INNER JOIN @tTempTableCountries as cID on [dbo].[replaceIllegalChar](d.fScanTravelCountry) =  [dbo].[replaceIllegalChar](cID.fCountryName	)	
	-- get drivers license country
	INNER JOIN @tTempTableCountries as lID on [dbo].[replaceIllegalChar](d.fScanLicenceCountry) = [dbo].[replaceIllegalChar](lID.fCountryName)				
	-- get pickup location
	INNER JOIN @tTempTableLocations as pID on [dbo].[replaceIllegalChar](d.fScanPickupLocation) = [dbo].[replaceIllegalChar](pID.fLocationName)			
	-- get  return location
	INNER JOIN @tTempTableLocations as rID on [dbo].[replaceIllegalChar](d.fScanReturnLocation) = [dbo].[replaceIllegalChar](rID.fLocationName)		
	-- get brand and vehicle IDs
	INNER JOIN @tTempTable as BandV on [dbo].[replaceIllegalChar](d.fScanBrandName) = [dbo].[replaceIllegalChar](BandV.fBrandName) AND [dbo].[replaceIllegalChar](d.fScanVehicleName) = [dbo].[replaceIllegalChar](BandV.fVehicleName)
	---- get website  
	INNER JOIN @tTempTableWebsites  as wID on d.fScanURL= wID.fWebsiteDomain		
	-- get currency
	INNER JOIN tRefCurrency as curID on curID.fCurrencyCode = d.fScanCurrency
			
	GROUP BY d.fScanDate
		, wID.fWebsiteID	
		, cID.fCountryID
		, pID.fLocationID 
		, rID.fLocationID 
		, d.fScanPickupDate
		, d.fScanReturnDate
		, lID.fCountryID 
		, BandV.fBrandID
		, BandV.fVehicleID
		, d.fScanTotalPrice
		, curID.fID 

		
	DELETE FROM @tTempTable
	DELETE FROM @tTempTableCountries
	DELETE FROM @tTempTableLocations
	DELETE FROM @tTempTableWebsites
	
	DECLARE @newCount int
	SET @newCount = (SELECT TOP 1 fID from tDataScanClean ORDER BY fID DESC)

	SELECT (@newCount - @oldCount) as 'fDataCount'

END






GO
/****** Object:  StoredProcedure [dbo].[checkDataSpread]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sally Gamer
-- Create date: 04-09-15
-- Description:	look at spread of data to determine if there are holes in the data received.
-- =============================================
CREATE PROCEDURE [dbo].[checkDataSpread]
	-- Add the parameters for the stored procedure here
	@thisWeek smalldatetime, 
	@thisCountry int
AS
BEGIN
	
DECLARE @tTempData TABLE (
		fID int IDENTITY(1,1) PRIMARY KEY 
	  ,fCount int
      ,fScanID int
      ,fScanDate smalldatetime
      ,fScanURL int
      ,fScanTravelCountryID int
      ,fScanPickupLocationID int
      ,fScanReturnLocationID int
      ,fScanPickupDate smalldatetime
      ,fScanReturnDate smalldatetime
      ,fScanLicenceCountryID int
      ,fScanBrandID int
      ,fScanVehicleID int
	  )

	INSERT INTO @tTempData (
		fCount
      ,fScanID
      ,fScanDate
      ,fScanURL
      ,fScanTravelCountryID
      ,fScanPickupLocationID
      ,fScanReturnLocationID
      ,fScanPickupDate
      ,fScanReturnDate
      ,fScanLicenceCountryID
      ,fScanBrandID
      ,fScanVehicleID
	  )
	SELECT 		
	   count(fScanID)
      ,min(fScanID)
      ,fScanDate
      ,fScanURL
      ,fScanTravelCountryID
      ,fScanPickupLocationID
      ,fScanReturnLocationID
      ,fScanPickupDate
      ,fScanReturnDate
      ,fScanLicenceCountryID
      ,fScanBrandID
      ,fScanVehicleID
	FROM tDataScanClean
	WHERE fScanDate > dateadd(day,-1,@thisWeek) AND fScanDate < dateadd(day,6,@thisWeek)
		AND @thisCountry = fScanTravelCountryID
		AND fActive = 1
		AND fScanVehicleID in (select fID from tRefVehicle WHERE fVehicleBrandID in (select fID from tRefBrand WHERE fBrandIsApolloFamily = 1))
	GROUP BY
		fScanID
      ,fScanDate
      ,fScanURL
      ,fScanTravelCountryID
      ,fScanPickupLocationID
      ,fScanReturnLocationID
      ,fScanPickupDate
      ,fScanReturnDate
      ,fScanLicenceCountryID
      ,fScanBrandID
      ,fScanVehicleID


	  
DECLARE @tTempDataCounts TABLE (
		fID int IDENTITY(1,1) PRIMARY KEY 
	  ,fScanURL int
      ,fScanTravelCountryID int
      ,fScanPickupLocationID int
      ,fScanReturnLocationID int
      ,fScanPickupDate smalldatetime
      ,fScanReturnDate smalldatetime
      ,fScanLicenceCountryID int
      ,fScanBrandID int
      --,fScanVehicleID int	  
	  ,fCount int DEFAULT 0
	  ,fCount2 int  DEFAULT 0
	  ,fCount3 int  DEFAULT 0
	  )

	INSERT INTO @tTempDataCounts (
	     fScanURL 
		,fScanTravelCountryID
		,fScanPickupLocationID
		,fScanReturnLocationID
		,fScanPickupDate
		,fScanReturnDate
		,fScanLicenceCountryID
		,fScanBrandID
		--,fScanVehicleID
		)
	SELECT
	     fScanURL 
		,fScanTravelCountryID
		,fScanPickupLocationID
		,fScanReturnLocationID
		,fScanPickupDate
		,fScanReturnDate
		,fScanLicenceCountryID
		,fScanBrandID
		--,fScanVehicleID
	FROM  @tTempData
	GROUP BY 
	     fScanURL 
		,fScanTravelCountryID
		,fScanPickupLocationID
		,fScanReturnLocationID
		,fScanPickupDate
		,fScanReturnDate
		,fScanLicenceCountryID
		,fScanBrandID
		--,fScanVehicleID

	--SELECT * FROM  @tTempDataCounts


	----get counts
	--DECLARE @totalRowCount int, @currentRow int, @thisTravelCountryID int, @thisPickupLocationID int	,@thisReturnLocationID int		,@thisPickupDate smalldatetime		,@thisReturnDate smalldatetime		,@thisLicenceCountryID int		,@thisBrandID int 	,@thisVehicleID int
	--SET @currentRow = 0
	--SET @totalRowCount = 1000 --(SELECT count(fID) FROM @tTempDataCounts)

	--WHILE @currentRow < @totalRowCount
	--	BEGIN
	--		SET @thisTravelCountryID  = (SELECT fScanTravelCountryID FROM @tTempDataCounts WHERE fID = @currentRow)
	--		SET @thisPickupLocationID  = (SELECT fScanPickupLocationID FROM @tTempDataCounts WHERE fID = @currentRow)	
	--		SET @thisReturnLocationID  = (SELECT fScanReturnLocationID FROM @tTempDataCounts WHERE fID = @currentRow)		
	--		SET @thisPickupDate  = (SELECT fScanPickupDate FROM @tTempDataCounts WHERE fID = @currentRow)		
	--		SET @thisReturnDate  = (SELECT fScanReturnDate FROM @tTempDataCounts WHERE fID = @currentRow)		
	--		SET @thisLicenceCountryID  = (SELECT fScanLicenceCountryID FROM @tTempDataCounts WHERE fID = @currentRow)		
	--		SET @thisBrandID  = (SELECT fScanBrandID FROM @tTempDataCounts WHERE fID = @currentRow) 	
	--		--SET @thisVehicleID  = (SELECT fScanVehicleID FROM @tTempDataCounts WHERE fID = @currentRow)

	--		UPDATE @tTempDataCounts
	--		SET fCount = (	SELECT count(fID) from @tTempData 
	--						WHERE fScanURL = 1
	--						AND fScanTravelCountryID = @thisTravelCountryID
	--						AND fScanPickupLocationID = @thisPickupLocationID
	--						AND fScanReturnLocationID = @thisReturnLocationID
	--						AND fScanPickupDate = @thisPickupDate
	--						AND fScanReturnDate = @thisReturnDate
	--						AND fScanLicenceCountryID = @thisLicenceCountryID
	--						AND fScanBrandID = @thisBrandID
	--						--AND fScanVehicleID = @thisVehicleID
	--					 )
	--		  , fCount2 = (	SELECT count(fID) from @tTempData 
	--						WHERE fScanURL = 2
	--						AND fScanTravelCountryID = @thisTravelCountryID
	--						AND fScanPickupLocationID = @thisPickupLocationID
	--						AND fScanReturnLocationID = @thisReturnLocationID
	--						AND fScanPickupDate = @thisPickupDate
	--						AND fScanReturnDate = @thisReturnDate
	--						AND fScanLicenceCountryID = @thisLicenceCountryID
	--						AND fScanBrandID = @thisBrandID
	--						--AND fScanVehicleID = @thisVehicleID
	--					 )
	--		  , fCount3 = (	SELECT count(fID) from @tTempData 
	--						WHERE fScanURL = 3
	--						AND fScanTravelCountryID = @thisTravelCountryID
	--						AND fScanPickupLocationID = @thisPickupLocationID
	--						AND fScanReturnLocationID = @thisReturnLocationID
	--						AND fScanPickupDate = @thisPickupDate
	--						AND fScanReturnDate = @thisReturnDate
	--						AND fScanLicenceCountryID = @thisLicenceCountryID
	--						AND fScanBrandID = @thisBrandID
	--						--AND fScanVehicleID = @thisVehicleID
	--					 )
	--		  , fCount4 = (	SELECT count(fID) from @tTempData 
	--						WHERE fScanURL = 4
	--						AND fScanTravelCountryID = @thisTravelCountryID
	--						AND fScanPickupLocationID = @thisPickupLocationID
	--						AND fScanReturnLocationID = @thisReturnLocationID
	--						AND fScanPickupDate = @thisPickupDate
	--						AND fScanReturnDate = @thisReturnDate
	--						AND fScanLicenceCountryID = @thisLicenceCountryID
	--						AND fScanBrandID = @thisBrandID
	--						--AND fScanVehicleID = @thisVehicleID
	--					 )
	--		  , fCount5 = (	SELECT count(fID) from @tTempData 
	--						WHERE fScanURL = 5
	--						AND fScanTravelCountryID = @thisTravelCountryID
	--						AND fScanPickupLocationID = @thisPickupLocationID
	--						AND fScanReturnLocationID = @thisReturnLocationID
	--						AND fScanPickupDate = @thisPickupDate
	--						AND fScanReturnDate = @thisReturnDate
	--						AND fScanLicenceCountryID = @thisLicenceCountryID
	--						AND fScanBrandID = @thisBrandID
	--						--AND fScanVehicleID = @thisVehicleID
	--					 )
	--		  , fCount6 = (	SELECT count(fID) from @tTempData 
	--						WHERE fScanURL = 6
	--						AND fScanTravelCountryID = @thisTravelCountryID
	--						AND fScanPickupLocationID = @thisPickupLocationID
	--						AND fScanReturnLocationID = @thisReturnLocationID
	--						AND fScanPickupDate = @thisPickupDate
	--						AND fScanReturnDate = @thisReturnDate
	--						AND fScanLicenceCountryID = @thisLicenceCountryID
	--						AND fScanBrandID = @thisBrandID
	--						--AND fScanVehicleID = @thisVehicleID
	--					 )
	--		  , fCount7 = (	SELECT count(fID) from @tTempData 
	--						WHERE fScanURL = 7
	--						AND fScanTravelCountryID = @thisTravelCountryID
	--						AND fScanPickupLocationID = @thisPickupLocationID
	--						AND fScanReturnLocationID = @thisReturnLocationID
	--						AND fScanPickupDate = @thisPickupDate
	--						AND fScanReturnDate = @thisReturnDate
	--						AND fScanLicenceCountryID = @thisLicenceCountryID
	--						AND fScanBrandID = @thisBrandID
	--						--AND fScanVehicleID = @thisVehicleID
	--					 )
	--		  , fCount8 = (	SELECT count(fID) from @tTempData 
	--						WHERE fScanURL = 8
	--						AND fScanTravelCountryID = @thisTravelCountryID
	--						AND fScanPickupLocationID = @thisPickupLocationID
	--						AND fScanReturnLocationID = @thisReturnLocationID
	--						AND fScanPickupDate = @thisPickupDate
	--						AND fScanReturnDate = @thisReturnDate
	--						AND fScanLicenceCountryID = @thisLicenceCountryID
	--						AND fScanBrandID = @thisBrandID
	--						--AND fScanVehicleID = @thisVehicleID
	--					 )

	--		SET @currentRow = @currentRow + 1
	--	END

	--SELECT * FROM @tTempDataCounts

	SELECT 
	   tD.fID
      ,tD.fScanTravelCountryID
      ,tD.fScanPickupLocationID
      ,tD.fScanReturnLocationID
      ,tD.fScanPickupDate
      ,tD.fScanReturnDate
      ,tD.fScanBrandID
      --,tD.fScanVehicleID
	  ,isnull(t1.fCount,0) as fCount1
	  ,isnull(tL1.fCount,0) as fLCount1
	  ,isnull(t2.fCount,0) as fCount2
	  ,isnull(tL2.fCount,0) as fLCount2
	  ,isnull(t3.fCount,0) as fCount3
	  ,isnull(tL3.fCount,0) as fLCount3
	  --,isnull(t4.fCount,0) as fCount4
	  ----,isnull(tL4.fCount,0) as fLCount4
	  --,isnull(t5.fCount,0) as fCount5
	  ----,isnull(tL5.fCount,0) as fLCount5
	  --,isnull(t6.fCount,0) as fCount6
	  ----,isnull(tL6.fCount,0) as fLCount6
	  --,isnull(t7.fCount,0) as fCount7
	  --,isnull(tL7.fCount,0) as fLCount7
	  --,isnull(t8.fCount,0) as fCount8
	  ----,isnull(tL8.fCount,0) as fLCount8
	FROM 
		( SELECT 
		 min(fID) as fID
      ,fScanTravelCountryID
      ,fScanPickupLocationID
      ,fScanReturnLocationID
      ,fScanPickupDate
      ,fScanReturnDate
      ,fScanBrandID
	  FROM
	  @tTempDataCounts
	  GROUP BY 
		fScanTravelCountryID
      ,fScanPickupLocationID
      ,fScanReturnLocationID
      ,fScanPickupDate
      ,fScanReturnDate
      ,fScanBrandID	  
	  ) as tD

	LEFT JOIN (SELECT 
					count(fID) as fCount
				  ,fScanTravelCountryID
				  ,fScanPickupLocationID
				  ,fScanReturnLocationID
				  ,fScanPickupDate
				  ,fScanReturnDate
				  ,fScanLicenceCountryID
				  ,fScanBrandID
				FROM  @tTempData
				WHERE fScanURL = 1
				and fScanLicenceCountryID = 1
				GROUP BY 
					fScanTravelCountryID
				  ,fScanPickupLocationID
				  ,fScanReturnLocationID
				  ,fScanPickupDate
				  ,fScanReturnDate
				  ,fScanLicenceCountryID
				  ,fScanBrandID
		) as t1 
			on	t1.fScanTravelCountryID = tD.fScanTravelCountryID 
			AND t1.fScanPickupLocationID = tD.fScanPickupLocationID 
			AND t1.fScanReturnLocationID = tD.fScanReturnLocationID 
			AND t1.fScanPickupDate = tD.fScanPickupDate 
			AND t1.fScanReturnDate = tD.fScanReturnDate 
			--AND t1.fScanLicenceCountryID = tD.fScanLicenceCountryID 
			AND t1.fScanBrandID = tD.fScanBrandID 
		
	LEFT JOIN (SELECT 
					count(fID) as fCount
				  ,fScanTravelCountryID
				  ,fScanPickupLocationID
				  ,fScanReturnLocationID
				  ,fScanPickupDate
				  ,fScanReturnDate
				  ,fScanLicenceCountryID
				  ,fScanBrandID
				FROM  @tTempData
				WHERE fScanURL = 1
				and nOT fScanLicenceCountryID = 1
				GROUP BY 
					fScanTravelCountryID
				  ,fScanPickupLocationID
				  ,fScanReturnLocationID
				  ,fScanPickupDate
				  ,fScanReturnDate
				  ,fScanLicenceCountryID
				  ,fScanBrandID
		) as tL1 
			on	tL1.fScanTravelCountryID = tD.fScanTravelCountryID 
			AND tL1.fScanPickupLocationID = tD.fScanPickupLocationID 
			AND tL1.fScanReturnLocationID = tD.fScanReturnLocationID 
			AND tL1.fScanPickupDate = tD.fScanPickupDate 
			AND tL1.fScanReturnDate = tD.fScanReturnDate 
			--AND tL1.fScanLicenceCountryID = tD.fScanLicenceCountryID 
			AND tL1.fScanBrandID = tD.fScanBrandID 
			
	LEFT JOIN (SELECT 
					count(fID) as fCount
				  ,fScanTravelCountryID
				  ,fScanPickupLocationID
				  ,fScanReturnLocationID
				  ,fScanPickupDate
				  ,fScanReturnDate
				  ,fScanLicenceCountryID
				  ,fScanBrandID
				FROM  @tTempData
				WHERE fScanURL = 2
				and fScanLicenceCountryID = 1
				GROUP BY 
					fScanTravelCountryID
				  ,fScanPickupLocationID
				  ,fScanReturnLocationID
				  ,fScanPickupDate
				  ,fScanReturnDate
				  ,fScanLicenceCountryID
				  ,fScanBrandID
		) as t2 
			on	t2.fScanTravelCountryID = tD.fScanTravelCountryID 
			AND t2.fScanPickupLocationID = tD.fScanPickupLocationID 
			AND t2.fScanReturnLocationID = tD.fScanReturnLocationID 
			AND t2.fScanPickupDate = tD.fScanPickupDate 
			AND t2.fScanReturnDate = tD.fScanReturnDate 
			--AND t2.fScanLicenceCountryID = tD.fScanLicenceCountryID 
			AND t2.fScanBrandID = tD.fScanBrandID 
	
	LEFT JOIN (SELECT 
					count(fID) as fCount
				  ,fScanTravelCountryID
				  ,fScanPickupLocationID
				  ,fScanReturnLocationID
				  ,fScanPickupDate
				  ,fScanReturnDate
				  ,fScanLicenceCountryID
				  ,fScanBrandID
				FROM  @tTempData
				WHERE fScanURL = 2
				and NOT fScanLicenceCountryID = 1
				GROUP BY 
					fScanTravelCountryID
				  ,fScanPickupLocationID
				  ,fScanReturnLocationID
				  ,fScanPickupDate
				  ,fScanReturnDate
				  ,fScanLicenceCountryID
				  ,fScanBrandID
		) as tL2 
			on	tL2.fScanTravelCountryID = tD.fScanTravelCountryID 
			AND tL2.fScanPickupLocationID = tD.fScanPickupLocationID 
			AND tL2.fScanReturnLocationID = tD.fScanReturnLocationID 
			AND tL2.fScanPickupDate = tD.fScanPickupDate 
			AND tL2.fScanReturnDate = tD.fScanReturnDate 
			--AND tL2.fScanLicenceCountryID = tD.fScanLicenceCountryID 
			AND tL2.fScanBrandID = tD.fScanBrandID 

	LEFT JOIN (SELECT 
					count(fID) as fCount
				  ,fScanTravelCountryID
				  ,fScanPickupLocationID
				  ,fScanReturnLocationID
				  ,fScanPickupDate
				  ,fScanReturnDate
				  ,fScanLicenceCountryID
				  ,fScanBrandID
				FROM  @tTempData
				WHERE fScanURL = 3
				and fScanLicenceCountryID = 1
				GROUP BY 
					fScanTravelCountryID
				  ,fScanPickupLocationID
				  ,fScanReturnLocationID
				  ,fScanPickupDate
				  ,fScanReturnDate
				  ,fScanLicenceCountryID
				  ,fScanBrandID
		) as t3 
			on	t3.fScanTravelCountryID = tD.fScanTravelCountryID 
			AND t3.fScanPickupLocationID = tD.fScanPickupLocationID 
			AND t3.fScanReturnLocationID = tD.fScanReturnLocationID 
			AND t3.fScanPickupDate = tD.fScanPickupDate 
			AND t3.fScanReturnDate = tD.fScanReturnDate 
			--AND t3.fScanLicenceCountryID = tD.fScanLicenceCountryID 
			AND t3.fScanBrandID = tD.fScanBrandID 
			
	LEFT JOIN (SELECT 
					count(fID) as fCount
				  ,fScanTravelCountryID
				  ,fScanPickupLocationID
				  ,fScanReturnLocationID
				  ,fScanPickupDate
				  ,fScanReturnDate
				  ,fScanLicenceCountryID
				  ,fScanBrandID
				FROM  @tTempData
				WHERE fScanURL = 3
				and NOT fScanLicenceCountryID = 1
				GROUP BY 
					fScanTravelCountryID
				  ,fScanPickupLocationID
				  ,fScanReturnLocationID
				  ,fScanPickupDate
				  ,fScanReturnDate
				  ,fScanLicenceCountryID
				  ,fScanBrandID
		) as tL3 
			on	tL3.fScanTravelCountryID = tD.fScanTravelCountryID 
			AND tL3.fScanPickupLocationID = tD.fScanPickupLocationID 
			AND tL3.fScanReturnLocationID = tD.fScanReturnLocationID 
			AND tL3.fScanPickupDate = tD.fScanPickupDate 
			AND tL3.fScanReturnDate = tD.fScanReturnDate 
			--AND tL3.fScanLicenceCountryID = tD.fScanLicenceCountryID 
			AND tL3.fScanBrandID = tD.fScanBrandID 

	--LEFT JOIN (SELECT 
	--				count(fID) as fCount
	--			  ,fScanTravelCountryID
	--			  ,fScanPickupLocationID
	--			  ,fScanReturnLocationID
	--			  ,fScanPickupDate
	--			  ,fScanReturnDate
	--			  ,fScanLicenceCountryID
	--			  ,fScanBrandID
	--			FROM  @tTempData
	--			WHERE fScanURL = 4
	--			GROUP BY 
	--				fScanTravelCountryID
	--			  ,fScanPickupLocationID
	--			  ,fScanReturnLocationID
	--			  ,fScanPickupDate
	--			  ,fScanReturnDate
	--			  ,fScanLicenceCountryID
	--			  ,fScanBrandID
	--	) as t4 
	--		on	t4.fScanTravelCountryID = tD.fScanTravelCountryID 
	--		AND t4.fScanPickupLocationID = tD.fScanPickupLocationID 
	--		AND t4.fScanReturnLocationID = tD.fScanReturnLocationID 
	--		AND t4.fScanPickupDate = tD.fScanPickupDate 
	--		AND t4.fScanReturnDate = tD.fScanReturnDate 
	--		--AND t4.fScanLicenceCountryID = tD.fScanLicenceCountryID 
	--		AND t4.fScanBrandID = tD.fScanBrandID 


	--LEFT JOIN (SELECT 
	--				count(fID) as fCount
	--			  ,fScanTravelCountryID
	--			  ,fScanPickupLocationID
	--			  ,fScanReturnLocationID
	--			  ,fScanPickupDate
	--			  ,fScanReturnDate
	--			  ,fScanLicenceCountryID
	--			  ,fScanBrandID
	--			FROM  @tTempData
	--			WHERE fScanURL = 5
	--			GROUP BY 
	--				fScanTravelCountryID
	--			  ,fScanPickupLocationID
	--			  ,fScanReturnLocationID
	--			  ,fScanPickupDate
	--			  ,fScanReturnDate
	--			  ,fScanLicenceCountryID
	--			  ,fScanBrandID
	--	) as t5 
	--		on	t5.fScanTravelCountryID = tD.fScanTravelCountryID 
	--		AND t5.fScanPickupLocationID = tD.fScanPickupLocationID 
	--		AND t5.fScanReturnLocationID = tD.fScanReturnLocationID 
	--		AND t5.fScanPickupDate = tD.fScanPickupDate 
	--		AND t5.fScanReturnDate = tD.fScanReturnDate 
	--		--AND t5.fScanLicenceCountryID = tD.fScanLicenceCountryID 
	--		AND t5.fScanBrandID = tD.fScanBrandID 
			

	--LEFT JOIN (SELECT 
	--				count(fID) as fCount
	--			  ,fScanTravelCountryID
	--			  ,fScanPickupLocationID
	--			  ,fScanReturnLocationID
	--			  ,fScanPickupDate
	--			  ,fScanReturnDate
	--			  ,fScanLicenceCountryID
	--			  ,fScanBrandID
	--			FROM  @tTempData
	--			WHERE fScanURL = 6
	--			GROUP BY 
	--				fScanTravelCountryID
	--			  ,fScanPickupLocationID
	--			  ,fScanReturnLocationID
	--			  ,fScanPickupDate
	--			  ,fScanReturnDate
	--			  ,fScanLicenceCountryID
	--			  ,fScanBrandID
	--	) as t6 
	--		on	t6.fScanTravelCountryID = tD.fScanTravelCountryID 
	--		AND t6.fScanPickupLocationID = tD.fScanPickupLocationID 
	--		AND t6.fScanReturnLocationID = tD.fScanReturnLocationID 
	--		AND t6.fScanPickupDate = tD.fScanPickupDate 
	--		AND t6.fScanReturnDate = tD.fScanReturnDate 
	--		--AND t6.fScanLicenceCountryID = tD.fScanLicenceCountryID 
	--		AND t6.fScanBrandID = tD.fScanBrandID 

	--LEFT JOIN (SELECT 
	--				count(fID) as fCount
	--			  ,fScanTravelCountryID
	--			  ,fScanPickupLocationID
	--			  ,fScanReturnLocationID
	--			  ,fScanPickupDate
	--			  ,fScanReturnDate
	--			  ,fScanLicenceCountryID
	--			  ,fScanBrandID
	--			FROM  @tTempData
	--			WHERE fScanURL = 7
	--			and fScanLicenceCountryID = 1
	--			GROUP BY 
	--				fScanTravelCountryID
	--			  ,fScanPickupLocationID
	--			  ,fScanReturnLocationID
	--			  ,fScanPickupDate
	--			  ,fScanReturnDate
	--			  ,fScanLicenceCountryID
	--			  ,fScanBrandID
	--	) as t7 
	--		on	t7.fScanTravelCountryID = tD.fScanTravelCountryID 
	--		AND t7.fScanPickupLocationID = tD.fScanPickupLocationID 
	--		AND t7.fScanReturnLocationID = tD.fScanReturnLocationID 
	--		AND t7.fScanPickupDate = tD.fScanPickupDate 
	--		AND t7.fScanReturnDate = tD.fScanReturnDate 
	--		--AND t7.fScanLicenceCountryID = tD.fScanLicenceCountryID 
	--		AND t7.fScanBrandID = tD.fScanBrandID 
			
	--LEFT JOIN (SELECT 
	--				count(fID) as fCount
	--			  ,fScanTravelCountryID
	--			  ,fScanPickupLocationID
	--			  ,fScanReturnLocationID
	--			  ,fScanPickupDate
	--			  ,fScanReturnDate
	--			  ,fScanLicenceCountryID
	--			  ,fScanBrandID
	--			FROM  @tTempData
	--			WHERE fScanURL = 7
	--			and NOT fScanLicenceCountryID = 1
	--			GROUP BY 
	--				fScanTravelCountryID
	--			  ,fScanPickupLocationID
	--			  ,fScanReturnLocationID
	--			  ,fScanPickupDate
	--			  ,fScanReturnDate
	--			  ,fScanLicenceCountryID
	--			  ,fScanBrandID
	--	) as tL7 
	--		on	tL7.fScanTravelCountryID = tD.fScanTravelCountryID 
	--		AND tL7.fScanPickupLocationID = tD.fScanPickupLocationID 
	--		AND tL7.fScanReturnLocationID = tD.fScanReturnLocationID 
	--		AND tL7.fScanPickupDate = tD.fScanPickupDate 
	--		AND tL7.fScanReturnDate = tD.fScanReturnDate 
	--		--AND tL7.fScanLicenceCountryID = tD.fScanLicenceCountryID 
	--		AND tL7.fScanBrandID = tD.fScanBrandID 

	--LEFT JOIN (SELECT 
	--				count(fID) as fCount
	--			  ,fScanTravelCountryID
	--			  ,fScanPickupLocationID
	--			  ,fScanReturnLocationID
	--			  ,fScanPickupDate
	--			  ,fScanReturnDate
	--			  ,fScanLicenceCountryID
	--			  ,fScanBrandID
	--			FROM  @tTempData
	--			WHERE fScanURL = 8
	--			GROUP BY 
	--				fScanTravelCountryID
	--			  ,fScanPickupLocationID
	--			  ,fScanReturnLocationID
	--			  ,fScanPickupDate
	--			  ,fScanReturnDate
	--			  ,fScanLicenceCountryID
	--			  ,fScanBrandID
	--	) as t8 
	--		on	t8.fScanTravelCountryID = tD.fScanTravelCountryID 
	--		AND t8.fScanPickupLocationID = tD.fScanPickupLocationID 
	--		AND t8.fScanReturnLocationID = tD.fScanReturnLocationID 
	--		AND t8.fScanPickupDate = tD.fScanPickupDate 
	--		AND t8.fScanReturnDate = tD.fScanReturnDate 
	--		--AND t8.fScanLicenceCountryID = tD.fScanLicenceCountryID 
	--		AND t8.fScanBrandID = tD.fScanBrandID 


	WHERE NOT 
		(	t1.fCount = tL1.fCount
		AND t1.fCount = t2.fCount
		AND t1.fCount = tL2.fCount
		AND t1.fCount = t3.fCount
		AND t1.fCount = tL3.fCount)

END


GO
/****** Object:  StoredProcedure [dbo].[checkForData]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sally Gamer
-- Create date: 06/08/15
-- Description:	Check if this week's data has arrived
-- =============================================
CREATE PROCEDURE [dbo].[checkForData]
	@dateToCheck smalldatetime
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @firstDate date, @lastDate date, @firstDayOfWeek date
	SET @firstDayOfWeek = [dbo].[getFirstDayOfWeek](@dateToCheck)
	SET @lastDate = dateadd(dd,6,@firstDayOfWeek)
	SET @firstDate = dateadd(dd,-2,@firstDayOfWeek)

	DECLARE @count int, @countClean int

	SET @count = 
	(	SELECT count(fID) as fScanCount FROM tDataScan
		WHERE fScanDate >= @firstDate AND fScanDate <= @lastDate
	)
	SET @countClean = 
	(
		SELECT count(fID) as fScanCleanCount FROM tDataScanClean
		WHERE fScanDate >= @firstDate AND fScanDate <= @lastDate AND fActive > 0
	) 

	SELECT  @count as fScanCount, @countClean as fScanCleanCount

END


GO
/****** Object:  StoredProcedure [dbo].[deleteData]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <13/03/2015>
-- Description:	<Deactivate invalid data>
-- =============================================
CREATE PROCEDURE [dbo].[deleteData]
	@badID int
AS
BEGIN

	SET NOCOUNT ON;

    UPDATE tDataScan 
	SET fActive = 0
	WHERE fID = @badID


END




GO
/****** Object:  StoredProcedure [dbo].[deleteExceptionsPrices]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <30/03/15>
-- Description:	<remove price exception (change to not active)>
-- =============================================
CREATE PROCEDURE [dbo].[deleteExceptionsPrices]
	@badID int
AS
BEGIN

	SET NOCOUNT ON;

    UPDATE [comparison].[dbo].[tRefPriceException]
	SET fActive = 0
	WHERE fID = @badID
	
    UPDATE [comparison].[dbo].[tRefPriceExceptionLocations]
	SET fActive = 0
	WHERE fExceptionID = @badID
	
    UPDATE [comparison].[dbo].[tRefPriceExceptionBrands]
	SET fActive = 0
	WHERE fExceptionID = @badID

END




GO
/****** Object:  StoredProcedure [dbo].[getExceptionsPricesByID]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <30/03/15>
-- Description:	<Get a single price excpetion by ID>
-- =============================================

CREATE PROCEDURE [dbo].[getExceptionsPricesByID]
	@getID int
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @exceptionTotalCount int, @countTotal int, @PickupList varchar(MAX), @ReturnList varchar(MAX), @addLocation nvarchar(100)
	SET @PickupList = ''
	SET @ReturnList = ''
	SET @exceptionTotalCount = (SELECT top 1 fID FROM tRefPriceExceptionLocations order by fID DESC)
	SET @addLocation = ''
	SET @countTotal = 1
	
	DECLARE @countEx int, @exceptionBrandCount int, @brandList nvarchar(max), @addBrand nvarchar(max), @count int
	SET @count = 1
	SET @countEx = 1
	SET @brandList = ''
	SET @exceptionBrandCount = (SELECT top 1 fID FROM tRefPriceExceptionBrands order by fID DESC)
	SET @addBrand = ''

	-- get pickup/return lists for this exception record
	WHILE @countTotal <= @exceptionTotalCount 
		BEGIN
			-- get pickup locations
			SET @addLocation = (	SELECT tPE.fLocationID									
									from tRefPriceExceptionLocations tPE
									where tPE.fID = @countTotal
									AND tPE.fExceptionID = @getID
									AND fPickupOrDropoff = 1
											AND tPE.fActive = 1)
			SET @PickupList = 
				CASE
					WHEN NOT @addLocation = ''
						THEN CASE
							WHEN @PickupList = ''
								THEN @addLocation
							ELSE concat (@PickupList,', ',@addLocation)
						END
					ELSE @PickupList
				END

			-- get return locations
			SET @addLocation = (	SELECT tPE.fLocationID									
									from tRefPriceExceptionLocations tPE
									where tPE.fID = @countTotal
									AND tPE.fExceptionID = @getID
									AND fPickupOrDropoff = 2
											AND tPE.fActive = 1)
			SET @ReturnList = 
				CASE
					WHEN NOT @addLocation = ''
						THEN CASE
							WHEN @ReturnList = ''
								THEN @addLocation
							ELSE concat (@ReturnList,', ',@addLocation)
						END
					ELSE @ReturnList
				END	

			SET @countTotal = @countTotal + 1
		END		
		
	-- get pickup/return lists for this exception record
		WHILE @countEx <= @exceptionBrandCount 
			BEGIN
				-- get pickup locations
				SET @addBrand = ''
				SET @addBrand = (	SELECT tPE.fBrandID										
										from tRefPriceExceptionBrands tPE
										INNER JOIN tRefBrand as tB on tB.fID = tPE.fBrandID
										where tPE.fID = @countEx
										AND tPE.fExceptionID = @getID
										AND tPE.fActive = 1
										)
				SET @brandList = 
					CASE
						WHEN NOT @addBrand = ''
							THEN CASE
								WHEN @brandList = ''
									THEN @addBrand
								ELSE concat (@brandList,', ',@addBrand)
							END
						ELSE @brandList
					END

				SET @countEx = @countEx + 1
			END		

    SELECT TOP 1 
	   @BrandList as fPriceExceptionBrandID
      ,[fPriceExceptionCountryID]
	  ,@PickupList as fPriceExceptionPickupLocationID
	  ,@ReturnList as fPriceExceptionReturnLocationID
      ,[fPriceExceptionOneWay]
      ,[fPriceExceptionDateStart]
      ,[fPriceExceptionDateEnd]
      ,[fPriceExceptionPriceChange]
      ,[fPriceExceptionPercentage]
      ,[fPriceExceptionCurrencyID]
      ,[fPriceExceptionNote]
  FROM [comparison].[dbo].[tRefPriceException] as tPE

  WHERE tPE.fID = @getID


END




GO
/****** Object:  StoredProcedure [dbo].[getFiltersComparison]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sally Gamer
-- Create date: 28/08/15
-- Description:	get filters for Comparison Report
-- =============================================
CREATE PROCEDURE [dbo].[getFiltersComparison]
	 @DataSetDateStartSDT smalldatetime
	,@websiteID int
	,@countryID int
	,@brandID int
	,@vehicleTypeID int
	,@vehicleBerthID int
AS
BEGIN

	SET NOCOUNT ON;
	   
	--get websites
	DECLARE @tTempWebsites TABLE (
	   fID int
      ,fWebsiteName nvarchar(200)
      ,fWebsiteDomain nvarchar(200)
      ,fWebsiteAlias nvarchar(max)
      ,fWebsiteIncludesFees int
      ,fActive int	  )	
	INSERT INTO @tTempWebsites 
    exec getListWebsites	
	--update website id
	SET @websiteID = 
		CASE
			WHEN @websiteID in (SELECT fID FROM @tTempWebsites)
			THEN @websiteID
			ELSE (SELECT TOP 1 fID FROM @tTempWebsites ORDER BY fID ASC)
		END

	--get travel dates
	DECLARE @tTempTravelDates TABLE(
		fTravelDateText nvarchar(200),
		fTravelDateValue  nvarchar(200)
		)
	INSERT INTO @tTempTravelDates
    exec getListTravelDatesForDataSet @DataSetDateStartSDT
	
	--get brands
	DECLARE @tTempBrands TABLE(
		fID int, 
		fBrandName nvarchar(200)
		)
	INSERT INTO @tTempBrands
    exec getListBrandsActivebyWebsiteCountryIDs @websiteID, @countryID

	--update brand id
	SET @brandID = 
		CASE
			WHEN (@brandID = 0 ) or (@brandID in (SELECT fID FROM @tTempBrands))
			THEN @brandID
			ELSE (SELECT TOP 1 fID FROM @tTempBrands ORDER BY fID ASC)
		END
	
	--get vehicle types
	DECLARE @tTempVehicleTypes TABLE(
		fID int, 
		fVehicleTypeName nvarchar(200)
		)
	INSERT INTO @tTempVehicleTypes
    exec getListVehicleTypesbyWebsiteCountryBrand @websiteID, @countryID, @brandID
	
	--update brand id
	SET @vehicleTypeID = 
		CASE
			WHEN (@vehicleTypeID = 0) or (@vehicleTypeID in (SELECT fID FROM @tTempVehicleTypes))
			THEN @vehicleTypeID
			ELSE (SELECT TOP 1 fID FROM @tTempVehicleTypes ORDER BY fID ASC)
		END

	--get vehicle types
	DECLARE @tTempVehicleBerths TABLE(
		fVehicleBerthValue int, 
		fVehicleBerthName nvarchar(200)
		)
	INSERT INTO @tTempVehicleBerths
    exec getListVehicleBerthsbyWebsiteCountryBrand @websiteID, @countryID, @brandID, @vehicleTypeID 
	
	--update brand id
	SET @vehicleBerthID = 
		CASE
			WHEN (@vehicleBerthID = 0) or (@vehicleBerthID in (SELECT fVehicleBerthValue FROM @tTempVehicleBerths))
			THEN @vehicleBerthID
			ELSE (SELECT TOP 1 fVehicleBerthValue FROM @tTempVehicleBerths ORDER BY fVehicleBerthValue ASC)
		END
		
	--get vehicle 
	DECLARE @tTempVehicles TABLE(
		fID int, 
		fVehicleName nvarchar(200)
		)
	INSERT INTO @tTempVehicles
    exec getListVehiclesbyWebsiteCountryBrand @websiteID, @countryID, @brandID, @vehicleTypeID, @vehicleBerthID
	
	--get locations 
	DECLARE @tTempLocations TABLE(
		fID int
       ,fCountryID int
       ,fLocationName nvarchar(200)
       ,fLocationCode nvarchar(200)
       ,fLocationAlias nvarchar(max)
       ,fActive int	  
		)
	INSERT INTO @tTempLocations
    exec getListLocations @countryID


	--get data from all temp tables
	SELECT  @DataSetDateStartSDT as fDateTime, @websiteID as fWebsiteID, @countryID as fCountryID, @brandID as fBrandID, @vehicleTypeID as fVehicleTypeID, @vehicleBerthID as fVehicleBerthID
	SELECT * FROM @tTempWebsites
	SELECT * FROM @tTempTravelDates
	SELECT * FROM @tTempBrands
	SELECT * FROM @tTempVehicleTypes
	SELECT * FROM @tTempVehicleBerths
	SELECT * FROM @tTempVehicles
	SELECT * FROM @tTempLocations


END


GO
/****** Object:  StoredProcedure [dbo].[getFiltersComparisonSnapashot]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sally Gamer
-- Create date: 28/08/15
-- Description:	get filters for Snapshot Report
-- =============================================
CREATE PROCEDURE [dbo].[getFiltersComparisonSnapashot]
  @DataSetDateStartSDT smalldatetime
, @websiteID int
, @CountryID int
, @BrandID int
, @vehicleID int

AS
BEGIN

	SET NOCOUNT ON;
		   	
	--setup table to return
	DECLARE @tTempTableFinancial TABLE
		(
		 fID int, 
		 fDate nvarchar(10)
		,fYearWeek nvarchar(50)
		,fDataCount int
		)		
	INSERT INTO @tTempTableFinancial (fID, fDate, fYearWeek,fDataCount)
    exec('getFinancialYearListWeeksAndDatesWithData');

	--get travel dates
	DECLARE @tTempTravelDates TABLE(
		fTravelDateText nvarchar(200),
		fTravelDateValue  nvarchar(200)
		)
	INSERT INTO @tTempTravelDates
    exec getListTravelDatesForDataSet @DataSetDateStartSDT

	--get websites
	DECLARE @tTempWebsites TABLE (
	   fID int
      ,fWebsiteName nvarchar(200)
      ,fWebsiteDomain nvarchar(200)
      ,fWebsiteAlias nvarchar(max)
      ,fWebsiteIncludesFees int
      ,fActive int	  )	
	INSERT INTO @tTempWebsites 
    exec getListWebsites	
	--update website id
	SET @websiteID = 
		CASE
			WHEN @websiteID in (SELECT fID FROM @tTempWebsites)
			THEN @websiteID
			ELSE (SELECT TOP 1 fID FROM @tTempWebsites ORDER BY fID ASC)
		END

	--get list of countries
	DECLARE @tTempCountries TABLE (fID int, fCountryName nvarchar(200))
	INSERT INTO @tTempCountries
	SELECT fID, fCountryName 
	FROM tRefCountry WHERE fActive > 0

	--get brands
	DECLARE @tTempBrands TABLE(
		fID int, 
		fBrandName nvarchar(200)
		)
	INSERT INTO @tTempBrands
    exec getListBrandsActivebyWebsiteCountryIDs @websiteID, @countryID
	
	--get locations 
	DECLARE @tTempLocations TABLE(
		fID int
       ,fCountryID int
       ,fLocationName nvarchar(200)
       ,fLocationCode nvarchar(200)
       ,fLocationAlias nvarchar(max)
       ,fActive int	  
		)
	INSERT INTO @tTempLocations
    exec getListLocations @countryID

	--get data from all temp tables
	SELECT  @DataSetDateStartSDT as fDateTime, @countryID as fCountryID, @brandID as fBrandID, @vehicleID as fVehicleID
	SELECT * FROM @tTempTableFinancial
	SELECT * FROM @tTempTravelDates
	SELECT * FROM @tTempWebsites
	SELECT * FROM @tTempCountries
	SELECT * FROM @tTempLocations


END



GO
/****** Object:  StoredProcedure [dbo].[getFiltersComparisonSnapshot]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sally Gamer
-- Create date: 28/08/15
-- Description:	get filters for Snapshot Report
-- =============================================
CREATE PROCEDURE [dbo].[getFiltersComparisonSnapshot]
  @DataSetDateStartSDT smalldatetime
, @websiteID int
, @CountryID int
, @BrandID int
, @vehicleID int

AS
BEGIN

	SET NOCOUNT ON;

	SET @DataSetDateStartSDT = '2015-11-02'
		   	
	--setup table to return
	DECLARE @tTempTableFinancial TABLE
		(
		 fID int, 
		 fDate nvarchar(10)
		,fYearWeek nvarchar(50)
		,fDataCount int
		)		
	INSERT INTO @tTempTableFinancial (fID, fDate, fYearWeek,fDataCount)
    exec('getFinancialYearListWeeksAndDatesWithData');

	--get travel dates
	DECLARE @tTempTravelDates TABLE(
		fTravelDateText nvarchar(200),
		fTravelDateValue  nvarchar(200)
		)
	INSERT INTO @tTempTravelDates
    exec getListTravelDatesForDataSet @DataSetDateStartSDT

	--get websites
	DECLARE @tTempWebsites TABLE (
	   fID int
      ,fWebsiteName nvarchar(200)
      ,fWebsiteDomain nvarchar(200)
      ,fWebsiteAlias nvarchar(max)
      ,fWebsiteIncludesFees int
      ,fActive int	  )	
	INSERT INTO @tTempWebsites 
    exec getListWebsites	
	--update website id
	SET @websiteID = 
		CASE
			WHEN @websiteID in (SELECT fID FROM @tTempWebsites)
			THEN @websiteID
			ELSE (SELECT TOP 1 fID FROM @tTempWebsites ORDER BY fID ASC)
		END

	--get list of countries
	DECLARE @tTempCountries TABLE (fID int, fCountryName nvarchar(200))
	INSERT INTO @tTempCountries
	SELECT fID, fCountryName 
	FROM tRefCountry WHERE fActive > 0

	--get brands
	DECLARE @tTempBrands TABLE(
		fID int, 
		fBrandName nvarchar(200)
		)
	INSERT INTO @tTempBrands
    exec getListBrandsActivebyWebsiteCountryIDs @websiteID, @countryID
	
	--get locations 
	DECLARE @tTempLocations TABLE(
		fID int
       ,fCountryID int
       ,fLocationName nvarchar(200)
       ,fLocationCode nvarchar(200)
       ,fLocationAlias nvarchar(max)
       ,fActive int	  
		)
	INSERT INTO @tTempLocations
    exec getListLocations @countryID

	--get data from all temp tables
	SELECT  @DataSetDateStartSDT as fDateTime, @countryID as fCountryID, @brandID as fBrandID, @vehicleID as fVehicleID
	SELECT * FROM @tTempTableFinancial
	SELECT * FROM @tTempTravelDates
	SELECT * FROM @tTempWebsites
	SELECT * FROM @tTempCountries
	SELECT * FROM @tTempLocations


END



GO
/****** Object:  StoredProcedure [dbo].[getFinancialYearListWeeksAndDates]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <16/03/2015>
-- Description:	<get list of financial weeks and dates>
-- =============================================
CREATE PROCEDURE [dbo].[getFinancialYearListWeeksAndDates]
	
AS
BEGIN

	SET NOCOUNT ON;
	
		--setup table to return
	DECLARE @tTempTableFinancial TABLE
		(
		 fDate nvarchar(10)
		,fYearWeek nvarchar(50)
		)
		
	-- get starting year
	DECLARE @startDate smalldatetime, @checkYear int, @financialYearStartYear int
	SET @startDate = (SELECT TOP 1 fFirstDate FROM tRefFirstDate)
	SET @checkYear = datepart(year,@startDate)
	SET @financialYearStartYear = 
		CASE 
			WHEN @startDate < cast(concat(@checkYear,'-06-01') as smalldatetime)
				THEN datepart(year,dateadd(year,-1,@startDate))
			ELSE datepart(year,@startDate)
		END
	
	--prepare variables for while loops
	DECLARE @DateFinancialYearStarts nvarchar(20),
			@DateFinancialYearEnds nvarchar(20),
			@CountDate smalldatetime,
			@currentDate smalldatetime,
			@CountYear int,
			@WkStartDate smalldatetime,
			@FinancialWk nvarchar(50)
	SET @CountYear = @financialYearStartYear
	SET @CountDate = @startDate

	-- get date of most recent Wednesday (as data goes in the night before)
	SET @currentDate = getdate()
	SET @currentDate =
				CASE	
					WHEN datepart(dw,@currentDate) = 2 -- when today is a Monday
						THEN dateadd(day,1,@currentDate)
					WHEN datepart(dw,@currentDate) = 3 -- when today is a Tuesday
						THEN @currentDate
					WHEN datepart(dw,@currentDate) = 4 -- when today is a Wednesday
						THEN dateadd(day,-1,@currentDate)
					WHEN datepart(dw,@currentDate) = 5 -- when today is a Thursday
						THEN dateadd(day,-2,@currentDate)
					WHEN datepart(dw,@currentDate) = 6 -- when today is a Friday
						THEN dateadd(day,-3,@currentDate)
					WHEN datepart(dw,@currentDate) = 7 -- when today is a Saturday
						THEN dateadd(day,-4,@currentDate)
					WHEN datepart(dw,@currentDate) = 1 -- when today is a Sunday
						THEN dateadd(day,-5,@currentDate)
				END	

	-- run through each year 
	WHILE (@CountYear <= datepart(year,@currentDate))
		BEGIN 
			-- get start date of financial year	
			SET @DateFinancialYearStarts =
				CASE	
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 2 -- when the first is a Monday
						THEN cast(concat(@CountYear,'-07-01') as smalldatetime)
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 3 -- when the first is a Tuesday
						THEN dateadd(day,-1,cast(concat(@CountYear,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 4 -- when the first is a Wednesday
						THEN dateadd(day,-2,cast(concat(@CountYear,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 5 -- when the first is a Thursday
						THEN dateadd(day,-3,cast(concat(@CountYear,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 6 -- when the first is a Friday
						THEN dateadd(day,-4,cast(concat(@CountYear,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 7 -- when the first is a Saturday
						THEN dateadd(day,2,cast(concat(@CountYear,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 1 -- when the first is a Sunday
						THEN dateadd(day,1,cast(concat(@CountYear,'-07-01') as smalldatetime))
				END		
				
			-- get end date of financial year	
			SET @DateFinancialYearEnds =
				CASE	
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 2 -- when the first (of the following year) is a Monday
						THEN dateadd(day,-2,cast(concat(@CountYear+1,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 3 -- when the first (of the following year) is a Tuesday
						THEN dateadd(day,-3,cast(concat(@CountYear+1,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 4 -- when the first (of the following year) is a Wednesday
						THEN dateadd(day,-4,cast(concat(@CountYear+1,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 5 -- when the first (of the following year) is a Thursday
						THEN dateadd(day,-5,cast(concat(@CountYear+1,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 6 -- when the first (of the following year) is a Friday
						THEN dateadd(day,-6,cast(concat(@CountYear+1,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 7 -- when the first (of the following year) is a Saturday
						THEN dateadd(day,1,cast(concat(@CountYear+1,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 1 -- when the first (of the following year) is a Sunday
						THEN cast(concat(@CountYear+1,'-07-01') as smalldatetime)
				END	
			
			-- insert weeks into table
			   WHILE (@CountDate <= @DateFinancialYearEnds) AND (@CountDate <= @currentDate)
			     BEGIN 
        
					SET @FinancialWk = concat(cast((DATEDIFF(WEEK, @DateFinancialYearStarts, @CountDate) + 1) as nvarchar (10)), ' | ', CONVERT(VARCHAR(20),@CountDate,106))

			        INSERT INTO @tTempTableFinancial (fDate, fYearWeek)
					VALUES (CONVERT(VARCHAR(10),@CountDate,126), @FinancialWk)
             
					SET @CountDate = dateadd(week,1,@CountDate)
				END

		SET @CountYear = @CountYear + 1
	END
	
	--remove dates without data
	DECLARE @latestDateWithData date
	SET @latestDateWithData = (SELECT TOP 1 fScanDate FROM tDataScanClean WHERE fActive > 0 ORDER BY fScanDate DESC)
	DELETE FROM @tTempTableFinancial WHERE fDate > @latestDateWithData
	
	-- get data
	SELECT * from @tTempTableFinancial
	ORDER BY fDate DESC
	
	-- drop temp table
	DELETE FROM @tTempTableFinancial


END



GO
/****** Object:  StoredProcedure [dbo].[getFinancialYearListWeeksAndDatesWithData]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <27/08/2015>
-- Description:	<get list of financial weeks and dates>
-- =============================================
CREATE PROCEDURE [dbo].[getFinancialYearListWeeksAndDatesWithData]
	
AS
BEGIN

	SET NOCOUNT ON;
		
	
		--setup table to return
	DECLARE @tTempTableFinancialStart TABLE
		(
		 fDate nvarchar(10)
		,fYearWeek nvarchar(50)
		)
		
	-- get starting year
	DECLARE @startDate smalldatetime, @checkYear int, @financialYearStartYear int
	SET @startDate = (SELECT TOP 1 fFirstDate FROM tRefFirstDate)
	SET @checkYear = datepart(year,@startDate)
	SET @financialYearStartYear = 
		CASE 
			WHEN @startDate < cast(concat(@checkYear,'-06-01') as smalldatetime)
				THEN datepart(year,dateadd(year,-1,@startDate))
			ELSE datepart(year,@startDate)
		END
	
	--prepare variables for while loops
	DECLARE @DateFinancialYearStarts nvarchar(20),
			@DateFinancialYearEnds nvarchar(20),
			@CountDate smalldatetime,
			@currentDate smalldatetime,
			@CountYear int,
			@WkStartDate smalldatetime,
			@FinancialWk nvarchar(50)
	SET @CountYear = @financialYearStartYear
	SET @CountDate = @startDate

	-- get date of most recent Wednesday (as data goes in the night before)
	SET @currentDate = getdate()
	SET @currentDate =
				CASE	
					WHEN datepart(dw,@currentDate) = 2 -- when today is a Monday
						THEN dateadd(day,1,@currentDate)
					WHEN datepart(dw,@currentDate) = 3 -- when today is a Tuesday
						THEN @currentDate
					WHEN datepart(dw,@currentDate) = 4 -- when today is a Wednesday
						THEN dateadd(day,-1,@currentDate)
					WHEN datepart(dw,@currentDate) = 5 -- when today is a Thursday
						THEN dateadd(day,-2,@currentDate)
					WHEN datepart(dw,@currentDate) = 6 -- when today is a Friday
						THEN dateadd(day,-3,@currentDate)
					WHEN datepart(dw,@currentDate) = 7 -- when today is a Saturday
						THEN dateadd(day,-4,@currentDate)
					WHEN datepart(dw,@currentDate) = 1 -- when today is a Sunday
						THEN dateadd(day,-5,@currentDate)
				END	

	-- run through each year 
	WHILE (@CountYear <= datepart(year,@currentDate))
		BEGIN 
			-- get start date of financial year	
			SET @DateFinancialYearStarts =
				CASE	
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 2 -- when the first is a Monday
						THEN cast(concat(@CountYear,'-07-01') as smalldatetime)
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 3 -- when the first is a Tuesday
						THEN dateadd(day,-1,cast(concat(@CountYear,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 4 -- when the first is a Wednesday
						THEN dateadd(day,-2,cast(concat(@CountYear,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 5 -- when the first is a Thursday
						THEN dateadd(day,-3,cast(concat(@CountYear,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 6 -- when the first is a Friday
						THEN dateadd(day,-4,cast(concat(@CountYear,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 7 -- when the first is a Saturday
						THEN dateadd(day,2,cast(concat(@CountYear,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear,'-07-01') as smalldatetime)) = 1 -- when the first is a Sunday
						THEN dateadd(day,1,cast(concat(@CountYear,'-07-01') as smalldatetime))
				END		
				
			-- get end date of financial year	
			SET @DateFinancialYearEnds =
				CASE	
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 2 -- when the first (of the following year) is a Monday
						THEN dateadd(day,-2,cast(concat(@CountYear+1,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 3 -- when the first (of the following year) is a Tuesday
						THEN dateadd(day,-3,cast(concat(@CountYear+1,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 4 -- when the first (of the following year) is a Wednesday
						THEN dateadd(day,-4,cast(concat(@CountYear+1,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 5 -- when the first (of the following year) is a Thursday
						THEN dateadd(day,-5,cast(concat(@CountYear+1,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 6 -- when the first (of the following year) is a Friday
						THEN dateadd(day,-6,cast(concat(@CountYear+1,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 7 -- when the first (of the following year) is a Saturday
						THEN dateadd(day,1,cast(concat(@CountYear+1,'-07-01') as smalldatetime))
					WHEN datepart(dw,cast(concat(@CountYear+1,'-07-01') as smalldatetime)) = 1 -- when the first (of the following year) is a Sunday
						THEN cast(concat(@CountYear+1,'-07-01') as smalldatetime)
				END	
			
			-- insert weeks into table
			   WHILE (@CountDate <= @DateFinancialYearEnds) AND (@CountDate <= @currentDate)
			     BEGIN 
        
					SET @FinancialWk = concat(cast((DATEDIFF(WEEK, @DateFinancialYearStarts, @CountDate) + 1) as nvarchar (10)), ' | ', CONVERT(VARCHAR(20),@CountDate,106))

			        INSERT INTO @tTempTableFinancialStart (fDate, fYearWeek)
					VALUES (CONVERT(VARCHAR(10),@CountDate,126), @FinancialWk)
             
					SET @CountDate = dateadd(week,1,@CountDate)
				END

		SET @CountYear = @CountYear + 1
	END
	
	--remove dates without data
	DECLARE @latestDateWithData date
	SET @latestDateWithData = (SELECT TOP 1 fScanDate FROM tDataScanClean WHERE fActive > 0 ORDER BY fScanDate DESC)
	DELETE FROM @tTempTableFinancialStart WHERE fDate > @latestDateWithData
	
		--setup table to return
	DECLARE @tTempTableFinancial TABLE
		(
		 fID int IDENTITY(1,1) PRIMARY KEY, 
		 fDate nvarchar(10)
		,fYearWeek nvarchar(50)
		,fDataCount int
		)	
	-- get data
	INSERT INTO @tTempTableFinancial (fDate,fYearWeek)
	SELECT * from @tTempTableFinancialStart
	ORDER BY fDate DESC
	
	-- drop temp table
	DELETE FROM @tTempTableFinancialStart

	--get counts for data
	DECLARE @tTempData TABLE (fDataCount int, fDate date)
	INSERT INTO @tTempData
	SELECT count(fid), fscandate
	FROM tDataScanClean
	GROUP BY fscandate
				
	----setup variable for getting data counts for dates
	DECLARE @count int, @totalDateCount int, @dataCount int, @dateToCheckStart date, @dateToCheckEnd date
	SET @count = 1
	SET @totalDateCount = (SELECT TOP 1 fID from @tTempTableFinancial ORDER BY fID DESC)
	--get counts for dates
	While @count <= @totalDateCount
		BEGIN
			SET @dateToCheckStart = dateadd(dd,-1,(SELECT fDate FROM @tTempTableFinancial WHERE fID = @count))
			SET @dateToCheckEnd = dateadd(dd,6,@dateToCheckStart)
			SET @dataCount = (SELECT sum(fDataCount) FROM @tTempData WHERE fDate >= @dateToCheckStart AND fDate <= @dateToCheckEnd)

			UPDATE @tTempTableFinancial 
			SET  fDataCount = @dataCount
			WHERE fID = @count;

			SET @count = @count + 1
		END

	-- get data
	SELECT * from @tTempTableFinancial
	WHERE fDataCount > 0
	ORDER BY fDate DESC
	
	-- drop temp table
	DELETE FROM @tTempTableFinancial
	

END



GO
/****** Object:  StoredProcedure [dbo].[getFinancialYearWeek]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<http://www.sqlteam.com/>
-- Create date: <16/06/15>
-- Description:	<get the week number from the financial year.>
-- =============================================
CREATE PROCEDURE [dbo].[getFinancialYearWeek]
 @current_date smalldatetime

as 
begin 
	
	DECLARE @firstBegDate as smalldatetime
	DECLARE @wkNum as integer

	SET @firstBegDate = cast ('2013/07/01' as smalldatetime)
	SET @wkNum = (CAST(DATEDIFF(week,@firstBegDate,@current_date) as int) % 52 ) + 1
	
	SELECT @wkNum

END




GO
/****** Object:  StoredProcedure [dbo].[getListBrandsActive]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of brands from the brands table>
-- =============================================
CREATE PROCEDURE [dbo].[getListBrandsActive]

AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM tRefBrand
	WHERE NOT fActive = 0
	ORDER BY fBrandName
END




GO
/****** Object:  StoredProcedure [dbo].[getListBrandsActivebyWebsiteCountryIDs]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of travel countries, from the website selected>
-- =============================================
CREATE PROCEDURE [dbo].[getListBrandsActivebyWebsiteCountryIDs]
	 @websiteID int
	,@countryID int
AS
BEGIN
	
	SELECT tD.fScanBrandID as fID, tBrand.fBrandName as fBrandName from
		(SELECT distinct fScanBrandID
		FROM tDataScanClean 
		WHERE (fScanURL = @websiteID OR @websiteID = 0)
		AND	  fScanTravelCountryID = @countryID OR @countryID = 0) as tD
	INNER JOIN tRefBrand as tBrand on tBrand.fID = tD.fScanBrandID
	AND tBrand.fActive = 1
	ORDER BY fBrandName ASC

END




GO
/****** Object:  StoredProcedure [dbo].[getListBrandsInactive]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of inactive brands from the brands table>
-- =============================================
CREATE PROCEDURE [dbo].[getListBrandsInactive]

AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM tRefBrand
	WHERE  fActive = 0
	ORDER BY fBrandName
END



GO
/****** Object:  StoredProcedure [dbo].[getListChartDataVehiclePriceOverTimeLabels]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer >
-- Create date: <20/04/2015,>
-- Description:	<get Label list for price over time chart>
-- =============================================
CREATE PROCEDURE [dbo].[getListChartDataVehiclePriceOverTimeLabels]
  @DataSetDateStart nvarchar(MAX)

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @DataSetDateStartSDT smalldatetime

	SET @DataSetDateStartSDT = 
	CASE 
		WHEN  (@DataSetDateStart = 'NULL' OR @DataSetDateStart is Null)
			THEN CONVERT(SMALLDATETIME, '2000-01-01 00:00:01')
		ELSE
			CONVERT(SMALLDATETIME, @DataSetDateStart)
	END

	DECLARE @tDates TABLE (fScanPickupDate smalldatetime, fTravelDates nvarchar(max))
	
    -- Insert into temp table 
	INSERT INTO @tDates
	SELECT 	fScanPickupDate, (CONCAT( CONVERT(VARCHAR(11),fScanPickupDate,6) , ' - ' , CONVERT(VARCHAR(11),fScanReturnDate,6))) As fTravelDates	
	FROM (
		SELECT DISTINCT fScanPickupDate, fScanReturnDate
		FROM tDataScanClean
		WHERE (fScanDate >=  @DataSetDateStartSDT) and (fScanDate <=  dateadd(day, 7,@DataSetDateStartSDT) )	
	) as tMain
	ORDER BY fScanPickupDate ASC

	DECLARE @sum as int
	SET @sum = (select count (fTravelDates) from @tDates)

	DECLARE @counter as int
	SET @counter = 0

	DECLARE @string nvarchar(max)
	SET @string = ''

	WHILE @counter < @sum
		BEGIN
			SET @string = 
				CASE
					WHEN @string = ''
					THEN (SELECT TOP 1 fTravelDates from @tDates ORDER BY fScanPickupDate ASC)
					ELSE concat(@string,',',(SELECT TOP 1 fTravelDates from @tDates ORDER BY fScanPickupDate ASC))
				END
			DELETE from @tDates WHERE fTravelDates in (select top 1 fTravelDates from @tDates  ORDER BY fScanPickupDate ASC)

			SET @counter = @counter + 1
	END	

	SELECT @string

END



GO
/****** Object:  StoredProcedure [dbo].[getListCountries]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of countries from the countries table>
-- =============================================
CREATE PROCEDURE [dbo].[getListCountries]

AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT * FROM tRefCountry
	WHERE NOT fActive = 0
END




GO
/****** Object:  StoredProcedure [dbo].[getListCountriesbyWebsite]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of travel countries, from the website selected>
-- =============================================
CREATE PROCEDURE [dbo].[getListCountriesbyWebsite]
	@websiteID int
AS
BEGIN
	
	SELECT tD.fScanTravelCountryID as fID, tCountry.fCountryName as fCountryName from
		(SELECT distinct fScanTravelCountryID
		FROM tDataScanClean 
		WHERE (fScanURL = @websiteID OR @websiteID = 0)) as tD
	INNER JOIN tRefCountry as tCountry on tCountry.fID = tD.fScanTravelCountryID
	AND tCountry.fActive = 1
	ORDER BY fCountryName ASC


END




GO
/****** Object:  StoredProcedure [dbo].[getListCurrencies]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of currencies from the currencies table>
-- =============================================
CREATE PROCEDURE [dbo].[getListCurrencies]

AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT * FROM tRefCurrency
	WHERE NOT fActive = 0
	ORDER BY fCurrencyName
END




GO
/****** Object:  StoredProcedure [dbo].[getListDatesScanAndVehicleCombos]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <23/04/15>
-- Description:	<Get list of dates combined across all scans>
-- =============================================
CREATE PROCEDURE [dbo].[getListDatesScanAndVehicleCombos]

AS
BEGIN
	--declare variables to get list of dates (most relevant from each data set)
	DECLARE @DatesTable TABLE
			( fScanDate date, fPickupDate nvarchar (10))
	DECLARE @FinYearDatesTable TABLE
			(fDates nvarchar(10), fYear nvarchar(50))
			insert into @FinYearDatesTable
			exec getFinancialYearListWeeksAndDates
	DECLARE  @finWeeks int,
			 @countPickupDates int,
			 @countFinWeeks int,
			 @ThisScanDate date,
			 @DateToAdd date
		 
	--initialise variables to get list of dates (most relevant from each data set)
	SET @finWeeks = (SELECT count(fDates) from @FinYearDatesTable)
	SET @countFinWeeks = 0
	SET @ThisScanDate = (SELECT top 1 fDates from @FinYearDatesTable order by fDates desc)

	--fill temp table with list of dates (most relevant from each data set)
	WHILE @countFinWeeks < @finWeeks
		BEGIN			
			SET @countPickupDates = 
				CASE
					WHEN @countFinWeeks > 4
					THEN 1
					ELSE 10
				END	
			WHILE @countPickupDates > 0
				BEGIN
					SET @DateToAdd = 
						CASE
							WHEN @countFinWeeks > 4
							THEN Dateadd(day,14, @ThisScanDate)
							ELSE Dateadd(week,(@countPickupDates * 4) - 2,@ThisScanDate)
						END	

					INSERT INTO @DatesTable
					VALUES (@ThisScanDate, @DateToAdd)

					SET @countPickupDates = @countPickupDates - 1
				END
			SET @ThisScanDate = dateadd(day,(-7), @ThisScanDate) 
			SET @countFinWeeks = 
				CASE 
					WHEN @ThisScanDate <= dateadd(day,1,cast ('2015-03-23' as date))
					THEN @finWeeks + 1
					ELSE @countFinWeeks + 1
				END		
		END

	SELECT max(fScanDate) as fScanDate, fPickupDate from @DatesTable GROUP BY fPickupDate ORDER BY fScanDate DESC, fPickupDate DESC


END



GO
/****** Object:  StoredProcedure [dbo].[getListExceptions]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<Get list of the counts of exceptions, where data fields do not match any entries in the common lookup tables>
-- =============================================
CREATE PROCEDURE [dbo].[getListExceptions]

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @lastCheckedDate date, @countExVehicles int, @countExBrands int,  @countExDates int, @countExCountries int, @countExLocations int, @countExWebsites int, @countExCurrencies int, @dateChecked date, @firstDate date, @lastDate date
	SET @lastCheckedDate = (SELECT TOP 1 fDateChecked from tRefExceptionCheck WHERE fNumberExceptions = 0 AND fActive > 0 ORDER BY fDateChecked DESC)
	SET @dateChecked =	   (SELECT TOP 1 fDateChecked FROM tRefExceptionCheck WHERE fNumberExceptions = 0 AND fActive > 0 ORDER BY fDateChecked DESC)
	SET @firstDate = (SELECT TOP 1 CONVERT(VARCHAR(11),fScanDate,106) FROM tDataScan WHERE fScanDate > @dateChecked ORDER BY fScanDate ASC )
	SET @lastDate =  (SELECT TOP 1 CONVERT(VARCHAR(11),fScanDate,106) FROM tDataScan WHERE fScanDate > @dateChecked ORDER BY fScanDate DESC )

	--setup tables to use for get vehicle exceptions
	DECLARE @tTempTableBrandVehicle TABLE( fID nvarchar(200), fScanURL nvarchar(200), fBrandID int, fBrandName nvarchar(200), fVehicleName nvarchar(200))
	--get vehicle exceptions
	insert into @tTempTableBrandVehicle
    exec('getListExceptionsVehicles');
	--count vehicle exceptions
	SET @countExVehicles = (Select Count(fID) From @tTempTableBrandVehicle)
	-- drop old table	
	DELETE FROM @tTempTableBrandVehicle
	
	--setup tables to use for get  exceptions
	DECLARE @tTempTableBrand TABLE( fID nvarchar(200), fBrandName nvarchar(200))
	--get  exceptions
	insert into @tTempTableBrand
    exec('getListExceptionsBrands');
	--count  exceptions
	SET @countExBrands = (Select Count(fID) From @tTempTableBrand)
	-- drop old table	
	DELETE FROM @tTempTableBrand

	--setup tables to use for get vehicle exceptions
	DECLARE @tTempDateExceptions TABLE( fCount int, [fScanURL] nvarchar(200), [fScanPickupDate] nvarchar(200), [fScanReturnDate] nvarchar(200), fReason nvarchar(max))
	--get vehicle exceptions
	insert into @tTempDateExceptions
    exec('getListExceptionsDates');
	--count vehicle exceptions
	SET @countExDates = (Select Count(fCount) From @tTempDateExceptions)
	-- drop old table	
	DELETE FROM @tTempDateExceptions

	--get countries
	DECLARE @tTempTableCountries TABLE (fCountryID int, fCountryName nvarchar(200), fType nvarchar(1))
	-- insert in brand and vehicle name combos
	INSERT INTO @tTempTableCountries
    exec('getListExceptionsCountries');
	--count vehicle exceptions
	SET @countExCountries = (Select Count(fCountryID) From @tTempTableCountries)
	-- drop old table	
	DELETE FROM @tTempTableCountries
	
	--get locations
	DECLARE @tTempTableLocations TABLE (fLocationID int, fLocationName nvarchar(200), fType nvarchar(1))
	-- insert in brand and vehicle name combos
	INSERT INTO @tTempTableLocations
    exec('getListExceptionsLocations');
	--count vehicle exceptions
	SET @countExLocations = (Select Count(fLocationID) From @tTempTableLocations)
	-- drop old table	
	DELETE FROM @tTempTableLocations
	
	--get websites
	DECLARE @tTempTableWebsites TABLE (fWebsiteID int, fWebsiteDomain nvarchar(200))
	-- insert in brand and vehicle name combos
	INSERT INTO @tTempTableWebsites
    exec('getListExceptionsWebsites');
	--count vehicle exceptions
	SET @countExWebsites = (Select Count(fWebsiteID) From @tTempTableWebsites)
	-- drop old table	
	DELETE FROM @tTempTableWebsites
	
	--get currencies
	DECLARE @tTempTableCurrencies TABLE (fCurrencyID int, fCurrencyCode nvarchar(200))
	-- insert in brand and vehicle name combos
	INSERT INTO @tTempTableCurrencies
    exec('getListExceptionsCurrencies');
	--count vehicle exceptions
	SET @countExCurrencies = (Select Count(fCurrencyID) From @tTempTableCurrencies)
	-- drop old table	
	DELETE FROM @tTempTableCurrencies

	--select all exceptions as one table
	SELECT 
	   (CONCAT(	@firstDate, ' - ', @lastDate) ) as fDateRange
	  ,@countExDates as fDate 
	  ,(select COUNT(fID) from (SELECT min(fID) as fID FROM tDataScan WHERE fScanDate > @lastCheckedDate AND fActive > 0 AND NOT fID in (Select fScanID from tDataScanClean) GROUP BY  [fScanDate] ,[fScanURL] ,[fScanTravelCountry] ,[fScanPickupLocation] ,[fScanReturnLocation] ,[fScanPickupDate] ,[fScanReturnDate] ,[fScanLicenceCountry] ,[fScanBrandName] ,[fScanVehicleName] ,[fScanTotalPrice] ,[fScanCurrency] ,[fScanSourceURL]) as tD) as  fDataCount	   
	  ,@countExWebsites as fWebsite
	  ,@countExCountries as fCountry
	  ,@countExBrands as fBrand
	  ,@countExLocations as fLocation
	  ,@countExVehicles as fVehicle 
	  ,@countExCurrencies  as fCurrency
	  
	  

END





GO
/****** Object:  StoredProcedure [dbo].[getListExceptionsBrands]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <12/03/15>
-- Description:	<Get a list of the brand exceptions (brand in scan data that aren't in our current list of brands)>
-- =============================================

CREATE PROCEDURE [dbo].[getListExceptionsBrands]
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @lastCheckedDate date
	SET @lastCheckedDate = (SELECT TOP 1 fDateChecked from tRefExceptionCheck WHERE fNumberExceptions = 0 ORDER BY fDateChecked DESC)
	
	DECLARE @tableData TABLE (fID int, fScanBrandName nvarchar(200), factive int)
	INSERT INTO @tableData (fID, fscanBrandName, factive)
	SELECT min(fID), fScanBrandName, 1 from tDataScan
	WHERE (not factive  = 0)
	AND fScanDate > @lastCheckedDate
	GROUP BY fscanBrandName, factive
	UPDATE @tableData
	SET fScanBrandName = [dbo].[replaceIllegalChar](fScanBrandName)

	--get brand and vehicle name combos
	DECLARE @tTempTableBrand TABLE (fBrandID int, fBrandName nvarchar(200))
	-- insert in brand and vehicle name combos
	INSERT INTO @tTempTableBrand
	SELECT fID, fBrandName  from tRefBrand 
		UNION ALL 
	SELECT fID, Split.a.value('.', 'VARCHAR(100)') AS String  from (SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](fBrandAlias), ';', '</M><M>') + '</M>' AS XML) AS String, fID  FROM  tRefBrand ) AS a CROSS APPLY String.nodes ('/M') AS Split(a)	
	UPDATE @tTempTableBrand
	SET fBrandName = [dbo].[replaceIllegalChar](fBrandName)
	
	--get brand name exceptions
	SELECT fID, fScanBrandName from @tableData
	WHERE fScanBrandName not in (SELECT fBrandName FROM  @tTempTableBrand)
	order by fScanBrandName
END






GO
/****** Object:  StoredProcedure [dbo].[getListExceptionsCountries]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<Get list of the counts of exceptions, where countries in data scan do not match up with countries in our country list>
-- =============================================
CREATE PROCEDURE [dbo].[getListExceptionsCountries]

AS
BEGIN
	SET NOCOUNT ON;
	
	--get date last checked for exceptions
	DECLARE @lastCheckedDate date
	SET @lastCheckedDate = (SELECT TOP 1 fDateChecked from tRefExceptionCheck WHERE fNumberExceptions = 0 ORDER BY fDateChecked DESC)

	--get data to check
	DECLARE @tData TABLE (fID int, fScanCountry nvarchar(200), fType nvarchar(1))
	--get travel country list
	INSERT INTO @tData (fID, fScanCountry, fType)
	SELECT min(fID), fScanTravelCountry, '1' FROM tDataScan
	WHERE NOT fActive = 0
		AND fScanDate > @lastCheckedDate
	GROUP BY fScanTravelCountry
	--get licence country list
	INSERT INTO @tData (fID, fScanCountry, fType)
	SELECT min(fID), fScanLicenceCountry, '2' FROM tDataScan
	WHERE NOT fActive = 0
		AND fScanDate > @lastCheckedDate
	GROUP BY fScanLicenceCountry

	--get countries
	DECLARE @tTempTableCountries TABLE (fCountryID int, fCountryName nvarchar(200))
	-- insert in brand and vehicle name combos
	INSERT INTO @tTempTableCountries
	SELECT fID, fCountryName from tRefCountry 
	WHERE NOT fActive = 0																				
		UNION ALL 																		
	SELECT fID as fCountryID, fCountryCode as fCountryName from tRefCountry 
	WHERE NOT fActive = 0   																		
		UNION ALL 																		
	SELECT fCountryID, Split.a.value('.', 'VARCHAR(100)') AS String  
	from (SELECT fID as fCountryID, CAST ('<M>' + REPLACE(fCountryAlias, ';', '</M><M>') + '</M>' AS XML) AS String FROM  tRefCountry WHERE NOT fActive = 0) 
	AS a CROSS APPLY String.nodes ('/M') AS Split(a)
	  
	--get list of exceptions
	SELECT fID, fScanCountry, fType FROM @tData
	WHERE fScanCountry not in (SELECT fCountryName FROM @tTempTableCountries)
	order by fScanCountry

END





GO
/****** Object:  StoredProcedure [dbo].[getListExceptionsCurrencies]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <12/03/15>
-- Description:	<Get a list of the currency exceptions (currency in scan data that aren't in our current list of currencies)>
-- =============================================
CREATE PROCEDURE [dbo].[getListExceptionsCurrencies]
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @lastCheckedDate date
	SET @lastCheckedDate = (SELECT TOP 1 fDateChecked from tRefExceptionCheck WHERE fNumberExceptions = 0 ORDER BY fDateChecked DESC)
	
	--get data to check
	DECLARE @tData TABLE (fID int, fScanCurrency nvarchar(200))
	--get currency list
	INSERT INTO @tData (fID, fScanCurrency)
	SELECT min(fID), fScanCurrency FROM tDataScan
	WHERE NOT fActive = 0
		AND fScanDate > @lastCheckedDate
	GROUP BY fScanCurrency
	
	--get countries
	DECLARE @tTempTableCurrencies TABLE (fCurrencyName nvarchar(200))
	-- insert in brand and vehicle name combos
	INSERT INTO @tTempTableCurrencies
	SELECT fCurrencyCode 
	from tRefCurrency 
	WHERE NOT fActive = 0																		
		UNION ALL 									
	SELECT Split.a.value('.', 'VARCHAR(100)') AS String  
	from ( SELECT CAST ('<M>' + REPLACE( CAST(fCurrencyAlias As nvarchar(100)), ';', '</M><M>') + '</M>' AS XML) AS String   FROM  tRefCurrency ) 
	AS a CROSS APPLY String.nodes ('/M') AS Split(a)
	
    SELECT fID, fScanCurrency
	from @tData
	WHERE fScanCurrency not in ( SELECT fCurrencyName from @tTempTableCurrencies)

END




GO
/****** Object:  StoredProcedure [dbo].[getListExceptionsDates]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sally Gamer
-- Create date: 06/02/2015
-- Description:	Check to see if there are any dates in the latest data, that shouldn't be there
-- =============================================
CREATE PROCEDURE [dbo].[getListExceptionsDates]
AS
BEGIN
  
	--get date last checked for exceptions
	DECLARE @lastCheckedDate date
	SET @lastCheckedDate = (SELECT TOP 1 fDateChecked from tRefExceptionCheck WHERE fNumberExceptions = 0 ORDER BY fDateChecked DESC)
	dECLARE @counter int, @firstDate date, @currentDate date
	SET @counter = 0
	SET @currentDate = '2015-01-08'
	SET @currentDate = DATEADD(yyyy, DATEDIFF(yyyy, dateadd(mm,-1,@currentDate), @lastCheckedDate), @currentDate)
	SET @currentDate = DATEADD(mm, DATEDIFF(mm, dateadd(mm,-1,@currentDate), @lastCheckedDate), @currentDate)
	SET @firstDate = @currentDate


	-- get data to check
	DECLARE @tData TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fScanURL nvarchar(max), fScanPickupDate date, fScanReturnDate date, dateDifference int)
	INSERT INTO @tData (fScanURL, fScanPickupDate, fScanReturnDate)
	SELECT distinct fScanURL, fScanPickupDate, fScanReturnDate from tDataScan
	WHERE   factive > 0
		AND fScanDate > @lastCheckedDate
	--calculate date difference
	UPDATE @tData
	SET dateDifference = DATEDIFF(d, fScanPickupDate, fScanReturnDate)

	-- get list of dates
	DECLARE @datesTable AS TABLE ( fID int, thisDate date)
	-- fill dates table
	WHILE @counter < 15
		BEGIN
			--go to next month
			SET @currentDate = dateadd(mm,@counter,@firstDate)
			-- get correct monday
			SET @currentDate = dateadd(dd,6,@currentDate)
			SET @currentDate = [dbo].[getFirstDayOfWeek](@currentDate)			
			-- add those dates into the table
			INSERT INTO @datesTable 
			VALUES (@counter+1, @currentDate)
			--increase counter
			SET @counter = @counter + 1
		END

	--remove good data
	DELETE FROM @tData	
	WHERE (dateDifference = 10) AND (NOT fScanPickupDate in (SELECT thisDate from @datesTable))

	
SELECT * FROM(	SELECT  '' as fCount
      ,fScanURL
      ,fScanPickupDate as fScanPickupDate
      ,fScanReturnDate as fScanReturnDate
	  ,concat('Pickup/Dropoff Dates out by ',DATEDIFF(d, fScanPickupDate, tD.thisDate), ' days. Pickup should be ', tD.thisDate,'. Dropoff should be ',CONVERT(VARCHAR(10),(dateadd(d,DATEDIFF(d, fScanPickupDate, tD.thisDate),fScanReturnDate)),126)  ,'.') as fReason
  FROM @tData as t
  INNER JOIN @datesTable as tD on datepart(mm,tD.thisDate) = datepart(mm,t.fScanPickupDate) aNd datepart(yyyy,tD.thisDate) = datepart(yyyy,t.fScanPickupDate) 
  WHERE fScanPickupDate not in (SELECT thisDate from @datesTable)
  ) as t1

  UNION ALL

SELECT * FROM(  SELECT  '' as fCount
      ,fScanURL
      ,fScanPickupDate as fScanPickupDate
      ,fScanReturnDate as fScanReturnDate
	  ,concat('Incorrect travel length: ',dateDifference,' days.') as fReason
  FROM @tData as t
  WHERE NOT dateDifference = 10
  ) as t2

  ORDER BY fScanURL ASC, fScanPickupDate ASC, fScanReturnDate ASC

END



GO
/****** Object:  StoredProcedure [dbo].[getListExceptionsDuplicates]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <09/04/2015>
-- Description:	<get any duplicates from data>
-- =============================================
CREATE PROCEDURE [dbo].[getListExceptionsDuplicates]

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @lastCheckedDate date, @dateChecked date, @firstDate date, @lastDate date
	SET @lastCheckedDate =  (SELECT TOP 1 fDateChecked from tRefExceptionCheck WHERE fNumberExceptions = 0 AND fActive > 0 ORDER BY fDateChecked DESC)
	SET @dateChecked =		(SELECT TOP 1 fDateChecked FROM tRefExceptionCheck WHERE fNumberExceptions = 0 AND fActive > 0 ORDER BY fDateChecked DESC)
	SET @firstDate = (SELECT TOP 1 CONVERT(VARCHAR(11),fScanDate,106) FROM tDataScan WHERE fScanDate > @dateChecked ORDER BY fScanDate ASC )
	SET @lastDate =  (SELECT TOP 1 CONVERT(VARCHAR(11),fScanDate,106) FROM tDataScan WHERE fScanDate > @dateChecked ORDER BY fScanDate DESC )

	
	--get required data set into temp table
	IF OBJECT_ID('tempdb..#tData') IS NOT NULL
	/*Then it exists*/
	DROP TABLE #tData
	/* recreate table */
	CREATE TABLE #tData (fID int
						,fScanDate date
						,[fScanURL]  nvarchar(50)
						,[fScanPickupLocation]  nvarchar(50)
						,[fScanReturnLocation]  nvarchar(50)
						,[fScanPickupDate] date
						,[fScanReturnDate] date
						,[fScanLicenceCountry]  nvarchar(50)
						,[fScanVehicleName]  nvarchar(200)
						,[fScanCurrency] nvarchar(3))
	INSERT INTO #tData ( fID
						,[fScanDate]
						,[fScanURL]
						,[fScanPickupLocation]
						,[fScanReturnLocation]
						,[fScanPickupDate]
						,[fScanReturnDate]
						,[fScanLicenceCountry]
						,[fScanVehicleName]
						,[fScanCurrency])
	SELECT   min(fID)
			,[fScanDate]
			,[fScanURL]
			,[fScanPickupLocation]
			,[fScanReturnLocation]
			,[fScanPickupDate]
			,[fScanReturnDate]
			,[fScanLicenceCountry]
			,[fScanVehicleName]
			,[fScanCurrency] 
	from tDataScan 
	WHERE fScanDate > @lastCheckedDate 
	AND fActive > 0
	group by [fScanDate]
			,[fScanURL]
			,[fScanPickupLocation]
			,[fScanReturnLocation]
			,[fScanPickupDate]
			,[fScanReturnDate]
			,[fScanLicenceCountry]
			,[fScanVehicleName]
			,[fScanCurrency]

    SELECT 
	    (CONCAT(@firstDate, ' - ', @lastDate) ) as fDateRange
	   ,(select COUNT(fID) from #tData) as  fDataCount
	   ,(select count (fID) from tDataScan WHERE NOT fID in (
			SELECT fID from #tData
	   ) AND fScanDate > @lastCheckedDate and not fActive = 0) as fDuplicates
	   
END




GO
/****** Object:  StoredProcedure [dbo].[getListExceptionsLocations]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<Get list of the counts of exceptions, where countries in data scan do not match up with countries in our country list>
-- =============================================
CREATE PROCEDURE [dbo].[getListExceptionsLocations]

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @lastCheckedDate date
	SET @lastCheckedDate = (SELECT TOP 1 fDateChecked from tRefExceptionCheck WHERE fNumberExceptions = 0 ORDER BY fDateChecked DESC)
			
	--get data to check
	DECLARE @tData TABLE (fID int, fScanLocation nvarchar(200), fType nvarchar(1))
	--get pickup list
	INSERT INTO @tData (fID, fScanLocation, fType)
	SELECT min(fID), fScanPickupLocation, '1' FROM tDataScan
	WHERE NOT fActive = 0
		AND fScanDate > @lastCheckedDate
	GROUP BY fScanPickupLocation
	--get return list
	INSERT INTO @tData (fID, fScanLocation, fType)
	SELECT min(fID), fScanReturnLocation, '2' FROM tDataScan
	WHERE NOT fActive = 0
		AND fScanDate > @lastCheckedDate
	GROUP BY fScanReturnLocation

	--get locations
	DECLARE @tTempTableLocations TABLE (fLocationID int, fLocationName nvarchar(200))
	-- insert in brand and vehicle name combos
	INSERT INTO @tTempTableLocations
	SELECT fID, fLocationName from tRefLocation
	WHERE NOT fActive = 0																				
		UNION ALL 																		
	SELECT fID as fLocationID, fLocationCode as fLocationName from tRefLocation 
	WHERE NOT fActive = 0   																		
		UNION ALL 																		
	SELECT fLocationID, Split.a.value('.', 'VARCHAR(100)') AS String  
	from (SELECT fID as fLocationID, CAST ('<M>' + REPLACE(fLocationAlias, ';', '</M><M>') + '</M>' AS XML) AS String FROM  tRefLocation WHERE NOT fActive = 0) 
	AS a CROSS APPLY String.nodes ('/M') AS Split(a)
	

    SELECT fID, fScanLocation, fType from @tData WHERE fScanLocation not in ( SELECT fLocationName from @tTempTableLocations)

END





GO
/****** Object:  StoredProcedure [dbo].[getListExceptionsPrices]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <30/03/15>
-- Description:	<Get list of price exceptions from the price exceptions table>
-- =============================================
CREATE PROCEDURE [dbo].[getListExceptionsPrices]

AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @tempExceptionList TABLE (
		fID int IDENTITY(1,1) PRIMARY KEY,
		fExceptionID int
	)

	INSERT INTO @tempExceptionList (fExceptionID)
	SELECT distinct fExceptionID FROM tRefPriceExceptionLocations

	DECLARE @temp TABLE (
		fExceptionID int, 
		fLocationList nvarchar(max), 
		fPickupOrDropoff nvarchar(max)
	)
	
	DECLARE @exceptionLocCount int, @exceptionTotalCount int, @count int, @countTotal int, @PickupList varchar(MAX), @ReturnList varchar(MAX), @addLocation nvarchar(100), @thisException int
	SET @exceptionLocCount = (SELECT count(fExceptionID) FROM @tempExceptionList)
	SET @count = 1
	SET @PickupList = ''
	SET @ReturnList = ''
	SET @exceptionTotalCount = (SELECT top 1 fID FROM tRefPriceExceptionLocations order by fID DESC)
	SET @addLocation = ''
	
	WHILE @count <= @exceptionLocCount
		BEGIN

			SET @thisException = (SELECT fExceptionID FROM @tempExceptionList WHERE fID = @count)
			SET @countTotal = 1
			SET @addLocation = ''
			SET @PickupList = ''
			SET @ReturnList = ''

			-- get pickup/return lists for this exception record
			WHILE @countTotal <= @exceptionTotalCount 
				BEGIN
					-- get pickup locations
					SET @addLocation = ''
					SET @addLocation = (	SELECT tL.fLocationName											
											from tRefPriceExceptionLocations tPE
											INNER JOIN tRefLocation as tL on tL.fID = tPE.fLocationID
											where tPE.fID = @countTotal
											AND tPE.fExceptionID = @thisException
											AND fPickupOrDropoff = 1
											AND tPE.fActive = 1
											)
					SET @PickupList = 
						CASE
							WHEN NOT @addLocation = ''
								THEN CASE
									WHEN @PickupList = ''
										THEN @addLocation
									ELSE concat (@PickupList,', ',@addLocation)
								END
							ELSE @PickupList
						END

					-- get return locations
					SET @addLocation = ''
					SET @addLocation = (	SELECT tL.fLocationName											
											from tRefPriceExceptionLocations tPE
											INNER JOIN tRefLocation as tL on tL.fID = tPE.fLocationID
											where tPE.fID = @countTotal
											AND tPE.fExceptionID = @thisException
											AND fPickupOrDropoff = 2
											AND tPE.fActive = 1)
					SET @ReturnList = 
						CASE
							WHEN NOT @addLocation = ''
								THEN CASE
									WHEN @ReturnList = ''
										THEN @addLocation
									ELSE concat (@ReturnList,', ',@addLocation)
								END
							ELSE @ReturnList
						END	

					SET @countTotal = @countTotal + 1
				END

			-- add pickup values for this exception record
			INSERT into @temp
			VALUES (@thisException, @PickupList, 1)
			-- add return values for this exception record	
			INSERT into @temp
			VALUES (@thisException, @ReturnList, 2)

			SET @count = @count  + 1

		END	

		
	DECLARE @tempBrands TABLE (
		fExceptionID int, 
		fBrandList nvarchar(max)
	)
	
	DECLARE @countEx int, @exceptionBrandCount int, @brandList nvarchar(max), @addBrand nvarchar(max)
	SET @count = 1
	SET @countEx = 1
	SET @brandList = ''
	SET @exceptionBrandCount = (SELECT top 1 fID FROM tRefPriceExceptionBrands order by fID DESC)
	SET @addBrand = ''
	
	WHILE @count <= @exceptionTotalCount
		BEGIN

			SET @thisException = (SELECT fExceptionID FROM @tempExceptionList WHERE fID = @count)
			SET @countEx = 1
			SET @addBrand = ''
			SET @brandList = ''

			-- get pickup/return lists for this exception record
			WHILE @countEx <= @exceptionBrandCount 
				BEGIN
					-- get pickup locations
					SET @addBrand = ''
					SET @addBrand = (	SELECT tB.fBrandName											
											from tRefPriceExceptionBrands tPE
											INNER JOIN tRefBrand as tB on tB.fID = tPE.fBrandID
											where tPE.fID = @countEx
											AND tPE.fExceptionID = @thisException
											AND tPE.fActive = 1
											)
					SET @brandList = 
						CASE
							WHEN NOT @addBrand = ''
								THEN CASE
									WHEN @brandList = ''
										THEN @addBrand
									ELSE concat (@brandList,', ',@addBrand)
								END
							ELSE @brandList
						END

					SET @countEx = @countEx + 1
				END

			-- add pickup values for this exception record
			INSERT into @tempBrands
			VALUES (@thisException, @brandList)

			SET @count = @count  + 1

		END	
		
	SELECT tP.[fID]
		  ,tCo.fCountryName
		  ,isNull(tB.fBrandList,'N/A') as fBrandList
		  ,tPEPickup.fLocationList as fPickupLocationName
		  ,tPEReturn.fLocationList as fReturnLocationName
		  ,tOW.fOneWay
		  ,CONVERT(VARCHAR(11),fPriceExceptionDateStart,6) as fPriceExceptionDateStart
		  ,CONVERT(VARCHAR(11),fPriceExceptionDateEnd,6) as fPriceExceptionDateEnd
		  ,[fPriceExceptionPriceChange]
		  ,[fPriceExceptionPercentage]
		  ,tCu.fCurrencyCode
		  ,[fPriceExceptionNote]
	FROM [comparison].[dbo].[tRefPriceException] as tP
	LEFT JOIN [comparison].[dbo].[tRefCurrency] as tCu on tCu.fID = tP.fPriceExceptionCurrencyID
	LEFT JOIN [comparison].[dbo].[tRefCountry] as tCo on tCo.fID = tP.[fPriceExceptionCountryID]
	--LEFT JOIN [comparison].[dbo].[tRefBrand] as tB on tB.fID = tP.[fPriceExceptionBrandID]
	LEFT JOIN (SELECT 1 as fID, 'Yes' as fOneWay UNION ALL SELECT 0  as fID, 'No' as fOneWay) as tOW on tOW.fID = tP.[fPriceExceptionOneWay]
	LEFT JOIN @temp as tPEPickup on tPEPickup.fExceptionID = tP.fID AND tPEPickup.fPickupOrDropoff = 1
	LEFT JOIN @temp as tPEReturn on tPEReturn.fExceptionID = tP.fID AND tPEReturn.fPickupOrDropoff = 2
	LEFT JOIN @tempBrands as tB on tB.fExceptionID = tP.fID

	WHERE tP.[fActive] = 1


END




GO
/****** Object:  StoredProcedure [dbo].[getListExceptionsVehicles]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <12/03/15>
-- Description:	<Get a list of the vehicle exceptions (vehicles in scan data that aren't in our current list of vehicles)>
-- =============================================
CREATE PROCEDURE [dbo].[getListExceptionsVehicles]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @lastCheckedDate date
	SET @lastCheckedDate = (SELECT TOP 1 fDateChecked from tRefExceptionCheck WHERE fNumberExceptions = 0 ORDER BY fDateChecked DESC)

	--get required data set into temp table
	DECLARE  @tTempTableData TABLE (fID int, fScanURL nvarchar(200), fScanBrandName nvarchar(MAX), fScanVehicleName nvarchar(MAX))
	INSERT INTO @tTempTableData  (fID, fScanURL, fScanBrandName, fScanVehicleName)
	SELECT  min(fID), fScanURL, [dbo].[replaceIllegalChar](fScanBrandName), [dbo].[replaceIllegalChar](fScanVehicleName) FROM tDataScan
	WHERE fScanDate > @lastCheckedDate AND factive > 0 
	AND NOT fid in (select fscanid from tDataScanClean)
	GROUP BY fScanURL, fScanBrandName, fScanVehicleName 

	--SELECT * from @tTempTableData
	
	--get required data set into temp table
	DECLARE  @tTempTableBrandVehicle TABLE (fBrandID int, fBrandName nvarchar(MAX), fVehicleName nvarchar(MAX))
	-- add in vahielce brand combos
	INSERT INTO @tTempTableBrandVehicle
	SELECT tB.fID, tB.fBrandName, tV.fVehicleName FROM 	
	(
		SELECT [dbo].[replaceIllegalChar](fVehicleName) as fVehicleName, fVehicleBrandID from tRefVehicle
		UNION ALL 
		SELECT Split.a.value('.', 'VARCHAR(100)') AS String, fVehicleBrandID  from ( SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](fVehicleAlias), ';', '</M><M>') + '</M>' AS XML) AS String, fVehicleBrandID   FROM  tRefVehicle) AS a CROSS APPLY String.nodes ('/M') AS Split(a)
	) as tV
	INNER JOIN (
		SELECT [dbo].[replaceIllegalChar](fBrandName) as fBrandName, fID from tRefBrand 
		UNION ALL 
		SELECT Split.a.value('.', 'VARCHAR(100)') AS String, fID  from (SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](fBrandAlias), ';', '</M><M>') + '</M>' AS XML) AS String, fID  FROM  tRefBrand ) AS a CROSS APPLY String.nodes ('/M') AS Split(a)
	) as tB on tB.fID = tV.fVehicleBrandID
	WHERE NOT tV.fVehicleName = ''
	AND NOT tB.fBrandName = ''

	--SELECT * FROM @tTempTableBrandVehicle

	DELETE FROM @tTempTableBrandVehicle
	WHERE fBrandName not in (SELECT fScanBrandName FROM @tTempTableData)
			
	--SELECT * from @tTempTableBrandVehicle

	--get list of vehicles that don't match the current combos
	SELECT fID, tD.fScanURL, tD.fBrandID, tD.fScanBrandName, tD.fScanVehicleName  From 
	(
		Select min(fID) as fID, tD.fScanURL, tB.fBrandID, tD.fScanBrandName, tD.fScanVehicleName  From @tTempTableData as tD
		INNER JOIN (SELECT fBrandID, fBrandName FROM @tTempTableBrandVehicle group by fBrandID, fBrandName ) AS tB ON tB.fBrandName = tD.fScanBrandName
		GROUP BY tD.fScanURL, tB.fBrandID, tD.fScanBrandName, tD.fScanVehicleName
	) as tD
	LEFT OUTER JOIN @tTempTableBrandVehicle AS tT ON tT.fBrandID = tD.fBrandID AND tT.fVehicleName = tD.fScanVehicleName 
	WHERE tT.fBrandName IS NULL AND tT.fVehicleName IS NULL
		order by fScanBrandName, fScanVehicleName

END






GO
/****** Object:  StoredProcedure [dbo].[getListExceptionsWebsites]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <12/03/15>
-- Description:	<Get a list of the website exceptions (websites in scan data that aren't in our current list of websites)>
-- =============================================
CREATE PROCEDURE [dbo].[getListExceptionsWebsites] 

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @lastCheckedDate date
	SET @lastCheckedDate = (SELECT TOP 1 fDateChecked from tRefExceptionCheck WHERE fNumberExceptions = 0 ORDER BY fDateChecked DESC)
	
	--get data to be checked (data since last check)
	DECLARE @tableData TABLE (fID int, fScanURL nvarchar(200))
	INSERT INTO @tableData (fID, fScanURL)
	SELECT min(fID), fScanURL from tDataScan
	WHERE (not factive  = 0)
	AND fScanDate > @lastCheckedDate
	GROUP BY fScanURL


	--get websites
	DECLARE @tTempTableWebsites TABLE (fWebsiteName nvarchar(200))
	-- insert in brand and vehicle name combos
	INSERT INTO @tTempTableWebsites
	SELECT fWebsiteName from tRefWebsite
	WHERE NOT fActive = 0																																					
		UNION ALL 		
	SELECT fWebsiteDomain from tRefWebsite
	WHERE NOT fActive = 0																																					
		UNION ALL 																	
	SELECT Split.a.value('.', 'VARCHAR(100)') AS String  
	from (SELECT CAST ('<M>' + REPLACE(fWebsiteAlias, ';', '</M><M>') + '</M>' AS XML) AS String FROM  tRefWebsite WHERE NOT fActive = 0) 
	AS a CROSS APPLY String.nodes ('/M') AS Split(a)


	Select fID , fScanURL 
    from @tableData 
    WHERE fScanURL not in	( SELECT fWebsiteName from @tTempTableWebsites)
	order by fScanURL

END





GO
/****** Object:  StoredProcedure [dbo].[getListLocations]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <13/03/2015>
-- Description:	<get list of approved locations>
-- =============================================
CREATE PROCEDURE [dbo].[getListLocations]
	@countySelect int
AS
BEGIN

	SET NOCOUNT ON;

    SELECT * from tRefLocation
	WHERE NOT fActive = 0
	AND (@countySelect = 0 OR fCountryID = @countySelect)
END




GO
/****** Object:  StoredProcedure [dbo].[getListLocationsPickupByWebsiteCountryBrand]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of travel countries, from the website selected>
-- =============================================
CREATE PROCEDURE [dbo].[getListLocationsPickupByWebsiteCountryBrand]
	 @websiteID int
	,@countryID int
	,@brandID int
AS
BEGIN
	
	SELECT tD.fScanPickupLocationID as fID, tLocation.fLocationName as fLocationName from
		(SELECT distinct fScanPickupLocationID
		FROM tDataScanClean 
		WHERE (fScanURL = @websiteID OR @websiteID = 0)
		AND	  (fScanTravelCountryID = @countryID OR @countryID = 0)
		AND	  (fScanBrandID = @brandID OR @brandID = 0)
		) as tD
	INNER JOIN tRefLocation as tLocation on tLocation.fID = tD.fScanPickupLocationID
	AND tLocation.fActive = 1
	ORDER BY fLocationName ASC

END




GO
/****** Object:  StoredProcedure [dbo].[getListLocationsReturnByWebsiteCountryBrand]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of travel countries, from the website selected>
-- =============================================
CREATE PROCEDURE [dbo].[getListLocationsReturnByWebsiteCountryBrand]
	 @websiteID int
	,@countryID int
	,@brandID int
AS
BEGIN
	
	SELECT tD.fScanReturnLocationID as fID, tLocation.fLocationName as fLocationName from
		(SELECT distinct fScanReturnLocationID
		FROM tDataScanClean 
		WHERE (fScanURL = @websiteID OR @websiteID = 0)
		AND	  (fScanTravelCountryID = @countryID OR @countryID = 0)
		AND	  (fScanBrandID = @brandID OR @brandID = 0)
		) as tD
	INNER JOIN tRefLocation as tLocation on tLocation.fID = tD.fScanReturnLocationID
	AND tLocation.fActive = 1
	ORDER BY fLocationName ASC

END




GO
/****** Object:  StoredProcedure [dbo].[getListLocationsReturnByWebsiteCountryVehicle]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of locations for the brand of that vehicle>
-- =============================================
CREATE PROCEDURE [dbo].[getListLocationsReturnByWebsiteCountryVehicle]
	 @websiteID int
	,@countryID int
	,@vehicleID int
AS
BEGIN	

	SELECT tD.fID, tLocation.fLocationName as fLocationName from
			(   SELECT distinct fScanReturnLocationID as fID
				FROM tDataScanClean 
				WHERE (fScanURL = @websiteID OR @websiteID = 0)
				AND	  (fScanTravelCountryID = @countryID OR @countryID = 0)
				AND	  (fScanVehicleID = @vehicleID OR @vehicleID = 0)
				AND (@vehicleID = 0 OR (fScanReturnLocationID IN (SELECT fBranchLocationID from tRefBranch WHERE fBranchBrandID = (SELECT fVehicleBrandID FROM tRefVehicle WHERE fID = @vehicleID))))
					UNION ALL
				SELECT distinct fScanPickupLocationID as fID
				FROM tDataScanClean 
				WHERE (fScanURL = @websiteID OR @websiteID = 0)
				AND	  (fScanTravelCountryID = @countryID OR @countryID = 0)
				AND	  (fScanVehicleID = @vehicleID OR @vehicleID = 0)
				AND (@vehicleID = 0 OR (fScanPickupLocationID IN (SELECT fBranchLocationID from tRefBranch WHERE fBranchBrandID = (SELECT fVehicleBrandID FROM tRefVehicle WHERE fID = @vehicleID))))
			) as tD
			
	INNER JOIN tRefLocation as tLocation on tLocation.fID = tD.fID
	AND tLocation.fActive = 1
	GROUP BY tD.fID, tLocation.fLocationName
	ORDER BY fLocationName ASC

END




GO
/****** Object:  StoredProcedure [dbo].[getListTravelDatesForDataSet]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <16/03/2015>
-- Description:	<Get list of vehicle berths from vehicles table>
-- =============================================
CREATE PROCEDURE [dbo].[getListTravelDatesForDataSet]
(@DataSetDateStartSDT smalldatetime)

AS
BEGIN
	
	SET NOCOUNT ON;
	
    -- temp table of dates in this report
	DECLARE @tDates TABLE (fldID int IDENTITY(1,1) PRIMARY KEY, fTravelDates nvarchar(max), fScanPickupDate date, fScanReturnDate date, fActive int)
	INSERT INTO @tDates (fTravelDates, fScanPickupDate, fScanReturnDate, fActive)
	SELECT 	(CONCAT( CONVERT(VARCHAR(11),fScanPickupDate,6) , ' - ' , CONVERT(VARCHAR(11),fScanReturnDate,6))) As fTravelDate, fScanPickupDate, fScanReturnDate, 1
	FROM (
		SELECT DISTINCT fScanPickupDate, fScanReturnDate
		FROM tDataScanClean
		WHERE (fScanDate >=  dateadd(day,-1,@DataSetDateStartSDT)) and (fScanDate <=  dateadd(day, 6,@DataSetDateStartSDT) )	
	) as tMain
	ORDER BY fScanPickupDate ASC
	
	SELECT fTravelDates as fTravelDateText, concat(fScanPickupDate,',',fScanReturnDate) as fTravelDateValue FROM @tDates	
	WHERE fActive = 1

END

	



GO
/****** Object:  StoredProcedure [dbo].[getListVehicleBerths]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <16/03/2015>
-- Description:	<Get list of vehicle berths from vehicles table>
-- =============================================
CREATE PROCEDURE [dbo].[getListVehicleBerths]
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT Min ((fVehicleBerthAdults + fVehicleBerthChildren)) AS fVehicleBerthValue, (cast ((fVehicleBerthAdults + fVehicleBerthChildren) as nvarchar(10)) + ' Berth')  as fVehicleBerthName
	FROM tRefVehicle
	GROUP BY (fVehicleBerthAdults + fVehicleBerthChildren)

END




GO
/****** Object:  StoredProcedure [dbo].[getListVehicleBerthsbyWebsiteCountryBrand]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of travel countries, from the website selected>
-- =============================================
CREATE PROCEDURE [dbo].[getListVehicleBerthsbyWebsiteCountryBrand]
	 @websiteID int
	,@countryID int
	,@brandID int
	,@vehicleTypeID int
AS
BEGIN

	SELECT min(fVehicleBerthValue) as fVehicleBerthValue, CONCAT(fVehicleBerthValue,' Berth') as fVehicleBerthName from
		(SELECT  tD.fScanVehicleID as fID, tVehicle.fVehicleName as fVehicleName, (tVehicle.fVehicleBerthAdults + tVehicle.fVehicleBerthChildren) as fVehicleBerthValue from
			(SELECT distinct fScanVehicleID
				FROM tDataScanClean 
				WHERE (fScanURL = @websiteID OR @websiteID = 0)
				AND	  (fScanTravelCountryID = @countryID OR @countryID = 0)
				AND	  (fScanBrandID = @brandID OR @brandID = 0)
			) as tD
			INNER JOIN tRefVehicle as tVehicle on tVehicle.fID = tD.fScanVehicleID
			AND tVehicle.fActive = 1
		) as tBerth
	GROUP BY CONCAT(fVehicleBerthValue,' Berth')

END




GO
/****** Object:  StoredProcedure [dbo].[getListVehicleEquivalentsbyWebsiteCountryBrand]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of travel countries, from the website selected>
-- =============================================
CREATE PROCEDURE [dbo].[getListVehicleEquivalentsbyWebsiteCountryBrand]
	 @websiteID int
	,@countryID int
	,@brandID int
	,@vehicleTypeID int
	,@vehicleBerthID int
AS
BEGIN
	
	SELECT tD.fScanVehicleID as fID, concat(tBrand.fBrandName, ' ',tVehicle.fVehicleName) as fVehicleName from
		(SELECT distinct fScanVehicleID
		FROM tDataScanClean 
		WHERE (fScanURL = @websiteID OR @websiteID = 0)
		AND	  (fScanTravelCountryID = @countryID OR @countryID = 0)
		AND	  (fScanBrandID = @brandID or @brandID = 0)) as tD
	INNER JOIN tRefVehicle as tVehicle on tVehicle.fID = tD.fScanVehicleID
	INNER JOIN tRefBrand as tBrand on tBrand.fID = tVehicle.fVehicleBrandID
	AND tVehicle.fActive = 1
	AND (tVehicle.fVehicleTypeID = @vehicleTypeID OR @vehicleTypeID = 0)
	AND ((tVehicle.fVehicleBerthAdults + tVehicle.fVehicleBerthChildren) = @vehicleBerthID OR @vehicleBerthID = 0)
	AND tD.fScanVehicleID in (SELECT fVehicleOneID FROM tRefVehicleEquivalent WHERE fActive > 0)
	ORDER BY fVehicleName ASC

END




GO
/****** Object:  StoredProcedure [dbo].[getListVehicles]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <13/03/2015>
-- Description:	<get the list of vehicles from the vehicles table>
-- =============================================
CREATE PROCEDURE [dbo].[getListVehicles]
	@activeID int

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT * FROM tRefVehicle as v
	--INNER JOIN tRefBrand as b on v.fVehicleBrandID = b.fID
	WHERE NOT v.fActive = 0
	--AND b.fActive = @activeID
	ORDER BY fVehicleName
END




GO
/****** Object:  StoredProcedure [dbo].[getListVehiclesbyBrandID]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <13/03/2015>
-- Description:	<get the list of vehicles from the vehicles table>
-- =============================================

CREATE PROCEDURE [dbo].[getListVehiclesbyBrandID]
	@brandID int

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT * FROM tRefVehicle as v
	--INNER JOIN tRefBrand as b on v.fVehicleBrandID = b.fID
	WHERE NOT v.fActive = 0
	AND (@brandID = 0 OR v.fVehicleBrandID = @brandID)
	ORDER BY fVehicleName
END




GO
/****** Object:  StoredProcedure [dbo].[getListVehiclesbyWebsiteCountryBrand]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of travel countries, from the website selected>
-- =============================================
CREATE PROCEDURE [dbo].[getListVehiclesbyWebsiteCountryBrand]
	 @websiteID int
	,@countryID int
	,@brandID int
	,@vehicleTypeID int
	,@vehicleBerthID int
AS
BEGIN
	
	SELECT tD.fScanVehicleID as fID, tVehicle.fVehicleName as fVehicleName from
		(SELECT distinct fScanVehicleID
		FROM tDataScanClean 
		WHERE (@websiteID = 0 OR fScanURL = @websiteID)
		AND	  (@countryID = 0 OR fScanTravelCountryID = @countryID)
		AND	  (@brandID = 0	  OR fScanBrandID = @brandID)
		) as tD
	INNER JOIN (SELECT * FROM tRefVehicle 
				WHERE fActive = 1
	AND (@vehicleTypeID = 0  OR fVehicleTypeID = @vehicleTypeID)
	AND (@vehicleBerthID = 0 OR (fVehicleBerthAdults + fVehicleBerthChildren) = @vehicleBerthID))
	as tVehicle on tVehicle.fID = tD.fScanVehicleID
	
	ORDER BY fVehicleName ASC

END




GO
/****** Object:  StoredProcedure [dbo].[getListVehicleTypes]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of vehicle types from the vehicle types table>
-- =============================================
CREATE PROCEDURE [dbo].[getListVehicleTypes]

AS
BEGIN

	SET NOCOUNT ON;

    SELECT * from tRefVehicleType
	WHERE fActive = 1
END




GO
/****** Object:  StoredProcedure [dbo].[getListVehicleTypesbyWebsiteCountryBrand]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of travel countries, from the website selected>
-- =============================================
CREATE PROCEDURE [dbo].[getListVehicleTypesbyWebsiteCountryBrand]
	 @websiteID int
	,@countryID int
	,@brandID int
AS
BEGIN

	CREATE TABLE #tVehicles (fScanVehicleID int)
	INSERT INTO #tVehicles (fScanVehicleID)
	SELECT distinct fScanVehicleID FROM tDataScanClean
	WHERE     (@websiteID = 0 OR fScanURL = @websiteID)
		AND	  (@countryID = 0 OR fScanTravelCountryID = @countryID)
		AND	  (@brandID = 0	  OR fScanBrandID = @brandID)		

	SELECT distinct tVehicleType.fID as fID, tVehicleType.fVehicleTypeName as fVehicleTypeName
	FROM #tVehicles as tD
	INNER JOIN (SELECT fID, fVehicleTypeID FROM tRefVehicle WHERE fActive = 1 )		  as tVehicle		on tVehicle.fID = tD.fScanVehicleID
	INNER JOIN (SELECT fID, fVehicleTypeName FROM tRefVehicleType WHERE fActive = 1 ) as tVehicleType	on tVehicleType.fID = tVehicle.fVehicleTypeID

END




GO
/****** Object:  StoredProcedure [dbo].[getListWebsites]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<get the list of websites from the websites table>
-- =============================================
CREATE PROCEDURE [dbo].[getListWebsites]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM tRefWebsite
	WHERE NOT fActive = 0
END




GO
/****** Object:  StoredProcedure [dbo].[getScanDataCleanByFilters]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <17/03/15>
-- Description:	<Get data from clean data table>
-- =============================================
CREATE PROCEDURE [dbo].[getScanDataCleanByFilters]
  @DataSetDateStart nvarchar(MAX)
, @TravelDateRanges nvarchar(MAX)
, @CountryID int
, @BrandID int
, @PickupReturnLocationComboID nvarchar(max) 
, @VehicleID int
, @VehicleTypeID int
, @VehicleBerthID int
, @LicenceCountryID int
, @ScanURLs nvarchar(max) 
, @PriceExceptions int

AS
BEGIN	


DECLARE 
  @firstURL int
, @SecondURL int
, @ThirdURL int
, @FourthURL int
, @FifthURL int
, @SixthURL int
, @SeventhURL int
, @EighthURL int
, @firstURLName nvarchar(200)
, @SecondURLName nvarchar(200)
, @ThirdURLName nvarchar(200)
, @FourthURLName nvarchar(200)
, @FifthURLName nvarchar(200)
, @SixthURLName nvarchar(200)
, @SeventhURLName nvarchar(200)
, @EighthURLName nvarchar(200)
, @DataSetSDT date
, @DataSetDateStartSDT date


	SET @DataSetDateStartSDT = 
	CASE 
		WHEN  (@DataSetDateStart = 'NULL' OR @DataSetDateStart is Null)
			THEN CONVERT(SMALLDATETIME, '2000-01-01')
		ELSE
			CONVERT(SMALLDATETIME, @DataSetDateStart)
	END

	--create list of location combinations
	DECLARE @locationCombinationsTAB TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fPickupLocationID int, fReturnLocationID int)
	INSERT INTO @locationCombinationsTAB (fPickupLocationID, fReturnLocationID)
	SELECT substring(string,1,charindex('-',string)-1), reverse(substring(reverse(string),0,charindex('-',reverse(string)))) 
	FROM (SELECT Split.a.value('.', 'VARCHAR(100)') AS String from (SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](@PickupReturnLocationComboID), ';', '</M><M>') + '</M>' AS XML) AS String ) AS a CROSS APPLY String.nodes ('/M') AS Split(a)) as t
	
	--get country this report is for
	DECLARE @locCountryID int
	SET @locCountryID =
		CASE
			WHEN @countryID = 0
			THEN (select fCountryID from tRefLocation WHERE fID = (SELECT top 1 fPickupLocationID from @locationCombinationsTAB))
			ELSE @locCountryID
		END
	--add combinations where "all return locations" was selected for a specific pickup location
	INSERT INTO @locationCombinationsTAB (fPickupLocationID, fReturnLocationID)
	SELECT t.fPickupLocationID, tR.fID FROM @locationCombinationsTAB t
	CROSS JOIN (SELECT fID from tRefLocation WHERE fCountryID = @countryID) tR	
	WHERE fReturnLocationID = 0
	--add combinations where "all pickup locations" was selected for a specific return location
	INSERT INTO @locationCombinationsTAB (fPickupLocationID, fReturnLocationID)
	SELECT tP.fID, tR.fReturnLocationID FROM (SELECT fID from tRefLocation WHERE fCountryID = @countryID) tP
	CROSS JOIN (SELECT fReturnLocationID FROM @locationCombinationsTAB WHERE fPickupLocationID = 0) tR
	--remove unnecessary lines
	DELETE FROM @locationCombinationsTAB
	WHERE fPickupLocationID = 0 or fReturnLocationID = 0

--SELECT * FROM @locationCombinationsTAB
	
	--create list of travel date ranges
	DECLARE @travelDatesFilterTAB TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fPickupDate smalldatetime, fReturnDate smalldatetime, fTravelDates nvarchar(max), fActive int)
	INSERT INTO @travelDatesFilterTAB (fPickupDate, fReturnDate, fActive)
	SELECT substring(string,1,charindex(',',string)-1), reverse(substring(reverse(string),0,charindex(',',reverse(string)))) , 1
	FROM (SELECT Split.a.value('.', 'VARCHAR(100)') AS String from (SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](@TravelDateRanges), ';', '</M><M>') + '</M>' AS XML) AS String ) AS a CROSS APPLY String.nodes ('/M') AS Split(a)) as t			
    -- temp table of dates in this report
	DECLARE @tDates TABLE (fldID int IDENTITY(1,1) PRIMARY KEY, fScanPickupDate smalldatetime, fScanReturnDate smalldatetime, fTravelDates nvarchar(max), fActive int)
	INSERT INTO @tDates (fScanPickupDate, fScanReturnDate, fTravelDates, fActive)
	SELECT 	fScanPickupDate, fScanReturnDate, (CONCAT( CONVERT(VARCHAR(11),fScanPickupDate,6) , ' - ' , CONVERT(VARCHAR(11),fScanReturnDate,6))) As fTravelDates	, 1
	FROM (
		SELECT DISTINCT fScanPickupDate, fScanReturnDate
		FROM tDataScanClean
		WHERE (fScanDate >=  dateadd(day,-1,@DataSetDateStartSDT)) and (fScanDate <=  dateadd(day, 6,@DataSetDateStartSDT) )	
	) as tMain
	ORDER BY fScanPickupDate ASC
	--remove unneccessary dates
	DELETE FROM @travelDatesFilterTAB WHERE NOT concat(fPickupDate,',',fReturnDate) in (SELECT concat(fScanPickupDate,',',fScanReturnDate) FROM @tDates)
	--add travel dates text
	UPDATE @travelDatesFilterTAB
	SET fTravelDates = (CONCAT( CONVERT(VARCHAR(11),fPickupDate,6) , ' - ' , CONVERT(VARCHAR(11),fPickupDate,6)))
		
--SELECT * FROM @travelDatesFilterTAB

	--get urls in order
	DECLARE @URLtable TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fScanURL int)
	DECLARE @urlList nvarchar(max)
	SELECT @urlList = COALESCE ( COALESCE(@urlList+';','') + CAST(Fid AS NVARCHAR(20)), @urlList) FROM tRefWebsite
	DECLARE @URLcount int
	SET @ScanURLs = concat(@ScanURLs,';')
	SET @ScanURLs = 
		CASE 
			WHEN @ScanURLs = '0;'
			THEN @urlList
			WHEN @ScanURLs LIKE '0%'
			THEN REPLACE(@ScanURLs,'0;','')
			ELSE @ScanURLs
		END 
	--convert list of URLs to table
	WHILE CHARINDEX(';', @ScanURLs) > 0 
	BEGIN
		DECLARE @tmpstr VARCHAR(50)
		 SET @tmpstr = SUBSTRING(@ScanURLs, 1, ( CHARINDEX(';', @ScanURLs) - 1 ))

		INSERT INTO @URLtable (fScanURL)
		VALUES  (@tmpstr)   
		SET @ScanURLs = SUBSTRING(@ScanURLs, CHARINDEX(';', @ScanURLs) + 1, LEN(@ScanURLs))
	END
	SET @URLcount = (select count(fScanURL) from @URLtable)

	--set URL values for report
	SET @firstURL = (SELECT TOP 1 fScanURL from @URLtable WHERE NOT fScanURL = 0 ORDER BY fID ASC)
	SET @SecondURL = [dbo].[getOrderOfComparisonData](@firstURL,2)
	SET @ThirdURL = [dbo].[getOrderOfComparisonData](@firstURL,3)
	SET @FourthURL = [dbo].[getOrderOfComparisonData](@firstURL,4)
	SET @FifthURL = [dbo].[getOrderOfComparisonData](@firstURL,5)
	SET @SixthURL = [dbo].[getOrderOfComparisonData](@firstURL,6)
	SET @SeventhURL = [dbo].[getOrderOfComparisonData](@firstURL,7)
	SET @EighthURL = [dbo].[getOrderOfComparisonData](@firstURL,8)

	SET @firstURLName = (SELECT fWebsiteName from tRefWebsite WHERE fID = @firstURL)
	SET @secondURLName = (SELECT fWebsiteName from tRefWebsite WHERE fID = @secondURL)
	SET @thirdURLName = (SELECT fWebsiteName from tRefWebsite WHERE fID = @thirdURL)
	SET @fourthURLName = (SELECT fWebsiteName from tRefWebsite WHERE fID = @fourthURL)
	SET @fifthURLName = (SELECT fWebsiteName from tRefWebsite WHERE fID = @fifthURL)
	SET @sixthURLName = (SELECT fWebsiteName from tRefWebsite WHERE fID = @sixthURL)
	SET @seventhURLName = (SELECT fWebsiteName from tRefWebsite WHERE fID = @seventhURL)
	SET @EighthURLName = (SELECT fWebsiteName from tRefWebsite WHERE fID = @eighthURL)
	
	--get table of acceptable licence country codes
	DECLARE @tLicenceCountryCode TABLE (fldID int IDENTITY(1,1) PRIMARY KEY, NatOrInternational int, LicenceCounrtyID int, websiteID int, travelCountry int)
	INSERT INTO @tLicenceCountryCode(NatOrInternational, LicenceCounrtyID, websiteID, travelCountry)
	SELECT 1, [fDomLicenceCountryID], [fWebsiteID], [fTravelCountryID]
	FROM [comparison].[dbo].[tRefDriversLicenceCodes]  
	INSERT INTO @tLicenceCountryCode(NatOrInternational, LicenceCounrtyID, websiteID, travelCountry)
	SELECT 2, [fIntLicenceCountryID], [fWebsiteID], [fTravelCountryID]
	FROM [comparison].[dbo].[tRefDriversLicenceCodes]  					
	DELETE FROM @tLicenceCountryCode WHERE Not @LicenceCountryID = NatOrInternational
	
--SELECT * FROM @tLicenceCountryCode

	--get required data set into temp table
	IF OBJECT_ID('tempdb..#tTempTable') IS NOT NULL
	/*Then it exists*/
	DROP TABLE #tTempTable
	--create table
	CREATE TABLE #tTempTable 
		(
		   fScanID int
		  ,fScanDate smalldatetime
		  ,fScanURL int
		  ,fLinkURL nvarchar(max)
		  ,fScanTravelCountryID int
		  ,fCountryName nvarchar(200)
		  ,fScanPickupLocationID int
		  ,fScanReturnLocationID int
		  ,fLocationCombination nvarchar(200)
		  ,fScanPickupDate smalldatetime
		  ,fScanReturnDate smalldatetime
		  ,fTravelDates nvarchar(200)
		  ,fScanLicenceCountryID int
		  ,fScanBrandID int
		  ,fBrandName nvarchar(200)
		  ,fVehicleName nvarchar(200)
		  ,fScanVehicleID int
		  ,fVehicleTypeID int
		  ,fVehicleBerthID int
		  ,fScanTotalPrice decimal(18,2)
		  ,fScanOriginalPrice decimal(18,2)
		  ,fPriceModifiers nvarchar(max)
		  ,fScanCurrencyID int
		  ,fScanCurrencyCode nvarchar(3)
		)

	INSERT INTO #tTempTable (	fScanID, fScanDate, fScanURL, 
								fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanReturnDate, 
								fScanLicenceCountryID, fScanBrandID, fScanVehicleID, 
								fScanTotalPrice, fScanOriginalPrice, fScanCurrencyID)

SELECT	MIN(tTemp.fScanID) as fScanID
			,tTemp.fScanDate
			,tTemp.[fScanURL]
			,tTemp.[fScanTravelCountryID]
			,tTemp.[fScanPickupLocationID]
			,tTemp.[fScanReturnLocationID]
			,tTemp.[fScanPickupDate]
			,tTemp.[fScanReturnDate]
			,tTemp.[fScanLicenceCountryID]
			,tTemp.[fScanBrandID]
			,tTemp.[fScanVehicleID]
			,[dbo].[convertPriceToCurrency](tTemp.fScanTotalPrice, tTemp.fScanCurrencyID, tTemp.fScanDate, tTemp.fScanTravelCountryID) as fScanTotalPrice
			,tTemp.fScanTotalPrice as fScanOriginalPrice
			,tTemp.[fScanCurrencyID]	

	from tDataScanClean as tTemp
	INNER JOIN @locationCombinationsTAB as tL on tL.fPickupLocationID = tTemp.[fScanPickupLocationID] AND  tL.fReturnLocationID = tTemp.[fScanReturnLocationID]
	INNER JOIN @travelDatesFilterTAB as tDates on (tDates.fPickupDate = tTemp.[fScanPickupDate] AND tDates.fReturnDate = tTemp.[fScanReturnDate])
	INNER JOIN @tLicenceCountryCode as tLC on tTemp.fScanLicenceCountryID = tLC.LicenceCounrtyID AND tTemp.[fScanTravelCountryID] = travelCountry AND tTemp.[fScanURL] = tLC.websiteID	

	WHERE 
	(tTemp.fScanDate >= @DataSetDateStartSDT AND tTemp.fScanDate <= DATEADD(day,7,@DataSetDateStartSDT) OR @DataSetDateStart = 'NULL' OR @DataSetDateStart is Null )
	AND (tTemp.fScanVehicleID  = @VehicleID OR @VehicleID = 0)
	AND (tTemp.fScanBrandID = @BrandID OR @BrandID = 0)
	AND (tTemp.fScanTravelCountryID = @CountryID OR @CountryID = 0)
	AND (fScanURL in (SELECT fScanURL FROM @URLtable))


	GROUP BY tTemp.[fScanDate]
      ,tTemp.[fScanURL]
      ,tTemp.[fScanTravelCountryID]
      ,tTemp.[fScanPickupLocationID]
      ,tTemp.[fScanReturnLocationID]
      ,tTemp.[fScanPickupDate]
      ,tTemp.[fScanReturnDate]
      ,tTemp.[fScanLicenceCountryID]
      ,tTemp.[fScanBrandID]
      ,tTemp.[fScanVehicleID]
      ,tTemp.[fScanTotalPrice]
      ,tTemp.[fScanCurrencyID]	  

	DELETE FROM #tTempTable WHERE NOT (fScanVehicleID in (SELECT fID from tRefVehicle WHERE fVehicleTypeID = @VehicleTypeID) OR @VehicleTypeID = 0)
	DELETE FROM #tTempTable WHERE NOT (fScanVehicleID in (SELECT fID from tRefVehicle WHERE (fVehicleBerthAdults + fVehicleBerthChildren) = @VehicleBerthID) OR @VehicleBerthID = 0)
	
--SELECT * FROM #tTempTable

-------------------------------------------------  4 seconds until here ----------------------------------------------------------------------------------------------

	-- add in location combinations using location names
	UPDATE #tTempTable 
	SET fLocationCombination = (rPL.fLocationName + ' - ' + rRL.fLocationName) 
	FROM #tTempTable as tD
	INNER JOIN tRefLocation as rPL on rPL.fID = tD.fScanPickupLocationID
	INNER JOIN tRefLocation as rRL on rRL.fID = tD.fScanReturnLocationID
	
	-- add in location combinations using location names
	UPDATE #tTempTable 
	SET fTravelDates = CONCAT( CONVERT(VARCHAR(11),fScanPickupDate,6) , ' - ' , CONVERT(VARCHAR(11),fScanReturnDate,6) )
	--FROM #tTempTableLarge as tD
	
	-- add in location combinations using location names
	UPDATE #tTempTable 
	SET fCountryName = tC.fCountryName  
	FROM #tTempTable as tD
	INNER JOIN tRefCountry tC on tC.fID = tD.fScanTravelCountryID
		
	-- add in location combinations using location names
	UPDATE #tTempTable 
	SET fVehicleName = (tB.fBrandName + ' ' + tV.fVehicleName),
		fBrandName = tB.fBrandName,
		fVehicleTypeID = tV.fVehicleTypeID,
		fVehicleBerthID = (cast (tV.fVehicleBerthAdults as int) + cast (tV.fVehicleBerthChildren as int) )
	FROM #tTempTable as tD
	INNER JOIN tRefVehicle tV on tV.fID = tD.fScanVehicleID
	INNER JOIN tRefBrand tB on tB.fID = tV.fVehicleBrandID	
					
	-- add in link string
	UPDATE #tTempTable 
	SET fLinkURL = concat('fW=',(CONVERT(VARCHAR(10),[dbo].[getFirstDayOfWeek](@DataSetDateStartSDT),126)),
				'&tcID=',tD.fScanTravelCountryID,
				'&bID=',tD.fScanBrandID,
				'&pID=',tD.fScanPickupLocationID,
				'&rID=',tD.fScanReturnLocationID,
				'&vID=',tD.fScanVehicleID,
				'&vtID=','0',
				'&vbID=','0',
				'&lcID=',@LicenceCountryID,
				'&eID=',@PriceExceptions) 
	FROM #tTempTable as tD

	--add price modifiers, and update price as per exceptions
	UPDATE #tTempTable 
	SET fPriceModifiers = [dbo].[getListPriceExceptionsAsString](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions),
		fScanTotalPrice = [dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)
	FROM #tTempTable as tD
						 
	UPDATE #tTempTable
	SET fScanCurrencyCode = (SELECT fCurrencyCode FROM tRefCurrency WHERE fID = fScanCurrencyID)
	FROM #tTempTable as tD
	

	

	--get required data set into temp table
	IF OBJECT_ID('tempdb..#tTempFinal') IS NOT NULL
	/*Then it exists*/
	DROP TABLE #tTempFinal
	--create table
	CREATE TABLE #tTempFinal 
		(	fID int IDENTITY(1,1) PRIMARY KEY
		  ,fScanID int
		  ,fCountryName nvarchar(200)
		  ,fLinkURL nvarchar(max)
		  ,fLocationCombination nvarchar(200)
		  ,fVehicleName nvarchar(200)
		  ,fTravelDates nvarchar(200)
		  ,fMainClass nvarchar(200)
		  ,fScanCurrency nvarchar(3)
		  ,fScanTotalPrice nvarchar(200)
		  ,fScanTotalPriceDEC decimal(18,2)
		  ,fScanOriginalPrice nvarchar(200)
		  ,fScanOriginalPriceDEC decimal(18,2)
		  ,fScanOriginalModifiers nvarchar(max)
		  ,fSecondPrice nvarchar(200)
		  ,fSecondPriceDEC decimal(18,2)
		  ,fSecondOriginalPrice nvarchar(200)
		  ,fSecondOriginalPriceDEC decimal(18,2)
		  ,fSecondComparison nvarchar(200)
		  ,fSecondClass nvarchar(200)
		  ,fSecondCurrency nvarchar(3)
		  ,fSecondModifiers nvarchar(max)
		  ,fThirdPrice nvarchar(200)
		  ,fThirdPriceDEC decimal(18,2)
		  ,fThirdOriginalPrice nvarchar(200)
		  ,fThirdOriginalPriceDEC decimal(18,2)
		  ,fThirdComparison nvarchar(200)
		  ,fThirdClass nvarchar(200)
		  ,fThirdCurrency nvarchar(3)
		  ,fThirdModifiers nvarchar(max)
		  ,fFourthPrice nvarchar(200)
		  ,fFourthPriceDEC decimal(18,2)
		  ,fFourthOriginalPrice nvarchar(200)
		  ,fFourthOriginalPriceDEC decimal(18,2)
		  ,fFourthComparison nvarchar(200)
		  ,fFourthClass nvarchar(200)
		  ,fFourthCurrency nvarchar(3)
		  ,fFourthModifiers nvarchar(max)
		  ,fFifthPrice nvarchar(200)
		  ,fFifthPriceDEC decimal(18,2)
		  ,fFifthOriginalPrice nvarchar(200)
		  ,fFifthOriginalPriceDEC decimal(18,2)
		  ,fFifthComparison nvarchar(200)
		  ,fFifthClass nvarchar(200)
		  ,fFifthCurrency nvarchar(3)
		  ,fFifthModifiers nvarchar(max)
		  ,fSixthPrice nvarchar(200)
		  ,fSixthPriceDEC decimal(18,2)
		  ,fSixthOriginalPrice nvarchar(200)
		  ,fSixthOriginalPriceDEC decimal(18,2)
		  ,fSixthComparison nvarchar(200)
		  ,fSixthClass nvarchar(200)
		  ,fSixthCurrency nvarchar(3)
		  ,fSixthModifiers nvarchar(max)
		  ,fSeventhPrice nvarchar(200)
		  ,fSeventhPriceDEC decimal(18,2)
		  ,fSeventhOriginalPrice nvarchar(200)
		  ,fSeventhOriginalPriceDEC decimal(18,2)
		  ,fSeventhComparison nvarchar(200)
		  ,fSeventhClass nvarchar(200)
		  ,fSeventhCurrency nvarchar(3)
		  ,fSeventhModifiers nvarchar(max)
		  ,fEighthPrice nvarchar(200)
		  ,fEighthPriceDEC decimal(18,2)
		  ,fEighthOriginalPrice nvarchar(200)
		  ,fEighthOriginalPriceDEC decimal(18,2)
		  ,fEighthComparison nvarchar(200)
		  ,fEighthClass nvarchar(200)
		  ,fEighthCurrency nvarchar(3)
		  ,fEighthModifiers nvarchar(max)		 
		)


INSERT INTO #tTempFinal 
		(
		   fScanID
		  ,fCountryName 
		  ,fLinkURL 
		  ,fLocationCombination 
		  ,fVehicleName 
		  ,fTravelDates 
		  ,fScanCurrency 
		  ,fScanTotalPriceDEC
		  ,fScanOriginalPriceDEC 
		  ,fScanOriginalModifiers 
		  ,fSecondPriceDEC 
		  ,fSecondOriginalPriceDEC 
		  ,fSecondCurrency 
		  ,fSecondModifiers 
		  ,fThirdPriceDEC 
		  ,fThirdOriginalPriceDEC 
		  ,fThirdCurrency 
		  ,fThirdModifiers 
		  ,fFourthPriceDEC 
		  ,fFourthOriginalPriceDEC 
		  ,fFourthCurrency 
		  ,fFourthModifiers 
		  ,fFifthPriceDEC 
		  ,fFifthOriginalPriceDEC 
		  ,fFifthCurrency 
		  ,fFifthModifiers 
		  ,fSixthPriceDEC 
		  ,fSixthOriginalPriceDEC 
		  ,fSixthCurrency 
		  ,fSixthModifiers 
		  ,fSeventhPriceDEC 
		  ,fSeventhOriginalPriceDEC 
		  ,fSeventhCurrency 
		  ,fSeventhModifiers 
		  ,fEighthPriceDEC 
		  ,fEighthOriginalPriceDEC 
		  ,fEighthCurrency 
		  ,fEighthModifiers 
		  )

	SELECT tMain.fScanID
		  --,min(tMain.fScanID) as fScanID
		  ,tMain.fCountryName 
		  ,tMain.fLinkURL	
		  ,tMain.fLocationCombination
		  ,tMain.fVehicleName
		  ,tMain.fTravelDates 
		  ,t1.fFirstCurrencyCode
		  ,fFirstPrice
		  ,t1.fFirstOriginalPrice 
		  ,fFirstModifiers   
		  ,fSecondPrice
		  ,fSecondOriginalPrice 
		  ,fSecondCurrencyCode
		  ,fSecondModifiers
		  ,fThirdPrice
		  ,fThirdOriginalPrice 
		  ,fThirdCurrencyCode
		  ,fThirdModifiers
		  ,fFourthPrice
		  ,fFourthOriginalPrice 
		  ,fFourthCurrencyCode
		  ,fFourthModifiers
		  ,fFifthPrice
		  ,fFifthOriginalPrice 
		  ,fFifthCurrencyCode
		  ,fFifthModifiers
		  ,fSixthPrice
		  ,fSixthOriginalPrice 
		  ,fSixthCurrencyCode
		  ,fSixthModifiers
		  ,fSeventhPrice
		  ,fSeventhOriginalPrice 
		  ,fSeventhCurrencyCode
		  ,fSeventhModifiers
		  ,fEighthPrice
		  ,fEighthOriginalPrice 
		  ,fEighthCurrencyCode
		  ,fEighthModifiers

	 FROM(	  
			SELECT  min (fScanID) as fScanID	
					, fScanDate
					, fLinkURL	
					, fScanTravelCountryID
					, fCountryName 
					, fScanPickupLocationID as fPickupLocationID
					, fScanReturnLocationID as fReturnLocationID
					, fScanPickupDate
					, fScanReturnDate
					, fTravelDates 
					, fScanBrandID
					, fBrandName 
					, fScanVehicleID
					, fVehicleName 
					, fScanLicenceCountryID
					, fLocationCombination
					from #tTempTable as tTable				
					GROUP BY fScanDate 
					, fLinkURL	
					, fScanTravelCountryID
					, fCountryName 
					, fScanPickupLocationID 
					, fScanReturnLocationID 
					, fScanPickupDate
					, fScanReturnDate
					, fTravelDates 
					, fScanBrandID
					, fBrandName 
					, fScanVehicleID
					, fVehicleName 
					, fScanLicenceCountryID
					, fLocationCombination
					
		) as tMain 
	
	LEFT JOIN (	SELECT fScanTravelCountryID
						  ,fScanPickupLocationID
						  ,fScanReturnLocationID
						  ,fScanPickupDate
						  ,fScanLicenceCountryID
						  ,fScanVehicleID
						  ,fScanURL as fFirstURL
						  ,fScanTotalPrice as fFirstPrice
						  ,fPriceModifiers as fFirstModifiers
						  ,fScanOriginalPrice as fFirstOriginalPrice
						  ,fScanCurrencyID as fFirstCurrencyID 
						  ,fScanCurrencyCode as fFirstCurrencyCode
					FROM #tTempTable 					
					WHERE (@firstURL = fScanURL) 
				 ) as t1 on (convert (varchar, t1.fScanPickupDate,101)) = (convert (varchar, tMain.fScanPickupDate,101)) 
				 AND t1.[fScanVehicleID] = tMain.[fScanVehicleID]
				 AND t1.fScanTravelCountryID = tMain.fScanTravelCountryID
				 AND t1.fScanPickupLocationID = tMain.fPickupLocationID
				 AND t1.fScanReturnLocationID = tMain.fReturnLocationID
				 
	LEFT JOIN (	SELECT fScanTravelCountryID
						  ,fScanPickupLocationID
						  ,fScanReturnLocationID
						  ,fScanPickupDate
						  ,fScanLicenceCountryID
						  ,fScanVehicleID
						  ,fScanURL as fSecondURL
						  ,fScanTotalPrice as fSecondPrice
						  ,fPriceModifiers as fSecondModifiers
						  ,fScanOriginalPrice as fSecondOriginalPrice
						  ,fScanCurrencyID as fSecondCurrencyID 
						  ,fScanCurrencyCode as fSecondCurrencyCode
					FROM #tTempTable 					
					WHERE (@SecondURL = fScanURL)
				 ) as t2 on (convert (varchar, t2.fScanPickupDate,101)) = (convert (varchar, tMain.fScanPickupDate,101)) 
				 AND t2.[fScanVehicleID] = tMain.[fScanVehicleID]
				 AND t2.fScanTravelCountryID = tMain.fScanTravelCountryID
				 AND t2.fScanPickupLocationID = tMain.fPickupLocationID
				 AND t2.fScanReturnLocationID = tMain.fReturnLocationID
	
	LEFT JOIN (	SELECT fScanTravelCountryID
						  ,fScanPickupLocationID
						  ,fScanReturnLocationID
						  ,fScanPickupDate
						  ,fScanLicenceCountryID
						  ,fScanVehicleID
						  ,fScanURL as fThirdURL
						  ,fScanTotalPrice as fThirdPrice
						  ,fPriceModifiers as fThirdModifiers
						  ,fScanOriginalPrice as fThirdOriginalPrice
						  ,fScanCurrencyID as fThirdCurrencyID 
						  ,fScanCurrencyCode as fThirdCurrencyCode
					FROM #tTempTable 					
					WHERE (@ThirdURL = fScanURL)
				 ) as t3 on (convert (varchar, t3.fScanPickupDate,101)) = (convert (varchar, tMain.fScanPickupDate,101)) 
				 AND t3.[fScanVehicleID] = tMain.[fScanVehicleID]
				 AND t3.fScanTravelCountryID = tMain.fScanTravelCountryID
				 AND t3.fScanPickupLocationID = tMain.fPickupLocationID
				 AND t3.fScanReturnLocationID = tMain.fReturnLocationID
				 
	LEFT JOIN (	SELECT fScanTravelCountryID
						  ,fScanPickupLocationID
						  ,fScanReturnLocationID
						  ,fScanPickupDate
						  ,fScanLicenceCountryID
						  ,fScanVehicleID
						  ,fScanURL as fFourthURL
						  ,fScanTotalPrice as fFourthPrice
						  ,fPriceModifiers as fFourthModifiers
						  ,fScanOriginalPrice as fFourthOriginalPrice
						  ,fScanCurrencyID as fFourthCurrencyID 
						  ,fScanCurrencyCode as fFourthCurrencyCode
					FROM #tTempTable 					
					WHERE (@FourthURL = fScanURL)
				 ) as t4 on (convert (varchar, t4.fScanPickupDate,101)) = (convert (varchar, tMain.fScanPickupDate,101)) 
				 AND t4.[fScanVehicleID] = tMain.[fScanVehicleID]
				 AND t4.fScanTravelCountryID = tMain.fScanTravelCountryID
				 AND t4.fScanPickupLocationID = tMain.fPickupLocationID
				 AND t4.fScanReturnLocationID = tMain.fReturnLocationID
				 
	LEFT JOIN (	SELECT fScanTravelCountryID
						  ,fScanPickupLocationID
						  ,fScanReturnLocationID
						  ,fScanPickupDate
						  ,fScanLicenceCountryID
						  ,fScanVehicleID
						  ,fScanURL as fFifthURL
						  ,fScanTotalPrice as fFifthPrice
						  ,fPriceModifiers as fFifthModifiers
						  ,fScanOriginalPrice as fFifthOriginalPrice
						  ,fScanCurrencyID as fFifthCurrencyID 
						  ,fScanCurrencyCode as fFifthCurrencyCode
					FROM #tTempTable 					
					WHERE (@FifthURL = fScanURL)
				 ) as t5 on (convert (varchar, t5.fScanPickupDate,101)) = (convert (varchar, tMain.fScanPickupDate,101)) 
				 AND t5.[fScanVehicleID] = tMain.[fScanVehicleID]
				 AND t5.fScanTravelCountryID = tMain.fScanTravelCountryID
				 AND t5.fScanPickupLocationID = tMain.fPickupLocationID
				 AND t5.fScanReturnLocationID = tMain.fReturnLocationID
				 
	LEFT JOIN (	SELECT fScanTravelCountryID
						  ,fScanPickupLocationID
						  ,fScanReturnLocationID
						  ,fScanPickupDate
						  ,fScanLicenceCountryID
						  ,fScanVehicleID
						  ,fScanURL as fSixthURL
						  ,fScanTotalPrice as fSixthPrice
						  ,fPriceModifiers as fSixthModifiers
						  ,fScanOriginalPrice as fSixthOriginalPrice
						  ,fScanCurrencyID as fSixthCurrencyID 
						  ,fScanCurrencyCode as fSixthCurrencyCode
					FROM #tTempTable 					
					WHERE (@SixthURL = fScanURL)
				 ) as t6 on (convert (varchar, t6.fScanPickupDate,101)) = (convert (varchar, tMain.fScanPickupDate,101)) 
				 AND t6.[fScanVehicleID] = tMain.[fScanVehicleID]
				 AND t6.fScanTravelCountryID = tMain.fScanTravelCountryID
				 AND t6.fScanPickupLocationID = tMain.fPickupLocationID
				 AND t6.fScanReturnLocationID = tMain.fReturnLocationID

	LEFT JOIN (	SELECT fScanTravelCountryID
						  ,fScanPickupLocationID
						  ,fScanReturnLocationID
						  ,fScanPickupDate
						  ,fScanLicenceCountryID
						  ,fScanVehicleID
						  ,fScanURL as fSeventhURL
						  ,fScanTotalPrice as fSeventhPrice
						  ,fPriceModifiers as fSeventhModifiers
						  ,fScanOriginalPrice as fSeventhOriginalPrice
						  ,fScanCurrencyID as fSeventhCurrencyID 
						  ,fScanCurrencyCode as fSeventhCurrencyCode
					FROM #tTempTable 					
					WHERE (@SeventhURL = fScanURL)
				 ) as t7 on (convert (varchar, t7.fScanPickupDate,101)) = (convert (varchar, tMain.fScanPickupDate,101)) 
				 AND t7.[fScanVehicleID] = tMain.[fScanVehicleID]
				 AND t7.fScanTravelCountryID = tMain.fScanTravelCountryID
				 AND t7.fScanPickupLocationID = tMain.fPickupLocationID
				 AND t7.fScanReturnLocationID = tMain.fReturnLocationID

	LEFT JOIN (	SELECT fScanTravelCountryID
						  ,fScanPickupLocationID
						  ,fScanReturnLocationID
						  ,fScanPickupDate
						  ,fScanLicenceCountryID
						  ,fScanVehicleID
						  ,fScanURL as fEighthURL
						  ,fScanTotalPrice as fEighthPrice
						  ,fPriceModifiers as fEighthModifiers
						  ,fScanOriginalPrice as fEighthOriginalPrice
						  ,fScanCurrencyID as fEighthCurrencyID 
						  ,fScanCurrencyCode as fEighthCurrencyCode
					FROM #tTempTable 					
					WHERE (@EighthURL = fScanURL)
				 ) as t8 on (convert (varchar, t8.fScanPickupDate,101)) = (convert (varchar, tMain.fScanPickupDate,101)) 
				 AND t8.[fScanVehicleID] = tMain.[fScanVehicleID]
				 AND t8.fScanTravelCountryID = tMain.fScanTravelCountryID
				 AND t8.fScanPickupLocationID = tMain.fPickupLocationID
				 AND t8.fScanReturnLocationID = tMain.fReturnLocationID

	WHERE 
	(tMain.fScanBrandID in (SELECT fID from tRefBrand WHERE fActive = 1))
	AND (tMain.fScanVehicleID in (SELECT fID from tRefVehicle WHERE fActive = 1))
	
	--group by 
	--	   tMain.fCountryName 
	--	  ,tMain.fLinkURL	
	--	  ,tMain.fLocationCombination
	--	  ,tMain.fVehicleName
	--	  ,tMain.fTravelDates 
	--	  ,t1.fFirstCurrencyCode
	--	  ,fFirstPrice
	--	  ,t1.fFirstOriginalPrice 
	--	  ,fFirstModifiers   
	--	  ,fSecondPrice
	--	  ,fSecondOriginalPrice 
	--	  ,fSecondCurrencyCode
	--	  ,fSecondModifiers
	--	  ,fThirdPrice
	--	  ,fThirdOriginalPrice 
	--	  ,fThirdCurrencyCode
	--	  ,fThirdModifiers
	--	  ,fFourthPrice
	--	  ,fFourthOriginalPrice 
	--	  ,fFourthCurrencyCode
	--	  ,fFourthModifiers
	--	  ,fFifthPrice
	--	  ,fFifthOriginalPrice 
	--	  ,fFifthCurrencyCode
	--	  ,fFifthModifiers
	--	  ,fSixthPrice
	--	  ,fSixthOriginalPrice 
	--	  ,fSixthCurrencyCode
	--	  ,fSixthModifiers
	--	  ,fSeventhPrice
	--	  ,fSeventhOriginalPrice 
	--	  ,fSeventhCurrencyCode
	--	  ,fSeventhModifiers
	--	  ,fEighthPrice
	--	  ,fEighthOriginalPrice 
	--	  ,fEighthCurrencyCode
	--	  ,fEighthModifiers


---------------------------------------------------------------


DELETE FROM #tTempTable

DELETE FROM #tTempFinal where fID not in
	(	SELECT min(fID) from #tTempFinal 
		GROUP BY  fCountryName 
		  ,fLocationCombination 
		  ,fVehicleName 
		  ,fTravelDates 
		  ,fScanTotalPriceDEC
		  ,fSecondPriceDEC 
		  ,fThirdPriceDEC 
		  ,fFourthPriceDEC 
		  ,fFifthPriceDEC 
		  ,fSixthPriceDEC 
		  ,fSeventhPriceDEC 
		  ,fEighthPriceDEC 
	)


UPDATE #tTempFinal
SET fMainClass = [dbo].[getClassName](1, fScanTotalPriceDEC, fSecondPriceDEC, fThirdPriceDEC,fFourthPriceDEC,fFifthPriceDEC,fSixthPriceDEC,fSeventhPriceDEC,fEighthPriceDEC),
	fSecondComparison = [dbo].[replaceEmptyPrice](CONCAT(IsNull(CAST( ((fSecondPriceDEC-fScanTotalPriceDEC)/fScanTotalPriceDEC*100) as decimal(18,2)),0),'%')),
	fSecondClass = [dbo].[getClassName](2, fScanTotalPriceDEC, fSecondPriceDEC, fThirdPriceDEC,fFourthPriceDEC,fFifthPriceDEC,fSixthPriceDEC,fSeventhPriceDEC,fEighthPriceDEC),
	fThirdComparison = [dbo].[replaceEmptyPrice](CONCAT(IsNull(CAST( ((fThirdPriceDEC-fScanTotalPriceDEC)/fScanTotalPriceDEC*100) as decimal(18,2)),0),'%')),
	fThirdClass = [dbo].[getClassName](3, fScanTotalPriceDEC, fSecondPriceDEC, fThirdPriceDEC,fFourthPriceDEC,fFifthPriceDEC,fSixthPriceDEC,fSeventhPriceDEC,fEighthPriceDEC),
	fFourthComparison = [dbo].[replaceEmptyPrice](CONCAT(IsNull(CAST( ((fFourthPriceDEC-fScanTotalPriceDEC)/fScanTotalPriceDEC*100) as decimal(18,2)),0),'%')),
	fFourthClass = [dbo].[getClassName](4, fScanTotalPriceDEC, fSecondPriceDEC, fThirdPriceDEC,fFourthPriceDEC,fFifthPriceDEC,fSixthPriceDEC,fSeventhPriceDEC,fEighthPriceDEC),
	fFifthComparison = [dbo].[replaceEmptyPrice](CONCAT(IsNull(CAST( ((fFifthPriceDEC-fScanTotalPriceDEC)/fScanTotalPriceDEC*100) as decimal(18,2)),0),'%')),
	fFifthClass = [dbo].[getClassName](5, fScanTotalPriceDEC, fSecondPriceDEC, fThirdPriceDEC,fFourthPriceDEC,fFifthPriceDEC,fSixthPriceDEC,fSeventhPriceDEC,fEighthPriceDEC),
	fSixthComparison = [dbo].[replaceEmptyPrice](CONCAT(IsNull(CAST( ((fSixthPriceDEC-fScanTotalPriceDEC)/fScanTotalPriceDEC*100) as decimal(18,2)),0),'%')),
	fSixthClass = [dbo].[getClassName](6, fScanTotalPriceDEC, fSecondPriceDEC, fThirdPriceDEC,fFourthPriceDEC,fFifthPriceDEC,fSixthPriceDEC,fSeventhPriceDEC,fEighthPriceDEC),
	fSeventhComparison = [dbo].[replaceEmptyPrice](CONCAT(IsNull(CAST( ((fSeventhPriceDEC-fScanTotalPriceDEC)/fScanTotalPriceDEC*100) as decimal(18,2)),0),'%')),
	fSeventhClass = [dbo].[getClassName](7, fScanTotalPriceDEC, fSecondPriceDEC, fThirdPriceDEC,fFourthPriceDEC,fFifthPriceDEC,fSixthPriceDEC,fSeventhPriceDEC,fEighthPriceDEC),
	fEighthComparison = [dbo].[replaceEmptyPrice](CONCAT(IsNull(CAST( ((fEighthPriceDEC-fScanTotalPriceDEC)/fScanTotalPriceDEC*100) as decimal(18,2)),0),'%')),
	fEighthClass = [dbo].[getClassName](8, fScanTotalPriceDEC, fSecondPriceDEC, fThirdPriceDEC,fFourthPriceDEC,fFifthPriceDEC,fSixthPriceDEC,fSeventhPriceDEC,fEighthPriceDEC)

UPDATE #tTempFinal
SET fScanCurrency = COALESCE(NULLIF(fScanCurrency,''), 'N/A'),
	fScanTotalPrice = CONCAT('$', (IsNull(fScanTotalPriceDEC, 0)))	,
	fScanOriginalPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fScanOriginalPriceDEC, 0)))),
	fSecondPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fSecondPriceDEC, 0)))),
	fSecondOriginalPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fSecondOriginalPriceDEC, 0)))),
	fThirdPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fThirdPriceDEC, 0)))),
	fThirdOriginalPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fThirdOriginalPriceDEC, 0)))),
	fFourthPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fFourthPriceDEC, 0)))),
	fFourthOriginalPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fFourthOriginalPriceDEC, 0)))),
	fFifthPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fFifthPriceDEC, 0)))),
	fFifthOriginalPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fFifthOriginalPriceDEC, 0)))),
	fSixthPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fSixthPriceDEC, 0)))),
	fSixthOriginalPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fSixthOriginalPriceDEC, 0)))),
	fSeventhPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fSeventhPriceDEC, 0)))),
	fSeventhOriginalPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fSeventhOriginalPriceDEC, 0)))),
	fEighthPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fEighthPriceDEC, 0)))),
	fEighthOriginalPrice = [dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(fEighthOriginalPriceDEC, 0))))



---------------------------------------------------------------



SELECT t.fScanID
		  ,fCountryName 
		  ,fLinkURL 
		  ,fLocationCombination 
		  ,fVehicleName 
		  ,fTravelDates 
		  ,fMainClass 
		  ,fScanCurrency 
		  ,fScanTotalPrice 
		  ,fScanOriginalPrice  
		  ,fScanOriginalModifiers 
		  ,fSecondPrice 
		  ,fSecondOriginalPrice 
		  ,fSecondComparison 
		  ,fSecondClass 
		  ,fSecondCurrency 
		  ,fSecondModifiers 
		  ,fThirdPrice 
		  ,fThirdOriginalPrice 
		  ,fThirdComparison 
		  ,fThirdClass 
		  ,fThirdCurrency 
		  ,fThirdModifiers 
		  ,fFourthPrice 
		  ,fFourthOriginalPrice 
		  ,fFourthComparison 
		  ,fFourthClass 
		  ,fFourthCurrency 
		  ,fFourthModifiers 
		  ,fFifthPrice 
		  ,fFifthOriginalPrice 
		  ,fFifthComparison 
		  ,fFifthClass 
		  ,fFifthCurrency 
		  ,fFifthModifiers 
		  ,fSixthPrice 
		  ,fSixthOriginalPrice  
		  ,fSixthComparison 
		  ,fSixthClass 
		  ,fSixthCurrency 
		  ,fSixthModifiers 
		  ,fSeventhPrice 
		  ,fSeventhOriginalPrice 
		  ,fSeventhComparison 
		  ,fSeventhClass 
		  ,fSeventhCurrency 
		  ,fSeventhModifiers 
		  ,fEighthPrice 
		  ,fEighthOriginalPrice 
		  ,fEighthComparison 
		  ,fEighthClass 
		  ,fEighthCurrency 
		  ,fEighthModifiers  
		,@firstURLName																															as fMainWebsite	
		,@secondURLName																															as fSecondWebsite
		,@thirdURLName																															as fThirdWebsite
		,@fourthURLName																															as fFourthWebsite
		,@fifthURLName																															as fFifthWebsite
		,@sixthURLName																															as fSixthWebsite
		,@seventhURLName																														as fSeventhWebsite
		,@eighthURLName																															as fEighthWebsite
FROM #tTempFinal as t
		
ORDER BY fCountryName
      ,fLocationCombination
      ,fVehicleName
      ,cast(left(fTravelDates,9) as date)

DELETE FROM #tTempFinal


END




GO
/****** Object:  StoredProcedure [dbo].[getScanDataCleanByFiltersVehicleCompare]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <17/03/15>
-- Description:	<Get data from clean data table>
-- =============================================
CREATE PROCEDURE [dbo].[getScanDataCleanByFiltersVehicleCompare]
  @DataSetDateStart nvarchar(MAX)
, @TravelDateRanges nvarchar(MAX)
, @CountryID int
, @BrandID int
, @PickupReturnLocationComboID nvarchar(max) 
, @VehicleID nvarchar(max)
, @VehicleTypeID int
, @VehicleBerthID int
, @LicenceCountryID int
, @ScanURLs nvarchar(max) 
, @PriceExceptions int

AS
BEGIN	

	DECLARE 
	 @DataSetDateStartSDT smalldatetime
	,@URLcount int
	,@firstDataSet int

	
	--get urls in order
	DECLARE @URLtable TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fURL int)
	DECLARE @urlList nvarchar(max)
	--SELECT @urlList =  COALESCE(@urlList+';' ,'') + fid FROM tRefWebsite
	SELECT @urlList = COALESCE ( COALESCE(@urlList+';','') + CAST(Fid AS NVARCHAR(20)), @urlList) FROM tRefWebsite
	--SELECT @urlList
	
	--percent or price option
	DECLARE @showPercentorPrice int
	SET @showPercentorPrice =1

	SET @ScanURLs = concat(@ScanURLs,';')

	SET @ScanURLs = 
		CASE 
			WHEN @ScanURLs = '0;'
			THEN @urlList
			WHEN @ScanURLs LIKE '0%'
			THEN REPLACE(@ScanURLs,'0;','')
			ELSE @ScanURLs
		END 

	WHILE CHARINDEX(';', @ScanURLs) > 0 
	BEGIN
		DECLARE @tmpstr VARCHAR(50)
		 SET @tmpstr = SUBSTRING(@ScanURLs, 1, ( CHARINDEX(';', @ScanURLs) - 1 ))

		INSERT INTO @URLtable (fURL)
		VALUES  (@tmpstr)   
		SET @ScanURLs = SUBSTRING(@ScanURLs, CHARINDEX(';', @ScanURLs) + 1, LEN(@ScanURLs))
	END
	SET @URLcount = (select count(furl) from @URLtable)

	
	--get URL variables
	DECLARE @url1 int, @url2 int, @url3 int, @url4 int, @url5 int, @url6 int, @url7 int, @url8 int
	SET @url1 = IsNull((SELECT fURL FROM @URLtable WHERE fID = 1),0) 
	SET @url2 = IsNull((SELECT fURL FROM @URLtable WHERE fID = 2),0) 
	SET @url3 = IsNull((SELECT fURL FROM @URLtable WHERE fID = 3),0) 
	SET @url4 = IsNull((SELECT fURL FROM @URLtable WHERE fID = 4),0) 
	SET @url5 = IsNull((SELECT fURL FROM @URLtable WHERE fID = 5),0) 
	SET @url6 = IsNull((SELECT fURL FROM @URLtable WHERE fID = 6),0) 
	SET @url7 = IsNull((SELECT fURL FROM @URLtable WHERE fID = 7),0) 
	SET @url8 = IsNull((SELECT fURL FROM @URLtable WHERE fID = 8),0) 

--SELECT * FROM @URLtable
	
	--get vehicles in input string
	DECLARE @Vehicletable TABLE (fVehicleID int)
	SET @VehicleID = concat(@VehicleID,';')
	WHILE CHARINDEX(';', @VehicleID) > 0 
	BEGIN
		DECLARE @tmpstrV VARCHAR(50)
		 SET @tmpstrV = SUBSTRING(@VehicleID, 1, ( CHARINDEX(';', @VehicleID) - 1 ))

		INSERT INTO @Vehicletable (fVehicleID)
		VALUES  (@tmpstrV)   
		SET @VehicleID = SUBSTRING(@VehicleID, CHARINDEX(';', @VehicleID) + 1, LEN(@VehicleID))
	END
	-- add vehicles that are 'equivalents' on vehicles in input string
	INSERT INTO @Vehicletable (fVehicleID)
	SELECT fVehicleTwoID fROM tRefVehicleEquivalent WHERE fVehicleOneID in (SELECT fVehicleID FROM @Vehicletable)

	DECLARE @VehicletableEquiv TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fVehicleOneID int, fVehicleTwoID int)
	INSERT INTO @VehicletableEquiv (fVehicleOneID, fVehicleTwoID)
		SELECT fVehicleOneID, fVehicleTwoID FROM tRefVehicleEquivalent where fActive > 0
	INSERT INTO @VehicletableEquiv (fVehicleOneID, fVehicleTwoID)
		SELECT distinct(fVehicleOneID), fVehicleOneID FROM tRefVehicleEquivalent  where fActive > 0
	
	DELETE FROM @VehicletableEquiv
	WHERE fID not in (SELECT distinct fID FROM (SELECT min(fID) as fID FROM @VehicletableEquiv GROUP BY fVehicleOneID, fVehicleTwoID) as f)

--SELECT * FROM @VehicletableEquiv

	--get wk beginning date of selected data set
	SET @DataSetDateStartSDT = 
	CASE 
		WHEN  (@DataSetDateStart = 'NULL' OR @DataSetDateStart is Null)
			THEN CONVERT(SMALLDATETIME, '2000-01-01 00:00:01')
		ELSE
			CONVERT(SMALLDATETIME, @DataSetDateStart)
	END
	
	--create list of location combinations
	DECLARE @locationCombinationsTAB TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fPickupLocationID int, fReturnLocationID int)
	INSERT INTO @locationCombinationsTAB (fPickupLocationID, fReturnLocationID)
	SELECT substring(string,1,charindex('-',string)-1), reverse(substring(reverse(string),0,charindex('-',reverse(string)))) 
	FROM (SELECT Split.a.value('.', 'VARCHAR(100)') AS String from (SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](@PickupReturnLocationComboID), ';', '</M><M>') + '</M>' AS XML) AS String ) AS a CROSS APPLY String.nodes ('/M') AS Split(a)) as t
	
	--get country this report is for
	DECLARE @locCountryID int
	SET @locCountryID =
		CASE
			WHEN @countryID = 0
			THEN (select fCountryID from tRefLocation WHERE fID = (SELECT top 1 fPickupLocationID from @locationCombinationsTAB))
			ELSE @locCountryID
		END
	--add combinations where "all return locations" was selected for a specific pickup location
	INSERT INTO @locationCombinationsTAB (fPickupLocationID, fReturnLocationID)
	SELECT t.fPickupLocationID, tR.fID FROM @locationCombinationsTAB t
	CROSS JOIN (SELECT fID from tRefLocation WHERE fCountryID = @countryID) tR	
	WHERE fReturnLocationID = 0
	--add combinations where "all pickup locations" was selected for a specific return location
	INSERT INTO @locationCombinationsTAB (fPickupLocationID, fReturnLocationID)
	SELECT tP.fID, tR.fReturnLocationID FROM (SELECT fID from tRefLocation WHERE fCountryID = @countryID) tP
	CROSS JOIN (SELECT fReturnLocationID FROM @locationCombinationsTAB WHERE fPickupLocationID = 0) tR
	--remove unnecessary lines
	DELETE FROM @locationCombinationsTAB
	WHERE fPickupLocationID = 0 or fReturnLocationID = 0

--sELECT * FROM @locationCombinationsTAB

	--create list of travel date ranges
	DECLARE @travelDatesFilterTAB TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fPickupDate smalldatetime, fReturnDate smalldatetime, fTravelDates nvarchar(max), fActive int)
	INSERT INTO @travelDatesFilterTAB (fPickupDate, fReturnDate, fActive)
	SELECT substring(string,1,charindex(',',string)-1), reverse(substring(reverse(string),0,charindex(',',reverse(string)))) , 1
	FROM (SELECT Split.a.value('.', 'VARCHAR(100)') AS String from (SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](@TravelDateRanges), ';', '</M><M>') + '</M>' AS XML) AS String ) AS a CROSS APPLY String.nodes ('/M') AS Split(a)) as t
			
    -- temp table of dates in this report
	DECLARE @tDates TABLE (fldID int IDENTITY(1,1) PRIMARY KEY, fScanPickupDate smalldatetime, fScanReturnDate smalldatetime, fTravelDates nvarchar(max), fActive int)
	INSERT INTO @tDates (fScanPickupDate, fScanReturnDate, fTravelDates, fActive)
	SELECT 	fScanPickupDate, fScanReturnDate, (CONCAT( CONVERT(VARCHAR(11),fScanPickupDate,6) , ' - ' , CONVERT(VARCHAR(11),fScanReturnDate,6))) As fTravelDates	, 1
	FROM (
		SELECT DISTINCT fScanPickupDate as fScanPickupDate,  fScanReturnDate as fScanReturnDate
		FROM tDataScanClean
		WHERE (fScanDate >=  dateadd(day,-1,@DataSetDateStartSDT)) and (fScanDate <=  dateadd(day, 6,@DataSetDateStartSDT) )	
	) as tMain
	ORDER BY fScanPickupDate ASC
	
	DELETE FROM @travelDatesFilterTAB WHERE NOT concat(fPickupDate,',',fReturnDate) in (SELECT concat(fScanPickupDate,',',fScanReturnDate) FROM @tDates)

	UPDATE @travelDatesFilterTAB
	SET fTravelDates = (CONCAT( CONVERT(VARCHAR(11),fPickupDate,6) , ' - ' , CONVERT(VARCHAR(11),fPickupDate,6)))
		
--SELECT * FROM @travelDatesFilterTAB

	-- Get list of data sets	
	DECLARE @tDataSets TABLE (fldID int IDENTITY(1,1) PRIMARY KEY, fScanDate smalldatetime, fYear nvarchar(50))	
    -- Insert into temp table 
	INSERT INTO @tDataSets (fScanDate, fYear)
	exec getFinancialYearListWeeksAndDates	
	--remove old dates
	DELETE FROM @tDataSets WHERE fScanDate  <= (SELECT TOP 1 fFirstDate FROM tRefFirstDate)
	DELETE FROM @tDataSets WHERE fScanDate  > @DataSetDateStartSDT

--SELECT * FROM @tDataSets

	--get table of acceptable licence country codes
	DECLARE @tLicenceCountryCode TABLE (fldID int IDENTITY(1,1) PRIMARY KEY, NatOrInternational int, LicenceCounrtyID int, websiteID int, travelCountry int)
	INSERT INTO @tLicenceCountryCode(NatOrInternational, LicenceCounrtyID, websiteID, travelCountry)
	SELECT 1, [fDomLicenceCountryID], [fWebsiteID], [fTravelCountryID]
	FROM [comparison].[dbo].[tRefDriversLicenceCodes]  
	INSERT INTO @tLicenceCountryCode(NatOrInternational, LicenceCounrtyID, websiteID, travelCountry)
	SELECT 2, [fIntLicenceCountryID], [fWebsiteID], [fTravelCountryID]
	FROM [comparison].[dbo].[tRefDriversLicenceCodes]  					
	DELETE FROM @tLicenceCountryCode WHERE Not @LicenceCountryID = NatOrInternational
	

	-- Set the most recent data set to be included
	SET @firstDataSet = (SELECT min(fldID) FROM @tDataSets)
	
	--get required data set into temp table
	IF OBJECT_ID('tempdb..#tTempTable') IS NOT NULL
	/*Then it exists*/
	DROP TABLE #tTempTable
	--get required data set into temp table
	CREATE TABLE  #tTempTable  (
		fScanID int
		,fScanDate smalldatetime
		,fScanURL int
		,fScanTravelCountryID int
		,fScanPickupLocationID int
		,fScanReturnLocationID int
		,fScanPickupDate smalldatetime
		,fScanReturnDate smalldatetime
		,fScanLicenceCountryID int
		,fScanBrandID int
		,fScanVehicleID int
		,fScanVehicleIDCompTo int
		,fScanTotalPrice decimal(18,2)
		,fScanOriginalPrice decimal(18,2)
		,fScanCurrencyID int
		,fScanCurrencyCode nvarchar(3)
	)
	
	-- main data
	INSERT INTO #tTempTable
	SELECT	
		MIN(tTemp.fScanID) as fScanID
		,[dbo].[getFirstDayOfWeek](tTemp.fScanDate)
		,tTemp.[fScanURL]
		,tTemp.[fScanTravelCountryID]
		,tTemp.[fScanPickupLocationID]
		,tTemp.[fScanReturnLocationID]
		,tTemp.[fScanPickupDate]
		,tTemp.[fScanReturnDate]
		,tTemp.[fScanLicenceCountryID]
		,tTemp.[fScanBrandID]
		,tVE.fVehicleTwoID
		,min(tVE.fVehicleOneID)
		,[dbo].[convertPriceToCurrency](tTemp.fScanTotalPrice, tTemp.fScanCurrencyID, tTemp.fScanDate, tTemp.fScanTravelCountryID) as fScanTotalPrice
		,min(tTemp.fScanTotalPrice)
		,tTemp.[fScanCurrencyID]	
		,tC.fCurrencyCode	
	from tDataScanClean as tTemp
	INNER JOIN @locationCombinationsTAB as tL on tL.fPickupLocationID = tTemp.[fScanPickupLocationID] AND  tL.fReturnLocationID = tTemp.[fScanReturnLocationID]
	INNER JOIN @VehicletableEquiv as tVE on tVE.fVehicleTwoID = tTemp.fScanVehicleID 
	INNER JOIN @travelDatesFilterTAB as tDates on (tDates.fPickupDate = tTemp.[fScanPickupDate] AND tDates.fReturnDate = tTemp.[fScanReturnDate])
	INNER JOIN @tLicenceCountryCode as tLC on tTemp.fScanLicenceCountryID = tLC.LicenceCounrtyID AND tTemp.[fScanTravelCountryID] = travelCountry AND tTemp.[fScanURL] = tLC.websiteID	
	INNER JOIN tRefCurrency as tC on tC.fID = tTemp.fScanCurrencyID
	WHERE 
		(tTemp.fScanDate >= @DataSetDateStartSDT AND tTemp.fScanDate <= DATEADD(day,7,@DataSetDateStartSDT) OR @DataSetDateStart = 'NULL' OR @DataSetDateStart is Null )
		AND (fScanURL in (SELECT fURL FROM @URLtable))
		AND ((tTemp.fScanBrandID = @BrandID OR tTemp.fScanVehicleID in (SELECT fVehicleTwoID FROM tRefVehicleEquivalent)) OR @BrandID = 0)
		AND (tTemp.fScanTravelCountryID = @CountryID OR @CountryID = 0)
		AND (tTemp.fScanVehicleID in (select fVehicleID from @Vehicletable))
	GROUP BY tTemp.[fScanDate]
		,tTemp.[fScanURL]
		,tTemp.[fScanTravelCountryID]
		,tTemp.[fScanPickupLocationID]
		,tTemp.[fScanReturnLocationID]
		,tTemp.[fScanPickupDate] 
		,tTemp.[fScanReturnDate] 
		,tTemp.[fScanLicenceCountryID]
		,tTemp.[fScanBrandID]
		,tTemp.[fScanVehicleID]
		,tVE.fVehicleTwoID
		,tTemp.[fScanTotalPrice]
		,tTemp.[fScanCurrencyID]
		,tC.fCurrencyCode		  
	  	  

	-- drop unneeded data
	DELETE FROM @locationCombinationsTAB
	 

	--get required data set into temp table
	IF OBJECT_ID('tempdb..#tTempTableLarge') IS NOT NULL
	/*Then it exists*/
	DROP TABLE #tTempTableLarge
	--get required data set into temp table
	CREATE TABLE #tTempTableLarge  (
		fID int IDENTITY(1,1) PRIMARY KEY
		,fScanID int
		,fScanDate date
		,fTravelCountryID int
		,fCountryName nvarchar(200)
		,fPickupLocationID int
		,fReturnLocationID int
		,fVehicleCompareID int
		,fVehicleID int
		,fBrandID int
		,fPickupDate date
		,fReturnDate date
		,fLinkURL nvarchar(max) 
		,fLocationCombination nvarchar(200)
		,fVehicleCompareName nvarchar(200)
		,fVehicleName nvarchar(200)
		,fTravelDates nvarchar(200)
		,fMainWebsite int
		,fScanTotalPrice decimal(18,2)
		,fFirstComparison decimal (18,2)
		,fScanOriginalPrice decimal(18,2)
		,fScanModifiers nvarchar(max)
		,fScanCurrency nvarchar(3)
		,fScanClass nvarchar(200)
		,fSecondWebsite int
		,fSecondPrice decimal(18,2)
		,fSecondComparison decimal (18,2)
		,fSecondOriginalPrice decimal(18,2)
		,fSecondModifiers nvarchar(max)
		,fSecondCurrency nvarchar(3)
		,fSecondClass nvarchar(200)
		,fThirdWebsite int
		,fThirdPrice decimal(18,2)
		,fThirdComparison decimal (18,2)	
		,fThirdOriginalPrice decimal(18,2)
		,fThirdModifiers nvarchar(max)
		,fThirdCurrency nvarchar(3)
		,fThirdClass nvarchar(200)
		,fFourthWebsite int
		,fFourthPrice decimal(18,2)
		,fFourthComparison decimal (18,2)
		,fFourthOriginalPrice decimal(18,2)
		,fFourthModifiers nvarchar(max)
		,fFourthCurrency nvarchar(3)
		,fFourthClass nvarchar(200)
		,fFifthWebsite int
		,fFifthPrice decimal(18,2)
		,fFifthComparison decimal (18,2)
		,fFifthOriginalPrice decimal(18,2)
		,fFifthModifiers nvarchar(max)
		,fFifthCurrency nvarchar(3)
		,fFifthClass nvarchar(200)
		,fSixthWebsite int
		,fSixthPrice decimal(18,2)
		,fSixthComparison decimal (18,2)
		,fSixthOriginalPrice decimal(18,2)
		,fSixthModifiers nvarchar(max)
		,fSixthCurrency nvarchar(3)
		,fSixthClass nvarchar(200)
		,fSeventhWebsite int
		,fSeventhPrice decimal(18,2)
		,fSeventhComparison decimal (18,2)
		,fSeventhOriginalPrice decimal(18,2)
		,fSeventhModifiers nvarchar(max)
		,fSeventhCurrency nvarchar(3)
		,fSeventhClass nvarchar(200)
		,fEighthWebsite int
		,fEighthPrice decimal(18,2)
		,fEighthComparison decimal (18,2)
		,fEighthOriginalPrice decimal(18,2)
		,fEighthModifiers nvarchar(max)
		,fEighthCurrency nvarchar(3)
		,fEighthClass nvarchar(200)
	)

		
	--compared to vehicles
	INSERT INTO #tTempTableLarge (fScanID, fScanDate, fTravelCountryID, fPickupLocationID,fReturnLocationID ,fVehicleCompareID,fVehicleID ,fBrandID ,fPickupDate ,fReturnDate,
									fMainWebsite, fScanTotalPrice, fScanOriginalPrice, fScanModifiers, fScanCurrency,
									fSecondWebsite, fSecondPrice, fSecondOriginalPrice, fSecondModifiers, fSecondCurrency,
									fThirdWebsite, fThirdPrice, fThirdOriginalPrice, fThirdModifiers, fThirdCurrency,
									fFourthWebsite, fFourthPrice,  fFourthOriginalPrice, fFourthModifiers, fFourthCurrency,
									fFifthWebsite, fFifthPrice,  fFifthOriginalPrice, fFifthModifiers, fFifthCurrency,
									fSixthWebsite, fSixthPrice,  fSixthOriginalPrice, fSixthModifiers, fSixthCurrency,
									fSeventhWebsite, fSeventhPrice, fSeventhOriginalPrice, fSeventhModifiers, fSeventhCurrency,  
									fEighthWebsite, fEighthPrice, fEighthOriginalPrice, fEighthModifiers, fEighthCurrency
									)
	SELECT 
		  min(tMain.fScanID)
		,tMain.fScanDate
		,tMain.fScanTravelCountryID
		,tMain.fScanPickupLocationID
		,tMain.fScanReturnLocationID
		,tMain.fScanVehicleIDCompTo
		,tMain.fScanVehicleID
		,tMain.fScanBrandID
		,tMain.fScanPickupDate
		,tMain.fScanReturnDate
		, @url1 
		, t1.fFirstPrice  
		, t1.fFirstOriginalPrice
		, t1.fFirstModifiers 
		, t1.fScanCurrencyCode   
		, @url2
		, t2.fSecondPrice  	 
		, t2.fSecondOriginalPrice
		, t2.fSecondModifiers 
		, t2.fScanCurrencyCode   
		, @url3
		, t3.fThirdPrice  	
		, t3.fThirdOriginalPrice
		, t3.fThirdModifiers  
		, t3.fScanCurrencyCode  
		, @url4
		, t4.fFourthPrice  	
		, t4.fFourthOriginalPrice
		, t4.fFourthModifiers  
		, t4.fScanCurrencyCode   
		, @url5 
		, t5.fFifthPrice  	
		, t5.fFifthOriginalPrice
		, t5.fFifthModifiers
		, t5.fScanCurrencyCode   
		, @url6
		, t6.fSixthPrice  	
		, t6.fSixthOriginalPrice
		, t6.fSixthModifiers 
		, t6.fScanCurrencyCode   
		, @url7
		, t7.fSeventhPrice 	 
		, t7.fSeventhOriginalPrice
		, t7.fSeventhModifiers
		, t7.fScanCurrencyCode  
		, @url8 
		, t8.fEighthPrice 	
		, t8.fEighthOriginalPrice
		, t8.fEighthModifiers
		, t8.fScanCurrencyCode 
	FROM(	  
			SELECT 
				  min(fScanID) as fScanID
				, fScanDate
				, fScanTravelCountryID
				, fScanPickupLocationID
				, fScanReturnLocationID
				, fScanPickupDate
				, fScanReturnDate
				, fScanVehicleID
				, fScanVehicleIDCompTo
				, fScanBrandID 
			from (
					SELECT  min (tTable.fScanID) as fScanID	
					, fScanDate
					, min (tTable.fScanURL) as 	fScanURL
					, tTable.fScanTravelCountryID
					, tTable.fScanPickupLocationID
					, tTable.fScanReturnLocationID
					, tTable.fScanPickupDate 
					, tTable.fScanReturnDate
					, tTable.fScanVehicleIDCompTo
					, tTable.fScanBrandID
					, tTable.fScanVehicleID
					, min (tTable.fScanLicenceCountryID) as 	fScanLicenceCountryID
					from #tTempTable as tTable				
					GROUP BY tTable.fScanTravelCountryID
					, fScanDate
					, tTable.fScanTravelCountryID
					, tTable.fScanPickupLocationID
					, tTable.fScanReturnLocationID
					, tTable.fScanPickupDate 
					, tTable.fScanReturnDate 
					, tTable.fScanVehicleIDCompTo
					, tTable.fScanBrandID
					, tTable.fScanVehicleID	
			) as tMin					  

			GROUP BY  fScanTravelCountryID
					, fScanDate
				, fScanPickupLocationID
				, fScanReturnLocationID
				, fScanPickupDate
				, fScanReturnDate
				, fScanVehicleID
				, fScanVehicleIDCompTo
				,fScanBrandID

		) as tMain
		
		INNER JOIN tRefVehicle as tVCT on tVCT.fID =	tMain.fScanVehicleIDCompTo
		INNER JOIN tRefBrand as tVCTBrand on tVCTBrand.fID =	tVCT.fVehicleBrandID
		INNER JOIN tDataScanClean as tData2 on tData2.fScanID =	tMain.fScanID

		LEFT JOIN (	SELECT     fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,min([dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fFirstPrice
							  ,max([dbo].[getListPriceExceptionsAsString](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fFirstModifiers
							  ,fScanOriginalPrice as fFirstOriginalPrice
							  ,fScanCurrencyID as fFirstCurrencyID 
							  ,fScanCurrencyCode 
						FROM #tTempTable 					
						WHERE (fScanURL = @url1)
						group by fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,fScanOriginalPrice						  
							  ,fScanCurrencyID 
							  ,fScanCurrencyCode 
					 ) as t1 on t1.fScanPickupDate = tMain.fScanPickupDate 
					 AND t1.[fScanVehicleID] = tMain.[fScanVehicleID]
					 AND t1.fScanVehicleIDCompTo = tMain.[fScanVehicleIDCompTo]
					 AND t1.fScanTravelCountryID = tMain.fScanTravelCountryID
					 AND t1.fScanPickupLocationID = tMain.fScanPickupLocationID
					 AND t1.fScanReturnLocationID = tMain.fScanReturnLocationID
					 					 
		LEFT JOIN (	SELECT fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,min([dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fSecondPrice
							  ,max([dbo].[getListPriceExceptionsAsString](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fSecondModifiers
							  ,fScanOriginalPrice as fSecondOriginalPrice
							  ,fScanCurrencyID as fSecondCurrencyID 
							  ,fScanCurrencyCode 
						FROM #tTempTable 					
						WHERE (fScanURL = @url2)
						group by fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,fScanOriginalPrice				  
							  ,fScanCurrencyID 
							  ,fScanCurrencyCode 
					 ) as t2 on t2.fScanPickupDate = tMain.fScanPickupDate
					 AND t2.[fScanVehicleID] = tMain.[fScanVehicleID]
					 AND t2.fScanVehicleIDCompTo = tMain.[fScanVehicleIDCompTo]
					 AND t2.fScanTravelCountryID = tMain.fScanTravelCountryID
					 AND t2.fScanPickupLocationID = tMain.fScanPickupLocationID
					 AND t2.fScanReturnLocationID = tMain.fScanReturnLocationID

		LEFT JOIN (	SELECT fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,min([dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fThirdPrice
							  ,max([dbo].[getListPriceExceptionsAsString](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fThirdModifiers
							  ,fScanOriginalPrice as fThirdOriginalPrice
							  ,fScanCurrencyID as fThirdCurrencyID 
							  ,fScanCurrencyCode 
						FROM #tTempTable 					
						WHERE (fScanURL = @url3)
						group by fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo	
							  ,fScanOriginalPrice			  
							  ,fScanCurrencyID 
							  ,fScanCurrencyCode 
					 ) as t3 on t3.fScanPickupDate = tMain.fScanPickupDate 
					 AND t3.[fScanVehicleID] = tMain.[fScanVehicleID]
					 AND t3.fScanVehicleIDCompTo = tMain.[fScanVehicleIDCompTo]
					 AND t3.fScanTravelCountryID = tMain.fScanTravelCountryID
					 AND t3.fScanPickupLocationID = tMain.fScanPickupLocationID
					 AND t3.fScanReturnLocationID = tMain.fScanReturnLocationID

		LEFT JOIN (	SELECT fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,min([dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fFourthPrice
							  ,max([dbo].[getListPriceExceptionsAsString](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fFourthModifiers
							  ,fScanOriginalPrice as fFourthOriginalPrice
							  ,fScanCurrencyID as fFourthCurrencyID 
							  ,fScanCurrencyCode 
						FROM #tTempTable 					
						WHERE (fScanURL = @url4)
						group by fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,fScanOriginalPrice			  
							  ,fScanCurrencyID 
							  ,fScanCurrencyCode 
					 ) as t4 on t4.fScanPickupDate = tMain.fScanPickupDate 
					 AND t4.[fScanVehicleID] = tMain.[fScanVehicleID]
					 AND t4.fScanVehicleIDCompTo = tMain.[fScanVehicleIDCompTo]
					 AND t4.fScanTravelCountryID = tMain.fScanTravelCountryID
					 AND t4.fScanPickupLocationID = tMain.fScanPickupLocationID
					 AND t4.fScanReturnLocationID = tMain.fScanReturnLocationID

		LEFT JOIN (	SELECT fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,fScanURL as fFifthURL
							  ,min([dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fFifthPrice
							  ,max([dbo].[getListPriceExceptionsAsString](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fFifthModifiers
							  ,fScanOriginalPrice as fFifthOriginalPrice
							  ,fScanCurrencyID as fFifthCurrencyID 
							  ,fScanCurrencyCode 
						FROM #tTempTable 					
						WHERE (fScanURL = @url5)
						group by fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,fScanURL 			
							  ,fScanOriginalPrice			  
							  ,fScanCurrencyID 
							  ,fScanCurrencyCode 
					 ) as t5 on t5.fScanPickupDate = tMain.fScanPickupDate
					 AND t5.[fScanVehicleID] = tMain.[fScanVehicleID]
					 AND t5.fScanVehicleIDCompTo = tMain.[fScanVehicleIDCompTo]
					 AND t5.fScanTravelCountryID = tMain.fScanTravelCountryID
					 AND t5.fScanPickupLocationID = tMain.fScanPickupLocationID
					 AND t5.fScanReturnLocationID = tMain.fScanReturnLocationID
					 
		LEFT JOIN (	SELECT fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,min([dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fSixthPrice
							  ,max([dbo].[getListPriceExceptionsAsString](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fSixthModifiers
							  ,fScanOriginalPrice as fSixthOriginalPrice
							  ,fScanCurrencyID as fSixthCurrencyID 
							  ,fScanCurrencyCode 
						FROM #tTempTable 					
						WHERE (fScanURL = @url6)
						group by fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,fScanOriginalPrice			  
							  ,fScanCurrencyID 
							  ,fScanCurrencyCode 
					 ) as t6 on t6.fScanPickupDate = tMain.fScanPickupDate
					 AND t6.[fScanVehicleID] = tMain.[fScanVehicleID]
					 AND t6.fScanVehicleIDCompTo = tMain.[fScanVehicleIDCompTo]
					 AND t6.fScanTravelCountryID = tMain.fScanTravelCountryID
					 AND t6.fScanPickupLocationID = tMain.fScanPickupLocationID
					 AND t6.fScanReturnLocationID = tMain.fScanReturnLocationID
					 
					 
		LEFT JOIN (	SELECT fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,min([dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fSeventhPrice
							  ,max([dbo].[getListPriceExceptionsAsString](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fSeventhModifiers
							  ,fScanOriginalPrice as fSeventhOriginalPrice
							  ,fScanCurrencyID as fSeventhCurrencyID 
							  ,fScanCurrencyCode 
						FROM #tTempTable 					
						WHERE (fScanURL = @url7)
						group by fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,fScanOriginalPrice				  
							  ,fScanCurrencyID 
							  ,fScanCurrencyCode 
					 ) as t7 on t7.fScanPickupDate = tMain.fScanPickupDate
					 AND t7.[fScanVehicleID] = tMain.[fScanVehicleID]
					 AND t7.fScanVehicleIDCompTo = tMain.[fScanVehicleIDCompTo]
					 AND t7.fScanTravelCountryID = tMain.fScanTravelCountryID
					 AND t7.fScanPickupLocationID = tMain.fScanPickupLocationID
					 AND t7.fScanReturnLocationID = tMain.fScanReturnLocationID
					 
		LEFT JOIN (	SELECT fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,min([dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fEighthPrice
							  ,max([dbo].[getListPriceExceptionsAsString](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fEighthModifiers
							  ,fScanOriginalPrice as fEighthOriginalPrice
							  ,fScanCurrencyID as fEighthCurrencyID 
							  ,fScanCurrencyCode 
						FROM #tTempTable 					
						WHERE (fScanURL = @url8)
						group by fScanDate
							  ,fScanTravelCountryID
							  ,fScanPickupLocationID
							  ,fScanReturnLocationID
							  ,fScanPickupDate
							  ,fScanLicenceCountryID
							  ,fScanVehicleID
							  ,fScanVehicleIDCompTo
							  ,fScanOriginalPrice	  
							  ,fScanCurrencyID 
							  ,fScanCurrencyCode 
					 ) as t8 on t8.fScanPickupDate = tMain.fScanPickupDate
					 AND t8.[fScanVehicleID] = tMain.[fScanVehicleID]
					 AND t8.fScanVehicleIDCompTo = tMain.[fScanVehicleIDCompTo]
					 AND t8.fScanTravelCountryID = tMain.fScanTravelCountryID
					 AND t8.fScanPickupLocationID = tMain.fScanPickupLocationID
					 AND t8.fScanReturnLocationID = tMain.fScanReturnLocationID
					 
	GROUP By tMain.fScanID
		,tMain.fScanDate
		,tMain.fScanTravelCountryID
		,tMain.fScanPickupLocationID
		,tMain.fScanReturnLocationID
		,tMain.fScanVehicleIDCompTo
		,tMain.fScanVehicleID
		,tMain.fScanBrandID
		,tMain.fScanPickupDate
		,tMain.fScanReturnDate
		,t1.fFirstPrice
		,t1.fFirstOriginalPrice
		,t1.fFirstModifiers
		, t1.fScanCurrencyCode 
		, t2.fSecondPrice  	 
		, t2.fSecondOriginalPrice
		, t2.fSecondModifiers 
		, t2.fScanCurrencyCode 
		, t3.fThirdPrice  	
		, t3.fThirdOriginalPrice
		, t3.fThirdModifiers  
		, t3.fScanCurrencyCode 
		, t4.fFourthPrice  	
		, t4.fFourthOriginalPrice
		, t4.fFourthModifiers  
		, t4.fScanCurrencyCode 
		, t5.fFifthPrice  	
		, t5.fFifthOriginalPrice
		, t5.fFifthModifiers
		, t5.fScanCurrencyCode 
		, t6.fSixthPrice  	
		, t6.fSixthOriginalPrice
		, t6.fSixthModifiers 
		, t6.fScanCurrencyCode 
		, t7.fSeventhPrice 	 
		, t7.fSeventhOriginalPrice
		, t7.fSeventhModifiers
		, t7.fScanCurrencyCode 
		, t8.fEighthPrice 	
		, t8.fEighthOriginalPrice
		, t8.fEighthModifiers
		, t8.fScanCurrencyCode 

	ORDER BY tMain.fScanVehicleIDCompTo

	-- delete first table
	delete from #tTempTable


	-- add in location combinations using location names
	UPDATE #tTempTableLarge 
	SET fLocationCombination = (rPL.fLocationName + ' - ' + rRL.fLocationName) 
	FROM #tTempTableLarge as tD
	INNER JOIN tRefLocation as rPL on rPL.fID = tD.fPickupLocationID
	INNER JOIN tRefLocation as rRL on rRL.fID = tD.fReturnLocationID
	
	-- add in location combinations using location names
	UPDATE #tTempTableLarge 
	SET fTravelDates = CONCAT( CONVERT(VARCHAR(11),fPickupDate,6) , ' - ' , CONVERT(VARCHAR(11),fReturnDate,6) )
	--FROM #tTempTableLarge as tD
	
	-- add in location combinations using location names
	UPDATE #tTempTableLarge 
	SET fCountryName = tC.fCountryName  
	FROM #tTempTableLarge as tD
	INNER JOIN tRefCountry tC on tC.fID = tD.fTravelCountryID
		
	-- add in location combinations using location names
	UPDATE #tTempTableLarge 
	SET fVehicleCompareName = (tBC.fBrandName + ' ' + tVC.fVehicleName),
		fVehicleName = (tB.fBrandName + ' ' + tV.fVehicleName)
	FROM #tTempTableLarge as tD
	INNER JOIN tRefVehicle tV on tV.fID = tD.fVehicleID
	INNER JOIN tRefBrand tB on tB.fID = tV.fVehicleBrandID
	INNER JOIN tRefVehicle tVC on tVC.fID = tD.fVehicleCompareID
	INNER JOIN tRefBrand tBC on tBC.fID = tVC.fVehicleBrandID

	
	--remove tables that are no longer needed
	IF OBJECT_ID('tempdb..#tTempTable') IS NOT NULL
	/*Then it exists*/
    DROP TABLE #tTempTable

	
	DECLARE @sectionList TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fVehicleCompareID int, fPickupDate date, fReturnDate date, fPickupLocation int, fReturnLocation int)
	INSERT INTO @sectionList (fVehicleCompareID, fPickupDate, fReturnDate, fPickupLocation, fReturnLocation)
	SELECT DISTINCT fVehicleCompareID, fPickupDate, fReturnDate, fPickupLocationID, fReturnLocationID
	FROM #tTempTableLarge

	--get percentage comparison against main vehicle in that category/etc combination
	DECLARE @totalCount int, @vehicleCategoryCount int, @thisCount int, @thisComparison1 decimal(18,2), @thisComparison2 decimal(18,2), 
			@comparePrice1 decimal(18,2), @comparePrice2 decimal(18,2), 
			@thisVehicleCompareID int, @thisPickupDate date, @thisReturnDate date, @thisPickupLocation int, @thisReturnLocation int, 
			@prevVehicleCategoryID int, @prevPickupDate date, @prevReturnDate date, @prevPickupLocation int, @prevReturnLocation int, 
			@thisURL int, @thisClass nvarchar(200), @secondClass nvarchar(200),
			@smallestPrice decimal(18,2) 
	SET @totalCount = (SELECT count(fid) FROM @sectionList)
	SET @vehicleCategoryCount = 0
	SET @thisCount = 1
	SET @thisURL = (SELECT fURL from @URLtable WHERE fID = 1)
	
	WHILE @thisCount <= @totalCount
		BEGIN
			--get values for current section
			SET @thisVehicleCompareID = (SELECT fVehicleCompareID FROM @sectionList WHERE fID = @thisCount)
			SET @thisPickupDate = (SELECT fPickupDate FROM @sectionList WHERE fID = @thisCount )
			SET @thisReturnDate = (SELECT fReturnDate FROM @sectionList WHERE fID = @thisCount )
			SET @thisPickupLocation = (SELECT fPickupLocation FROM @sectionList WHERE fID = @thisCount )
			SET @thisReturnLocation = (SELECT fReturnLocation FROM @sectionList WHERE fID = @thisCount )
			--get price of main vehicle for this section
			SET @comparePrice1 = (	SELECT top 1 fScanTotalPrice FROM #tTempTableLarge
								WHERE fVehicleID = @thisVehicleCompareID
								AND fVehicleCompareID = @thisVehicleCompareID
								AND fPickupDate = @thisPickupDate
								AND fReturnDate = @thisReturnDate
								AND fPickupLocationID = @thisPickupLocation
								AND fReturnLocationID = @thisReturnLocation
								ORDER BY fScanTotalPrice asc
							 )
							 			
			--update main table with classes
			UPDATE #tTempTableLarge 
			SET fScanClass = 
				CASE	
					WHEN isnull(fScanTotalPrice,0) = 0			 
						Then ' noPrice'
					WHEN fScanTotalPrice = @comparePrice1 
						THEN ' mainPrice'
					WHEN fScanTotalPrice < @comparePrice1 
						THEN ' smallerPrice'
					WHEN fScanTotalPrice > @comparePrice1
						THEN  ' largerPrice'
					ELSE 'nil'
				END
			,fSecondClass = 
				CASE	
					WHEN fSecondPrice = 0			 
						Then ' noPrice'
					WHEN fSecondPrice = @comparePrice1 
						THEN ' mainPrice'
					WHEN fSecondPrice < @comparePrice1 
						THEN ' smallerPrice'
					WHEN fSecondPrice > @comparePrice1
						THEN  ' largerPrice'
					ELSE ''
				END
			,fThirdClass = 
				CASE	
					WHEN fThirdPrice = 0			 
						Then ' noPrice'
					WHEN fThirdPrice = @comparePrice1 
						THEN ' mainPrice'
					WHEN fThirdPrice < @comparePrice1 
						THEN ' smallerPrice'
					WHEN fThirdPrice > @comparePrice1
						THEN  ' largerPrice'
					ELSE ''
				END
			,fFourthClass = 
				CASE	
					WHEN fFourthPrice = 0			 
						Then ' noPrice'
					WHEN fFourthPrice = @comparePrice1 
						THEN ' mainPrice'
					WHEN fFourthPrice < @comparePrice1 
						THEN ' smallerPrice'
					WHEN fFourthPrice > @comparePrice1
						THEN  ' largerPrice'
					ELSE ''
				END
			,fFifthClass = 
				CASE	
					WHEN fFifthPrice = 0			 
						Then ' noPrice'
					WHEN fFifthPrice = @comparePrice1 
						THEN ' mainPrice'
					WHEN fFifthPrice < @comparePrice1 
						THEN ' smallerPrice'
					WHEN fFifthPrice > @comparePrice1
						THEN  ' largerPrice'
					ELSE ''
				END
			,fSixthClass = 
				CASE	
					WHEN fSixthPrice = 0			 
						Then ' noPrice'
					WHEN fSixthPrice = @comparePrice1 
						THEN ' mainPrice'
					WHEN fSixthPrice < @comparePrice1 
						THEN ' smallerPrice'
					WHEN fSixthPrice > @comparePrice1
						THEN  ' largerPrice'
					ELSE ''
				END
			,fSeventhClass = 
				CASE	
					WHEN fSeventhPrice = 0			 
						Then ' noPrice'
					WHEN fSeventhPrice = @comparePrice1 
						THEN ' mainPrice'
					WHEN fSeventhPrice < @comparePrice1 
						THEN ' smallerPrice'
					WHEN fSeventhPrice > @comparePrice1
						THEN  ' largerPrice'
					ELSE ''
				END
			,fEighthClass = 
				CASE	
					WHEN fEighthPrice = 0			 
						Then ' noPrice'
					WHEN fEighthPrice = @comparePrice1 
						THEN ' mainPrice'
					WHEN fEighthPrice < @comparePrice1 
						THEN ' smallerPrice'
					WHEN fEighthPrice > @comparePrice1
						THEN  ' largerPrice'
					ELSE ''
				END
			WHERE fID in (SELECT fID from #tTempTableLarge WHERE 
								    fPickupDate = @thisPickupDate
								AND fReturnDate = @thisReturnDate
								AND fPickupLocationID = @thisPickupLocation
								AND fReturnLocationID = @thisReturnLocation
								AND fVehicleCompareID = @thisVehicleCompareID)
												
			--update main table with comparison values
			UPDATE #tTempTableLarge 
			SET fFirstComparison = 
				CASE	
					WHEN @showPercentOrPrice = 2 --show price difference
						THEN cast((fScanTotalPrice - @comparePrice1) as decimal(18,2))
					ELSE --show percentage difference
						cast((cast((fScanTotalPrice - @comparePrice1) as decimal(18,2))/@comparePrice1*100) as decimal(18,2))
				END
			, fSecondComparison = 
				CASE	
					WHEN @showPercentorPrice = 2 --show price difference
						THEN cast((fSecondPrice - @comparePrice1) as decimal(18,2))
					ELSE --show percentage difference
						cast((cast((fSecondPrice - @comparePrice1) as decimal(18,2))/@comparePrice1*100) as decimal(18,2))
				END
			, fThirdComparison = 
				CASE	
					WHEN @showPercentorPrice = 2 --show price difference
						THEN cast((fThirdPrice - @comparePrice1) as decimal(18,2))
					ELSE --show percentage difference
						cast((cast((fThirdPrice - @comparePrice1) as decimal(18,2))/@comparePrice1*100) as decimal(18,2))
				END
			, fFourthComparison = 
				CASE	
					WHEN @showPercentorPrice = 2 --show price difference
						THEN cast((fFourthPrice - @comparePrice1) as decimal(18,2))
					ELSE --show percentage difference
						cast((cast((fFourthPrice - @comparePrice1) as decimal(18,2))/@comparePrice1*100) as decimal(18,2))
				END
			, fFifthComparison = 
				CASE	
					WHEN @showPercentorPrice = 2 --show price difference
						THEN cast((fFifthPrice - @comparePrice1) as decimal(18,2))
					ELSE --show percentage difference
						cast((cast((fFifthPrice - @comparePrice1) as decimal(18,2))/@comparePrice1*100) as decimal(18,2))
				END
			, fSixthComparison = 
				CASE	
					WHEN @showPercentorPrice = 2 --show price difference
						THEN cast((fSixthPrice - @comparePrice1) as decimal(18,2))
					ELSE --show percentage difference
						cast((cast((fSixthPrice - @comparePrice1) as decimal(18,2))/@comparePrice1*100) as decimal(18,2))
				END
			, fSeventhComparison = 
				CASE	
					WHEN @showPercentorPrice = 2 --show price difference
						THEN cast((fSeventhPrice - @comparePrice1) as decimal(18,2))
					ELSE --show percentage difference
						cast((cast((fSeventhPrice - @comparePrice1) as decimal(18,2))/@comparePrice1*100) as decimal(18,2))
				END
			, fEighthComparison = 
				CASE	
					WHEN @showPercentorPrice = 2 --show price difference
						THEN cast((fEighthPrice - @comparePrice1) as decimal(18,2))
					ELSE --show percentage difference
						cast((cast((fEighthPrice - @comparePrice1) as decimal(18,2))/@comparePrice1*100) as decimal(18,2))
				END
			WHERE fID in (SELECT fID from #tTempTableLarge WHERE 
								    fPickupDate = @thisPickupDate
								AND fReturnDate = @thisReturnDate
								AND fPickupLocationID = @thisPickupLocation
								AND fReturnLocationID = @thisReturnLocation
								AND fVehicleCompareID = @thisVehicleCompareID)

			
			SET @thisCount = @thisCount + 1
		END


	--final data
	SELECT min(tPrices.[fScanID]) as fScanID
		  ,concat('fW=',(CONVERT(VARCHAR(10),tPrices.fscandate,126)),'&pDate=NULL&tcID=',tPrices.fTravelCountryID,'&bID=',tPrices.fBrandID,'&pID=',
				tPrices.fPickupLocationID,'&rID=',tPrices.fReturnLocationID,'&vID=',tPrices.fVehicleID,'&vtID=',0,'&vbID=',0,'&lcID=',
				@LicenceCountryID,'&wID=',@url1,'&eID=',@PriceExceptions,'&aVC=1') as fLinkURL 
		  ,fCountryName
		  ,fLocationCombination
		  ,fVehicleCompareName
		  ,fVehicleName
		  ,tPrices.fTravelDates
		  , (SELECT fWebsiteName FROM tRefWebsite WHERE fID = (1) ) as fMainWebsite
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull([fScanTotalPrice], 0))))	as fScanTotalPrice
		  ,[dbo].[replaceEmptyPrice](CONCAT(IsNull(tPrices.fFirstComparison,0),'%'))as fMainComparison	
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(tPrices.fScanOriginalPrice, 0)))) as fScanOriginalPrice
		  ,IsNull(tPrices.fScanModifiers,'') as fScanModifiers
		  ,IsNull(tPrices.fScanCurrency,'') as fScanCurrency 
		  ,tPrices.fScanClass as fMainClass
		  , (SELECT [fWebsiteName] FROM tRefWebsite WHERE (IsNull((SELECT top 1 fURL from @URLtable WHERE fID = 2),0) = fID )) as [fSecondWebsite]
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull([fSecondPrice], 0))))	as fSecondPrice
		  ,[dbo].[replaceEmptyPrice](CONCAT(IsNull(tPrices.fSecondComparison,0),'%'))as fSecondComparison
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(tPrices.fSecondOriginalPrice, 0)))) as fSecondOriginalPrice
		  ,IsNull(tPrices.fSecondModifiers,'') as fSecondModifiers
		  ,IsNull(tPrices.fSecondCurrency,'') as fSecondCurrency
		  ,tPrices.fSecondClass
		  , (SELECT [fWebsiteName] FROM tRefWebsite WHERE (IsNull((SELECT top 1 fURL from @URLtable WHERE fID = 3),0) = fID )) as [fThirdWebsite]
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull([fThirdPrice], 0))))	as fThirdPrice
		  ,[dbo].[replaceEmptyPrice](CONCAT(IsNull(tPrices.fThirdComparison,0),'%'))as fThirdComparison
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(tPrices.fThirdOriginalPrice, 0)))) as fThirdOriginalPrice
		  ,IsNull(tPrices.fThirdModifiers,'') as fThirdModifiers
		  ,IsNull(tPrices.fThirdCurrency,'') as fThirdCurrency
		  ,tPrices.fThirdClass
		  ,(SELECT [fWebsiteName] FROM tRefWebsite WHERE (IsNull((SELECT top 1 fURL from @URLtable WHERE fID = 4),0) = fID )) as [fFourthWebsite]
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull([fFourthPrice], 0))))	as fFourthPrice
		  ,[dbo].[replaceEmptyPrice](CONCAT(IsNull(tPrices.fFourthComparison,0),'%'))as fFourthComparison
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(tPrices.fFourthOriginalPrice, 0)))) as fFourthOriginalPrice
		  ,IsNull(tPrices.fFourthModifiers,'') as fFourthModifiers
		  ,IsNull(tPrices.fFourthCurrency,'') as fFourthCurrency
		  ,tPrices.fFourthClass
		  ,(SELECT [fWebsiteName] FROM tRefWebsite WHERE (IsNull((SELECT top 1 fURL from @URLtable WHERE fID = 5),0) = fID )) as [fFifthWebsite]
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull([fFifthPrice], 0))))	as fFifthPrice
		  ,[dbo].[replaceEmptyPrice](CONCAT(IsNull(tPrices.fFifthComparison,0),'%'))as fFifthComparison
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(tPrices.fFifthOriginalPrice, 0)))) as fFifthOriginalPrice
		  ,IsNull(tPrices.fFifthModifiers,'') as fFifthModifiers
		  ,IsNull(tPrices.fFifthCurrency,'') as fFifthCurrency
		  ,tPrices.fFifthClass
		  ,(SELECT [fWebsiteName] FROM tRefWebsite WHERE (IsNull((SELECT top 1 fURL from @URLtable WHERE fID = 6),0) = fID )) as [fSixthWebsite]
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull([fSixthPrice], 0))))	as fSixthPrice
		  ,[dbo].[replaceEmptyPrice](CONCAT(IsNull(tPrices.fSixthComparison,0),'%'))as fSixthComparison
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(tPrices.fSixthOriginalPrice, 0)))) as fSixthOriginalPrice
		  ,IsNull(tPrices.fSixthModifiers,'') as fSixthModifiers
		  ,IsNull(tPrices.fSixthCurrency,'') as fSixthCurrency
		  ,tPrices.fSixthClass
		  ,(SELECT [fWebsiteName] FROM tRefWebsite WHERE (IsNull((SELECT top 1 fURL from @URLtable WHERE fID = 7),0) = fID )) as [fSeventhWebsite]
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull([fSeventhPrice], 0))))	as fSeventhPrice
		  ,[dbo].[replaceEmptyPrice](CONCAT(IsNull(tPrices.fSeventhComparison,0),'%'))as fSeventhComparison
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(tPrices.fSeventhOriginalPrice, 0)))) as fSeventhOriginalPrice
		  ,IsNull(tPrices.fSeventhModifiers,'') as fSeventhModifiers
		  ,IsNull(tPrices.fSeventhCurrency,'') as fSeventhCurrency
		  ,tPrices.fSeventhClass
		  ,(SELECT [fWebsiteName] FROM tRefWebsite WHERE (IsNull((SELECT top 1 fURL from @URLtable WHERE fID = 8),0) = fID )) as [fEighthWebsite]
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull([fEighthPrice], 0))))	as fEighthPrice
		  ,[dbo].[replaceEmptyPrice](CONCAT(IsNull(tPrices.fEighthComparison,0),'%'))as fEighthComparison
		  ,[dbo].[replaceEmptyPrice](CONCAT('$', (IsNull(tPrices.fEighthOriginalPrice, 0)))) as fEighthOriginalPrice
		  ,IsNull(tPrices.fEighthModifiers,'') as fEighthModifiers
		  ,IsNull(tPrices.fEighthCurrency,'') as fEighthCurrency
		  ,tPrices.fEighthClass
	  FROM #tTempTableLarge as tPrices  

	  GROUP BY 
		  tPrices.fLinkURL
		  ,tPrices.fscandate
		  ,tPrices.fTravelCountryID
		  ,fCountryName
		  ,tPrices.fPickupLocationID
		  ,tPrices.fReturnLocationID
		  ,[fLocationCombination]
		  ,tPrices.[fVehicleCompareName]
		  ,[fVehicleName]
		  ,tPrices.fBrandID
		  ,tPrices.fVehicleID
		  ,tPrices.[fTravelDates]
		  ,fScanTotalPrice
		  ,tPrices.fFirstComparison
		  ,tPrices.fScanOriginalPrice
		  ,tPrices.fScanModifiers 
		  ,tPrices.fScanCurrency
		  ,tPrices.fScanClass
		  , fSecondWebsite
		  ,[fSecondPrice]
		  ,tPrices.fSecondComparison
		  ,tPrices.fSecondOriginalPrice
		  ,tPrices.fSecondModifiers 
		  ,tPrices.fSecondCurrency 
		  ,tPrices.fSecondClass
		  , fThirdWebsite
		  ,[fThirdPrice]
		  ,tPrices.fThirdComparison
		  ,tPrices.fThirdOriginalPrice
		  ,tPrices.fThirdModifiers 
		  ,tPrices.fThirdCurrency 
		  ,tPrices.fThirdClass
		  ,fFourthWebsite
		  ,[fFourthPrice]
		  ,tPrices.fFourthComparison
		  ,tPrices.fFourthOriginalPrice
		  ,tPrices.fFourthModifiers 
		  ,tPrices.fFourthCurrency 
		  ,tPrices.fFourthClass
		  ,fFifthWebsite
		  ,[fFifthPrice]
		  ,tPrices.fFifthComparison
		  ,tPrices.fFifthOriginalPrice
		  ,tPrices.fFifthModifiers 
		  ,tPrices.fFifthCurrency
		  ,tPrices.fFifthClass
		  ,fSixthWebsite
		  ,[fSixthPrice]
		  ,tPrices.fSixthComparison
		  ,tPrices.fSixthOriginalPrice
		  ,tPrices.fSixthModifiers 
		  ,tPrices.fSixthCurrency 
		  ,tPrices.fSixthClass
		  ,fSeventhWebsite
		  ,[fSeventhPrice]
		  ,tPrices.fSeventhComparison
		  ,tPrices.fSeventhOriginalPrice
		  ,tPrices.fSeventhModifiers 
		  ,tPrices.fSeventhCurrency 
		  ,tPrices.fSeventhClass
		  ,fEighthWebsite
		  ,[fEighthPrice]
		  ,tPrices.fEighthComparison
		  ,tPrices.fEighthOriginalPrice
		  ,tPrices.fEighthModifiers 
		  ,tPrices.fEighthCurrency 
		  ,tPrices.fEighthClass
		  
	  ORDER BY fCountryName
			  ,[fLocationCombination]
			  , CAST (SUBSTRING(tPrices.[fTravelDates], 1, 9) as smalldatetime) ASC
			  ,tPrices.[fVehicleCompareName]
			  ,[fVehicleName]	
	  	  	  
	  delete from #tTempTableLarge




END


GO
/****** Object:  StoredProcedure [dbo].[getScanDataCleanByFiltersVehicleComparePriceIncrease]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <17/03/15>
-- Description:	<Get data from clean data table>
-- =============================================
CREATE PROCEDURE [dbo].[getScanDataCleanByFiltersVehicleComparePriceIncrease]
  @DataSetDateStart nvarchar(MAX)
, @CountryID int
, @BrandID int
, @PickupLocationID int
, @ReturnLocationID int 
, @VehicleID int
, @VehicleTypeID int
, @VehicleBerthID int
, @LicenceCountryID int
, @ScanURL int
, @PriceExceptions int

AS
BEGIN	

	DECLARE @SecondScanURL int
	, @ThirdScanURL int
	, @FourthScanURL int
	, @FifthScanURL int
	, @SixthScanURL int
	, @SeventhScanURL int
	, @EighthScanURL int
	, @DataSetSDT smalldatetime
	, @DataSetDateStartSDT date

	SET @SecondScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,2)
	SET @ThirdScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,3)
	SET @FourthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,4)
	SET @FifthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,5)
	SET @SixthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,6)
	SET @SeventhScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,7)
	SET @EighthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,8)

	SET @DataSetDateStartSDT = 
	CASE 
		WHEN  (@DataSetDateStart = 'NULL' OR @DataSetDateStart is Null)
			THEN CONVERT(SMALLDATETIME, '2000-01-01 00:00:01')
		ELSE
			CONVERT(SMALLDATETIME, @DataSetDateStart)
	END
	
	
	
	DECLARE @tVehicleEqiv TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fVehicleOneID int, fVehicleTwoID int, fVehicleOneName nvarchar(200), fVehicleOneBrandID int, fVehicleOneTypeID int, fVehicleOneBerthID int, fVehicleTwoName nvarchar(200), fVehicleTwoBrandID int)
	-- get combos from equivalents table
	INSERT INTO @tVehicleEqiv (fVehicleOneID, fVehicleTwoID)
	SELECT distinct fVehicleOneID, fVehicleTwoID FROM tRefVehicleEquivalent
	-- insert vehicles where they are equivalents of themselves
	INSERT INTO @tVehicleEqiv (fVehicleOneID, fVehicleTwoID)
	SELECT fVehicleOneID, fVehicleOneID FROM (SELECT distinct fVehicleOneID FROM tRefVehicleEquivalent) as v
	-- add rband id for main vehicle
	UPDATE @tVehicleEqiv
	SET fVehicleOneBrandID = (SELECT fVEhicleBrandID FROM tRefVehicle WHERE fID = fVehicleOneID),
		fVehicleTwoBrandID = (SELECT fVEhicleBrandID FROM tRefVehicle WHERE fID = fVehicleTwoID),
		fVehicleOneTypeID = (SELECT fVehicleTypeID FROM tRefVehicle WHERE fID = fVehicleOneID),
		fVehicleOneBerthID = (SELECT sum(fVehicleBerthAdults + fVehicleBerthChildren ) FROM tRefVehicle WHERE fID = fVehicleOneID)
	--get equiv vehicle name
	UPDATE @tVehicleEqiv
	SET fVehicleOneName = concat((SELECT fBrandName FROM tRefBrand WHERE fID = (SELECT fVehicleBrandID FROM tRefVehicle WHERE fID = fVehicleOneID)),' ',(SELECT fVehicleName FROM tRefVehicle WHERE fID = fVehicleOneID)),
		fVehicleTwoName=  concat((SELECT fBrandName FROM tRefBrand WHERE fID = (SELECT fVehicleBrandID FROM tRefVehicle WHERE fID = fVehicleTwoID)),' ',(SELECT fVehicleName FROM tRefVehicle WHERE fID = fVehicleTwoID))


--SELECT * FROM @tVehicleEqiv

	--get required data set into temp table
	IF OBJECT_ID('tempdb..#tTempTablePI') IS NOT NULL
	/*Then it exists*/
	DROP TABLE #tTempTablePI
	--create table
	CREATE TABLE #tTempTablePI 
		(
		   fID int IDENTITY(1,1) PRIMARY KEY
		  ,fScanID int
		  ,fScanURL int
		  ,fScanDate date
		  ,fTravelCountryID int
		  ,fPickupLocationID int
		  ,fReturnLocationID int
		  ,fPickupDate date
		  ,fReturnDate date
		  ,fVehicleCompareID int
		  ,fVehicleID int
		  ,fTotalPrice decimal(18,2)
		  ,fTotalPriceUpdated decimal(18,2)
		  ,fTotalPriceCurrency nvarchar(3)
		  ,fScanCurrencyID int
		  ,fTotalPriceModifiers nvarchar(max)
		  ,fOldPrice decimal(18,2)
		  ,fOldPriceUpdated decimal(18,2)
		  ,fOldPriceCurrency nvarchar(3)
		  ,fOldPriceModifiers nvarchar(max)
		  ,fPriceChange decimal(18,2)	 
		  ,fActive int
		)

	-- main data
	INSERT INTO #tTempTablePI (	fScanID, fScanURL, fScanDate, fTravelCountryID, fPickupLocationID, fReturnLocationID, fPickupDate, fReturnDate, fVehicleCompareID, fVehicleID, 
								fTotalPrice, fScanCurrencyID, fActive)
	SELECT tTemp.fScanID
				,tTemp.[fScanURL]
				,tTemp.fScanDate
				,tTemp.[fScanTravelCountryID]
				,tTemp.[fScanPickupLocationID]
				,tTemp.[fScanReturnLocationID]
				,tTemp.[fScanPickupDate]
				,tTemp.[fScanReturnDate]
				,tEquiv.fVehicleOneID
				,tTemp.[fScanVehicleID]
				,[dbo].[convertPriceToCurrency](tTemp.fScanTotalPrice, tTemp.fScanCurrencyID, tTemp.fScanDate, tTemp.fScanTravelCountryID) as fScanTotalPrice
				,tTemp.[fScanCurrencyID]	
				,0
		from [dbo].[tDataScanClean] as tTemp
		INNER JOIN @tVehicleEqiv as tEquiv on tEquiv.fVehicleTwoID = fScanVehicleID
		WHERE 
		(tTemp.fScanDate >= dateadd(day,-7,@DataSetDateStartSDT) AND tTemp.fScanDate <= DATEADD(day,7,@DataSetDateStartSDT) OR @DataSetDateStart = 'NULL' OR @DataSetDateStart is Null )  
		AND (tEquiv.[fVehicleOneID] = @VehicleID OR @VehicleID = 0)
		AND (tTemp.fScanTravelCountryID = @CountryID OR @CountryID = 0)
		AND (tTemp.fScanPickupLocationID = @PickupLocationID OR @PickupLocationID = 0)
		AND (tTemp.fScanReturnLocationID = @ReturnLocationID OR @ReturnLocationID = 0)
		AND (tTemp.fScanLicenceCountryID = [dbo].[getLicenceCountryByIntOrDom](tTemp.fScanURL, @CountryID, @LicenceCountryID))
		AND (tEquiv.fVehicleOneBrandID = @BrandID OR @BrandID = 0)
		AND ((tEquiv.fVehicleOneTypeID = @VehicleTypeID) OR @VehicleTypeID = 0)
		AND ((tEquiv.fVehicleOneBerthID = @VehicleBerthID) OR @VehicleBerthID = 0)
		AND tTemp.fActive = 1
		

--SELECT * FROM #tTempTablePI
	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	UPDATE #tTempTablePI
	SET fTotalPriceCurrency =  (SELECT fCurrencyCode from tRefCurrency WHERE fID = fScanCurrencyID),
		fTotalPriceUpdated = [dbo].[convertPriceByExceptions](	fTotalPrice, fScanURL, fVehicleID, 
																fTravelCountryID, fPickupLocationID, fReturnLocationID, 
																fPickupDate, fScanCurrencyID, @PriceExceptions),
		fTotalPriceModifiers = [dbo].[getListPriceExceptionsAsString](fTotalPrice, fScanURL, fVehicleID, fTravelCountryID, fPickupLocationID, fReturnLocationID, fPickupDate, fScanCurrencyID, @PriceExceptions),
		fScanDate = [dbo].[getFirstDayOfWeek](fScanDate)

	DELETE FROM #tTempTablePI 
	WHERE fID NOT IN (SELECT min(fID) as fID FROM #tTempTablePI GROUP BY fScanURL, fPickupLocationID, fReturnLocationID, fPickupDate, fReturnDate, fVehicleID, fTotalPrice)
	

--SELECT * FROM #tTempTablePI

	----------------------------------------------------------------------------  10 secs up to here  ----------------------------------------------------------------------------


	Declare @count int, @rowID int, @priceChange decimal(18,2), @thisPrice decimal(18,2), @oldPrice decimal(18,2), @thisScanDate date, @thisURL int,
			@thisTravelCountryID int, @thisPickupLocationID int, @thisReturnLocationID int, @thisPickupDate date, @thisReturnDate date,
			@thisVehicleCompareID int, @thisVehicleID int,  @thisCurrency nvarchar (3), @thisCurrencyID int
	SET @count = 0

	WHILE @count < (select count(fID) from #tTempTablePI)
		BEGIN		
			SET @rowID = @count + 1
			SET @thisScanDate = (SELECT fScanDate FROM #tTempTablePI WHERE fID = @rowID)

			If @thisScanDate = @DataSetDateStartSDT
				BEGIN
					SET @thisPrice = (SELECT fTotalPrice FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisURL = (SELECT fScanURL FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisTravelCountryID = (SELECT fTravelCountryID FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisPickupLocationID = (SELECT fPickupLocationID FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisReturnLocationID = (SELECT fReturnLocationID FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisPickupDate = (SELECT fPickupDate FROM #tTempTablePI WHERE fID = @rowID)					
					SET @thisReturnDate = (SELECT fReturnDate FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisVehicleCompareID = (SELECT fVehicleCompareID FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisVehicleID = (SELECT fVehicleID FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisCurrency = (SELECT fTotalPriceCurrency FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisCurrencyID = (SELECT fID FROM tRefCurrency WHERE fCurrencyCode = @thisCurrency)

					SET @oldPrice = 
						(	SELECT min(fTotalPrice) FROM #tTempTablePI 
							WHERE	fScanURL  = @thisURL
							AND		fTravelCountryID = @thisTravelCountryID
							AND		fPickupLocationID = @thisPickupLocationID
							AND		fReturnLocationID = @thisReturnLocationID
							AND		fPickupDate = @thisPickupDate
							AND		fReturnDate = @thisReturnDate
							AND		fVehicleCompareID = @thisVehicleCompareID
							AND		fVehicleID = @thisVehicleID
							AND		fScanDate = dateadd(day,-7,@DataSetDateStartSDT)
						)



					SET @priceChange = cast ((@thisPrice - @oldPrice) as decimal(18,2))

					UPDATE #tTempTablePI
					SET fPriceChange = @priceChange,
						fOldPrice = @oldPrice,
						fOldPriceUpdated = [dbo].[convertPriceByExceptions](@oldPrice, @thisURL, @thisVehicleID, @thisTravelCountryID, @thisPickupLocationID, @thisReturnLocationID, @thisPickupDate, @thisCurrencyID, @PriceExceptions),
					    fOldPriceCurrency = @thisCurrency,
					    fOldPriceModifiers = [dbo].[getListPriceExceptionsAsString](@oldPrice, @thisURL, @thisVehicleID, @thisTravelCountryID, @thisPickupLocationID, @thisReturnLocationID, @thisPickupDate, @thisCurrencyID, @PriceExceptions) 
					WHERE fID = @rowID
					
				END
			SET @count = @count + 1
		END

	--remove old values
	DELETE fROM #tTempTablePI
	WHERE fScanDate = dateadd(day,-7,@DataSetDateStartSDT)
	
	----------------------------------------------------------------------------  19 secs up to here  ----------------------------------------------------------------------------

	-- get the dates from the main table
	DECLARE @dateOne nvarchar(20), @dateTwo nvarchar(20), @dateThree nvarchar(20), @dateFour nvarchar(20), @dateFive nvarchar(20), @dateSix nvarchar(20), @dateSeven nvarchar(20), @dateEight nvarchar(20), @dateNine nvarchar(20), @dateTen nvarchar(20)
	SET @dateOne =		CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI ORDER BY fPickupDate asc),6)
	SET @dateTwo =		CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateOne ORDER BY fPickupDate asc),6)
	SET @dateThree =	CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateTwo ORDER BY fPickupDate asc),6)
	SET @dateFour =		CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateThree ORDER BY fPickupDate asc),6)
	SET @dateFive =		CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateFour ORDER BY fPickupDate asc),6)
	SET @dateSix =		CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateFive ORDER BY fPickupDate asc),6)
	SET @dateSeven =	CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateSix ORDER BY fPickupDate asc),6)
	SET @dateEight =	CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateSeven ORDER BY fPickupDate asc),6)			
	SET @dateTen =		CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateNine ORDER BY fPickupDate asc),6)

	-- combine table repetitively to get data	
	SELECT   tMain.fScanID	
			,tMain.fScanURL		
			,tW.fWebsiteName
			,tC.fCountryName	
			,concat(tPL.fLocationName,' - ', tRL.fLocationName) as fLocationCombination
			,tV.fVehicleTwoBrandID as fVehicleBrandID
			,replace(tV.fVehicleTwoName,' Berth','B') as fVehicleName
			,replace(tV.fVehicleOneName,' Berth','B') as fVehicleCompareName
			,ISNULL(tV.fID,0) as fVehicleID
			,@dateOne as fFirstDate
			,ISNULL(tFirstDate.fTotalPrice,0) as fFirstPrice
			,ISNULL(tFirstDate.fTotalPriceUpdated,0) as fFirstPriceUpdated 
			,ISNULL(tFirstDate.fTotalPriceCurrency,'N/A') as fFirstPriceCurrency 
			,ISNULL(tFirstDate.fTotalPriceModifiers,'N/A') as fFirstPriceModifiers 
			,ISNULL(tFirstDate.fOldPrice,0) as fFirstOldPrice
			,ISNULL(tFirstDate.fOldPriceUpdated,0) as fFirstOldPriceUpdated 
			,ISNULL(tFirstDate.fOldPriceCurrency,'N/A') as fFirstOldPriceCurrency 
			,ISNULL(tFirstDate.fOldPriceModifiers,'N/A') as fFirstOldPriceModifiers 
			,ISNULL(tFirstDate.fPriceChange,0) as fFirstPriceChange
			,ISNULL(concat('firstPrice ',[dbo].[getClassNameTableForPriceIncrease](tFirstDate.fTotalPrice, tFirstDate.fOldPrice, tFirstDate.fPriceChange)),'') as fFirstClass
			,@dateTwo as fSecondDate
			,ISNULL(tSecondDate.fTotalPrice,0) as fSecondPrice
			,ISNULL(tSecondDate.fTotalPriceUpdated,0) as fSecondPriceUpdated 
			,ISNULL(tSecondDate.fTotalPriceCurrency,'N/A') as fSecondPriceCurrency 
			,ISNULL(tSecondDate.fTotalPriceModifiers,'N/A') as fSecondPriceModifiers 
			,ISNULL(tSecondDate.fOldPrice,0) as fSecondOldPrice
			,ISNULL(tSecondDate.fOldPriceUpdated,0) as fSecondOldPriceUpdated 
			,ISNULL(tSecondDate.fOldPriceCurrency,'N/A') as fSecondOldPriceCurrency 
			,ISNULL(tSecondDate.fOldPriceModifiers,'N/A') as fSecondOldPriceModifiers 
			,ISNULL(tSecondDate.fPriceChange,0) as fSecondPriceChange
			,ISNULL(concat('secondPrice ',[dbo].[getClassNameTableForPriceIncrease](tSecondDate.fTotalPrice, tSecondDate.fOldPrice, tSecondDate.fPriceChange)),'') as  fSecondClass
			,@dateThree as fThirdDate
			,ISNULL(tThirdDate.fTotalPrice,0) as fThirdPrice
			,ISNULL(tThirdDate.fTotalPriceUpdated,0) as fThirdPriceUpdated 
			,ISNULL(tThirdDate.fTotalPriceCurrency,'N/A') as fThirdPriceCurrency 
			,ISNULL(tThirdDate.fTotalPriceModifiers,'N/A') as fThirdPriceModifiers 
			,ISNULL(tThirdDate.fOldPrice,0) as fThirdOldPrice
			,ISNULL(tThirdDate.fOldPriceUpdated,0) as fThirdOldPriceUpdated 
			,ISNULL(tThirdDate.fOldPriceCurrency,'N/A') as fThirdOldPriceCurrency 
			,ISNULL(tThirdDate.fOldPriceModifiers,'N/A') as fThirdOldPriceModifiers 
			,ISNULL(tThirdDate.fPriceChange,0) as fThirdPriceChange
			,ISNULL(concat('thirdPrice ',[dbo].[getClassNameTableForPriceIncrease](tThirdDate.fTotalPrice, tThirdDate.fOldPrice, tThirdDate.fPriceChange)),'') as fThirdClass
			,@dateFour as fFourthDate
			,ISNULL(tFourthDate.fTotalPrice,0) as fFourthPrice
			,ISNULL(tFourthDate.fTotalPriceUpdated,0) as fFourthPriceUpdated 
			,ISNULL(tFourthDate.fTotalPriceCurrency,'N/A') as fFourthPriceCurrency 
			,ISNULL(tFourthDate.fTotalPriceModifiers,'N/A') as fFourthPriceModifiers 
			,ISNULL(tFourthDate.fOldPrice,0) as fFourthOldPrice
			,ISNULL(tFourthDate.fOldPriceUpdated,0) as fFourthOldPriceUpdated 
			,ISNULL(tFourthDate.fOldPriceCurrency,'N/A') as fFourthOldPriceCurrency 
			,ISNULL(tFourthDate.fOldPriceModifiers,'N/A') as fFourthOldPriceModifiers 
			,ISNULL(tFourthDate.fPriceChange,0) as fFourthPriceChange
			,ISNULL(concat('fourthPrice ',[dbo].[getClassNameTableForPriceIncrease](tFourthDate.fTotalPrice, tFourthDate.fOldPrice, tFourthDate.fPriceChange)),'') as fFourthClass
			,@dateFive as fFifthDate
			,ISNULL(tFifthDate.fTotalPrice,0) as fFifthPrice
			,ISNULL(tFifthDate.fTotalPriceUpdated,0) as fFifthPriceUpdated 
			,ISNULL(tFifthDate.fTotalPriceCurrency,'N/A') as fFifthPriceCurrency 
			,ISNULL(tFifthDate.fTotalPriceModifiers,'N/A') as fFifthPriceModifiers 
			,ISNULL(tFifthDate.fOldPrice,0) as fFifthOldPrice
			,ISNULL(tFifthDate.fOldPriceUpdated,0) as fFifthOldPriceUpdated 
			,ISNULL(tFifthDate.fOldPriceCurrency,'N/A') as fFifthOldPriceCurrency 
			,ISNULL(tFifthDate.fOldPriceModifiers,'N/A') as fFifthOldPriceModifiers 
			,ISNULL(tFifthDate.fPriceChange,0) as fFifthPriceChange
			,ISNULL(concat('fifthPrice ',[dbo].[getClassNameTableForPriceIncrease](tFifthDate.fTotalPrice, tFifthDate.fOldPrice, tFifthDate.fPriceChange)),'') as  fFifthClass
			,@dateSix as fSixthDate
			,ISNULL(tSixthDate.fTotalPrice,0) as fSixthPrice
			,ISNULL(tSixthDate.fTotalPriceUpdated,0) as fSixthPriceUpdated 
			,ISNULL(tSixthDate.fTotalPriceCurrency,'N/A') as fSixthPriceCurrency 
			,ISNULL(tSixthDate.fTotalPriceModifiers,'N/A') as fSixthPriceModifiers 
			,ISNULL(tSixthDate.fOldPrice,0) as fSixthOldPrice
			,ISNULL(tSixthDate.fOldPriceUpdated,0) as fSixthOldPriceUpdated 
			,ISNULL(tSixthDate.fOldPriceCurrency,'N/A') as fSixthOldPriceCurrency 
			,ISNULL(tSixthDate.fOldPriceModifiers,'N/A') as fSixthOldPriceModifiers 
			,ISNULL(tSixthDate.fPriceChange,0) as fSixthPriceChange
			,ISNULL(concat('sixthPrice ',[dbo].[getClassNameTableForPriceIncrease](tSixthDate.fTotalPrice, tSixthDate.fOldPrice, tSixthDate.fPriceChange)),'') as  fSixthClass
			,@dateSeven as fSeventhDate
			,ISNULL(tSeventhDate.fTotalPrice,0) as fSeventhPrice
			,ISNULL(tSeventhDate.fTotalPriceUpdated,0) as fSeventhPriceUpdated 
			,ISNULL(tSeventhDate.fTotalPriceCurrency,'N/A') as fSeventhPriceCurrency 
			,ISNULL(tSeventhDate.fTotalPriceModifiers,'N/A') as fSeventhPriceModifiers 
			,ISNULL(tSeventhDate.fOldPrice,0) as fSeventhOldPrice
			,ISNULL(tSeventhDate.fOldPriceUpdated,0) as fSeventhOldPriceUpdated 
			,ISNULL(tSeventhDate.fOldPriceCurrency,'N/A') as fSeventhOldPriceCurrency 
			,ISNULL(tSeventhDate.fOldPriceModifiers,'N/A') as fSeventhOldPriceModifiers 
			,ISNULL(tSeventhDate.fPriceChange,0) as fSeventhPriceChange
			,ISNULL(concat('seventhPrice ',[dbo].[getClassNameTableForPriceIncrease](tSeventhDate.fTotalPrice, tSeventhDate.fOldPrice, tSeventhDate.fPriceChange)),'') as  fSeventhClass
			,@dateEight as fEighthDate
			,ISNULL(tEighthDate.fTotalPrice,0) as fEighthPrice
			,ISNULL(tEighthDate.fTotalPriceUpdated,0) as fEighthPriceUpdated 
			,ISNULL(tEighthDate.fTotalPriceCurrency,'N/A') as fEighthPriceCurrency 
			,ISNULL(tEighthDate.fTotalPriceModifiers,'N/A') as fEighthPriceModifiers 
			,ISNULL(tEighthDate.fOldPrice,0) as fEighthOldPrice
			,ISNULL(tEighthDate.fOldPriceUpdated,0) as fEighthOldPriceUpdated 
			,ISNULL(tEighthDate.fOldPriceCurrency,'N/A') as fEighthOldPriceCurrency 
			,ISNULL(tEighthDate.fOldPriceModifiers,'N/A') as fEighthOldPriceModifiers 
			,ISNULL(tEighthDate.fPriceChange,0) as fEighthPriceChange
			,ISNULL(concat('eighthPrice ',[dbo].[getClassNameTableForPriceIncrease](tEighthDate.fTotalPrice, tEighthDate.fOldPrice, tEighthDate.fPriceChange)),'') as  fEighthClass
			,@dateNine as fNinthDate
			,ISNULL(tNinthDate.fTotalPrice,0) as fNinthPrice
			,ISNULL(tNinthDate.fTotalPriceUpdated,0) as fNinthPriceUpdated 
			,ISNULL(tNinthDate.fTotalPriceCurrency,'N/A') as fNinthPriceCurrency 
			,ISNULL(tNinthDate.fTotalPriceModifiers,'N/A') as fNinthPriceModifiers 
			,ISNULL(tNinthDate.fOldPrice,0) as fNinthOldPrice
			,ISNULL(tNinthDate.fOldPriceUpdated,0) as fNinthOldPriceUpdated 
			,ISNULL(tNinthDate.fOldPriceCurrency,'N/A') as fNinthOldPriceCurrency 
			,ISNULL(tNinthDate.fOldPriceModifiers,'N/A') as fNinthOldPriceModifiers 
			,ISNULL(tNinthDate.fPriceChange,0) as fNinthPriceChange
			,ISNULL(concat('ninthPrice ',[dbo].[getClassNameTableForPriceIncrease](tNinthDate.fTotalPrice, tNinthDate.fOldPrice, tNinthDate.fPriceChange)),'') as  fNinthClass
			,@dateTen as fTenthDate
			,ISNULL(tTenthDate.fTotalPrice,0) as fTenthPrice
			,ISNULL(tTenthDate.fTotalPriceUpdated,0) as fTenthPriceUpdated 
			,ISNULL(tTenthDate.fTotalPriceCurrency,'N/A') as fTenthPriceCurrency 
			,ISNULL(tTenthDate.fTotalPriceModifiers,'N/A') as fTenthPriceModifiers 
			,ISNULL(tTenthDate.fOldPrice,0) as fTenthOldPrice
			,ISNULL(tTenthDate.fOldPriceUpdated,0) as fTenthOldPriceUpdated 
			,ISNULL(tTenthDate.fOldPriceCurrency,'N/A') as fTenthOldPriceCurrency 
			,ISNULL(tTenthDate.fOldPriceModifiers,'N/A') as fTenthOldPriceModifiers 
			,ISNULL(tTenthDate.fPriceChange,0) as fTenthPriceChange
			,ISNULL(concat('tenthPrice ',[dbo].[getClassNameTableForPriceIncrease](tTenthDate.fTotalPrice, tTenthDate.fOldPrice, tTenthDate.fPriceChange)),'') as  fTenthClass
	
	
	 from (	 
	 SELECT min(fScanID) as fScanID
			,fScanURL		
			,fTravelCountryID
			,fPickupLocationID
			,fReturnLocationID
			,fVehicleCompareID
			,fVehicleID
	FROM #tTempTablePI 	 
	GROUP BY fScanURL		
			,fTravelCountryID
			,fPickupLocationID
			,fReturnLocationID
			,fVehicleCompareID
			,fVehicleID
	 
	 )as tMain 
	LEFT JOIN tRefLocation as tPL on tPL.fID = tMain.fPickupLocationID
	LEFT JOIN tRefLocation as tRL on tRL.fID = tMain.fReturnLocationID
	LEFT JOIN tRefCountry as tC on tC.fID = tMain.fTravelCountryID	
	LEFT JOIN @tVehicleEqiv as tV on tV.fVehicleTwoID = tMain.fVehicleID
	LEFT JOIN tRefBrand as tVCB on tVCB.fID =  tV.fVehicleTwoBrandID
	LEFT JOIN tRefWebsite as tW on tW.fID = tMain.fScanURL
	
	LEFT Join #tTempTablePI as tFirstDate on 
		(	tMain.fScanURL = tFirstDate.fScanURL
		AND tMain.fTravelCountryID = tFirstDate.fTravelCountryID
		AND tMain.fPickupLocationID = tFirstDate.fPickupLocationID
		AND tMain.fReturnLocationID = tFirstDate.fReturnLocationID
		AND tMain.fVehicleID = tFirstDate.fVehicleID
		AND tFirstDate.fPickupDate = @dateOne
		)
	LEFT Join #tTempTablePI as tSecondDate on 
		(	tMain.fScanURL = tSecondDate.fScanURL
		AND tMain.fTravelCountryID = tSecondDate.fTravelCountryID
		AND tMain.fPickupLocationID = tSecondDate.fPickupLocationID
		AND tMain.fReturnLocationID = tSecondDate.fReturnLocationID
		AND tMain.fVehicleID = tSecondDate.fVehicleID
		AND tSecondDate.fPickupDate = @dateTwo
		)
	LEFT Join #tTempTablePI as tThirdDate on 
		(	tMain.fScanURL = tThirdDate.fScanURL
		AND tMain.fTravelCountryID = tThirdDate.fTravelCountryID
		AND tMain.fPickupLocationID = tThirdDate.fPickupLocationID
		AND tMain.fReturnLocationID = tThirdDate.fReturnLocationID
		AND tMain.fVehicleID = tThirdDate.fVehicleID
	AND		tThirdDate.fPickupDate = @dateThree
		)
	LEFT Join #tTempTablePI as tFourthDate on 
		(	tMain.fScanURL = tFourthDate.fScanURL
		AND tMain.fTravelCountryID = tFourthDate.fTravelCountryID
		AND tMain.fPickupLocationID = tFourthDate.fPickupLocationID
		AND tMain.fReturnLocationID = tFourthDate.fReturnLocationID
		AND tMain.fVehicleID = tFourthDate.fVehicleID
	AND		tFourthDate.fPickupDate = @dateFour
		)
	LEFT Join #tTempTablePI as tFifthDate on 
		(	tMain.fScanURL = tFifthDate.fScanURL
		AND tMain.fTravelCountryID = tFifthDate.fTravelCountryID
		AND tMain.fPickupLocationID = tFifthDate.fPickupLocationID
		AND tMain.fReturnLocationID = tFifthDate.fReturnLocationID
		AND tMain.fVehicleID = tFifthDate.fVehicleID
	AND		tFifthDate.fPickupDate = @dateFive
		)
	LEFT Join #tTempTablePI as tSixthDate on 
		(	tMain.fScanURL = tSixthDate.fScanURL
		AND tMain.fTravelCountryID = tSixthDate.fTravelCountryID
		AND tMain.fPickupLocationID = tSixthDate.fPickupLocationID
		AND tMain.fReturnLocationID = tSixthDate.fReturnLocationID
		AND tMain.fVehicleID = tSixthDate.fVehicleID
	AND		tSixthDate.fPickupDate = @dateSix
		)
	LEFT Join #tTempTablePI as tSeventhDate on 
		(	tMain.fScanURL = tSeventhDate.fScanURL
		AND tMain.fTravelCountryID = tSeventhDate.fTravelCountryID
		AND tMain.fPickupLocationID = tSeventhDate.fPickupLocationID
		AND tMain.fReturnLocationID = tSeventhDate.fReturnLocationID
		AND tMain.fVehicleID = tSeventhDate.fVehicleID
	AND		tSeventhDate.fPickupDate = @dateSeven
		)
	LEFT Join #tTempTablePI as tEighthDate on 
		(	tMain.fScanURL = tEighthDate.fScanURL
		AND tMain.fTravelCountryID = tEighthDate.fTravelCountryID
		AND tMain.fPickupLocationID = tEighthDate.fPickupLocationID
		AND tMain.fReturnLocationID = tEighthDate.fReturnLocationID
		AND tMain.fVehicleID = tEighthDate.fVehicleID
	AND		tEighthDate.fPickupDate = @dateEight
		)
	LEFT Join #tTempTablePI as tNinthDate on 
		(	tMain.fScanURL = tNinthDate.fScanURL
		AND tMain.fTravelCountryID = tNinthDate.fTravelCountryID
		AND tMain.fPickupLocationID = tNinthDate.fPickupLocationID
		AND tMain.fReturnLocationID = tNinthDate.fReturnLocationID
		AND tMain.fVehicleID = tNinthDate.fVehicleID
	AND		tNinthDate.fPickupDate = @dateNine
		)
	LEFT OUTER Join #tTempTablePI as tTenthDate on 
		(	tMain.fScanURL = tTenthDate.fScanURL
		AND tMain.fTravelCountryID = tTenthDate.fTravelCountryID
		AND tMain.fPickupLocationID = tTenthDate.fPickupLocationID
		AND tMain.fReturnLocationID = tTenthDate.fReturnLocationID
		AND tMain.fVehicleID = tTenthDate.fVehicleID
		AND tTenthDate.fPickupDate = @dateTen
		)

	WHERE	(tFirstDate.fPickupDate  = @dateOne OR tFirstDate.fPickupDate IS NULL)
	
	ORDER BY tC.fCountryName
			,fLocationCombination
			,tV.fVehicleOneName
			,tFirstDate.fScanURL	
			,tVCB.fBrandOrderPriceIncrease
			,tV.fVehicleTwoName
				
	DELETE FROM #tTempTablePI

	
END


GO
/****** Object:  StoredProcedure [dbo].[getScanDataCleanByFiltersVehicleComparePriceIncreaseSmallestPriceOnly]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <17/03/15>
-- Description:	<Get data from clean data table>
-- =============================================
CREATE PROCEDURE [dbo].[getScanDataCleanByFiltersVehicleComparePriceIncreaseSmallestPriceOnly]
  @DataSetDateStart nvarchar(MAX)
, @CountryID int
, @BrandID int
, @PickupLocationID int
, @ReturnLocationID int 
, @VehicleID int
, @VehicleTypeID int
, @VehicleBerthID int
, @LicenceCountryID int
, @ScanURL int
, @PriceExceptions int

AS
BEGIN	

DECLARE @SecondScanURL int
, @ThirdScanURL int
, @FourthScanURL int
, @FifthScanURL int
, @SixthScanURL int
, @SeventhScanURL int
, @EighthScanURL int
, @DataSetSDT smalldatetime
, @DataSetDateStartSDT date

SET @SecondScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,2)
SET @ThirdScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,3)
SET @FourthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,4)
SET @FifthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,5)
SET @SixthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,6)
SET @SeventhScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,7)
SET @EighthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,8)


SET @DataSetDateStartSDT = 
CASE 
	WHEN  (@DataSetDateStart = 'NULL' OR @DataSetDateStart is Null)
		THEN CONVERT(SMALLDATETIME, '2000-01-01 00:00:01')
	ELSE
		CONVERT(SMALLDATETIME, @DataSetDateStart)
END

	
	DECLARE @tVehicleEqiv TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fVehicleOneID int, fVehicleTwoID int, fVehicleOneName nvarchar(200), fVehicleOneBrandID int, fVehicleOneTypeID int, fVehicleOneBerthID int, fVehicleTwoName nvarchar(200), fVehicleTwoBrandID int)
	-- get combos from equivalents table
	INSERT INTO @tVehicleEqiv (fVehicleOneID, fVehicleTwoID)
	SELECT distinct fVehicleOneID, fVehicleTwoID FROM tRefVehicleEquivalent
	-- insert vehicles where they are equivalents of themselves
	INSERT INTO @tVehicleEqiv (fVehicleOneID, fVehicleTwoID)
	SELECT fVehicleOneID, fVehicleOneID FROM (SELECT distinct fVehicleOneID FROM tRefVehicleEquivalent) as v
	-- add rband id for main vehicle
	UPDATE @tVehicleEqiv
	SET fVehicleOneBrandID = (SELECT fVEhicleBrandID FROM tRefVehicle WHERE fID = fVehicleOneID),
		fVehicleTwoBrandID = (SELECT fVEhicleBrandID FROM tRefVehicle WHERE fID = fVehicleTwoID),
		fVehicleOneTypeID = (SELECT fVehicleTypeID FROM tRefVehicle WHERE fID = fVehicleOneID),
		fVehicleOneBerthID = (SELECT sum(fVehicleBerthAdults + fVehicleBerthChildren ) FROM tRefVehicle WHERE fID = fVehicleOneID)
	--get equiv vehicle name
	UPDATE @tVehicleEqiv
	SET fVehicleOneName = concat((SELECT fBrandName FROM tRefBrand WHERE fID = (SELECT fVehicleBrandID FROM tRefVehicle WHERE fID = fVehicleOneID)),' ',(SELECT fVehicleName FROM tRefVehicle WHERE fID = fVehicleOneID)),
		fVehicleTwoName=  concat((SELECT fBrandName FROM tRefBrand WHERE fID = (SELECT fVehicleBrandID FROM tRefVehicle WHERE fID = fVehicleTwoID)),' ',(SELECT fVehicleName FROM tRefVehicle WHERE fID = fVehicleTwoID))

--SELECT * FROM @tVehicleEqiv

	--get required data set into temp table
	IF OBJECT_ID('tempdb..#tTempTablePI') IS NOT NULL
	/*Then it exists*/
	DROP TABLE #tTempTablePI
	--create table
	CREATE TABLE #tTempTablePI 
		(
		   fID int IDENTITY(1,1) PRIMARY KEY
		  ,fScanID int
		  ,fScanURL int
		  ,fScanDate date
		  ,fTravelCountryID int
		  ,fPickupLocationID int
		  ,fReturnLocationID int
		  ,fPickupDate date
		  ,fReturnDate date
		  ,fVehicleCompareID int
		  ,fVehicleID int
		  ,fTotalPrice decimal(18,2)
		  ,fTotalPriceUpdated decimal(18,2)
		  ,fTotalPriceCurrency nvarchar(3)
		  ,fScanCurrencyID int
		  ,fTotalPriceModifiers nvarchar(max)
		  ,fOldPrice decimal(18,2)
		  ,fOldPriceUpdated decimal(18,2)
		  ,fOldPriceCurrency nvarchar(3)
		  ,fOldPriceModifiers nvarchar(max)
		  ,fPriceChange decimal(18,2)	 
		  ,fActive int
		)

	-- main data
	INSERT INTO #tTempTablePI (	fScanID, fScanURL, fScanDate, fTravelCountryID, fPickupLocationID, fReturnLocationID, fPickupDate, fReturnDate, fVehicleCompareID, fVehicleID, 
								fTotalPrice, fScanCurrencyID, fActive)
	SELECT tTemp.fScanID
				,tTemp.[fScanURL]
				,tTemp.fScanDate
				,tTemp.[fScanTravelCountryID]
				,tTemp.[fScanPickupLocationID]
				,tTemp.[fScanReturnLocationID]
				,tTemp.[fScanPickupDate]
				,tTemp.[fScanReturnDate]
				,tEquiv.fVehicleOneID
				,tTemp.[fScanVehicleID]
				,[dbo].[convertPriceToCurrency](tTemp.fScanTotalPrice, tTemp.fScanCurrencyID, tTemp.fScanDate, tTemp.fScanTravelCountryID) as fScanTotalPrice
				,tTemp.[fScanCurrencyID]	
				,0
		from [dbo].[tDataScanClean] as tTemp
		INNER JOIN @tVehicleEqiv as tEquiv on tEquiv.fVehicleTwoID = fScanVehicleID
		WHERE 
		(tTemp.fScanDate >= dateadd(day,-7,@DataSetDateStartSDT) AND tTemp.fScanDate <= DATEADD(day,7,@DataSetDateStartSDT) OR @DataSetDateStart = 'NULL' OR @DataSetDateStart is Null )  
		AND (tEquiv.[fVehicleOneID] = @VehicleID OR @VehicleID = 0)
		AND (tTemp.fScanTravelCountryID = @CountryID OR @CountryID = 0)
		AND (tTemp.fScanPickupLocationID = @PickupLocationID OR @PickupLocationID = 0)
		AND (tTemp.fScanReturnLocationID = @ReturnLocationID OR @ReturnLocationID = 0)
		AND (tTemp.fScanLicenceCountryID = [dbo].[getLicenceCountryByIntOrDom](tTemp.fScanURL, @CountryID, @LicenceCountryID))
		AND (tEquiv.fVehicleOneBrandID = @BrandID OR @BrandID = 0)
		AND ((tEquiv.fVehicleOneTypeID = @VehicleTypeID) OR @VehicleTypeID = 0)
		AND ((tEquiv.fVehicleOneBerthID = @VehicleBerthID) OR @VehicleBerthID = 0)
		AND tTemp.fActive = 1
		
	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	UPDATE #tTempTablePI
	SET fTotalPriceCurrency =  (SELECT fCurrencyCode from tRefCurrency WHERE fID = fScanCurrencyID),
		fTotalPriceUpdated = [dbo].[convertPriceByExceptions](	fTotalPrice, fScanURL, fVehicleID, 
																fTravelCountryID, fPickupLocationID, fReturnLocationID, 
																fPickupDate, fScanCurrencyID, @PriceExceptions),
		fTotalPriceModifiers = [dbo].[getListPriceExceptionsAsString](fTotalPrice, fScanURL, fVehicleID, fTravelCountryID, fPickupLocationID, fReturnLocationID, fPickupDate, fScanCurrencyID, @PriceExceptions),
		fScanDate = [dbo].[getFirstDayOfWeek](fScanDate)

	DELETE FROM #tTempTablePI 
	WHERE fID NOT IN (SELECT min(fID) as fID FROM #tTempTablePI GROUP BY fScanURL, fPickupLocationID, fReturnLocationID, fPickupDate, fReturnDate, fVehicleID, fTotalPrice)


	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	

	Declare @count int, @countmax int, @rowID int, @priceChange decimal(18,2), @thisPrice decimal(18,2), @oldPrice decimal(18,2), @thisScanDate date, @thisURL int,
			@thisTravelCountryID int, @thisPickupLocationID int, @thisReturnLocationID int, @thisPickupDate date, @thisReturnDate date,
			@thisVehicleCompareID int, @thisVehicleID int,  @thisCurrency nvarchar (3), @thisCurrencyID int
	SET @count = 0
	SET @countmax = (select count(fID) from #tTempTablePI)
	-- go through each line and calculate price change
	WHILE @count < @countmax
		BEGIN		
			SET @rowID = @count + 1
			SET @thisScanDate = (SELECT fScanDate FROM #tTempTablePI WHERE fID = @rowID)

			If @thisScanDate  =  @DataSetDateStartSDT
				BEGIN
					SET @thisPrice = (SELECT fTotalPrice FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisURL = (SELECT fScanURL FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisTravelCountryID = (SELECT fTravelCountryID FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisPickupLocationID = (SELECT fPickupLocationID FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisReturnLocationID = (SELECT fReturnLocationID FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisPickupDate = (SELECT fPickupDate FROM #tTempTablePI WHERE fID = @rowID)					
					SET @thisReturnDate = (SELECT fReturnDate FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisVehicleCompareID = (SELECT fVehicleCompareID FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisVehicleID = (SELECT fVehicleID FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisCurrency = (SELECT fTotalPriceCurrency FROM #tTempTablePI WHERE fID = @rowID)
					SET @thisCurrencyID = (SELECT fID FROM tRefCurrency WHERE fCurrencyCode = @thisCurrency)

					SET @oldPrice = 
						(	SELECT TOP 1 fTotalPrice FROM #tTempTablePI 
							WHERE	fScanURL  = @thisURL
							AND		fTravelCountryID = @thisTravelCountryID
							AND		fPickupLocationID = @thisPickupLocationID
							AND		fReturnLocationID = @thisReturnLocationID
							AND		fPickupDate = @thisPickupDate
							AND		fReturnDate = @thisReturnDate
							AND		fVehicleCompareID = @thisVehicleCompareID
							AND		fVehicleID = @thisVehicleID
							AND		fScanDate = dateadd(day,-7,@DataSetDateStartSDT)
							ORDER BY fTotalPrice ASC
						)

					SET @priceChange = cast ((@thisPrice - @oldPrice) as decimal(18,2))

					UPDATE #tTempTablePI
					SET fPriceChange = @priceChange,
						fOldPrice = @oldPrice,
						fOldPriceUpdated = [dbo].[convertPriceByExceptions](@oldPrice, @thisURL, @thisVehicleID, @thisTravelCountryID, @thisPickupLocationID, @thisReturnLocationID, @thisPickupDate, @thisCurrencyID, @PriceExceptions),
					    fOldPriceCurrency = @thisCurrency,
					    fOldPriceModifiers = [dbo].[getListPriceExceptionsAsString](@oldPrice, @thisURL, @thisVehicleID, @thisTravelCountryID, @thisPickupLocationID, @thisReturnLocationID, @thisPickupDate, @thisCurrencyID, @PriceExceptions) 
					WHERE fID = @rowID
					
				END
			SET @count = @count + 1
		END

	--remove old values
	DELETE fROM #tTempTablePI
	WHERE fScanDate = dateadd(day,-7,@DataSetDateStartSDT)
	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	-- get the dates from the main table
	DECLARE @dateOne nvarchar(20), @dateTwo nvarchar(20), @dateThree nvarchar(20), @dateFour nvarchar(20), @dateFive nvarchar(20), @dateSix nvarchar(20), @dateSeven nvarchar(20), @dateEight nvarchar(20), @dateNine nvarchar(20), @dateTen nvarchar(20)
	SET @dateOne =		CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI ORDER BY fPickupDate asc),6)
	SET @dateTwo =		CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateOne ORDER BY fPickupDate asc),6)
	SET @dateThree =	CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateTwo ORDER BY fPickupDate asc),6)
	SET @dateFour =		CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateThree ORDER BY fPickupDate asc),6)
	SET @dateFive =		CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateFour ORDER BY fPickupDate asc),6)
	SET @dateSix =		CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateFive ORDER BY fPickupDate asc),6)
	SET @dateSeven =	CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateSix ORDER BY fPickupDate asc),6)
	SET @dateEight =	CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateSeven ORDER BY fPickupDate asc),6)			
	SET @dateTen =		CONVERT(VARCHAR(11),(SELECT top 1 fPickupDate as fPickupDate from #tTempTablePI WHERE fPickupDate > @dateNine ORDER BY fPickupDate asc),6)

	--get list of sections in report
	DECLARE @sectionList TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fVehicleID int, fVehicleCompareID int, fPickupDate date, fPickupLocation int, fReturnLocation int)
	INSERT INTO @sectionList (fVehicleID, fVehicleCompareID, fPickupDate, fPickupLocation, fReturnLocation)
	SELECT DISTINCT fVehicleID, fVehicleCompareID, fPickupDate, fPickupLocationID, fReturnLocationID
	FROM #tTempTablePI

	--declare variables for where
	DECLARE @countI int, @countRow int, @rowCountry int, @rowPickupLocation int, @rowReturnLocation int, @rowPickupDate date, @rowReturnDate date, @rowVehicle int, @rowVehicleCompare int, @rowVehicleID int, @minPrice decimal(18,2), @rowURL int, @countEqualMins int, @thisTotalPrice  decimal(18,2)
	SET @countI = 1
	SET @countRow = (SELECT count(fID) from @sectionList ) --ORDER BY fID DESC)

	-- go through each line and mark as inactive if it is not the smallest value (compared to other agents for the same vehicle/date/location combos)
	WHILE @countI < @countRow
		BEGIN
			
			SET @rowVehicle =			(SELECT fVehicleID FROM @sectionList WHERE fID = @countI)
			SET @rowVehicleCompare =	(SELECT fVehicleCompareID FROM @sectionList WHERE fID = @countI)
			SET @rowPickupDate =		(SELECT [fPickupDate]	  FROM @sectionList WHERE fID = @countI)
			SET @rowPickupLocation =	(SELECT [fPickupLocation] FROM @sectionList WHERE fID = @countI)
			SET @rowReturnLocation =	(SELECT [fReturnLocation] FROM @sectionList WHERE fID = @countI)

			SET @minPrice = (100000)
			SET @minPrice = (SELECT TOP 1 fTotalPrice as fTotalPrice
								FROM #tTempTablePI 
								WHERE fVehicleCompareID = @rowVehicleCompare
								AND fVehicleID = @rowVehicle
								AND fPickupDate = @rowPickupDate
								AND [fPickupLocationID] = @rowPickupLocation
								AND [fReturnLocationID] = @rowReturnLocation
								AND NOT fTotalPrice = 0
								ORDER BY fTotalPrice ASC
							)

			UPDATE #tTempTablePI
			SET fActive =
				CASE
					WHEN (fVehicleID = fVehicleCompareID AND fScanURL = @ScanURL) 
						THEN 1
					WHEN (fTotalPrice = @minPrice)
						THEN CASE
							WHEN (fPickupDate = cast(@dateOne as date))
								THEN 1
							WHEN (fPickupDate > cast(@dateOne as date))
								THEN 3
							ELSE 0
						END		
					ELSE 0
				END
			WHERE fVehicleCompareID = @rowVehicleCompare
				AND fVehicleID = @rowVehicle
				AND [fPickupDate] = @rowPickupDate
				AND [fPickupLocationID] = @rowPickupLocation
				AND [fReturnLocationID] = @rowReturnLocation
				AND NOT fTotalPrice = 0

			SET @countI = @countI + 1
		END
	
	SET @countI = 1	

			
	-- combine table repetitively to get data
	SELECT   tMain.fScanID	
			,tMain.fScanURL		
			,tW.fWebsiteName
			,tC.fCountryName	
			,concat(tPL.fLocationName,' - ', tRL.fLocationName) as fLocationCombination
			,tV.fVehicleTwoBrandID as fVehicleBrandID
			,replace(tV.fVehicleTwoName,' Berth','B') as fVehicleName
			,replace(tV.fVehicleOneName,' Berth','B') as fVehicleCompareName
			,ISNULL(tV.fVehicleTwoID,0) as fVehicleID
			,ISNULL(tV.fVehicleOneID,0) as fVehicleComparisonID

			,ISNULL(tFirstDate.fActive,0) as fFirstActive
			,ISNULL(tSecondDate.fActive,0) as fSecondActive
			,ISNULL(tThirdDate.fActive,0) as fThirdActive
			,ISNULL(tFourthDate.fActive,0) as fFourthActive
			,ISNULL(tFifthDate.fActive,0) as fFifthActive
			,ISNULL(tSixthDate.fActive,0) as fSixthActive
			,ISNULL(tSeventhDate.fActive,0) as fSeventhActive
			,ISNULL(tEighthDate.fActive,0) as fEighthActive
			,ISNULL(tNinthDate.fActive,0) as fNinthActive
			,ISNULL(tTenthDate.fActive,0) as fTenthActive




			,@dateOne as fFirstDate
			,ISNULL(tFirstDate.fTotalPrice,0) as fFirstPrice
			,ISNULL(tFirstDate.fTotalPriceUpdated,0) as fFirstPriceUpdated 
			,ISNULL(tFirstDate.fTotalPriceCurrency,'N/A') as fFirstPriceCurrency 
			,ISNULL(tFirstDate.fTotalPriceModifiers,'N/A') as fFirstPriceModifiers 
			,ISNULL(tFirstDate.fOldPrice,0) as fFirstOldPrice
			,ISNULL(tFirstDate.fOldPriceUpdated,0) as fFirstOldPriceUpdated 
			,ISNULL(tFirstDate.fOldPriceCurrency,'N/A') as fFirstOldPriceCurrency 
			,ISNULL(tFirstDate.fOldPriceModifiers,'N/A') as fFirstOldPriceModifiers 
			,ISNULL(tFirstDate.fPriceChange,0) as fFirstPriceChange
			,ISNULL(concat('firstPrice ',[dbo].[getClassNameTableForPriceIncrease](tFirstDate.fTotalPrice, tFirstDate.fOldPrice, tFirstDate.fPriceChange)),'') as fFirstClass
			,@dateTwo as fSecondDate
			,ISNULL(tSecondDate.fTotalPrice,0) as fSecondPrice
			,ISNULL(tSecondDate.fTotalPriceUpdated,0) as fSecondPriceUpdated 
			,ISNULL(tSecondDate.fTotalPriceCurrency,'N/A') as fSecondPriceCurrency 
			,ISNULL(tSecondDate.fTotalPriceModifiers,'N/A') as fSecondPriceModifiers 
			,ISNULL(tSecondDate.fOldPrice,0) as fSecondOldPrice
			,ISNULL(tSecondDate.fOldPriceUpdated,0) as fSecondOldPriceUpdated 
			,ISNULL(tSecondDate.fOldPriceCurrency,'N/A') as fSecondOldPriceCurrency 
			,ISNULL(tSecondDate.fOldPriceModifiers,'N/A') as fSecondOldPriceModifiers 
			,ISNULL(tSecondDate.fPriceChange,0) as fSecondPriceChange
			,ISNULL(concat('firstPrice ',[dbo].[getClassNameTableForPriceIncrease](tSecondDate.fTotalPrice, tSecondDate.fOldPrice, tSecondDate.fPriceChange)),'') as  fSecondClass
			,@dateThree as fThirdDate
			,ISNULL(tThirdDate.fTotalPrice,0) as fThirdPrice
			,ISNULL(tThirdDate.fTotalPriceUpdated,0) as fThirdPriceUpdated 
			,ISNULL(tThirdDate.fTotalPriceCurrency,'N/A') as fThirdPriceCurrency 
			,ISNULL(tThirdDate.fTotalPriceModifiers,'N/A') as fThirdPriceModifiers 
			,ISNULL(tThirdDate.fOldPrice,0) as fThirdOldPrice
			,ISNULL(tThirdDate.fOldPriceUpdated,0) as fThirdOldPriceUpdated 
			,ISNULL(tThirdDate.fOldPriceCurrency,'N/A') as fThirdOldPriceCurrency 
			,ISNULL(tThirdDate.fOldPriceModifiers,'N/A') as fThirdOldPriceModifiers 
			,ISNULL(tThirdDate.fPriceChange,0) as fThirdPriceChange
			,ISNULL(concat('firstPrice ',[dbo].[getClassNameTableForPriceIncrease](tThirdDate.fTotalPrice, tThirdDate.fOldPrice, tThirdDate.fPriceChange)),'') as fThirdClass
			,@dateFour as fFourthDate
			,ISNULL(tFourthDate.fTotalPrice,0) as fFourthPrice
			,ISNULL(tFourthDate.fTotalPriceUpdated,0) as fFourthPriceUpdated 
			,ISNULL(tFourthDate.fTotalPriceCurrency,'N/A') as fFourthPriceCurrency 
			,ISNULL(tFourthDate.fTotalPriceModifiers,'N/A') as fFourthPriceModifiers 
			,ISNULL(tFourthDate.fOldPrice,0) as fFourthOldPrice
			,ISNULL(tFourthDate.fOldPriceUpdated,0) as fFourthOldPriceUpdated 
			,ISNULL(tFourthDate.fOldPriceCurrency,'N/A') as fFourthOldPriceCurrency 
			,ISNULL(tFourthDate.fOldPriceModifiers,'N/A') as fFourthOldPriceModifiers 
			,ISNULL(tFourthDate.fPriceChange,0) as fFourthPriceChange
			,ISNULL(concat('firstPrice ',[dbo].[getClassNameTableForPriceIncrease](tFourthDate.fTotalPrice, tFourthDate.fOldPrice, tFourthDate.fPriceChange)),'') as fFourthClass
			,@dateFive as fFifthDate
			,ISNULL(tFifthDate.fTotalPrice,0) as fFifthPrice
			,ISNULL(tFifthDate.fTotalPriceUpdated,0) as fFifthPriceUpdated 
			,ISNULL(tFifthDate.fTotalPriceCurrency,'N/A') as fFifthPriceCurrency 
			,ISNULL(tFifthDate.fTotalPriceModifiers,'N/A') as fFifthPriceModifiers 
			,ISNULL(tFifthDate.fOldPrice,0) as fFifthOldPrice
			,ISNULL(tFifthDate.fOldPriceUpdated,0) as fFifthOldPriceUpdated 
			,ISNULL(tFifthDate.fOldPriceCurrency,'N/A') as fFifthOldPriceCurrency 
			,ISNULL(tFifthDate.fOldPriceModifiers,'N/A') as fFifthOldPriceModifiers 
			,ISNULL(tFifthDate.fPriceChange,0) as fFifthPriceChange
			,ISNULL(concat('firstPrice ',[dbo].[getClassNameTableForPriceIncrease](tFifthDate.fTotalPrice, tFifthDate.fOldPrice, tFifthDate.fPriceChange)),'') as  fFifthClass
			,@dateSix as fSixthDate
			,ISNULL(tSixthDate.fTotalPrice,0) as fSixthPrice
			,ISNULL(tSixthDate.fTotalPriceUpdated,0) as fSixthPriceUpdated 
			,ISNULL(tSixthDate.fTotalPriceCurrency,'N/A') as fSixthPriceCurrency 
			,ISNULL(tSixthDate.fTotalPriceModifiers,'N/A') as fSixthPriceModifiers 
			,ISNULL(tSixthDate.fOldPrice,0) as fSixthOldPrice
			,ISNULL(tSixthDate.fOldPriceUpdated,0) as fSixthOldPriceUpdated 
			,ISNULL(tSixthDate.fOldPriceCurrency,'N/A') as fSixthOldPriceCurrency 
			,ISNULL(tSixthDate.fOldPriceModifiers,'N/A') as fSixthOldPriceModifiers 
			,ISNULL(tSixthDate.fPriceChange,0) as fSixthPriceChange
			,ISNULL(concat('firstPrice ',[dbo].[getClassNameTableForPriceIncrease](tSixthDate.fTotalPrice, tSixthDate.fOldPrice, tSixthDate.fPriceChange)),'') as  fSixthClass
			,@dateSeven as fSeventhDate
			,ISNULL(tSeventhDate.fTotalPrice,0) as fSeventhPrice
			,ISNULL(tSeventhDate.fTotalPriceUpdated,0) as fSeventhPriceUpdated 
			,ISNULL(tSeventhDate.fTotalPriceCurrency,'N/A') as fSeventhPriceCurrency 
			,ISNULL(tSeventhDate.fTotalPriceModifiers,'N/A') as fSeventhPriceModifiers 
			,ISNULL(tSeventhDate.fOldPrice,0) as fSeventhOldPrice
			,ISNULL(tSeventhDate.fOldPriceUpdated,0) as fSeventhOldPriceUpdated 
			,ISNULL(tSeventhDate.fOldPriceCurrency,'N/A') as fSeventhOldPriceCurrency 
			,ISNULL(tSeventhDate.fOldPriceModifiers,'N/A') as fSeventhOldPriceModifiers 
			,ISNULL(tSeventhDate.fPriceChange,0) as fSeventhPriceChange
			,ISNULL(concat('firstPrice ',[dbo].[getClassNameTableForPriceIncrease](tSeventhDate.fTotalPrice, tSeventhDate.fOldPrice, tSeventhDate.fPriceChange)),'') as  fSeventhClass
			,@dateEight as fEighthDate
			,ISNULL(tEighthDate.fTotalPrice,0) as fEighthPrice
			,ISNULL(tEighthDate.fTotalPriceUpdated,0) as fEighthPriceUpdated 
			,ISNULL(tEighthDate.fTotalPriceCurrency,'N/A') as fEighthPriceCurrency 
			,ISNULL(tEighthDate.fTotalPriceModifiers,'N/A') as fEighthPriceModifiers 
			,ISNULL(tEighthDate.fOldPrice,0) as fEighthOldPrice
			,ISNULL(tEighthDate.fOldPriceUpdated,0) as fEighthOldPriceUpdated 
			,ISNULL(tEighthDate.fOldPriceCurrency,'N/A') as fEighthOldPriceCurrency 
			,ISNULL(tEighthDate.fOldPriceModifiers,'N/A') as fEighthOldPriceModifiers 
			,ISNULL(tEighthDate.fPriceChange,0) as fEighthPriceChange
			,ISNULL(concat('firstPrice ',[dbo].[getClassNameTableForPriceIncrease](tEighthDate.fTotalPrice, tEighthDate.fOldPrice, tEighthDate.fPriceChange)),'') as  fEighthClass
			,@dateNine as fNinthDate
			,ISNULL(tNinthDate.fTotalPrice,0) as fNinthPrice
			,ISNULL(tNinthDate.fTotalPriceUpdated,0) as fNinthPriceUpdated 
			,ISNULL(tNinthDate.fTotalPriceCurrency,'N/A') as fNinthPriceCurrency 
			,ISNULL(tNinthDate.fTotalPriceModifiers,'N/A') as fNinthPriceModifiers 
			,ISNULL(tNinthDate.fOldPrice,0) as fNinthOldPrice
			,ISNULL(tNinthDate.fOldPriceUpdated,0) as fNinthOldPriceUpdated 
			,ISNULL(tNinthDate.fOldPriceCurrency,'N/A') as fNinthOldPriceCurrency 
			,ISNULL(tNinthDate.fOldPriceModifiers,'N/A') as fNinthOldPriceModifiers 
			,ISNULL(tNinthDate.fPriceChange,0) as fNinthPriceChange
			,ISNULL(concat('firstPrice ',[dbo].[getClassNameTableForPriceIncrease](tNinthDate.fTotalPrice, tNinthDate.fOldPrice, tNinthDate.fPriceChange)),'') as  fNinthClass
			,@dateTen as fTenthDate
			,ISNULL(tTenthDate.fTotalPrice,0) as fTenthPrice
			,ISNULL(tTenthDate.fTotalPriceUpdated,0) as fTenthPriceUpdated 
			,ISNULL(tTenthDate.fTotalPriceCurrency,'N/A') as fTenthPriceCurrency 
			,ISNULL(tTenthDate.fTotalPriceModifiers,'N/A') as fTenthPriceModifiers 
			,ISNULL(tTenthDate.fOldPrice,0) as fTenthOldPrice
			,ISNULL(tTenthDate.fOldPriceUpdated,0) as fTenthOldPriceUpdated 
			,ISNULL(tTenthDate.fOldPriceCurrency,'N/A') as fTenthOldPriceCurrency 
			,ISNULL(tTenthDate.fOldPriceModifiers,'N/A') as fTenthOldPriceModifiers
			,ISNULL(tTenthDate.fPriceChange,0) as fTenthPriceChange
			,ISNULL(concat('tenthPrice ',[dbo].[getClassNameTableForPriceIncrease](tTenthDate.fTotalPrice, tTenthDate.fOldPrice, tTenthDate.fPriceChange)),'') as  fTenthClass

	 from (	 
	 SELECT min(fScanID) as fScanID
			,fScanURL		
			,fTravelCountryID
			,fPickupLocationID
			,fReturnLocationID
			,fVehicleCompareID
			,fVehicleID
	FROM #tTempTablePI 	 
	GROUP BY fScanURL		
			,fTravelCountryID
			,fPickupLocationID
			,fReturnLocationID
			,fVehicleCompareID
			,fVehicleID
	 
	 )as tMain 
	LEFT JOIN tRefLocation as tPL on tPL.fID = tMain.fPickupLocationID
	LEFT JOIN tRefLocation as tRL on tRL.fID = tMain.fReturnLocationID
	LEFT JOIN tRefCountry as tC on tC.fID = tMain.fTravelCountryID	
	LEFT JOIN @tVehicleEqiv as tV on tV.fVehicleTwoID = tMain.fVehicleID
	LEFT JOIN tRefBrand as tVCB on tVCB.fID =  tV.fVehicleTwoBrandID
	LEFT JOIN tRefWebsite as tW on tW.fID = tMain.fScanURL
	
	LEFT Join #tTempTablePI as tFirstDate on 
		(	tMain.fScanURL = tFirstDate.fScanURL
		AND tMain.fTravelCountryID = tFirstDate.fTravelCountryID
		AND tMain.fPickupLocationID = tFirstDate.fPickupLocationID
		AND tMain.fReturnLocationID = tFirstDate.fReturnLocationID
		AND tMain.fVehicleID = tFirstDate.fVehicleID
		AND tFirstDate.fPickupDate = @dateOne
		)

	LEFT Join #tTempTablePI as tSecondDate on 
		(	tMain.fScanURL = tSecondDate.fScanURL
		AND tMain.fTravelCountryID = tSecondDate.fTravelCountryID
		AND tMain.fPickupLocationID = tSecondDate.fPickupLocationID
		AND tMain.fReturnLocationID = tSecondDate.fReturnLocationID
		AND tMain.fVehicleCompareID = tSecondDate.fVehicleCompareID
		AND tMain.fVehicleID = tSecondDate.fVehicleID
		AND tSecondDate.fPickupDate = @dateTwo
		)
	LEFT Join #tTempTablePI as tThirdDate on 
		(	tMain.fScanURL = tThirdDate.fScanURL
		AND tMain.fTravelCountryID = tThirdDate.fTravelCountryID
		AND tMain.fPickupLocationID = tThirdDate.fPickupLocationID
		AND tMain.fReturnLocationID = tThirdDate.fReturnLocationID
		AND tMain.fVehicleCompareID = tThirdDate.fVehicleCompareID
		AND tMain.fVehicleID = tThirdDate.fVehicleID
		AND tThirdDate.fPickupDate = @dateThree
		)
	LEFT Join #tTempTablePI as tFourthDate on 
		(	tMain.fScanURL = tFourthDate.fScanURL
		AND tMain.fTravelCountryID = tFourthDate.fTravelCountryID
		AND tMain.fPickupLocationID = tFourthDate.fPickupLocationID
		AND tMain.fReturnLocationID = tFourthDate.fReturnLocationID
		AND tMain.fVehicleCompareID = tFourthDate.fVehicleCompareID
		AND tMain.fVehicleID = tFourthDate.fVehicleID
		AND tFourthDate.fPickupDate = @dateFour
		)
	LEFT Join #tTempTablePI as tFifthDate on 
		(	tMain.fScanURL = tFifthDate.fScanURL
		AND tMain.fTravelCountryID = tFifthDate.fTravelCountryID
		AND tMain.fPickupLocationID = tFifthDate.fPickupLocationID
		AND tMain.fReturnLocationID = tFifthDate.fReturnLocationID
		AND tMain.fVehicleCompareID = tFifthDate.fVehicleCompareID
		AND tMain.fVehicleID = tFifthDate.fVehicleID
		AND tFifthDate.fPickupDate = @dateFive 
		)
	LEFT Join #tTempTablePI as tSixthDate on 
		(	tMain.fScanURL = tSixthDate.fScanURL
		AND tMain.fTravelCountryID = tSixthDate.fTravelCountryID
		AND tMain.fPickupLocationID = tSixthDate.fPickupLocationID
		AND tMain.fReturnLocationID = tSixthDate.fReturnLocationID
		AND tMain.fVehicleCompareID = tSixthDate.fVehicleCompareID
		AND tMain.fVehicleID = tSixthDate.fVehicleID
		AND tSixthDate.fPickupDate = @dateSix
		)
	LEFT Join #tTempTablePI as tSeventhDate on 
		(	tMain.fScanURL = tSeventhDate.fScanURL
		AND tMain.fTravelCountryID = tSeventhDate.fTravelCountryID
		AND tMain.fPickupLocationID = tSeventhDate.fPickupLocationID
		AND tMain.fReturnLocationID = tSeventhDate.fReturnLocationID
		AND tMain.fVehicleCompareID = tSeventhDate.fVehicleCompareID
		AND tMain.fVehicleID = tSeventhDate.fVehicleID
		AND tSeventhDate.fPickupDate = @dateSeven
		)
	LEFT Join #tTempTablePI as tEighthDate on 
		(	tMain.fScanURL = tEighthDate.fScanURL
		AND tMain.fTravelCountryID = tEighthDate.fTravelCountryID
		AND tMain.fPickupLocationID = tEighthDate.fPickupLocationID
		AND tMain.fReturnLocationID = tEighthDate.fReturnLocationID
		AND tMain.fVehicleCompareID = tEighthDate.fVehicleCompareID
		AND tMain.fVehicleID = tEighthDate.fVehicleID
		AND tEighthDate.fPickupDate = @dateEight
		)
	LEFT Join #tTempTablePI as tNinthDate on 
		(	tMain.fScanURL = tNinthDate.fScanURL
		AND tMain.fTravelCountryID = tNinthDate.fTravelCountryID
		AND tMain.fPickupLocationID = tNinthDate.fPickupLocationID
		AND tMain.fReturnLocationID = tNinthDate.fReturnLocationID
		AND tMain.fVehicleCompareID = tNinthDate.fVehicleCompareID
		AND tMain.fVehicleID = tNinthDate.fVehicleID
		AND tNinthDate.fPickupDate = @dateNine
		)
	LEFT Join #tTempTablePI as tTenthDate on 
		(	tMain.fScanURL = tTenthDate.fScanURL
		AND tMain.fTravelCountryID = tTenthDate.fTravelCountryID
		AND tMain.fPickupLocationID = tTenthDate.fPickupLocationID
		AND tMain.fReturnLocationID = tTenthDate.fReturnLocationID
		AND tMain.fVehicleCompareID = tTenthDate.fVehicleCompareID
		AND tMain.fVehicleID = tTenthDate.fVehicleID
		AND tTenthDate.fPickupDate = @dateTen
		)
		
	WHERE	(NOT (		(ISNULL(tFirstDate.fTotalPrice,0) = 0)
					AND (ISNULL(tSecondDate.fTotalPrice,0) = 0)
					AND (ISNULL(tThirdDate.fTotalPrice,0) = 0)
					AND (ISNULL(tFourthDate.fTotalPrice,0) = 0)
					AND (ISNULL(tFifthDate.fTotalPrice,0) = 0)
					AND (ISNULL(tSixthDate.fTotalPrice,0) = 0)
					AND (ISNULL(tSeventhDate.fTotalPrice,0) = 0)
					AND (ISNULL(tEighthDate.fTotalPrice,0) = 0)
					AND (ISNULL(tNinthDate.fTotalPrice,0) = 0)
					AND (ISNULL(tTenthDate.fTotalPrice,0) = 0)
				 )
			)
	AND (tFirstDate.fActive > 0 OR (tMain.fScanURL = @ScanURL AND tMain.fVehicleCompareID = tMain.fVehicleID))
	
	ORDER BY tC.fCountryName
			,fLocationCombination
			,tV.fVehicleOneName
			,tFirstDate.fScanURL	
			,tVCB.fBrandOrderPriceIncrease
			,tV.fVehicleTwoName
				
	--select and get rid of original table
	DELETE FROM #tTempTablePI



END


GO
/****** Object:  StoredProcedure [dbo].[getScanDataCleanByFiltersVehicleCompareSnapshot]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <17/03/15>
-- Description:	<Get data from clean data table>
-- =============================================
CREATE PROCEDURE [dbo].[getScanDataCleanByFiltersVehicleCompareSnapshot]
  @quickReportNumber int
, @DataSetDateStart nvarchar(MAX)
, @TravelDateRanges nvarchar(MAX)
, @CountryID int
, @BrandID int
, @PickupReturnLocationComboID nvarchar(max) 
, @LicenceCountryID int
, @ScanURLs nvarchar(max) 
, @PriceExceptions int
, @rateOption int                     -- 1 = rate for full travel period, 2 = average daily rate
, @selectApolloFamilyVehicles int
, @showPercentOrPrice int             --percent = 1, price = 2
 
AS
BEGIN	

	If Not @quickReportNumber = 0
		BEGIN
			SET @DataSetDateStart = (SELECT TOP 1 [dbo].[getFirstDayOfWeek](dateadd(d,1,fScanDate)) FROM tDataScanClean ORDER BY fID DESC)
			SET @TravelDateRanges = (SELECT fQuickReportTravelDates FROM tRefQuickReport WHERE fID = @quickReportNumber)
			SET @CountryID = (SELECT fQuickReportCountryID FROM tRefQuickReport WHERE fID = @quickReportNumber)
			SET @BrandID = (SELECT fQuickReportBrandID FROM tRefQuickReport WHERE fID = @quickReportNumber)
			SET @PickupReturnLocationComboID = (SELECT fQuickReportLocationCombo FROM tRefQuickReport WHERE fID = @quickReportNumber)
			SET @LicenceCountryID = (SELECT fQuickReportLicenceCountry FROM tRefQuickReport WHERE fID = @quickReportNumber)
			SET @ScanURLs = (SELECT fQuickReportScanURLs FROM tRefQuickReport WHERE fID = @quickReportNumber)
			SET @PriceExceptions = (SELECT fQuickReportPriceExceptions FROM tRefQuickReport WHERE fID = @quickReportNumber)
			SET @rateOption = (SELECT fQuickReportRateOption FROM tRefQuickReport WHERE fID = @quickReportNumber)                     
			SET @selectApolloFamilyVehicles = (SELECT fQuickReportApolloFamilyOnly FROM tRefQuickReport WHERE fID = @quickReportNumber)
			SET @showPercentOrPrice = (SELECT fQuickReportPercentOrPrice FROM tRefQuickReport WHERE fID = @quickReportNumber)
		END 
			
	DECLARE 
	 @DataSetSDT smalldatetime
	,@DataSetDateStartSDT smalldatetime
	,@URLcount int
	,@firstDataSet int

	--get urls in order
	DECLARE @URLtable TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fURL int)
	SET @ScanURLs = concat(@ScanURLs,';')
	WHILE CHARINDEX(';', @ScanURLs) > 0 
	BEGIN
		DECLARE @tmpstr VARCHAR(50)
		 SET @tmpstr = SUBSTRING(@ScanURLs, 1, ( CHARINDEX(';', @ScanURLs) - 1 ))

		INSERT INTO @URLtable (fURL)
		VALUES  (@tmpstr)   
		SET @ScanURLs = SUBSTRING(@ScanURLs, CHARINDEX(';', @ScanURLs) + 1, LEN(@ScanURLs))
	END
	SET @URLcount = (select count(furl) from @URLtable)

--SELECT * FROM @URLtable
	
	--get wk beginning date of selected data set
	SET @DataSetDateStartSDT = 
	CASE 
		WHEN  (@DataSetDateStart = 'NULL' OR @DataSetDateStart is Null)
			THEN CONVERT(SMALLDATETIME, '2000-01-01 00:00:01')
		ELSE
			CONVERT(SMALLDATETIME, @DataSetDateStart)
	END
	
    -- temp table of dates in this report
	DECLARE @tDates TABLE (fldID int IDENTITY(1,1) PRIMARY KEY, fScanPickupDate smalldatetime, fScanReturnDate smalldatetime, fTravelDates nvarchar(max), fTravelDatesShort nvarchar(max), fActive int)
	INSERT INTO @tDates (fScanPickupDate, fScanReturnDate, fTravelDates, fTravelDatesShort, fActive)
	SELECT 	fScanPickupDate, fScanReturnDate, 
			(CONCAT( CONVERT(VARCHAR(11),fScanPickupDate,6) , ' - ' , CONVERT(VARCHAR(11),fScanReturnDate,6))) As fTravelDates	,
			(CONCAT( CONVERT(VARCHAR(10),fScanPickupDate) , ',' , CONVERT(VARCHAR(10),fScanReturnDate))) As fTravelDatesShort	,
			1
	FROM (
		SELECT DISTINCT fScanPickupDate, fScanReturnDate
		FROM tDataScanClean
		WHERE (fScanDate >=  dateadd(day,-1,@DataSetDateStartSDT)) and (fScanDate <=  dateadd(day, 6,@DataSetDateStartSDT) )	
	) as tMain
	ORDER BY fScanPickupDate ASC
	
	If Not @quickReportNumber = 0
		BEGIN
			DECLARE @countDates int, @maxDates int

			If cast(@TravelDateRanges as int) in (1,2,3,4,5,6,7,8,9,10)
				BEGIN
					SET @countDates = 2
					SET @maxDates = cast(@TravelDateRanges as int)
					--first date
					SET @TravelDateRanges = (SELECT fTravelDatesShort FROM @tDates WHERE fldID = 1)
					-- add any other dates
					WHILE @countDates <= @maxDates
						BEGIN
							SET @TravelDateRanges = concat(@TravelDateRanges,';',(SELECT fTravelDatesShort FROM @tDates WHERE fldID = @countDates))
							SET @countDates = @countDates + 1
						END
				END 
		END 
	
	--create list of location combinations
	DECLARE @locationCombinationsTAB TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fPickupLocationID int, fReturnLocationID int)
	INSERT INTO @locationCombinationsTAB (fPickupLocationID, fReturnLocationID)
	SELECT substring(string,1,charindex('-',string)-1), reverse(substring(reverse(string),0,charindex('-',reverse(string)))) 
	FROM (SELECT Split.a.value('.', 'VARCHAR(100)') AS String from (SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](@PickupReturnLocationComboID), ';', '</M><M>') + '</M>' AS XML) AS String ) AS a CROSS APPLY String.nodes ('/M') AS Split(a)) as t
	
	--get country this report is for
	DECLARE @locCountryID int
	SET @locCountryID =
		CASE
			WHEN @countryID = 0
			THEN (select fCountryID from tRefLocation WHERE fID = (SELECT top 1 fPickupLocationID from @locationCombinationsTAB))
			ELSE @locCountryID
		END
	--add combinations where "all return locations" was selected for a specific pickup location
	INSERT INTO @locationCombinationsTAB (fPickupLocationID, fReturnLocationID)
	SELECT t.fPickupLocationID, tR.fID FROM @locationCombinationsTAB t
	CROSS JOIN (SELECT fID from tRefLocation WHERE fCountryID = @countryID) tR	
	WHERE fReturnLocationID = 0
	--add combinations where "all pickup locations" was selected for a specific return location
	INSERT INTO @locationCombinationsTAB (fPickupLocationID, fReturnLocationID)
	SELECT tP.fID, tR.fReturnLocationID FROM (SELECT fID from tRefLocation WHERE fCountryID = @countryID) tP
	CROSS JOIN (SELECT fReturnLocationID FROM @locationCombinationsTAB WHERE fPickupLocationID = 0) tR
	--remove unnecessary lines
	DELETE FROM @locationCombinationsTAB
	WHERE fPickupLocationID = 0 or fReturnLocationID = 0

--sELECT * FROM @locationCombinationsTAB

	--create list of travel date ranges
	DECLARE @travelDatesFilterTAB TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fPickupDate date, fReturnDate date)
	INSERT INTO @travelDatesFilterTAB (fPickupDate, fReturnDate)
	SELECT substring(string,1,charindex(',',string)-1), reverse(substring(reverse(string),0,charindex(',',reverse(string)))) 
	FROM (SELECT Split.a.value('.', 'VARCHAR(100)') AS String from (SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](@TravelDateRanges), ';', '</M><M>') + '</M>' AS XML) AS String ) AS a CROSS APPLY String.nodes ('/M') AS Split(a)) as t
			
		
--SELECT * FROM @travelDatesFilterTAB

	-- Get list of data sets	
	DECLARE @tDataSets TABLE (fldID int IDENTITY(1,1) PRIMARY KEY, fScanDate smalldatetime, fYear nvarchar(50))	
    -- Insert into temp table 
	INSERT INTO @tDataSets (fScanDate, fYear)
	exec getFinancialYearListWeeksAndDates	
	--remove old dates
	DELETE FROM @tDataSets WHERE fScanDate <= (SELECT TOP 1 fFirstDate FROM tRefFirstDate)
	DELETE FROM @tDataSets WHERE fScanDate > @DataSetDateStartSDT

--SELECT * FROM @tDataSets

	DECLARE @tLicenceCountryCode TABLE (fldID int IDENTITY(1,1) PRIMARY KEY, NatOrInternational int, LicenceCounrtyID int, websiteID int, travelCountry int)
	INSERT INTO @tLicenceCountryCode(NatOrInternational, LicenceCounrtyID, websiteID, travelCountry)
	SELECT 1, [fDomLicenceCountryID], [fWebsiteID], [fTravelCountryID]
	FROM [comparison].[dbo].[tRefDriversLicenceCodes]  
	INSERT INTO @tLicenceCountryCode(NatOrInternational, LicenceCounrtyID, websiteID, travelCountry)
	SELECT 2, [fIntLicenceCountryID], [fWebsiteID], [fTravelCountryID]
	FROM [comparison].[dbo].[tRefDriversLicenceCodes]  
					
	DELETE FROM @tLicenceCountryCode WHERE Not @LicenceCountryID = NatOrInternational

	-- Set the most recent data set to be included
	SET @firstDataSet = (SELECT min(fldID) FROM @tDataSets)
	
	--get required data set into temp table
	IF OBJECT_ID('tempdb..#tTempTable') IS NOT NULL
	/*Then it exists*/
	DROP TABLE #tTempTable
	CREATE TABLE #tTempTable (
		fID int IDENTITY(1,1) PRIMARY KEY
		,fScanID int
		,fScanDate smalldatetime
		,fScanURL int
		,fScanTravelCountryID int
		,fScanPickupLocationID int
		,fScanReturnLocationID int
		,fScanPickupDate smalldatetime
		,fScanReturnDate smalldatetime
		,fVehicleCategoryID int
		,fScanLicenceCountryID int
		,fScanBrandID int
		,fScanVehicleID int
		,fScanTotalPrice decimal(18,2)
		,fScanOriginalPrice decimal(18,2)
		,fScanCurrencyID int
	)
	
	-- main data
	INSERT INTO #tTempTable
	SELECT	
		MIN(tTemp.fScanID) as fScanID
		,[dbo].[getFirstDayOfWeek](tTemp.fScanDate)
		,tTemp.[fScanURL]
		,tTemp.[fScanTravelCountryID]
		,tTemp.[fScanPickupLocationID]
		,tTemp.[fScanReturnLocationID]
		,tTemp.[fScanPickupDate]
		,tTemp.[fScanReturnDate]
		,tV.fVehicleCategoryID
		,tTemp.[fScanLicenceCountryID]
		,tTemp.[fScanBrandID]
		,tTemp.fScanVehicleID
		,min([dbo].[convertPriceByExceptions](cast([dbo].[convertPriceToCurrency](fScanTotalPrice, fScanCurrencyID, fScanDate, fScanTravelCountryID) as decimal(18,2)), fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions))  as fScanTotalPrice
		,ABS(min(tTemp.fScanTotalPrice))
		,tTemp.[fScanCurrencyID]	
	from tDataScanClean as tTemp
	INNER JOIN @locationCombinationsTAB as tL on tL.fPickupLocationID = tTemp.[fScanPickupLocationID] AND  tL.fReturnLocationID = tTemp.[fScanReturnLocationID]
	INNER JOIN tRefVehicle as tV on tV.fID = tTemp.fScanVehicleID
	INNER JOIN @tLicenceCountryCode as tLC on tTemp.fScanLicenceCountryID = tLC.LicenceCounrtyID AND tTemp.[fScanTravelCountryID] = travelCountry AND tTemp.[fScanURL] = tLC.websiteID
	WHERE 
		(tTemp.fScanDate >= @DataSetDateStartSDT AND tTemp.fScanDate <= DATEADD(day,7,@DataSetDateStartSDT) OR @DataSetDateStart = 'NULL' OR @DataSetDateStart is Null )
		AND (fScanURL in (SELECT fURL FROM @URLtable))
		AND ((@TravelDateRanges = '2000-01-01,2000-01-01' AND tTemp.fScanPickupDate in (SELECT fScanPickupDate FROM @tDates))
				OR 
				(tTemp.fScanPickupDate in (SELECT fPickupDate FROM @travelDatesFilterTAB) AND  tTemp.fScanReturnDate in (SELECT fReturnDate FROM @travelDatesFilterTAB WHERE tTemp.fScanPickupDate = fPickupDate))
		)
		AND (@BrandID = 0 OR (tTemp.fScanBrandID = @BrandID OR tTemp.fScanVehicleID in (SELECT fVehicleTwoID FROM tRefVehicleEquivalent)))
		AND (@CountryID = 0 OR tTemp.fScanTravelCountryID = @CountryID)
		AND (tTemp.fScanVehicleID in (select fID FROM tRefVehicle WHERE NOT fVehicleCategoryID is NULL))
		AND (@selectApolloFamilyVehicles = 0 or tTemp.fScanBrandID in (select fid from tRefBrand WHERE fBrandIsApolloFamily = 1))
	GROUP BY tTemp.[fScanDate]
		,tTemp.[fScanURL]
		,tTemp.[fScanTravelCountryID]
		,tTemp.[fScanPickupLocationID]
		,tTemp.[fScanReturnLocationID]
		,tTemp.[fScanPickupDate] 
		,tTemp.[fScanReturnDate] 
		,tV.fVehicleCategoryID
		,tTemp.[fScanLicenceCountryID]
		,tTemp.[fScanBrandID]
		,tTemp.[fScanVehicleID]
		,tTemp.[fScanTotalPrice]
		,tTemp.[fScanCurrencyID]	
	ORDER BY    tTemp.[fScanTravelCountryID], tV.fVehicleCategoryID,tTemp.[fScanBrandID],tTemp.fScanVehicleID
	
		
	--change figures to daily rate if that's required.
	--get percentage comparison against main vehicle in that category/etc combination
	DECLARE @totalCount1 int, @thisCount1 int, @thisPrice decimal(18,2), @thisOriginalPrice decimal(18,2), @travelPeriodCount int
	SET @totalCount1 = (SELECT count(fid) FROM #tTempTable)
	SET @thisCount1 = 1

	WHILE @thisCount1 <= @totalCount1
		BEGIN
			SET @thisPrice = (SELECT fScanTotalPrice FROM #tTempTable WHERE fID = @thisCount1 )
			SET @thisOriginalPrice =  (SELECT fScanOriginalPrice FROM #tTempTable WHERE fID = @thisCount1 )
			SET @travelPeriodCount = cast((DATEDIFF(d,(SELECT fScanPickupDate FROM #tTempTable WHERE fID = @thisCount1 ),(SELECT fScanReturnDate FROM #tTempTable WHERE fID = @thisCount1 ))) as int) + 1
			
			SET @thisPrice = 
				CASE	
					WHEN @rateOption = 2
					THEN cast((@thisPrice/@travelPeriodCount) as decimal(18,2))
					ELSE @thisPrice
				END
			SET @thisOriginalPrice  = 
				CASE	
					WHEN @rateOption = 2
					THEN cast((@thisOriginalPrice/@travelPeriodCount) as decimal(18,2))
					ELSE @thisOriginalPrice
				END

			--update main table
			UPDATE #tTempTable 
				SET fScanTotalPrice = @thisPrice
				   ,fScanOriginalPrice = @thisOriginalPrice
			WHERE fID = @thisCount1
			
			-- iterate count
			SET @thisCount1 = @thisCount1 + 1
		END
	  	  

	--get vehicles that are listed as having required report categories
	IF OBJECT_ID('tempdb..#Vehicletable') IS NOT NULL
	/*Then it exists*/
	DROP TABLE #Vehicletable
	/* create fresh table */
	CREATE TABLE #Vehicletable (fID int IDENTITY(1,1) PRIMARY KEY, fVehicleCountID int, fVehicleID int, fBrandName nvarchar(200), fBrandOrder int, fVehicleName nvarchar(200), fVehicleCategoryID int)
	--fill table with data
	INSERT INTO #Vehicletable (fVehicleID, fBrandName, fBrandOrder, fVehicleName, fVehicleCategoryID)
	SELECT tV.fID, tB.fBrandName, tB.fBrandOrderSnapshot, tV.fVehicleName, fVehicleCategoryID FROM tRefVehicle as tV
	INNER JOIN tRefBrand as tB on tB.fID = tV.fVehicleBrandID
	WHERE tV.fID in (SELECT fScanVehicleID FROM #tTempTable)
	ORDER BY fVehicleCategoryID, tB.fBrandOrderSnapshot, fVehicleBrandID
		


--SELECT * FROM #Vehicletable

--SELECT * FROM #tTempTable


	 
	--get required data set into temp table
	IF OBJECT_ID('tempdb..#tTempTableLarge') IS NOT NULL
	/*Then it exists*/
	DROP TABLE #tTempTableLarge
	--create variables needed in table
	DECLARE @web1 int, @web2 int
	SET @web1 = IsNull((SELECT fURL FROM @URLtable WHERE fID = 1),0)
	SET @web2 = IsNull((SELECT fURL FROM @URLtable WHERE fID = 2),0)
	
	--create table
	CREATE TABLE #tTempTableLarge (
		fID int IDENTITY(1,1) PRIMARY KEY
		,fScanID int
		--,fLinkURL nvarchar(max) 
		,fCountryID int
		,fPickupLocationID int
		,fReturnLocationID int
		,fBrandID int
		,fVehicleID int
		,fPickupDate date
		,fReturnDate date
		--,fTravelDates nvarchar(max)
		,fMainWebsiteID int
		--,fVehicleCategoryName int
		,fVehicleCategoryID int
		,fVehicleCountID int
		,fScanTotalPrice decimal(18,2)
		,fScanOriginalPrice decimal(18,2)
		,fScanComparison decimal(18,2)
		,fScanClass nvarchar(max)
		,fScanModifiers nvarchar(max)
		,fScanCurrency int
		,fSecondWebsiteID int
		,fSecondPrice decimal(18,2)
		,fSecondOriginalPrice decimal(18,2)
		,fSecondComparison decimal(18,2)
		,fSecondClass nvarchar(max)
		,fSecondModifiers nvarchar(max)
		,fSecondCurrency int
		)
		
	--compared to vehicles
	INSERT INTO #tTempTableLarge (	fScanID,fCountryID, fPickupLocationID, fReturnLocationID, --fVehicleCompareName, 
									fBrandID, fVehicleID, fPickupDate, fReturnDate,
									fMainWebsiteID, fVehicleCategoryID, --fVehicleCountID,
									fScanTotalPrice, fScanOriginalPrice, fScanModifiers, fScanCurrency,
									fSecondWebsiteID, fSecondPrice, fSecondOriginalPrice, fSecondModifiers, fSecondCurrency
									)
	SELECT 
		  min(tMain.fScanID)
		, tMain.fScanTravelCountryID
		, tMain.fScanPickupLocationID
		, tMain.fScanReturnLocationID
		, tMain.fScanBrandID
		, tMain.fScanVehicleID
		, tMain.fScanPickupDate
		, tMain.fScanReturnDate
		, @web1
		, tMain.fVehicleCategoryID
		--, tVC.fVehicleCountID
		, t1.fFirstPrice 
		, t1.fFirstOriginalPrice
		, t1.fFirstModifiers 
		, t1.fFirstCurrencyID
		, @web2
		, t2.fSecondPrice
		, t2.fSecondOriginalPrice
		, t2.fSecondModifiers 
		, t2.fSecondCurrencyID

	FROM(	  
			SELECT  min (tTable.fScanID) as fScanID	
			, fScanDate
			, min (tTable.fScanURL) as 	fScanURL
			, tTable.fScanTravelCountryID
			, tTable.fScanPickupLocationID
			, tTable.fScanReturnLocationID
			, tTable.fScanPickupDate 
			, tTable.fScanReturnDate 
			, tTable.fScanBrandID
			, tTable.fScanVehicleID
			, rV.fVehicleCategoryID
			, min (tTable.fScanLicenceCountryID) as 	fScanLicenceCountryID
			from #tTempTable as tTable				
			INNER JOIN tRefVehicle as rV on rV.fID = tTable.fScanVehicleID
			GROUP BY  tTable.fScanTravelCountryID
					, fScanDate
					, tTable.fScanTravelCountryID
					, tTable.fScanPickupLocationID
					, tTable.fScanReturnLocationID
					, tTable.fScanPickupDate
					, tTable.fScanReturnDate
					, tTable.fScanBrandID
					, tTable.fScanVehicleID	
					, rV.fVehicleCategoryID

	) as tMain
	INNER JOIN #Vehicletable as tVC on tVC.fVehicleID = tMain.fScanVehicleID

	LEFT JOIN (	SELECT   fScanDate
						,fScanTravelCountryID
						,fScanPickupLocationID
						,fScanReturnLocationID
						,fScanPickupDate
						,fScanReturnDate
						,fScanLicenceCountryID
						,fScanVehicleID
						,fScanURL as fFirstURL
						,min(fScanTotalPrice) as fFirstPrice
						,max([dbo].[getListPriceExceptionsAsString](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fFirstModifiers
						,fScanOriginalPrice as fFirstOriginalPrice
						,fScanCurrencyID as fFirstCurrencyID 
					FROM #tTempTable 					
					WHERE (fScanURL = @web1)
					group by fScanDate
							,fScanTravelCountryID
							,fScanPickupLocationID
							,fScanReturnLocationID
							,fScanPickupDate
							,fScanReturnDate
							,fScanLicenceCountryID
							,fScanVehicleID
							,fScanURL 
							,fScanOriginalPrice						  
							,fScanCurrencyID 
					) as t1 on t1.fScanPickupDate = tMain.fScanPickupDate
					AND t1.fScanReturnDate = tMain.fScanReturnDate
					AND t1.[fScanVehicleID] = tMain.[fScanVehicleID]
					AND t1.fScanTravelCountryID = tMain.fScanTravelCountryID
					AND t1.fScanPickupLocationID = tMain.fScanPickupLocationID
					AND t1.fScanReturnLocationID = tMain.fScanReturnLocationID
					 
	LEFT JOIN (	SELECT   fScanDate
						,fScanTravelCountryID
						,fScanPickupLocationID
						,fScanReturnLocationID
						,fScanPickupDate
						,fScanReturnDate
						,fScanLicenceCountryID
						,fScanVehicleID
						,fScanURL as fSecondURL
						,min(fScanTotalPrice) as fSecondPrice
						,max([dbo].[getListPriceExceptionsAsString](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)) as fSecondModifiers
						,fScanOriginalPrice as fSecondOriginalPrice
						,fScanCurrencyID as fSecondCurrencyID 
					FROM #tTempTable 					
					WHERE (fScanURL = @web2)
					group by fScanDate
							,fScanTravelCountryID
							,fScanPickupLocationID
							,fScanReturnLocationID
							,fScanPickupDate
							,fScanReturnDate
							,fScanLicenceCountryID
							,fScanVehicleID
							,fScanURL 		
							,fScanOriginalPrice				  
							,fScanCurrencyID 
					) as t2 on t2.fScanPickupDate = tMain.fScanPickupDate
					AND t2.fScanReturnDate = tMain.fScanReturnDate
					AND t2.[fScanVehicleID] = tMain.[fScanVehicleID]
					AND t2.fScanTravelCountryID = tMain.fScanTravelCountryID
					AND t2.fScanPickupLocationID = tMain.fScanPickupLocationID
					AND t2.fScanReturnLocationID = tMain.fScanReturnLocationID
						 		
	GROUP BY tMain.fScanTravelCountryID
		, tMain.fScanPickupLocationID
		, tMain.fScanReturnLocationID
		, tMain.fScanBrandID
		, tMain.fScanVehicleID
		, tMain.fScanPickupDate
		, tMain.fScanReturnDate
		, tMain.fVehicleCategoryID
		--, tVC.fVehicleCountID
		, t1.fFirstPrice 
		, t1.fFirstOriginalPrice
		, t1.fFirstModifiers 
		, t1.fFirstCurrencyID
		, t2.fSecondPrice
		, t2.fSecondOriginalPrice
		, t2.fSecondModifiers 
		, t2.fSecondCurrencyID
		,tVC.fBrandOrder

	ORDER BY tMain.fScanTravelCountryID, tMain.fScanPickupLocationID, tMain.fScanReturnLocationID, tMain.fScanPickupDate, tMain.fVehicleCategoryID, tVC.fBrandOrder, tMain.fScanVehicleID
	


	--remove tables that are no longer needed
	IF OBJECT_ID('tempdb..#tTempTable') IS NOT NULL
	/*Then it exists*/
    DROP TABLE #tTempTable

	
	DECLARE @sectionList TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fVehicleCategoryID int, fPickupDate date, fReturnDate date, fPickupLocation int, fReturnLocation int)
	INSERT INTO @sectionList (fVehicleCategoryID, fPickupDate, fReturnDate, fPickupLocation, fReturnLocation)
	SELECT DISTINCT fVehicleCategoryID, fPickupDate, fReturnDate, fPickupLocationID, fReturnLocationID
	FROM #tTempTableLarge



	--get percentage comparison against main vehicle in that category/etc combination
	DECLARE @totalCount int, @vehicleCategoryCount int, @thisCount int, @thisComparison1 decimal(18,2), @thisComparison2 decimal(18,2), 
			@comparePrice1 decimal(18,2), @comparePrice2 decimal(18,2), 
			@thisVehicleCategoryID int, @thisPickupDate date, @thisReturnDate date, @thisPickupLocation int, @thisReturnLocation int, 
			@prevVehicleCategoryID int, @prevPickupDate date, @prevReturnDate date, @prevPickupLocation int, @prevReturnLocation int, 
			@thisURL int, @thisClass nvarchar(200), @secondClass nvarchar(200),
			@smallestPrice decimal(18,2)
			--@thisVehicleName int, @thisPrice1 decimal(18,2), @thisPrice2 decimal(18,2), 
	SET @totalCount = (SELECT count(fid) FROM @sectionList)
	SET @vehicleCategoryCount = 0
	SET @thisCount = 1
	SET @thisURL = (SELECT fURL from @URLtable WHERE fID = 1)

	
	

	--SELECT * FROM #Vehicletable
	--variables for while
	DECLARE @vehicleCount int, @vehicleMAXCount int, @vehicleOrder int, @prevVehicleCategory int
	SET @vehicleMAXCount =  (SELECT count(fID) FROM #tTempTableLarge  --WHERE NOT fVehicleCategoryID IS NULL
							)
	SET @vehicleCount = 1
	SET @vehicleOrder = 1
	SET @prevVehicleCategory = 0
	-- run while to allocate vehicle order
	WHILE @vehicleCount <=  @vehicleMAXCount
		BEGIN
			--get values for current section
			SET @thisVehicleCategoryID = (SELECT fVehicleCategoryID FROM #tTempTableLarge WHERE fID = @vehicleCount)
			SET @thisPickupDate = (SELECT fPickupDate FROM #tTempTableLarge WHERE fID = @vehicleCount )
			SET @thisReturnDate = (SELECT fReturnDate FROM #tTempTableLarge WHERE fID = @vehicleCount )
			SET @thisPickupLocation = (SELECT fPickupLocationID FROM #tTempTableLarge WHERE fID = @vehicleCount )
			SET @thisReturnLocation = (SELECT fReturnLocationID FROM #tTempTableLarge WHERE fID = @vehicleCount )

			SET @vehicleOrder = 
				CASE
					WHEN NOT (		@prevVehicleCategoryID = @thisVehicleCategoryID
								AND @prevPickupDate = @thisPickupDate
								AND @prevReturnDate = @thisReturnDate
								AND @prevPickupLocation = @thisPickupLocation
								AND @prevReturnLocation = @thisReturnLocation
								)
					THEN 1
					Else @vehicleOrder
				END

			UPDATE #tTempTableLarge 
			SET  fVehicleCountID = @vehicleOrder
			WHERE fID = @vehicleCount
		
			--get values for current section
			SET @prevVehicleCategoryID = @thisVehicleCategoryID
			SET @prevPickupDate = @thisPickupDate
			SET @prevReturnDate = @thisReturnDate
			SET @prevPickupLocation = @thisPickupLocation
			SET @prevReturnLocation = @thisReturnLocation
	
			SET @vehicleOrder= @vehicleOrder + 1	
			SET @vehicleCount= @vehicleCount + 1
		END





	WHILE @thisCount <= @totalCount
		BEGIN
			--get values for current section
			SET @thisVehicleCategoryID = (SELECT fVehicleCategoryID FROM @sectionList WHERE fID = @thisCount)
			SET @thisPickupDate = (SELECT fPickupDate FROM @sectionList WHERE fID = @thisCount )
			SET @thisReturnDate = (SELECT fReturnDate FROM @sectionList WHERE fID = @thisCount )
			SET @thisPickupLocation = (SELECT fPickupLocation FROM @sectionList WHERE fID = @thisCount )
			SET @thisReturnLocation = (SELECT fReturnLocation FROM @sectionList WHERE fID = @thisCount )
			--get price of main vehicle for this section
			SET @comparePrice1 = (	SELECT top 1 fScanTotalPrice FROM #tTempTableLarge
								WHERE fVehicleID = (	SELECT TOP 1 fVehicleID from #tTempTableLarge
														WHERE fVehicleCategoryID = @thisVehicleCategoryID
														ORDER BY fVehicleCountID ASC
													 )
								AND fMainWebsiteID = @thisURL
								AND fPickupDate = @thisPickupDate
								AND fReturnDate = @thisReturnDate
								AND fPickupLocationID = @thisPickupLocation
								AND fReturnLocationID = @thisReturnLocation
								AND fVehicleCategoryID = @thisVehicleCategoryID
								ORDER BY fScanTotalPrice asc
							 )
							 			
			--update main table with classes
			UPDATE #tTempTableLarge 
			SET fScanClass = 
				CASE	
					WHEN isnull(fScanTotalPrice,0) = 0			 
						Then ' noPrice'
					WHEN fScanTotalPrice = @comparePrice1 
						THEN ' mainPrice'
					WHEN fScanTotalPrice < @comparePrice1 
						THEN ' smallerPrice'
					WHEN fScanTotalPrice > @comparePrice1
						THEN  ' largerPrice'
					ELSE 'nil'
				END
			,
			fSecondClass = 
				CASE	
					WHEN fSecondPrice = 0			 
						Then ' noPrice'
					WHEN fSecondPrice = @comparePrice1 
						THEN ' mainPrice'
					WHEN fSecondPrice < @comparePrice1 
						THEN ' smallerPrice'
					WHEN fSecondPrice > @comparePrice1
						THEN  ' largerPrice'
					ELSE ''
				END
			WHERE fID in (SELECT fID from #tTempTableLarge WHERE 
								    fPickupDate = @thisPickupDate
								AND fReturnDate = @thisReturnDate
								AND fPickupLocationID = @thisPickupLocation
								AND fReturnLocationID = @thisReturnLocation
								AND fVehicleCategoryID = @thisVehicleCategoryID)
												
			--update main table with comparison values
			UPDATE #tTempTableLarge 
			SET fScanComparison = 
				CASE	
					WHEN @showPercentOrPrice = 2 --show price difference
						THEN cast((fScanTotalPrice - @comparePrice1) as decimal(18,2))
					ELSE --show percentage difference
						cast((cast((fScanTotalPrice - @comparePrice1) as decimal(18,2))/@comparePrice1*100) as decimal(18,2))
				END
			, fSecondComparison = 
				CASE	
					WHEN @showPercentOrPrice = 2 --show price difference
						THEN cast((fSecondPrice - @comparePrice1) as decimal(18,2))
					ELSE --show percentage difference
						cast((cast((fSecondPrice - @comparePrice1) as decimal(18,2))/@comparePrice1*100) as decimal(18,2))
				END
			WHERE fID in (SELECT fID from #tTempTableLarge WHERE 
								    fPickupDate = @thisPickupDate
								AND fReturnDate = @thisReturnDate
								AND fPickupLocationID = @thisPickupLocation
								AND fReturnLocationID = @thisReturnLocation
								AND fVehicleCategoryID = @thisVehicleCategoryID)

			
			-- iterate count
			SET @thisCount = @thisCount + 1
		END




	DECLARE @comparisonSign as nvarchar(1)
	SET @comparisonSign = 
		CASE
			WHEN @showPercentOrPrice = 2
				THEN '$'
			ELSE '%'
		END



	-- get final data
	IF OBJECT_ID('tempdb..#tTempTableFinal') IS NOT NULL
	/*Then it exists*/
	DROP TABLE #tTempTableFinal
	--create table
	CREATE TABLE #tTempTableFinal (
			 fID int IDENTITY(1,1) PRIMARY KEY
			,fScanID int
			,fCountryID nvarchar(50)
			,fLocationCombination nvarchar(50)
			,fPickupLocationID  nvarchar(50)
			,fReturnLocationID nvarchar(50)
			,fPickupDate date
			,fReturnDate date
			,fTravelDates nvarchar(50)
			,fVehicleCountID nvarchar(50)
			,c1fVehicleCountID nvarchar(50)
			,c1fVehicleID nvarchar(150)
			,c1fVehicleCategoryID int
			,c1fVehicleCategoryName nvarchar(50)
			,c1fMainWebsiteID nvarchar(50)
			,c1fScanTotalPrice nvarchar(50)
			,c1fScanOriginalPrice nvarchar(50)
			,c1fScanModifiers nvarchar(max)
			,c1fScanClass nvarchar(max)
			,c1fScanComparison nvarchar(50)
			,c1fScanCurrency nvarchar(50)
			,c1fSecondWebsiteID nvarchar(50)
			,c1fSecondPrice nvarchar(50)
			,c1fSecondOriginalPrice nvarchar(50)
			,c1fSecondModifiers nvarchar(max)
			,c1fSecondComparison nvarchar(50)
			,c1fSecondClass nvarchar(max)
			,c1fSecondCurrency nvarchar(50)
			,c2fVehicleCountID nvarchar(50)
			,c2fVehicleID nvarchar(150)
			,c2fVehicleCategoryID nvarchar(50)
			,c2fVehicleCategoryName nvarchar(50)
			,c2fMainWebsite nvarchar(50)
			,c2fScanTotalPrice nvarchar(50)
			,c2fScanOriginalPrice nvarchar(50)
			,c2fScanModifiers nvarchar(max)
			,c2fScanClass nvarchar(max)
			,c2fScanComparison nvarchar(50)
			,c2fScanCurrency nvarchar(50)
			,c2fSecondWebsite nvarchar(50)
			,c2fSecondPrice nvarchar(50)
			,c2fSecondOriginalPrice nvarchar(50)
			,c2fSecondModifiers nvarchar(max)
			,c2fSecondComparison nvarchar(50)
			,c2fSecondClass nvarchar(50)
			,c2fSecondCurrency nvarchar(50)
			,c3fVehicleCountID nvarchar(50)
			,c3fVehicleID nvarchar(150)
			,c3fVehicleCategoryID nvarchar(50)
			,c3fVehicleCategoryName nvarchar(50)
			,c3fMainWebsite nvarchar(50)
			,c3fScanTotalPrice nvarchar(50)
			,c3fScanOriginalPrice nvarchar(50)
			,c3fScanModifiers nvarchar(max)
			,c3fScanClass nvarchar(50)
			,c3fScanComparison nvarchar(50)
			,c3fScanCurrency nvarchar(50)
			,c3fSecondWebsite nvarchar(50)
			,c3fSecondPrice nvarchar(50)
			,c3fSecondOriginalPrice nvarchar(50)
			,c3fSecondModifiers nvarchar(max)
			,c3fSecondComparison nvarchar(50)
			,c3fSecondClass nvarchar(50)
			,c3fSecondCurrency nvarchar(50)
			,c4fVehicleCountID nvarchar(50)
			,c4fVehicleID nvarchar(150)
			,c4fVehicleCategoryID nvarchar(50)
			,c4fVehicleCategoryName nvarchar(50)
			,c4fMainWebsite nvarchar(50)
			,c4fScanTotalPrice nvarchar(50)
			,c4fScanOriginalPrice nvarchar(50)
			,c4fScanModifiers nvarchar(max)
			,c4fScanClass nvarchar(50)
			,c4fScanComparison nvarchar(50)
			,c4fScanCurrency nvarchar(50)
			,c4fSecondWebsite nvarchar(50)
			,c4fSecondPrice nvarchar(50)
			,c4fSecondOriginalPrice nvarchar(50)
			,c4fSecondModifiers nvarchar(max)
			,c4fSecondComparison nvarchar(50)
			,c4fSecondClass nvarchar(50)
			,c4fSecondCurrency nvarchar(50)
			,c5fVehicleCountID nvarchar(50)
			,c5fVehicleID nvarchar(150)
			,c5fVehicleCategoryID nvarchar(50)
			,c5fVehicleCategoryName nvarchar(50)
			,c5fMainWebsite nvarchar(50)
			,c5fScanTotalPrice nvarchar(50)
			,c5fScanOriginalPrice nvarchar(50)
			,c5fScanModifiers nvarchar(max)
			,c5fScanClass nvarchar(50)
			,c5fScanComparison nvarchar(50)
			,c5fScanCurrency nvarchar(50)
			,c5fSecondWebsite nvarchar(50)
			,c5fSecondPrice nvarchar(50)
			,c5fSecondOriginalPrice nvarchar(50)
			,c5fSecondModifiers nvarchar(max)
			,c5fSecondComparison nvarchar(50)
			,c5fSecondClass nvarchar(50)
			,c5fSecondCurrency nvarchar(50)
		)
	INSERT INTO #tTempTableFinal (
		 fScanID 
		,fCountryID 
		,fPickupLocationID  
		,fReturnLocationID 
		,fPickupDate
		,fReturnDate
		,fVehicleCountID 
		,c1fVehicleCountID 
		,c1fVehicleID 
		,c1fVehicleCategoryID 
		,c1fMainWebsiteID 
		,c1fScanTotalPrice 
		,c1fScanOriginalPrice 
		,c1fScanModifiers 
		,c1fScanClass 
		,c1fScanComparison 
		,c1fScanCurrency 
		,c1fSecondWebsiteID 
		,c1fSecondPrice 
		,c1fSecondOriginalPrice 
		,c1fSecondModifiers 
		,c1fSecondComparison 
		,c1fSecondClass 
		,c1fSecondCurrency 
		,c2fVehicleCountID 
		,c2fVehicleID 
		,c2fVehicleCategoryID 
		,c2fMainWebsite 
		,c2fScanTotalPrice 
		,c2fScanOriginalPrice 
		,c2fScanModifiers 
		,c2fScanClass 
		,c2fScanComparison 
		,c2fScanCurrency 
		,c2fSecondWebsite 
		,c2fSecondPrice 
		,c2fSecondOriginalPrice 
		,c2fSecondModifiers 
		,c2fSecondComparison 
		,c2fSecondClass 
		,c2fSecondCurrency 
		,c3fVehicleCountID 
		,c3fVehicleID 
		,c3fVehicleCategoryID 
		,c3fMainWebsite 
		,c3fScanTotalPrice 
		,c3fScanOriginalPrice 
		,c3fScanModifiers 
		,c3fScanClass 
		,c3fScanComparison 
		,c3fScanCurrency 
		,c3fSecondWebsite 
		,c3fSecondPrice 
		,c3fSecondOriginalPrice 
		,c3fSecondModifiers 
		,c3fSecondComparison 
		,c3fSecondClass 
		,c3fSecondCurrency 
		,c4fVehicleCountID 
		,c4fVehicleID 
		,c4fVehicleCategoryID 
		,c4fMainWebsite 
		,c4fScanTotalPrice 
		,c4fScanOriginalPrice 
		,c4fScanModifiers 
		,c4fScanClass 
		,c4fScanComparison 
		,c4fScanCurrency 
		,c4fSecondWebsite 
		,c4fSecondPrice 
		,c4fSecondOriginalPrice 
		,c4fSecondModifiers 
		,c4fSecondComparison 
		,c4fSecondClass 
		,c4fSecondCurrency 
		,c5fVehicleCountID 
		,c5fVehicleID 
		,c5fVehicleCategoryID 
		,c5fMainWebsite 
		,c5fScanTotalPrice 
		,c5fScanOriginalPrice 
		,c5fScanModifiers 
		,c5fScanClass 
		,c5fScanComparison 
		,c5fScanCurrency 
		,c5fSecondWebsite 
		,c5fSecondPrice 
		,c5fSecondOriginalPrice 
		,c5fSecondModifiers 
		,c5fSecondComparison 
		,c5fSecondClass 
		,c5fSecondCurrency 
		)
	SELECT min(tMain.fScanID ) as fScanID
		,tMain.fCountryID 
		,tMain.fPickupLocationID 
		,tMain.fReturnLocationID
		,tMain.fPickupDate
		,tMain.fReturnDate
		,tMain.fVehicleCountID 
		,t1.fVehicleCountID 
		,t1.fVehicleID 
		,t1.fVehicleCategoryID 
		,t1.fMainWebsiteID 
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (isNull(t1.fScanTotalPrice,0))))  as fScanTotalPrice
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (isNull(t1.fScanOriginalPrice,0))))  as fScanOriginalPrice
		,t1.fScanModifiers 
		,t1.fScanClass 
		,[dbo].[replaceEmptyPriceAsBlank2](CONCAT(@comparisonSign, (IsNull(t1.fScanComparison,0))), t1.fScanTotalPrice)  as fScanComparison
		,t1.fScanCurrency 
		,t1.fSecondWebsiteID  
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (isNull(t1.fSecondPrice,0))))  as fSecondPrice
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (isNull(t1.fSecondOriginalPrice,0))))  as fSecondOriginalPrice
		,t1.fSecondModifiers 
		,[dbo].[replaceEmptyPriceAsBlank2](CONCAT(@comparisonSign, (IsNull(t1.fSecondComparison,0))), t1.fSecondPrice)  as fSecondComparison
		,t1.fSecondClass
		,t1.fSecondCurrency 
		,t2.fVehicleCountID as c2fVehicleCountID
		,t2.fVehicleID  as c2fVehicleID
		,t2.fVehicleCategoryID  as c2fVehicleCategoryID
		,t2.fMainWebsiteID  as c2fMainWebsite
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t2.fScanTotalPrice, 0))))  as c2fScanTotalPrice
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t2.fScanOriginalPrice, 0))))  as c2fScanOriginalPrice
		,t2.fScanModifiers as c2fScanModifiers
		,t2.fScanClass as c2fScanClass
		,[dbo].[replaceEmptyPriceAsBlank2](CONCAT(@comparisonSign, (IsNull(t2.fScanComparison,0))), t2.fScanTotalPrice)  as c2fScanComparison
		,t2.fScanCurrency as c2fScanCurrency
		,t2.fSecondWebsiteID  as c2fSecondWebsite
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t2.fSecondPrice, 0))))  as c2fSecondPrice
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t2.fSecondOriginalPrice, 0))))  as c2fSecondOriginalPrice
		,t2.fSecondModifiers as c2fSecondModifiers
		,[dbo].[replaceEmptyPriceAsBlank2](CONCAT(@comparisonSign, (IsNull(t2.fSecondComparison,0))), t2.fSecondPrice)  as c2fSecondComparison
		,t2.fSecondClass as c2fSecondClass
		,t2.fSecondCurrency as c2fSecondCurrency
		,t3.fVehicleCountID as c3fVehicleCountID
		,t3.fVehicleID  as c3fVehicleID
		,t3.fVehicleCategoryID  as c3fVehicleCategoryID
		,t3.fMainWebsiteID  as c3fMainWebsite
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t3.fScanTotalPrice, 0))))  as c3fScanTotalPrice
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t3.fScanOriginalPrice, 0))))  as c3fScanOriginalPrice
		,t3.fScanModifiers as c3fScanModifiers
		,t3.fScanClass as c3fScanClass
		,[dbo].[replaceEmptyPriceAsBlank2](CONCAT(@comparisonSign, (IsNull(t3.fScanComparison,0))), t3.fScanTotalPrice)  as c3fScanComparison
		,t3.fScanCurrency as c3fScanCurrency
		,t3.fSecondWebsiteID  as c3fSecondWebsite
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t3.fSecondPrice, 0))))  as c3fSecondPrice
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t3.fSecondOriginalPrice, 0))))  as c3fSecondOriginalPrice
		,t3.fSecondModifiers as c3fSecondModifiers
		,[dbo].[replaceEmptyPriceAsBlank2](CONCAT(@comparisonSign, (IsNull(t3.fSecondComparison,0))), t3.fSecondPrice)  as c3fSecondComparison
		,t3.fSecondClass as c3fSecondClass
		,t3.fSecondCurrency as c3fSecondCurrency
		,t4.fVehicleCountID as c4fVehicleCountID
		,t4.fVehicleID  as c4fVehicleID
		,t4.fVehicleCategoryID  as c4fVehicleCategoryID
		,t4.fMainWebsiteID  as c4fMainWebsite
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t4.fScanTotalPrice, 0))))  as c4fScanTotalPrice
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t4.fScanOriginalPrice, 0))))  as c4fScanOriginalPrice
		,t4.fScanModifiers as c4fScanModifiers
		,t4.fScanClass as c4fScanClass
		,[dbo].[replaceEmptyPriceAsBlank2](CONCAT(@comparisonSign, (IsNull(t4.fScanComparison,0))), t4.fScanTotalPrice)  as c4fScanComparison
		,t4.fScanCurrency as c4fScanCurrency
		,t4.fSecondWebsiteID  as c4fSecondWebsite
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t4.fSecondPrice, 0))))  as c4fSecondPrice
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t4.fSecondOriginalPrice, 0))))  as c4fSecondOriginalPrice
		,t4.fSecondModifiers as c4fSecondModifiers
		,[dbo].[replaceEmptyPriceAsBlank2](CONCAT(@comparisonSign, (IsNull(t4.fSecondComparison,0))), t4.fSecondPrice)  as c4fSecondComparison
		,t4.fSecondClass as c4fSecondClass
		,t4.fSecondCurrency as c4fSecondCurrency
		,t5.fVehicleCountID as c5fVehicleCountID
		,t5.fVehicleID  as c5fVehicleID
		,t5.fVehicleCategoryID  as c5fVehicleCategoryID
		,t5.fMainWebsiteID  as c5fMainWebsite
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t5.fScanTotalPrice, 0))))  as c5fScanTotalPrice
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t5.fScanOriginalPrice, 0))))  as c5fScanOriginalPrice
		,t5.fScanModifiers as c5fScanModifiers
		,t5.fScanClass as c5fScanClass
		,[dbo].[replaceEmptyPriceAsBlank2](CONCAT(@comparisonSign, (IsNull(t5.fScanComparison,0))), t5.fScanTotalPrice)  as c5fScanComparison
		,t5.fScanCurrency as c5fScanCurrency
		,t5.fSecondWebsiteID  as c5fSecondWebsite
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t5.fSecondPrice, 0))))  as c5fSecondPrice
		,[dbo].[replaceEmptyPriceAsBlank](CONCAT('$', (IsNull(t5.fSecondOriginalPrice, 0))))  as c5fSecondOriginalPrice
		,t5.fSecondModifiers as c5fSecondModifiers
		,[dbo].[replaceEmptyPriceAsBlank2](CONCAT(@comparisonSign, (IsNull(t5.fSecondComparison,0))), t5.fSecondPrice)  as c5fSecondComparison
		,t5.fSecondClass as c5fSecondClass
		,t5.fSecondCurrency as c5fSecondCurrency
		

	FROM 
		( SELECT min(fScanID ) as fScanID
				,fCountryID 
				,fPickupLocationID 
				,fReturnLocationID
				,fPickupDate
				,fReturnDate
				,fVehicleCountID 
		  FROM #tTempTableLarge  
		  GROUP BY 
				 fCountryID 
				,fPickupLocationID 
				,fReturnLocationID
				,fPickupDate
				,fReturnDate
				,fVehicleCountID 
		)
	as tMain
	
	LEFT JOIN (
		SELECT min(fScanID ) as fScanID
			,fCountryID 
			,fPickupLocationID  
			,fReturnLocationID
			,fPickupDate
			,fReturnDate
			,fVehicleCountID
			,fVehicleCategoryID 
			,fVehicleID 
			,fMainWebsiteID 
			,fScanTotalPrice 
			,fScanOriginalPrice 
			,fScanModifiers 
			,fScanComparison
			,fScanClass
			,fScanCurrency
			,fSecondWebsiteID 
			,fSecondPrice 
			,fSecondOriginalPrice 
			,fSecondModifiers 
			,fSecondComparison
			,fSecondClass
			,fSecondCurrency
		FROM #tTempTableLarge 
		WHERE fVehicleCategoryID = 1
		GROUP BY 
			fCountryID 
			,fPickupLocationID  
			,fReturnLocationID
			,fPickupDate
			,fReturnDate
			,fVehicleCountID
			,fVehicleCategoryID 
			,fVehicleID 
			,fMainWebsiteID 
			,fScanTotalPrice 
			,fScanOriginalPrice 
			,fScanModifiers 
			,fScanComparison
			,fScanClass
			,fScanCurrency
			,fSecondWebsiteID 
			,fSecondPrice 
			,fSecondOriginalPrice 
			,fSecondModifiers 
			,fSecondComparison
			,fSecondClass
			,fSecondCurrency	
	) as t1
	on	tMain.fCountryID = t1.fCountryID
		AND tMain.fPickupLocationID  = t1.fPickupLocationID
		AND tMain.fReturnLocationID  = t1.fReturnLocationID			
		AND tMain.fPickupDate = t1.fPickupDate	
		AND tMain.fReturnDate = t1.fReturnDate
		AND tMain.fVehicleCountID = t1.fVehicleCountID

	LEFT JOIN (
		SELECT min(fScanID ) as fScanID
			,fCountryID 
			,fPickupLocationID  
			,fReturnLocationID
			,fPickupDate
			,fReturnDate
			,fVehicleCountID
			,fVehicleCategoryID 
			,fVehicleID 
			,fMainWebsiteID 
			,fScanTotalPrice 
			,fScanOriginalPrice 
			,fScanModifiers 
			,fScanComparison
			,fScanClass
			,fScanCurrency
			,fSecondWebsiteID 
			,fSecondPrice 
			,fSecondOriginalPrice 
			,fSecondModifiers 
			,fSecondComparison
			,fSecondClass
			,fSecondCurrency
		FROM #tTempTableLarge 
		WHERE fVehicleCategoryID = 2	
		GROUP BY 
			fCountryID 
			,fPickupLocationID  
			,fReturnLocationID
			,fPickupDate
			,fReturnDate
			,fVehicleCountID
			,fVehicleCategoryID 
			,fVehicleID 
			,fMainWebsiteID 
			,fScanTotalPrice 
			,fScanOriginalPrice 
			,fScanModifiers 
			,fScanComparison
			,fScanClass
			,fScanCurrency
			,fSecondWebsiteID 
			,fSecondPrice 
			,fSecondOriginalPrice 
			,fSecondModifiers 
			,fSecondComparison
			,fSecondClass
			,fSecondCurrency	
	) as t2
	on	tMain.fCountryID = t2.fCountryID
		AND tMain.fPickupLocationID  = t2.fPickupLocationID
		AND tMain.fReturnLocationID  = t2.fReturnLocationID			
		AND tMain.fPickupDate = t2.fPickupDate	
		AND tMain.fReturnDate = t2.fReturnDate
		AND tMain.fVehicleCountID = t2.fVehicleCountID
		
	LEFT JOIN (
		SELECT min(fScanID ) as fScanID
			,fCountryID 
			,fPickupLocationID  
			,fReturnLocationID
			,fPickupDate
			,fReturnDate
			,fVehicleCountID
			,fVehicleCategoryID 
			,fVehicleID 
			,fMainWebsiteID 
			,fScanTotalPrice 
			,fScanOriginalPrice 
			,fScanModifiers 
			,fScanComparison
			,fScanClass
			,fScanCurrency
			,fSecondWebsiteID 
			,fSecondPrice 
			,fSecondOriginalPrice 
			,fSecondModifiers 
			,fSecondComparison
			,fSecondClass
			,fSecondCurrency
		FROM #tTempTableLarge 
		WHERE fVehicleCategoryID = 3
		GROUP BY 
			fCountryID 
			,fPickupLocationID  
			,fReturnLocationID
			,fPickupDate
			,fReturnDate
			,fVehicleCountID
			,fVehicleCategoryID 
			,fVehicleID 
			,fMainWebsiteID 
			,fScanTotalPrice 
			,fScanOriginalPrice 
			,fScanModifiers 
			,fScanComparison
			,fScanClass
			,fScanCurrency
			,fSecondWebsiteID 
			,fSecondPrice 
			,fSecondOriginalPrice 
			,fSecondModifiers 
			,fSecondComparison
			,fSecondClass
			,fSecondCurrency	
	) as t3
	on	tMain.fCountryID = t3.fCountryID
		AND tMain.fPickupLocationID  = t3.fPickupLocationID
		AND tMain.fReturnLocationID  = t3.fReturnLocationID	
		AND tMain.fPickupDate = t3.fPickupDate
		AND tMain.fReturnDate = t3.fReturnDate
		AND tMain.fVehicleCountID = t3.fVehicleCountID
		
	LEFT JOIN (
		SELECT min(fScanID ) as fScanID
			,fCountryID 
			,fPickupLocationID  
			,fReturnLocationID 
			,fPickupDate
			,fReturnDate
			,fVehicleCountID
			,fVehicleCategoryID 
			,fVehicleID 
			,fMainWebsiteID 
			,fScanTotalPrice 
			,fScanOriginalPrice 
			,fScanModifiers 
			,fScanComparison
			,fScanClass
			,fScanCurrency
			,fSecondWebsiteID 
			,fSecondPrice 
			,fSecondOriginalPrice 
			,fSecondModifiers 
			,fSecondComparison
			,fSecondClass
			,fSecondCurrency
		FROM #tTempTableLarge 
		WHERE fVehicleCategoryID = 4
		GROUP BY 
			fCountryID 
			,fPickupLocationID  
			,fReturnLocationID
			,fPickupDate
			,fReturnDate
			,fVehicleCountID
			,fVehicleCategoryID 
			,fVehicleID 
			,fMainWebsiteID 
			,fScanTotalPrice 
			,fScanOriginalPrice 
			,fScanModifiers 
			,fScanComparison
			,fScanClass
			,fScanCurrency
			,fSecondWebsiteID 
			,fSecondPrice 
			,fSecondOriginalPrice 
			,fSecondModifiers 
			,fSecondComparison
			,fSecondClass
			,fSecondCurrency
	) as t4
	on	tMain.fCountryID = t4.fCountryID
		AND tMain.fPickupLocationID  = t4.fPickupLocationID
		AND tMain.fReturnLocationID  = t4.fReturnLocationID	
		AND tMain.fPickupDate = t4.fPickupDate
		AND tMain.fReturnDate = t4.fReturnDate
		AND tMain.fVehicleCountID = t4.fVehicleCountID
		
	LEFT JOIN (
		SELECT min(fScanID ) as fScanID
			,fCountryID 
			,fPickupLocationID  
			,fReturnLocationID
			,fPickupDate
			,fReturnDate
			,fVehicleCountID
			,fVehicleCategoryID 
			,fVehicleID 
			,fMainWebsiteID 
			,fScanTotalPrice 
			,fScanOriginalPrice 
			,fScanModifiers 
			,fScanComparison
			,fScanClass
			,fScanCurrency
			,fSecondWebsiteID 
			,fSecondPrice 
			,fSecondOriginalPrice 
			,fSecondModifiers 
			,fSecondComparison
			,fSecondClass
			,fSecondCurrency
		FROM #tTempTableLarge 
		WHERE fVehicleCategoryID = 5
		GROUP BY 
			fCountryID 
			,fPickupLocationID  
			,fReturnLocationID
			,fPickupDate
			,fReturnDate
			,fVehicleCountID
			,fVehicleCategoryID 
			,fVehicleID 
			,fMainWebsiteID 
			,fScanTotalPrice 
			,fScanOriginalPrice 
			,fScanModifiers 
			,fScanComparison
			,fScanClass
			,fScanCurrency
			,fSecondWebsiteID 
			,fSecondPrice 
			,fSecondOriginalPrice 
			,fSecondModifiers 
			,fSecondComparison
			,fSecondClass
			,fSecondCurrency
	) as t5
	on	tMain.fCountryID = t5.fCountryID
		AND tMain.fPickupLocationID  = t5.fPickupLocationID
		AND tMain.fReturnLocationID  = t5.fReturnLocationID	
		AND tMain.fPickupDate = t5.fPickupDate
		AND tMain.fReturnDate = t5.fReturnDate
		AND tMain.fVehicleCountID = t5.fVehicleCountID
		
	GROUP BY 
		tMain.fCountryID 
		,tMain.fPickupLocationID
		,tMain.fReturnLocationID
		,tMain.fPickupDate
		,tMain.fReturnDate
		,tMain.fVehicleCountID
		,t1.fVehicleCountID
		,t1.fVehicleID 
		,t1.fVehicleCategoryID 
		,t1.fMainWebsiteID 
		,t1.fScanTotalPrice 
		,t1.fScanOriginalPrice 
		,t1.fScanModifiers 
		,t1.fScanComparison
		,t1.fScanClass
		,t1.fScanCurrency
		,t1.fSecondWebsiteID
		,t1.fSecondPrice 
		,t1.fSecondOriginalPrice 
		,t1.fSecondModifiers 
		,t1.fSecondComparison
		,t1.fSecondClass
		,t1.fSecondCurrency
		,t2.fVehicleCountID
		,t2.fVehicleID 
		,t2.fVehicleCategoryID 
		,t2.fMainWebsiteID 
		,t2.fScanTotalPrice 
		,t2.fScanOriginalPrice 
		,t2.fScanModifiers
		,t2.fScanComparison
		,t2.fScanClass
		,t2.fScanCurrency
		,t2.fSecondWebsiteID 
		,t2.fSecondPrice 
		,t2.fSecondOriginalPrice 
		,t2.fSecondModifiers
		,t2.fSecondComparison
		,t2.fSecondClass
		,t2.fSecondCurrency
		,t3.fVehicleCountID
		,t3.fVehicleID 
		,t3.fVehicleCategoryID 
		,t3.fMainWebsiteID 
		,t3.fScanTotalPrice 
		,t3.fScanOriginalPrice 
		,t3.fScanModifiers
		,t3.fScanComparison
		,t3.fScanClass
		,t3.fScanCurrency
		,t3.fSecondWebsiteID 
		,t3.fSecondPrice 
		,t3.fSecondOriginalPrice 
		,t3.fSecondModifiers
		,t3.fSecondComparison
		,t3.fSecondClass
		,t3.fSecondCurrency
		,t4.fVehicleCountID
		,t4.fVehicleID 
		,t4.fVehicleCategoryID 
		,t4.fMainWebsiteID 
		,t4.fScanTotalPrice 
		,t4.fScanOriginalPrice 
		,t4.fScanModifiers
		,t4.fScanComparison
		,t4.fScanClass
		,t4.fScanCurrency
		,t4.fSecondWebsiteID 
		,t4.fSecondPrice 
		,t4.fSecondOriginalPrice 
		,t4.fSecondModifiers
		,t4.fSecondComparison
		,t4.fSecondClass
		,t4.fSecondCurrency
		,t5.fVehicleCountID
		,t5.fVehicleID 
		,t5.fVehicleCategoryID 
		,t5.fMainWebsiteID 
		,t5.fScanTotalPrice 
		,t5.fScanOriginalPrice 
		,t5.fScanModifiers
		,t5.fScanClass
		,t5.fScanComparison
		,t5.fScanCurrency
		,t5.fSecondWebsiteID 
		,t5.fSecondPrice 
		,t5.fSecondOriginalPrice 
		,t5.fSecondModifiers
		,t5.fSecondComparison
		,t5.fSecondClass
		,t5.fSecondCurrency
		
	ORDER BY tMain.fCountryID, tMain.fPickupDate, tMain.fPickupLocationID, tMain.fReturnLocationID, tMain.fVehicleCountID 


	-- create reference table of names
	-- fTypeID values -----  1 = country, 2 = location, 3 = vehicle, 4 = website, 5= vehicle category
	IF OBJECT_ID('tempdb..#tTempReference') IS NOT NULL
	/*Then it exists*/
	DROP TABLE #tTempReference
	CREATE TABLE #tTempReference (
		fTypeID int
		,fID int
		,fName nvarchar(300)
	)
	INSERT INTO #tTempReference (fTypeID, fID, fName)
		SELECT distinct '1' as fType, fCountryID , tC.fCountryName 
		FROM #tTempTableLarge tTL
		INNER JOIN tRefCountry as tC on tC.fID = tTL.fCountryID
	INSERT INTO #tTempReference (fTypeID, fID, fName)
		SELECT distinct '2' , tL.fID , tL.fLocationName
		FROM #tTempTableLarge tTL
		INNER JOIN tRefLocation as tL on tL.fID = tTL.fPickupLocationID
		WHERE tL.fID in (SELECT distinct fPickupLocationID as fID FROM #tTempTableLarge)
	INSERT INTO #tTempReference (fTypeID, fID, fName)
		SELECT distinct '22' , tL.fID , tL.fLocationName
		FROM #tTempTableLarge tTL
		INNER JOIN tRefLocation as tL on tL.fID = tTL.fReturnLocationID
		WHERE tL.fID in (SELECT distinct fReturnLocationID as fID FROM #tTempTableLarge)
	INSERT INTO #tTempReference (fTypeID, fID, fName)
		SELECT distinct '3' as fType, tV.fVehicleID, (tV.fBrandName + ' ' + tV.fVehicleName)	
		FROM #tTempTableLarge tTL
		INNER JOIN #Vehicletable as tV on tV.fVehicleID = tTL.fVehicleID
		--WHERE tV.fID in (SELECT distinct fVehicleID FROM #tTempTableLarge)
	INSERT INTO #tTempReference (fTypeID, fID, fName)
		SELECT distinct '4' as fType, tTL.fMainWebsiteID, tW.fWebsiteName 
		FROM #tTempTableLarge tTL
		INNER JOIN tRefWebsite as tW on tW.fID = tTL.fMainWebsiteID
	INSERT INTO #tTempReference (fTypeID, fID, fName)
		SELECT distinct '4' as fType, tTL.fSecondWebsiteID, tW.fWebsiteName 
		FROM #tTempTableLarge tTL
		INNER JOIN tRefWebsite as tW on tW.fID = tTL.fSecondWebsiteID
		--WHERE tW.fID in (SELECT fWebsiteName from #tTempTableLarge)		
	INSERT INTO #tTempReference (fTypeID, fID, fName)
		SELECT distinct '5' as fType, tTL.fVehicleCategoryID, rVC.fVehicleCategoryName
		FROM #tTempTableLarge tTL
		INNER JOIN tRefVehicleCategory as rVC on rVC.fID =	tTL.fVehicleCategoryID
		--WHERE rVC.fID in (SELECT fURL from @URLtable)

	--SELECT * FROM #tTempReference
	--ORDER BY fTypeID ASC, fID ASC

			
	
	IF OBJECT_ID('tempdb..#tTempTableLarge') IS NOT NULL
	/*Then it exists*/
	   DROP TABLE #tTempTableLarge

	UPDATE #tTempTableFinal
	SET  fCountryID = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 1 AND fCountryID = fID)
		,c1fVehicleID =  (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 3 AND c1fVehicleID = fID)
		,c2fVehicleID =  (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 3 AND c2fVehicleID = fID)
		,c3fVehicleID =  (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 3 AND c3fVehicleID = fID)
		,c4fVehicleID =  (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 3 AND c4fVehicleID = fID)
		,c5fVehicleID =  (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 3 AND c5fVehicleID = fID)
		,c1fVehicleCategoryName = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 5 AND c1fVehicleCategoryID = fID)
		,c2fVehicleCategoryName = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 5 AND c2fVehicleCategoryID = fID)
		,c3fVehicleCategoryName = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 5 AND c3fVehicleCategoryID = fID)
		,c4fVehicleCategoryName = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 5 AND c4fVehicleCategoryID = fID)
		,c5fVehicleCategoryName = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 5 AND c5fVehicleCategoryID = fID)
		,fTravelDates = ( CONVERT(VARCHAR(11),fPickupDate,6) + ' - ' + CONVERT(VARCHAR(11),fReturnDate,6) )
		,fLocationCombination = ( (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 2 AND fPickupLocationID = fID) + ' - ' + (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 22 AND fReturnLocationID = fID)) 
		,c1fMainWebsiteID = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 4 AND c1fMainWebsiteID = fID)
		,c1fSecondWebsiteID = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 4 AND c1fSecondWebsiteID = fID)
		,c2fMainWebsite = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 4 AND c2fMainWebsite = fID)
		,c2fSecondWebsite = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 4 AND c2fSecondWebsite = fID)
		,c3fMainWebsite = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 4 AND c3fMainWebsite = fID)
		,c3fSecondWebsite = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 4 AND c3fSecondWebsite = fID)
		,c4fMainWebsite = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 4 AND c4fMainWebsite = fID)
		,c4fSecondWebsite = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 4 AND c4fSecondWebsite = fID)
		,c5fMainWebsite = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 4 AND c5fMainWebsite = fID)
		,c5fSecondWebsite = (SELECT TOP 1 fName FROM #tTempReference WHERE fTypeID = 4 AND c5fSecondWebsite = fID)
	   
	SELECT --*
		 fScanID 
		,fCountryID As fCountryName
		,fLocationCombination
		,fTravelDates
		,fVehicleCountID
		,c1fVehicleCountID
		,c1fVehicleID  as c1fVehicleName
		,c1fVehicleCategoryName 
		,c1fVehicleCategoryID 
		,c1fMainWebsiteID as c1fMainWebsite
		,c1fScanTotalPrice 
		,c1fScanOriginalPrice 
		,c1fScanModifiers 
		,c1fScanClass 
		,c1fScanComparison 
		,c1fScanCurrency 
		,c1fSecondWebsiteID  as c1fSecondWebsite
		,c1fSecondPrice 
		,c1fSecondOriginalPrice 
		,c1fSecondModifiers 
		,c1fSecondComparison 
		,c1fSecondClass 
		,c1fSecondCurrency 
		,c2fVehicleCountID 
		,c2fVehicleID   as c2fVehicleName
		,c2fVehicleCategoryName 
		,c2fVehicleCategoryID 
		,c2fMainWebsite  as c2fMainWebsite
		,c2fScanTotalPrice 
		,c2fScanOriginalPrice 
		,c2fScanModifiers 
		,c2fScanClass 
		,c2fScanComparison 
		,c2fScanCurrency 
		,c2fSecondWebsite  as c2fSecondWebsite
		,c2fSecondPrice 
		,c2fSecondOriginalPrice 
		,c2fSecondModifiers 
		,c2fSecondComparison 
		,c2fSecondClass 
		,c2fSecondCurrency 
		,c3fVehicleCountID 
		,c3fVehicleID  as c3fVehicleName
		,c3fVehicleCategoryName 
		,c3fVehicleCategoryID 
		,c3fMainWebsite  as c3fMainWebsite
		,c3fScanTotalPrice 
		,c3fScanOriginalPrice 
		,c3fScanModifiers 
		,c3fScanClass 
		,c3fScanComparison 
		,c3fScanCurrency 
		,c3fSecondWebsite  as c3fSecondWebsite
		,c3fSecondPrice 
		,c3fSecondOriginalPrice 
		,c3fSecondModifiers 
		,c3fSecondComparison 
		,c3fSecondClass 
		,c3fSecondCurrency 
		,c4fVehicleCountID 
		,c4fVehicleID  as c4fVehicleName
		,c4fVehicleCategoryName 
		,c4fVehicleCategoryID 
		,c4fMainWebsite   as c4fMainWebsite
		,c4fScanTotalPrice 
		,c4fScanOriginalPrice 
		,c4fScanModifiers 
		,c4fScanClass 
		,c4fScanComparison 
		,c4fScanCurrency 
		,c4fSecondWebsite  as c4fSecondWebsite
		,c4fSecondPrice 
		,c4fSecondOriginalPrice 
		,c4fSecondModifiers 
		,c4fSecondComparison 
		,c4fSecondClass 
		,c4fSecondCurrency 
		,c5fVehicleCountID 
		,c5fVehicleID  as c5fVehicleName
		,c5fVehicleCategoryName 
		,c5fVehicleCategoryID 
		,c5fMainWebsite   as c5fMainWebsite 
		,c5fScanTotalPrice 
		,c5fScanOriginalPrice 
		,c5fScanModifiers 
		,c5fScanClass 
		,c5fScanComparison 
		,c5fScanCurrency 
		,c5fSecondWebsite   as c5fSecondWebsite
		,c5fSecondPrice 
		,c5fSecondOriginalPrice 
		,c5fSecondModifiers 
		,c5fSecondComparison 
		,c5fSecondClass 
		,c5fSecondCurrency 
	FROM #tTempTableFinal
	ORDER BY fCountryID, fPickupLocationID, fReturnLocationID, fPickupDate, cast(fVehicleCountID as int) --, fVehicleCategoryID

	--get list of pickup and drop off locations
	DECLARE @listStr VARCHAR(MAX), @comboCount int, @maxcomboCount int, @thisPickupLocID int, @thisReturnLocID int, @thisPickupLocName nvarchar(50), @thisReturnLoName nvarchar(50)
	SET @listStr = ''
	SET @comboCount = 1
	SET @maxcomboCount = (SELECT count(fid) from @locationCombinationsTAB)

	WHILE @comboCount <= @maxcomboCount
		BEGIN
			SET @thisPickupLocID = (SELECT fPickupLocationID FROM @locationCombinationsTAB WHERE fID = @comboCount)
			SET @thisReturnLocID = (SELECT fReturnLocationID FROM @locationCombinationsTAB WHERE fID = @comboCount)
			SET @thisPickupLocName = (SELECT fLocationName FROM tRefLocation WHERE fID = @thisPickupLocID)
			SET @thisReturnLoName = (SELECT fLocationName FROM tRefLocation WHERE fID = @thisReturnLocID)

			SET @listStr= 
				CASE
					WHEN @comboCount = 1
					THEN concat(@thisPickupLocID  ,  cast('_' as nvarchar(1))  ,  @thisPickupLocName  ,  cast('-' as nvarchar(1))  ,  @thisReturnLocID  ,  cast('_' as nvarchar(1))  ,  @thisReturnLoName)
					ELSE concat(@listStr , cast(';' as nvarchar(1)) , @thisPickupLocID , cast('_' as nvarchar(1)) , @thisPickupLocName , cast('-' as nvarchar(1)) , @thisReturnLocID , cast('_' as nvarchar(1)) , @thisReturnLoName)
				END
			SET @comboCount = @comboCount + 1
		END

	--SELECT values for filters
	SELECT  @DataSetDateStart as DataSetDateStart, @TravelDateRanges as TravelDateRanges, @CountryID as CountryID, @BrandID as BrandID, 
			@LicenceCountryID as LicenceCountryID, @PriceExceptions as PriceExceptions, @rateOption as rateOption,
			@selectApolloFamilyVehicles as selectApolloFamilyVehicles, @showPercentOrPrice as showPercentOrPrice,
			(SELECT fQuickReportScanURLs FROM tRefQuickReport WHERE fID = @quickReportNumber) as ScanURLs, 
			@listStr as PickupReturnLocationComboID


	--remove table that is no longer needed
	IF OBJECT_ID('tempdb..#Vehicletable') IS NOT NULL
	/*Then it exists*/
    DROP TABLE #Vehicletable
	IF OBJECT_ID('tempdb..#tTempTableFinal') IS NOT NULL
	/*Then it exists*/
	   DROP TABLE #tTempTableFinal
	   
	-- drop unneeded data
	DELETE FROM @locationCombinationsTAB


END



GO
/****** Object:  StoredProcedure [dbo].[getScanDataCleanChartVehiclePriceOverTime]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <20/04/15>
-- Description:	<Get data from clean data table to graph prices over time>
-- =============================================
CREATE PROCEDURE [dbo].[getScanDataCleanChartVehiclePriceOverTime]
  @DataSetDateStart nvarchar(MAX)
, @PickUpDateRangeStart nvarchar(MAX)
, @CountryID int
, @BrandID int
, @PickupLocationID int
, @ReturnLocationID int 
, @VehicleID int
, @VehicleTypeID int
, @VehicleBerthID int
, @LicenceCountryID int
, @ScanURL int
, @PriceExceptions int
, @addComparisonVehicle int

AS
BEGIN	

DECLARE 
	  @SecondScanURL int
	, @ThirdScanURL int
	, @FourthScanURL int
	, @FifthScanURL int
	, @SixthScanURL int
	, @SeventhScanURL int
	, @EighthScanURL int
	, @minValue decimal (18,2)
	, @maxValue decimal (18,2)

	SET @SecondScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,2)
	SET @ThirdScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,3)
	SET @FourthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,4)
	SET @FifthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,5)
	SET @SixthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,6)
	SET @SeventhScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,7)
	SET @EighthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,8)
	SET @minValue = 100000.00
	SET @maxValue = 0.00
	
	DECLARE @DataSetDateStartSDT smalldatetime

	SET @DataSetDateStartSDT = 
	CASE 
		WHEN  (@DataSetDateStart = 'NULL' OR @DataSetDateStart is Null)
			THEN CONVERT(SMALLDATETIME, '2000-01-01 00:00:01')
		ELSE
			CONVERT(SMALLDATETIME, @DataSetDateStart)
	END


	
	DECLARE @tDates TABLE (fScanPickupDate smalldatetime, fTravelDates nvarchar(max), fActive int)
	
    -- Insert into temp table 
	INSERT INTO @tDates
	SELECT 	fScanPickupDate, (CONCAT( CONVERT(VARCHAR(11),fScanPickupDate,6) , ' - ' , CONVERT(VARCHAR(11),fScanReturnDate,6))) As fTravelDates	, 1
	FROM (
		SELECT DISTINCT fScanPickupDate,  fScanReturnDate
		FROM tDataScanClean
		WHERE (fScanDate >=  @DataSetDateStartSDT) and (fScanDate <=  dateadd(day, 7,@DataSetDateStartSDT) )	
	) as tMain
	ORDER BY fScanPickupDate ASC
	

	DECLARE @sum as int, 
			@counter as int ,
			@thisDate date,
			@stringSite1 nvarchar(max), @stringSite2 nvarchar(max), @stringSite3 nvarchar(max), @stringSite4 nvarchar(max), 
			@stringSite5 nvarchar(max), @stringSite6 nvarchar(max), @stringSite7 nvarchar(max), @stringSite8 nvarchar(max),
			@priceOne decimal (18,2), @priceTwo decimal (18,2), @priceThree decimal (18,2), @priceFour decimal (18,2),
			@priceFive decimal (18,2), @priceSix decimal (18,2), @priceSeven decimal (18,2), @priceEight decimal (18,2),
			@comparisonValue decimal (18,2), @comparisonString nvarchar(max)
	SET @sum = (select count (fTravelDates) from @tDates)
	SET @counter = 0	
	SET @stringSite1 = ''
	SET @stringSite2 = ''
	SET @stringSite3 = ''
	SET @stringSite4 = ''
	SET @stringSite5 = ''
	SET @stringSite6 = ''
	SET @stringSite7 = ''
	SET @stringSite8 = ''
	SET @comparisonValue = 0.00
	SET @comparisonString = ''
	

	--temp table to contain relevant data
	CREATE TABLE #tTempTablePriceOverTime
		(
		   fScanID int
		  ,fScanDate smalldatetime
		  ,fScanURL int
		  ,fScanTravelCountryID int
		  ,fScanPickupLocationID int
		  ,fScanReturnLocationID int
		  ,fScanPickupDate smalldatetime
		  ,fScanReturnDate smalldatetime
		  ,fScanLicenceCountryID int
		  ,fScanBrandID int
		  ,fScanVehicleID int
		  ,fScanTotalPrice decimal(18,2)
		  ,fScanCurrencyID int
		)
	-- fill table with relevant data
	INSERT INTO #tTempTablePriceOverTime
	SELECT	MIN(tTemp.fScanID) as fScanID
			,tTemp.fScanDate
			,tTemp.[fScanURL]
			,tTemp.[fScanTravelCountryID]
			,tTemp.[fScanPickupLocationID]
			,tTemp.[fScanReturnLocationID]
			,tTemp.[fScanPickupDate]
			,tTemp.[fScanReturnDate]
			,tTemp.[fScanLicenceCountryID]
			,tTemp.[fScanBrandID]
			,tTemp.[fScanVehicleID]
			,[dbo].[convertPriceToCurrency](tTemp.fScanTotalPrice, tTemp.fScanCurrencyID, tTemp.fScanDate, tTemp.fScanTravelCountryID) as fScanTotalPrice
			,tTemp.[fScanCurrencyID]	
	from tDataScanClean as tTemp
	WHERE 
	(tTemp.fScanDate >= @DataSetDateStartSDT AND tTemp.fScanDate <= DATEADD(day,7,@DataSetDateStartSDT) OR @DataSetDateStart = 'NULL' OR @DataSetDateStart is Null )
	AND (tTemp.fScanVehicleID  = @VehicleID OR @VehicleID = 0 OR tTemp.fScanVehicleID in (SELECT fVehicleOneID FROM tRefVehicleEquivalent WHERE fVehicleTwoID = @VehicleID ))
	AND (tTemp.fScanPickupLocationID = @PickupLocationID OR @PickupLocationID = 0)
	AND (tTemp.fScanReturnLocationID = @ReturnLocationID OR @ReturnLocationID = 0)
	AND (tTemp.fScanBrandID = @BrandID OR @BrandID = 0 OR tTemp.fScanVehicleID in (SELECT fVehicleOneID FROM tRefVehicleEquivalent WHERE fVehicleTwoID = @VehicleID ))
	AND (tTemp.fScanTravelCountryID = @CountryID OR @CountryID = 0)
	AND ((tTemp.fScanVehicleID in (SELECT fID from tRefVehicle WHERE fVehicleTypeID = @VehicleTypeID)) OR @VehicleTypeID = 0 OR tTemp.fScanVehicleID in (SELECT fVehicleOneID FROM tRefVehicleEquivalent WHERE fVehicleTwoID = @VehicleID ))
	AND ((tTemp.fScanVehicleID in (SELECT fID from tRefVehicle WHERE (fVehicleBerthAdults + fVehicleBerthChildren) = @VehicleBerthID)) OR @VehicleBerthID = 0 OR tTemp.fScanVehicleID in (SELECT fVehicleOneID FROM tRefVehicleEquivalent WHERE fVehicleTwoID = @VehicleID ))
	GROUP BY tTemp.[fScanDate]
      ,tTemp.[fScanURL]
      ,tTemp.[fScanTravelCountryID]
      ,tTemp.[fScanPickupLocationID]
      ,tTemp.[fScanReturnLocationID]
      ,tTemp.[fScanPickupDate]
      ,tTemp.[fScanReturnDate]
      ,tTemp.[fScanLicenceCountryID]
      ,tTemp.[fScanBrandID]
      ,tTemp.[fScanVehicleID]
      ,tTemp.[fScanTotalPrice]
      ,tTemp.[fScanCurrencyID]	  

	--for each set of dates
	WHILE @counter < @sum
		BEGIN
			SET @thisDate = (SELECT TOP 1 fScanPickupDate from @tDates WHERE fActive = 1 ORDER BY fScanPickupDate ASC)
			UPDATE @tDates SET fActive = 0 WHERE fScanPickupDate in (select top 1 fScanPickupDate from @tDates WHERE fActive = 1 ORDER BY fScanPickupDate ASC)
			
			SET @priceOne = cast ((SELECT TOP 1 [dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions) from #tTempTablePriceOverTime 			
								WHERE (fScanPickupDate = @thisDate)
									AND fScanURL = @ScanURL
									AND fScanVehicleID  = @VehicleID
								) as decimal(18,2))			
			SET @priceOne = 
					CASE
						WHEN @priceOne is NULL
						THEN 0
						ELSE @priceOne
					END
			SET @stringSite1 = 
					CASE 
						WHEN NOT @priceOne is NULL
						THEN 
							CASE
								WHEN @stringSite1 = '' 
								THEN cast(cast(@priceOne as int) as nvarchar(50))
								ELSE concat (@stringSite1,',',cast(@priceOne as int))
							END
						ELSE @stringSite1
					END	
								
			SET @priceTwo = cast ((SELECT TOP 1 [dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions) from #tTempTablePriceOverTime 			
								WHERE (fScanPickupDate = @thisDate )
									AND fScanURL = @SecondScanURL
									AND fScanVehicleID  = @VehicleID
								) as decimal(18,2))
			SET @priceTwo = 
					CASE
						WHEN @priceTwo is NULL
						THEN 0
						ELSE @priceTwo
					END
			SET @stringSite2 = 
					CASE 
						WHEN NOT @priceTwo is NULL 
						THEN 
							CASE
								WHEN @stringSite2 = '' 
								THEN cast(cast(@priceTwo as int) as nvarchar(50))
								ELSE concat (@stringSite2,',',cast(@priceTwo as int))
							END
						ELSE @stringSite2
					END

			SET @priceThree = cast ((SELECT TOP 1 [dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions) from #tTempTablePriceOverTime 			
								WHERE (fScanPickupDate = @thisDate )
									AND fScanURL = @ThirdScanURL
									AND fScanVehicleID  = @VehicleID
								) as decimal(18,2))
			SET @priceThree = 
					CASE
						WHEN @priceThree is NULL
						THEN 0
						ELSE @priceThree
					END
			SET @stringSite3 = 
					CASE 
						WHEN NOT @priceThree is NULL 
						THEN 
							CASE
								WHEN @stringSite3 = '' 
								THEN cast(cast(@priceThree as int) as nvarchar(50))
								ELSE concat (@stringSite3,',',cast(@priceThree as int))
							END
						ELSE @stringSite3
					END

			SET @priceFour = cast ((SELECT TOP 1 [dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions) from #tTempTablePriceOverTime 			
								WHERE (fScanPickupDate = @thisDate)
									AND fScanURL = @FourthScanURL
									AND fScanVehicleID  = @VehicleID
								) as decimal(18,2))
			SET @priceFour = 
					CASE
						WHEN @priceFour is NULL
						THEN 0
						ELSE @priceFour
					END
			SET @stringSite4 =
					CASE 
						WHEN NOT @priceFour is NULL 
						THEN 
							CASE
								WHEN @stringSite4 = '' 
								THEN cast(cast(@priceFour as int) as nvarchar(50))
								ELSE concat (@stringSite4,',',cast(@priceFour as int))
							END
						ELSE @stringSite4
					END

			SET @priceFive = cast ((SELECT TOP 1 [dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions) from #tTempTablePriceOverTime 			
								WHERE (fScanPickupDate = @thisDate)
									AND fScanURL = @FifthScanURL
									AND fScanVehicleID  = @VehicleID
								) as decimal(18,2))
			SET @priceFive = 
					CASE
						WHEN @priceFive is NULL
						THEN 0
						ELSE @priceFive
					END
			SET @stringSite5 = 
					CASE 
						WHEN NOT @priceFive is NULL 
						THEN 
							CASE
								WHEN @stringSite5 = '' 
								THEN cast(cast(@priceFive as int) as nvarchar(50))
								ELSE concat (@stringSite5,',',cast(@priceFive as int))
							END
						ELSE @stringSite5
					END

			SET @priceSix = cast ((SELECT TOP 1 [dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions) from #tTempTablePriceOverTime 			
								WHERE (fScanPickupDate = @thisDate)
									AND fScanURL = @SixthScanURL
									AND fScanVehicleID  = @VehicleID
								) as decimal(18,2))
			SET @priceSix = 
					CASE
						WHEN @priceSix is NULL
						THEN 0
						ELSE @priceSix
					END
			SET @stringSite6 = 
					CASE 
						WHEN NOT @priceSix is NULL 
						THEN 
							CASE
								WHEN @stringSite6 = '' 
								THEN cast(cast(@priceSix as int) as nvarchar(50))
								ELSE concat (@stringSite6,',',cast(@priceSix as int))
							END
						ELSE @stringSite6
					END

			SET @priceSeven = cast ((SELECT TOP 1 [dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions) from #tTempTablePriceOverTime 			
								WHERE (fScanPickupDate = @thisDate)
									AND fScanURL = @SeventhScanURL
									AND fScanVehicleID  = @VehicleID
								) as decimal(18,2))
			SET @priceSeven = 
					CASE
						WHEN @priceSeven is NULL
						THEN 0
						ELSE @priceSeven
					END
			SET @stringSite7 = 
					CASE 
						WHEN NOT @priceSeven is NULL 
						THEN 
							CASE
								WHEN @stringSite7 = '' 
								THEN cast(cast(@priceSeven as int) as nvarchar(50))
								ELSE concat (@stringSite7,',',cast(@priceSeven as int))
							END
						ELSE @stringSite7
					END

			SET @priceEight = cast ((SELECT TOP 1 [dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions) from #tTempTablePriceOverTime 			
								WHERE (fScanPickupDate = @thisDate)
									AND fScanURL = @EighthScanURL
									AND fScanVehicleID  = @VehicleID
								) as decimal(18,2))
			SET @priceEight = 
					CASE
						WHEN @priceEight is NULL
						THEN 0
						ELSE @priceEight
					END
			SET @stringSite8 = 
					CASE 
						WHEN NOT @priceEight is NULL 
						THEN 
							CASE
								WHEN @stringSite8 = '' 
								THEN cast(cast(cast(@priceEight as int) as int) as nvarchar(50))
								ELSE concat (@stringSite8,',',cast(@priceEight as int))
							END
						ELSE @stringSite8
					END

			-- get comparison vehicle values
			SET @comparisonValue = cast ((SELECT TOP 1 [dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions) from #tTempTablePriceOverTime 			
								WHERE (fScanPickupDate = @thisDate)
									AND fScanURL = 1
									AND NOT fScanVehicleID = @VehicleID
								) as decimal(18,2))
			SET @comparisonValue = 
					CASE
						WHEN @comparisonValue is NULL
						THEN 0
						ELSE @comparisonValue
					END
			SET @comparisonString = 
					CASE 
						WHEN @comparisonString = '' 
						THEN concat (@comparisonString,cast(@comparisonValue as int))
						ELSE concat (@comparisonString,',',cast(@comparisonValue as int))
					END	

			-- calculate max and min values 
			DECLARE @checkMinValue int
			DECLARE @checkMaxValue int
			SET @checkMinValue = (SELECT Top 1 cast(price as int) from (select @priceOne as price UNION ALL SELECT @priceTwo UNION ALL SELECT @priceThree UNION ALL SELECT @priceFour UNION ALL SELECT @priceFive UNION ALL SELECT @priceSix UNION ALL SELECT @priceSeven UNION ALL SELECT @priceEight) as minV WHERE NOT price = 0 ORDER BY PRICE ASC)
			SET @checkMaxValue = (SELECT Top 1 cast(price as int) from (select @priceOne as price UNION ALL SELECT @priceTwo UNION ALL SELECT @priceThree UNION ALL SELECT @priceFour UNION ALL SELECT @priceFive UNION ALL SELECT @priceSix UNION ALL SELECT @priceSeven UNION ALL SELECT @priceEight) as maxV WHERE NOT price = 0 ORDER BY PRICE DESC)
			SET @minValue = 
				CASE
					WHEN @checkMinValue < @minValue AND NOT @checkMinValue = 0
					THEN @checkMinValue
					ELSE @minValue
				END			
			SET @maxValue = 
				CASE
					WHEN @checkMaxValue > @maxValue AND NOT @checkMaxValue = 0
					THEN @checkMaxValue
					ELSE @maxValue
				END

			SET @counter = @counter + 1
	END	

	SET @comparisonString =
		CASE 
			WHEN @addComparisonVehicle = 0
			THEN ''
			ELSE @comparisonString
		END


	-- get string list of dates
	DECLARE @sumDates as int
	SET @sumDates = (select count (fTravelDates) from @tDates)
	DECLARE @counterDates as int
	SET @counterDates = 0
	DECLARE @stringDates nvarchar(max)
	SET @stringDates = ''
	WHILE @counterDates < @sumDates
		BEGIN
			SET @stringDates = 
				CASE 
					WHEN NOT @stringSite1 = ''
					THEN
						CASE
							WHEN @stringDates = ''
							THEN concat('"',(SELECT TOP 1 fTravelDates from @tDates ORDER BY fScanPickupDate ASC),'"')
							ELSE concat(@stringDates,',"',(SELECT TOP 1 fTravelDates from @tDates ORDER BY fScanPickupDate ASC),'"')
						END
					ELSE @stringDates
				END
			DELETE from @tDates WHERE fTravelDates in (select top 1 fTravelDates from @tDates  ORDER BY fScanPickupDate ASC)
			SET @counterDates = @counterDates + 1
	END	
		 	
	--SELECT  '0' as fURL, '0,0,0,0,0,0,0,0,0,0' as fString 
	SELECT * FROM (
		SELECT  '0' as fURL, @stringDates as fString 
				UNION ALL 		
		SELECT  @ScanURL, @comparisonString 
				UNION ALL 
		SELECT  @ScanURL, @stringSite1 
				UNION ALL 
		SELECT  @SecondScanURL, @stringSite2
				UNION ALL 
		SELECT  @ThirdScanURL , @stringSite3
				UNION ALL 
		SELECT  @FourthScanURL , @stringSite4
				UNION ALL 
		SELECT  @FifthScanURL , @stringSite5
				UNION ALL 
		SELECT  @SixthScanURL , @stringSite6
				UNION ALL 
		SELECT  @SeventhScanURL , @stringSite7
				UNION ALL 
		SELECT  @EighthScanURL , @stringSite8
	) AS tFinal where not fString = '' and not fString = '0,0,0,0,0,0,0,0,0,0'

	SELECT 'MIN' as fName, cast(@minValue as int) as fValue

	SELECT 'MAX' as fName, cast(@maxValue as int) as fValue

	
	DELETE FROM #tTempTablePriceOverTime

END


GO
/****** Object:  StoredProcedure [dbo].[getScanDataCleanChartVehiclePriceOverTimeAcrossDataSets]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <20/04/15>
-- Description:	<Get data from clean data table to graph prices over time>
-- =============================================
CREATE PROCEDURE [dbo].[getScanDataCleanChartVehiclePriceOverTimeAcrossDataSets]
  @DataSetDateStart nvarchar(MAX)
, @TravelDateRanges nvarchar(MAX)
, @CountryID int
, @BrandID int
, @PickupReturnLocationComboID nvarchar(max) 
, @VehicleID nvarchar(max)
, @VehicleTypeID int
, @VehicleBerthID int
, @LicenceCountryID int
, @ScanURLs nvarchar(max) 
, @PriceExceptions int
, @addComparisonVehicle int

AS
BEGIN	


DECLARE  @minValue decimal (18,2)
		,@maxValue decimal (18,2)
		,@firstDataSet int

SET @minValue = 100000.00
SET @maxValue = 0.00
	

	-- convert start date if needed
	DECLARE @DataSetDateStartSDT date
	SET @DataSetDateStartSDT = 
	CASE 
		WHEN  (@DataSetDateStart = 'NULL' OR @DataSetDateStart is Null)
			THEN CONVERT(date, '2000-01-01 00:00:01')
		ELSE
			CONVERT(date, @DataSetDateStart)
	END


	--create a table list of the URLs to eb included
	DECLARE @tableScanURLs TABLE (fScanURL nvarchar(max))
	INSERT INTO @tableScanURLs (fScanURL)
	SELECT Split.a.value('.', 'VARCHAR(100)') AS String from (SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](@ScanURLs), ';', '</M><M>') + '</M>' AS XML) AS String ) AS a CROSS APPLY String.nodes ('/M') AS Split(a)

	--create list of location combinations
	DECLARE @locationCombinationsTAB TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fPickupLocationID int, fReturnLocationID int)
	INSERT INTO @locationCombinationsTAB (fPickupLocationID, fReturnLocationID)
	SELECT substring(string,1,charindex('-',string)-1), reverse(substring(reverse(string),0,charindex('-',reverse(string)))) 
	FROM (SELECT Split.a.value('.', 'VARCHAR(100)') AS String from (SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](@PickupReturnLocationComboID), ';', '</M><M>') + '</M>' AS XML) AS String ) AS a CROSS APPLY String.nodes ('/M') AS Split(a)) as t
	--get country this report is for
	DECLARE @locCountryID int
	SET @locCountryID =
		CASE
			WHEN @countryID = 0
			THEN (select fCountryID from tRefLocation WHERE fID = (SELECT top 1 fPickupLocationID from @locationCombinationsTAB))
			ELSE @locCountryID
		END
	--add combinations where "all return locations" was selected for a specific pickup location
	INSERT INTO @locationCombinationsTAB (fPickupLocationID, fReturnLocationID)
	SELECT t.fPickupLocationID, tR.fID FROM @locationCombinationsTAB t
	CROSS JOIN (SELECT fID from tRefLocation WHERE fCountryID = @countryID) tR	
	WHERE fReturnLocationID = 0
	--add combinations where "all pickup locations" was selected for a specific return location
	INSERT INTO @locationCombinationsTAB (fPickupLocationID, fReturnLocationID)
	SELECT tP.fID, tR.fReturnLocationID FROM (SELECT fID from tRefLocation WHERE fCountryID = @countryID) tP
	CROSS JOIN (SELECT fReturnLocationID FROM @locationCombinationsTAB WHERE fPickupLocationID = 0) tR
	--remove unnecessary lines
	DELETE FROM @locationCombinationsTAB
	WHERE fPickupLocationID = 0 or fReturnLocationID = 0

	--sELECT * FROM @locationCombinationsTAB

	--create list of travel date ranges
	DECLARE @travelDatesFilterTAB TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fPickupDate date, fReturnDate date)
	INSERT INTO @travelDatesFilterTAB (fPickupDate, fReturnDate)
	SELECT substring(string,1,charindex(',',string)-1), reverse(substring(reverse(string),0,charindex(',',reverse(string)))) 
	FROM (SELECT Split.a.value('.', 'VARCHAR(100)') AS String from (SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](@TravelDateRanges), ';', '</M><M>') + '</M>' AS XML) AS String ) AS a CROSS APPLY String.nodes ('/M') AS Split(a)) as t
					
			
    -- temp table of dates in this report
	DECLARE @tDates TABLE (fldID int IDENTITY(1,1) PRIMARY KEY, fScanPickupDate date, fTravelDates nvarchar(max), fActive int)
	INSERT INTO @tDates (fScanPickupDate, fTravelDates, fActive)
	SELECT 	fScanPickupDate, (CONCAT( CONVERT(VARCHAR(11),fScanPickupDate,6) , ' - ' , CONVERT(VARCHAR(11),fScanReturnDate,6))) As fTravelDates	, 1
	FROM (
		SELECT DISTINCT fScanPickupDate, fScanReturnDate
		FROM tDataScanClean
		WHERE (fScanDate >=  dateadd(day,-1,@DataSetDateStartSDT)) and (fScanDate <=  dateadd(day, 6,@DataSetDateStartSDT) )	
	) as tMain
	ORDER BY fScanPickupDate ASC
		
	--SELECT * FROM @travelDatesFilterTAB

	-- Get list of data sets	
	DECLARE @tDataSets TABLE (fldID int IDENTITY(1,1) PRIMARY KEY, fScanDate date, fYear nvarchar(50))	
    -- Insert into temp table 
	INSERT INTO @tDataSets (fScanDate, fYear)
	exec getFinancialYearListWeeksAndDates	
	--remove old dates
	DELETE FROM @tDataSets WHERE fScanDate <= (SELECT TOP 1 fFirstDate FROM tRefFirstDate)
	DELETE FROM @tDataSets WHERE fScanDate > @DataSetDateStartSDT

	--SELECT * FROM @tDataSets

	-- Set the most recent data set to be included
	SET @firstDataSet = (SELECT min(fldID) FROM @tDataSets)
	
	--SELECT @firstDataSet

	--temp table to contain relevant data
	CREATE TABLE  #tTempTablePriceOverTime 
		(fScanID int
		  ,fScanDate date
		  ,fScanURL int
		  ,fScanTravelCountryID int
		  ,fScanPickupLocationID int
		  ,fScanReturnLocationID int
		  ,fScanPickupDate date
		  ,fScanReturnDate date
		  ,fScanLicenceCountryID int
		  ,fScanBrandID int
		  ,fScanVehicleID int
		  ,fScanTotalPrice decimal(18,2)
		  ,fScanCurrencyID int)


	-- fill table with data that is relevant for this report
	INSERT INTO #tTempTablePriceOverTime
	SELECT	tTemp.fScanID as fScanID
		,[dbo].[getFirstDayOfWeek](tTemp.fScanDate)
		,tTemp.[fScanURL]
		,tTemp.[fScanTravelCountryID]
		,tTemp.[fScanPickupLocationID]
		,tTemp.[fScanReturnLocationID]
		,tTemp.[fScanPickupDate]
		,tTemp.[fScanReturnDate]
		,tTemp.[fScanLicenceCountryID]
		,tTemp.[fScanBrandID]
		,tTemp.[fScanVehicleID]
		,[dbo].[convertPriceToCurrency](tTemp.fScanTotalPrice, tTemp.fScanCurrencyID, tTemp.fScanDate, tTemp.fScanTravelCountryID) as fScanTotalPrice
		,tTemp.[fScanCurrencyID]	
	from tDataScanClean as tTemp
	INNER JOIN @locationCombinationsTAB as tL on tL.fPickupLocationID = tTemp.[fScanPickupLocationID] AND  tL.fReturnLocationID = tTemp.[fScanReturnLocationID]
	INNER JOIN ((SELECT Split.a.value('.', 'VARCHAR(100)') AS String from (SELECT CAST ('<M>' + REPLACE([dbo].[replaceIllegalChar](@VehicleID), ';', '</M><M>') + '</M>' AS XML) AS String ) AS a CROSS APPLY String.nodes ('/M') AS Split(a))) as tV on TV.string = tTemp.fScanVehicleID AND NOT @VehicleID = '0'

	WHERE tTemp.fScanDate in (SELECT tTemp.fScanDate FROM @tDataSets)
		AND (@ScanURLs = '0' OR fScanURL in (SELECT fScanURL FROM @tableScanURLs))
		AND ((@TravelDateRanges = '2000-01-01,2000-01-01' AND tTemp.fScanPickupDate in (SELECT fScanPickupDate FROM @tDates))
			 OR 
			 (tTemp.fScanPickupDate in (SELECT fPickupDate FROM @travelDatesFilterTAB) AND tTemp.fScanReturnDate in (SELECT fReturnDate FROM @travelDatesFilterTAB WHERE tTemp.fScanPickupDate = fPickupDate))
		)
		AND (tTemp.fScanBrandID = @BrandID OR @BrandID = 0)
		AND (tTemp.fScanTravelCountryID = @CountryID OR @CountryID = 0)
	    AND (tTemp.fScanLicenceCountryID = [dbo].[getLicenceCountryByIntOrDom](tTemp.fScanURL, @CountryID, @LicenceCountryID))


		--SELECT * FROM #tTempTablePriceOverTime
	  	
	DELETE FROM @locationCombinationsTAB

	---- setup table to hold final data
	CREATE TABLE #FinalData (
			   fldID int IDENTITY(1,1) PRIMARY KEY
			  ,dataRangeID int
			  ,fScanID int
			  ,minPrice decimal(18,2)
			  ,maxPrice decimal(18,2)
			  ,fURL int
			  ,fTravelCountryID  int
			  ,fPickupLocationID  int
			  ,fReturnLocationID  int
			  ,fPickupLocationName  nvarchar(max)
			  ,fReturnLocationName  nvarchar(max)
			  ,fPickupDate nvarchar(max)
			  ,fReturnDate nvarchar(max)
			  ,fLicenceCountryID  int
			  ,fBrandID  int
			  ,fVehicleID  int
			  ,fVehicleName  nvarchar(max)
			  ,fTotalPriceList nvarchar(max)
			  ,fScanCurrencyID  int
			  )


	-- fill final data table with first (most recent) data set
	INSERT INTO #FinalData (fScanID 
							,dataRangeID
							,minPrice
							,maxPrice
							,fURL 
							,fTravelCountryID  
							,fPickupLocationID  
							,fReturnLocationID  
						    ,fPickupLocationName
						    ,fReturnLocationName 
							,fPickupDate 
							,fReturnDate 
							,fLicenceCountryID  
							,fBrandID  
							,fVehicleID  
							,fVehicleName 
							)
	SELECT   fScanID 
			,'1' 
			,10000
			,0
			,fScanURL
			,fScanTravelCountryID 
			,fScanPickupLocationID 
			,fScanReturnLocationID 
			,tPL.fLocationName
			,tRL.fLocationName
			,cast(fScanPickupDate as nvarchar(max))
			,cast(fScanReturnDate as nvarchar(max))
			,[dbo].[getLicenceCountryByIntOrDom](fScanURL,fScanTravelCountryID,fScanLicenceCountryID)
			,fScanBrandID 
			,fScanVehicleID 
			,tV.fVehicleName
	FROM #tTempTablePriceOverTime tT
	INNER JOIN tRefVehicle as tV on tV.fID = tT.fScanVehicleID
	INNER JOIN tRefLocation as tPL on tPL.fID = tT.fScanPickupLocationID
	INNER JOIN tRefLocation as tRL on tRL.fID = tT.fScanReturnLocationID
	WHERE fScanDate = (SELECT fScanDate FROM @tDataSets WHERE fldID = @firstDataSet)
	ORDER BY fScanPickupDate ASC
	
	--SELECT * FROM #FinalData

	

	-- declare variables for subsequent while statement
	DECLARE @PriceList nvarchar(max), @PriceToAdd nvarchar(max), @dataSetCount int, @dataSetMAX int, @dataRowCount int, @dataRowMAX int, @thisDataSet date, @thisDataRow int
	SET @dataSetCount = @firstDataSet 
	SET @dataSetMAX = (SELECT max(fldID) from @tDataSets)
	SET @dataRowCount = 1
	SET @dataRowMAX = (SELECT count(fldID) from #FinalData)

	
	-- go through each row and add on the other values
	WHILE @dataSetCount <= @dataSetMAX
		BEGIN
			SET @thisDataSet = (SELECT fScanDate FROM @tDataSets WHERE @dataSetCount = fldID )
			SET @PriceList = ''	
			SET @dataRowCount = 1
			

			WHILE @dataRowCount <= @dataRowMAX
			BEGIN
				SET @PriceList = (SELECT fTotalPriceList from #FinalData WHERE fldID = @dataRowCount)
				SET @thisDataRow = (SELECT fScanID from #FinalData WHERE fldID = @dataRowCount)
				-- reset max and min values
				SET @minValue = cast((SELECT minPrice FROM #FinalData WHERE fldID = @dataRowCount) as decimal(18,2))
				SET @maxValue = cast((SELECT maxPrice FROM #FinalData WHERE fldID = @dataRowCount) as decimal(18,2))

				DECLARE @thisScanURL int, @thisCountry int, @thisPickupID int, @thisReturnID int, @thisPickupDate date, @thisReturnDate date, @thisLicence int, @thisBrandID int, @thisVehicleID int, @thisCurrencyID int
				SET @thisScanURL = (SELECT top 1 fURL from #FinalData WHERE fScanID = @thisDataRow ORDER BY fURL DESC)
				SET @thisCountry = (SELECT top 1 fTravelCountryID from #FinalData WHERE fScanID = @thisDataRow ORDER BY fTravelCountryID DESC)
				SET @thisPickupID = (SELECT top 1 fPickupLocationID from #FinalData WHERE fScanID = @thisDataRow ORDER BY fPickupLocationID DESC)
				SET @thisReturnID = (SELECT top 1 fReturnLocationID from #FinalData WHERE fScanID = @thisDataRow ORDER BY fReturnLocationID DESC)
				SET @thisPickupDate = (SELECT top 1 fPickupDate from #FinalData WHERE fScanID = @thisDataRow ORDER BY fPickupDate DESC)
				SET @thisReturnDate =(SELECT top 1 fReturnDate from #FinalData WHERE fScanID = @thisDataRow ORDER BY fReturnDate DESC)
				SET @thisLicence = (SELECT top 1 fLicenceCountryID from #FinalData WHERE fScanID = @thisDataRow ORDER BY fLicenceCountryID DESC)
				SET @thisBrandID = (SELECT top 1 fBrandID from #FinalData WHERE fScanID = @thisDataRow ORDER BY fBrandID DESC)
				SET @thisVehicleID = (SELECT top 1 fVehicleID from #FinalData WHERE fScanID = @thisDataRow ORDER BY fVehicleID DESC)
				SET @thisCurrencyID = (SELECT top 1 fScanCurrencyID from #FinalData WHERE fScanID = @thisDataRow ORDER BY fVehicleID DESC)

				SET @PriceToAdd =  (SELECT top 1 fScanTotalPrice from 
										(	SELECT fScanTotalPrice FROM #tTempTablePriceOverTime
											WHERE   (fScanURL  = @thisScanURL
												AND fScanTravelCountryID  = @thisCountry
												AND fScanPickupLocationID  = @thisPickupID
												AND fScanReturnLocationID  = @thisReturnID
												AND cast(fScanPickupDate as nvarchar(max)) = @thisPickupDate
												AND cast(fScanReturnDate as nvarchar(max)) = @thisReturnDate
												AND [dbo].[getLicenceCountryByIntOrDom](fScanURL,fScanTravelCountryID,fScanLicenceCountryID ) = @thisLicence
												AND fScanBrandID  = @thisBrandID
												AND fScanVehicleID  = @thisVehicleID
												AND fScanDate = @thisDataSet)
										) as t
										order by fScanTotalPrice desc
									)
				SET @PriceToAdd =  [dbo].[convertPriceByExceptions](@PriceToAdd, @thisScanURL, @thisVehicleID, @thisCountry, @thisPickupID, @thisReturnID, @thisPickupDate, @thisCurrencyID, @PriceExceptions)
				SET @minValue = 
					CASE
						WHEN @PriceToAdd < @minValue
						THEN @PriceToAdd
						ELSE @minValue
					END
				SET @maxValue = 
					CASE
						WHEN @PriceToAdd > @maxValue
						THEN @PriceToAdd
						ELSE @maxValue
					END
				
				UPDATE #FinalData 
				SET fTotalPriceList = 
						CASE 
							WHEN @PriceList = '' OR @PriceList IS NULL
							THEN @PriceToAdd
							ELSE concat(ISNULL(@PriceToAdd,0),',',@PriceList)
						END,
					minPrice = @minValue,
					maxPrice = @maxValue
				WHERE fldID = @dataRowCount

				SET @PriceToAdd = 0
				SET @dataRowCount = @dataRowCount + 1
			END
			
			SET @dataSetCount = @dataSetCount + 1
		END
		
	--SELECT * FROM #FinalData

	--remove old data
	DELETE FROM #tTempTablePriceOverTime


	-- get dates for line graph column titles
	SELECT * FROM @tDataSets ORDER BY fScanDate ASC
		
	-- get list of distinct dates in final data
	DECLARE @finalDates TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fPickupDate datetime, fReturnDate datetime, fPickupLocationID int, fReturnLocationID int)
	INSERT INTO @finalDates (fPickupDate, fReturnDate, fPickupLocationID, fReturnLocationID)
	SELECT fPickupDate, fReturnDate, fPickupLocationID, fReturnLocationID FROM #FinalData GROUP BY fPickupDate, fReturnDate, fPickupLocationID, fReturnLocationID
	
	----set variables 
	DECLARE @totalDatesInFinalData int, @count int
	SET @totalDatesInFinalData = (SELECT count(fID) FROM @finalDates)
	SET @count = 1

	
	--get number of tables
	SELECT (SELECT count(fID) FROM @finalDates) as 'graphCount'


	---- run through and get each date as a seperate table
	WHILE @count <= @totalDatesInFinalData
		BEGIN
			
			SELECT   fldID 
					,dataRangeID 
					,fScanID 
					,minPrice 
					,maxPrice 
					,fURL 
					,fTravelCountryID  
					,fPickupLocationID  
					,fReturnLocationID  
					,fPickupLocationName
					,fReturnLocationName 
					,fPickupDate
					,fReturnDate
					,fLicenceCountryID  
					,fBrandID  
					,fVehicleID  
					,fVehicleName  
					,fTotalPriceList 
					,fScanCurrencyID 
			FROM #FinalData WHERE (fPickupDate = (SELECT fPickupDate FROM @finalDates WHERE fID = @count) 
											AND fReturnDate = (SELECT fReturnDate FROM @finalDates WHERE fID = @count)
											AND fPickupLocationID = (SELECT fPickupLocationID FROM @finalDates WHERE fID = @count)
											AND fReturnLocationID = (SELECT fReturnLocationID FROM @finalDates WHERE fID = @count)											
											)
			SET @count = @count + 1
		END

END


GO
/****** Object:  StoredProcedure [dbo].[getScanDataCleanChartVehiclePriceOverTimeAcrossDataSetsTest]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <20/04/15>
-- Description:	<Get data from clean data table to graph prices over time>
-- =============================================
CREATE PROCEDURE [dbo].[getScanDataCleanChartVehiclePriceOverTimeAcrossDataSetsTest]
  @DataSetDateStart nvarchar(MAX)
, @PickUpDateRangeStart nvarchar(MAX)
, @CountryID int
, @BrandID int
, @PickupLocationID int
, @ReturnLocationID int 
, @VehicleID int
, @VehicleTypeID int
, @VehicleBerthID int
, @LicenceCountryID int
, @ScanURL int
, @PriceExceptions int
, @addComparisonVehicle int

AS
BEGIN	


DECLARE 
	  @SecondScanURL int
	, @ThirdScanURL int
	, @FourthScanURL int
	, @FifthScanURL int
	, @SixthScanURL int
	, @SeventhScanURL int
	, @EighthScanURL int
	, @minValue decimal (18,2)
	, @maxValue decimal (18,2)
	, @firstDataSet int

	SET @SecondScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,2)
	SET @ThirdScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,3)
	SET @FourthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,4)
	SET @FifthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,5)
	SET @SixthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,6)
	SET @SeventhScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,7)
	SET @EighthScanURL = [dbo].[getOrderOfComparisonData](@ScanURL,8)
	SET @minValue = 100000.00
	SET @maxValue = 0.00
	

	-- convert start date if needed
	DECLARE @DataSetDateStartSDT smalldatetime
	SET @DataSetDateStartSDT = 
	CASE 
		WHEN  (@DataSetDateStart = 'NULL' OR @DataSetDateStart is Null)
			THEN CONVERT(SMALLDATETIME, '2000-01-01 00:00:01')
		ELSE
			CONVERT(SMALLDATETIME, @DataSetDateStart)
	END
			
			
    -- temp table of dates in this report
	DECLARE @tDates TABLE (fldID int IDENTITY(1,1) PRIMARY KEY, fScanPickupDate smalldatetime, fTravelDates nvarchar(max), fActive int)
	INSERT INTO @tDates (fScanPickupDate, fTravelDates, fActive)
	SELECT 	fScanPickupDate, (CONCAT( CONVERT(VARCHAR(11),fScanPickupDate,6) , ' - ' , CONVERT(VARCHAR(11),fScanReturnDate,6))) As fTravelDates	, 1
	FROM (
		SELECT DISTINCT CAST(fScanPickupDate AS DATE) as fScanPickupDate,  CAST(fScanReturnDate AS DATE) as fScanReturnDate
		FROM tDataScanClean
		WHERE (fScanDate >=  dateadd(day,-1,@DataSetDateStartSDT)) and (fScanDate <=  dateadd(day, 6,@DataSetDateStartSDT) )	
	) as tMain
	ORDER BY fScanPickupDate ASC
		

	-- Get list of data sets	
	DECLARE @tDataSets TABLE (fldID int IDENTITY(1,1) PRIMARY KEY, fScanDate smalldatetime, fYear nvarchar(50))	
    -- Insert into temp table 
	INSERT INTO @tDataSets (fScanDate, fYear)
	exec getFinancialYearListWeeksAndDates
	

	-- Set the most recent data set to be included
	SET @firstDataSet = (SELECT fldID FROM @tDataSets WHERE cast(fScanDate as date) =  cast(@DataSetDateStartSDT as date))
	

	--remove old dates
	DELETE FROM @tDataSets WHERE cast(fScanDate as date) <= '2015-03-28'
	DELETE FROM @tDataSets WHERE cast(fScanDate as date) > @DataSetDateStartSDT
	

	--temp table to contain relevant data
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tTempTablePriceOverTime]') AND type in (N'U'))
	DROP TABLE [tTempTablePriceOverTime]
	CREATE TABLE tTempTablePriceOverTime
		(fScanID int
		  ,fScanDate smalldatetime
		  ,fScanURL int
		  ,fScanTravelCountryID int
		  ,fScanPickupLocationID int
		  ,fScanReturnLocationID int
		  ,fScanPickupDate smalldatetime
		  ,fScanReturnDate smalldatetime
		  ,fScanLicenceCountryID int
		  ,fScanBrandID int
		  ,fScanVehicleID int
		  ,fScanTotalPrice decimal(18,2)
		  ,fScanCurrencyID int)


	-- fill table with data that is relevant for this report
	INSERT INTO tTempTablePriceOverTime
	SELECT	MIN(tTemp.fScanID) as fScanID
		,[dbo].[getFirstDayOfWeek](tTemp.fScanDate)
		,tTemp.[fScanURL]
		,tTemp.[fScanTravelCountryID]
		,tTemp.[fScanPickupLocationID]
		,tTemp.[fScanReturnLocationID]
		,tTemp.[fScanPickupDate]
		,tTemp.[fScanReturnDate]
		,tTemp.[fScanLicenceCountryID]
		,tTemp.[fScanBrandID]
		,tTemp.[fScanVehicleID]
		,[dbo].[convertPriceToCurrency](tTemp.fScanTotalPrice, tTemp.fScanCurrencyID, tTemp.fScanDate, tTemp.fScanTravelCountryID) as fScanTotalPrice
		,tTemp.[fScanCurrencyID]	
	from tDataScanClean as tTemp
	WHERE cast(tTemp.fScanDate as date) in (SELECT cast(tTemp.fScanDate as date) FROM @tDataSets)
		AND (cast(tTemp.fScanPickupDate as date) in (SELECT fScanPickupDate FROM @tDates))
		AND (tTemp.fScanVehicleID  = @VehicleID OR @VehicleID = 0 OR tTemp.fScanVehicleID in (SELECT fVehicleOneID FROM tRefVehicleEquivalent WHERE fVehicleTwoID = @VehicleID ))
		AND (tTemp.fScanPickupLocationID = @PickupLocationID OR @PickupLocationID = 0)
		AND (tTemp.fScanReturnLocationID = @ReturnLocationID OR @ReturnLocationID = 0)
		AND (tTemp.fScanBrandID = @BrandID OR @BrandID = 0 OR tTemp.fScanVehicleID in (SELECT fVehicleOneID FROM tRefVehicleEquivalent WHERE fVehicleTwoID = @VehicleID ))
		AND (tTemp.fScanTravelCountryID = @CountryID OR @CountryID = 0)
		AND ((tTemp.fScanVehicleID in (SELECT fID from tRefVehicle WHERE fVehicleTypeID = @VehicleTypeID)) OR @VehicleTypeID = 0 OR tTemp.fScanVehicleID in (SELECT fVehicleOneID FROM tRefVehicleEquivalent WHERE fVehicleTwoID = @VehicleID ))
		AND ((tTemp.fScanVehicleID in (SELECT fID from tRefVehicle WHERE (fVehicleBerthAdults + fVehicleBerthChildren) = @VehicleBerthID)) OR @VehicleBerthID = 0 OR tTemp.fScanVehicleID in (SELECT fVehicleOneID FROM tRefVehicleEquivalent WHERE fVehicleTwoID = @VehicleID ))
	    AND (tTemp.fScanLicenceCountryID = [dbo].[getLicenceCountryByIntOrDom](tTemp.fScanURL, @CountryID, @LicenceCountryID))
	GROUP BY tTemp.[fScanDate]
		,tTemp.[fScanURL]
		,tTemp.[fScanTravelCountryID]
		,tTemp.[fScanPickupLocationID]
		,tTemp.[fScanReturnLocationID]
		,tTemp.[fScanPickupDate]
		,tTemp.[fScanReturnDate]
		,tTemp.[fScanLicenceCountryID]
		,tTemp.[fScanBrandID]
		,tTemp.[fScanVehicleID]
		,tTemp.[fScanTotalPrice]
		,tTemp.[fScanCurrencyID]	 
	  	

	-- setup table to hold final data
	DECLARE @FinalData table (
			   fldID int IDENTITY(1,1) PRIMARY KEY
			  ,dataRangeID int
			  ,fScanID int
			  ,minPrice decimal(18,2)
			  ,maxPrice decimal(18,2)
			  ,fURL int
			  ,fTravelCountryID  int
			  ,fPickupLocationID  int
			  ,fReturnLocationID  int
			  ,fPickupDate nvarchar(max)
			  ,fReturnDate nvarchar(max)
			  ,fLicenceCountryID  int
			  ,fBrandID  int
			  ,fVehicleID  int
			  ,fTotalPriceList nvarchar(max)
			  ,fScanCurrencyID  int
			  )


	-- fill final data table with first (most recent) data set
	INSERT INTO @FinalData (fScanID 
							,dataRangeID
							,minPrice
							,maxPrice
							,fURL 
							,fTravelCountryID  
							,fPickupLocationID  
							,fReturnLocationID  
							,fPickupDate 
							,fReturnDate 
							,fLicenceCountryID  
							,fBrandID  
							,fVehicleID  
							,fTotalPriceList
							,fScanCurrencyID)
	SELECT   fScanID 
			,'1' 
			,10000
			,0
			,fScanURL
			,fScanTravelCountryID 
			,fScanPickupLocationID 
			,fScanReturnLocationID 
			,cast(cast(fScanPickupDate as date) as nvarchar(max))
			,cast(cast(fScanReturnDate as date) as nvarchar(max))
			,[dbo].[getLicenceCountryByIntOrDom](fScanURL,fScanTravelCountryID,fScanLicenceCountryID)
			,fScanBrandID 
			,fScanVehicleID 
			,[dbo].[convertPriceByExceptions](fScanTotalPrice, fScanURL, fScanVehicleID, fScanTravelCountryID, fScanPickupLocationID, fScanReturnLocationID, fScanPickupDate, fScanCurrencyID, @PriceExceptions)
			,fScanCurrencyID
	FROM tTempTablePriceOverTime
	WHERE cast(fScanDate as date) = (SELECT cast(fScanDate as date) FROM @tDataSets WHERE fldID = @firstDataSet)
	ORDER BY fScanPickupDate ASC
	

	-- declare variables for subsequent while statement
	DECLARE @PriceList nvarchar(max), @PriceToAdd nvarchar(max), @dataSetCount int, @dataSetMAX int, @dataRowCount int, @dataRowMAX int, @thisDataSet date, @thisDataRow int
	SET @dataSetCount = @firstDataSet
	SET @dataSetMAX = (SELECT count(fldID) from @tDataSets)
	SET @dataRowCount = 1
	SET @dataRowMAX = (SELECT count(fldID) from @FinalData)

	
	-- go through each row and add on the other values
	WHILE @dataSetCount <= @dataSetMAX
		BEGIN
			SET @thisDataSet = cast((SELECT fScanDate FROM @tDataSets WHERE @dataSetCount = fldID ) as date)
			SET @PriceList = ''	
			SET @dataRowCount = 1
			

			WHILE @dataRowCount <= @dataRowMAX
			BEGIN
				SET @PriceList = (SELECT fTotalPriceList from @FinalData WHERE fldID = @dataRowCount)
				SET @thisDataRow = (SELECT fScanID from @FinalData WHERE fldID = @dataRowCount)
				-- reset max and min values
				SET @minValue = cast((SELECT minPrice FROM @FinalData WHERE fldID = @dataRowCount) as decimal(18,2))
				SET @maxValue = cast((SELECT maxPrice FROM @FinalData WHERE fldID = @dataRowCount) as decimal(18,2))

				DECLARE @thisScanURL int, @thisCountry int, @thisPickupID int, @thisReturnID int, @thisPickupDate date, @thisReturnDate date, @thisLicence int, @thisBrandID int, @thisVehicleID int, @thisCurrencyID int
				SET @thisScanURL = (SELECT top 1 fURL from @FinalData WHERE fScanID = @thisDataRow ORDER BY fURL DESC)
				SET @thisCountry = (SELECT top 1 fTravelCountryID from @FinalData WHERE fScanID = @thisDataRow ORDER BY fTravelCountryID DESC)
				SET @thisPickupID = (SELECT top 1 fPickupLocationID from @FinalData WHERE fScanID = @thisDataRow ORDER BY fPickupLocationID DESC)
				SET @thisReturnID = (SELECT top 1 fReturnLocationID from @FinalData WHERE fScanID = @thisDataRow ORDER BY fReturnLocationID DESC)
				SET @thisPickupDate = (SELECT top 1  cast(fPickupDate as date) from @FinalData WHERE fScanID = @thisDataRow ORDER BY fPickupDate DESC)
				SET @thisReturnDate =(SELECT top 1 cast(fReturnDate as date) from @FinalData WHERE fScanID = @thisDataRow ORDER BY fReturnDate DESC)
				SET @thisLicence = (SELECT top 1 fLicenceCountryID from @FinalData WHERE fScanID = @thisDataRow ORDER BY fLicenceCountryID DESC)
				SET @thisBrandID = (SELECT top 1 fBrandID from @FinalData WHERE fScanID = @thisDataRow ORDER BY fBrandID DESC)
				SET @thisVehicleID = (SELECT top 1 fVehicleID from @FinalData WHERE fScanID = @thisDataRow ORDER BY fVehicleID DESC)
				SET @thisCurrencyID = (SELECT top 1 fScanCurrencyID from @FinalData WHERE fScanID = @thisDataRow ORDER BY fVehicleID DESC)

				SET @PriceToAdd =  (SELECT top 1 fScanTotalPrice from 
										(	SELECT fScanTotalPrice FROM tTempTablePriceOverTime
											WHERE   (fScanURL  = @thisScanURL
												AND fScanTravelCountryID  = @thisCountry
												AND fScanPickupLocationID  = @thisPickupID
												AND fScanReturnLocationID  = @thisReturnID
												AND cast(cast(fScanPickupDate as date) as nvarchar(max)) = @thisPickupDate
												AND cast(cast(fScanReturnDate as date) as nvarchar(max)) = @thisReturnDate
												AND [dbo].[getLicenceCountryByIntOrDom](fScanURL,fScanTravelCountryID,fScanLicenceCountryID ) = @thisLicence
												AND fScanBrandID  = @thisBrandID
												AND fScanVehicleID  = @thisVehicleID
												AND cast(fScanDate as date) = @thisDataSet)
										) as t
										order by fScanTotalPrice desc
									)
				SET @PriceToAdd =  [dbo].[convertPriceByExceptions](@PriceToAdd, @thisScanURL, @thisVehicleID, @thisCountry, @thisPickupID, @thisReturnID, @thisPickupDate, @thisCurrencyID, @PriceExceptions)
				SET @minValue = 
					CASE
						WHEN @PriceToAdd < @minValue
						THEN @PriceToAdd
						ELSE @minValue
					END
				SET @maxValue = 
					CASE
						WHEN @PriceToAdd > @maxValue
						THEN @PriceToAdd
						ELSE @maxValue
					END
				
				UPDATE @FinalData 
				SET fTotalPriceList = concat(ISNULL(@PriceToAdd,0),',',@PriceList),
					minPrice = @minValue,
					maxPrice = @maxValue
				WHERE fldID = @dataRowCount

				SET @PriceToAdd = 0
				SET @dataRowCount = @dataRowCount + 1
			END
			
			SET @dataSetCount = @dataSetCount + 1
		END

	
	-- get dates for line graph column titles
	DECLARE @dateCountRows int, @dateCountRowsTotal int 
	DECLARE @dateString table (fScanDate nvarchar(max))
	SET @dateCountRows = @firstDataSet
	SET @dateCountRowsTotal = (SELECT count(fldID) FROM @tDataSets WHERE fldID >= @firstDataSet)
	WHILE @dateCountRows <= @dateCountRowsTotal + 1
		BEGIN
			INSERT INTO @dateString (fScanDate)
			SELECT cast(cast(fScanDate as date) as nvarchar(max)) FROM @tDataSets WHERE fldID = @dateCountRows
			
			SET @dateCountRows = @dateCountRows + 1
		END
	SELECT * FROM @dateString ORDER BY fScanDate ASC
	--SELECT cast(cast(fScanDate as date) as nvarchar) FROM @tDataSets WHERE fldID >= @firstDataSet


	-- remove excess table
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tTempTablePriceOverTime]') AND type in (N'U'))
	DROP TABLE tTempTablePriceOverTime

	
	-- get list of distinct dates in final data
	DECLARE @finalDates TABLE (fID int IDENTITY(1,1) PRIMARY KEY, fPickupDate smalldatetime, fReturnDate smalldatetime)
	INSERT INTO @finalDates (fPickupDate, fReturnDate)
	SELECT fPickupDate, fReturnDate FROM @FinalData GROUP BY fPickupDate, fReturnDate 
	

	----set variables 
	DECLARE @totalDatesInFinalData int, @count int
	SET @totalDatesInFinalData = (SELECT count(fID) FROM @finalDates)
	SET @count = 1
	---- run through and get each date as a seperate table
	WHILE @count <= @totalDatesInFinalData
		BEGIN
			SELECT * FROM @FinalData WHERE (fPickupDate = (SELECT fPickupDate FROM @finalDates WHERE fID = @count) AND fReturnDate = (SELECT fReturnDate FROM @finalDates WHERE fID = @count))
			SET @count = @count + 1
		END

		
END

GO
/****** Object:  StoredProcedure [dbo].[getScanDataWeeklyCounts]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sally Gamer
-- Create date: 09/04/15
-- Description:	get counts of data spread to see consistency of data
-- =============================================
CREATE PROCEDURE [dbo].[getScanDataWeeklyCounts]
	
AS
BEGIN
	SET NOCOUNT ON;
	
	-- setup requried variables
    DECLARE @wkCount int, @wkBeg date, @wkEnd date, @notThisDate date, @count int, @countMax int
	SET @wkBeg = [dbo].[getFirstDayOfWeek](getdate())
	SET @notThisDate = '2015-03-23'

	--get list of financial weeks
	DECLARE  @tTempFinWeeks TABLE(fID int  IDENTITY(1,1) PRIMARY KEY, fDate nvarchar(10),fYearWeek nvarchar(50))
	insert into @tTempFinWeeks(fDate, fYearWeek )
    exec('getFinancialYearListWeeksAndDates');
	
	--get rid of unneccessary data
	DELETE FROM @tTempFinWeeks WHERE fID > ((SELECT min(fID) from @tTempFinWeeks) + 11)

--SELECT * FROM @tTempFinWeeks

	DECLARE @firstDate date, @lastDate date
	SET @firstDate = dateadd(day,-2,[dbo].[getFirstDayOfWeek]((SELECT top 1 fDate from @tTempFinWeeks ORDER BY fID desc )))
	SET @lastDate = dateadd(day,5,[dbo].[getFirstDayOfWeek](( SELECT top 1 fDate from @tTempFinWeeks ORDER BY fID asc)))

	--get relevant data
	DECLARE @tTempData TABLE(fID int  IDENTITY(1,1) PRIMARY KEY, fCount int, fScanURL nvarchar(100), fScanDateData date)
	INSERT INTO @tTempData(fCount, fScanURL, fScanDateData)
	SELECT count(fID), fScanURL, cast (fScanDate as date) from tDataScanClean
	WHERE fscandate >= @firstDate aND fscandate <= @lastDate
	GROUP BY fScanURL, cast (fScanDate as date)

--SELECT * FROM @tTempData ORDER BY fScanDateData

	--setup for data counts
	SET @wkCount = 1
	DECLARE  @tTempDataCounts TABLE(fDate date, fTotalCount int, fCountWeb1 int, fCountWeb2 int, fCountWeb3 int, fCountWeb4 int, fCountWeb5 int, fCountWeb6 int, fCountWeb7 int, fCountWeb8 int)
	
	--get data from first URL
	INSERT INTO @tTempDataCounts (fDate)
	SELECT distinct fScanDateData				
	FROM @tTempData 
	ORDER BY fScanDateData DESC

--SELECT * FROM @tTempDataCounts
	
	UPDATE @tTempDataCounts
	SET fCountWeb1 = isnull((SELECT sum(fCount) from @tTempData WHERE cast(fDate as date) = cast(fScanDateData as date) AND fScanURL = 1),0),
	    fCountWeb2 = isnull((SELECT sum(fCount) from @tTempData WHERE cast(fDate as date) = cast(fScanDateData as date) AND fScanURL = 2),0),
	    fCountWeb3 = isnull((SELECT sum(fCount) from @tTempData WHERE cast(fDate as date) = cast(fScanDateData as date) AND fScanURL = 3),0),
	    fCountWeb4 = isnull((SELECT sum(fCount) from @tTempData WHERE cast(fDate as date) = cast(fScanDateData as date) AND fScanURL = 4),0),
	    fCountWeb5 = isnull((SELECT sum(fCount) from @tTempData WHERE cast(fDate as date) = cast(fScanDateData as date) AND fScanURL = 5),0),
	    fCountWeb6 = isnull((SELECT sum(fCount) from @tTempData WHERE cast(fDate as date) = cast(fScanDateData as date) AND fScanURL = 6),0),
	    fCountWeb7 = isnull((SELECT sum(fCount) from @tTempData WHERE cast(fDate as date) = cast(fScanDateData as date) AND fScanURL = 7),0),
	    fCountWeb8 = isnull((SELECT sum(fCount) from @tTempData WHERE cast(fDate as date) = cast(fScanDateData as date) AND fScanURL = 8),0)

	UPDATE @tTempDataCounts
	SET fTotalCount = (fCountWeb1 + fCountWeb2 + fCountWeb3 + fCountWeb4 + fCountWeb5 + fCountWeb6 + fCountWeb7 + fCountWeb8)
	
--SELECT * FROM @tTempDataCounts

	-- setup table for averages
	DECLARE  @tTempDataAverages TABLE(fDate nvarchar(100), fTotalCount int, fCountWeb1 int, fCountWeb2 int, fCountWeb3 int, fCountWeb4 int, fCountWeb5 int, fCountWeb6 int, fCountWeb7 int, fCountWeb8 int)

	-- calculate averages
	INSERT INTO @tTempDataAverages
	VALUES(
			 'Average'
			,(SELECT AVG(fTotalCount) FROM @tTempDataCounts WHERE fTotalCount > 0 AND NOT fDate = @notThisDate)
			,(SELECT AVG(fCountWeb1) FROM @tTempDataCounts WHERE fCountWeb1 > 0 AND NOT fDate = @notThisDate)
			,(SELECT AVG(fCountWeb2) FROM @tTempDataCounts WHERE fCountWeb2 > 0 AND NOT fDate = @notThisDate)
			,(SELECT AVG(fCountWeb3) FROM @tTempDataCounts WHERE fCountWeb3 > 0 AND NOT fDate = @notThisDate)
			,(SELECT AVG(fCountWeb4) FROM @tTempDataCounts WHERE fCountWeb4 > 0 AND NOT fDate = @notThisDate)
			,(SELECT AVG(fCountWeb5) FROM @tTempDataCounts WHERE fCountWeb5 > 0 AND NOT fDate = @notThisDate)
			,(SELECT AVG(fCountWeb6) FROM @tTempDataCounts WHERE fCountWeb6 > 0 AND NOT fDate = @notThisDate)
			,(SELECT AVG(fCountWeb7) FROM @tTempDataCounts WHERE fCountWeb7 > 0 AND NOT fDate = @notThisDate)
			,(SELECT AVG(fCountWeb8) FROM @tTempDataCounts WHERE fCountWeb8 > 0 AND NOT fDate = @notThisDate)
	)

	--get data to view
	SELECT   fDate
			,fTotalCount
			,([dbo].[getScanDataWeeklyCountsCHECKAGAINSTAVERAGE](fTotalCount, (SELECT fTotalCount FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fTotalCountChange
			,([dbo].[getScanDataWeeklyCountsGETCLASS](fTotalCount, (SELECT fTotalCount FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fTotalCountClass			
			,fCountWeb1
			,([dbo].[getScanDataWeeklyCountsCHECKAGAINSTAVERAGE](fCountWeb1, (SELECT fCountWeb1 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb1Change
			,([dbo].[getScanDataWeeklyCountsGETCLASS](fCountWeb1, (SELECT fCountWeb1 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb1Class			
			,fCountWeb2
			,([dbo].[getScanDataWeeklyCountsCHECKAGAINSTAVERAGE](fCountWeb2, (SELECT fCountWeb2 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb2Change
			,([dbo].[getScanDataWeeklyCountsGETCLASS](fCountWeb2, (SELECT fCountWeb2 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb2Class			
			,fCountWeb3
			,([dbo].[getScanDataWeeklyCountsCHECKAGAINSTAVERAGE](fCountWeb3, (SELECT fCountWeb3 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb3Change
			,([dbo].[getScanDataWeeklyCountsGETCLASS](fCountWeb3, (SELECT fCountWeb3 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb3Class
			,fCountWeb4
			,([dbo].[getScanDataWeeklyCountsCHECKAGAINSTAVERAGE](fCountWeb4, (SELECT fCountWeb4 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb4Change
			,([dbo].[getScanDataWeeklyCountsGETCLASS](fCountWeb4, (SELECT fCountWeb4 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb4Class
			,fCountWeb5
			,([dbo].[getScanDataWeeklyCountsCHECKAGAINSTAVERAGE](fCountWeb5, (SELECT fCountWeb5 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb5Change
			,([dbo].[getScanDataWeeklyCountsGETCLASS](fCountWeb5, (SELECT fCountWeb5 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb5Class
			,fCountWeb6
			,([dbo].[getScanDataWeeklyCountsCHECKAGAINSTAVERAGE](fCountWeb6, (SELECT fCountWeb6 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb6Change
			,([dbo].[getScanDataWeeklyCountsGETCLASS](fCountWeb6, (SELECT fCountWeb6 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb6Class
			,fCountWeb7
			,([dbo].[getScanDataWeeklyCountsCHECKAGAINSTAVERAGE](fCountWeb7, (SELECT fCountWeb7 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb7Change
			,([dbo].[getScanDataWeeklyCountsGETCLASS](fCountWeb7, (SELECT fCountWeb7 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb7Class
			,fCountWeb8
			,([dbo].[getScanDataWeeklyCountsCHECKAGAINSTAVERAGE](fCountWeb8, (SELECT fCountWeb8 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb8Change
			,([dbo].[getScanDataWeeklyCountsGETCLASS](fCountWeb8, (SELECT fCountWeb8 FROM @tTempDataAverages WHERE fDate = 'Average')) ) as fCountWeb8Class
	FROM (
		SELECT * FROM @tTempDataAverages
		UNION ALL
		SELECT cast(fDate as nvarchar(200)), fTotalCount, fCountWeb1, fCountWeb2, fCountWeb3, fCountWeb4, fCountWeb5, fCountWeb6, fCountWeb7, fCountWeb8 FROM @tTempDataCounts
		WHERE NOT fDate IS NULL
		AND NOT (isnull(fTotalCount,0)= 0)
	) as tD
	ORDER BY fDate DESC
	

END





GO
/****** Object:  StoredProcedure [dbo].[importXMLExchangeRates]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sally Gamer
-- Create date: 02/06/15
-- Description:	Import Exchange Rates
-- =============================================
CREATE PROCEDURE [dbo].[importXMLExchangeRates]
	@XMLString nvarchar(max)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @correctedXMLString xml

	SET @correctedXMLString = REPLACE(LTRIM(RTRIM(@XMLString)),',','')
	
    INSERT INTO [tDataExchangeRate] ([fExchangeRateDate], [fExchangeRateValue], [fExchangeRateCurrencyCode], fActive)
	SELECT
		getdate(),
		cast(Rates.value('(exchangeRate)[1]', 'nvarchar(50)') as decimal(16,8)),
		--cast(REPLACE(Rates.value('(exchangeRate)[1]', 'decimal(16,8)'),',','') as decimal(7,4)),
		Rates.value('(targetCurrency)[1]', 'nvarchar(10)'),
		1
	FROM
	 @correctedXMLString.nodes('/channel/item') AS XTbl(Rates)

END



GO
/****** Object:  StoredProcedure [dbo].[pagesAdd]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Alan Attwater>
-- Create date: <19-06-13>
-- =============================================
CREATE PROCEDURE [dbo].[pagesAdd] 
	@strPageName NVarChar(150),
	@strPageURL NVarChar(150),
	@intParentID Int
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO tAdminPages(fldName, fldURL, fldParentID)
	VALUES (@strPageName, @strPageURL, @intParentID)
END





GO
/****** Object:  StoredProcedure [dbo].[pagesDelete]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Alan Attwater>
-- Create date: <19-06-13>
-- =============================================
CREATE PROCEDURE [dbo].[pagesDelete]
	@fldID Int
AS
BEGIN

	SET NOCOUNT ON;

    DELETE FROM tAdminPages WHERE fldID = @fldID

	DELETE FROM tAdminUsersPages WHERE fldPageID = @fldID
END






GO
/****** Object:  StoredProcedure [dbo].[pagesSelList]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Alan Attwater>
-- Create date: <19-06-2013>
-- =============================================
CREATE PROCEDURE [dbo].[pagesSelList]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT fldID As fldRowID, fldID, fldName, fldURL, fldParentID
	FROM tAdminPages
	WHERE fldParentID = 0

	UNION ALL

    SELECT fldParentID As fldRowID, fldID, fldName, fldURL, fldParentID
	FROM tAdminPages
	WHERE fldParentID > 0

	ORDER BY fldRowID, fldParentID
END






GO
/****** Object:  StoredProcedure [dbo].[pagesUpdate]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Alan Attwater>
-- Create date: <19-06-2013>
-- =============================================
CREATE PROCEDURE [dbo].[pagesUpdate]
	@fldID Int,
	@fldName NVarChar(150),
	@fldURL NVarChar(150)
AS
BEGIN

	SET NOCOUNT ON;

    UPDATE tAdminPages
	SET fldName = @fldName,
		fldURL = @fldURL
	WHERE fldID = @fldID
END





GO
/****** Object:  StoredProcedure [dbo].[updateExceptionsBrands]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<add new brand>
-- =============================================
CREATE PROCEDURE [dbo].[updateExceptionsBrands]
	@unknownID int, 
	@acceptedID int
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tRefBrand
	SET fBrandAlias = 
	(
		CASE
			WHEN
				fBrandAlias IS NULL OR fBrandAlias = ''
			THEN
				(SELECT fScanBrandName FROM tDataScan WHERE fID = @unknownID)		
			ELSE
				CONCAT(fBrandAlias, (';'+(SELECT fScanBrandName FROM tDataScan WHERE fID = @unknownID))) 
		END
	)
	
	WHERE fID = @acceptedID;
END




GO
/****** Object:  StoredProcedure [dbo].[updateExceptionsBrandsAddBrand]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/03/2015>
-- Description:	<add new brand>
-- =============================================
CREATE PROCEDURE [dbo].[updateExceptionsBrandsAddBrand]
	@unknownID int,
	@activeState int
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO tRefBrand	(fBrandName, fBrandAlias, fBrandPriority, fActive)
	SELECT fScanBrandName, '', NULL, @activeState
	FROM tDataScan
	WHERE fID = @unknownID
END




GO
/****** Object:  StoredProcedure [dbo].[updateExceptionsCountries]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <13/03/15>
-- Description:	<Update Countries table to deal with exceptions in data>
-- =============================================
CREATE PROCEDURE [dbo].[updateExceptionsCountries]
	@unknownID int, 
	@acceptedID int,
	@typeID int
AS
BEGIN

	SET NOCOUNT ON;

  UPDATE tRefCountry
	SET fCountryAlias = 
	(
		CASE
			WHEN
				fCountryAlias IS NULL OR fCountryAlias = ''
			THEN
				CASE
					WHEN 
						@typeID = 1 
					THEN
						(SELECT fScanTravelCountry FROM tDataScan WHERE fID = @unknownID)	
					ELSE
						(SELECT fScanLicenceCountry FROM tDataScan WHERE fID = @unknownID)	
				END		
			ELSE
				CASE
					WHEN 
						@typeID = 1 
					THEN
						CONCAT(fCountryAlias, (';'+(SELECT fScanTravelCountry FROM tDataScan WHERE fID = @unknownID))) 
					ELSE
						CONCAT(fCountryAlias, (';'+(SELECT fScanLicenceCountry FROM tDataScan WHERE fID = @unknownID))) 
				END
		END
	)
	WHERE fID = @acceptedID

END




GO
/****** Object:  StoredProcedure [dbo].[updateExceptionsCurrencies]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <13/03/15>
-- Description:	<Update Countries table to deal with exceptions in data>
-- =============================================
CREATE PROCEDURE [dbo].[updateExceptionsCurrencies]
	@unknownID int, 
	@acceptedID int

AS
BEGIN

	SET NOCOUNT ON;

  UPDATE tRefCurrency
	SET fCurrencyAlias = 
	(
		CASE
			WHEN
				fCurrencyAlias IS NULL OR fCurrencyAlias = ''
			THEN
				(SELECT fScanCurrency FROM tDataScan WHERE fID = @unknownID)
			ELSE
				CONCAT(fCurrencyAlias, (';'+(SELECT fScanCurrency FROM tDataScan WHERE fID = @unknownID))) 
		END
	)
	WHERE fID = @acceptedID

END




GO
/****** Object:  StoredProcedure [dbo].[updateExceptionsDates]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <26/08/2015>
-- Description:	<add new brand>
-- =============================================
CREATE PROCEDURE [dbo].[updateExceptionsDates]
	@pickupDate smalldatetime, 
	@returnDate smalldatetime
AS
BEGIN
	SET NOCOUNT ON;

	SET @pickupDate = cast(@pickupDate as date)
	SET @returnDate = cast(@returnDate as date)

	UPDATE tDataScan
	SET fActive = 0
	WHERE fScanPickupDate = @pickupDate
	AND   fScanReturnDate = @returnDate


END




GO
/****** Object:  StoredProcedure [dbo].[updateExceptionsLocations]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <13/03/15>
-- Description:	<Update Locations table to deal with exceptions in data>
-- =============================================
CREATE PROCEDURE [dbo].[updateExceptionsLocations]
	@unknownID int, 
	@acceptedID int,
	@typeID int
AS
BEGIN

	SET NOCOUNT ON;

  UPDATE tRefLocation
	SET fLocationAlias = 
	(
		CASE
			WHEN
				fLocationAlias IS NULL OR fLocationAlias = ''
			THEN
				CASE
					WHEN 
						@typeID = 1 
					THEN
						(SELECT fScanPickupLocation FROM tDataScan WHERE fID = @unknownID)	
					ELSE
						(SELECT fScanReturnLocation FROM tDataScan WHERE fID = @unknownID)	
				END		
			ELSE
				CASE
					WHEN 
						@typeID = 1 
					THEN
						CONCAT(fLocationAlias, (';'+(SELECT fScanPickupLocation FROM tDataScan WHERE fID = @unknownID))) 
					ELSE
						CONCAT(fLocationAlias, (';'+(SELECT fScanReturnLocation FROM tDataScan WHERE fID = @unknownID))) 
				END
		END
	)
	WHERE fID = @acceptedID
	END 




GO
/****** Object:  StoredProcedure [dbo].[updateExceptionsPrices]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <30/03/15>
-- Description:	<update price exceptions>
-- =============================================
CREATE PROCEDURE [dbo].[updateExceptionsPrices]
	@updateID int,
	@brand nvarchar(max), 
	@country int, 
	@pickupLocation nvarchar(max), 
	@returnLocation nvarchar(max), 
	@OneWayRentals bit, 
	@startDate smalldatetime,
	@endDate smalldatetime,
	@priceChange decimal (18,2),
	@priceChangePercent decimal (18,2),
	@currency int, 
	@priceChangeNote nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
		
	-- set NULLS if dates not set
	DECLARE @startDateFinal nvarchar(20), @endDateFinal nvarchar(20), @currentDate smalldatetime
	SET @currentDate = getdate()
	SET @startDateFinal = 
			CASE
				WHEN @startDate = '' or @startDate IS NULL OR @startDate = '1900-01-01 00:00:00'
					THEN  
						CASE	
							WHEN datepart(dw,@currentDate) = 1 -- when today is a Sunday
								THEN CAST(@currentDate AS nvarchar(20))
							WHEN datepart(dw,@currentDate) = 2 -- when today is a Monday
								THEN  CAST(dateadd(day,-1,@currentDate) AS nvarchar(20))
							WHEN datepart(dw,@currentDate) = 3 -- when today is a Tuesday
								THEN  CAST(dateadd(day,-2,@currentDate) AS nvarchar(20))
							WHEN datepart(dw,@currentDate) = 4 -- when today is a Wednesday
								THEN  CAST(dateadd(day,-3,@currentDate) AS nvarchar(20))
							WHEN datepart(dw,@currentDate) = 5 -- when today is a Thursday
								THEN  CAST(dateadd(day,-4,@currentDate) AS nvarchar(20))
							WHEN datepart(dw,@currentDate) = 6 -- when today is a Friday
								THEN  CAST(dateadd(day,-5,@currentDate) AS nvarchar(20))
							WHEN datepart(dw,@currentDate) = 7 -- when today is a Saturday
								THEN  CAST(dateadd(day,-6,@currentDate) AS nvarchar(20))
						END	
				ELSE @startDate
			END
	SET @endDateFinal =
			CASE
				WHEN @endDate = '' or @endDate IS NULL OR @endDate = '1900-01-01 00:00:00'
					THEN NULL
				ELSE @endDate
			END
	-- set NULLs if INTs are empty

    UPDATE [comparison].[dbo].[tRefPriceException]
	SET fPriceExceptionCountryID = @country
		,fPriceExceptionOneWay = @OneWayRentals
		,fPriceExceptionDateStart = CAST(@startDateFinal AS smalldatetime)
		,fPriceExceptionDateEnd =  CAST(@endDateFinal AS smalldatetime)
		,fPriceExceptionPriceChange = @priceChange
		,fPriceExceptionPercentage = @priceChangePercent
		,fPriceExceptionCurrencyID = @currency
		,fPriceExceptionNote = @priceChangeNote
	WHERE fID = @updateID

	
	UPDATE tRefPriceExceptionLocations
	SET fActive = 0
	WHERE fExceptionID = @updateID

	DECLARE @countLocations int, @totalCountLocations int, @countBrands int, @totalBrands int

  DECLARE  @temp TABLE (
	fID int  IDENTITY(1,1) PRIMARY KEY,
	thisID int,
	pickupOrDropoff int
  )
  
  INSERT INTO @temp (thisID, pickupOrDropoff)
  SELECT val, '1' FROM [dbo].[split](@pickupLocation,',')
  
  INSERT INTO @temp (thisID, pickupOrDropoff)
  SELECT val, '2' FROM [dbo].[split](@returnLocation,',')

  SET @countLocations = 1
  SET @totalCountLocations = (select count(thisID) from @temp)

  WHILE @countLocations <= @totalCountLocations
	BEGIN
		INSERT INTO tRefPriceExceptionLocations
		([fExceptionID],[fLocationID],[fPickupOrDropoff])
		VALUES ( @updateID,
				 (SELECT thisID from @temp WHERE fID = @countLocations),
				 (SELECT pickupOrDropoff from @temp WHERE fID = @countLocations)
			   )

		SET @countLocations = @countLocations + 1
	END
	
	
	UPDATE tRefPriceExceptionBrands
	SET fActive = 0
	WHERE fExceptionID = @updateID
	
--run through list of brands, and add to table
  DECLARE  @tempBrands TABLE (
	fID int  IDENTITY(1,1) PRIMARY KEY,
	thisID int
  )
  
  INSERT INTO @tempBrands (thisID)
  SELECT val FROM [dbo].[split](@brand,',')
  
  SET @countBrands = 1
  SET @totalBrands = (select count(thisID) from @tempBrands)

  WHILE @countBrands <= @totalBrands
	BEGIN
		INSERT INTO tRefPriceExceptionBrands
		(fExceptionID, fBrandID)
		VALUES ( @updateID,
				 (SELECT thisID from @tempBrands WHERE fID = @countBrands)
			   )

		SET @countBrands = @countBrands + 1
	END




END




GO
/****** Object:  StoredProcedure [dbo].[updateExceptionsVehicles]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <13/03/15>
-- Description:	<Update vehicles table to deal with exceptions in data>
-- =============================================
CREATE PROCEDURE [dbo].[updateExceptionsVehicles]
	@unknownID int, 
	@acceptedID int
AS
BEGIN
	UPDATE tRefVehicle
				SET fVehicleAlias = 
				(
					CASE
						WHEN
							fVehicleAlias IS NULL OR fVehicleAlias = ''
						THEN
							(SELECT fScanVehicleName FROM tDataScan WHERE fID = @unknownID )	
						ELSE
							CONCAT(fVehicleAlias, (';'+(SELECT fScanVehicleName FROM tDataScan WHERE fID = @unknownID ))) 
					END
				)
				WHERE fID = @acceptedID
END




GO
/****** Object:  StoredProcedure [dbo].[updateExceptionsVehiclesAddVehicle]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <13/03/15>
-- Description:	<Update Countries table to deal with exceptions in data>
-- =============================================
CREATE PROCEDURE [dbo].[updateExceptionsVehiclesAddVehicle]
	@unknownID int, 
	@acceptedBrandID int
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO tRefVehicle
	([fVehicleName], [fVehicleBrandID], [fVehicleTypeID], [fVehicleDriveTypeID], [fVehicleBerthAdults], [fVehicleBerthChildren], [fVehicleAlias])

	SELECT d.fScanVehicleName, b.fID, 4, 4, 0, 0, ''
	FROM tDataScan as d
	INNER JOIN ( 
				SELECT fID,fBrandName
				from tRefBrand 				
																	
				UNION ALL 
																	
				SELECT fID, 
					Split.a.value('.', 'VARCHAR(100)') AS String  
				from 
				( 
					SELECT fID, 
						CAST ('<M>' + REPLACE(fBrandAlias, ';', '</M><M>') + '</M>' AS XML) AS String  
					FROM  tRefBrand  
				) AS a CROSS APPLY String.nodes ('/M') AS Split(a)
				) as b on b.fBrandName = d.fScanBrandName
	WHERE d.fID = @unknownID


END





GO
/****** Object:  StoredProcedure [dbo].[updateExceptionsWebsites]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <12/03/15>
-- Description:	<Set unknown website as an allias of a known website>
-- =============================================
CREATE PROCEDURE [dbo].[updateExceptionsWebsites]
	@unknownID int, 
	@acceptedID int
AS
BEGIN

	SET NOCOUNT ON;

		UPDATE tRefWebsite
	SET fWebsiteAlias = 
	(
		CASE
			WHEN
				fWebsiteAlias IS NULL OR fWebsiteAlias = ''
			THEN
				(SELECT fScanURL FROM tDataScan WHERE fID = @unknownID)				
			ELSE
				CONCAT(fWebsiteAlias, (';'+(SELECT fScanURL FROM tDataScan WHERE fID = @unknownID))) 
		END
	)
	WHERE fID = @acceptedID;

END




GO
/****** Object:  StoredProcedure [dbo].[usersAdd]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Alan Attwater>
-- Create date: <27-06-13>
-- =============================================
CREATE PROCEDURE [dbo].[usersAdd]
	@strUsername NVarChar(50),
    @strPassword NVarChar(50),
    @strName NVarChar(50),
    @strEmail NVarChar(50),
    @isAdmin Bit,
    @isActive Bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO tAdminUsers(fldUserName, fldPWD, fldName, fldEmail, fldAdmin, fldActive)
	VALUES(@strUsername, @strPassword, @strName, @strEmail, @isAdmin, @isActive)

	RETURN @@identity
END





GO
/****** Object:  StoredProcedure [dbo].[usersPagesSelNav]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Alan Attwater>
-- Create date: <20-06-13>
-- =============================================
CREATE PROCEDURE [dbo].[usersPagesSelNav]
	@userID Int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @userID = 0
		BEGIN
			SELECT a.fldID, a.fldName, a.fldURL, a.fldParentID,
				(CASE 
					WHEN a.fldParentID = 0 THEN a.fldID
					ELSE a.fldParentID
				END) as fldGroupID,
					(SELECT COUNT(*) FROM tAdminPages As x
						WHERE x.fldParentID = a.fldID) As fldSubCount
					FROM tAdminPages As a
			ORDER BY fldGroupID, a.fldParentID
		END
	ELSE
		BEGIN
			SELECT a.fldID, a.fldName, a.fldURL, a.fldParentID,
				(CASE 
					WHEN a.fldParentID = 0 THEN a.fldID
					ELSE a.fldParentID
				END) as fldGroupID,
			(SELECT COUNT(*) FROM tAdminUsersPages As x
				LEFT OUTER JOIN  tAdminPages y ON y.fldID = x.fldPageID
				WHERE y.fldParentID = a.fldID and x.fldUserID = @userID) As fldSubCount
			FROM tAdminPages As a
			JOIN tAdminUsersPages b ON b.fldPageID = a.fldID and b.fldUserID = @userID
			ORDER BY fldGroupID
		END
END






GO
/****** Object:  StoredProcedure [dbo].[usersSelList]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<alan attwater>
-- Create date: <19-06-13>
-- =============================================
CREATE PROCEDURE [dbo].[usersSelList]

AS
BEGIN

	SET NOCOUNT ON;

	SELECT fldID, fldName, fldEmail, fldActive 
	FROM tAdminUsers 
	WHERE fldActive = 1
	ORDER BY fldName
END





GO
/****** Object:  StoredProcedure [dbo].[usersUpdate]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<alan attwater>
-- Create date: <20-06-13>
-- =============================================
CREATE PROCEDURE [dbo].[usersUpdate]
	@intID Int,
	@strUsername NVarChar(50),
    @strPassword NVarChar(50),
    @strName NVarChar(50),
    @strEmail NVarChar(50),
    @isAdmin Bit,
    @isActive Bit
AS
BEGIN

	SET NOCOUNT ON;

    UPDATE tAdminUsers SET
		fldUserName = @strUsername,
		fldPWD = @strPassword,
		fldName = @strName,
		fldEmail = @strEmail,
		fldAdmin = @isAdmin,
		fldActive = @isActive
	WHERE fldID = @intID
END






GO
/****** Object:  UserDefinedFunction [dbo].[checkScanDate]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sally Gamer
-- Create date: 12/06/15
-- Description:	Set the "Scan Date" to a day later if scan date is showing as a Sunday due to the server time zone, instead of a Monday.
-- =============================================
CREATE FUNCTION [dbo].[checkScanDate]
(
	@scanDate smalldatetime
)
RETURNS smalldatetime
AS
BEGIN
	
	DECLARE @reportedScanDate smalldatetime
	SET @reportedScanDate = @scanDate
	SET @reportedScanDate =
				CASE	
					WHEN datepart(dw,@reportedScanDate) = 1 -- when today is a Sunday
						THEN dateadd(day,1,@reportedScanDate)
					ELSE @reportedScanDate
				END	

	RETURN @reportedScanDate

END



GO
/****** Object:  UserDefinedFunction [dbo].[convertPriceByExceptions]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <17/03/15>
-- Description:	<Get data from clean data table>
-- =============================================
CREATE FUNCTION [dbo].[convertPriceByExceptions]
(
	 @fScanTotalPrice decimal(18,2)
	,@fScanURL int 
	,@fScanVehicleID int 
	,@fScanTravelCountryID int 
	,@fScanPickupLocationID int 
	,@fScanReturnLocationID int 
	,@fScanPickupDate smalldatetime 
	,@fScanCurrencyID int
	,@PriceExceptions int
)
RETURNS decimal(18,2)
AS
BEGIN
	
	-- set return price to scanPrice variable
	DECLARE @returnPrice decimal(8,2), @isoneWay int, @originalPrice decimal(8,2)
	SET @returnPrice = @fScanTotalPrice
	SET @originalPrice = @fScanTotalPrice

	-- Return original price if price exceptions is turned off (1 = add fees to prices without them, 2 = remove fees from prices with them)
	IF @PriceExceptions = 0
	RETURN @ReturnPrice

	--GET VEHICLE BRAND
	DECLARE @vehicleBrandID int
	SET @vehicleBrandID = (SELECT fVehicleBrandID FROM tRefVehicle WHERE fID = @fScanVehicleID)

	--Check if is a one way trip
	SET @isoneWay = 
		CASE
			WHEN @fScanPickupLocationID = @fScanReturnLocationID
			THEN 0
			ELSE 1
		END

	-- declare variables for price changes
	DECLARE @Times decimal(10,4), @TimesAmount decimal(10,4), @Add decimal(8,2)
	SET @Add = 0.00
		
	DECLARE @thisVehicleID int
	SET @thisVehicleID = (SELECT fVehicleBrandID FROM tRefVehicle WHERE fID = @fScanVehicleID)

	-- create table to hold list of exceptoins
	DECLARE @exceptionsTable TABLE (fID INT IDENTITY(1,1) PRIMARY KEY, fldAddAmount decimal(8,2) DEFAULT 0, fldTimesAmount decimal(8,2) DEFAULT 0)
	-- get additon exceptions
	INSERT INTO @exceptionsTable (fldAddAmount)
	SELECT [dbo].[convertPriceToCurrency](fPriceExceptionPriceChange, fPriceExceptionCurrencyID, getdate(), @fScanTravelCountryID) from tRefPriceException as tP
	where fActive = 1
	AND (@fScanVehicleID = 0 OR (@thisVehicleID in (SELECT fBrandID FROM tRefPriceExceptionBrands WHERE fExceptionID = tP.fID AND fActive = 1)))
	AND (fPriceExceptionCountryID = @fScanTravelCountryID or @fScanTravelCountryID = 0)
	AND (fPriceExceptionOneWay = 0)
	AND (fPriceExceptionDateStart <= @fScanPickupDate)
	AND (fPriceExceptionDateEnd >= dateadd(day,10,(@fScanPickupDate)))
	AND (fPriceExceptionPriceChange > 0 or fPriceExceptionPriceChange < 0)
	AND (  (		(@fScanPickupLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1) OR @fScanPickupLocationID = 0)
				AND (@fScanReturnLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1) OR @fScanReturnLocationID = 0)
			)
			OR
			(		(@fScanPickupLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1) OR @fScanPickupLocationID = 0)
				AND ((SELECT sum(isnull(fLocationID,0))  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1) = 0)
			)
			OR
			(		((SELECT sum(isnull(fLocationID,0))  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1) = 0)
				AND (@fScanReturnLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1) OR @fScanReturnLocationID = 0)
			)
		)
	--get one-way addition exceptions
	INSERT INTO @exceptionsTable (fldAddAmount)
	select top 1 [dbo].[convertPriceToCurrency](fPriceExceptionPriceChange, fPriceExceptionCurrencyID, getdate(), @fScanTravelCountryID) from tRefPriceException as tP
	where fActive = 1
	AND (@fScanVehicleID = 0 OR (@thisVehicleID in (SELECT fBrandID FROM tRefPriceExceptionBrands WHERE fExceptionID = tP.fID AND fActive = 1)))
	AND (fPriceExceptionCountryID = @fScanTravelCountryID or @fScanTravelCountryID = 0)
	AND (fPriceExceptionOneWay = @isoneWay AND @isoneWay = 1)
	AND (fPriceExceptionDateStart <= @fScanPickupDate)
	AND (fPriceExceptionDateEnd >= dateadd(day,10,(@fScanPickupDate)))
	AND (fPriceExceptionPriceChange > 0 or fPriceExceptionPriceChange < 0)
	AND ((@fScanPickupLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1)
	OR (@fScanReturnLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1))))
	ORDER BY fPriceExceptionPriceChange DESC
	
	--get times exceptions
	INSERT INTO @exceptionsTable (fldTimesAmount)
	SELECT fPriceExceptionPercentage from tRefPriceException as tP
	where fActive = 1
	AND (@fScanVehicleID = 0 OR (@thisVehicleID in (SELECT fBrandID FROM tRefPriceExceptionBrands WHERE fExceptionID = tP.fID AND fActive = 1)))
	AND (fPriceExceptionCountryID = @fScanTravelCountryID or @fScanTravelCountryID = 0)
	AND (fPriceExceptionOneWay = 0)
	AND (fPriceExceptionDateStart <= @fScanPickupDate)
	AND (fPriceExceptionDateEnd >= dateadd(day,10,@fScanPickupDate))
	AND (fPriceExceptionPercentage > 0 or fPriceExceptionPercentage < 0)
	AND (  (		(@fScanPickupLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1) OR @fScanPickupLocationID = 0)
				AND (@fScanReturnLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1) OR @fScanReturnLocationID = 0)
			)
			OR
			(		(@fScanPickupLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1) OR @fScanPickupLocationID = 0)
				AND ((SELECT sum(isnull(fLocationID,0)) FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1) = 0)
			)
			OR
			(		((SELECT sum(isnull(fLocationID,0))  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1) = 0)
				AND (@fScanReturnLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1) OR @fScanReturnLocationID = 0)
			)
	)
	--get one-way addition exceptions
	INSERT INTO @exceptionsTable (fldTimesAmount)
	select top 1 fPriceExceptionPercentage from tRefPriceException as tP
	where fActive = 1
	AND (@fScanVehicleID = 0 OR (@thisVehicleID in (SELECT fBrandID FROM tRefPriceExceptionBrands WHERE fExceptionID = tP.fID AND fActive = 1)))
	AND (fPriceExceptionCountryID = @fScanTravelCountryID or @fScanTravelCountryID = 0)
	AND (fPriceExceptionOneWay = @isoneWay AND @isoneWay = 1)
	AND (fPriceExceptionDateStart <= @fScanPickupDate)
	AND (fPriceExceptionDateEnd >= dateadd(day,10,(@fScanPickupDate)))
	AND (fPriceExceptionPercentage > 0 or fPriceExceptionPercentage < 0)
	AND ((@fScanPickupLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1)
	OR (@fScanReturnLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1))))
	ORDER BY fPriceExceptionPriceChange DESC

--SELECT * FROM @exceptionsTable

	
	--check if website already includes fees or not
	DECLARE @websiteIncludesFees int
	SET @websiteIncludesFees = (SELECT fWebsiteIncludesFees FROM tRefWebsite WHERE fID = @fScanURL)

	--get total add value
	SET @Add = (SELECT sum(fldAddAmount) FROM @exceptionsTable)
	--Add/subtract any dollar value changes
	SET @returnPrice = 
		CASE
			WHEN @Add > 0 OR @Add < 0
			THEN 
				CASE
					WHEN @PriceExceptions = 1 AND @websiteIncludesFees = 0
						THEN CAST(@returnPrice + @Add as decimal(8,2))
					WHEN @PriceExceptions = 2 AND @websiteIncludesFees = 1
						THEN CAST(@returnPrice - @Add as decimal(8,2))
					ELSE @returnPrice
				END
			ELSE @returnPrice
		END
		
	--get times values
	SET @Times = (SELECT sum(fldTimesAmount) FROM @exceptionsTable) / 100
	SET @TimesAmount = 
		CASE
			WHEN @Times > 0 OR @Times < 0
			THEN 
				CASE
					WHEN @websiteIncludesFees = 0
						THEN cast(@returnPrice * @Times as decimal(10,5))
					WHEN @websiteIncludesFees = 1
						THEN cast(( @originalPrice / (1 + @Times) * @Times) as decimal(10,5))
					ELSE 0
				END
			ELSE 0			
		END		
	--Add/subtract any percentage change values
	SET @returnPrice =  
		CASE
			WHEN @TimesAmount > 0 OR @TimesAmount < 0
			THEN
				CASE
					WHEN @PriceExceptions = 1 AND @websiteIncludesFees = 0
						THEN @returnPrice + @TimesAmount
					WHEN @PriceExceptions = 2 AND @websiteIncludesFees = 1
						THEN @returnPrice - @TimesAmount
					ELSE @returnPrice
				END
			ELSE @returnPrice
		END

	--SELECT @returnPrice

	--SELECT @returnPrice
		
	RETURN @ReturnPrice

END






GO
/****** Object:  UserDefinedFunction [dbo].[convertPriceToAUD]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <20/03/2015>
-- Description:	<convert price over to AUD from whichever currency it is currently>
-- =============================================
CREATE FUNCTION [dbo].[convertPriceToAUD]
(
	@priceInOtherCUR decimal(18,2),
	@currencyID int,
	@scanDate smalldatetime
)
RETURNS decimal(18,2)
AS
BEGIN



---------------------------- THIS FUNCTION ISN'T BEING USED CURRENTLY------------------------------------------------------------------------------------------

	DECLARE @returnPrice decimal(18,2)
	--DECLARE @currencyCode nvarchar(5)

	--SET @currencyCode = (SELECT fCurrencyCode FROM tRefCurrency WHERE fID = @currencyID)
	
	--SET @returnPrice = 
	--	CASE
	--		WHEN @currencyCode = 'AUD'
	--			THEN @priceInOtherCUR
	--		ELSE
	--			(@priceInOtherCUR / (SELECT TOP 1 fExchangeRateValue from tDataExchangeRate WHERE fExchangeRateCurrencyCode = @currencyCode AND fExchangeRateDate < @scanDate ORDER BY fExchangeRateDate DESC ))
	--	END	

---------------------------- THIS FUNCTION ISN'T BEING USED CURRENTLY------------------------------------------------------------------------------------------

	RETURN @returnPrice

END




GO
/****** Object:  UserDefinedFunction [dbo].[convertPriceToCurrency]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <27/03/2015>
-- Description:	<convert price over to selected currency from whichever currency it is currently>
-- =============================================
CREATE FUNCTION [dbo].[convertPriceToCurrency]
(
	@priceInOtherCUR decimal(18,2),
	@currenctCurrencyID int,
	@scanDate smalldatetime,
	@selectedCurrencyCountryID int
)
RETURNS decimal(18,2)
AS
BEGIN

	DECLARE @returnPrice decimal(18,2)
	DECLARE @currencyCodeCurrent nvarchar(5)
	DECLARE @currencyCodeSelected nvarchar(5)

	SET @currencyCodeCurrent = (SELECT fCurrencyCode FROM tRefCurrency WHERE fID = @currenctCurrencyID)
	SET @currencyCodeSelected = (SELECT fCurrencyCode FROM tRefCountry WHERE fID = @selectedCurrencyCountryID )
	
	SET @returnPrice = 
		CASE
			WHEN @currencyCodeCurrent = @currencyCodeSelected --when trying to convert from and to the same currency code, return original value
				THEN @priceInOtherCUR
			WHEN @currencyCodeCurrent = 'AUD' -- converting from AUD to another currency
				THEN (@priceInOtherCUR  * (SELECT TOP 1 fExchangeRateValue from tDataExchangeRate WHERE fExchangeRateCurrencyCode = @currencyCodeSelected AND fExchangeRateDate < @scanDate  ORDER BY fExchangeRateDate DESC ))
			WHEN @currencyCodeSelected = 'AUD' -- converting to AUD from another currency
				THEN (@priceInOtherCUR / (SELECT TOP 1 fExchangeRateValue from tDataExchangeRate WHERE fExchangeRateCurrencyCode = @currencyCodeCurrent AND fExchangeRateDate < @scanDate   ORDER BY fExchangeRateDate DESC ))
			ELSE -- for all other currency conversions		
				((@priceInOtherCUR / (SELECT TOP 1 fExchangeRateValue from tDataExchangeRate WHERE fExchangeRateCurrencyCode = @currencyCodeCurrent AND fExchangeRateDate < @scanDate   ORDER BY fExchangeRateDate DESC ))
				* (SELECT TOP 1 fExchangeRateValue from tDataExchangeRate WHERE fExchangeRateCurrencyCode = @currencyCodeSelected AND fExchangeRateDate < @scanDate   ORDER BY fExchangeRateDate DESC ))
			END

	RETURN @returnPrice

END



GO
/****** Object:  UserDefinedFunction [dbo].[getBrandVehicleID]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10-04-15>
-- Description:	<Get brand or vheicle ID from data scan>
-- =============================================
CREATE FUNCTION [dbo].[getBrandVehicleID]
(
	@fScanID int
	,@typeID int
)
RETURNS int
AS
BEGIN
	
	DECLARE @ID int
	
---------------------------- THIS FUNCTION ISN'T BEING USED CURRENTLY------------------------------------------------------------------------------------------

	--DECLARE @BrandNameOLD nvarchar(200)
	--DECLARE @VehicleNameOLD nvarchar(200)
	--SET @BrandNameOLD = (SELECT [fScanBrandName] FROM [tDataScan] WHERE fID = @fScanID)
	--SET @VehicleNameOLD = (SELECT [fScanVehicleName] FROM [tDataScan] WHERE fID = @fScanID)

	--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tTempBrandVehicle]') AND type in (N'U'))
	--SET @ID = 
	--	CASE
	--		WHEN @typeID = 1
	--		THEN (  SELECT min(fBrandID) FROM tTempBrandVehicle 
	--				WHERE fBrandName = @BrandNameOLD
	--				AND fVehicleName = @VehicleNameOLD
	--			 )
	--		WHEN @typeID = 2
	--		THEN (  SELECT min(fVehicleID) FROM tTempBrandVehicle 
	--				WHERE fBrandName = @BrandNameOLD
	--				AND fVehicleName = @VehicleNameOLD
	--			 )
	--	END
			
---------------------------- THIS FUNCTION ISN'T BEING USED CURRENTLY------------------------------------------------------------------------------------------

	RETURN @ID

END





GO
/****** Object:  UserDefinedFunction [dbo].[getClassName]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <18/03/2015>
-- Description:	<get class name for the comparison values>
-- =============================================
CREATE FUNCTION [dbo].[getClassName]
(
	@returnValue int,
	@mainNumber int,
	@numberTwo int,
	@numberThree int,
	@numberFour int,
	@numberFive int,
	@numberSix int,
	@numberSeven int,
	@numberEight int
)

RETURNS nvarchar(MAX)

AS
BEGIN
	
declare @Return nvarchar(MAX),
		@mainClass nvarchar(MAX),
		@SecondClass nvarchar(MAX),
		@ThirdClass nvarchar(MAX),
		@FourthClass nvarchar(MAX),
		@FifthClass nvarchar(MAX),
		@SixthClass nvarchar(MAX),
		@SeventhClass nvarchar(MAX),
		@EighthClass nvarchar(MAX),
		@AcceptableMargin decimal (6,2),
		@UnacceptableMargin decimal (6,2)

SET @mainClass = 'mainPrice'
SET	@SecondClass = 'secondPrice'
SET	@ThirdClass = 'thirdPrice'
SET	@FourthClass = 'fourthPrice'
SET	@FifthClass = 'fifthPrice'
SET	@SixthClass = 'sixthPrice'
SET	@SeventhClass = 'seventhPrice'
SET	@EighthClass = 'eighthPrice'
SET @AcceptableMargin = 0.95
SET @UnacceptableMargin = 0.75

--check to see if main price is average price
DECLARE @averageprice decimal(18,2)
SET @averageprice = avg(@mainNumber + @numberTwo + @numberThree + @numberFour + @numberFive + @numberSix + @numberSeven + @numberEight)
SET @mainClass =
CASE	
	WHEN (@mainNumber >= (@averageprice*0.95)) AND (@mainNumber <= (@averageprice*1.05))
		THEN CONCAT(@mainClass,' averagePrice')
	ELSE @mainClass
END

--remove nulls
SET @mainNumber = IsNull(@mainNumber, 0)
SET @numberTwo = IsNull(@numberTwo, 0)
SET @numberThree = IsNull(@numberThree, 0)
SET @numberFour = IsNull(@numberFour, 0)
SET @numberFive = IsNull(@numberFive, 0)
SET @numberSix = IsNull(@numberSix, 0)
SET @numberSeven = IsNull(@numberSeven, 0)
SET @numberEight = IsNull(@numberEight, 0)

--calculate smallest number
DECLARE @cheapestPrice decimal(18,2)
SET @cheapestPrice = 
	CASE
		WHEN NOT (@mainNumber = 0)
		THEN @mainNumber
		ELSE 10000
	END
SET @cheapestPrice = 
	CASE
		WHEN (@numberTwo < @cheapestPrice ) AND  (@numberTwo > 0)
		THEN @numberTwo
		ELSE @cheapestPrice
	END
SET @cheapestPrice = 
	CASE
		WHEN (@numberThree < @cheapestPrice ) AND  (@numberThree > 0)
		THEN @numberThree
		ELSE @cheapestPrice
	END
SET @cheapestPrice = 
	CASE
		WHEN (@numberFour < @cheapestPrice ) AND  (@numberFour > 0)
		THEN @numberFour
		ELSE @cheapestPrice
	END
SET @cheapestPrice = 
	CASE
		WHEN (@numberFive < @cheapestPrice ) AND  (@numberFive > 0)
		THEN @numberFive
		ELSE @cheapestPrice
	END
SET @cheapestPrice = 
	CASE
		WHEN (@numberSix < @cheapestPrice ) AND  (@numberSix > 0)
		THEN @numberSix
		ELSE @cheapestPrice
	END
SET @cheapestPrice = 
	CASE
		WHEN (@numberSeven < @cheapestPrice ) AND  (@numberSeven > 0)
		THEN @numberSeven
		ELSE @cheapestPrice
	END
SET @cheapestPrice = 
	CASE
		WHEN (@numberEight < @cheapestPrice ) AND (@numberEight > 0)
		THEN @numberEight
		ELSE @cheapestPrice
	END


-- set which class is being returned, and add classes depending on if cheapest, smaller than main, etc
SET @Return = 
	CASE	
		WHEN @returnValue = 1
			THEN 
				Case When @mainNumber = @cheapestPrice 
					 Then CONCAT(@mainClass,' cheapestPrice')
					 ELSE @mainClass
				END
		WHEN @returnValue = 2
			THEN 
				CASE
					WHEN @numberTwo < @mainNumber OR @mainNumber = 0
						THEN
							CASE
								When @numberTwo = @cheapestPrice 
									Then 
										CASE
											WHEN @numberTwo <= (@mainNumber * @AcceptableMargin)
												THEN 
													CASE
														WHEN @numberTwo <= (@mainNumber * @UnacceptableMargin)
														THEN CONCAT(@SecondClass,' cheapestPriceBigMargin smallerPrice')
														ELSE CONCAT(@SecondClass,' cheapestPriceMedMargin smallerPrice')
													END			
											ELSE CONCAT(@SecondClass,' cheapestPrice smallerPrice')
										END
								WHEN @numberTwo = 0			 Then CONCAT(@SecondClass,' noPrice')
								ELSE CONCAT(@SecondClass, ' smallerPrice')
							END
					WHEN @numberTwo > @mainNumber
						THEN CONCAT(@SecondClass, ' largerPrice')
					ELSE
						@SecondClass
				END
		WHEN @returnValue = 3
			THEN 
				CASE
					WHEN @numberThree < @mainNumber OR @mainNumber = 0
						THEN 
							CASE
								When @numberThree = @cheapestPrice	
									Then 
										CASE
											WHEN @numberThree <= (@mainNumber * @AcceptableMargin)
												THEN 
													CASE
														WHEN @numberThree <= (@mainNumber * @UnacceptableMargin)
														THEN CONCAT(@ThirdClass,' cheapestPriceBigMargin smallerPrice')
														ELSE CONCAT(@ThirdClass,' cheapestPriceMedMargin smallerPrice')
													END			
											ELSE CONCAT(@ThirdClass,' cheapestPrice smallerPrice')
										END
								WHEN @numberThree = 0				Then CONCAT(@ThirdClass,' noPrice')
								ELSE CONCAT(@ThirdClass, ' smallerPrice')
							END
					WHEN @numberThree > @mainNumber
						THEN CONCAT(@ThirdClass, ' largerPrice')
					ELSE
						@ThirdClass
				END
		WHEN @returnValue = 4
			THEN 
				CASE
					WHEN @numberFour < @mainNumber OR @mainNumber = 0
						THEN 
							CASE	
								When @numberFour  = @cheapestPrice 
									Then 
										CASE
											WHEN @numberFour <= (@mainNumber * @AcceptableMargin)
												THEN 
													CASE
														WHEN @numberFour <= (@mainNumber * @UnacceptableMargin)
														THEN CONCAT(@FourthClass,' cheapestPriceBigMargin smallerPrice')
														ELSE CONCAT(@FourthClass,' cheapestPriceMedMargin smallerPrice')
													END			
											ELSE CONCAT(@FourthClass,' cheapestPrice smallerPrice')
										END
								WHEN @numberFour = 0				Then CONCAT(@FourthClass,' noPrice')
								ELSE CONCAT(@FourthClass, ' smallerPrice')
							END			
					WHEN @numberFour > @mainNumber
						THEN CONCAT(@FourthClass, ' largerPrice')
					ELSE
						@FourthClass
				END
		WHEN @returnValue = 5
			THEN  
				CASE
					WHEN @numberFive < @mainNumber OR @mainNumber = 0
						THEN 
							CASE
								When @numberFive  = @cheapestPrice  
									Then 
										CASE
											WHEN @numberFive <= (@mainNumber * @AcceptableMargin)
												THEN 
													CASE
														WHEN @numberFive <= (@mainNumber * @UnacceptableMargin)
														THEN CONCAT(@FifthClass,' cheapestPriceBigMargin smallerPrice')
														ELSE CONCAT(@FifthClass,' cheapestPriceMedMargin smallerPrice')
													END			
											ELSE CONCAT(@FifthClass,' cheapestPrice smallerPrice')
										END
								WHEN @numberFive = 0				Then CONCAT(@FifthClass,' noPrice')
								ELSE CONCAT(@FifthClass, ' smallerPrice')
							END
					WHEN @numberFive > @mainNumber
						THEN CONCAT(@FifthClass, ' largerPrice')
					ELSE
						@FifthClass
				END
		WHEN @returnValue = 6
			THEN 
				CASE
					WHEN @numberSix < @mainNumber OR @mainNumber = 0
						THEN 
							CASE
								When @numberSix  = @cheapestPrice   
									Then 
										CASE
											WHEN @numberSix <= (@mainNumber * @AcceptableMargin)
												THEN 
													CASE
														WHEN @numberSix <= (@mainNumber * @UnacceptableMargin)
														THEN CONCAT(@SixthClass,' cheapestPriceBigMargin smallerPrice')
														ELSE CONCAT(@SixthClass,' cheapestPriceMedMargin smallerPrice')
													END			
											ELSE CONCAT(@SixthClass,' cheapestPrice smallerPrice')
										END
								WHEN @numberSix = 0				Then CONCAT(@SixthClass,' noPrice')
								ELSE CONCAT(@SixthClass, ' smallerPrice')
							END
					WHEN @numberSix > @mainNumber
						THEN CONCAT(@SixthClass, ' largerPrice')
					ELSE
						@SixthClass
				END
		WHEN @returnValue = 7
			THEN 
				CASE
					WHEN @numberSeven < @mainNumber OR @mainNumber = 0
						THEN 
							CASE	
								When @numberSeven = @cheapestPrice 
									Then 
										CASE
											WHEN @numberSeven <= (@mainNumber * @AcceptableMargin)
												THEN 
													CASE
														WHEN @numberSeven <= (@mainNumber * @UnacceptableMargin)
														THEN CONCAT(@SeventhClass,' cheapestPriceBigMargin smallerPrice')
														ELSE CONCAT(@SeventhClass,' cheapestPriceMedMargin smallerPrice')
													END			
											ELSE CONCAT(@SeventhClass,' cheapestPrice smallerPrice')
										END
								WHEN @numberSeven = 0				Then CONCAT(@SeventhClass,' noPrice')
								ELSE CONCAT(@SeventhClass, ' smallerPrice')
							END
					WHEN @numberSeven > @mainNumber
						THEN CONCAT(@SeventhClass, ' largerPrice')
					ELSE
						@SeventhClass
				END
		WHEN @returnValue = 8
			THEN 
				CASE
					WHEN @numberEight < @mainNumber OR @mainNumber = 0
						THEN 
							CASE	
								When @numberEight = @cheapestPrice 
									Then 
										CASE
											WHEN @numberEight <= (@mainNumber * @AcceptableMargin)
												THEN 
													CASE
														WHEN @numberEight <= (@mainNumber * @UnacceptableMargin)
														THEN CONCAT(@EighthClass,' cheapestPriceBigMargin smallerPrice')
														ELSE CONCAT(@EighthClass,' cheapestPriceMedMargin smallerPrice')
													END			
											ELSE CONCAT(@EighthClass,' cheapestPrice smallerPrice')
										END
								WHEN @numberEight = 0				Then CONCAT(@EighthClass,' noPrice')
								ELSE CONCAT(@EighthClass, ' smallerPrice')
							END
					WHEN @numberEight > @mainNumber
						THEN CONCAT(@EighthClass, ' largerPrice')
					ELSE
						@EighthClass
				END
		ELSE ''
	END

return @return 

END




GO
/****** Object:  UserDefinedFunction [dbo].[getClassNameTable]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getClassNameTable] ( 
	@scanID int,
	@mainNumber int,
	@numberTwo int,
	@numberThree int,
	@numberFour int,
	@numberFive int,
	@numberSix int,
	@numberSeven int,
	@numberEight int
)


RETURNS @tTempTableClasses TABLE (
	scanID int
	,mainClass nvarchar(50)
	,fSecondClass nvarchar(50)	
	,fThirdClass nvarchar(50)	
	,fFourthClass nvarchar(50)	
	,fFifthClass nvarchar(50)	
	,fSixthClass nvarchar(50)	
	,fSeventhClass nvarchar(50)	
	,fEighthClass nvarchar(50)
)
AS
BEGIN




---------------------------- THIS FUNCTION ISN'T BEING USED CURRENTLY------------------------------------------------------------------------------------------


	
--declare @Return nvarchar(MAX),
--		@mainClass nvarchar(MAX),
--		@SecondClass nvarchar(MAX),
--		@ThirdClass nvarchar(MAX),
--		@FourthClass nvarchar(MAX),
--		@FifthClass nvarchar(MAX),
--		@SixthClass nvarchar(MAX),
--		@SeventhClass nvarchar(MAX),
--		@EighthClass nvarchar(MAX)

--SET @mainClass = 'mainPrice'
--SET	@SecondClass = 'secondPrice'
--SET	@ThirdClass = 'thirdPrice'
--SET	@FourthClass = 'fourthPrice'
--SET	@FifthClass = 'fifthPrice'
--SET	@SixthClass = 'sixthPrice'
--SET	@SeventhClass = 'seventhPrice'
--SET	@EighthClass = 'eighthPrice'

----check to see if main price is average price
--DECLARE @averageprice decimal(18,2)
--SET @averageprice = avg(@mainNumber + @numberTwo + @numberThree + @numberFour + @numberFive + @numberSix + @numberSeven + @numberEight)
--SET @mainClass =
--CASE	
--	WHEN (@mainNumber >= (@averageprice*0.95)) AND (@mainNumber <= (@averageprice*1.05))
--		THEN CONCAT(@mainClass,' averagePrice')
--	ELSE @mainClass
--END

----remove nulls
--SET @numberTwo = IsNull(@numberTwo, 0)
--SET @numberThree = IsNull(@numberThree, 0)
--SET @numberFour = IsNull(@numberFour, 0)
--SET @numberFive = IsNull(@numberFive, 0)
--SET @numberSix = IsNull(@numberSix, 0)
--SET @numberSeven = IsNull(@numberSeven, 0)
--SET @numberEight = IsNull(@numberEight, 0)

----calculate smallest number
--DECLARE @cheapestPrice decimal(18,2)
--SET @cheapestPrice = 
--	CASE
--		WHEN NOT (@mainNumber = 0)
--		THEN @mainNumber
--		ELSE 10000
--	END
--SET @cheapestPrice = 
--	CASE
--		WHEN (@numberTwo < @cheapestPrice ) AND  (@numberTwo > 0)
--		THEN @numberTwo
--		ELSE @cheapestPrice
--	END
--SET @cheapestPrice = 
--	CASE
--		WHEN (@numberThree < @cheapestPrice ) AND  (@numberThree > 0)
--		THEN @numberThree
--		ELSE @cheapestPrice
--	END
--SET @cheapestPrice = 
--	CASE
--		WHEN (@numberFour < @cheapestPrice ) AND  (@numberFour > 0)
--		THEN @numberFour
--		ELSE @cheapestPrice
--	END
--SET @cheapestPrice = 
--	CASE
--		WHEN (@numberFive < @cheapestPrice ) AND  (@numberFive > 0)
--		THEN @numberFive
--		ELSE @cheapestPrice
--	END
--SET @cheapestPrice = 
--	CASE
--		WHEN (@numberSix < @cheapestPrice ) AND  (@numberSix > 0)
--		THEN @numberSix
--		ELSE @cheapestPrice
--	END
--SET @cheapestPrice = 
--	CASE
--		WHEN (@numberSeven < @cheapestPrice ) AND  (@numberSeven > 0)
--		THEN @numberSeven
--		ELSE @cheapestPrice
--	END
--SET @cheapestPrice = 
--	CASE
--		WHEN (@numberEight < @cheapestPrice ) AND (@numberEight > 0)
--		THEN @numberEight
--		ELSE @cheapestPrice
--	END



----set the final class names
--SET @mainClass = 
--	Case When @mainNumber = @cheapestPrice 
--		Then CONCAT(@mainClass,' cheapestPrice')
--		ELSE @mainClass
--	END
--SET @SecondClass = 
--	CASE
--		WHEN @numberTwo < @mainNumber
--			THEN
--				CASE
--					When @numberTwo = @cheapestPrice Then CONCAT(@SecondClass,' cheapestPrice smallerPrice')
--					WHEN @numberTwo = 0			 Then CONCAT(@SecondClass,' noPrice')
--					ELSE CONCAT(@SecondClass, ' smallerPrice')
--				END
--		WHEN @numberTwo > @mainNumber
--			THEN CONCAT(@SecondClass, ' largerPrice')
--		ELSE
--			@SecondClass
--	END
--SET @ThirdClass = 
--	CASE
--		WHEN @numberTwo < @mainNumber
--			THEN
--				CASE
--					When @numberTwo = @cheapestPrice Then CONCAT(@ThirdClass,' cheapestPrice smallerPrice')
--					WHEN @numberTwo = 0			 Then CONCAT(@ThirdClass,' noPrice')
--					ELSE CONCAT(@ThirdClass, ' smallerPrice')
--				END
--		WHEN @numberTwo > @mainNumber
--			THEN CONCAT(@ThirdClass, ' largerPrice')
--		ELSE
--			@ThirdClass
--	END	
--SET @FourthClass = 
--	CASE
--		WHEN @numberTwo < @mainNumber
--			THEN
--				CASE
--					When @numberTwo = @cheapestPrice Then CONCAT(@FourthClass,' cheapestPrice smallerPrice')
--					WHEN @numberTwo = 0			 Then CONCAT(@FourthClass,' noPrice')
--					ELSE CONCAT(@FourthClass, ' smallerPrice')
--				END
--		WHEN @numberTwo > @mainNumber
--			THEN CONCAT(@FourthClass, ' largerPrice')
--		ELSE
--			@FourthClass
--	END	
--SET @FifthClass = 
--	CASE
--		WHEN @numberTwo < @mainNumber
--			THEN
--				CASE
--					When @numberTwo = @cheapestPrice Then CONCAT(@FifthClass,' cheapestPrice smallerPrice')
--					WHEN @numberTwo = 0			 Then CONCAT(@FifthClass,' noPrice')
--					ELSE CONCAT(@FifthClass, ' smallerPrice')
--				END
--		WHEN @numberTwo > @mainNumber
--			THEN CONCAT(@FifthClass, ' largerPrice')
--		ELSE
--			@FifthClass
--	END
--SET @SixthClass = 
--	CASE
--		WHEN @numberTwo < @mainNumber
--			THEN
--				CASE
--					When @numberTwo = @cheapestPrice Then CONCAT(@SixthClass,' cheapestPrice smallerPrice')
--					WHEN @numberTwo = 0			 Then CONCAT(@SixthClass,' noPrice')
--					ELSE CONCAT(@SixthClass, ' smallerPrice')
--				END
--		WHEN @numberTwo > @mainNumber
--			THEN CONCAT(@SixthClass, ' largerPrice')
--		ELSE
--			@SixthClass
--	END	
--SET @SeventhClass = 
--	CASE
--		WHEN @numberTwo < @mainNumber
--			THEN
--				CASE
--					When @numberTwo = @cheapestPrice Then CONCAT(@SeventhClass,' cheapestPrice smallerPrice')
--					WHEN @numberTwo = 0			 Then CONCAT(@SeventhClass,' noPrice')
--					ELSE CONCAT(@SeventhClass, ' smallerPrice')
--				END
--		WHEN @numberTwo > @mainNumber
--			THEN CONCAT(@SeventhClass, ' largerPrice')
--		ELSE
--			@SeventhClass
--	END
--SET @EighthClass = 
--	CASE
--		WHEN @numberTwo < @mainNumber
--			THEN
--				CASE
--					When @numberTwo = @cheapestPrice Then CONCAT(@EighthClass,' cheapestPrice smallerPrice')
--					WHEN @numberTwo = 0			 Then CONCAT(@EighthClass,' noPrice')
--					ELSE CONCAT(@EighthClass, ' smallerPrice')
--				END
--		WHEN @numberTwo > @mainNumber
--			THEN CONCAT(@EighthClass, ' largerPrice')
--		ELSE
--			@EighthClass
--	END

--	INSERT INTO @tTempTableClasses
--	VALUES	 (@scanID, @mainClass, @SecondClass, @ThirdClass, @FourthClass, @FifthClass, @SixthClass, @SeventhClass, @EighthClass)


return 

END



---------------------------- THIS FUNCTION ISN'T BEING USED CURRENTLY------------------------------------------------------------------------------------------

GO
/****** Object:  UserDefinedFunction [dbo].[getClassNameTableForPriceIncrease]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <29/04/15>
-- Description:	<get the Class name for the Price increase table>
-- =============================================
CREATE FUNCTION [dbo].[getClassNameTableForPriceIncrease]
(
	 @price decimal(18,2)
	,@priceOld decimal(18,2)
	,@priceChange decimal(18,2)
)
RETURNS nvarchar(200)
AS
BEGIN	
	DECLARE @class nvarchar(200)

	SET @class = 
			CASE	
				WHEN @price > @priceOld
					THEN CONCAT(@class,' priceIncrease')
				WHEN @price < @priceOld
					THEN CONCAT(@class,' priceDecrease')
				WHEN @price = @priceOld
					THEN CONCAT(@class,' priceNoChange')
				ELSE ' noPrice'
			END

	RETURN @class
END



GO
/****** Object:  UserDefinedFunction [dbo].[getCountryID]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10-04-15>
-- Description:	<get country ID from data scan>
-- =============================================
CREATE FUNCTION [dbo].[getCountryID]
(
	 @fScanID int
	,@typeID int
)
RETURNS int
AS
BEGIN
	
	DECLARE @fScanURLID int
	--SET @fScanURLID = 0
	
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tTempTravelCountry]') AND type in (N'U'))
	SET @fScanURLID = 
		CASE
			WHEN @typeID = 1
			THEN (  SELECT fCountryID FROM tTempTravelCountry 
					WHERE fCountryName = (SELECT [fScanTravelCountry] FROM [tDataScan] WHERE fID = @fScanID)
				 )
			WHEN @typeID = 2
			THEN (  SELECT fCountryID FROM tTempTravelCountry 
					WHERE fCountryName = (SELECT [fScanLicenceCountry] FROM [tDataScan] WHERE fID = @fScanID)
				 )
		END

	RETURN @fScanURLID

END



GO
/****** Object:  UserDefinedFunction [dbo].[getCurrencyID]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10-04-15>
-- Description:	<get curerncy id from datascan>
-- =============================================
CREATE FUNCTION [dbo].[getCurrencyID]
(
	@fScanID int
)
RETURNS int
AS
BEGIN
	
	DECLARE @fScanURLID int
	--SET @fScanURLID = 0
	
	SET @fScanURLID = (SELECT fID FROM [tRefCurrency] WHERE [fCurrencyCode] = (SELECT  [fScanCurrency] FROM [tDataScan] WHERE fID = @fScanID))

	RETURN @fScanURLID

END



GO
/****** Object:  UserDefinedFunction [dbo].[getFirstDayOfWeek]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <24-04-15>
-- Description:	<Get first day of week>
-- =============================================
CREATE FUNCTION [dbo].[getFirstDayOfWeek]
(
	@DateToConvert nvarchar(50)
)
RETURNS smalldatetime
AS
BEGIN

	--DECLARE @checkIfDate nvarchar(50)
	--SET @checkIfDate = cast(@DateToConvert as nvarchar(50))
	IF (TRY_PARSE(@DateToConvert AS smalldatetime USING 'en-US')) IS NULL
		BEGIN		
			RETURN NULL
		END
	
	DECLARE @wkStartDate smalldatetime
	SET @wkStartDate =
				CASE	
					WHEN datepart(dw,@DateToConvert) = 2 -- when today is a Monday
						THEN @DateToConvert
					WHEN datepart(dw,@DateToConvert) = 3 -- when today is a Tuesday
						THEN dateadd(day,-1,@DateToConvert)
					WHEN datepart(dw,@DateToConvert) = 4 -- when today is a Wednesday
						THEN dateadd(day,-2,@DateToConvert)
					WHEN datepart(dw,@DateToConvert) = 5 -- when today is a Thursday
						THEN dateadd(day,-3,@DateToConvert)
					WHEN datepart(dw,@DateToConvert) = 6 -- when today is a Friday
						THEN dateadd(day,-4,@DateToConvert)
					WHEN datepart(dw,@DateToConvert) = 7 -- when today is a Saturday
						THEN dateadd(day,-5,@DateToConvert)
					WHEN datepart(dw,@DateToConvert) = 1 -- when today is a Sunday
						THEN dateadd(day,-6,@DateToConvert)
					ELSE getdate()
				END	

	RETURN @wkStartDate

END



GO
/****** Object:  UserDefinedFunction [dbo].[getLicenceCountryByIntOrDom]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <27/03/15>
-- Description:	<Get Int/Domestic Drivers licence country code>
-- =============================================
CREATE FUNCTION [dbo].[getLicenceCountryByIntOrDom]
(
	@ScanURL int, 
	@CountryID int, 
	@LicenceCountryID int
)
RETURNS int
AS
BEGIN

	DECLARE @returnScanID int
		
	SET @returnScanID = 
		CASE
			WHEN @LicenceCountryID = 1 --DOMESTIC
				THEN
					(
					SELECT [fDomLicenceCountryID]
					FROM [comparison].[dbo].[tRefDriversLicenceCodes]
					WHERE [fWebsiteID] = @ScanURL
					AND   [fTravelCountryID] = @CountryID
					)
			ELSE
					(
					SELECT [fIntLicenceCountryID]
					FROM [comparison].[dbo].[tRefDriversLicenceCodes]
					WHERE [fWebsiteID] = @ScanURL
					AND   [fTravelCountryID] = @CountryID
					)
		END

	RETURN @returnScanID
END




GO
/****** Object:  UserDefinedFunction [dbo].[getListPriceExceptionsAsString]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <17/03/15>
-- Description:	<Get list of price exceptions for this specific item, as a string>
-- =============================================
CREATE FUNCTION [dbo].[getListPriceExceptionsAsString]
(
	 @fScanTotalPrice decimal(18,2)
	,@fScanURL int 
	,@fScanVehicleID int 
	,@fScanTravelCountryID int 
	,@fScanPickupLocationID int 
	,@fScanReturnLocationID int 
	,@fScanPickupDate smalldatetime 
	,@fScanCurrencyID int
	,@PriceExceptions int
)
RETURNS nvarchar (MAX)
AS
BEGIN
	
	-- set return price to scanPrice variable
	DECLARE @returnString nvarchar (max)
	SET @returnString = ''
	
	-- set return price to scanPrice variable
	DECLARE @returnPrice decimal(8,2), @isoneWay int, @originalPrice decimal(8,2)
	SET @returnPrice = @fScanTotalPrice
	SET @originalPrice = @fScanTotalPrice
	
	--check if website already includes fees or not
	DECLARE @websiteIncludesFees int
	SET @websiteIncludesFees = (SELECT fWebsiteIncludesFees FROM tRefWebsite WHERE fID = @fScanURL)

	-- Return original price if price exceptions is turned off
	IF (@PriceExceptions = 0) OR (@PriceExceptions = 1 AND @websiteIncludesFees = 1) OR (@PriceExceptions = 2 AND @websiteIncludesFees = 0)
	RETURN '(none)'

	--GET VEHICLE BRAND
	DECLARE @vehicleBrandID int
	SET @vehicleBrandID = (SELECT fVehicleBrandID FROM tRefVehicle WHERE fID = @fScanVehicleID)

	--Check if is a one way trip
	SET @IsOneWay = 
		CASE
			WHEN @fScanPickupLocationID = @fScanReturnLocationID
				THEN 0
			ELSE 1
		END

	-- declare variables for price changes
	DECLARE @Times decimal(18,15), @TimesAmount decimal(10,4), @Add decimal(18,2), @Subtract decimal(18,2), @thisCountrysCurrency nvarchar(3)
	SET @Add = 0.00
	SET @Subtract = 0.00
	SET @thisCountrysCurrency = (SELECT fCurrencyCode FROM tRefCountry WHERE fID = @fScanTravelCountryID)
	
	DECLARE @thisVehicleID int
	SET @thisVehicleID = (SELECT fVehicleBrandID FROM tRefVehicle WHERE fID = @fScanVehicleID)
	
	-- create table to hold list of exceptoins
	DECLARE @exceptionsTable TABLE (fID INT IDENTITY(1,1) PRIMARY KEY, fldAddAmount decimal(8,2) DEFAULT 0, fldTimesAmount decimal(8,2) DEFAULT 0)
	-- get additon exceptions
	INSERT INTO @exceptionsTable (fldAddAmount)
	SELECT [dbo].[convertPriceToCurrency](fPriceExceptionPriceChange, fPriceExceptionCurrencyID, getdate(), @fScanTravelCountryID) from tRefPriceException as tP
	where fActive = 1
	AND (@fScanVehicleID = 0 OR (@thisVehicleID in (SELECT fBrandID FROM tRefPriceExceptionBrands WHERE fExceptionID = tP.fID AND fActive = 1)))
	AND (fPriceExceptionCountryID = @fScanTravelCountryID or @fScanTravelCountryID = 0)
	AND (fPriceExceptionOneWay = 0)
	AND (fPriceExceptionDateStart <= @fScanPickupDate)
	AND (fPriceExceptionDateEnd >= dateadd(day,10,(@fScanPickupDate)))
	AND (fPriceExceptionPriceChange > 0 or fPriceExceptionPriceChange < 0)
	AND (  (		(@fScanPickupLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1) OR @fScanPickupLocationID = 0)
				AND (@fScanReturnLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1) OR @fScanReturnLocationID = 0)
			)
			OR
			(		(@fScanPickupLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1) OR @fScanPickupLocationID = 0)
				AND ((SELECT sum(isnull(fLocationID,0))  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1) = 0)
			)
			OR
			(		((SELECT sum(isnull(fLocationID,0))  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1) = 0)
				AND (@fScanReturnLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1) OR @fScanReturnLocationID = 0)
			)
		)
	--get one-way addition exceptions
	INSERT INTO @exceptionsTable (fldAddAmount)
	select top 1 [dbo].[convertPriceToCurrency](fPriceExceptionPriceChange, fPriceExceptionCurrencyID, getdate(), @fScanTravelCountryID) from tRefPriceException as tP
	where fActive = 1
	AND (@fScanVehicleID = 0 OR (@thisVehicleID in (SELECT fBrandID FROM tRefPriceExceptionBrands WHERE fExceptionID = tP.fID AND fActive = 1)))
	AND (fPriceExceptionCountryID = @fScanTravelCountryID or @fScanTravelCountryID = 0)
	AND (fPriceExceptionOneWay = @isoneWay AND @isoneWay = 1)
	AND (fPriceExceptionDateStart <= @fScanPickupDate )
	AND (fPriceExceptionDateEnd >= dateadd(day,10,(@fScanPickupDate)))
	AND (fPriceExceptionPriceChange > 0 or fPriceExceptionPriceChange < 0)
	AND ((@fScanPickupLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1)
	OR (@fScanReturnLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1))))
	ORDER BY fPriceExceptionPriceChange DESC
	
	--get times exceptions
	INSERT INTO @exceptionsTable (fldTimesAmount)
	SELECT fPriceExceptionPercentage from tRefPriceException as tP
	where fActive = 1
	AND (@fScanVehicleID = 0 OR (@thisVehicleID in (SELECT fBrandID FROM tRefPriceExceptionBrands WHERE fExceptionID = tP.fID AND fActive = 1)))
	AND (fPriceExceptionCountryID = @fScanTravelCountryID or @fScanTravelCountryID = 0)
	AND (fPriceExceptionOneWay = 0)
	AND (fPriceExceptionDateStart <= @fScanPickupDate)
	AND (fPriceExceptionDateEnd >= dateadd(day,10,(@fScanPickupDate)))
	AND (fPriceExceptionPercentage > 0 or fPriceExceptionPercentage < 0)
	AND (  (		(@fScanPickupLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1) OR @fScanPickupLocationID = 0)
				AND (@fScanReturnLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1) OR @fScanReturnLocationID = 0)
			)
			OR
			(		(@fScanPickupLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1) OR @fScanPickupLocationID = 0)
				AND ((SELECT sum(isnull(fLocationID,0)) FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1) = 0)
			)
			OR
			(		((SELECT sum(isnull(fLocationID,0))  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1) = 0)
				AND (@fScanReturnLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1) OR @fScanReturnLocationID = 0)
			)
	)
	--get one-way addition exceptions
	INSERT INTO @exceptionsTable (fldTimesAmount)
	select top 1 fPriceExceptionPercentage from tRefPriceException as tP
	where fActive = 1
	AND (@fScanVehicleID = 0 OR (@thisVehicleID in (SELECT fBrandID FROM tRefPriceExceptionBrands WHERE fExceptionID = tP.fID AND fActive = 1)))
	AND (fPriceExceptionCountryID = @fScanTravelCountryID or @fScanTravelCountryID = 0)
	AND (fPriceExceptionOneWay = @isoneWay AND @isoneWay = 1)
	AND (fPriceExceptionDateStart <= @fScanPickupDate )
	AND (fPriceExceptionDateEnd >= dateadd(day,10,(@fScanPickupDate)))
	AND (fPriceExceptionPercentage > 0 or fPriceExceptionPercentage < 0)
	AND ((@fScanPickupLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 1 and fActive = 1)
	OR (@fScanReturnLocationID in (SELECT fLocationID  FROM tRefPriceExceptionLocations WHERE fExceptionID = tP.fID AND fPickupOrDropoff = 2 and fActive = 1))))
	ORDER BY fPriceExceptionPriceChange DESC
	
	
	--get total add value
	SET @Add = (SELECT sum(fldAddAmount) FROM @exceptionsTable)
	--Add/subtract any dollar value changes
	SET @returnPrice = 
		CASE
			WHEN @Add > 0 OR @Add < 0
			THEN 
				CASE
					WHEN @PriceExceptions = 1 AND @websiteIncludesFees = 0
						THEN CAST(@returnPrice + @Add as decimal(8,2))
					WHEN @PriceExceptions = 2 AND @websiteIncludesFees = 1
						THEN CAST(@returnPrice - @Add as decimal(8,2))
					ELSE @returnPrice
				END
			ELSE @returnPrice
		END
		
	--get times values
	SET @Times = (SELECT sum(fldTimesAmount) FROM @exceptionsTable) / 100
	SET @TimesAmount = 
		CASE
			WHEN @Times > 0 OR @Times < 0
			THEN 
				CASE
					WHEN @websiteIncludesFees = 0
						THEN cast(@returnPrice * @Times as decimal(10,5))
					WHEN @websiteIncludesFees = 1
						THEN cast(( @originalPrice / (1 + @Times) * @Times) as decimal(10,5))
					ELSE 0
				END
			ELSE 0			
		END		

	--get total change amount
	DECLARE @totalChange decimal(10,2)
	SET @totalChange = @Add - @subtract + @TimesAmount

	
	--add start of bracket
	SET @returnString = 
		CASE
			WHEN @Add <> 0 OR @Subtract <> 0
				THEN CONCAT (@returnString,'(')
			ELSE @returnString
		END

	--add list of Add/subtraction changes
	SET @returnString = 
		CASE
			WHEN @Add <> 0
			THEN 
				CASE
					WHEN @PriceExceptions = 1 AND @websiteIncludesFees = 0
						THEN CONCAT (@returnString,' Add: ', @Add, ' ', @thisCountrysCurrency)
					WHEN @PriceExceptions = 2 AND @websiteIncludesFees = 1
						THEN CONCAT (@returnString,' Subtract: ', @Add, ' ', @thisCountrysCurrency)
				END
			ELSE @returnString
		END

	--add list of Add/subtraction changes
	SET @returnString = 
		CASE
			WHEN @Subtract <> 0
			THEN 
				CASE
					WHEN @PriceExceptions = 1 AND @websiteIncludesFees = 0
						THEN CONCAT (@returnString,' Subtract: ', @Subtract, ' ', @thisCountrysCurrency)
					WHEN @PriceExceptions = 2 AND @websiteIncludesFees = 1
						THEN CONCAT (@returnString,' Add: ', @Subtract, ' ', @thisCountrysCurrency)
				END
			ELSE @returnString
		END
		
	DECLARE @multiplyString nvarchar(50), @multiplySign nvarchar(50)
	SET @multiplySign = 
		CASE
			WHEN @PriceExceptions = 1 AND @websiteIncludesFees = 0
				THEN '-'
			WHEN @PriceExceptions = 2 AND @websiteIncludesFees = 1
				THEN '+'
			ELSE ''
		END
	SET @multiplyString = 
		CASE
			WHEN @PriceExceptions = 1 AND @websiteIncludesFees = 0
				THEN 'add '
			WHEN @PriceExceptions = 2 AND @websiteIncludesFees = 1
				THEN 'subtract '
			ELSE ''
		END

	--Add list of times changes
	SET @returnString = 
		CASE
			WHEN @Times <> 0 AND @Times <> 1
			THEN CONCAT (@returnString,' <br/> Multiply by: ',@multiplySign,cast(@Times*100 as decimal(5,2)),'% equals: ',@multiplyString, cast(@TimesAmount as decimal(10,2)), ' ', @thisCountrysCurrency )
			ELSE @returnString
		END
		
	--add end of bracket
	SET @returnString = 
		CASE
			WHEN @Add <> 0 OR @Subtract <> 0
				THEN CONCAT (@returnString,')')
			ELSE @returnString
		END

	SET @returnString = 
		CASE
			WHEN @totalChange <> 0 
				THEN CONCAT(' ',@totalChange, ' ', @thisCountrysCurrency,' <br/> ', @returnString)
			ELSE @returnString
		END

	SET @returnString = 
		CASE
			WHEN @returnString = '' OR @returnString IS NULL
			THEN 'none'
			ELSE @returnString
		END
	
	--COALESCE(NULLIF(@returnString,''), 'none')	

	RETURN @returnString

END




GO
/****** Object:  UserDefinedFunction [dbo].[getLocationID]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10-04-15>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getLocationID]
(
	@fScanID int
	,@typeID int
)
RETURNS int
AS
BEGIN
	
	DECLARE @ID int
	--SET @fScanURLID = 0
	
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tTempTravelLocation]') AND type in (N'U'))
	SET @ID = 
		CASE
			WHEN @typeID = 1
			THEN (  SELECT fLocationID FROM tTempTravelLocation 
					WHERE fLocationName = (SELECT [fScanPickupLocation] FROM [tDataScan] WHERE fID = @fScanID)
				 )
			WHEN @typeID = 2
			THEN (  SELECT fLocationID FROM tTempTravelLocation 
					WHERE fLocationName = (SELECT [fScanReturnLocation] FROM [tDataScan] WHERE fID = @fScanID)
				 )
		END

	RETURN @ID

END





GO
/****** Object:  UserDefinedFunction [dbo].[getOrderOfComparisonData]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <19/03/15>
-- Description:	<set the order of the website data>
-- =============================================
CREATE FUNCTION [dbo].[getOrderOfComparisonData]
(
	@mainScanID int,
	@scanIDposition int
)
RETURNS int
AS
BEGIN

	DECLARE @returnScanID int

	SET @returnScanID = 

		CASE
			WHEN @mainScanID = 1
				THEN
					CASE
						WHEN @scanIDposition = 1 THEN 1
						WHEN @scanIDposition = 2 THEN 2
						WHEN @scanIDposition = 3 THEN 3
						WHEN @scanIDposition = 4 THEN 4
						WHEN @scanIDposition = 5 THEN 5
						WHEN @scanIDposition = 6 THEN 6
						WHEN @scanIDposition = 7 THEN 7
						WHEN @scanIDposition = 8 THEN 8		
					END
			WHEN @mainScanID = 2
				THEN
					CASE
						WHEN @scanIDposition = 1 THEN 2
						WHEN @scanIDposition = 2 THEN 1
						WHEN @scanIDposition = 3 THEN 3
						WHEN @scanIDposition = 4 THEN 4
						WHEN @scanIDposition = 5 THEN 5
						WHEN @scanIDposition = 6 THEN 6
						WHEN @scanIDposition = 7 THEN 7	
						WHEN @scanIDposition = 8 THEN 8	
					END
			WHEN @mainScanID = 3
				THEN
					CASE
						WHEN @scanIDposition = 1 THEN 3
						WHEN @scanIDposition = 2 THEN 1
						WHEN @scanIDposition = 3 THEN 2
						WHEN @scanIDposition = 4 THEN 4
						WHEN @scanIDposition = 5 THEN 5
						WHEN @scanIDposition = 6 THEN 6
						WHEN @scanIDposition = 7 THEN 7	
						WHEN @scanIDposition = 8 THEN 8		
					END
			WHEN @mainScanID = 4
				THEN
					CASE
						WHEN @scanIDposition = 1 THEN 4
						WHEN @scanIDposition = 2 THEN 1
						WHEN @scanIDposition = 3 THEN 2
						WHEN @scanIDposition = 4 THEN 3
						WHEN @scanIDposition = 5 THEN 5
						WHEN @scanIDposition = 6 THEN 6
						WHEN @scanIDposition = 7 THEN 7	
						WHEN @scanIDposition = 8 THEN 8		
					END
			WHEN @mainScanID = 5
				THEN
					CASE
						WHEN @scanIDposition = 1 THEN 5
						WHEN @scanIDposition = 2 THEN 1
						WHEN @scanIDposition = 3 THEN 2
						WHEN @scanIDposition = 4 THEN 3
						WHEN @scanIDposition = 5 THEN 4
						WHEN @scanIDposition = 6 THEN 6
						WHEN @scanIDposition = 7 THEN 7	
						WHEN @scanIDposition = 8 THEN 8		
					END
			WHEN @mainScanID = 6
				THEN
					CASE
						WHEN @scanIDposition = 1 THEN 6
						WHEN @scanIDposition = 2 THEN 1
						WHEN @scanIDposition = 3 THEN 2
						WHEN @scanIDposition = 4 THEN 3
						WHEN @scanIDposition = 5 THEN 4
						WHEN @scanIDposition = 6 THEN 5
						WHEN @scanIDposition = 7 THEN 7	
						WHEN @scanIDposition = 8 THEN 8			
					END
			WHEN @mainScanID = 7
				THEN
					CASE
						WHEN @scanIDposition = 1 THEN 7
						WHEN @scanIDposition = 2 THEN 1
						WHEN @scanIDposition = 3 THEN 2
						WHEN @scanIDposition = 4 THEN 3
						WHEN @scanIDposition = 5 THEN 4
						WHEN @scanIDposition = 6 THEN 5
						WHEN @scanIDposition = 7 THEN 6	
						WHEN @scanIDposition = 8 THEN 8			
					END
			WHEN @mainScanID = 8
				THEN
					CASE
						WHEN @scanIDposition = 1 THEN 8
						WHEN @scanIDposition = 2 THEN 1
						WHEN @scanIDposition = 3 THEN 2
						WHEN @scanIDposition = 4 THEN 3
						WHEN @scanIDposition = 5 THEN 4
						WHEN @scanIDposition = 6 THEN 5
						WHEN @scanIDposition = 7 THEN 6	
						WHEN @scanIDposition = 8 THEN 7		
					END
		END

	RETURN @returnScanID

END




GO
/****** Object:  UserDefinedFunction [dbo].[getScanDataWeeklyCountsCHECKAGAINSTAVERAGE]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/04/15>
-- Description:	<check amount value deviates from average>
-- =============================================
CREATE FUNCTION [dbo].[getScanDataWeeklyCountsCHECKAGAINSTAVERAGE]
(
	@count int,
	@averageCount int
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	--DECLARE @returnString nvarchar(200)
	--DECLARE @marginOfError1 int
	--DECLARE @marginOfError2 int
	--DECLARE @marginClass nvarchar(200)
	DECLARE @percentChange decimal (18,2)

	-- set values of variables
	--SET @marginOfError1 = 5
	--SET @marginOfError2 = 10

	SET @percentChange = (CAST((CAST((@count - @averageCount) as decimal(18,2))/@averageCount*100) as decimal(18,2)))

	--SET @marginClass = 'countChange'
	--SET @marginClass = 
	--	CASE 
	--		WHEN @percentChange > @marginOfError2 OR @percentChange <( @marginOfError2 *-1)
	--			THEN CONCAT(@marginClass,' highAlert')
	--		WHEN @percentChange > @marginOfError1 OR @percentChange <( @marginOfError1 *-1)
	--			THEN CONCAT(@marginClass,' lowAlert')
	--		ELSE @marginClass
	--	END
	
	-- create string
	--SET @returnString = CONCAT(@count,' <span class="',@marginClass,'"> (',@percentChange,'%)</span>') 

	-- return variable
	RETURN @percentChange

END



GO
/****** Object:  UserDefinedFunction [dbo].[getScanDataWeeklyCountsGETCLASS]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10/04/15>
-- Description:	<check amount value deviates from average to get class value>
-- =============================================
CREATE FUNCTION [dbo].[getScanDataWeeklyCountsGETCLASS]
(
	@count int,
	@averageCount int
)
RETURNS nvarchar(200)
AS
BEGIN
	-- Declare the return variable here
	--DECLARE @returnString nvarchar(200)
	DECLARE @marginOfError1 int
	DECLARE @marginOfError2 int
	DECLARE @marginClass nvarchar(200)
	DECLARE @percentChange decimal (18,2)

	-- set values of variables
	SET @marginOfError1 = 5
	SET @marginOfError2 = 10
	SET @percentChange = (CAST((CAST((@count - @averageCount) as decimal(18,2))/@averageCount*100) as decimal(18,2)))
	SET @marginClass = 'countChange'
	SET @marginClass = 
		CASE 
			WHEN @count = 0
				THEN CONCAT(@marginClass,' noData')
			WHEN @percentChange > @marginOfError2 OR @percentChange <( @marginOfError2 *-1)
				THEN CONCAT(@marginClass,' highAlert')
			WHEN @percentChange > @marginOfError1 OR @percentChange <( @marginOfError1 *-1)
				THEN CONCAT(@marginClass,' lowAlert')
			ELSE @marginClass
		END
	
	-- create string
	--SET @returnString = CONCAT(@count,' <span class="',@marginClass,'"> (',@percentChange,'%)</span>') 

	-- return variable
	RETURN @marginClass

END



GO
/****** Object:  UserDefinedFunction [dbo].[getURLID]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <10-04-15>
-- Description:	<get URL ID from data scan>
-- =============================================
CREATE FUNCTION [dbo].[getURLID]
(
	@fScanID int
)
RETURNS int
AS
BEGIN
	
	DECLARE @fScanURLID int
	--SET @fScanURLID = 0
	
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tTempURLs]') AND type in (N'U'))
	SET @fScanURLID = (SELECT fWebsiteID FROM tTempURLs WHERE fWebsiteDomain = (SELECT  [fScanURL] FROM [tDataScan] WHERE fID = @fScanID))

	RETURN @fScanURLID

END



GO
/****** Object:  UserDefinedFunction [dbo].[getVehicleByBrandClassesAndComparisons]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getVehicleByBrandClassesAndComparisons] ( )

RETURNS @tTempTableClassesAndComparisons TABLE (
	fScanID int
	,fMainClass nvarchar(200)
	,fFirstComparison decimal (18,2)
	,fSecondClass nvarchar(200)	
	,fSecondComparison decimal (18,2)
	,fThirdClass nvarchar(200)
	,fThirdComparison decimal (18,2)	
	,fFourthClass nvarchar(200)
	,fFourthComparison decimal (18,2)	
	,fFifthClass nvarchar(200)	
	,fFifthComparison decimal (18,2)
	,fSixthClass nvarchar(200)	
	,fSixthComparison decimal (18,2)
	,fSeventhClass nvarchar(200)	
	,fSeventhComparison decimal (18,2)
	,fEighthClass nvarchar(200)
	,fEighthComparison decimal (18,2)
)
AS
BEGIN


---------------------------- THIS FUNCTION ISN'T BEING USED CURRENTLY------------------------------------------------------------------------------------------


	
--declare @Return nvarchar(MAX),
--		@RowCount int,
--		@scanID int,
--		@mainClass nvarchar(MAX),
--		@SecondClass nvarchar(MAX),
--		@ThirdClass nvarchar(MAX),
--		@FourthClass nvarchar(MAX),
--		@FifthClass nvarchar(MAX),
--		@SixthClass nvarchar(MAX),
--		@SeventhClass nvarchar(MAX),
--		@EighthClass nvarchar(MAX),
--		@mainNumber int,
--		@numberOne int,
--		@numberTwo int,
--		@numberThree int,
--		@numberFour int,
--		@numberFive int,
--		@numberSix int,
--		@numberSeven int,
--		@numberEight int,
--		@comparisonOne decimal(18,2),
--		@comparisonTwo decimal(18,2),
--		@comparisonThree decimal(18,2),
--		@comparisonFour decimal(18,2),
--		@comparisonFive decimal(18,2),
--		@comparisonSix decimal(18,2),
--		@comparisonSeven decimal(18,2),
--		@comparisonEight decimal(18,2),
--		@averageprice decimal(18,2),
--		@smallestPrice decimal (18,2),
--		@prevComparedToVehicle nvarchar (200),
--		@prevDate nvarchar (200),
--		@mainLocationCombo nvarchar (200)

--SET @mainClass = 'firstPrice'
--SET	@SecondClass = 'secondPrice'
--SET	@ThirdClass = 'thirdPrice'
--SET	@FourthClass = 'fourthPrice'
--SET	@FifthClass = 'fifthPrice'
--SET	@SixthClass = 'sixthPrice'
--SET	@SeventhClass = 'seventhPrice'
--SET	@EighthClass = 'eighthPrice'
--SET @comparisonOne  = 0
--SET @comparisonTwo  = 0
--SET @comparisonThree   = 0
--SET @comparisonFour   = 0
--SET @comparisonFive   = 0
--SET @comparisonSix   = 0
--SET @comparisonSeven   = 0
--SET @comparisonEight  = 0
--SET @averageprice = 0
--SET @smallestPrice = 0
--SET @RowCount = 0
--SET @mainLocationCombo = ''
--SET @prevComparedToVehicle = ''
--SET @prevDate = ''

--WHILE @RowCount < ((select count(fScanID) from tTempTableLarge)-1)
--BEGIN
--	SET @prevComparedToVehicle = 
--		CASE
--			WHEN @RowCount > 0
--			THEN (SELECT [fVehicleCompareName] FROM tTempTableLarge WHERE fID = @RowCount)
--		ELSE
--			''
--		END

--	SET @prevDate = 
--		CASE
--			WHEN @RowCount > 0
--			THEN (SELECT [fTravelDates] FROM tTempTableLarge WHERE fID = @RowCount)
--		ELSE
--			''
--		END

--	-- reset class values
--	SET @mainClass = 'firstPrice'
--	SET	@SecondClass = 'secondPrice'
--	SET	@ThirdClass = 'thirdPrice'
--	SET	@FourthClass = 'fourthPrice'
--	SET	@FifthClass = 'fifthPrice'
--	SET	@SixthClass = 'sixthPrice'
--	SET	@SeventhClass = 'seventhPrice'
--	SET	@EighthClass = 'eighthPrice'
--	SET @comparisonOne  = 0
--	SET @comparisonTwo  = 0
--	SET @comparisonThree   = 0
--	SET @comparisonFour   = 0
--	SET @comparisonFive   = 0
--	SET @comparisonSix   = 0
--	SET @comparisonSeven   = 0
--	SET @comparisonEight  = 0
--	SET @numberOne = 0
--	SET @numberTwo = 0
--	SET @numberThree = 0
--	SET @numberFour = 0
--	SET @numberFive = 0
--	SET @numberSix = 0
--	SET @numberSeven = 0
--	SET @numberEight = 0

--	-- where this vehicle (to be comapred to) is NOT the same as the last row, and not the same date
--	--IF ((SELECT fScanID FROM tTempTableLarge WHERE fID = (@RowCount + 1)) in (SELECT fScanID  FROM tTempTableLarge WHERE [fVehicleCompareName] = [fVehicleName] ))
--	--	BEGIN
--			--check to see if main price is average price
--			SET @mainLocationCombo = (SELECT top 1 ([fLocationCombination]) FROM tTempTableLarge
--								WHERE [fCountryName] = (SELECT [fCountryName] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--								AND [fLocationCombination] = (SELECT [fLocationCombination] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--								AND [fVehicleName] = (SELECT [fVehicleCompareName] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--								AND [fTravelDates] = (SELECT [fTravelDates] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--							  )
--			SET @mainNumber = ( SELECT top 1 (fScanTotalPrice) FROM tTempTableLarge 
--								WHERE [fCountryName] = (SELECT [fCountryName] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--								AND [fLocationCombination] = @mainLocationCombo
--								AND [fVehicleName] = (SELECT [fVehicleCompareName] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--								AND [fTravelDates] = (SELECT [fTravelDates] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--							  )							  
--			SET @smallestPrice = (  SELECT TOP 1 fPrice FROM tTempTableList  	
--									WHERE [fLocationCombination] = @mainLocationCombo
--									AND [fVehicleCompareName] = (SELECT [fVehicleCompareName] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--									AND [fTravelDates] = (SELECT [fTravelDates] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--									ORDER BY [fPrice] ASC	
--								 )
							  		

--			--SET @averageprice = avg( SELECT fScanTotalPrice  FROM tTempTableLarge 
--			--					WHERE [fCountryName] = (SELECT [fCountryName] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--			--					AND [fLocationCombination] = @mainLocationCombo
--			--					AND [fVehicleCompareName] = (SELECT [fVehicleCompareName] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--			--					AND [fTravelDates] = (SELECT [fTravelDates] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--			--					UNION ALL
--			--					SELECT fScanTotalPrice  FROM tTempTableLarge 
--			--					WHERE [fCountryName] = (SELECT [fCountryName] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--			--					AND [fLocationCombination] = @mainLocationCombo
--			--					AND [fVehicleCompareName] = (SELECT [fVehicleCompareName] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--			--					AND [fTravelDates] = (SELECT [fTravelDates] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--			--					UNION ALL
--			--				  )
--			--	(select sum([fPrice]) FROM [tTempTableList] 
--			--	WHERE [fVehicleCompareName] = (SELECT [fVehicleCompareName] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--			--	AND [fTravelDates] = (SELECT [fTravelDates] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--			--	AND fScanID in ( SELECT fScanID FROM tTempTableLarge WHERE [fLocationCombination] = @mainLocationCombo)
--			--	AND NOT [fPrice] = 0)
--			--	/ 
--			--	(select count ([fPrice]) FROM [tTempTableList] 
--			--	WHERE [fVehicleCompareName] = (SELECT [fVehicleCompareName] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--			--	AND [fTravelDates] = (SELECT [fTravelDates] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--			--	AND fScanID in ( SELECT fScanID FROM tTempTableLarge WHERE [fLocationCombination] = @mainLocationCombo)
--			--	AND NOT [fPrice] = 0)

--		--END

--	-- get data values for that row
--	SET @scanID = (SELECT fScanID FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--	SET @numberOne = (SELECT fScanTotalPrice FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--	SET @numberTwo = (SELECT [fSecondPrice] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--	SET @numberThree = (SELECT [fThirdPrice] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--	SET @numberFour = (SELECT [fFourthPrice] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--	SET @numberFive = (SELECT [fFifthPrice] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--	SET @numberSix = (SELECT [fSixthPrice] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--	SET @numberSeven = (SELECT [fSeventhPrice] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
--	SET @numberEight = (SELECT [fEighthPrice] FROM tTempTableLarge WHERE fID = (@RowCount + 1))
	
--	--remove nulls
--	SET @numberOne = IsNull(@numberOne, 0)
--	SET @numberTwo = IsNull(@numberTwo, 0)
--	SET @numberThree = IsNull(@numberThree, 0)
--	SET @numberFour = IsNull(@numberFour, 0)
--	SET @numberFive = IsNull(@numberFive, 0)
--	SET @numberSix = IsNull(@numberSix, 0)
--	SET @numberSeven = IsNull(@numberSeven, 0)
--	SET @numberEight = IsNull(@numberEight, 0)

		

--	-- calculate percentages
--	SET @comparisonOne  = 
--		case
--			when NOT @numberOne = @mainNumber AND NOT @numberOne = 0
--				then CAST((CAST((@numberOne - @mainNumber) as decimal (18,4))/@mainNumber * 100) as decimal(18,2))
--			else 0
--		end
--	SET @comparisonTwo  = 
--		case
--			when NOT @numberTwo = 0
--				then CAST((CAST((@numberTwo - @mainNumber) as decimal (18,4))/@mainNumber * 100) as decimal(18,2))
--			else 0
--		end 
--	SET @comparisonThree = 
--		case
--			when NOT @numberThree = 0
--				then CAST((CAST((@numberThree - @mainNumber) as decimal (18,4))/@mainNumber * 100) as decimal(18,2))
--			else 0
--		end   
--	SET @comparisonFour = 
--		case
--			when NOT @numberFour = 0
--				then CAST((CAST((@numberFour - @mainNumber) as decimal (18,4))/@mainNumber * 100) as decimal(18,2))
--			else 0
--		end   
--	SET @comparisonFive = 
--		case
--			when NOT @numberFive = 0
--				then CAST((CAST((@numberFive - @mainNumber) as decimal (18,4))/@mainNumber * 100) as decimal(18,2))
--			else 0
--		end   
--	SET @comparisonSix = 
--		case
--			when NOT @numberSix = 0
--				then CAST((CAST((@numberSix - @mainNumber) as decimal (18,4))/@mainNumber * 100) as decimal(18,2))
--			else 0
--		end   
--	SET @comparisonSeven = 
--		case
--			when NOT @numberSeven = 0
--				then CAST((CAST((@numberSeven - @mainNumber) as decimal (18,4))/@mainNumber * 100) as decimal(18,2))
--			else 0
--		end   
--	SET @comparisonEight = 
--		case
--			when NOT @numberEight = 0
--				then CAST((CAST((@numberEight - @mainNumber) as decimal (18,4))/@mainNumber * 100) as decimal(18,2))
--			else 0
--		end  
	
--	SET @mainClass =
--		CASE	
--			WHEN @numberOne = @mainNumber
--				THEN CONCAT(@mainClass,' mainPrice')
--			ELSE @mainClass
--		END
--	SET @mainClass =
--		CASE	
--			WHEN @numberOne = 0			 
--				Then CONCAT(@mainClass,' noPrice')
--			WHEN @numberOne <= @smallestPrice 
--				THEN CONCAT(@mainClass,' cheapestPrice')
--			ELSE @mainClass
--		END
--	SET @SecondClass = 
--		CASE
--			WHEN @numberTwo = 0			 
--				Then CONCAT(@SecondClass,' noPrice')
--			WHEN @numberTwo <= @smallestPrice 
--				THEN CONCAT(@SecondClass,' cheapestPrice smallerPrice')
--			WHEN @numberTwo < @mainNumber 
--				THEN CONCAT(@SecondClass,' smallerPrice')
--			WHEN @numberTwo > @mainNumber
--				THEN CONCAT(@SecondClass, ' largerPrice')
--			ELSE @SecondClass
--		END
--	SET @ThirdClass = 
--		CASE
--			WHEN @numberThree = 0			 
--				Then CONCAT(@ThirdClass,' noPrice')
--			WHEN @numberThree <= @smallestPrice 
--				THEN CONCAT(@ThirdClass,' cheapestPrice smallerPrice')
--			WHEN @numberThree < @mainNumber 
--				THEN CONCAT(@ThirdClass,' smallerPrice')
--			WHEN @numberThree > @mainNumber
--				THEN CONCAT(@ThirdClass, ' largerPrice')
--			ELSE @ThirdClass
--		END
--	SET @FourthClass = 
--		CASE
--			WHEN @numberFour = 0			 
--				Then CONCAT(@FourthClass,' noPrice')
--			WHEN @numberFour <= @smallestPrice 
--				THEN CONCAT(@FourthClass,' cheapestPrice smallerPrice')
--			WHEN @numberFour < @mainNumber 
--				THEN CONCAT(@FourthClass,' smallerPrice')
--			WHEN @numberFour > @mainNumber
--				THEN CONCAT(@FourthClass, ' largerPrice')
--			ELSE @FourthClass
--		END
--	SET @FifthClass = 
--		CASE
--			WHEN @numberFive = 0			 
--				Then CONCAT(@FifthClass,' noPrice')
--			WHEN @numberFive <= @smallestPrice 
--				THEN CONCAT(@FifthClass,' cheapestPrice smallerPrice')
--			WHEN @numberFive < @mainNumber 
--				THEN CONCAT(@FifthClass,' smallerPrice')
--			WHEN @numberFive > @mainNumber
--				THEN CONCAT(@FifthClass, ' largerPrice')
--			ELSE @FifthClass
--		END
--	SET @SixthClass = 
--		CASE
--			WHEN @numberSix = 0			 
--				Then CONCAT(@SixthClass,' noPrice')
--			WHEN @numberSix <= @smallestPrice 
--				THEN CONCAT(@SixthClass,' cheapestPrice smallerPrice')
--			WHEN @numberSix < @mainNumber 
--				THEN CONCAT(@SixthClass,' smallerPrice')
--			WHEN @numberSix > @mainNumber
--				THEN CONCAT(@SixthClass, ' largerPrice')
--			ELSE @SixthClass
--		END
--	SET @SeventhClass = 
--		CASE
--			WHEN @numberSeven = 0			 
--				Then CONCAT(@SeventhClass,' noPrice')
--			WHEN @numberSeven <= @smallestPrice 
--				THEN CONCAT(@SeventhClass,' cheapestPrice smallerPrice')
--			WHEN @numberSeven < @mainNumber 
--				THEN CONCAT(@SeventhClass,' smallerPrice')
--			WHEN @numberSeven > @mainNumber
--				THEN CONCAT(@SeventhClass, ' largerPrice')
--			ELSE @SeventhClass
--		END
--	SET @EighthClass = 
--		CASE
--			WHEN @numberEight = 0			 
--				Then CONCAT(@EighthClass,' noPrice')
--			WHEN @numberEight <= @smallestPrice 
--				THEN CONCAT(@EighthClass,' cheapestPrice smallerPrice')
--			WHEN @numberEight < @mainNumber 
--				THEN CONCAT(@EighthClass,' smallerPrice')
--			WHEN @numberEight > @mainNumber
--				THEN CONCAT(@EighthClass, ' largerPrice')
--			ELSE @EighthClass
--		END

--	INSERT INTO @tTempTableClassesAndComparisons
--	VALUES (@scanID, @mainClass, @comparisonOne, @SecondClass, @comparisonTwo, @ThirdClass, @comparisonThree, @FourthClass, @comparisonFour, @FifthClass, @comparisonFive, @SixthClass, @comparisonSix, @SeventhClass, @comparisonSeven, @EighthClass, @comparisonEight )

--	SET @RowCount = @RowCount + 1
--END



---------------------------- THIS FUNCTION ISN'T BEING USED CURRENTLY------------------------------------------------------------------------------------------

return 

END




GO
/****** Object:  UserDefinedFunction [dbo].[RemoveIllegalCharacters]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sally Gamer
-- Create date: 18/05/15
-- Description:	Remove any illegal characters that can't be parsed by CSV imports (e.g. Word version of apostrophes etc).
-- =============================================
CREATE FUNCTION [dbo].[RemoveIllegalCharacters]
(
	@stringToConvert nvarchar(max)
)
RETURNS nvarchar(max)
AS
BEGIN
		
		SET @stringToConvert = REPLACE(@stringToConvert,'"','')
		SET @stringToConvert = REPLACE(@stringToConvert,CHAR(10),'\n ')
		SET @stringToConvert = REPLACE(@stringToConvert,CHAR(13),'\n ')
		SET @stringToConvert = REPLACE(@stringToConvert,'‘','\''')
		SET @stringToConvert = REPLACE(@stringToConvert,'’','\"')
		SET @stringToConvert = REPLACE(@stringToConvert,'“','\"')
		SET @stringToConvert = REPLACE(@stringToConvert,'”','\"')
		SET @stringToConvert = REPLACE(@stringToConvert,'”','\"')
		SET @stringToConvert = REPLACE(@stringToConvert,'?','\?')

	RETURN @stringToConvert

END



GO
/****** Object:  UserDefinedFunction [dbo].[replaceEmptyPrice]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <19/03/2015>
-- Description:	<check if price is $0, then replace with 'N/A'>
-- =============================================
CREATE FUNCTION [dbo].[replaceEmptyPrice]
(
	@strToCheck nvarchar(100)
)
RETURNS nvarchar(100)
AS
BEGIN
	DECLARE @returnString nvarchar(100)

	SET @returnString =
		CASE	
			WHEN (@strToCheck = '$0.00' OR @strToCheck = '0.00%') THEN 'N/A'
			ELSE @strToCheck
		END

	RETURN @returnString

END




GO
/****** Object:  UserDefinedFunction [dbo].[replaceEmptyPriceAsBlank]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <19/03/2015>
-- Description:	<check if price is $0, then replace with 'N/A'>
-- =============================================
CREATE FUNCTION [dbo].[replaceEmptyPriceAsBlank]
(
	@strToCheck nvarchar(100)
)
RETURNS nvarchar(100)
AS
BEGIN
	DECLARE @returnString nvarchar(100)

	SET @returnString =
		CASE	
			WHEN (@strToCheck = '$0.00' OR @strToCheck = '0.00%') THEN ''
			ELSE @strToCheck
		END

	RETURN @returnString

END




GO
/****** Object:  UserDefinedFunction [dbo].[replaceEmptyPriceAsBlank2]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Sally Gamer>
-- Create date: <31/08/2015>
-- Description:	<check if price is $0, then replace with 'N/A'>
-- =============================================
CREATE FUNCTION [dbo].[replaceEmptyPriceAsBlank2]
(
	@strToCheck nvarchar(100),
	@secondString nvarchar(100)
)
RETURNS nvarchar(100)
AS
BEGIN
	DECLARE @returnString nvarchar(100)

	SET @returnString =
		CASE	
			WHEN (@secondString IS NULL OR @secondString = '' OR @secondString = '$0.00')
			THEN ''
			ELSE 
				CASE
					WHEN (@strToCheck = '$0.00' OR @strToCheck = '0.00%') THEN 'N/A'
					ELSE @strToCheck
				END
		END

	RETURN @returnString

END




GO
/****** Object:  UserDefinedFunction [dbo].[replaceIllegalChar]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[replaceIllegalChar] (@String nvarchar(MAX)) 

RETURNS nvarchar(MAX)

AS BEGIN 

declare @Return nvarchar(MAX)

SET @Return = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@String, '%', '-'), '/', '-'), '\', '-'), '&', '-'), '^', '-'), '*', '-')






--SET @Return = 
--	CASE 
--		WHEN CHARINDEX('%', @Return) > 0
--		THEN REPLACE(@Return, '%', '-')
--		ELSE @Return
--	END
--SET @Return = 
--	CASE 
--		WHEN CHARINDEX('/', @Return) > 0
--		THEN REPLACE(@Return, '/', '-')
--		ELSE @Return
--	END
--SET @Return = 
--	CASE 
--		WHEN CHARINDEX('\', @Return) > 0
--		THEN REPLACE(@Return, '\', '-')
--		ELSE @Return
--	END
--SET @Return = 
--	CASE 
--		WHEN CHARINDEX('&', @Return) > 0
--		THEN REPLACE(@Return, '&', '-')
--		ELSE @Return
--	END
--SET @Return = 
--	CASE 
--		WHEN CHARINDEX('^', @Return) > 0
--		THEN REPLACE(@Return, '^', '-')
--		ELSE @Return
--	END
--SET @Return = 
--	CASE 
--		WHEN CHARINDEX('*', @Return) > 0
--		THEN REPLACE(@Return, '*', '-')
--		ELSE @Return
--	END
--SET @Return = 
--	CASE 
--		WHEN CHARINDEX('(', @Return) > 0
--		THEN REPLACE(@Return, '(', '-')
--	END
--SET @Return = 
--	CASE 
--		WHEN CHARINDEX(')', @Return) > 0
--		THEN REPLACE(@Return, ')', '-')
--	END

return @return 

end 



GO
/****** Object:  UserDefinedFunction [dbo].[split]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[split](
    @delimited NVARCHAR(MAX),
    @delimiter NVARCHAR(100)
) RETURNS @t TABLE (id INT IDENTITY(1,1), val NVARCHAR(MAX))
AS
BEGIN
    DECLARE @xml XML

	If NOT @delimited = ''
		Begin
			SET @xml = N'<t>' + REPLACE(@delimited,@delimiter,'</t><t>') + '</t>'
			INSERT INTO @t(val)
			SELECT  r.value('.','varchar(MAX)') as item
			FROM  @xml.nodes('/t') as records(r)
		END
    RETURN
END



GO
/****** Object:  Table [dbo].[tAdminPages]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAdminPages](
	[fldID] [int] IDENTITY(1,1) NOT NULL,
	[fldName] [nvarchar](150) NOT NULL,
	[fldURL] [nvarchar](150) NOT NULL,
	[fldParentID] [int] NOT NULL,
 CONSTRAINT [PK_tblPages] PRIMARY KEY CLUSTERED 
(
	[fldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tAdminUsers]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tAdminUsers](
	[fldID] [int] IDENTITY(1,1) NOT NULL,
	[fldUserName] [varchar](50) NOT NULL,
	[fldPWD] [varchar](50) NOT NULL,
	[fldName] [varchar](50) NULL,
	[fldEmail] [varchar](50) NULL,
	[fldAdmin] [bit] NOT NULL,
	[fldDept] [varchar](50) NULL,
	[fldDateCreated] [smalldatetime] NOT NULL,
	[fldLastUpdated] [smalldatetime] NOT NULL,
	[fldUpdatedBy] [varchar](50) NULL,
	[fldActive] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tAdminUsersPages]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAdminUsersPages](
	[fldID] [int] IDENTITY(1,1) NOT NULL,
	[fldUserID] [int] NOT NULL,
	[fldPageID] [int] NOT NULL,
 CONSTRAINT [PK_tblUsersPages] PRIMARY KEY CLUSTERED 
(
	[fldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tDataExchangeRate]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDataExchangeRate](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fExchangeRateDate] [smalldatetime] NOT NULL,
	[fExchangeRateValue] [decimal](16, 8) NOT NULL,
	[fExchangeRateCurrencyCode] [nvarchar](10) NOT NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tDataExchangeRate] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tDataScan]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDataScan](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fScanDate] [smalldatetime] NOT NULL,
	[fScanURL] [nvarchar](max) NOT NULL,
	[fScanTravelCountry] [nvarchar](100) NULL,
	[fScanPickupLocation] [nvarchar](100) NOT NULL,
	[fScanReturnLocation] [nvarchar](100) NOT NULL,
	[fScanPickupDate] [smalldatetime] NOT NULL,
	[fScanReturnDate] [smalldatetime] NOT NULL,
	[fScanLicenceCountry] [nvarchar](100) NULL,
	[fScanBrandName] [nvarchar](100) NULL,
	[fScanVehicleName] [nvarchar](200) NOT NULL,
	[fScanTotalPrice] [decimal](8, 2) NOT NULL,
	[fScanCurrency] [nvarchar](5) NOT NULL,
	[fScanSourceURL] [nvarchar](max) NULL,
	[fActive] [int] NULL,
 CONSTRAINT [PK_tDataScan] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tDataScan2]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDataScan2](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fScanDate] [smalldatetime] NOT NULL,
	[fScanURL] [nvarchar](max) NOT NULL,
	[fScanTravelCountry] [nvarchar](100) NULL,
	[fScanPickupLocation] [nvarchar](100) NOT NULL,
	[fScanReturnLocation] [nvarchar](100) NOT NULL,
	[fScanPickupDate] [smalldatetime] NOT NULL,
	[fScanReturnDate] [smalldatetime] NOT NULL,
	[fScanLicenceCountry] [nvarchar](100) NULL,
	[fScanBrandName] [nvarchar](100) NULL,
	[fScanVehicleName] [nvarchar](200) NOT NULL,
	[fScanTotalPrice] [decimal](8, 2) NOT NULL,
	[fScanCurrency] [nvarchar](5) NOT NULL,
	[fScanSourceURL] [nvarchar](max) NULL,
	[fActive] [int] NULL,
 CONSTRAINT [PK_tDataScan2] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tDataScanClean]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDataScanClean](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fScanID] [int] NOT NULL,
	[fScanDate] [date] NOT NULL,
	[fScanURL] [nvarchar](max) NULL,
	[fScanTravelCountryID] [int] NOT NULL,
	[fScanPickupLocationID] [int] NOT NULL,
	[fScanReturnLocationID] [int] NOT NULL,
	[fScanPickupDate] [date] NOT NULL,
	[fScanReturnDate] [date] NOT NULL,
	[fScanLicenceCountryID] [int] NOT NULL,
	[fScanBrandID] [int] NOT NULL,
	[fScanVehicleID] [int] NOT NULL,
	[fScanTotalPrice] [decimal](8, 2) NOT NULL,
	[fScanCurrencyID] [int] NOT NULL,
	[fActive] [int] NOT NULL,
	[fScanCreateDate] [date] NULL,
 CONSTRAINT [PK_tDataScanClean2] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tDataScanClean3]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDataScanClean3](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fScanID] [int] NOT NULL,
	[fScanDate] [smalldatetime] NOT NULL,
	[fScanURL] [nvarchar](max) NOT NULL,
	[fScanTravelCountryID] [int] NOT NULL,
	[fScanPickupLocationID] [int] NOT NULL,
	[fScanReturnLocationID] [int] NOT NULL,
	[fScanPickupDate] [smalldatetime] NOT NULL,
	[fScanReturnDate] [smalldatetime] NOT NULL,
	[fScanLicenceCountryID] [int] NOT NULL,
	[fScanBrandID] [int] NOT NULL,
	[fScanVehicleID] [int] NOT NULL,
	[fScanTotalPrice] [decimal](8, 2) NOT NULL,
	[fScanCurrencyID] [int] NOT NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tDataScanClean] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefBranch]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefBranch](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fBranchBrandID] [int] NOT NULL,
	[fBranchLocationID] [int] NOT NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefBranch] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefBrand]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefBrand](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fBrandName] [nvarchar](50) NOT NULL,
	[fBrandAlias] [nvarchar](max) NULL,
	[fBrandPriority] [int] NULL,
	[fBrandOrderPriceIncrease] [int] NULL,
	[fBrandOrderSnapshot] [int] NULL,
	[fBrandIsApolloFamily] [int] NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefBrand] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefCountry]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefCountry](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fCountryName] [nvarchar](50) NOT NULL,
	[fCountryCode] [nvarchar](10) NOT NULL,
	[fCurrencyCode] [nvarchar](10) NOT NULL,
	[fCountryAlias] [nvarchar](max) NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefCountry] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefCurrency]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefCurrency](
	[fID] [int] NOT NULL,
	[fCurrencyName] [nvarchar](100) NOT NULL,
	[fCurrencyCode] [nvarchar](3) NOT NULL,
	[fCurrencyAlias] [nvarchar](max) NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_fRefCurrency] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefDriversLicenceCodes]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefDriversLicenceCodes](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fWebsiteID] [int] NOT NULL,
	[fTravelCountryID] [int] NOT NULL,
	[fIntLicenceCountryID] [nvarchar](50) NOT NULL,
	[fDomLicenceCountryID] [int] NOT NULL,
 CONSTRAINT [PK_tRefDriversLicenceCodes] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefExceptionCheck]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefExceptionCheck](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fDateChecked] [smalldatetime] NOT NULL,
	[fNumberExceptions] [int] NOT NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefExceptionCheck] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefFirstDate]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefFirstDate](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fFirstDate] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tRefFirstDate] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefLocation]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefLocation](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fCountryID] [int] NOT NULL,
	[fLocationName] [nvarchar](max) NOT NULL,
	[fLocationCode] [nvarchar](10) NULL,
	[fLocationAlias] [nvarchar](max) NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefLocation] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefPriceException]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefPriceException](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fPriceExceptionCountryID] [int] NULL,
	[fPriceExceptionOneWay] [int] NOT NULL,
	[fPriceExceptionDateStart] [smalldatetime] NOT NULL,
	[fPriceExceptionDateEnd] [smalldatetime] NOT NULL,
	[fPriceExceptionPriceChange] [decimal](6, 2) NULL,
	[fPriceExceptionPercentage] [decimal](6, 2) NULL,
	[fPriceExceptionCurrencyID] [int] NOT NULL,
	[fPriceExceptionNote] [nvarchar](max) NOT NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefPriceException] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefPriceExceptionBrands]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefPriceExceptionBrands](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fExceptionID] [int] NOT NULL,
	[fBrandID] [int] NOT NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefPriceExceptionBrands] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefPriceExceptionLocations]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefPriceExceptionLocations](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fExceptionID] [int] NOT NULL,
	[fLocationID] [int] NOT NULL,
	[fPickupOrDropoff] [int] NOT NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefPriceExceptionLocations] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefQuickReport]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefQuickReport](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fQuickReportUserID] [int] NOT NULL,
	[fQuickReportName] [nvarchar](200) NOT NULL,
	[fQuickReportType] [int] NOT NULL,
	[fQuickReportFinWeek] [nvarchar](50) NULL,
	[fQuickReportTravelDates] [nvarchar](max) NULL,
	[fQuickReportCountryID] [int] NULL,
	[fQuickReportBrandID] [int] NULL,
	[fQuickReportLocationCombo] [nvarchar](50) NULL,
	[fQuickReportLicenceCountry] [int] NULL,
	[fQuickReportScanURLs] [nvarchar](200) NULL,
	[fQuickReportPriceExceptions] [int] NULL,
	[fQuickReportRateOption] [int] NULL,
	[fQuickReportApolloFamilyOnly] [int] NULL,
	[fQuickReportPercentOrPrice] [int] NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefQuickReportSettings] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefVehicle]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefVehicle](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fVehicleName] [nvarchar](100) NOT NULL,
	[fVehicleBrandID] [int] NOT NULL,
	[fVehicleCountryID] [int] NULL,
	[fVehicleTypeID] [int] NOT NULL,
	[fVehicleDriveTypeID] [int] NOT NULL,
	[fVehicleCategoryID] [int] NULL,
	[fVehicleBerthAdults] [int] NOT NULL,
	[fVehicleBerthChildren] [int] NULL,
	[fVehicleAlias] [nvarchar](max) NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefVehicle] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefVehicleCategory]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefVehicleCategory](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fVehicleCategoryName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tRefVehicleCategory] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefVehicleDriveType]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefVehicleDriveType](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fVehicleDriveTypeName] [nvarchar](20) NOT NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefVehicleDriveType] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefVehicleEquivalent]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefVehicleEquivalent](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fVehicleOneID] [int] NOT NULL,
	[fVehicleTwoID] [int] NOT NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefVehicleEquivalent] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefVehicleType]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefVehicleType](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fVehicleTypeName] [nvarchar](20) NOT NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefVehicleType] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRefWebsite]    Script Date: 2/25/2016 12:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRefWebsite](
	[fID] [int] IDENTITY(1,1) NOT NULL,
	[fWebsiteName] [nvarchar](100) NOT NULL,
	[fWebsiteDomain] [nvarchar](max) NOT NULL,
	[fWebsiteAlias] [nvarchar](max) NULL,
	[fWebsiteIncludesFees] [int] NOT NULL,
	[fActive] [int] NOT NULL,
 CONSTRAINT [PK_tRefWebsite] PRIMARY KEY CLUSTERED 
(
	[fID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[tAdminUsers] ADD  CONSTRAINT [DF_tblUsers_fldMakeDate]  DEFAULT (getdate()) FOR [fldDateCreated]
GO
ALTER TABLE [dbo].[tAdminUsers] ADD  CONSTRAINT [DF_tblUsers_fldLastUpdated]  DEFAULT (getdate()) FOR [fldLastUpdated]
GO
ALTER TABLE [dbo].[tAdminUsers] ADD  CONSTRAINT [DF_tblUsers_fldTalvorAdmin]  DEFAULT ((0)) FOR [fldActive]
GO
ALTER TABLE [dbo].[tDataExchangeRate] ADD  CONSTRAINT [DF_tDataExchangeRate_fExchangeRateDate]  DEFAULT (getdate()) FOR [fExchangeRateDate]
GO
ALTER TABLE [dbo].[tDataExchangeRate] ADD  CONSTRAINT [DF_tDataExchangeRate_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tDataScan] ADD  CONSTRAINT [DF_tDataScan_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tDataScan2] ADD  CONSTRAINT [DF_tDataScan_fActive2]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tDataScanClean] ADD  CONSTRAINT [DF_tDataScanClean_fActive_1]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tDataScanClean] ADD  CONSTRAINT [DF_tDataScanClean_fScanCreateDate]  DEFAULT (getdate()) FOR [fScanCreateDate]
GO
ALTER TABLE [dbo].[tDataScanClean3] ADD  CONSTRAINT [DF_tDataScanClean_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefBranch] ADD  CONSTRAINT [DF_tRefBranch_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefBrand] ADD  CONSTRAINT [DF_tRefBrand_fBrandOrderSnapshot]  DEFAULT ((10000)) FOR [fBrandOrderSnapshot]
GO
ALTER TABLE [dbo].[tRefBrand] ADD  CONSTRAINT [DF_tRefBrand_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefCountry] ADD  CONSTRAINT [DF_tRefCountry_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefCurrency] ADD  CONSTRAINT [DF_fRefCurrency_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefExceptionCheck] ADD  CONSTRAINT [DF_tRefExceptionCheck_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefLocation] ADD  CONSTRAINT [DF_tRefLocation_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefPriceException] ADD  CONSTRAINT [DF_tRefPriceException_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefPriceExceptionBrands] ADD  CONSTRAINT [DF_tRefPriceExceptionBrands_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefPriceExceptionLocations] ADD  CONSTRAINT [DF_tRefPriceExceptionLocations_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefVehicle] ADD  CONSTRAINT [DF_tRefVehicle_fVehicleTypeID]  DEFAULT ((1)) FOR [fVehicleTypeID]
GO
ALTER TABLE [dbo].[tRefVehicle] ADD  CONSTRAINT [DF_tRefVehicle_fVehicleDriveTypeID]  DEFAULT ((1)) FOR [fVehicleDriveTypeID]
GO
ALTER TABLE [dbo].[tRefVehicle] ADD  CONSTRAINT [DF_tRefVehicle_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefVehicleDriveType] ADD  CONSTRAINT [DF_tRefVehicleDriveType_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefVehicleEquivalent] ADD  CONSTRAINT [DF_tRefVehicleEquivalent_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefVehicleType] ADD  CONSTRAINT [DF_tRefVehicleType_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefWebsite] ADD  CONSTRAINT [DF_tRefWebsite_fActive]  DEFAULT ((1)) FOR [fActive]
GO
ALTER TABLE [dbo].[tRefBranch]  WITH CHECK ADD  CONSTRAINT [FK_tRefBranch_tRefBrand] FOREIGN KEY([fBranchBrandID])
REFERENCES [dbo].[tRefBrand] ([fID])
GO
ALTER TABLE [dbo].[tRefBranch] CHECK CONSTRAINT [FK_tRefBranch_tRefBrand]
GO
ALTER TABLE [dbo].[tRefBranch]  WITH CHECK ADD  CONSTRAINT [FK_tRefBranch_tRefLocation] FOREIGN KEY([fBranchLocationID])
REFERENCES [dbo].[tRefLocation] ([fID])
GO
ALTER TABLE [dbo].[tRefBranch] CHECK CONSTRAINT [FK_tRefBranch_tRefLocation]
GO
ALTER TABLE [dbo].[tRefLocation]  WITH CHECK ADD  CONSTRAINT [FK_tRefLocation_tRefCountry] FOREIGN KEY([fCountryID])
REFERENCES [dbo].[tRefCountry] ([fID])
GO
ALTER TABLE [dbo].[tRefLocation] CHECK CONSTRAINT [FK_tRefLocation_tRefCountry]
GO
ALTER TABLE [dbo].[tRefVehicle]  WITH NOCHECK ADD  CONSTRAINT [FK_tRefVehicle_tRefBrand] FOREIGN KEY([fVehicleBrandID])
REFERENCES [dbo].[tRefBrand] ([fID])
GO
ALTER TABLE [dbo].[tRefVehicle] CHECK CONSTRAINT [FK_tRefVehicle_tRefBrand]
GO
ALTER TABLE [dbo].[tRefVehicle]  WITH NOCHECK ADD  CONSTRAINT [FK_tRefVehicle_tRefVehicleType] FOREIGN KEY([fVehicleTypeID])
REFERENCES [dbo].[tRefVehicleType] ([fID])
GO
ALTER TABLE [dbo].[tRefVehicle] CHECK CONSTRAINT [FK_tRefVehicle_tRefVehicleType]
GO
ALTER TABLE [dbo].[tRefVehicleEquivalent]  WITH CHECK ADD  CONSTRAINT [FK_tRefVehicleEquivalent_tRefVehicle] FOREIGN KEY([fVehicleOneID])
REFERENCES [dbo].[tRefVehicle] ([fID])
GO
ALTER TABLE [dbo].[tRefVehicleEquivalent] CHECK CONSTRAINT [FK_tRefVehicleEquivalent_tRefVehicle]
GO
USE [master]
GO
ALTER DATABASE [Comparison] SET  READ_WRITE 
GO
