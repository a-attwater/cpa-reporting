Imports System.IO
Imports System.Data
Imports System.Data.OleDb

Partial Class _500
    Inherits System.Web.UI.Page
    Protected Sub Page_PreLoad(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreLoad

        ' Display a generic error message
        Server.ClearError()
        Response.StatusCode = 500

        Response.TrySkipIisCustomErrors = True
    End Sub

End Class