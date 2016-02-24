<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Report.master"  CodeBehind="exceptions-currencies.aspx.vb" Inherits="cpa_reports.exceptions_currencies" %>

<asp:Content ID="header" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
    <h1>Unknown Currencies</h1>
    <p>Click the button below to get a list of any unknown currencies in the data.  </p>
    
    <asp:Button ID="btnCheckExceptions" Text="Check for Unknown"  runat="server" OnClick="btnCheckExceptions_click" />    

    <asp:GridView   ID="GVCurrencies" runat="server" AutoGenerateColumns="false" CssClass="table-list"   OnRowDataBound="GVCurrencies_RowDataBound">
        <Columns>
            <asp:BoundField DataField="fID" HeaderStyle-Width="150" HeaderText="ID"  ReadOnly="true" />

            <asp:BoundField DataField="fScanCurrency" HeaderStyle-Width="150" HeaderText="Unknown Currency"  ReadOnly="true" />

            <asp:TemplateField HeaderText="Select Currency">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlCurrencyAlias" runat="server" AutoPostBack="true" ></asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>                                               
                            
            <asp:TemplateField HeaderText="Set as Alias">
                <ItemTemplate>
                    <asp:Button ID="btnSetAlias" Text="Set as alias"  CommandArgument="SetAlias"  OnClick="btnSetAlias_Click"  runat="server" />
                </ItemTemplate>
            </asp:TemplateField>     
               
            <asp:TemplateField HeaderText="Delete Data (hides data only)">
                <ItemTemplate>
                    <asp:Button ID="btnDeleteData" Text="Delete"  CommandArgument="DeleteData"  OnClick="btnDeleteData_Click"  runat="server" />
                </ItemTemplate>
            </asp:TemplateField>    
        </Columns>
    </asp:GridView>
    
    

    <script type="text/javascript">
        $(function () {
            $("[id$=btnCheckExceptions]").click(function () {
                window.scrollTo(0, 0);
                $("[id$=processing]").css('display', "block");
            });
            $('[id*="btnSetAlias"]').click(function () {
                window.scrollTo(0, 0);
                $("[id$=processing]").css('display', "block");
            });
            $('[id*="btnDeleteData"]').click(function () {
                window.scrollTo(0, 0);
                $("[id$=processing]").css('display', "block");
            });
        });
     </script>

</asp:Content>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
</asp:Content>