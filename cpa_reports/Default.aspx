<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Report.master" CodeBehind="default.aspx.vb" Inherits="cpa_reports._default" %>

<asp:Content ID="header" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
    <h1>CPA Reports</h1>
    <p>Please select a page from the menu on the left to get started, or select from one of your Quick Reports options below.</p>

    <div id="quickReportsWrapper">
        <h3>Quick Reports</h3>
        <p>The following are shortcuts to your quick reports.</p>
         <div id="quickReports">
            <a href="/reports/comparison-snapshot.aspx?qr=1">
                <div class="quickReportBox">
                    <h4>Comparison Snapshot</h4>
                    <ul>
                        <li>Sydney to Sydney </li>
                        <li>Vendors Apollo & MHR </li>
                        <li>Last three date ranges </li>
                        <li>Domestic Pricing </li>
                    </ul>
                </div>
            </a>

        </div>
    </div>

    
    <script type="text/javascript">
        $(function () {
            $('[class*="quickReportBox"]').click(function () {
                window.scrollTo(0, 0);
                $("[id$=processing]").css('display', "block");
            });            
        });

     </script>

</asp:Content>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
</asp:Content>