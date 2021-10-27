<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<!--<%@ page language="java" contentType="text/html; charset=UTF-8"%>-->

<%@ page session="false"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import = "com.thinkm.mink.asvc.util.DateUtil" %>

<%@ taglib prefix="mink" uri="/WEB-INF/tld/mink.tld" %>
<c:set var="iphone" scope="request" value="2000013" />
<c:set var="android" scope="request" value="2000012" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
	<title>ThinkM</title>
	<script type="text/javascript">

	var _ua = window.navigator.userAgent.toLowerCase();

	var browser = {
		model: _ua.match(/(samsung-sch-m490|sonyericssonx1i|ipod|iphone)/) ? _ua.match(/(samsung-sch-m490|sonyericssonx1i|ipod|iphone)/)[0] : "",
		skt : /msie/.test( _ua ) && /nate/.test( _ua ),
		lgt : /msie/.test( _ua ) && /([010|011|016|017|018|019]{3}\d{3,4}\d{4}$)/.test( _ua ),
		opera : (/opera/.test( _ua ) && /(ppc|skt)/.test(_ua)) || /opera mobi/.test( _ua ),
		ipod : /webkit/.test( _ua ) && /\(ipod/.test( _ua ) ,
		iphone : /webkit/.test( _ua ) && /\(iphone/.test( _ua ),
		lgtwv : /wv/.test( _ua ) && /lgtelecom/.test( _ua )
	};

	if(browser.opera) {
		document.write("<meta name=\"viewport\" content=\"user-scalable=no, initial-scale=0.75, maximum-scale=0.75, minimum-scale=0.75\" \/>");
	} else if (browser.ipod || browser.iphone) {
		setTimeout(function() { if(window.pageYOffset == 0){ window.scrollTo(0, 1);} }, 100);
	} else if (browser.lgtwv || browser.skt || browser.lgt) {
//		
	}
    //IE접속일 경우 메세지 "Internet Explorer는 지원하지 않습니다." 를 출력한다.
    
	function include_file(type, fileName) {
		var oHead = document.getElementsByTagName("head");

		if (oHead.length < 1)  return false;
		else {
			switch (type) {
				case 'CSS':
					var CSS =  document.createElement('link');
					CSS.rel   = 'stylesheet';
					CSS.type  = 'text/css';
					CSS.href  = '../css/' + fileName + '.css';
					oHead[0].appendChild(CSS);
					break;
				case 'JS':
					var JS  = document.createElement('script');
					JS.type = 'text/javascript';
					oHead[0].appendChild(JS);
					break;
				default:
					break;
			}
		}
	}

	try {
		if (browser.skt || browser.lgt || browser.lgtwv) {
			include_file('CSS', 'login_fb');
		} else if(browser.opera) {
			include_file('CSS', 'login_ipn');
			include_file('CSS', 'login_op');
		} else {
			include_file('CSS', 'login_ipn');
		}
	}
	catch (e) {	}
	
function hangul(a)
{
     week = new Array(7);
     week[0] = "<mink:message code='mink.label.sunday' text='일요일' />";
     week[1] = "<mink:message code='mink.label.monday' text='월요일' />";
     week[2] = "<mink:message code='mink.label.tuesday' text='화요일' />";
     week[3] = "<mink:message code='mink.label.wednesday' text='수요일' />";
     week[4] = "<mink:message code='mink.label.thursday' text='목요일' />";
     week[5] = "<mink:message code='mink.label.friday' text='금요일' />";
     week[6] = "<mink:message code='mink.label.saturday' text='토요일' />";
     return week[a];
}

function realtimeClock() {
  document.mink_form.rtcInput.value = getTimeStamp();
  setTimeout("realtimeClock()", 1000);
}


function getTimeStamp() { // 24시간제
  var d = new Date();
  var s =
    leadingZeros(d.getFullYear(), 4) + '-' +
    leadingZeros(d.getMonth() + 1, 2) + '-' +
    leadingZeros(d.getDate(), 2) + ' ' +
    leadingZeros(hangul(d.getDay()), 3);
  return s;
}


function leadingZeros(n, digits) {
  var zero = '';
  n = n.toString();

  if (n.length < digits) {
    for (var i = 0; i < digits - n.length; i++)
      zero += '0';
  }
  return zero + n;
}

//2012-11-22 -yu
function logout() {
	var form = document.mink_form;
	
	form.action = "oldMinkLoginM.miaps";
	form.submit();
}

function appDownload(platformCd, appId, versionNo, userId, deviceId) {
	if(platformCd == ${iphone}) {
		//alert("iphone");
	//	location.href = 'fileIphoneDownload.do?Filename=' + encodeURIComponent(appFilePath) + '&manifest=' + encodeURIComponent(manifest) + '&appCd=' + appCd + '&appVersion=' + appVersion + '&platformCd=' + platformCd + '&platformVer=' + platformVer ;
		location.href = 'appFileDownUrlReq.miaps?platformCd=' + platformCd + '&appId=' + appId + '&versionNo=' + versionNo + '&userId=' + userId + '&deviceId=' + deviceId + '&filegubun=' + 'manifestFile' ;
	//	location.href = "itms-services://?action=download-manifest&amp;url=https://miaps.thinkm.co.kr/miaps3/lfpos/LFPosDev.plist";		
	} else if (platformCd == ${android}) {
		//alert("android");
//		location.href = 'fileDownload.do?file3Name90818=' + encodeURIComponent(appFilePath) + '&appCd=' + appCd + '&appVersion=' + appVersion + '&platformCd=' + platformCd + '&platformVer=' + platformVer ;
		location.href = 'appFileDown.miaps?platformCd=' + platformCd + '&appId=' + appId + '&versionNo=' + versionNo + '&userId=' + userId + '&deviceId=' + deviceId + '&filegubun=' + 'appFile' ;
		//location.href = "http://121.50.21.204:9090/lfposdev/app/appInstall.miaps?q=ODsDsk2paJg%3D&filegubun=appFile&platformCd=2000012";
	}
}

	</script>

<link rel="stylesheet" type="text/css" href="../css/screen.css" media="screen" />
<style type="text/css">
<!--
.style1 {color: #000000}
.style2 {color: #FFFFFF}
.style4 {color: #000000; font-weight: bold; }
-->
</style>	
	
</head>
<body onload="realtimeClock()">

<div id="mobileWrap">
	<div id="logtop"><h1> <span></span></h1></div> 
	<div id="contentsWrap">	 
	 <form name="mink_form" method="post">
	<div>
			<!-- 날짜 요일을 표시  -->
			<label for="rtcInput" ></label>				
			<input type="text" name="rtcInput" size="20" style="border: 0px solid #ffffff" readonly="readonly" />
	</div>
	<div>
			<!-- 로그인 한 사용자의 이름을 표시  -->
			<font face="Calibri" color="blue" size="2"><b>${login_companyname}</b></font>
			<font face="Calibri" color="blue" size="2"><b>${login_username}</b></font>
	</div>				

	<br />
				
				  		<div id="appinfo_wrap" >
				
				<table border ="0" width="270">

						<tr>
							<td width = "10"></td>
							<td  width="178" height ="10"></td>
						</tr>
						<tr>
							<td></td>
							<td><div style="font: bold 8pt 굴림; color: #5D5D5D">
							인증 유효시간이 지났습니다.<br><br>브라우저를 종료하고 다시 포탈에 접속하여<br><br>로그인을  시도하세요.</div></td>
				</table>	 
			<br />
       	</div>
				
		</form>
	</div><!-- // contents -->
	<h2 style="padding-top: 1px; background-color: #CBCEDB;  background-position: left -40px; "></h2>
	<div id="footerWrap" class="imbg"><p class="copy">Copyright ⓒ 2015 ThinkM. All rights reserved.</p></div>
</div><!-- // mobile_wrap -->

</body>
<link rel="stylesheet" type="text/css" href="../css/css01.css" media="screen" />
<style type="text/css">
<!--
#appinfo_wrap{

}
.app1{ 
 background-color: #CECEF6;
 color: white;
}
.app2{
 background-color: #F5F5F5;
}
.app3{
 background-color: #BDBDBD;
}
-->
</style>
</html>