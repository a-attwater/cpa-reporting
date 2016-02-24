<%@ Page Language="VB" MasterPageFile="~/Report.master" AutoEventWireup="false" validateRequest="false" title="CPA Pages" CodeBehind="cms-pages.aspx.vb" Inherits="cpa_reports.CPA_pages" %>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
    <div class="buttons">
        <a href="cms-pages-add.aspx" class="add"><img src="../graphics/icon-add-white.png" /> Add Page</a>
        <div class="clear"></div>
    </div>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
<asp:ScriptManager ID="s1" runat="server" />

<asp:HiddenField ID="isExport" runat="server" Value="0" />

<h1>CPA Pages</h1>

    <asp:GridView ID="pages" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" CssClass="table-list" 
        EmptyDataText="No Available Items" PageSize="500" 
        Width="610px" DataSourceID="sqlsource1" DataKeyNames="fldID">
        <AlternatingRowStyle CssClass="odd" />
        <Columns>
            <asp:BoundField DataField="fldParentID" HeaderStyle-CssClass="hidden" ItemStyle-CssClass="hidden" 
                SortExpression="fldParentID" ReadOnly="true"/>
            <asp:BoundField DataField="fldName" HeaderText="Page Name" 
                SortExpression="fldName" ItemStyle-CssClass="sub-page" />
            <asp:BoundField DataField="fldURL" HeaderText="Page URL" 
                SortExpression="fldURL" />

            <asp:TemplateField HeaderStyle-Width="80">
                <ItemTemplate>
                    <a href='<%# String.Format("cms-pages-edit.aspx?id={0}", Eval("fldID"))%>' class="btn-link add-link">Add/Remove sub pages</a>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:CommandField ShowEditButton="True" ControlStyle-CssClass="btn-link edit-link" ItemStyle-Width="60" />
            <asp:CommandField ShowDeleteButton="True" ControlStyle-CssClass="btn-link delete-link" ItemStyle-Width="60" />
        </Columns>
        <EmptyDataRowStyle Font-Bold="true" />

    </asp:GridView>
    <asp:SqlDataSource ID="sqlsource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:ConnString1 %>" 
        SelectCommand="pagesSelList" SelectCommandType="StoredProcedure" 
        UpdateCommand="pagesUpdate" UpdateCommandType="StoredProcedure"
        DeleteCommand="pagesDelete" DeleteCommandType="StoredProcedure">
        <UpdateParameters>
            <asp:Parameter Name="fldID" Type="Int32" />
            <asp:Parameter Name="fldName" Type="String" />
            <asp:Parameter Name="fldURL" Type="String" />
        </UpdateParameters>
        <DeleteParameters>
            <asp:Parameter Name="fldID" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <script type="text/javascript">

        $(function () {
            $('a.delete-link').click(function () {
                var trigger = $(this);
                if (!confirm("Are you sure you want to delete this page?")) {
                    return false;
                }
            });
        });
    </script>
</asp:Content>