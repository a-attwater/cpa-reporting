Public Class exceptions_prices_update
    Inherits System.Web.UI.Page

    Public sqlDr As DataRow

    ' setup checklist variables
    Public PickupLocationList As New CheckBoxList
    Public ReturnLocationList As New CheckBoxList
    Public BrandNameList As New CheckBoxList

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim websiteID As Integer = 0
        Dim countryID As Integer = 0
        If Not Page.IsPostBack Then
            ' fill filter ddls

            data.initDDlCurrency(ddlCurrency)

            'data.updateDDLBrandWithSelect(ddlBrand, websiteID, countryID)
        ' get country ID
        ' get location list
            'Dim sqlDsLocs As DataSet
            'Dim sqlDtLocs As DataTable
            'Dim sqlDrLocs As DataRow

        If Request.QueryString("id") > 0 Then 'check if id querystring exists and get data
            'get data
            Dim sqlDs As DataSet = data.Current.getExceptionsPricesByID(Request.QueryString("id"))
            sqlDr = sqlDs.Tables("PriceException").Rows(0)

                data.updateDDLCountryWithSelect(ddlCountry, websiteID)
                If ddlCountry.Items.FindByValue(sqlDr("fPriceExceptionCountryID")) IsNot Nothing Then
                    ddlCountry.SelectedValue = sqlDr("fPriceExceptionCountryID")
                End If
                countryID = ddlCountry.SelectedValue
                'data.updateDDLBrandWithSelect(ddlBrand, websiteID, countryID)
                'If ddlBrand.Items.FindByValue(sqlDr("fPriceExceptionBrandID")) IsNot Nothing Then
                '    ddlBrand.SelectedValue = sqlDr("fPriceExceptionBrandID")
                'End If
            chBxOneWay.Checked = sqlDr("fPriceExceptionOneWay")

            If Not IsDBNull(sqlDr("fPriceExceptionDateStart")) Then
                txtStartDate.Text = sqlDr("fPriceExceptionDateStart")
            End If
            If Not IsDBNull(sqlDr("fPriceExceptionDateEnd")) Then
                Dim myVal As String = sqlDr("fPriceExceptionDateEnd")
                Dim acceptableDateRange As DateTime = DateTime.Now
                acceptableDateRange = acceptableDateRange.AddYears(30)

                If Not (String.IsNullOrEmpty(myVal) Or myVal = "") Then
                    Dim thisDate As DateTime = Convert.ToDateTime(myVal)
                    If Not thisDate > acceptableDateRange Then
                        txtEndDate.Text = sqlDr("fPriceExceptionDateEnd")
                    End If
                End If
            End If

            If Not IsDBNull(sqlDr("fPriceExceptionPriceChange")) Then
                txtPriceChangeDecimal.Text = sqlDr("fPriceExceptionPriceChange")
            End If
            If Not IsDBNull(sqlDr("fPriceExceptionPercentage")) Then
                txtPriceChangePercent.Text = sqlDr("fPriceExceptionPercentage")
            End If

            ddlCurrency.SelectedValue = sqlDr("fPriceExceptionCurrencyID")

            If Not IsDBNull(sqlDr("fPriceExceptionNote")) Then
                txtPriceChangeNote.Text = sqlDr("fPriceExceptionNote")
            End If


            End If
        End If

        'End If

        Call updateBrandBoxes()
        Call updateLocationBoxes()


    End Sub

    Protected Sub btnUpdateException_Click(ByVal sender As Object, ByVal e As EventArgs)

        'setup variables
        Dim fID As Integer = 0
        Dim website As Integer = 0
        'Dim brand As Integer = 0
        Dim country As Integer = 0
        Dim pickupLocation As Integer = 0
        Dim returnLocation As Integer = 0
        Dim OneWayRentals As Boolean = 0
        Dim startDate, endDate As DateTime
        Dim priceChangeNote As String
        Dim priceChange As Decimal = 0
        Dim priceChangePercent As Decimal = 0
        Dim currency As Integer = 0

        'get value of variables
        fID = Convert.ToInt32(Request.QueryString("id").ToString)
        'brand = ddlBrand.SelectedValue
        country = ddlCountry.SelectedValue
        'pickupLocation = ddlPickupLocation.SelectedValue
        'returnLocation = ddlReturnLocation.SelectedValue
        OneWayRentals = chBxOneWay.Checked
        Decimal.TryParse(txtPriceChangeDecimal.Text, priceChange)
        Decimal.TryParse(txtPriceChangePercent.Text, priceChangePercent)
        currency = ddlCurrency.SelectedValue
        priceChangeNote = txtPriceChangeNote.Text


        If String.IsNullOrEmpty(txtStartDate.Text) Then
            startDate = DateTime.Now
        Else
            startDate = Convert.ToDateTime(txtStartDate.Text)
        End If
        If String.IsNullOrEmpty(txtEndDate.Text) Then
            endDate = DateTime.Now
            endDate = endDate.AddYears(50)
        Else
            endDate = Convert.ToDateTime(txtEndDate.Text)
        End If

        ' get list of pickup Locations
        Dim pickupList As String = ""
        For Each li As ListItem In PickupLocationList.Items
            If li.Selected Then
                If pickupList = "" Then
                    pickupList = li.Value.ToString()
                Else
                    pickupList = pickupList & "," & li.Value.ToString()
                End If
            End If
        Next
        Dim returnList As String = ""
        For Each li As ListItem In ReturnLocationList.Items
            If li.Selected Then
                If returnList = "" Then
                    returnList = li.Value.ToString()
                Else
                    returnList = returnList & "," & li.Value.ToString()
                End If
            End If
        Next
        If returnList = "0" Then
            returnList = pickupList
        End If
        ' get list of brands
        Dim brandList As String = ""
        For Each li As ListItem In BrandNameList.Items
            If li.Selected Then
                If brandList = "" Then
                    brandList = li.Value.ToString()
                Else
                    brandList = brandList & "," & li.Value.ToString()
                End If
            End If
        Next

        'insert data to database
        data.updateExceptionsPrices(fID, brandList, country, pickupList, returnList, OneWayRentals, startDate, endDate, priceChange, priceChangePercent, currency, priceChangeNote)

        'ClientScript.RegisterStartupScript(Me.GetType(), "AlertMessageBox", (pickupList & " " & returnList), True)
        'reload page
        Response.Redirect("/data/exceptions-prices-list.aspx")
    End Sub


    Sub updateBrandBoxes()
        Dim check As Integer = 0
        If Request.QueryString("id") > 0 Then 'check if id querystring exists and get data
            'get data
            Dim sqlDs As DataSet = data.Current.getExceptionsPricesByID(Request.QueryString("id"))
            sqlDr = sqlDs.Tables("PriceException").Rows(0)

            check = 1

        End If

        Dim selBrand As String = ""
        If Not IsDBNull(sqlDr("fPriceExceptionBrandID")) And Not (sqlDr("fPriceExceptionBrandID") = "") Then
            selBrand = sqlDr("fPriceExceptionBrandID")
        End If

        ' get list of brands
        Dim brandList As String = ""
        For Each li As ListItem In BrandNameList.Items
            If li.Selected Then
                If brandList = "" Then
                    brandList = li.Value.ToString()
                Else
                    brandList = brandList & ", " & li.Value.ToString()
                End If
            End If
        Next

        If Not brandList = "" Then
            selBrand = brandList
        End If

        BrandNameList.Items.Clear()
        'cbContainerBrands.Controls.Remove(BrandNameList)

        ' get country ID
        Dim websiteID As Integer = 0
        ' get country ID
        Dim countryID = ddlCountry.SelectedValue
        ' get brand list
        Dim sqlDsBrands As DataSet = data.Current.getListActiveBrands(websiteID, countryID)
        Dim sqlDtBrands As DataTable = sqlDsBrands.Tables(0)
        Dim sqlDrBrands As DataRow
        'add new check box for each item in the list
        For i As Integer = 0 To sqlDtBrands.Rows.Count - 1
            sqlDrBrands = sqlDtBrands.Rows(i)
            BrandNameList.Items.Add(New ListItem(sqlDrBrands("fBrandName"), sqlDrBrands("fID")))
        Next

        'select item if in select list
        If Not selBrand = "" Then
            Dim xB As Object
            Dim iB As Long
            xB = Split(selBrand, ", ")
            For iB = 0 To UBound(xB)
                If BrandNameList.Items.FindByValue(xB(iB)) IsNot Nothing Then
                    BrandNameList.Items.FindByValue(xB(iB)).Selected = True
                End If
            Next iB
        End If
        'add check box lists into place holder on page
        BrandNameList.RepeatDirection = RepeatDirection.Horizontal
        cbContainerBrands.Controls.Add(BrandNameList)

    End Sub

    Sub updateLocationBoxes()
        Dim check As Integer = 0
        If Request.QueryString("id") > 0 Then 'check if id querystring exists and get data
            'get data
            Dim sqlDs As DataSet = data.Current.getExceptionsPricesByID(Request.QueryString("id"))
            sqlDr = sqlDs.Tables("PriceException").Rows(0)

            check = 1

        End If

        Dim selPickUp As String = ""
        Dim selReturn As String = ""

        PickupLocationList.Items.Clear()
        ReturnLocationList.Items.Clear()
        'cbContainerPULocations.Controls.Clear()
        'cbContainerRLocations.Controls.Clear()

        ' get country ID
        Dim countryID = ddlCountry.SelectedValue
        ' get location list
        Dim sqlDsLocs As DataSet = data.Current.getListLocations(countryID)
        Dim sqlDtLocs As DataTable = sqlDsLocs.Tables(0)
        Dim sqlDrLocs As DataRow
        'add new check box for each item in the list
        For iLoc As Integer = 0 To sqlDtLocs.Rows.Count - 1
            sqlDrLocs = sqlDtLocs.Rows(iLoc)
            PickupLocationList.Items.Add(New ListItem(sqlDrLocs("fLocationName"), sqlDrLocs("fID")))
        Next
        'select item if in select list
        If check = 1 Then
            If Not IsDBNull(sqlDr("fPriceExceptionPickupLocationID")) And Not (sqlDr("fPriceExceptionPickupLocationID") = "") Then
                Dim txt As String = sqlDr("fPriceExceptionPickupLocationID").ToString()
                Dim x As Object
                Dim i As Long
                x = Split(txt, ", ")
                For i = 0 To UBound(x)
                    'PickupLocationList.SelectedIndex = x(i)
                    If PickupLocationList.Items.FindByValue(x(i)) IsNot Nothing Then
                        PickupLocationList.Items.FindByValue(x(i)).Selected = True
                    End If
                Next i
            End If
        End If
        'add check box lists into place holder on page
        PickupLocationList.RepeatDirection = RepeatDirection.Horizontal
        cbContainerPULocations.Controls.Add(PickupLocationList)

        ' get country ID
        countryID = ddlCountry.SelectedValue
        ' get location list
        sqlDsLocs = data.Current.getListLocations(countryID)
        sqlDtLocs = sqlDsLocs.Tables(0)
        'add new check box for each item in the list
        For iLoc As Integer = 0 To sqlDtLocs.Rows.Count - 1
            sqlDrLocs = sqlDtLocs.Rows(iLoc)
            ReturnLocationList.Items.Add(New ListItem(sqlDrLocs("fLocationName"), sqlDrLocs("fID")))
        Next
        If check = 1 Then
            If Not IsDBNull(sqlDr("fPriceExceptionReturnLocationID")) And Not (sqlDr("fPriceExceptionReturnLocationID") = "") Then
                Dim txt As String = sqlDr("fPriceExceptionReturnLocationID").ToString()
                Dim x As Object
                Dim i As Long
                x = Split(txt, ", ")
                For i = 0 To UBound(x)
                    'ReturnLocationList.SelectedIndex = x(i)
                    If ReturnLocationList.Items.FindByValue(x(i)) IsNot Nothing Then
                        ReturnLocationList.Items.FindByValue(x(i)).Selected = True
                    End If
                Next i
            End If
        End If
        'add check box lists into place holder on page
        ReturnLocationList.RepeatDirection = RepeatDirection.Horizontal
        cbContainerRLocations.Controls.Add(ReturnLocationList)

    End Sub


    'Protected Sub ddlMainWebsite_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)

    '    ' update other filters from main website choice
    '    Dim websiteID As Integer = 0

    '    ' update country, but keep current value if it is in the list
    '    Dim currentCountryID = ddlCountry.SelectedValue
    '    data.updateDDLCountryWithSelect(ddlCountry, websiteID)
    '    If ddlCountry.Items.FindByValue(currentCountryID) IsNot Nothing Then
    '        ddlCountry.SelectedValue = currentCountryID
    '    End If
    '    Dim countryID = ddlCountry.SelectedValue

    '    ' update brand
    '    'Dim currentBrandID = ddlBrand.SelectedValue
    '    'data.updateDDLBrandWithSelect(ddlBrand, websiteID, countryID)
    '    'If ddlBrand.Items.FindByValue(currentBrandID) IsNot Nothing Then
    '    '    ddlBrand.SelectedValue = currentBrandID
    '    'End If
    '    ' Dim brandID = ddlBrand.SelectedValue

    '    Call updateBrandBoxes()
    '    Call updateLocationBoxes()

    'End Sub

    Protected Sub ddlCountry_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)

        ' update other filters from main website choice
        Dim websiteID As Integer = 0
        Dim countryID = ddlCountry.SelectedValue

        ' update brand
        'Dim currentBrandID = ddlBrand.SelectedValue
        'ddlBrand.Items.Clear()
        'data.updateDDLBrandWithSelect(ddlBrand, websiteID, countryID)
        'If ddlBrand.Items.FindByValue(currentBrandID) IsNot Nothing Then
        '    ddlBrand.SelectedValue = currentBrandID
        'End If
        'Dim brandID = ddlBrand.SelectedValue

        Call updateBrandBoxes()
        Call updateLocationBoxes()
    End Sub

    'Protected Sub ddlBrand_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)

    '    ' update other filters from main website choice
    '    'Dim websiteID = ddlWebsite.SelectedValue
    '    'Dim countryID = ddlCountry.SelectedValue
    '    'Dim brandID = ddlBrand.SelectedValue

    '    Call updateLocationBoxes()
    'End Sub

End Class