Imports System.Data.SqlClient
Imports System.Configuration

Public Class exceptions_currencies
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
           
        End If
    End Sub

    Protected Sub GVCurrencies_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim ddl = TryCast(e.Row.FindControl("ddlCurrencyAlias"), DropDownList)
            If ddl IsNot Nothing Then
                'get list of accepted Currency and fill drop down lists.
                Dim DsCurrencies As DataSet = New DataSet
                DsCurrencies = data.Current.getListCurrencies()
                ddl.DataSource = DsCurrencies.Tables("Currencies")
                ddl.DataValueField = "fID"
                ddl.DataTextField = "fCurrencyName"
                ddl.DataBind()
            End If
        End If
    End Sub

    Private Sub getdata()
        'get list of Currency exceptions and fill data table
        Dim DsCurrencyExceptions As DataSet = New DataSet
        DsCurrencyExceptions = data.Current.getListExceptionsCurrencies()
        GVCurrencies.DataSource = DsCurrencyExceptions.Tables("CurrencyExceptions")
        GVCurrencies.DataBind()

        If DsCurrencyExceptions.Tables.Count <= 0 Or DsCurrencyExceptions.Tables("CurrencyExceptions").Rows.Count <= 0 Then
            ClientScript.RegisterStartupScript(Me.GetType(), "AlertMessageBox", "alert('No unknown currencies');", True)
        End If
    End Sub

    Protected Sub btnCheckExceptions_click(ByVal sender As Object, ByVal e As EventArgs)
        getdata()
    End Sub

    Protected Sub btnSetAlias_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim gvRow As GridViewRow = CType(CType(sender, Control).Parent.Parent, GridViewRow)
        Dim index As Integer = gvRow.RowIndex

        If gvRow.RowType = DataControlRowType.DataRow Then
            Dim idUnknown As Integer = 0
            Dim idAccepted As Integer = 0
            Dim ddlCurrencyAlias = TryCast(gvRow.FindControl("ddlCurrencyAlias"), DropDownList)
            Dim fID As String = GVCurrencies.Rows(index).Cells(0).Text

            'execute stored procedure to add Currency alias
            Integer.TryParse(ddlCurrencyAlias.SelectedValue, idAccepted)
            Integer.TryParse(fID, idUnknown)
            data.updateExceptionsCurrencies(idUnknown, idAccepted)
        End If

        getdata()
    End Sub

    Protected Sub btnDeleteData_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim gvRow As GridViewRow = CType(CType(sender, Control).Parent.Parent, GridViewRow)
        Dim index As Integer = gvRow.RowIndex

        If gvRow.RowType = DataControlRowType.DataRow Then
            Dim idUnknown As Integer = 0
            Dim fID As String = GVCurrencies.Rows(index).Cells(0).Text
            'execute stored procedure to delete line of data
            Integer.TryParse(fID, idUnknown)
            data.deleteData(idUnknown)
        End If

        getdata()
    End Sub

End Class