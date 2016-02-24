<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Report.master"  CodeBehind="exceptions-vehicles.aspx.vb" Inherits="cpa_reports.exceptions_vehicles" %>

<asp:Content ID="header" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
    <h1>Unknown Vehicles</h1>
    <p>Click the button below to check for unknown vehicles in the data.<br />
        Usually this means tha a new vehicle has been added, or one of the websites is using an alternate name for a vehicle
    </p>
    
    <asp:Button ID="btnCheckExceptions" Text="Check for Unknown"  runat="server" OnClick="btnCheckExceptions_click" />    
           
    <asp:GridView   ID="GVVehicles" runat="server"   AutoGenerateColumns="false" CssClass="table-list"   OnRowDataBound="GVVehicles_RowDataBound"  AllowPaging="true"  OnPageIndexChanging="OnPageIndexChanging"  PageSize="20">
        <Columns>
            <asp:BoundField DataField="fID" HeaderStyle-Width="100" HeaderText="ID"  ReadOnly="true" />

            <asp:BoundField DataField="fScanURL" HeaderStyle-Width="100" HeaderText="From this website"  ReadOnly="true" />

            <asp:BoundField DataField="fBrandID" HeaderStyle-Width="50" HeaderText="BrandID"  ReadOnly="true" />
            
            <asp:BoundField DataField="fScanBrandName" HeaderStyle-Width="150" HeaderText="Brand of Unknown Vehicle"  ReadOnly="true" />

            <asp:BoundField DataField="fScanVehicleName" HeaderStyle-Width="150" HeaderText="Unknown Vehicle"  ReadOnly="true" />

            <asp:TemplateField HeaderText="Select Active Brand">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlBrandAlias" runat="server" OnSelectedIndexChanged="ddlBrandAlias_SelectedIndexChanged" AutoPostBack="true" ></asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>                                               
            
            <asp:TemplateField HeaderText="Select Vehicle">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlVehicleAlias" runat="server"></asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>  

            <asp:TemplateField HeaderText="Set as this" HeaderStyle-Width="50" >
                <ItemTemplate>
                    <%--<asp:Button ID="btnSetAlias" Text="Set as alias"  CommandArgument="SetAlias"  OnClick="btnSetAlias_Click"  runat="server" />--%>
                    <asp:CheckBox ID ="chbxActiveAlias" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>      
              
            <asp:TemplateField HeaderText="Select Inactive Brand">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlBrandInactiveAlias" OnSelectedIndexChanged="ddlVehicleInactiveAlias_SelectedIndexChanged" runat="server" AutoPostBack="true" ></asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>                                               
            
            <asp:TemplateField HeaderText="Select In. Vehicle">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlVehicleInactiveAlias" runat="server" ></asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>  

            <asp:TemplateField HeaderText="Set as this" HeaderStyle-Width="50" >
                <ItemTemplate>
                    <%--<asp:Button ID="btnSetInactiveAlias" Text="Set as alias"  CommandArgument="SetInactiveAlias"  OnClick="btnSetInactiveAlias_Click"  runat="server" />--%>
                    <asp:CheckBox ID ="chbxInActiveAlias" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>     
        </Columns>
    </asp:GridView>

    <div class="clear"></div>

    <asp:Button ID="btnSetAlias" Text="Accept all ticked items" visible="false" CommandArgument="SetAlias"  OnClick="btnSetAlias_Click"  runat="server" />

    

    <script type="text/javascript">
        $(function () {
            $("[id$=btnSetAlias]").change(function () {
                window.scrollTo(0, 0);
                $("[id$=processing]").css('display', "block");
            });
        });
     </script>

</asp:Content>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
</asp:Content>