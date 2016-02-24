Public Class CPA_pages_edit
    Inherits System.Web.UI.Page

    Public lit As New Literal()

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        'add a bunch of input fields to use for the conditions initially only showing hte first one. This is easier then adding a whole bunch on the page...
        For z As Int32 = 0 To 20 'hopefully 50 will be enough...
            lit = New Literal()
            If z > 0 Then
                lit.Text = "<div class='sub-input hidden'><a href='#' class='btn-link delete-link right'>Delete page</a><div class='form-element input'><label>Page Name:</label>" & vbCrLf
            Else
                lit.Text = "<div class='sub-input'><a href='#' class='btn-link delete-link right'>Delete page</a><div class='form-element input'><label>Page Name:</label>" & vbCrLf
            End If
            subHolder.Controls.Add(lit)

            'create a new textbox and add it to the conditions placeholder
            Dim textBox As New TextBox
            textBox.ID = "txtPageName" & z
            subHolder.Controls.Add(textBox)

            lit = New Literal()
            lit.Text = "</div><div class='form-element input'><label>Page URL:</label>" & vbCrLf
            subHolder.Controls.Add(lit)

            'create a new textbox and add it to the conditions placeholder
            Dim textBox2 As New TextBox
            textBox2.ID = "txtPageURL" & z
            subHolder.Controls.Add(textBox2)

            Dim hiddenField As New HiddenField
            hiddenField.ID = "txtPageID" & z
            subHolder.Controls.Add(hiddenField)

            lit = New Literal()
            lit.Text = "</div></div>" & vbCrLf
            subHolder.Controls.Add(lit)
        Next
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            txtSection.Text = admin.pagesGetName(Request.QueryString("id"))

            Dim sqlPagesDs As DataSet = admin.pagesSelSubPages(Request.QueryString("id"))
            Dim pagesCount As Integer = sqlPagesDs.Tables("pages").Rows.Count

            For x As Int32 = 0 To pagesCount - 1
                Dim sqlPageDR As DataRow = sqlPagesDs.Tables("pages").Rows(x)

                Dim textboxName As TextBox = subHolder.FindControl("txtPageName" & x)
                Dim textboxURL As TextBox = subHolder.FindControl("txtPageURL" & x)
                Dim hiddenField As HiddenField = subHolder.FindControl("txtPageID" & x)

                textboxName.Text = sqlPageDR("fldName")
                textboxURL.Text = sqlPageDR("fldURL")
                hiddenField.Value = sqlPageDR("fldID")
            Next
        End If
    End Sub

    Protected Sub btnConfirm_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConfirm.Click
        'update section name
        admin.pagesUpdate(Request.QueryString("id"), txtSection.Text, "#")

        'save the sub pages
        For z As Int32 = 0 To 20
            Dim textboxName As TextBox = subHolder.FindControl("txtPageName" & z)
            Dim textboxURL As TextBox = subHolder.FindControl("txtPageURL" & z)
            Dim hiddenField As HiddenField = subHolder.FindControl("txtPageID" & z)

            If Not hiddenField.Value = "" Then
                admin.pagesUpdate(hiddenField.Value, textboxName.Text, textboxURL.Text)
            Else
                If Not textboxName.Text = "" And Not textboxURL.Text = "" Then
                    admin.pagesAdd(textboxName.Text, textboxURL.Text, Request.QueryString("id"))
                End If
            End If
        Next

        Response.Redirect("cms-pages-edit.aspx?id=" & Request.QueryString("id"))
    End Sub

End Class