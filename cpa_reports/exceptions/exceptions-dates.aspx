<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Report.master"  CodeBehind="exceptions-dates.aspx.vb" Inherits="cpa_reports.dates" %>

<asp:Content ID="header" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .hideSpinner {display:none; }
    </style>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
    <h1>Incorrect Dates</h1>
    <p>Click the button below to get a list of Pick-Up and/or drop-off dates that are not correct.</p>
    <p>Any data showing up in this list:</p>
    <ul>
        <li>will not be included in the reports</li>
        <li>MUST be investigated, as it shows an error in the scans</li>
        <li>Should only be marked as "resolved" when the issue has been resolved.</li>
    </ul>

    <asp:Button ID="btnCheckExceptions" Text="Check for Unknown"  runat="server" OnClick="btnCheckExceptions_click" />    


    <asp:GridView   ID="GVDates" runat="server" AutoGenerateColumns="false" CssClass="table-list"   OnRowDataBound="GVDates_RowDataBound">
        <Columns>
            <asp:BoundField DataField="fCount" HeaderStyle-Width="100" HeaderText="# Errors"  ReadOnly="true" />
            <asp:BoundField DataField="fScanURL" HeaderStyle-Width="150" HeaderText="Agent"  ReadOnly="true" />
            <asp:BoundField DataField="fScanPickupDate" HeaderStyle-Width="150" HeaderText="Pickup"  ReadOnly="true" />
            <asp:BoundField DataField="fScanReturnDate" HeaderStyle-Width="150" HeaderText="Return"  ReadOnly="true" />
            <asp:BoundField DataField="fReason" HeaderStyle-Width="350" HeaderText="What is wrong"  ReadOnly="true" />
            <asp:TemplateField HeaderText="Has it been resolved?">
                <ItemTemplate>
                    <asp:Button ID="btnIssueResolved" Text="Mark as Resolved" OnClick="btnIssueResolved_Click"  runat="server" />
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
            $('[id*="btnIssueResolved"]').click(function () {
                window.scrollTo(0, 0);
                $("[id$=processing]").css('display', "block");
            });
        });
     </script>

</asp:Content>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
</asp:Content>