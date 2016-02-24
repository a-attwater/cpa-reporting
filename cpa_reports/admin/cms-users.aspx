<%@ Page Language="VB" MasterPageFile="~/Report.master" AutoEventWireup="false" validateRequest="false" title="CPA Users" CodeBehind="cms-users.aspx.vb" Inherits="cpa_reports.CPA_users" %>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
    <div class="buttons">
        <a href="cms-users-add.aspx" class="add"><img src="../graphics/icon-add-white.png" /> Add User</a>
        <div class="clear"></div>
    </div>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
<asp:ScriptManager ID="s1" runat="server" />

<asp:HiddenField ID="isExport" runat="server" Value="0" />

<h1>CPA Users</h1>

    <asp:GridView ID="users" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" CssClass="table-list" 
        EmptyDataText="No Available Items" PageSize="500" 
        Width="610px" DataSourceID="sqlsource1" DataKeyNames="fldID">
        <AlternatingRowStyle CssClass="odd" />
        <Columns>
            <asp:BoundField DataField="fldName" HeaderText="Name" 
                SortExpression="fldName" ReadOnly="true"/>
            <asp:BoundField DataField="fldEmail" HeaderText="Email" 
                SortExpression="fldEmail" />

            <asp:TemplateField HeaderStyle-Width="80">
                <ItemTemplate>
                    <a href='<%# String.Format("cms-users-edit.aspx?id={0}", Eval("fldID"))%>' class="btn-link edit-link">Edit</a>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:CommandField ShowDeleteButton="True" ControlStyle-CssClass="btn-link delete-link" ItemStyle-Width="60" />
        </Columns>
        <EmptyDataRowStyle Font-Bold="true" />

    </asp:GridView>
    <asp:SqlDataSource ID="sqlsource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:ConnString1 %>" 
        SelectCommand="usersSelList" SelectCommandType="StoredProcedure" 
        DeleteCommand="usersDelete" DeleteCommandType="StoredProcedure">
        <DeleteParameters>
            <asp:Parameter Name="fldID" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>
</asp:Content>