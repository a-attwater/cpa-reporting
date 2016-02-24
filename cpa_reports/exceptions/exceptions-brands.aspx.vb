Imports System.Data.SqlClient
Imports System.Configuration

Public Class brands
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
        End If

    End Sub

    Private Sub getdata()
        'get list of brand exceptions and fill data table
        Dim DsBrandExceptions As DataSet = New DataSet
        DsBrandExceptions = data.Current.getListExceptionsBrands()
        GVBrands.DataSource = DsBrandExceptions.Tables("BrandExceptions")
        GVBrands.DataBind()

        If DsBrandExceptions.Tables.Count <= 0 Or DsBrandExceptions.Tables("BrandExceptions").Rows.Count <= 0 Then
            ClientScript.RegisterStartupScript(Me.GetType(), "AlertMessageBox", "alert('No unknown brands');", True)
        End If
    End Sub

    Protected Sub btnCheckExceptions_click(ByVal sender As Object, ByVal e As EventArgs)
        getdata()
    End Sub

    Protected Sub GVBrands_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim ddl = TryCast(e.Row.FindControl("ddlBrandAlias"), DropDownList)
            If ddl IsNot Nothing Then
                data.initDDlBrandAll(ddl)
            End If
            Dim ddlInactive = TryCast(e.Row.FindControl("ddlBrandInactiveAlias"), DropDownList)
            If ddlInactive IsNot Nothing Then
                data.initDDlBrandInactive(ddlInactive)
            End If
        End If
    End Sub

    Protected Sub btnSetAlias_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim gvRow As GridViewRow = CType(CType(sender, Control).Parent.Parent, GridViewRow)
        Dim index As Integer = gvRow.RowIndex

        If gvRow.RowType = DataControlRowType.DataRow Then
            Dim idUnknown As Integer = 0
            Dim idAccepted As Integer = 0

            Dim ddlBrandAlias = TryCast(gvRow.FindControl("ddlBrandAlias"), DropDownList)
            Dim fID As String = GVBrands.Rows(index).Cells(0).Text

            'execute stored procedure to add brand alias
            Integer.TryParse(ddlBrandAlias.SelectedValue, idAccepted)
            Integer.TryParse(fID, idUnknown)
            data.updateExceptionsBrands(idUnknown, idAccepted)

        End If

        getdata()

    End Sub

    Protected Sub btnSetInactiveAlias_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim gvRow As GridViewRow = CType(CType(sender, Control).Parent.Parent, GridViewRow)
        Dim index As Integer = gvRow.RowIndex

        If gvRow.RowType = DataControlRowType.DataRow Then
            Dim idUnknown As Integer = 0
            Dim idAccepted As Integer = 0

            Dim ddlBrandAlias = TryCast(gvRow.FindControl("ddlBrandInactiveAlias"), DropDownList)
            Dim fID As String = GVBrands.Rows(index).Cells(0).Text

            'execute stored procedure to add brand alias
            Integer.TryParse(ddlBrandAlias.SelectedValue, idAccepted)
            Integer.TryParse(fID, idUnknown)
            data.updateExceptionsBrands(idUnknown, idAccepted)

        End If

        getdata()

    End Sub

    Protected Sub btnAddBrand_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim gvRow As GridViewRow = CType(CType(sender, Control).Parent.Parent, GridViewRow)
        Dim index As Integer = gvRow.RowIndex

        If gvRow.RowType = DataControlRowType.DataRow Then
            Dim idUnknown As Integer = 0
            Dim fID As String = GVBrands.Rows(index).Cells(0).Text

            'execute stored procedure to add brand alias
            Integer.TryParse(fID, idUnknown)
            data.updateExceptionsBrandsAddBrand(idUnknown, 1)

        End If

        getdata()

    End Sub


    Protected Sub btnAddInactiveBrand_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim gvRow As GridViewRow = CType(CType(sender, Control).Parent.Parent, GridViewRow)
        Dim index As Integer = gvRow.RowIndex

        If gvRow.RowType = DataControlRowType.DataRow Then
            Dim idUnknown As Integer = 0
            Dim fID As String = GVBrands.Rows(index).Cells(0).Text

            'execute stored procedure to add brand alias
            Integer.TryParse(fID, idUnknown)
            data.updateExceptionsBrandsAddBrand(idUnknown, 0)

        End If

        getdata()

    End Sub


End Class