Imports System.IO
Imports System.Data
Imports System.Data.OleDb

Partial Class _404
    Inherits System.Web.UI.Page
    Protected Sub Page_PreLoad(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreLoad

        ' Display a generic error message
        Server.ClearError()
        Response.StatusCode = 404

        Response.TrySkipIisCustomErrors = True
    End Sub

End Class