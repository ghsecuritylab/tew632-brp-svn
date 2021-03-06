<html>
<head>
<title>TRENDNET | TEW-632BRP | Wizard</title>
<meta http-equiv="Content-Type" content="text/html;">
<link rel="stylesheet" href="style.css" type="text/css">
<script language="JavaScript" src="public_msg.js"></script>
<script language="JavaScript" src="public.js"></script>
<script language="JavaScript">
	function loadSettings(){
		var dat = get_by_id("wan_curr_ipaddr").value.split("/");
		if(dat[0] !="0.0.0.0" && get_by_id("asp_temp_19").value == "0.0.0.0"){
			get_by_id("asp_temp_19").value = dat[0];
		}
		if(dat[1] !="0.0.0.0" && get_by_id("asp_temp_20").value == "0.0.0.0"){
			get_by_id("asp_temp_20").value = dat[1];
		}
		
		set_checked("<% CmoGetCfg("wan_pptp_dynamic","none"); %>",get_by_name("pptp_enable"));
		disable_dhcp_static_address(get_by_name("pptp_enable"), get_by_id("asp_temp_19"), get_by_id("asp_temp_20"), get_by_id("asp_temp_21"));
	}
	
	
	function send_request(){		
		var ip = get_by_id("asp_temp_19").value;	
		var mask = get_by_id("asp_temp_20").value;
		var gateway = get_by_id("asp_temp_21").value;
		
		var ip_addr_msg = replace_msg(all_ip_addr_msg,"IP address");
		var gateway_msg = replace_msg(all_ip_addr_msg,"Gateway address");
		
		var temp_ip_obj = new addr_obj(ip.split("."), ip_addr_msg, false, false);
		var temp_mask_obj = new addr_obj(mask.split("."), subnet_mask_msg, false, false);
		var temp_gateway_obj = new addr_obj(gateway.split("."), gateway_msg, false, false);
		
		if (get_by_name("pptp_enable")[1].checked){	
			if (!check_lan_setting(temp_ip_obj, temp_mask_obj, temp_gateway_obj)){
				return false;
			}
		}
		if(get_by_id("asp_temp_22").value == ""){
    		alert(msg[MSG40]);
    		return false;
	     }
		
		if (get_by_name("pptp_enable")[1].checked){
       		get_by_id("asp_temp_16").value = "0";
       		
       	}else{
       		get_by_id("asp_temp_16").value = "1";
       	}
	
		if (!check_pwd("asp_temp_18", "pwd2")){
			return false;
		}
		
		send_submit("form1");
	}
</script>
</head>

<body text="#000000" leftmargin="0" topmargin="0" onLoad="loadSettings();">
<table width="459" height="324" border="0" cellpadding="0" cellspacing="0" bgcolor="334255">
    <tr>
      <td height="49"><img src="bg_wizard_2.gif" width="459" height="49"></td>
    </tr>
    <tr>
      <td valign="top" background="bg_wizard_3.gif"><table width="459" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td colspan="3"><img src="spacer.gif" width="30" height="10"></td>
          </tr>
          <tr>
            <td width="7%"><img src="spacer.gif" width="30" height="60"></td>
            <td width="86%" align="center"><table width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td class="headerbg">Set PPTP Client</td>
              </tr>
            </table>
             <form id="form1" name="form1" method="post" action="apply.cgi">
             	<input type="hidden" id="html_response_page" name="html_response_page" value="wizard6.asp">
	  			<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="<% CmoGetCfg("html_response_return_page","none"); %>">
	  			<input type="hidden" id="wan_curr_ipaddr" name="wan_curr_ipaddr" value="<% CmoGetStatus("wan_current_ipaddr_00"); %>">
	  			<input type="hidden" id="reboot_type" name="reboot_type" value="none">
	  			<input type="hidden" id="asp_temp_02" name="asp_temp_02" value="pptp">
	  			<input type="hidden" id="asp_temp_16" name="asp_temp_16" value="<% CmoGetStatus("asp_temp_16"); %>">
	  			<input type="hidden" id="wan_pptp_dynamic" name="wan_pptp_dynamic"  value="<% CmoGetCfg("wan_pptp_dynamic","none"); %>">
	  			
                <table width="100%" border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF">
                  <tr>
                    <td align="right" bgcolor="#FFFFFF" class="bgblue">&nbsp;</td>
                    <td class="bggrey"><font face="Arial">
                      <input type="radio" name="pptp_enable" value="1" onClick='disable_dhcp_static_address(get_by_name("pptp_enable"), get_by_id("asp_temp_19"), get_by_id("asp_temp_20"), get_by_id("asp_temp_21"))'>
                    </font>Dynamic IP&nbsp;<font face="Arial">
                    <input type="radio" name="pptp_enable" value="0" onClick='disable_dhcp_static_address(get_by_name("pptp_enable"), get_by_id("asp_temp_19"), get_by_id("asp_temp_20"), get_by_id("asp_temp_21"))'>
                    </font>Static IP</td>
                  </tr>
                  <tr>
                    <td width="144" align="right" bgcolor="#FFFFFF" class="bgblue"><font face="Arial">My IP</font></td>
                    <td width="235" class="bggrey"><input type="text" id="asp_temp_19" name="asp_temp_19" size=16 maxlength=15 value="<% CmoGetCfg("asp_temp_19","none"); %>"></td>
                  </tr>
                  <tr>
                    <td align="right" bgcolor="#FFFFFF" class="bgblue"><font face="Arial">Subnet Mask</font></td>
                    <td class="bggrey"><input type="text" id="asp_temp_20" name="asp_temp_20" size=16 maxlength=15 value="<% CmoGetCfg("asp_temp_20","none"); %>"></td>
                  </tr>
                  <tr>
                    <td align="right" bgcolor="#FFFFFF" class="bgblue"><font face="Arial">GateWay</font></td>
                    <td class="bggrey"><input type="text" id="asp_temp_21" name="asp_temp_21" size="16" maxlength="15" value="<% CmoGetCfg("asp_temp_21","none"); %>"></td>
                  </tr>
                  <tr>
                    <td align="right" bgcolor="#FFFFFF" class="bgblue"><font face="Arial">Server IP</font></td>
                    <td class="bggrey"><input type="text" id="asp_temp_22" name="asp_temp_22" size=30 maxlength=63 value="<% CmoGetCfg("asp_temp_22","none"); %>"></td>
                  </tr>
                  <tr>
                    <td align="right" bgcolor="#FFFFFF" class="bgblue"><font face="Arial">PPTP Account</font></td>
                    <td class="bggrey"><input type="text" id="asp_temp_17" name="asp_temp_17" size="30" maxlength="63" value="<% CmoGetCfg("asp_temp_17","none"); %>"></td>
                  </tr>
                  <tr>
                    <td align="right" bgcolor="#FFFFFF" class="bgblue">PPTP Password</td>
                    <td class="bggrey"><input type="password" id="asp_temp_18" name="asp_temp_18" size="30" maxlength="63" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyG"></td>
                  </tr>
                  <tr>
                    <td align="right" bgcolor="#FFFFFF" class="bgblue">Retype Password</td>
                    <td class="bggrey"><input type="password" id="pwd2" name="pwd2" size="30" maxlength="63" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyG"></td>
                  </tr>
                </table>
                <p>
                  <input type="button" value="&lt; Back" name="back" onClick="window.location='<% CmoGetCfg("html_response_return_page","none"); %>'">
                <input type="button" value="Next &gt;" name="next" onClick="send_request()">
                <input type="button" name="exit" value="Exit" onClick="exit_wizard()">
                </p>
              </form>
              </td>
            <td width="7%"><img src="spacer.gif" width="30" height="60"></td>
          </tr>
      </table></td>
    </tr>
    <tr>
      <td height="14"><img src="bg_wizard_4.gif" width="459"></td>
    </tr>
  </table>
</body>
</html>
