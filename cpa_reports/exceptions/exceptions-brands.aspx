<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Report.master"  CodeBehind="exceptions-brands.aspx.vb" Inherits="cpa_reports.brands" %>

<asp:Content ID="header" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .hideSpinner {display:none; }
    </style>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
    <h1>Unknown Brands</h1>
    <p>Click the button below to check for any unknown brands in the data.</p>
    
    <asp:Button ID="btnCheckExceptions" Text="Check for Unknown"  runat="server" OnClick="btnCheckExceptions_click" />    

    <asp:GridView   ID="GVBrands" runat="server" AutoGenerateColumns="false" CssClass="table-list"   OnRowDataBound="GVBrands_RowDataBound">
        <Columns>
            <asp:BoundField DataField="fID" HeaderStyle-Width="150" HeaderText="ID"  ReadOnly="true" />

            <asp:BoundField DataField="fScanBrandName" HeaderStyle-Width="150" HeaderText="Unknown Brand"  ReadOnly="true" />

            <asp:TemplateField HeaderText="Select Brand">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlBrandAlias" runat="server" AutoPostBack="true" ></asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>                                               
                            
            <asp:TemplateField HeaderText="Set as Alias">
                <ItemTemplate>
                    <asp:Button ID="btnSetAlias" Text="Set as alias"  CommandArgument="SetAlias"  OnClick="btnSetAlias_Click"  runat="server" />
                </ItemTemplate>
            </asp:TemplateField>     

            <asp:TemplateField HeaderText="Select Inactive Brand">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlBrandInactiveAlias" runat="server" AutoPostBack="true" ></asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>                                               
                            
            <asp:TemplateField HeaderText="Set as Alias">
                <ItemTemplate>
                    <asp:Button ID="btnSetInactiveAlias" Text="Set as alias"  CommandArgument="SetInactiveAlias"  OnClick="btnSetInactiveAlias_Click"  runat="server" />
                </ItemTemplate>
            </asp:TemplateField>    
               
            <asp:TemplateField HeaderText="Add as new brand">
                <ItemTemplate>
                    <asp:Button ID="btnAddBrand" Text="Add brand"  CommandArgument="addBrand"  OnClick="btnAddBrand_Click"  runat="server" />
                </ItemTemplate>
            </asp:TemplateField>  
            
            <asp:TemplateField HeaderText="Add as new inactive brand">
                <ItemTemplate>
                    <asp:Button ID="btnAddInactiveBrand" Text="Add brand"  CommandArgument="addInactiveBrand"  OnClick="btnAddInactiveBrand_Click"  runat="server" />
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
            $('[id*="btnSetInactiveAlias"]').click(function () {
                window.scrollTo(0, 0);
                $("[id$=processing]").css('display', "block");
            });
            $('[id*="btnAddBrand"]').click(function () {
                window.scrollTo(0, 0);
                $("[id$=processing]").css('display', "block");
            });
            $('[id*="btnAddInactiveBrand"]').click(function () {
                window.scrollTo(0, 0);
                $("[id$=processing]").css('display', "block");
            });
        });
     </script>
</asp:Content>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
</asp:Content>