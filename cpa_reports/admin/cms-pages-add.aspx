<%@ Page Language="VB" MasterPageFile="~/Report.master"  AutoEventWireup="false" title="Add CPA Page" MaintainScrollPositionOnPostback="true" CodeBehind="cms-pages-add.aspx.vb" Inherits="cpa_reports.CPA_pages_add" validateRequest="false" %>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
    <div class="buttons">
        <a href="" runat="server" id="backLink">Back to Page List</a>
        <div class="clear"></div>
    </div>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
    <asp:ScriptManager ID="s1" runat="server" />

    <h1>Add CPA Page</h1>
    
    <div class="form-element select">
        <label>Select existing section/module:</label>
        <asp:DropDownList ID="ddlPages" runat="server"/>
    </div>

    <p><em>or</em></p>

    <div class="form-element input">
        <label>Enter new section/module:</label>
        <asp:TextBox runat="server" id="txtSection" />
    </div>

    <hr />

    <div id="subList">
        <asp:PlaceHolder ID="subHolder" runat="server" />
    </div>

    <a href="#" class="add-subvalue"><img src="../graphics/icon-add.png" alt="Add" /> Add another sub page</a>

    <div class="buttons">
        <asp:Button ID="btnConfirm" runat="server" Text="Save Page(s)" CssClass="btn-approve" />
    </div>

    <script type="text/javascript">
        $(function () {

            $('.add-subvalue').click(function (e) {
                $('#subList .sub-input:hidden:first').show();
                e.preventDefault();
            });
        });
    </script>
</asp:Content>