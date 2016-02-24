<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Report.master" CodeBehind="exceptions-counts.aspx.vb" Inherits="cpa_reports.exceptions_counts" %>

<asp:Content ID="header" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .table-list td .countChange.noData, .table-list td .countChange.noData span {color:#e1e1e1;}
    </style>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
    <h1>Data counts and spreads</h1>
    <p>This page lists the counts for each vendor over the past several weeks.<br /> 
        If there is no data showing for this week, than it has either not arrived or not been processed.
    </p>
    
    <h2>This week</h2>
    <p>Check if data has arrived for this week. </p>
    <p>Notes:</p>
    <ul>
        <li>If "received" is 0 than no data has been received this week.</li>
        <li>If "processed" is 0 than this week's data has not yet been processed. <br /> 
            The data will not be available for use in the reports until it has been processed.</li>
        <li>Some discrepency between the two figures is expected due to duplicates being omitted during processing, but a large difference could indicate an issue with the scan.</li>
    </ul>

    <asp:Button ID="btnCheckWksData" Text="Has Data Arrived?"  OnClick="btnCheckWksData_Click"  runat="server" />
    
     <asp:ListView ID="LVthisWeeksData" runat="server" ItemPlaceholderID="itemPlaceHolder" >
             <LayoutTemplate>
                <table class="table-list">
                    <tr>
                        <th>Received</th><th>Processed</th>
                    </tr>
                    <asp:PlaceHolder runat="server" ID="itemPlaceHolder"></asp:PlaceHolder>
                </table>  
            </LayoutTemplate>
            <ItemTemplate>
                    <tr>
                        <td><strong><%# Eval("fScanCount")%></strong></td>
                        <td><strong><%# Eval("fScanCleanCount")%></strong></td>
                    </tr>                           
            </ItemTemplate>
        </asp:ListView>        

    <h2>Recent weeks</h2>
    <p>Look at the counts of data received for each vendor over the past several weeks.</p>
    <asp:Button ID="btnGetWklyDataCounts" Text="Get Counts"  OnClick="btnGetWklyDataCounts_Click"  runat="server" />

     <asp:ListView ID="LVCounts" runat="server" ItemPlaceholderID="itemPlaceHolder1" >
             <LayoutTemplate>
                <table class="table-list" width="260">
                    <tr>
                        <th>Date</th><th>Total</th><th>Apollo</th><th>Salamanda</th><th>MHR</th><th>Best Camper</th><th>Camper Boerse</th><th>TSA</th><th>MH & Cars</th> <th>Cruise America</th>
                    </tr>
                    <asp:PlaceHolder runat="server" ID="itemPlaceHolder1"></asp:PlaceHolder>
                </table>  
            </LayoutTemplate>
            <ItemTemplate>
                    <tr>
                        <td><strong><%# Eval("fDate")%></strong></td>
                        <td><span class="<%# Eval("fTotalCountClass")%>"><%# Eval("fTotalCount")%> <span>(<%# Eval("fTotalCountChange")%> %)</span></span></td>
                        <td><span class="<%# Eval("fCountWeb1Class")%>"><%# Eval("fCountWeb1")%> <span>(<%# Eval("fCountWeb1Change")%> %)</span></span></td>
                        <td><span class="<%# Eval("fCountWeb2Class")%>"><%# Eval("fCountWeb2")%> <span>(<%# Eval("fCountWeb2Change")%> %)</span></span></td>
                        <td><span class="<%# Eval("fCountWeb3Class")%>"><%# Eval("fCountWeb3")%> <span>(<%# Eval("fCountWeb3Change")%> %)</span></span></td>
                        <td><span class="<%# Eval("fCountWeb4Class")%>"><%# Eval("fCountWeb4")%> <span>(<%# Eval("fCountWeb4Change")%> %)</span></span></td>
                        <td><span class="<%# Eval("fCountWeb5Class")%>"><%# Eval("fCountWeb5")%> <span>(<%# Eval("fCountWeb5Change")%> %)</span></span></td>
                        <td><span class="<%# Eval("fCountWeb6Class")%>"><%# Eval("fCountWeb6")%> <span>(<%# Eval("fCountWeb6Change")%> %)</span></span></td>
                        <td><span class="<%# Eval("fCountWeb7Class")%>"><%# Eval("fCountWeb7")%> <span>(<%# Eval("fCountWeb7Change")%> %)</span></span></td>
                        <td><span class="<%# Eval("fCountWeb8Class")%>"><%# Eval("fCountWeb8")%> <span>(<%# Eval("fCountWeb8Change")%> %)</span></td>
                    </tr>
                           
            </ItemTemplate>
        </asp:ListView>        

    
        

        <script type="text/javascript">
            $(function () {
                $("[id$=btnCheckWksData]").click(function () {
                    window.scrollTo(0, 0);
                    $("[id$=processing]").css('display', "block");
                });
                $("[id$=btnGetWklyDataCounts]").click(function () {
                    window.scrollTo(0, 0);
                    $("[id$=processing]").css('display', "block");
                });
            });
         </script>
</asp:Content>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
</asp:Content>