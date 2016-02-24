Imports System.Data.SqlClient
Imports System.Configuration

Public Class exceptions_locations
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            
        End If
    End Sub

    Protected Sub GVLocations_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim ddl = TryCast(e.Row.FindControl("ddlLocationAlias"), DropDownList)
            If ddl IsNot Nothing Then
                data.initDDlLocation(ddl, 0)
            End If
        End If
    End Sub

    Private Sub getdata()
        'get list of Location exceptions and fill data table
        Dim DsLocationExceptions As DataSet = New DataSet
        DsLocationExceptions = data.Current.getListExceptionsLocations()
        GVLocations.DataSource = DsLocationExceptions.Tables("LocationExceptions")
        GVLocations.DataBind()

        If DsLocationExceptions.Tables.Count <= 0 Or DsLocationExceptions.Tables("LocationExceptions").Rows.Count <= 0 Then
            ClientScript.RegisterStartupScript(Me.GetType(), "AlertMessageBox", "alert('No unknown locations');", True)
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
            Dim idType As Integer = 0

            Dim ddlLocationAlias = TryCast(gvRow.FindControl("ddlLocationAlias"), DropDownList)
            Dim fID As String = GVLocations.Rows(index).Cells(0).Text
            Dim fType As String = GVLocations.Rows(index).Cells(1).Text

            'execute stored procedure to add Location alias
            Integer.TryParse(ddlLocationAlias.SelectedValue, idAccepted)
            Integer.TryParse(fID, idUnknown)
            Integer.TryParse(fType, idType)
            data.updateExceptionsLocations(idUnknown, idAccepted, idType)

        End If
        getdata()
    End Sub

    Protected Sub btnDeleteData_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim gvRow As GridViewRow = CType(CType(sender, Control).Parent.Parent, GridViewRow)
        Dim index As Integer = gvRow.RowIndex

        If gvRow.RowType = DataControlRowType.DataRow Then
            Dim idUnknown As Integer = 0
            Dim ddlLocationAlias = TryCast(gvRow.FindControl("ddlLocationAlias"), DropDownList)
            Dim fID As String = GVLocations.Rows(index).Cells(0).Text
            'execute stored procedure to delete line of data
            Integer.TryParse(fID, idUnknown)
            data.deleteData(idUnknown)
        End If

        getdata()
    End Sub
End Class