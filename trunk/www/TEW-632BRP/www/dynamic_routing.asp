<html>
<head>
<meta http-equiv="Content-Type" content="text/html;">
<title>TRENDNET | TEW-632BRP | Routing | Dynamic</title>
<link rel="stylesheet" href="style.css" type="text/css">
<script language="JavaScript" src="public_msg.js"></script>
<script language="JavaScript" src="public.js"></script>
<SCRIPT LANGUAGE="JavaScript">
	function loadSettings(){
		set_checked("<% CmoGetCfg("rip_rx_version","none"); %>",get_by_name("rip_rx_version"));
		set_checked("<% CmoGetCfg("rip_tx_version","none"); %>",get_by_name("rip_tx_version"));
	}
	
	function send_request(){
		get_by_id("rip_enable").value = "1";
		if((get_checked_value(get_by_name("rip_rx_version")) == 0) && (get_checked_value(get_by_name("rip_tx_version")) == 0)){
			get_by_id("rip_enable").value = "0";
		}
		send_submit("form1");
	}
</SCRIPT>
</head>

<body onLoad="MM_preloadImages('but_wizard_1.gif','but_status_1.gif','but_tools_1.gif','but_main_1.gif','but_wireless_1.gif','but_routing_1.gif','but_access_1.gif','but_management_1.gif','but_help1_1.gif');loadSettings();">
<table width="750" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="21"><img src="c1_tl.gif" width="21" height="21"></td>
    <td width="708" background="bg1_t.gif"><img src="top_1.gif" width="390" height="21"></td>
    <td width="21"><img src="c1_tr.gif" width="21" height="21"></td>
  </tr>
  <tr>
    <td valign="top" background="bg1_l.gif"><img src="top_2.gif" width="21" height="69"></td>
    <td background="bg.gif"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="13%"><img src="logo.gif" width="270" height="69"></td>
        <td width="87%" align="right"><img src="description.gif"></td>
      </tr>
    </table>
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="20%" valign="top"><table width="56%" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td><a href="lan.asp"><img src="but_main_0.gif" name="Image2" width="144" height="28" border="0" id="Image2" onMouseOver="MM_swapImage('Image2','','but_main_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
            </tr>
            <tr>
              <td><img src="spacer.gif" width="8" height="8"></td>
            </tr>
            <tr>
              <td><a href="wireless_basic.asp"><img src="but_wireless_0.gif" name="Image3" width="144" height="28" border="0" id="Image3" onMouseOver="MM_swapImage('Image3','','but_wireless_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a><a href="w_basic.asp"></a></td>
            </tr>
            <tr>
              <td><img src="spacer.gif" width="8" height="8"></td>
            </tr>
            <tr>
              <td><a href="status.asp"><img src="but_status_0.gif" name="Image1" width="144" height="28" border="0" id="Image1" onMouseOver="MM_swapImage('Image1','','but_status_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
            </tr>
            <tr>
              <td><img src="spacer.gif" width="8" height="8"></td>
            </tr>
            <tr>
              <td><a href="static_routing.asp"><img src="but_routing_1.gif" name="Image4" width="144" height="28" border="0" id="Image4" onMouseOver="MM_swapImage('Image4','','but_routing_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
            </tr>
            <tr>
              <td><table width="100%" border="0" cellpadding="2" class="submenubg">
                  <tr>
                    <td width="13%" align="right"><font color="#FFFFFF">&bull;</font></td>
                    <td width="87%"><a href="static_routing.asp" class="submenus"><b>Static</b></a></td>
                  </tr>
                  <tr>
                    <td align="right"><font color="#FFFFFF">&bull;</font></td>
                    <td><a href="dynamic_routing.asp" class="submenus"><b><u>Dynamic</u></b></a></td>
                  </tr>
                  <tr>
                    <td align="right"><font color="#FFFFFF">&bull;</font></td>
                    <td><a href="routing_table.asp" class="submenus"><b>Routing Table </b></a></td>
                  </tr>
              </table></td>
            </tr>
            <tr>
              <td><img src="spacer.gif" width="8" height="8"></td>
            </tr>
            <tr>
              <td><a href="filters.asp"><img src="but_access_0.gif" name="Image5" width="144" height="28" border="0" id="Image5" onMouseOver="MM_swapImage('Image5','','but_access_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
            </tr>
            <tr>
              <td><img src="spacer.gif" width="8" height="8"></td>
            </tr>
            <tr>
              <td><a href="remote_management.asp"><img src="but_management_0.gif" width="144" height="28" border="0" id="Image6" onMouseOver="MM_swapImage('Image6','','but_management_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
            </tr>
            <tr>
              <td><img src="spacer.gif" width="8" height="8"></td>
            </tr>
            <tr>
              <td><a href="restart.asp"><img src="but_tools_0.gif" width="144" height="28" border="0" id="Image7" onMouseOver="MM_swapImage('Image7','','but_tools_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
            </tr>
            <tr>
              <td><img src="spacer.gif" width="8" height="8"></td>
            </tr>
            <tr>
              <td><a href="#" onClick="show_wizard('wizard.asp')"><img src="but_wizard_0.gif" name="Image71" width="144" height="28" border="0" id="Image71" onMouseOver="MM_swapImage('Image71','','but_wizard_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
            </tr>
            <tr>
              <td><img src="spacer.gif" width="15" height="15"></td>
            </tr>
          </table></td>
          <td width="2%"><img src="spacer.gif" width="15" height="15"></td>
          <td width="78%" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="10"><img src="c2_tl.gif" width="10" height="10"></td>
              <td width="531" background="bg2_t.gif"><img src="spacer.gif" width="10" height="10"></td>
              <td width="10"><img src="c2_tr.gif" width="10" height="10"></td>
            </tr>
            <tr>
              <td background="bg2_l.gif"><img src="spacer.gif" width="10" height="10"></td>
              <td height="400" valign="top" background="bg3.gif">
                  <table width="100%" border="0" cellpadding="3" cellspacing="0">
                    <tr>
                      <td width="85%" class="headerbg">Dynamic</td>
                      <td width="15%" class="headerbg"><a href="help_routing.asp#routing_dynamic" target="_blank"><img src="but_help1_0.gif" width="69" height="28" border="0" id="Image8" onMouseOver="MM_swapImage('Image8','','but_help1_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
                    </tr>
                  </table>
				  <form id="form1" name="form1" method="post" action="apply.cgi">
				  	<input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
                	<input type="hidden" id="html_response_message" name="html_response_message" value="The setting is saved.">
                	<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="dynamic_routing.asp">
                	<input type="hidden" id="reboot_type" name="reboot_type" value="application">
                	<input type="hidden" id="rip_enable" name="rip_enable" value="<% CmoGetCfg("rip_enable","none"); %>">
                	
                  <table width="100%" border="0" cellpadding="5" cellspacing="1" bgcolor="#FFFFFF">
                    <tr>
                      <td align="right" class="bgblue">Transmit </td>
                      <td class="bggrey">
                        <input type="radio" value="0" name="rip_tx_version">
                        Disabled
                        <input type="radio" value="1" name="rip_tx_version">
                        RIP 1&nbsp;
                        <input type="radio" value="2" name="rip_tx_version">
                        RIP 2</td>
                    </tr>
                    <tr>
                      <td align="right" class="bgblue">Receive </td>
                      <td class="bggrey">
                        <input type="radio" value="0" name="rip_rx_version">
                        Disabled
                        <input type="radio" value="1" name="rip_rx_version">
                        RIP 1&nbsp;
                        <input type="radio" value="2" name="rip_rx_version">
                        RIP 2</td>
                    </tr>
                    <tr>
                      <td align="right" class="bgblue">&nbsp;</td>
                      <td class="bggrey2">
                      	<input type="button" value="Cancel" name="cancel" onClick="window.location='dynamic_routing.asp'">
                        <input type="button" value="Apply" name="apply" onClick="send_request()"></td>
                    </tr>
                  </table>
                  <p>&nbsp;</p>
				  </form>                
				  <p>&nbsp;</p></td>
              <td background="bg2_r.gif"><img src="spacer.gif" width="10" height="10"></td>
            </tr>
            <tr>
              <td><img src="c2_bl.gif" width="10" height="10"></td>
              <td background="bg2_b.gif"><img src="spacer.gif" width="10" height="10"></td>
              <td><img src="c2_br.gif" width="10" height="10"></td>
            </tr>
          </table></td>
        </tr>
      </table>      
      <br>
      <br></td>
    <td background="bg1_r.gif">&nbsp;</td>
  </tr>
  <tr>
    <td><img src="c1_bl.gif" width="21" height="20"></td>
    <td align="right" background="bg1_b.gif"><img src="copyright.gif" width="264" height="20"></td>
    <td><img src="c1_br.gif" width="21" height="20"></td>
  </tr>
</table>
</body>
</html>
