<%@ Page ContentType="application/x-javascript" ResponseEncoding="utf-8" %>
<%@ Import Namespace="System.IO" %>
<%-- Setting the content type of this page to application/x-javascript tells the browser to render this page as javascript. But since this is still a .aspx page, we can still use VB code to interact with the server. Very tricky! This means we can add this file onto any page on any url in the <script src=''> tag, and can pass data in the querystring, and this page will still be able to interact with the server from the original domain it's hosted on, www.apollocamper.com. CROSS DOMAIN COOKIES!!! --%>

window.onload = function(){
    <% 
        'Grab the cookie
        Dim cookie As HttpCookie = Request.Cookies(Request.QueryString("cookieName"))
        Dim strCookieValue As String = ""
        
        'Check to make sure the cookie exists
        If Not cookie Is Nothing Then
            'Write the cookie value
            strCookieValue = cookie.Value.ToString()
    %>
        $('#PartnerCode').val('<%= strCookieValue %>'); //set the cookie value to the PartnerCode hidden field in the booking form. now when a booking is done, it will use this partner code.
        if(console){
            console.log($('#PartnerCode').val());
        }
    <%
        End If
    %>
}