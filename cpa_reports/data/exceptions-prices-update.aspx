<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Report.master" CodeBehind="exceptions-prices-update.aspx.vb" Inherits="cpa_reports.exceptions_prices_update" %>

<asp:Content ID="header" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">        
            .inner {position:relative;}
            .italic {font-style: italic; color:#c2c2c2;}
            #processing {display:none; width: 98.5%; height:100%; min-width:300px; min-height:600px; top:0; text-align:center; position:absolute; background-color:rgba(255,255,255,0.75);  }
            #processing img{position:relative; margin:0 auto; top:200px; width:124px; height:128px; }
            .chbxList {padding-bottom:10px; border-bottom:1px solid #bcbcbc;}
            /*.chbxList table {padding-bottom:10px; border-bottom:1px solid #bcbcbc;}*/
            .chbxList table td{padding-right:10px;}
    </style>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="mainContent" Runat="Server">
    <h1>Update Rental Fee</h1>
    <p>Alter the fields to update the accuracy of the details for a rental fee. (Rental fees are those that are incurred on top of the daily vehicle hire value). </p>
            
    <div class="form-element select">
        <label>Country: </label>
        <asp:DropDownList ID="ddlCountry" runat="server"  AutoPostBack="true" OnSelectedIndexChanged="ddlCountry_SelectedIndexChanged"  />
    </div>  
    
    <div class="form-element select chbxList">
        <label>Brand/s:  <span class="italic">(tick all that apply)</span> </label>
        <asp:placeHolder ID="cbContainerBrands" Runat="server" />
    </div>

    <div class="form-element select chbxList">
        <label>Pickup Location: </label>
        <asp:placeHolder ID="cbContainerPULocations" Runat="server" />
   </div>
    <div class="form-element select chbxList">
        <label>Return Location: </label>
        <asp:placeHolder ID="cbContainerRLocations" Runat="server" />
    </div>
    
    <div class="form-element select">
        <label>For One-way travel: <span class="italic">(tick if this fee only applies to one-way travel)</span> </label>
        <asp:CheckBox id="chBxOneWay" runat="server" />
        <p><i>Please tick this if this exception is only valid for one way travel.<br /> If selected, this will appear on location combinations where the pickup and dropoff locations match those selected above.</i></p>
    </div>
    
    <div class="form-element input">
        <label>Start Date: <span class="italic">(if left blank, will default to todays date)</span></label>
        <asp:TextBox ID="txtStartDate" runat="server" CssClass="datepicker" />
    </div>
    <div class="form-element input">
        <label>End Date: <span class="italic">(can leave blank for permanent)</span></label>
        <asp:TextBox ID="txtEndDate" runat="server" CssClass="datepicker" />
    </div>    
    
    <div class="form-element input">
        <label>Alter Price by ($xxx.xx):</label>
        <asp:TextBox ID="txtPriceChangeDecimal" runat="server" />
    </div>    
	<asp:RegularExpressionValidator runat="server"
		SetFocusOnError="true" 
		ID="txtPriceChangeDecimalValidator"
		ControlToValidate="txtPriceChangeDecimal"
		ErrorMessage="Only numbers and decimal point allowed." ForeColor="Red"
		ValidationExpression="^\d*\.?\d*$">* Only numbers and decimal point allowed.
	</asp:RegularExpressionValidator>
	<asp:RegularExpressionValidator runat="server"
		SetFocusOnError="true" 
		ID="txtPriceChangeDecimalValidator2"
		ControlToValidate="txtPriceChangeDecimal"
		ErrorMessage="Shorter number required. Max possible is 9999.99" ForeColor="Red"
		ValidationExpression="(.){0,7}">* Shorter number required. Max possible is 9999.99
	</asp:RegularExpressionValidator>

    <div class="form-element input">
        <label>Alter Price by (xx%):</label>
        <asp:TextBox ID="txtPriceChangePercent" runat="server" />
    </div>
	<asp:RegularExpressionValidator runat="server"
		SetFocusOnError="true" 
		ID="txtPriceChangePercentValidator"
		ControlToValidate="txtPriceChangePercent"
		ErrorMessage="Only numbers and decimal point allowed." ForeColor="Red"
		ValidationExpression="^\d*\.?\d*$">* Only numbers and decimal point allowed.
	</asp:RegularExpressionValidator>
	<asp:RegularExpressionValidator runat="server"
		SetFocusOnError="true" 
		ID="txtPriceChangePercentValidator2"
		ControlToValidate="txtPriceChangePercent"
		ErrorMessage="Shorter number required. Max possible is 9999.99" ForeColor="Red"
		ValidationExpression="(.){0,7}">* Shorter number required. Max possible is 9999.99
	</asp:RegularExpressionValidator>
    
    <div class="form-element select">
        <label>Currency of price change: </label>
        <asp:DropDownList ID="ddlCurrency" runat="server" />
    </div>
    
    <div class="form-element input">
        <label>Note: <span class="italic">(What is this fee for?)</span></label>
        <asp:TextBox ID="txtPriceChangeNote" runat="server" />
    </div>                                       
                              
    <asp:Button ID="btnUpdateException" Text="Update Exception"  CommandArgument="UpdateException"  OnClick="btnUpdateException_Click" runat="server" />
    
    <script type="text/javascript" >
        $(function () {
            $('.datepicker').datepicker({
                dateFormat: 'd/m/yy',
                minDate: 0
            });
        });

    </script>
</asp:Content>

<asp:Content ID="sideContent" ContentPlaceHolderID="sideContent" Runat="Server">
</asp:Content>