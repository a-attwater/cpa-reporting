<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Report.master" CodeBehind="exceptions-duplicates.aspx.vb" Inherits="cpa_reports.exceptions_duplicates" %>

<asp:Content ID="header" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
    <h1>Import data to cleaned table</h1>
        
    <table class="table-list" cellspacing="0" rules="all" border="1" id="ContentPlaceHolder1_specialsList" style="width:800px;border-collapse:collapse;">
	    <tr>
		    <td scope="col">Date range of Data checked:</td>		<td scope="col"><asp:Label ID="lblDateRangeChecked" runat="server"></asp:Label></td>      
	    </tr> 	    
        <tr>
		    <td scope="col">Count of Data checked:</td>		<td scope="col"><asp:Label ID="lblDateCountChecked" runat="server"></asp:Label></td>       
	    </tr> 
	    <tr>
		    <td scope="col">&nbsp;</td>		<td scope="col">&nbsp;</td>      
	    </tr> 
        <tr>
		    <td scope="col"><strong>Duplicates</strong></td>		<td scope="col"><asp:Label ID="lblDuplicateCount" runat="server"></asp:Label></td>                                     
	    </tr>
	    
    </table>
            
    <asp:Button ID="btnDeleteDuplicates" Text="Remove duplicates"  CommandArgument="deleteDuplicates"  OnClick="btnDeleteDuplicates_Click"  runat="server" />

    <p><asp:Label ID="lblDataAddedCount" runat="server"></asp:Label></p>
    
</asp:Content>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
</asp:Content>