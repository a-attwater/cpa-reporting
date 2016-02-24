Public Class data_import
    Inherits System.Web.UI.Page

    Public sqlDr As DataRow
    Dim DsWebsites As DataSet = New DataSet
    Public sqlDrData As DataRow
    Dim DsData As DataSet = New DataSet


    Public tableText As String = ""
    Public lblDateRangeChecked As String = "N/A"
    Public lblDateCountChecked As String = "N/A"
    Public lblDateExceptionCount As String = "N/A"
    Public lblWebsiteExceptionCount As String = "N/A"
    Public lblCountryExceptionCount As String = "N/A"
    Public lblBrandExceptionCount As String = "N/A"
    Public lblLocationExceptionCount As String = "N/A"
    Public lblVehicleExceptionCount As String = "N/A"
    Public lblCurrencyExceptionCount As String = "N/A"


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            'getExceptions()
            tblExceptions.Text = ""
        End If
    End Sub

    Private Sub getExceptions()

        DsWebsites = data.Current.getListExceptions()
        If DsWebsites.Tables.Count > 0 Then

            If DsWebsites.Tables("DataExceptions").Rows.Count > 0 Then
                sqlDr = DsWebsites.Tables("DataExceptions").Rows(0)
                lblDateRangeChecked = sqlDr("fDateRange")
                lblDateCountChecked = sqlDr("fDataCount")
                lblDateExceptionCount = sqlDr("fDate")
                lblWebsiteExceptionCount = sqlDr("fWebsite")
                lblCountryExceptionCount = sqlDr("fCountry")
                lblBrandExceptionCount = sqlDr("fBrand")
                lblLocationExceptionCount = sqlDr("fLocation")
                lblVehicleExceptionCount = sqlDr("fVehicle")
                lblCurrencyExceptionCount = sqlDr("fCurrency")
            End If

            tableText &= "<table class='table-list' cellspacing='0' rules='all' border='1' id='ContentPlaceHolder1_specialsList' style='width:800px;border-collapse:collapse;'>"
            tableText &= "<tr><td scope='col'>Date range of Data checked:</td>		    <td scope='col'>" & lblDateRangeChecked & "</td>            <td scope='col'>&nbsp;</td></tr>"
            tableText &= "<tr><td scope='col'>Count of Data checked:</td>		        <td scope='col'>" & lblDateCountChecked & "</td>            <td scope='col'>&nbsp;</td></tr> "
            tableText &= "<tr><td scope='col'>&nbsp;</td>		                        <td scope='col'>&nbsp;</td>                                 <td scope='col'>&nbsp;</td></tr> "
            tableText &= "<tr><td scope='col'><strong>Exception Type</strong></td>		<td scope='col'><strong>Number</strong></td>                <td scope='col'><strong>Click to view</strong></td></tr>"
            tableText &= "<tr><td scope='col'>Dates</td>		                        <td scope='col'>" & lblDateExceptionCount & "</td>          <td scope='col'><a href='/exceptions/exceptions-dates.aspx'>View Exceptions</a></td></tr>"
            tableText &= "<tr><td scope='col'>Websites</td>		                        <td scope='col'>" & lblWebsiteExceptionCount & "</td>        <td scope='col'><a href='/exceptions/exceptions-websites.aspx'>View Exceptions</a></td></tr>"
            tableText &= "<tr><td scope='col'>Countries</td>		                    <td scope='col'>" & lblCountryExceptionCount & "</td>        <td scope='col'><a href='/exceptions/exceptions-countries.aspx'>View Exceptions</a></td></tr>"
            tableText &= "<tr><td scope='col'>Brands</td>		                        <td scope='col'>" & lblBrandExceptionCount & "</td>          <td scope='col'><a href='/exceptions/exceptions-brands.aspx'>View Exceptions</a></td></tr>"
            tableText &= "<tr><td scope='col'>Locations</td>		                    <td scope='col'>" & lblLocationExceptionCount & "</td>       <td scope='col'><a href='/exceptions/exceptions-locations.aspx'>View Exceptions</a></td></tr>"
            tableText &= "<tr><td scope='col'>Vehicles</td>		                        <td scope='col'>" & lblVehicleExceptionCount & "</td>        <td scope='col'><a href='/exceptions/exceptions-vehicles.aspx'>View Exceptions</a></td></tr>"
            tableText &= "<tr><td scope='col'>Currency</td>		                        <td scope='col'>" & lblCurrencyExceptionCount & "</td>       <td scope='col'><a href='/exceptions/exceptions-currencies.aspx'>View Exceptions</a></td></tr>"
            tableText &= "</table>"

        End If

        'show data on the page
        tblExceptions.Text = tableText
    End Sub


    Protected Sub btnAcceptData_Click(ByVal sender As Object, ByVal e As EventArgs)

        'count exceptions and add to exceptionCheck
        Dim exceptionCount As Integer = 0
        Dim num As Integer = 0
        If Integer.TryParse(lblDateExceptionCount, num) Then
            exceptionCount += Integer.Parse(lblDateExceptionCount)
        End If
        If Integer.TryParse(lblWebsiteExceptionCount, num) Then
            exceptionCount += Integer.Parse(lblWebsiteExceptionCount)
        End If
        If Integer.TryParse(lblCountryExceptionCount, num) Then
            exceptionCount += Integer.Parse(lblCountryExceptionCount)
        End If
        If Integer.TryParse(lblBrandExceptionCount, num) Then
            exceptionCount += Integer.Parse(lblBrandExceptionCount)
        End If
        If Integer.TryParse(lblLocationExceptionCount, num) Then
            exceptionCount += Integer.Parse(lblLocationExceptionCount)
        End If
        If Integer.TryParse(lblVehicleExceptionCount, num) Then
            exceptionCount += Integer.Parse(lblVehicleExceptionCount)
        End If
        If Integer.TryParse(lblCurrencyExceptionCount, num) Then
            exceptionCount += Integer.Parse(lblCurrencyExceptionCount)
        End If
        data.addExceptionCheckCount(exceptionCount)

        'accept Data
        Dim addedDataCount As Integer = 0
        Dim wksToCheck As Integer = 2
        If System.Configuration.ConfigurationManager.AppSettings("testing") = "y" Then
            wksToCheck = 10
        End If

        DsData = data.addDataClean(wksToCheck)
        If DsData.Tables.Count > 0 Then
            If Not DsData.Tables("Data").Rows.Count > 0 Then
                addedDataCount = 0
            Else
                sqlDr = DsData.Tables("Data").Rows(0)
                addedDataCount = sqlDr("fDataCount")
            End If
        End If
        'show how many items were accepted
        lblDataAddedCount.Text = addedDataCount.ToString + " items added."
    End Sub

    Protected Sub btnCheckExceptions_click(ByVal sender As Object, ByVal e As EventArgs)
        'fill exceptions table
        getExceptions()
    End Sub


End Class