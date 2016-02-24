Imports System.Data.SqlClient
Imports System.Configuration

Public Class exceptions_countries
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
        End If

    End Sub

    Protected Sub GVCountries_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim ddl = TryCast(e.Row.FindControl("ddlCountryAlias"), DropDownList)
            If ddl IsNot Nothing Then
                data.initDDlCountry(ddl)
            End If
        End If
    End Sub

    Private Sub getdata()
        'get list of Country exceptions and fill data table
        Dim DsCountryExceptions As DataSet = New DataSet
        DsCountryExceptions = data.Current.getListExceptionsCountries()
        If DsCountryExceptions.Tables("CountryExceptions").Rows.Count > 0 Then
            GVCountries.DataSource = DsCountryExceptions.Tables("CountryExceptions")
            GVCountries.DataBind()
        Else
            ClientScript.RegisterStartupScript(Me.GetType(), "AlertMessageBox", "alert('No unknown countries');", True)
        End If

        'If DsCountryExceptions.Tables.Count <= 0 Or DsCountryExceptions.Tables("CountryExceptions").Rows.Count <= 0 Then
        '    ClientScript.RegisterStartupScript(Me.GetType(), "AlertMessageBox", "alert('No unknown countries');", True)
        'End If
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
            Dim idType As Integer = 0

            Dim ddlCountryAlias = TryCast(gvRow.FindControl("ddlCountryAlias"), DropDownList)
            Dim fID As String = GVCountries.Rows(index).Cells(0).Text
            Dim fType As String = GVCountries.Rows(index).Cells(1).Text

            'execute stored procedure to add Country alias
            Integer.TryParse(ddlCountryAlias.SelectedValue, idAccepted)
            Integer.TryParse(fID, idUnknown)
            Integer.TryParse(fType, idType)
            data.updateExceptionsCountries(idUnknown, idAccepted, idType)


        End If

        getdata()

    End Sub

    Protected Sub btnDeleteData_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim gvRow As GridViewRow = CType(CType(sender, Control).Parent.Parent, GridViewRow)
        Dim index As Integer = gvRow.RowIndex

        If gvRow.RowType = DataControlRowType.DataRow Then
            Dim idUnknown As Integer = 0

            Dim ddlCountryAlias = TryCast(gvRow.FindControl("ddlCountryAlias"), DropDownList)
            Dim fID As String = GVCountries.Rows(index).Cells(0).Text

            'execute stored procedure to delete line of data
            Integer.TryParse(fID, idUnknown)
            data.deleteData(idUnknown)

            getdata()

        End If


    End Sub
End Class