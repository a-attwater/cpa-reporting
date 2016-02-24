<%@ Page ContentType="application/x-javascript" ResponseEncoding="utf-8" %>
<%@ Import Namespace="System.IO" %>

<%
    'Create a new cookie, passing the name into the constructor
    Dim cookie As New HttpCookie(Request.QueryString("cookieName"))

    'Set the cookies value
    cookie.Value = Request.QueryString("cookieValue")

    'Set the cookie to expire in the defined amount of days
    Dim dtNow As DateTime = DateTime.Now
    Dim tsMinute As New TimeSpan(Request.QueryString("cookieDays"), 0, 0, 0)
    cookie.Expires = dtNow.Add(tsMinute)

    'Add the cookie
    Response.Cookies.Add(cookie)
%>