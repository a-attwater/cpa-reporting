<%@ Page Language="VB"  AutoEventWireup="false" MasterPageFile="~/Report.master"  title="Edit CPA User" CodeBehind="cms-users-edit.aspx.vb" Inherits="cpa_reports.CPA_users_edit" %>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
    <div class="buttons">
        <a href="cms-users.aspx" runat="server" id="backLink">Back to Users List</a>
        <div class="clear"></div>
    </div>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
    <asp:ScriptManager ID="s1" runat="server" />

    <h1>Edit User</h1>
    
    <div class="form-element input">
        <label>Username:</label>
        <asp:TextBox runat="server" id="txtUsername" />
    </div>

    <div class="form-element input">
        <label>Password:</label>
        <asp:TextBox runat="server" id="txtPassword" />
    </div>
    
    <div class="form-element input">
        <label>Full Name:</label>
        <asp:TextBox runat="server" id="txtName" />
    </div>

    <div class="form-element input">
        <label>Email:</label>
        <asp:TextBox runat="server" id="txtEmail" />
    </div>
    
    <div class="form-element checkbox">
        <label>CPA Administrator:</label>
        <asp:CheckBox ID="chkAdmin" runat="server" />
    </div>
    
    <div class="form-element checkbox">
        <label>Active:</label>
        <asp:CheckBox ID="chkActive" runat="server" />
    </div>

    <hr />

    <div id="pageList">
        <h2>Change access</h2>
        <asp:PlaceHolder ID="pageHolder" runat="server" />
    </div>


    <div class="buttons">
        <asp:Button ID="btnConfirm" runat="server" Text="Save" CssClass="btn-approve" />
    </div>

    <script type="text/javascript">
        $(function () {

            $('.toggleSubPages').click(function (e) {
                $('ul', $(this).parent().parent()).toggle(300);
                if ($(this).is('.visible')) {
                    $(this).removeClass('visible');
                    $('span', this).text('Hide');
                } else {
                    $(this).addClass('visible');
                    $('span', this).text('Show');
                }
                e.preventDefault();
            });

            $('.parentToggle input').click(function () {
                var pageID = $(this).next().text();
                if ($(this).is(':checked')) {
                    $('.subPage' + pageID + ' input').prop('checked', true);
                } else {
                    $('.subPage' + pageID + ' input').prop('checked', false);
                }
            });

            $('.pageToggle input').click(function () {
                var pageID = $(this).parent().attr('title');
                if ($(this).is(':checked')) {
                    $('.parentPage' + pageID + ' input').prop('checked', true);
                }

                if ($('.subPage' + pageID + ' input:checked').length == 0) {
                    $('.parentPage' + pageID + ' input').prop('checked', false);
                }
            });

            $('.subPageList:hidden').each(function () {
                if ($('input:checked', this).length > 0) {
                    $(this).show();
                    $(this).parent().find('.toggleSubPages').removeClass('visible');
                    $(this).parent().find('.toggleSubPages span').text('Hide');
                }
            });
        });
    </script>
</asp:Content>