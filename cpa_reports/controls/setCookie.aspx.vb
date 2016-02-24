Public Class setCookie
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Create a new cookie, passing the name into the constructor
        Dim cookie As New HttpCookie(Request.QueryString("cookieName"))

        'Set the cookies value
        cookie.Value = Request.QueryString("cookieValue")

        'Set the cookie to expire in the defined amount of days
        Dim dtNow As DateTime = DateTime.Now
        Dim tsMinute As New TimeSpan(0, 0, Request.QueryString("cookieMinutes"), 0)
        cookie.Expires = dtNow.Add(tsMinute)

        'Add the cookie
        Response.Cookies.Add(cookie)
    End Sub

End Class