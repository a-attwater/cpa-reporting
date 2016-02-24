﻿Public Class CPA_users_edit
    Inherits System.Web.UI.Page

    Public lit As New Literal()

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        Dim sqlPagesDs As DataSet = admin.pagesSelList()
        Dim pageCount = sqlPagesDs.Tables("pages").Rows.Count

        If pageCount > 0 Then
            lit = New Literal()
            lit.Text = "<ul id='pageList'>" & vbCrLf
            pageHolder.Controls.Add(lit)

            Dim first As Boolean = True
            For x As Int32 = 0 To pageCount - 1
                Dim sqlPageDR As DataRow = sqlPagesDs.Tables("pages").Rows(x)

                lit = New Literal()
                lit.Text = "<li class='parent-page'><div class='page-actions'><a href='#' class='toggleSubPages visible'><span>Show</span> sub pages</a> " & vbCrLf
                pageHolder.Controls.Add(lit)

                Dim checkBox As New CheckBox
                checkBox.ID = "page" & sqlPageDR("fldID")
                checkBox.Attributes("value") = sqlPageDR("fldID")
                checkBox.CssClass = "parentToggle parentPage" & sqlPageDR("fldID")
                checkBox.Text = sqlPageDR("fldID")
                pageHolder.Controls.Add(checkBox)

                lit = New Literal()
                lit.Text = "</div> <strong>" & sqlPageDR("fldName") & "</strong>" & vbCrLf
                pageHolder.Controls.Add(lit)

                'get sub pages
                Dim sqlSubPagesDs As DataSet = admin.pagesSelSubPages(sqlPageDR("fldID"))
                Dim subPageCount = sqlSubPagesDs.Tables("pages").Rows.Count

                'lit = New Literal()
                'lit.Text = "page count: " & subPageCount & vbCrLf
                'pageHolder.Controls.Add(lit)

                If subPageCount > 0 Then

                    lit = New Literal()
                    lit.Text = "<ul class='subPageList'>" & vbCrLf
                    pageHolder.Controls.Add(lit)

                    For y As Int32 = 0 To subPageCount - 1
                        Dim sqlSubPageDR As DataRow = sqlSubPagesDs.Tables("pages").Rows(y)

                        lit = New Literal()
                        lit.Text = "<li><div class='page-actions'>" & vbCrLf
                        pageHolder.Controls.Add(lit)

                        Dim subCheckBox As New CheckBox
                        subCheckBox.ID = "page" & sqlSubPageDR("fldID")
                        subCheckBox.Attributes("value") = sqlSubPageDR("fldID")
                        subCheckBox.CssClass = "pageToggle subPage" & sqlPageDR("fldID")
                        subCheckBox.Text = sqlSubPageDR("fldID")
                        subCheckBox.ToolTip = sqlPageDR("fldID")
                        pageHolder.Controls.Add(subCheckBox)

                        lit = New Literal()
                        lit.Text = "</div> " & sqlSubPageDR("fldName") & "</li>" & vbCrLf
                        pageHolder.Controls.Add(lit)
                    Next

                    lit = New Literal()
                    lit.Text = "</ul>" & vbCrLf
                    pageHolder.Controls.Add(lit)
                End If

                lit = New Literal()
                lit.Text = "</li>" & vbCrLf
                pageHolder.Controls.Add(lit)

            Next

            lit = New Literal()
            lit.Text = "</ul>" & vbCrLf
            pageHolder.Controls.Add(lit)
        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' get user details
        If Not Page.IsPostBack Then
            Dim sqlDs As DataSet = admin.usersSel(Request.QueryString("id"))
            If sqlDs.Tables("user").Rows.Count > 0 Then
                Dim sqlDR As DataRow = sqlDs.Tables("user").Rows(0)

                txtUsername.Text = sqlDR("fldUserName")
                txtPassword.Text = sqlDR("fldPWD")
                If Not IsDBNull(sqlDR("fldName")) Then
                    txtName.Text = sqlDR("fldName")
                End If
                If Not IsDBNull(sqlDR("fldEmail")) Then
                    txtEmail.Text = sqlDR("fldEmail")
                End If
                chkAdmin.Checked = sqlDR("fldAdmin")
                chkActive.Checked = sqlDR("fldActive")
            End If

            'get page access details
            Dim sqlPagesDs As DataSet = admin.usersPagesSel(Request.QueryString("id"))
            If sqlPagesDs.Tables("userPages").Rows.Count > 0 Then

                For x As Int32 = 0 To sqlPagesDs.Tables("userPages").Rows.Count - 1
                    Dim sqlDR As DataRow = sqlPagesDs.Tables("userPages").Rows(x)

                    Dim checkbox As CheckBox = pageHolder.FindControl("page" & sqlDR("fldPageID"))
                    checkbox.Checked = True
                Next
            End If
        End If


    End Sub

    Protected Sub btnConfirm_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConfirm.Click
        'save user details
        admin.usersUpdate(Request.QueryString("id"), txtUsername.Text, txtPassword.Text, txtName.Text, txtEmail.Text, chkAdmin.Checked, chkActive.Checked)

        'save the page access
        'first delete existing rows
        admin.usersPagesDelete(Request.QueryString("id"))

        Dim ctrl As Control
        For Each ctrl In pageHolder.Controls
            If (ctrl.GetType() Is GetType(CheckBox)) Then
                Dim checkBox As CheckBox = CType(ctrl, CheckBox)

                If checkBox.Checked Then
                    admin.usersPagesInsert(Request.QueryString("id"), checkBox.Text)
                End If
            End If
        Next
    End Sub

End Class