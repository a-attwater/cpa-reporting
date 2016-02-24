
Public Class exceptions_duplicates
    Inherits System.Web.UI.Page

    Public sqlDr As DataRow
    Dim DsWebsites As DataSet = New DataSet

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            DsWebsites = data.Current.getListExceptionsDuplicates()
            If DsWebsites.Tables.Count > 0 Then

                If Not DsWebsites.Tables("DataExceptions").Rows.Count > 0 Then
                    lblDateRangeChecked.Text = "N/A"
                    lblDateCountChecked.Text = "N/A"
                    lblDuplicateCount.Text = "N/A"
                Else
                    sqlDr = DsWebsites.Tables("DataExceptions").Rows(0)
                    lblDateRangeChecked.Text = sqlDr("fDateRange")
                    lblDateCountChecked.Text = sqlDr("fDataCount")
                    lblDuplicateCount.Text = sqlDr("fDuplicates")
                End If
            End If

            If DsWebsites.Tables.Count <= 0 Or DsWebsites.Tables("DataExceptions").Rows.Count <= 0 Then
                ClientScript.RegisterStartupScript(Me.GetType(), "AlertMessageBox", "alert('No duplicates');", True)
            End If
        End If
    End Sub

    'Protected Sub btnDeleteDuplicates_Click(ByVal sender As Object, ByVal e As EventArgs)
    '    Dim addedDataCount As Integer = 0
    '    addedDataCount = data.addDataClean()
    '    lblDataAddedCount.Text = addedDataCount.ToString + " items added."

    'End Sub

End Class