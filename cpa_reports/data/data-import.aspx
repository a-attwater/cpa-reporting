
<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Report.master"  CodeBehind="data-import.aspx.vb" Inherits="cpa_reports.data_import" %>

<asp:Content ID="header" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
    <h1>Import data to cleaned table</h1>

    <p>As the different websites scanned may name the vehicles etc in different ways, we use a list of Aliases to ensure that the prices are assigned to the correct parameters. <br />
        To assist with this, regular checks need to be made to make sure that no unknown names have cropped up, and if they have, to assign them as an Alias to the correct item (vehicle/location/brand etc).
    </p>
    <p>Please complete the steps below.</p>        


    <h2>Step 1: Check for exceptions</h2>
    <p>This will list if there are any unknown names in each of the search parameters.<br />
        If there are any exceptions (any number higher than zero), please click on the link for that item to go to the page where the unknown parameters can be assigned.<br />
        <i>Please note:</i> this process can take between 30 secs to 5 minutes depending on how many exceptions are present.
    </p>
    <asp:Button ID="btnCheckExceptions" Text="Check Exceptions"  runat="server" OnClick="btnCheckExceptions_click" />    
    <asp:Literal ID="tblExceptions"  runat="server" />    
            
    
    <h2>Step 2: Accept data</h2>
    <p>Once there are no more exceptions, click accept, to process the data.</p>    
    <asp:Button ID="btnAcceptData" Text="Accept Data"  CommandArgument="acceptData"  OnClick="btnAcceptData_Click"  runat="server" />


    <p><asp:Label ID="lblDataAddedCount" runat="server"></asp:Label> <asp:Label ID="lblDataDuplicateCount" runat="server"></asp:Label></p>
    
    <p><asp:Label ID="lblExceptionCountUpdated" runat="server"></asp:Label></p>
    

    

    <script type="text/javascript">
        $(function () {
            $("[id$=btnCheckExceptions]").click( function(){
                window.scrollTo(0, 0);
                $("[id$=processing]").css('display', "block");
            });
            $("[id$=btnAcceptData]").click( function(){
                window.scrollTo(0, 0);
                $("[id$=processing]").css('display', "block");
            });
        });
     </script>
        
</asp:Content>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
</asp:Content>