Public Class exceptions_counts
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LVCounts.DataSource = ""
            LVCounts.DataBind()
        End If
    End Sub

    Private Sub getData()
        'get data and fill data table
        Dim DsData As DataSet = New DataSet
        DsData = data.Current.getListExceptionsCounts()
        LVCounts.DataSource = DsData.Tables("DataCounts")
        If DsData.Tables("DataCounts").Rows.Count > 0 Then
            LVCounts.DataBind()
        Else
            ClientScript.RegisterStartupScript(Me.GetType(), "AlertMessageBox", "alert('No Data found');", True)
        End If
    End Sub

    Protected Sub btnCheckWksData_Click(ByVal sender As Object, ByVal e As EventArgs)
        'get data and fill data table
        Dim DsData As DataSet = New DataSet
        DsData = data.Current.checkForData(DateTime.Now)
        LVthisWeeksData.DataSource = DsData.Tables("DataCounts")
        If DsData.Tables("DataCounts").Rows.Count > 0 Then
            LVthisWeeksData.DataBind()
        Else
            ClientScript.RegisterStartupScript(Me.GetType(), "AlertMessageBox", "alert('No Data found');", True)
        End If
    End Sub

    Protected Sub btnGetWklyDataCounts_Click(ByVal sender As Object, ByVal e As EventArgs)
        getData()
    End Sub



End Class