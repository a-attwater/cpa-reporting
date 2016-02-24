<%@ Page Language="VB" MasterPageFile="~/Report.master"  AutoEventWireup="false" title="Edit CPA Page" MaintainScrollPositionOnPostback="true" CodeBehind="cms-pages-edit.aspx.vb" Inherits="cpa_reports.CPA_pages_edit" validateRequest="false" %>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
    <div class="buttons">
        <a href="cms-pages.aspx" runat="server" id="backLink">Back to Page List</a>
        <div class="clear"></div>
    </div>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
    <asp:ScriptManager ID="s1" runat="server" />

    <h1>Edit CPA Page</h1>
    
    <div class="form-element input">
        <label>Section/module:</label>
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


            //iterate through the conditions fields, if they're not blank show the field
            $('.sub-input').each(function () {
                if ($(this).find('input[type="text"]').val() != '') {
                    $(this).show();
                }
            });

            $('.delete-link').click(function (e) {
                if (confirm('Are you sure you want to delete this page?')) {
                    var parent = $(this).parent();
                    var pageID = $(parent).find('input[type="hidden"]').val()
                    $.get('ajax_deletePage.aspx?id=' + pageID, function (data) {
                        if (data == 1) {
                            showNotice('Page deleted');
                            $('input', parent).val('');
                            $(parent).hide();
                        } else {
                            alert('There was a problem deleting this page. Please try again later.');
                        }
                    });
                } else {
                    return false;
                }
                e.preventDefault();
            });
        });
    </script>

    <div class="display-notice hidden"></div>
</asp:Content>