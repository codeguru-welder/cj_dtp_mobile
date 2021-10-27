<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import = "com.thinkm.mink.asvc.util.DateUtil" %>
<%@ taglib prefix="mink" uri="/WEB-INF/tld/mink.tld" %>
	<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>ThinkM</title>
	<script type="text/javascript">

	var _ua = window.navigator.userAgent.toLowerCase();
//alert("_ua = " + _ua);
	var browser = {
		model: _ua.match(/(samsung-sch-m490|sonyericssonx1i|ipod|iphone)/) ? _ua.match(/(samsung-sch-m490|sonyericssonx1i|ipod|iphone)/)[0] : "",
		skt : /msie/.test( _ua ) && /nate/.test( _ua ),
		lgt : /msie/.test( _ua ) && /([010|011|016|017|018|019]{3}\d{3,4}\d{4}$)/.test( _ua ),
		opera : (/opera/.test( _ua ) && /(ppc|skt)/.test(_ua)) || /opera mobi/.test( _ua ),
		ipod : /webkit/.test( _ua ) && /\(ipod/.test( _ua ) ,
		iphone : /webkit/.test( _ua ) && /\(iphone/.test( _ua ),
		ipad : /webkit/.test( _ua ) && /\(ipad/.test( _ua ),
		lgtwv : /wv/.test( _ua ) && /lgtelecom/.test( _ua ),
		android : /webkit/.test( _ua ) && /android/.test( _ua ),
		ie : /msie/.test( _ua )
	};
//	alert("browser.ipad = " + browser.ipad);

	if(browser.opera) {
		document.write("<meta name=\"viewport\" content=\"user-scalable=no, initial-scale=0.75, maximum-scale=0.75, minimum-scale=0.75\" \/>");
	} else if (browser.ipod || browser.iphone || browser.ipad) {
		setTimeout(function() { if(window.pageYOffset == 0){ window.scrollTo(0, 1);} }, 100);
	} else if (browser.lgtwv || browser.skt || browser.lgt) {
	} else if (browser.android) {
	} else {
	}

	function include_file(type, fileName) {
		var oHead = document.getElementsByTagName("head")

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
					JS.src  = 'js/' + fileName + '.js';
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

	function init() {
		setHiddenInputs();
		focusOne();
		//chkPwdInput();
		chkPlatform(); // test 를 위한 주석처리 2010/11/03 mksong 
	}

	function setHiddenInputs() {
		var url = decodeURIComponent(getParameter("url"));
		if (url) {
		document.getElementById("url").value = url;
		}
		document.getElementById("relative").value = getParameter("relative");
		document.getElementById("brand").value = getParameter("brand");
	}
	function getParameter(name) {
		var query = window.location.search.substring(1);
		var params = query.split("&");
		for (var i = 0; i < params.length; i++) {
			var pos = params[i].indexOf("=");
			if (pos == -1) continue;
			if (name == params[i].substring(0, pos)) {
				return params[i].substring(pos + 1);
			}
		}
		return "";
	}
	function focusOne() {
		 //if (document.getElementById("sid").checked) {
//			document.getElementById("enpw").focus();
		//} else {
			document.getElementById("userid").focus();
		//}
	}

	function onClickCheck(cBox) {
		box = eval(cBox);
		box.checked = !box.checked;
		box.click();
	}
	function saveId() {
		var ip_sid = document.getElementById("sid");
		return true;
	}
	function getCookie(agName) {
		var ckName = agName + '=';
		var cookie = document.cookie;
		var start = cookie.indexOf(ckName);
		if(start != -1) {
			start += ckName.length;
			var end = cookie.indexOf(';', start);
			if(end == -1) {
				end = cookie.length;
			}
		return cookie.substring(start, end);
		}
		return null;
	}
	function chkPwdInput() {
		var ip_sid = document.getElementById("sid");
		if((!ip_sid.checked)) { //&& (ip_spw.checked)) {
			ip_sid.checked = true;
		}
	}
	function chkPlatform() {
		var f = document.mink_login_form;

		if (browser.ipad || browser.ipod || browser.iphone) {
			f.platformName.value = "2000013";
 			//alert("아이폰 계열로 접속하셨습니다.");
		} else if (browser.android) {
			f.platformName.value = "2000012";
 			//alert("안드로이드 플랫폼 환경입니다.");
		} else if (browser.ie) {
////웹개발환경용 Start (로그인하려는 플랫폼의 커멘트를 해제)
			//alert("Internet Explorer 환경입니다. 임시로 사용가능하게 함(안드로이드 목록나오게)");
			f.platformName.value = "2000012";
////웹개발환경용 End

//운영용 Start (개발환경 테스트시에는 커멘트처리후 테스트)
//			f.platformName.value = "ie";
//			f.action = "prehibitUse.do";
//			f.submit();
//운영용 End(개발환경 테스트시에는 커멘트처리후 테스트)

		}  else {
			//alert("Internet Explorer 환경입니다. 임시로 사용가능하게 함(안드로이드 목록나오게)");
			f.platformName.value = "2000012";
//			f.platformName.value = "2000013";
		}
	}
	
	function login() {
		var form = document.mink_login_form;
		
		if(form.lfcrmShopCode.value == "") {
			alert("매장코드를 입력해주세요.");
			return;
		}
		
		if(form.lfcrmPhone.value == "" || isNaN(form.lfcrmPhone.value) == true) {
			alert("전화번호를 정확히 입력해주세요.");
			return;
		}
		
		if(form.lfcrmPassword.value == "") {
			alert("비밀번호를 입력해주세요.");
			return;
		}
		
		form.action = "lfcrmDownload.miaps";
		form.submit();
	}
	
	</script>
<link rel="stylesheet" type="text/css" href="../css/screen.css" media="screen" />		
</head>

<body onload="init()">
<div id="mobileWrap">
	<div id="logtop"><h1> <span></span></h1></div>
	<div id="contentsWrap">	
		<form name="mink_login_form" id="loginform" method="post" action="lfposLoginCheckM.do" >
		<input type="hidden" name="platformName" id="platformName"/>
		<!-- <input type="hidden" name="packageNm" id="packageNm" value="com.lfcorp.miaps.posdev"/> -->
			<fieldset>
			<legend>Login</legend>
			<div class="login_brd_wrap">
				<span class="imbg login_inlt"> </span><span class="imbg login_inrt"> </span>
				<div class="login_wrap">
					<dl>
			       		<c:if test="${validUser == 'N'}">
							<p class="notice_save2" >입력하신 매장코드 혹은 비밀번호가  
								<br />일치하지 않습니다.
							</p>
			       		</c:if>
					</dl>
					<dl>
						<dt><label for="id">매장코드</label></dt>
						<dd><input type="text" name="lfcrmShopCode" id="lfcrmShopCode" maxlength="30" value="" tabindex="1"  title="userid" /></dd>
						<dt><label for="id">전화번호</label></dt>
						<dd><input type="text" name="lfcrmPhone" id="lfcrmPhone" maxlength="30" value="" tabindex="1"  title="tel" /></dd>
						<dt><label for="userPw">비밀번호</label></dt>
						<dd>
							<input type="hidden" name="platform" id="platform" value="" />
							<input type="password" name="lfcrmPassword" id="lfcrmPassword" autocomplete="off" maxlength="32" value="" tabindex="2" title="password" />
						</dd>
					</dl>
					<p class="id_save">
						<%-- <input type="checkbox"  name="saved_id" id="sid" tabindex="3" onclick="return saveId();" /><label id="idsave" for="sid" onclick="return saveId();"><mink:message code='mink.label.id_save' text='매장코드 저장'/></label> --%>
					</p>
				</div>
				<p class="notice_save3" >매장코드와 비밀번호를 입력하세요.</p>
				<span class="imbg login_inlb"> </span><span class="imbg login_inrb"> </span>
			</div>
			<!-- <input type="image" id="submit" src="img/btn_login.png" class="submit" />	 -->
			</fieldset>
			<table>
				<tr>
					<td width="96"  height="30" background="img/btn_login.png"  onclick="javascript:login()"><div align="center" style="font: bold 12pt 굴림; color: #5D5D5D"><a href="#"><mink:message code='mink.label.login' text='로그인'/></a></div></td>
				</tr>
			</table>
		</form>
	</div><!-- // contents -->
	<div id="footerWrap" ><p class="copy">COPYRIGHT 2016 LF. ALL RIGHTS RESERVED.
	<br /><br /><font color="blue"><mink:message code="mink.message.login_msg_employee" text="임직원을 위한 시스템으로서 인가된 분만 사용할 수 있습니다." /> <br />
          <mink:message code="mink.message.login_msg_legal" text="불법으로 사용시에는 법적 제재를 받을 수가 있습니다." /></font></p>
	</div>
	</div><!-- // mobile_wrap -->
</body>
</html>