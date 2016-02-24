Imports System.Data.SqlClient
Imports System.Configuration

Public Class dates
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
        End If
    End Sub

    Private Sub getdata()
        'get list of brand exceptions and fill data table
        Dim DsDateExceptions As DataSet = New DataSet
        DsDateExceptions = data.Current.getListExceptionsDates()
        If DsDateExceptions.Tables("DateExceptions").Rows.Count > 0 Then
            GVDates.DataSource = DsDateExceptions.Tables("DateExceptions")
            GVDates.DataBind()
        Else
            ClientScript.RegisterStartupScript(Me.GetType(), "AlertMessageBox", "alert('All Dates correct.');", True)
        End If
    End Sub

    Protected Sub btnCheckExceptions_click(ByVal sender As Object, ByVal e As EventArgs)
        getdata()
    End Sub

    Protected Sub GVDates_RowDataBound(sender As Object, e As GridViewRowEventArgs)
    End Sub

    Protected Sub btnIssueResolved_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim gvRow As GridViewRow = CType(CType(sender, Control).Parent.Parent, GridViewRow)

        If gvRow.RowType = DataControlRowType.DataRow Then
            Dim pickupdate As Date = DateTime.Parse(gvRow.Cells(2).Text.ToString()).ToString("yyyy-MM-dd")
            Dim returndate As Date = DateTime.Parse(gvRow.Cells(3).Text.ToString()).ToString("yyyy-MM-dd")
            'execute stored procedure to mark date issues as resolved
            data.updateExceptionsDates(pickupdate, returndate)
        End If

        getdata()
    End Sub

End Class