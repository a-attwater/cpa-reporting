Public Class CPA_pages_add
    Inherits System.Web.UI.Page

    Public lit As New Literal()

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        'add a bunch of input fields to use for the conditions initially only showing hte first one. This is easier then adding a whole bunch on the page...
        For z As Int32 = 0 To 20 'hopefully 50 will be enough...
            lit = New Literal()
            If z > 0 Then
                lit.Text = "<div class='sub-input hidden'><div class='form-element input'><label>Page Name:</label>" & vbCrLf
            Else
                lit.Text = "<div class='sub-input'><div class='form-element input'><label>Page Name:</label>" & vbCrLf
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

            lit = New Literal()
            lit.Text = "</div></div>" & vbCrLf
            subHolder.Controls.Add(lit)
        Next
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            admin.initPagesDDL(ddlPages)
        End If

    End Sub

    Protected Sub btnConfirm_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConfirm.Click
        Dim intParentID As Integer

        If ddlPages.SelectedValue > 0 Then
            intParentID = ddlPages.SelectedValue
        Else
            intParentID = admin.pagesAdd(txtSection.Text, "#", 0)
        End If


        'save the sub values
        For z As Int32 = 0 To 20
            Dim textboxName As TextBox = subHolder.FindControl("txtPageName" & z)
            Dim textboxURL As TextBox = subHolder.FindControl("txtPageURL" & z)

            If Not textboxName.Text = "" And Not textboxURL.Text = "" Then
                admin.pagesAdd(textboxName.Text, textboxURL.Text, intParentID)
            End If
        Next

        Response.Redirect("cms-pages.aspx")
    End Sub

End Class