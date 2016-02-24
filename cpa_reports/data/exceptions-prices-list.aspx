<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Report.master" CodeBehind="exceptions-prices-list.aspx.vb" Inherits="cpa_reports.exceptions_prices_list" %>

<asp:Content ID="header" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
    <h1>Rental Fees</h1>
    <p>This page lists the rental fees that are applied on top of the daily vehicle hire value.</p>
    <p>Some agents do not include these fees in the prices listed on their websites, and hence we must manually enter them here to ensure that we are providing accurate comparisons.</p>
    <p>The figures below are added to, or subtracted from the "scanned" prices, to provide a more accurate comparison between vendors.</p>
    
    <asp:GridView   ID="GVPrices" runat="server" AutoGenerateColumns="false" CssClass="table-list"  OnRowDataBound="GVPrices_RowDataBound">
        <Columns>
            <asp:BoundField DataField="fID" HeaderStyle-Width="150" HeaderText="ID"  ReadOnly="true" />
            
            <asp:BoundField DataField="fBrandList" HeaderStyle-Width="150" HeaderText="Brand"  ReadOnly="true" />                                 
                           
            <asp:BoundField DataField="fCountryName" HeaderStyle-Width="150" HeaderText="Country"  ReadOnly="true" />     
            
            <asp:BoundField DataField="fPickupLocationName" HeaderStyle-Width="150" HeaderText="Pickup Location"  ReadOnly="true" /> 

            <asp:BoundField DataField="fReturnLocationName" HeaderStyle-Width="150" HeaderText="Return Location"  ReadOnly="true" />
            
            <asp:BoundField DataField="fOneWay" HeaderStyle-Width="150" HeaderText="Only One-Way rentals"  ReadOnly="true" />         

            <asp:BoundField DataField="fPriceExceptionDateStart" HeaderStyle-Width="150" HeaderText="Start Date" ReadOnly="true"  /> 

            <asp:BoundField DataField="fPriceExceptionDateEnd" HeaderStyle-Width="150" HeaderText="End Date"  ReadOnly="true" />
              
            <asp:BoundField DataField="fPriceExceptionPriceChange" HeaderStyle-Width="150" HeaderText="Price Change"  ReadOnly="true" />   

            <asp:BoundField DataField="fPriceExceptionPercentage" HeaderStyle-Width="150" HeaderText="Percentage Change"  ReadOnly="true" />      
            
            <asp:BoundField DataField="fCurrencyCode" HeaderStyle-Width="150" HeaderText="Currency"  ReadOnly="true" />         
            
            <asp:BoundField DataField="fPriceExceptionNote" HeaderStyle-Width="150" HeaderText="Note"  ReadOnly="true" />                                                 
                                          
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:Button ID="btnUpdateException" Text="Update"  CommandArgument="UpdateException"  OnClick="btnUpdateException_Click"  runat="server" />
                </ItemTemplate>
            </asp:TemplateField>    
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:Button ID="btnDeleteException" Text="Delete"  CommandArgument="DeleteException"  OnClick="btnDeleteException_Click"  runat="server" />
                </ItemTemplate>
            </asp:TemplateField>  
        </Columns>
    </asp:GridView>

</asp:Content>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
    <div class="buttons">
         <asp:Button ID="btnAddException" Text="Add Exception" OnClick="btnAddException_Click"  runat="server" />
    </div> 
</asp:Content>