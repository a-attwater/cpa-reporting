Public Class CPA_pages
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub GVArticle_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles pages.RowDataBound
        ' Check if row is data row
        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.Cells.Count > 1 Then
                Dim strValue As String = e.Row.Cells(0).Text
                If strValue > 0 Then
                    e.Row.CssClass = "sub-page"
                End If
            End If
        End If
    End Sub

End Class