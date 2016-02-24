Public Class exceptions_prices_list
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            'get list of brand exceptions and fill data table
            Dim DsPriceExceptions As DataSet = New DataSet
            DsPriceExceptions = data.Current.getListExceptionsPrices()
            GVPrices.DataSource = DsPriceExceptions.Tables("PriceExceptions")
            GVPrices.DataBind()
        End If

    End Sub

    Protected Sub btnUpdateException_Click(ByVal sender As Object, ByVal e As EventArgs)
        'get row
        Dim gvRow As GridViewRow = CType(CType(sender, Control).Parent.Parent, GridViewRow)
        Dim index As Integer = gvRow.RowIndex
        If gvRow.RowType = DataControlRowType.DataRow Then
            ' get row ID
            Dim idUpdate As Integer = 0
            Integer.TryParse(GVPrices.Rows(index).Cells(0).Text, idUpdate)
            ' redirect to update page
            Response.Redirect("/data/exceptions-prices-update.aspx?id=" & idUpdate)
        End If
    End Sub

    Protected Sub btnDeleteException_Click(ByVal sender As Object, ByVal e As EventArgs)
        'get row
        Dim gvRow As GridViewRow = CType(CType(sender, Control).Parent.Parent, GridViewRow)
        Dim index As Integer = gvRow.RowIndex
        If gvRow.RowType = DataControlRowType.DataRow Then
            ' get exception ID
            Dim fID As Integer = 0
            Integer.TryParse(GVPrices.Rows(index).Cells(0).Text, fID)
            ' get website
            'Dim websiteIndex As Integer = GetColumnIndexByName(gvRow, "fURL")
            'Dim websiteValue As String = GVPrices.Rows(index).Cells(websiteIndex).Text
            'execute stored procedure to add brand alias
            data.deleteExceptionsPrices(fID)
            'reload page
            Response.Redirect(Request.RawUrl)
        End If
    End Sub

    'Private Function GetColumnIndexByName(row As GridViewRow, columnName As String) As Integer
    '    Dim columnIndex As Integer = 0
    '    For Each cell As DataControlFieldCell In row.Cells
    '        If TypeOf cell.ContainingField Is BoundField Then
    '            If DirectCast(cell.ContainingField, BoundField).DataField.Equals(columnName) Then
    '                Exit For
    '            End If
    '        End If
    '        ' keep adding 1 while we don't have the correct name
    '        columnIndex += 1
    '    Next
    '    Return columnIndex
    'End Function


    Protected Sub btnAddException_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' go to add exceptions page
        Response.Redirect("/data/exceptions-prices-add.aspx")
    End Sub

    Protected Sub GVPrices_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim pickUpDate As String = e.Row.Cells(7).Text
            Dim returnDate As String = e.Row.Cells(8).Text

            pickUpDate = pickUpDate.Substring(pickUpDate.Length - 2)
            returnDate = returnDate.Substring(returnDate.Length - 2)

            Dim PickupYear As Integer = Convert.ToInt32(pickUpDate)
            Dim ReturnYear As Integer = Convert.ToInt32(returnDate)

            Dim acceptableDateRange As DateTime = DateTime.Now
            acceptableDateRange = acceptableDateRange.AddYears(30)
            Dim acceptableDateStr As String = acceptableDateRange.Year.ToString()
            acceptableDateStr = acceptableDateStr.Substring(acceptableDateStr.Length - 2)

            Dim acceptableYear As Integer = Convert.ToInt32(acceptableDateStr)

            If Not (String.IsNullOrEmpty(pickUpDate) Or pickUpDate = "") Then
                If PickupYear > acceptableYear Then
                    e.Row.Cells(7).Text = ""
                End If
            End If
            If Not (String.IsNullOrEmpty(returnDate) Or returnDate = "") Then
                If ReturnYear > acceptableYear Then
                    e.Row.Cells(8).Text = ""
                End If
            End If
        End If
    End Sub


End Class