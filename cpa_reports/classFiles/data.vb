Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Data.SqlTypes
Imports System.IO
Imports System.Xml

Public Class data
    Public Shared sqlCon As SqlConnection = New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("SqlConnection"))
    Public Shared sqlConMainServer As SqlConnection = New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("SqlConnectionMainServer"))
    Public Shared sqlCom As SqlCommand
    Public Shared sqlDR As SqlDataReader
    Public Shared sqlDS As DataSet
    Public Shared sqlDA As SqlDataAdapter

    Public Shared Current As New data

    Public Shared Sub deleteData(ByVal badID As Integer)
        sqlCom = New SqlCommand("deleteData", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@badID", SqlDbType.Int).Value = badID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub

    Public Function getData(ByVal DataSetDateStart As String, ByVal TravelDateRanges As String, _
                            ByVal CountryID As Integer, ByVal BrandID As Integer, ByVal PickupReturnLocationComboID As String, _
                            ByVal VehicleID As Integer, ByVal vehicleTypeID As Integer, ByVal vehicleBerthID As Integer, ByVal LicenceCountryID As Integer, ByVal ScanURLs As String, ByVal PriceExceptions As Integer _
                            ) As DataSet
        sqlCom = New SqlCommand("getScanDataCleanByFilters", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420
        sqlCom.Parameters.Add("@DataSetDateStart", SqlDbType.NVarChar).Value = DataSetDateStart
        sqlCom.Parameters.Add("@TravelDateRanges", SqlDbType.NVarChar).Value = TravelDateRanges
        sqlCom.Parameters.Add("@CountryID", SqlDbType.Int).Value = CountryID
        sqlCom.Parameters.Add("@BrandID", SqlDbType.Int).Value = BrandID
        sqlCom.Parameters.Add("@PickupReturnLocationComboID", SqlDbType.NVarChar).Value = PickupReturnLocationComboID
        sqlCom.Parameters.Add("@VehicleID", SqlDbType.Int).Value = VehicleID
        sqlCom.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID
        sqlCom.Parameters.Add("@vehicleBerthID", SqlDbType.Int).Value = vehicleBerthID
        sqlCom.Parameters.Add("@LicenceCountryID", SqlDbType.Int).Value = LicenceCountryID
        sqlCom.Parameters.Add("@ScanURLs", SqlDbType.NVarChar).Value = ScanURLs
        sqlCom.Parameters.Add("@PriceExceptions", SqlDbType.Int).Value = PriceExceptions

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "Data")

        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function


    Public Function getDataVehicleCompare(ByVal DataSetDateStart As String, ByVal TravelDateRanges As String, ByVal CountryID As Integer, ByVal BrandID As Integer, ByVal PickupReturnLocationComboID As String, _
                                            ByVal VehicleID As String, ByVal vehicleTypeID As Integer, ByVal vehicleBerthID As Integer, ByVal LicenceCountryID As Integer, ByVal ScanURLs As String, ByVal PriceExceptions As Integer) As DataSet
        Dim ds As New DataSet()

        Try
            Using connection As New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("SqlConnection"))
                Using sqlCommand As New SqlCommand("getScanDataCleanByFiltersVehicleCompare", connection)
                    Using da = New SqlDataAdapter(sqlCommand)
                        sqlCommand.CommandType = CommandType.StoredProcedure
                        sqlCommand.CommandTimeout = 420
                        sqlCommand.Parameters.Add("@DataSetDateStart", SqlDbType.NVarChar).Value = DataSetDateStart
                        sqlCommand.Parameters.Add("@TravelDateRanges", SqlDbType.NVarChar).Value = TravelDateRanges
                        sqlCommand.Parameters.Add("@CountryID", SqlDbType.Int).Value = CountryID
                        sqlCommand.Parameters.Add("@BrandID", SqlDbType.Int).Value = BrandID
                        sqlCommand.Parameters.Add("@PickupReturnLocationComboID", SqlDbType.NVarChar).Value = PickupReturnLocationComboID
                        sqlCommand.Parameters.Add("@VehicleID", SqlDbType.NVarChar).Value = VehicleID
                        sqlCommand.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID
                        sqlCommand.Parameters.Add("@vehicleBerthID", SqlDbType.Int).Value = vehicleBerthID
                        sqlCommand.Parameters.Add("@LicenceCountryID", SqlDbType.Int).Value = LicenceCountryID
                        sqlCommand.Parameters.Add("@ScanURLs", SqlDbType.NVarChar).Value = ScanURLs
                        sqlCommand.Parameters.Add("@PriceExceptions", SqlDbType.Int).Value = PriceExceptions

                        connection.Open()

                        da.Fill(ds, "Data")
                    End Using
                End Using
            End Using
        Catch ex As Exception
            '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        End Try

        Return ds
    End Function


    'Public Function getDataVehicleCompareOLD(ByVal DataSetDateStart As String, ByVal TravelDateRanges As String, ByVal CountryID As Integer, ByVal BrandID As Integer, ByVal PickupReturnLocationComboID As String, _
    '                                        ByVal VehicleID As String, ByVal vehicleTypeID As Integer, ByVal vehicleBerthID As Integer, ByVal LicenceCountryID As Integer, ByVal ScanURLs As String, ByVal PriceExceptions As Integer) As DataSet
    '    sqlCom = New SqlCommand("getScanDataCleanByFiltersVehicleCompare", sqlCon)
    '    sqlCom.CommandType = CommandType.StoredProcedure
    '    sqlCom.CommandTimeout = 420
    '    sqlCom.Parameters.Add("@DataSetDateStart", SqlDbType.NVarChar).Value = DataSetDateStart
    '    sqlCom.Parameters.Add("@TravelDateRanges", SqlDbType.NVarChar).Value = TravelDateRanges
    '    sqlCom.Parameters.Add("@CountryID", SqlDbType.Int).Value = CountryID
    '    sqlCom.Parameters.Add("@BrandID", SqlDbType.Int).Value = BrandID
    '    sqlCom.Parameters.Add("@PickupReturnLocationComboID", SqlDbType.NVarChar).Value = PickupReturnLocationComboID
    '    sqlCom.Parameters.Add("@VehicleID", SqlDbType.NVarChar).Value = VehicleID
    '    sqlCom.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID
    '    sqlCom.Parameters.Add("@vehicleBerthID", SqlDbType.Int).Value = vehicleBerthID
    '    sqlCom.Parameters.Add("@LicenceCountryID", SqlDbType.Int).Value = LicenceCountryID
    '    sqlCom.Parameters.Add("@ScanURLs", SqlDbType.NVarChar).Value = ScanURLs
    '    sqlCom.Parameters.Add("@PriceExceptions", SqlDbType.Int).Value = PriceExceptions

    '    sqlDS = New DataSet
    '    'Try
    '    If sqlCon.State = ConnectionState.Closed Then
    '        sqlCon.Open()
    '    End If
    '    sqlDA = New SqlDataAdapter
    '    sqlDA.SelectCommand = sqlCom
    '    sqlDA.Fill(sqlDS, "Data")

    '    Return sqlDS
    '    'Catch ex As Exception
    '    '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
    '    '    Return sqlDS
    '    'End Try
    '    sqlCon.Close()
    '    sqlCom.Dispose()
    '    sqlDA.Dispose()
    '    sqlDS.Dispose()
    'End Function

    Public Function getDataVehicleCompareSnapshot(ByVal quickReportNumber As Integer, ByVal DataSetDateStart As String, ByVal TravelDateRanges As String, ByVal CountryID As Integer, ByVal BrandID As Integer, ByVal PickupReturnLocationComboID As String, _
                                                  ByVal LicenceCountryID As Integer, ByVal ScanURLs As String, ByVal PriceExceptions As Integer, ByVal rateOption As Integer, ByVal selectApolloFamilyVehicles As Integer, ByVal showPercentOrPrice As Integer) As DataSet
        Dim ds As New DataSet()

        Try
            Using connection As New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("SqlConnection"))
                Using sqlCommand As New SqlCommand("getScanDataCleanByFiltersVehicleCompareSnapshot", connection)
                    Using da = New SqlDataAdapter(sqlCommand)
                        sqlCommand.CommandType = CommandType.StoredProcedure
                        sqlCommand.CommandTimeout = 420
                        sqlCommand.Parameters.Add("@quickReportNumber", SqlDbType.Int).Value = quickReportNumber
                        sqlCommand.Parameters.Add("@DataSetDateStart", SqlDbType.NVarChar).Value = DataSetDateStart
                        sqlCommand.Parameters.Add("@TravelDateRanges", SqlDbType.NVarChar).Value = TravelDateRanges
                        sqlCommand.Parameters.Add("@CountryID", SqlDbType.Int).Value = CountryID
                        sqlCommand.Parameters.Add("@BrandID", SqlDbType.Int).Value = BrandID
                        sqlCommand.Parameters.Add("@PickupReturnLocationComboID", SqlDbType.NVarChar).Value = PickupReturnLocationComboID
                        sqlCommand.Parameters.Add("@LicenceCountryID", SqlDbType.Int).Value = LicenceCountryID
                        sqlCommand.Parameters.Add("@ScanURLs", SqlDbType.NVarChar).Value = ScanURLs
                        sqlCommand.Parameters.Add("@PriceExceptions", SqlDbType.Int).Value = PriceExceptions
                        sqlCommand.Parameters.Add("@rateOption", SqlDbType.Int).Value = rateOption
                        sqlCommand.Parameters.Add("@selectApolloFamilyVehicles", SqlDbType.Int).Value = selectApolloFamilyVehicles
                        sqlCommand.Parameters.Add("@showPercentOrPrice", SqlDbType.Int).Value = showPercentOrPrice

                        connection.Open()

                        da.Fill(ds)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        End Try

        Return ds
    End Function


    'Public Function getDataVehicleCompareSnapshotOLD(ByVal quickReportNumber As Integer, ByVal DataSetDateStart As String, ByVal TravelDateRanges As String, ByVal CountryID As Integer, ByVal BrandID As Integer, ByVal PickupReturnLocationComboID As String, _
    '                                              ByVal LicenceCountryID As Integer, ByVal ScanURLs As String, ByVal PriceExceptions As Integer, ByVal rateOption As Integer, ByVal selectApolloFamilyVehicles As Integer, ByVal showPercentOrPrice As Integer) As DataSet
    '    sqlCom = New SqlCommand("getScanDataCleanByFiltersVehicleCompareSnapshot", sqlCon)
    '    sqlCom.CommandType = CommandType.StoredProcedure
    '    sqlCom.CommandTimeout = 420
    '    sqlCom.Parameters.Add("@quickReportNumber", SqlDbType.Int).Value = quickReportNumber
    '    sqlCom.Parameters.Add("@DataSetDateStart", SqlDbType.NVarChar).Value = DataSetDateStart
    '    sqlCom.Parameters.Add("@TravelDateRanges", SqlDbType.NVarChar).Value = TravelDateRanges
    '    sqlCom.Parameters.Add("@CountryID", SqlDbType.Int).Value = CountryID
    '    sqlCom.Parameters.Add("@BrandID", SqlDbType.Int).Value = BrandID
    '    sqlCom.Parameters.Add("@PickupReturnLocationComboID", SqlDbType.NVarChar).Value = PickupReturnLocationComboID
    '    sqlCom.Parameters.Add("@LicenceCountryID", SqlDbType.Int).Value = LicenceCountryID
    '    sqlCom.Parameters.Add("@ScanURLs", SqlDbType.NVarChar).Value = ScanURLs
    '    sqlCom.Parameters.Add("@PriceExceptions", SqlDbType.Int).Value = PriceExceptions
    '    sqlCom.Parameters.Add("@rateOption", SqlDbType.Int).Value = rateOption
    '    sqlCom.Parameters.Add("@selectApolloFamilyVehicles", SqlDbType.Int).Value = selectApolloFamilyVehicles
    '    sqlCom.Parameters.Add("@showPercentOrPrice", SqlDbType.Int).Value = showPercentOrPrice

    '    sqlDS = New DataSet
    '    'Try
    '    If sqlCon.State = ConnectionState.Closed Then
    '        sqlCon.Open()
    '    End If
    '    sqlDA = New SqlDataAdapter
    '    sqlDA.SelectCommand = sqlCom
    '    sqlDA.Fill(sqlDS)

    '    Return sqlDS
    '    'Catch ex As Exception
    '    '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
    '    '    Return sqlDS
    '    'End Try
    '    sqlCon.Close()
    '    sqlCom.Dispose()
    '    sqlDA.Dispose()
    '    sqlDS.Dispose()

    'End Function


    Public Function getDataVehicleComparePriceChange(ByVal DataSetDateStart As String, ByVal PickUpDateRangeStart As String, ByVal PickUpDateRangeEnd As String, ByVal ReturnDateRangeStart As String, ByVal ReturnDateRangeEnd As String, _
                            ByVal CountryID As Integer, ByVal BrandID As Integer, ByVal PickupLocationID As Integer, ByVal ReturnLocationID As Integer, _
                            ByVal VehicleID As Integer, ByVal vehicleTypeID As Integer, ByVal vehicleBerthID As Integer, ByVal LicenceCountryID As Integer, ByVal ScanURL As Integer, ByVal PriceExceptions As Integer _
                            ) As DataSet
        sqlCom = New SqlCommand("getScanDataCleanByFiltersVehicleComparePriceIncrease", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420
        sqlCom.Parameters.Add("@DataSetDateStart", SqlDbType.NVarChar).Value = DataSetDateStart
        'sqlCom.Parameters.Add("@PickUpDateRangeStart", SqlDbType.NVarChar).Value = PickUpDateRangeStart
        'sqlCom.Parameters.Add("@PickUpDateRangeEnd", SqlDbType.NVarChar).Value = PickUpDateRangeEnd
        'sqlCom.Parameters.Add("@ReturnDateRangeStart", SqlDbType.NVarChar).Value = ReturnDateRangeStart
        'sqlCom.Parameters.Add("@ReturnDateRangeEnd", SqlDbType.NVarChar).Value = ReturnDateRangeEnd
        sqlCom.Parameters.Add("@CountryID", SqlDbType.Int).Value = CountryID
        sqlCom.Parameters.Add("@BrandID", SqlDbType.Int).Value = BrandID
        sqlCom.Parameters.Add("@PickupLocationID", SqlDbType.Int).Value = PickupLocationID
        sqlCom.Parameters.Add("@ReturnLocationID", SqlDbType.Int).Value = ReturnLocationID
        sqlCom.Parameters.Add("@VehicleID", SqlDbType.Int).Value = VehicleID
        sqlCom.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID
        sqlCom.Parameters.Add("@vehicleBerthID", SqlDbType.Int).Value = vehicleBerthID
        sqlCom.Parameters.Add("@LicenceCountryID", SqlDbType.Int).Value = LicenceCountryID
        sqlCom.Parameters.Add("@ScanURL", SqlDbType.Int).Value = ScanURL
        sqlCom.Parameters.Add("@PriceExceptions", SqlDbType.Int).Value = PriceExceptions

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "Data")

        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Function getDataVehicleComparePriceChangeSmallest(ByVal DataSetDateStart As String, ByVal PickUpDateRangeStart As String, ByVal PickUpDateRangeEnd As String, ByVal ReturnDateRangeStart As String, ByVal ReturnDateRangeEnd As String, _
                            ByVal CountryID As Integer, ByVal BrandID As Integer, ByVal PickupLocationID As Integer, ByVal ReturnLocationID As Integer, _
                            ByVal VehicleID As Integer, ByVal vehicleTypeID As Integer, ByVal vehicleBerthID As Integer, ByVal LicenceCountryID As Integer, ByVal ScanURL As Integer, ByVal PriceExceptions As Integer _
                            ) As DataSet
        sqlCom = New SqlCommand("getScanDataCleanByFiltersVehicleComparePriceIncreaseSmallestPriceOnly", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420
        sqlCom.Parameters.Add("@DataSetDateStart", SqlDbType.NVarChar).Value = DataSetDateStart
        'sqlCom.Parameters.Add("@PickUpDateRangeStart", SqlDbType.NVarChar).Value = PickUpDateRangeStart
        'sqlCom.Parameters.Add("@PickUpDateRangeEnd", SqlDbType.NVarChar).Value = PickUpDateRangeEnd
        'sqlCom.Parameters.Add("@ReturnDateRangeStart", SqlDbType.NVarChar).Value = ReturnDateRangeStart
        'sqlCom.Parameters.Add("@ReturnDateRangeEnd", SqlDbType.NVarChar).Value = ReturnDateRangeEnd
        sqlCom.Parameters.Add("@CountryID", SqlDbType.Int).Value = CountryID
        sqlCom.Parameters.Add("@BrandID", SqlDbType.Int).Value = BrandID
        sqlCom.Parameters.Add("@PickupLocationID", SqlDbType.Int).Value = PickupLocationID
        sqlCom.Parameters.Add("@ReturnLocationID", SqlDbType.Int).Value = ReturnLocationID
        sqlCom.Parameters.Add("@VehicleID", SqlDbType.Int).Value = VehicleID
        sqlCom.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID
        sqlCom.Parameters.Add("@vehicleBerthID", SqlDbType.Int).Value = vehicleBerthID
        sqlCom.Parameters.Add("@LicenceCountryID", SqlDbType.Int).Value = LicenceCountryID
        sqlCom.Parameters.Add("@ScanURL", SqlDbType.Int).Value = ScanURL
        sqlCom.Parameters.Add("@PriceExceptions", SqlDbType.Int).Value = PriceExceptions

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "Data")

        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Function getDataOverTime(ByVal DataSetDateStart As String, ByVal PickUpDateRangeStart As String, ByVal CountryID As Integer, ByVal BrandID As Integer, ByVal PickupLocationID As Integer, ByVal ReturnLocationID As Integer, _
                            ByVal VehicleID As Integer, ByVal vehicleTypeID As Integer, ByVal vehicleBerthID As Integer, ByVal LicenceCountryID As Integer, ByVal ScanURL As Integer, ByVal PriceExceptions As Integer, _
                            ByVal addComparisonVehicle As Integer) As DataSet
        sqlCom = New SqlCommand("getScanDataCleanChartVehiclePriceOverTime", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420
        sqlCom.Parameters.Add("@DataSetDateStart", SqlDbType.NVarChar).Value = DataSetDateStart
        sqlCom.Parameters.Add("@PickUpDateRangeStart", SqlDbType.NVarChar).Value = PickUpDateRangeStart
        sqlCom.Parameters.Add("@CountryID", SqlDbType.Int).Value = CountryID
        sqlCom.Parameters.Add("@BrandID", SqlDbType.Int).Value = BrandID
        sqlCom.Parameters.Add("@PickupLocationID", SqlDbType.Int).Value = PickupLocationID
        sqlCom.Parameters.Add("@ReturnLocationID", SqlDbType.Int).Value = ReturnLocationID
        sqlCom.Parameters.Add("@VehicleID", SqlDbType.Int).Value = VehicleID
        sqlCom.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID
        sqlCom.Parameters.Add("@vehicleBerthID", SqlDbType.Int).Value = vehicleBerthID
        sqlCom.Parameters.Add("@LicenceCountryID", SqlDbType.Int).Value = LicenceCountryID
        sqlCom.Parameters.Add("@ScanURL", SqlDbType.Int).Value = ScanURL
        sqlCom.Parameters.Add("@PriceExceptions", SqlDbType.Int).Value = PriceExceptions
        sqlCom.Parameters.Add("@addComparisonVehicle", SqlDbType.Int).Value = addComparisonVehicle

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS)
        sqlDS.Tables(0).TableName = "Data"
        sqlDS.Tables(1).TableName = "Min"
        sqlDS.Tables(2).TableName = "Max"

        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Function getDataOverTimeAcrossDataSets(ByVal DataSetDateStart As String, ByVal TravelDateRanges As String, ByVal CountryID As Integer, ByVal BrandID As Integer, ByVal PickupReturnLocationComboID As String, _
                                                ByVal VehicleID As String, ByVal vehicleTypeID As Integer, ByVal vehicleBerthID As Integer, ByVal LicenceCountryID As Integer, ByVal ScanURLs As String, ByVal PriceExceptions As Integer, _
                                                ByVal addComparisonVehicle As Integer) As DataSet
        sqlCom = New SqlCommand("getScanDataCleanChartVehiclePriceOverTimeAcrossDataSets", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420
        sqlCom.Parameters.Add("@DataSetDateStart", SqlDbType.NVarChar).Value = DataSetDateStart
        sqlCom.Parameters.Add("@TravelDateRanges", SqlDbType.NVarChar).Value = TravelDateRanges
        sqlCom.Parameters.Add("@CountryID", SqlDbType.Int).Value = CountryID
        sqlCom.Parameters.Add("@BrandID", SqlDbType.Int).Value = BrandID
        sqlCom.Parameters.Add("@PickupReturnLocationComboID", SqlDbType.NVarChar).Value = PickupReturnLocationComboID
        sqlCom.Parameters.Add("@VehicleID", SqlDbType.NVarChar).Value = VehicleID
        sqlCom.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID
        sqlCom.Parameters.Add("@vehicleBerthID", SqlDbType.Int).Value = vehicleBerthID
        sqlCom.Parameters.Add("@LicenceCountryID", SqlDbType.Int).Value = LicenceCountryID
        sqlCom.Parameters.Add("@ScanURLs", SqlDbType.NVarChar).Value = ScanURLs
        sqlCom.Parameters.Add("@PriceExceptions", SqlDbType.Int).Value = PriceExceptions
        sqlCom.Parameters.Add("@addComparisonVehicle", SqlDbType.Int).Value = addComparisonVehicle

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS)
        'sqlDS.Tables(0).TableName = "Dates"
        'sqlDS.Tables(1).TableName = "Data"
        'sqlDS.Tables(1).TableName = "Min"
        'sqlDS.Tables(2).TableName = "Max"

        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Function getDataTest(ByVal DataSetDateStart As String, ByVal PickUpDateRangeStart As String, ByVal CountryID As Integer, ByVal BrandID As Integer, ByVal PickupLocationID As Integer, ByVal ReturnLocationID As Integer, _
                            ByVal VehicleID As Integer, ByVal vehicleTypeID As Integer, ByVal vehicleBerthID As Integer, ByVal LicenceCountryID As Integer, ByVal ScanURL As Integer, ByVal PriceExceptions As Integer, _
                            ByVal addComparisonVehicle As Integer) As DataSet
        sqlCom = New SqlCommand("getScanDataCleanChartVehiclePriceOverTimeAcrossDataSetsTest", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420
        sqlCom.Parameters.Add("@DataSetDateStart", SqlDbType.NVarChar).Value = DataSetDateStart
        sqlCom.Parameters.Add("@PickUpDateRangeStart", SqlDbType.NVarChar).Value = PickUpDateRangeStart
        sqlCom.Parameters.Add("@CountryID", SqlDbType.Int).Value = CountryID
        sqlCom.Parameters.Add("@BrandID", SqlDbType.Int).Value = BrandID
        sqlCom.Parameters.Add("@PickupLocationID", SqlDbType.Int).Value = PickupLocationID
        sqlCom.Parameters.Add("@ReturnLocationID", SqlDbType.Int).Value = ReturnLocationID
        sqlCom.Parameters.Add("@VehicleID", SqlDbType.Int).Value = VehicleID
        sqlCom.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID
        sqlCom.Parameters.Add("@vehicleBerthID", SqlDbType.Int).Value = vehicleBerthID
        sqlCom.Parameters.Add("@LicenceCountryID", SqlDbType.Int).Value = LicenceCountryID
        sqlCom.Parameters.Add("@ScanURL", SqlDbType.Int).Value = ScanURL
        sqlCom.Parameters.Add("@PriceExceptions", SqlDbType.Int).Value = PriceExceptions
        sqlCom.Parameters.Add("@addComparisonVehicle", SqlDbType.Int).Value = addComparisonVehicle

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS)
        'sqlDS.Tables(0).TableName = "Dates"
        'sqlDS.Tables(1).TableName = "Data"
        'sqlDS.Tables(1).TableName = "Min"
        'sqlDS.Tables(2).TableName = "Max"

        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Shared Sub initDDlFinancialWeeksAndDates(ByVal ddlDates As DropDownList)
        ddlDates.Items.Clear()
        sqlCom = New SqlCommand("getFinancialYearListWeeksAndDates", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Dates")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlDates.DataSource = sqlDS.Tables("Dates")
        ddlDates.DataTextField = "fYearWeek"
        ddlDates.DataValueField = "fDate"
        ddlDates.DataBind()

        sqlDS.Dispose()

    End Sub

    Public Shared Sub initDDlFinancialWeeksAndDatesWithData(ByVal ddlDates As DropDownList)
        ddlDates.Items.Clear()
        sqlCom = New SqlCommand("getFinancialYearListWeeksAndDatesWithData", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Dates")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlDates.DataSource = sqlDS.Tables("Dates")
        ddlDates.DataTextField = "fYearWeek"
        ddlDates.DataValueField = "fDate"
        ddlDates.DataBind()

        sqlDS.Dispose()

    End Sub


    Public Shared Sub initDDlddlPriceExceptions(ByVal ddlPriceExceptions As DropDownList)
        ddlPriceExceptions.Items.Clear()

        ddlPriceExceptions.Items.Insert(0, New ListItem("Vehicle Hire only", 2))
        ddlPriceExceptions.Items.Insert(1, New ListItem("Vehicle hire and Fees", 1))
        ddlPriceExceptions.Items.Insert(1, New ListItem("Unaltered from scan", 0))
        ddlPriceExceptions.DataBind()

        'sqlDS.Dispose()

    End Sub

    Public Shared Sub initDDLRate(ByVal ddlRate As DropDownList)
        ddlRate.Items.Clear()

        ddlRate.Items.Insert(0, New ListItem("Daily Rate", 2))
        ddlRate.Items.Insert(1, New ListItem("Full travel Rate", 1))
        ddlRate.DataBind()

        'sqlDS.Dispose()

    End Sub

    Public Shared Sub initDDLShowSmallest(ByVal ddlShowSmallest As DropDownList)
        ddlShowSmallest.Items.Clear()

        ddlShowSmallest.Items.Insert(0, New ListItem("Smallest only", 0))
        ddlShowSmallest.Items.Insert(1, New ListItem("All", 1))
        ddlShowSmallest.DataBind()

        'sqlDS.Dispose()

    End Sub

    Public Function getListExceptionsCounts() As DataSet
        sqlCom = New SqlCommand("getScanDataWeeklyCounts", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "DataCounts")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Function checkForData(ByVal thisDate As Date) As DataSet
        sqlCom = New SqlCommand("checkForData", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@dateToCheck", SqlDbType.SmallDateTime).Value = thisDate
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "DataCounts")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Function getListExceptions() As DataSet
        sqlCom = New SqlCommand("getListExceptions", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "DataExceptions")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Function getListExceptionsDuplicates() As DataSet
        sqlCom = New SqlCommand("getListExceptionsDuplicates", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "DataExceptions")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Shared Sub initDDlWebsite(ByVal ddlWebsite As DropDownList)
        ddlWebsite.Items.Clear()
        sqlCom = New SqlCommand("getListWebsites", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Websites")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlWebsite.DataSource = sqlDS.Tables("Websites")
        ddlWebsite.DataTextField = "fWebsiteName"
        ddlWebsite.DataValueField = "fID"
        ddlWebsite.DataBind()

        'ddlWebsite.Items.Insert(0, New ListItem("Please select", 0))
        sqlDS.Dispose()

    End Sub

    Public Shared Sub initComparisonFilters(ByVal Values As DataTable, ByVal cblMainWebsite As CheckBoxList, ByVal cblTravelDateRange As CheckBoxList, ByVal ddlBrand As DropDownList, _
                                            ByVal ddlVehicleType As DropDownList, ByVal ddlVehicleBerth As DropDownList, ByVal ddlVehicleName As DropDownList, _
                                            ByVal ddlPickupLocation As DropDownList, ByVal ddlReturnLocation As DropDownList, _
                                            ByVal dataSet As Date, ByVal websiteID As Integer, ByVal countryID As Integer, ByVal brandID As Integer, ByVal vehicleTypeID As Integer, ByVal vehicleBerthID As Integer)

        'clear items
        cblMainWebsite.Items.Clear()
        cblTravelDateRange.Items.Clear()
        ddlBrand.Items.Clear()
        ddlVehicleType.Items.Clear()
        ddlVehicleBerth.Items.Clear()
        ddlVehicleName.Items.Clear()
        ddlPickupLocation.Items.Clear()
        ddlReturnLocation.Items.Clear()
        'sql query
        sqlCom = New SqlCommand("getFiltersComparison", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@DataSetDateStartSDT", SqlDbType.SmallDateTime).Value = dataSet
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID
        sqlCom.Parameters.Add("@brandID", SqlDbType.Int).Value = brandID
        sqlCom.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID
        sqlCom.Parameters.Add("@vehicleBerthID", SqlDbType.Int).Value = vehicleBerthID
        'run query
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS)
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        'fill values
        Values = sqlDS.Tables("Table")
        Values.AcceptChanges()
        'fill website list
        cblMainWebsite.DataSource = sqlDS.Tables("Table1")
        cblMainWebsite.DataTextField = "fWebsiteName"
        cblMainWebsite.DataValueField = "fID"
        cblMainWebsite.DataBind()
        cblMainWebsite.Items.Insert(0, New ListItem("All", 0))
        'fill travel date range
        cblTravelDateRange.DataSource = sqlDS.Tables("Table2")
        cblTravelDateRange.DataTextField = "fTravelDateText"
        cblTravelDateRange.DataValueField = "fTravelDateValue"
        cblTravelDateRange.DataBind()
        cblTravelDateRange.Items.Insert(0, New ListItem("All", 0))
        'fill brands
        ddlBrand.DataSource = sqlDS.Tables("Table3")
        ddlBrand.DataTextField = "fBrandName"
        ddlBrand.DataValueField = "fID"
        ddlBrand.DataBind()
        ddlBrand.Items.Insert(0, New ListItem("All", 0))
        'vehicle type
        ddlVehicleType.DataSource = sqlDS.Tables("Table4")
        ddlVehicleType.DataTextField = "fVehicleTypeName"
        ddlVehicleType.DataValueField = "fID"
        ddlVehicleType.DataBind()
        ddlVehicleType.Items.Insert(0, New ListItem("Please select", 0))
        'vehicle berth
        ddlVehicleBerth.DataSource = sqlDS.Tables("Table5")
        ddlVehicleBerth.DataTextField = "fVehicleBerthName"
        ddlVehicleBerth.DataValueField = "fVehicleBerthValue"
        ddlVehicleBerth.DataBind()
        ddlVehicleBerth.Items.Insert(0, New ListItem("Please select", 0))
        'vehicle list
        ddlVehicleName.DataSource = sqlDS.Tables("Table6")
        ddlVehicleName.DataTextField = "fVehicleName"
        ddlVehicleName.DataValueField = "fID"
        ddlVehicleName.DataBind()
        ddlVehicleName.Items.Insert(0, New ListItem("Please Select", 0))
        'pickup locations
        ddlPickupLocation.DataSource = sqlDS.Tables("Table7")
        ddlPickupLocation.DataTextField = "fLocationName"
        ddlPickupLocation.DataValueField = "fID"
        ddlPickupLocation.DataBind()
        ddlPickupLocation.Items.Insert(0, New ListItem("All locations", 0))
        ddlPickupLocation.Items.Insert(0, New ListItem("Please select", -1))
        'return locations
        ddlReturnLocation.DataSource = sqlDS.Tables("Table7")
        ddlReturnLocation.DataTextField = "fLocationName"
        ddlReturnLocation.DataValueField = "fID"
        ddlReturnLocation.DataBind()
        ddlReturnLocation.Items.Insert(0, New ListItem("All locations", 0))
        ddlReturnLocation.Items.Insert(0, New ListItem("Please select", -1))

        'clear data
        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateComparisonFilters(ByVal Values As DataTable, ByVal ddlBrand As DropDownList, _
                                            ByVal ddlVehicleType As DropDownList, ByVal ddlVehicleBerth As DropDownList, ByVal ddlVehicleName As DropDownList, _
                                            ByVal ddlPickupLocation As DropDownList, ByVal ddlReturnLocation As DropDownList, _
                                            ByVal dataSet As Date, ByVal websiteID As Integer, ByVal countryID As Integer, ByVal brandID As Integer, ByVal vehicleTypeID As Integer, ByVal vehicleBerthID As Integer)

        'clear items
        ddlBrand.Items.Clear()
        ddlVehicleType.Items.Clear()
        ddlVehicleBerth.Items.Clear()
        ddlVehicleName.Items.Clear()
        ddlPickupLocation.Items.Clear()
        ddlReturnLocation.Items.Clear()
        'sql query
        sqlCom = New SqlCommand("getFiltersComparison", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@DataSetDateStartSDT", SqlDbType.SmallDateTime).Value = dataSet
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID
        sqlCom.Parameters.Add("@brandID", SqlDbType.Int).Value = brandID
        sqlCom.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID
        sqlCom.Parameters.Add("@vehicleBerthID", SqlDbType.Int).Value = vehicleBerthID
        'run query
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS)
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        'fill values
        Values = sqlDS.Tables("Table")
        Values.AcceptChanges()
        'fill brands
        ddlBrand.DataSource = sqlDS.Tables("Table3")
        ddlBrand.DataTextField = "fBrandName"
        ddlBrand.DataValueField = "fID"
        ddlBrand.DataBind()
        ddlBrand.Items.Insert(0, New ListItem("All", 0))
        'vehicle type
        ddlVehicleType.DataSource = sqlDS.Tables("Table4")
        ddlVehicleType.DataTextField = "fVehicleTypeName"
        ddlVehicleType.DataValueField = "fID"
        ddlVehicleType.DataBind()
        ddlVehicleType.Items.Insert(0, New ListItem("Please select", 0))
        'vehicle berth
        ddlVehicleBerth.DataSource = sqlDS.Tables("Table5")
        ddlVehicleBerth.DataTextField = "fVehicleBerthName"
        ddlVehicleBerth.DataValueField = "fVehicleBerthValue"
        ddlVehicleBerth.DataBind()
        ddlVehicleBerth.Items.Insert(0, New ListItem("Please select", 0))
        'vehicle list
        ddlVehicleName.DataSource = sqlDS.Tables("Table6")
        ddlVehicleName.DataTextField = "fVehicleName"
        ddlVehicleName.DataValueField = "fID"
        ddlVehicleName.DataBind()
        ddlVehicleName.Items.Insert(0, New ListItem("Please Select", 0))
        'pickup locations
        ddlPickupLocation.DataSource = sqlDS.Tables("Table7")
        ddlPickupLocation.DataTextField = "fLocationName"
        ddlPickupLocation.DataValueField = "fID"
        ddlPickupLocation.DataBind()
        ddlPickupLocation.Items.Insert(0, New ListItem("All locations", 0))
        'return locations
        ddlReturnLocation.DataSource = sqlDS.Tables("Table7")
        ddlReturnLocation.DataTextField = "fLocationName"
        ddlReturnLocation.DataValueField = "fID"
        ddlReturnLocation.DataBind()
        ddlReturnLocation.Items.Insert(0, New ListItem("All locations", 0))

        'clear data
        sqlDS.Dispose()

    End Sub

    Public Shared Sub initComparisonFiltersSnapshot(ByVal Values As DataTable, ByVal ddlFinancialWeek As DropDownList, ByVal cblTravelDateRange As CheckBoxList, ByVal cblMainWebsite As CheckBoxList, _
                                                    ByVal ddlCountry As DropDownList, ByVal ddlPickupLocation As DropDownList, ByVal ddlReturnLocation As DropDownList, _
                                                    ByVal qsFinWk As String, ByVal websiteID As Integer, ByVal qsCountryID As Integer)

        'clear items
        ddlFinancialWeek.Items.Clear()
        cblTravelDateRange.Items.Clear()
        cblMainWebsite.Items.Clear()
        ddlCountry.Items.Clear()
        ddlPickupLocation.Items.Clear()
        ddlReturnLocation.Items.Clear()
        'sql query
        sqlCom = New SqlCommand("getFiltersComparisonSnapshot", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@DataSetDateStartSDT", SqlDbType.NVarChar).Value = qsFinWk
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = qsCountryID
        sqlCom.Parameters.Add("@brandID", SqlDbType.Int).Value = 0
        sqlCom.Parameters.Add("@vehicleID", SqlDbType.Int).Value = 0
        'run query
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS)
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        'fill values
        Values = sqlDS.Tables("Table")
        Values.AcceptChanges()
        'fill financial week
        ddlFinancialWeek.DataSource = sqlDS.Tables("Table1")
        ddlFinancialWeek.DataTextField = "fYearWeek"
        ddlFinancialWeek.DataValueField = "fDate"
        ddlFinancialWeek.DataBind()
        'fill travel date range
        cblTravelDateRange.DataSource = sqlDS.Tables("Table2")
        cblTravelDateRange.DataTextField = "fTravelDateText"
        cblTravelDateRange.DataValueField = "fTravelDateValue"
        cblTravelDateRange.DataBind()
        cblTravelDateRange.Items.Insert(0, New ListItem("All", 0))
        'fill website list
        cblMainWebsite.DataSource = sqlDS.Tables("Table3")
        cblMainWebsite.DataTextField = "fWebsiteName"
        cblMainWebsite.DataValueField = "fID"
        cblMainWebsite.DataBind()
        'fill country list
        ddlCountry.DataSource = sqlDS.Tables("Table4")
        ddlCountry.DataTextField = "fCountryName"
        ddlCountry.DataValueField = "fID"
        ddlCountry.DataBind()
        'pickup locations
        ddlPickupLocation.DataSource = sqlDS.Tables("Table5")
        ddlPickupLocation.DataTextField = "fLocationName"
        ddlPickupLocation.DataValueField = "fID"
        ddlPickupLocation.DataBind()
        ddlPickupLocation.Items.Insert(0, New ListItem("All locations", 0))
        ddlPickupLocation.Items.Insert(0, New ListItem("Please select", -1))
        'return locations
        ddlReturnLocation.DataSource = sqlDS.Tables("Table5")
        ddlReturnLocation.DataTextField = "fLocationName"
        ddlReturnLocation.DataValueField = "fID"
        ddlReturnLocation.DataBind()
        ddlReturnLocation.Items.Insert(0, New ListItem("All locations", 0))
        ddlReturnLocation.Items.Insert(0, New ListItem("Please select", -1))

        'clear data
        sqlDS.Dispose()

    End Sub

    Public Shared Sub initCBLMainWebsite(ByVal cblMainWebsite As CheckBoxList)
        cblMainWebsite.Items.Clear()
        sqlCom = New SqlCommand("getListWebsites", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Websites")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        cblMainWebsite.DataSource = sqlDS.Tables("Websites")
        cblMainWebsite.DataTextField = "fWebsiteName"
        cblMainWebsite.DataValueField = "fID"
        cblMainWebsite.DataBind()

        cblMainWebsite.Items.Insert(0, New ListItem("All", 0))
        sqlDS.Dispose()

        'ddlWebsite.Items.Insert(0, New ListItem("Please select", 0))
        sqlDS.Dispose()

    End Sub

    Public Function getListWebsites() As DataSet
        sqlCom = New SqlCommand("getListWebsites", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "Websites")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Function getListExceptionsWebsites() As DataSet
        sqlCom = New SqlCommand("getListExceptionsWebsites", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "WebsiteExceptions")
        Return sqlDS
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function


    Public Shared Sub updateExceptionsWebsites(ByVal unknownID As Integer, ByVal acceptedID As Integer)
        sqlCom = New SqlCommand("updateExceptionsWebsites", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@unknownID", SqlDbType.Int).Value = unknownID
        sqlCom.Parameters.Add("@acceptedID", SqlDbType.Int).Value = acceptedID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub

    Public Shared Sub initDDlBrand(ByVal ddlBrand As DropDownList)
        ddlBrand.Items.Clear()
        sqlCom = New SqlCommand("getListBrandsActive", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Brands")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlBrand.DataSource = sqlDS.Tables("Brands")
        ddlBrand.DataTextField = "fBrandName"
        ddlBrand.DataValueField = "fID"
        ddlBrand.DataBind()

        sqlDS.Dispose()

    End Sub

    Public Function getListActiveBrands(ByVal websiteID As Integer, ByVal countryID As Integer) As DataSet
        sqlCom = New SqlCommand("getListBrandsActivebyWebsiteCountryIDs", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "Brands")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Shared Sub updateDDLBrand(ByVal ddlBrand As DropDownList, ByVal websiteID As Integer, ByVal countryID As Integer)
        ddlBrand.Items.Clear()
        sqlCom = New SqlCommand("getListBrandsActivebyWebsiteCountryIDs", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Brands")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlBrand.DataSource = sqlDS.Tables("Brands")
        ddlBrand.DataTextField = "fBrandName"
        ddlBrand.DataValueField = "fID"
        ddlBrand.DataBind()

        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateDDLBrandWithSelect(ByVal ddlBrand As DropDownList, ByVal websiteID As Integer, ByVal countryID As Integer)
        ddlBrand.Items.Clear()
        sqlCom = New SqlCommand("getListBrandsActivebyWebsiteCountryIDs", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Brands")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlBrand.DataSource = sqlDS.Tables("Brands")
        ddlBrand.DataTextField = "fBrandName"
        ddlBrand.DataValueField = "fID"
        ddlBrand.DataBind()

        ddlBrand.Items.Insert(0, New ListItem("All brands", 0))

        sqlDS.Dispose()

    End Sub


    Public Shared Sub initDDlBrandAll(ByVal ddlBrand As DropDownList)
        ddlBrand.Items.Clear()
        sqlCom = New SqlCommand("getListBrandsActive", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Brands")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlBrand.DataSource = sqlDS.Tables("Brands")
        ddlBrand.DataTextField = "fBrandName"
        ddlBrand.DataValueField = "fID"
        ddlBrand.DataBind()

        ddlBrand.Items.Insert(0, New ListItem("All brands", 0))
        sqlDS.Dispose()

    End Sub

    'Public Function getListBrandsInactive() As DataSet
    '    sqlCom = New SqlCommand("getListBrandsInactive", sqlCon)
    '    sqlCom.CommandType = CommandType.StoredProcedure

    '    sqlDS = New DataSet
    '    'Try
    '    If sqlCon.State = ConnectionState.Closed Then
    '        sqlCon.Open()
    '    End If
    '    sqlDA = New SqlDataAdapter
    '    sqlDA.SelectCommand = sqlCom
    '    sqlDA.Fill(sqlDS, "BrandsInactive")
    '    Return sqlDS
    '    'Catch ex As Exception
    '    '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
    '    '    Return sqlDS
    '    'End Try
    '    sqlCon.Close()
    '    sqlCom.Dispose()
    '    sqlDA.Dispose()
    '    sqlDS.Dispose()
    'End Function


    Public Shared Sub initDDlBrandInactive(ByVal ddlBrand As DropDownList)
        ddlBrand.Items.Clear()
        sqlCom = New SqlCommand("getListBrandsInactive", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "BrandsInactive")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlBrand.DataSource = sqlDS.Tables("BrandsInactive")
        ddlBrand.DataTextField = "fBrandName"
        ddlBrand.DataValueField = "fID"
        ddlBrand.DataBind()

        ddlBrand.Items.Insert(0, New ListItem("Please select", 0))
        sqlDS.Dispose()

    End Sub

    Public Function getListExceptionsDates() As DataSet
        sqlCom = New SqlCommand("getListExceptionsDates", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "DateExceptions")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Shared Sub updateExceptionsDates(ByVal pickupDate As String, ByVal returnDate As String)
        sqlCom = New SqlCommand("updateExceptionsDates", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@pickupDate", SqlDbType.SmallDateTime).Value = pickupDate
        sqlCom.Parameters.Add("@returnDate", SqlDbType.SmallDateTime).Value = returnDate

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub

    Public Function getListExceptionsBrands() As DataSet
        sqlCom = New SqlCommand("getListExceptionsBrands", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "BrandExceptions")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Shared Sub updateExceptionsBrandsAddBrand(ByVal unknownID As Integer, ByVal activeState As Integer)
        sqlCom = New SqlCommand("updateExceptionsBrandsAddBrand", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@unknownID", SqlDbType.Int).Value = unknownID
        sqlCom.Parameters.Add("@activeState", SqlDbType.Int).Value = activeState

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub

    Public Shared Sub updateExceptionsBrands(ByVal unknownID As Integer, ByVal acceptedID As Integer)
        sqlCom = New SqlCommand("updateExceptionsBrands", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@unknownID", SqlDbType.Int).Value = unknownID
        sqlCom.Parameters.Add("@acceptedID", SqlDbType.Int).Value = acceptedID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub

    Public Function getListExceptionsCountries() As DataSet
        sqlCom = New SqlCommand("getListExceptionsCountries", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "CountryExceptions")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    'Public Function getListCountries() As DataSet
    '    sqlCom = New SqlCommand("getListCountries", sqlCon)
    '    sqlCom.CommandType = CommandType.StoredProcedure

    '    sqlDS = New DataSet
    '    'Try
    '    If sqlCon.State = ConnectionState.Closed Then
    '        sqlCon.Open()
    '    End If
    '    sqlDA = New SqlDataAdapter
    '    sqlDA.SelectCommand = sqlCom
    '    sqlDA.Fill(sqlDS, "Countries")
    '    Return sqlDS
    '    'Catch ex As Exception
    '    '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
    '    '    Return sqlDS
    '    'End Try
    '    sqlCon.Close()
    '    sqlCom.Dispose()
    '    sqlDA.Dispose()
    '    sqlDS.Dispose()
    'End Function

    Public Shared Sub initDDlCountry(ByVal ddlCountry As DropDownList)
        ddlCountry.Items.Clear()

        ddlCountry.Items.Insert(0, New ListItem("Australia", 1))
        ddlCountry.Items.Insert(1, New ListItem("New Zealand", 2))
        ddlCountry.Items.Insert(2, New ListItem("USA", 3))
        ddlCountry.Items.Insert(3, New ListItem("Canada", 4))
    End Sub

    Public Shared Sub initDDlCountryAll(ByVal ddlCountry As DropDownList)
        ddlCountry.Items.Clear()

        ddlCountry.Items.Insert(0, New ListItem("All countries", 0))
        ddlCountry.Items.Insert(1, New ListItem("Australia", 1))
        ddlCountry.Items.Insert(2, New ListItem("New Zealand", 2))
        ddlCountry.Items.Insert(3, New ListItem("USA", 3))
        ddlCountry.Items.Insert(4, New ListItem("Canada", 4))
    End Sub

    Public Shared Sub updateDDLCountry(ByVal ddlCountry As DropDownList, ByVal websiteID As Integer)
        ddlCountry.Items.Clear()

        sqlCom = New SqlCommand("getListCountriesbyWebsite", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Country")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlCountry.DataSource = sqlDS.Tables("Country")
        ddlCountry.DataTextField = "fCountryName"
        ddlCountry.DataValueField = "fID"
        ddlCountry.DataBind()

        sqlDS.Dispose()
    End Sub

    Public Shared Sub updateDDLCountryWithSelect(ByVal ddlCountry As DropDownList, ByVal websiteID As Integer)
        ddlCountry.Items.Clear()

        sqlCom = New SqlCommand("getListCountriesbyWebsite", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Country")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlCountry.DataSource = sqlDS.Tables("Country")
        ddlCountry.DataTextField = "fCountryName"
        ddlCountry.DataValueField = "fID"
        ddlCountry.DataBind()

        ddlCountry.Items.Insert(0, New ListItem("All Countries", 0))

        sqlDS.Dispose()
    End Sub

    Public Shared Sub initDDlLicenceCountry(ByVal ddlCountry As DropDownList)
        ddlCountry.Items.Clear()

        ddlCountry.Items.Insert(0, New ListItem("Domestic", 1))
        ddlCountry.Items.Insert(1, New ListItem("International", 2))
    End Sub

    Public Shared Sub initDDLpercentOrPrice(ByVal ddlPercentOrPrice As DropDownList)
        ddlPercentOrPrice.Items.Clear()

        ddlPercentOrPrice.Items.Insert(0, New ListItem("Price", 2))
        ddlPercentOrPrice.Items.Insert(1, New ListItem("Percent", 1))
    End Sub


    Public Shared Sub updateExceptionsCountries(ByVal unknownID As Integer, ByVal acceptedID As Integer, ByVal typeID As Integer)
        sqlCom = New SqlCommand("updateExceptionsCountries", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@unknownID", SqlDbType.Int).Value = unknownID
        sqlCom.Parameters.Add("@acceptedID", SqlDbType.Int).Value = acceptedID
        sqlCom.Parameters.Add("@typeID", SqlDbType.Int).Value = typeID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub


    Public Function getListExceptionsLocations() As DataSet
        sqlCom = New SqlCommand("getListExceptionsLocations", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "LocationExceptions")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Function getListLocations(ByVal countySelect As Integer) As DataSet
        sqlCom = New SqlCommand("getListLocations", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@countySelect", SqlDbType.Int).Value = countySelect


        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "Locations")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Shared Sub initDDlLocation(ByVal ddlLocation As DropDownList, ByVal countySelect As Integer)
        ddlLocation.Items.Clear()
        sqlCom = New SqlCommand("getListLocations", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@countySelect", SqlDbType.Int).Value = countySelect

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Locations")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlLocation.DataSource = sqlDS.Tables("Locations")
        ddlLocation.DataTextField = "fLocationName"
        ddlLocation.DataValueField = "fID"
        ddlLocation.DataBind()

        ddlLocation.Items.Insert(0, New ListItem("All locations", 0))
        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateDDLPickupLocation(ByVal ddlLocation As DropDownList, ByVal websiteID As Integer, ByVal countryID As Integer, ByVal brandID As Integer)
        ddlLocation.Items.Clear()
        sqlCom = New SqlCommand("getListLocationsPickupByWebsiteCountryBrand", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID
        sqlCom.Parameters.Add("@brandID", SqlDbType.Int).Value = brandID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Locations")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlLocation.DataSource = sqlDS.Tables("Locations")
        ddlLocation.DataTextField = "fLocationName"
        ddlLocation.DataValueField = "fID"
        ddlLocation.DataBind()

        ddlLocation.Items.Insert(0, New ListItem("All locations", 0))
        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateDDLLocationByVehicle(ByVal ddlLocation As DropDownList, ByVal websiteID As Integer, ByVal countryID As Integer, ByVal vehicleID As Integer)
        ddlLocation.Items.Clear()
        sqlCom = New SqlCommand("getListLocationsReturnByWebsiteCountryVehicle", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID
        sqlCom.Parameters.Add("@vehicleID", SqlDbType.Int).Value = vehicleID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Locations")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlLocation.DataSource = sqlDS.Tables("Locations")
        ddlLocation.DataTextField = "fLocationName"
        ddlLocation.DataValueField = "fID"
        ddlLocation.DataBind()

        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateDDLLocationByVehicleWithSelect(ByVal ddlLocation As DropDownList, ByVal websiteID As Integer, ByVal countryID As Integer, ByVal vehicleID As Integer)
        ddlLocation.Items.Clear()
        sqlCom = New SqlCommand("getListLocationsReturnByWebsiteCountryVehicle", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID
        sqlCom.Parameters.Add("@vehicleID", SqlDbType.Int).Value = vehicleID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Locations")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlLocation.DataSource = sqlDS.Tables("Locations")
        ddlLocation.DataTextField = "fLocationName"
        ddlLocation.DataValueField = "fID"
        ddlLocation.DataBind()

        ddlLocation.Items.Insert(0, New ListItem("All locations", 0))
        ddlLocation.Items.Insert(0, New ListItem("Please select", -1))
        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateDDLReturnLocation(ByVal ddlLocation As DropDownList, ByVal websiteID As Integer, ByVal countryID As Integer, ByVal brandID As Integer)
        ddlLocation.Items.Clear()
        sqlCom = New SqlCommand("getListLocationsReturnByWebsiteCountryBrand", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID
        sqlCom.Parameters.Add("@brandID", SqlDbType.Int).Value = brandID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Locations")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlLocation.DataSource = sqlDS.Tables("Locations")
        ddlLocation.DataTextField = "fLocationName"
        ddlLocation.DataValueField = "fID"
        ddlLocation.DataBind()

        ddlLocation.Items.Insert(0, New ListItem("All locations", 0))
        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateExceptionsLocations(ByVal unknownID As Integer, ByVal acceptedID As Integer, ByVal typeID As Integer)
        sqlCom = New SqlCommand("updateExceptionsLocations", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@unknownID", SqlDbType.Int).Value = unknownID
        sqlCom.Parameters.Add("@acceptedID", SqlDbType.Int).Value = acceptedID
        sqlCom.Parameters.Add("@typeID", SqlDbType.Int).Value = typeID
        sqlCom.CommandTimeout = 420

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub




    Public Function getListExceptionsVehicles() As DataSet
        sqlCom = New SqlCommand("getListExceptionsVehicles", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "VehicleExceptions")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function

    Public Shared Sub initDDlVehicle(ByVal ddlVehicle As DropDownList, ByVal brandID As Integer)
        ddlVehicle.Items.Clear()
        sqlCom = New SqlCommand("getListVehiclesbyBrandID", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@brandID", SqlDbType.Int).Value = brandID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Vehicles")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlVehicle.DataSource = sqlDS.Tables("Vehicles")
        ddlVehicle.DataTextField = "fVehicleName"
        ddlVehicle.DataValueField = "fID"
        ddlVehicle.DataBind()

        'ddlVehicle.Items.Insert(0, New ListItem("Please Select", 0))
        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateDDLVehicle(ByVal ddlVehicle As DropDownList, ByVal websiteID As Integer, ByVal countryID As Integer, ByVal brandID As Integer, ByVal vehicleTypeID As Integer, ByVal vehicleBerthID As Integer)
        ddlVehicle.Items.Clear()
        sqlCom = New SqlCommand("getListVehiclesbyWebsiteCountryBrand", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID
        sqlCom.Parameters.Add("@brandID", SqlDbType.Int).Value = brandID
        sqlCom.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID
        sqlCom.Parameters.Add("@vehicleBerthID", SqlDbType.Int).Value = vehicleBerthID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Vehicles")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlVehicle.DataSource = sqlDS.Tables("Vehicles")
        ddlVehicle.DataTextField = "fVehicleName"
        ddlVehicle.DataValueField = "fID"
        ddlVehicle.DataBind()

        ddlVehicle.Items.Insert(0, New ListItem("Please Select", 0))
        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateDDLVehicleAutoSelect(ByVal ddlVehicle As DropDownList, ByVal websiteID As Integer, ByVal countryID As Integer, ByVal brandID As Integer, ByVal vehicleTypeID As Integer, ByVal vehicleBerthID As Integer)
        ddlVehicle.Items.Clear()
        sqlCom = New SqlCommand("getListVehiclesbyWebsiteCountryBrand", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID
        sqlCom.Parameters.Add("@brandID", SqlDbType.Int).Value = brandID
        sqlCom.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID
        sqlCom.Parameters.Add("@vehicleBerthID", SqlDbType.Int).Value = vehicleBerthID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Vehicles")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlVehicle.DataSource = sqlDS.Tables("Vehicles")
        ddlVehicle.DataTextField = "fVehicleName"
        ddlVehicle.DataValueField = "fID"
        ddlVehicle.DataBind()

        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateDDLVehiclesWithEquivalentsAutoSelect(ByVal ddlVehicle As DropDownList, ByVal websiteID As Integer, ByVal countryID As Integer, ByVal brandID As Integer, ByVal vehicleTypeID As Integer, ByVal vehicleBerthID As Integer)
        ddlVehicle.Items.Clear()
        sqlCom = New SqlCommand("getListVehicleEquivalentsbyWebsiteCountryBrand", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID
        sqlCom.Parameters.Add("@brandID", SqlDbType.Int).Value = brandID
        sqlCom.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID
        sqlCom.Parameters.Add("@vehicleBerthID", SqlDbType.Int).Value = vehicleBerthID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Vehicles")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlVehicle.DataSource = sqlDS.Tables("Vehicles")
        ddlVehicle.DataTextField = "fVehicleName"
        ddlVehicle.DataValueField = "fID"
        ddlVehicle.DataBind()

        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateDDLVehicleType(ByVal ddlVehicleType As DropDownList, ByVal websiteID As Integer, ByVal countryID As Integer, ByVal brandID As Integer)
        ddlVehicleType.Items.Clear()
        sqlCom = New SqlCommand("getListVehicleTypesbyWebsiteCountryBrand", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID
        sqlCom.Parameters.Add("@brandID", SqlDbType.Int).Value = brandID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "VehicleTypes")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlVehicleType.DataSource = sqlDS.Tables("VehicleTypes")
        ddlVehicleType.DataTextField = "fVehicleTypeName"
        ddlVehicleType.DataValueField = "fID"
        ddlVehicleType.DataBind()

        ddlVehicleType.Items.Insert(0, New ListItem("Please select", 0))
        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateDDLVehicleBerth(ByVal ddlVehicleBerth As DropDownList, ByVal websiteID As Integer, ByVal countryID As Integer, ByVal brandID As Integer, ByVal vehicleTypeID As Integer)
        ddlVehicleBerth.Items.Clear()
        sqlCom = New SqlCommand("getListVehicleBerthsbyWebsiteCountryBrand", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@websiteID", SqlDbType.Int).Value = websiteID
        sqlCom.Parameters.Add("@countryID", SqlDbType.Int).Value = countryID
        sqlCom.Parameters.Add("@brandID", SqlDbType.Int).Value = brandID
        sqlCom.Parameters.Add("@vehicleTypeID", SqlDbType.Int).Value = vehicleTypeID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "VehicleBerths")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlVehicleBerth.DataSource = sqlDS.Tables("VehicleBerths")
        ddlVehicleBerth.DataTextField = "fVehicleBerthName"
        ddlVehicleBerth.DataValueField = "fVehicleBerthValue"
        ddlVehicleBerth.DataBind()

        ddlVehicleBerth.Items.Insert(0, New ListItem("Please select", 0))
        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateExceptionsVehicles(ByVal unknownID As Integer, ByVal acceptedID As Integer)
        sqlCom = New SqlCommand("updateExceptionsVehicles", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@unknownID", SqlDbType.Int).Value = unknownID
        sqlCom.Parameters.Add("@acceptedID", SqlDbType.Int).Value = acceptedID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub

    Public Shared Sub updateExceptionsVehiclesAddVehicle(ByVal unknownID As Integer, ByVal acceptedBrandID As Integer)
        sqlCom = New SqlCommand("updateExceptionsVehiclesAddVehicle", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@unknownID", SqlDbType.Int).Value = unknownID
        sqlCom.Parameters.Add("@acceptedBrandID", SqlDbType.Int).Value = acceptedBrandID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub


    Public Function getListExceptionsCurrencies() As DataSet
        sqlCom = New SqlCommand("getListExceptionsCurrencies", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "CurrencyExceptions")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function


    Public Function getListCurrencies() As DataSet
        sqlCom = New SqlCommand("getListCurrencies", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "Currencies")
        Return sqlDS
        'Catch ex As Exception
        '    '    _commonClasses.Errors.Current.ErrorFullList(ex, "specials", "specialsGetByURL")
        '    Return sqlDS
        'End Try
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function


    Public Shared Sub initDDlCurrency(ByVal ddlCurrency As DropDownList)
        ddlCurrency.Items.Clear()
        sqlCom = New SqlCommand("getListCurrencies", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Currencies")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlCurrency.DataSource = sqlDS.Tables("Currencies")
        ddlCurrency.DataTextField = "fCurrencyCode"
        ddlCurrency.DataValueField = "fID"
        ddlCurrency.DataBind()

        sqlDS.Dispose()

    End Sub

    Public Shared Sub updateExceptionsCurrencies(ByVal unknownID As Integer, ByVal acceptedID As Integer)
        sqlCom = New SqlCommand("updateExceptionsCurrencies", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@unknownID", SqlDbType.Int).Value = unknownID
        sqlCom.Parameters.Add("@acceptedID", SqlDbType.Int).Value = acceptedID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub

    Public Shared Sub initDDLVehicleType(ByVal ddlVehicleType As DropDownList)
        ddlVehicleType.Items.Clear()
        sqlCom = New SqlCommand("getListVehicleTypes", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "VehicleTypes")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlVehicleType.DataSource = sqlDS.Tables("VehicleTypes")
        ddlVehicleType.DataTextField = "fVehicleTypeName"
        ddlVehicleType.DataValueField = "fID"
        ddlVehicleType.DataBind()

        ddlVehicleType.Items.Insert(0, New ListItem("Please select", 0))
        sqlDS.Dispose()

    End Sub

    Public Shared Sub initDDLVehicleBerth(ByVal ddlVehicleBerth As DropDownList)
        ddlVehicleBerth.Items.Clear()
        sqlCom = New SqlCommand("getListVehicleBerths", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "VehicleBerths")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlVehicleBerth.DataSource = sqlDS.Tables("VehicleBerths")
        ddlVehicleBerth.DataTextField = "fVehicleBerthName"
        ddlVehicleBerth.DataValueField = "fVehicleBerthValue"
        ddlVehicleBerth.DataBind()

        ddlVehicleBerth.Items.Insert(0, New ListItem("Please select", 0))
        sqlDS.Dispose()

    End Sub

    Public Shared Sub initCBLTravelDateRange(ByVal cblTravelDateRange As CheckBoxList, ByVal dataSet As Date)
        cblTravelDateRange.Items.Clear()
        sqlCom = New SqlCommand("getListTravelDatesForDataSet", sqlCon)
        sqlCom.Parameters.Add("@DataSetDateStartSDT", SqlDbType.SmallDateTime).Value = dataSet
        sqlCom.CommandType = CommandType.StoredProcedure

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Dates")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        cblTravelDateRange.DataSource = sqlDS.Tables("Dates")
        cblTravelDateRange.DataTextField = "fTravelDateText"
        cblTravelDateRange.DataValueField = "fTravelDateValue"
        cblTravelDateRange.DataBind()

        sqlDS.Dispose()

    End Sub


    Public Function getListExceptionsPrices() As DataSet
        sqlCom = New SqlCommand("getListExceptionsPrices", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "PriceExceptions")
        Return sqlDS
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function


    Public Shared Sub addExceptionsPrices(ByVal brand As String, ByVal country As Integer, ByVal pickupLocation As String, ByVal returnLocation As String, ByVal OneWayRentals As Boolean, _
                                          ByVal startDate As Date, ByVal endDate As Date, ByVal priceChange As Decimal, ByVal priceChangePercent As Decimal, ByVal currency As Integer, ByVal priceChangeNote As String)
        sqlCom = New SqlCommand("addExceptionsPrices", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@brand", SqlDbType.NVarChar).Value = brand
        sqlCom.Parameters.Add("@country", SqlDbType.Int).Value = country
        sqlCom.Parameters.Add("@pickupLocation", SqlDbType.NVarChar).Value = pickupLocation
        sqlCom.Parameters.Add("@returnLocation", SqlDbType.NVarChar).Value = returnLocation
        sqlCom.Parameters.Add("@OneWayRentals", SqlDbType.Bit).Value = OneWayRentals
        sqlCom.Parameters.Add("@startDate", SqlDbType.SmallDateTime).Value = startDate
        sqlCom.Parameters.Add("@endDate", SqlDbType.SmallDateTime).Value = endDate
        sqlCom.Parameters.Add("@priceChange", SqlDbType.Decimal).Value = priceChange
        sqlCom.Parameters.Add("@priceChangePercent", SqlDbType.Decimal).Value = priceChangePercent
        sqlCom.Parameters.Add("@currency", SqlDbType.Int).Value = currency
        sqlCom.Parameters.Add("@priceChangeNote", SqlDbType.NVarChar).Value = priceChangeNote

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub

    Public Shared Sub updateExceptionsPrices(ByVal updateID As Integer, ByVal brandList As String, ByVal country As Integer, ByVal pickupLocation As String, ByVal returnLocation As String, ByVal OneWayRentals As Boolean, _
                                          ByVal startDate As DateTime, ByVal endDate As DateTime, ByVal priceChange As Decimal, ByVal priceChangePercent As Decimal, ByVal currency As Integer, ByVal priceChangeNote As String)
        sqlCom = New SqlCommand("updateExceptionsPrices", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@updateID", SqlDbType.Int).Value = updateID
        sqlCom.Parameters.Add("@brand", SqlDbType.NVarChar).Value = brandList
        sqlCom.Parameters.Add("@country", SqlDbType.Int).Value = country
        sqlCom.Parameters.Add("@pickupLocation", SqlDbType.NVarChar).Value = pickupLocation
        sqlCom.Parameters.Add("@returnLocation", SqlDbType.NVarChar).Value = returnLocation
        sqlCom.Parameters.Add("@OneWayRentals", SqlDbType.Bit).Value = OneWayRentals
        sqlCom.Parameters.Add("@startDate", SqlDbType.SmallDateTime).Value = startDate
        sqlCom.Parameters.Add("@endDate", SqlDbType.SmallDateTime).Value = endDate
        sqlCom.Parameters.Add("@priceChange", SqlDbType.Decimal).Value = priceChange
        sqlCom.Parameters.Add("@priceChangePercent", SqlDbType.Decimal).Value = priceChangePercent
        sqlCom.Parameters.Add("@currency", SqlDbType.Int).Value = currency
        sqlCom.Parameters.Add("@priceChangeNote", SqlDbType.NVarChar).Value = priceChangeNote

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub

    Public Shared Sub deleteExceptionsPrices(ByVal badID As Integer)
        sqlCom = New SqlCommand("deleteExceptionsPrices", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@badID", SqlDbType.Int).Value = badID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub


    Public Function getExceptionsPricesByID(ByVal getID As Integer) As DataSet
        sqlCom = New SqlCommand("getExceptionsPricesByID", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@getID", SqlDbType.Int).Value = getID
        sqlCom.CommandTimeout = 420

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "PriceException")
        Return sqlDS

        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()
    End Function


    Public Shared Sub addExceptionCheckCount(ByVal exceptionCount As Integer)
        sqlCom = New SqlCommand("addExceptionCheckCount", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@exceptionCount", SqlDbType.Int).Value = exceptionCount
        sqlCom.CommandTimeout = 720

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub


    Public Shared Function addDataClean(ByVal whatToCheck As Integer) As DataSet
        sqlCom = New SqlCommand("addScanDataClean", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@whatToCheck", SqlDbType.Int).Value = whatToCheck
        sqlCom.CommandTimeout = 720

        sqlDS = New DataSet
        'Try
        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDA.Fill(sqlDS, "Data")
        Return sqlDS

        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()
        sqlDS.Dispose()

    End Function


    Public Shared Sub importExchangeRates(ByVal XMLString As String)
        sqlCom = New SqlCommand("importXMLExchangeRates", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure
        sqlCom.Parameters.Add("@XMLString", SqlDbType.NVarChar).Value = XMLString

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()
        sqlCon.Close()
        sqlCom.Dispose()
    End Sub


End Class
