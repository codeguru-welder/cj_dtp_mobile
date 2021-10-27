<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" />

<script type="text/javascript" src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-ui-1.10.4.custom.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.ui.datepicker.kr.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.form.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/appcenterCommon.js"/>"></script>

<link rel="stylesheet" type="text/css" href="<c:url value="/css/admincenter.css"/>">
<link rel="stylesheet" type="text/css" href="<c:url value="/css/include.css"/>">
<link rel="shortcut icon" href="<c:url value="/favicon.ico"/>" />

<script type="text/javascript">
function init(){
	var isMobile = {
	        Android: function () {
	                 return navigator.userAgent.match(/Android/i);
	        },
	        BlackBerry: function () {
	                 return navigator.userAgent.match(/BlackBerry/i);
	        },
	        iOS: function () {
	                 return navigator.userAgent.match(/iPhone|iPod/i);
	        },
	        iPad: function () {
                //return navigator.userAgent.match(/iPad/i); iPadOS13에서 iPad가 아니라 Macintosh
	        	return navigator.userAgent.match(/iPad|Macintosh/i) && 'ontouchend' in document;
       		},
	        Opera: function () {
	                 return navigator.userAgent.match(/Opera Mini/i);
	        },
	        Windows: function () {
	                 return navigator.userAgent.match(/IEMobile/i);
	        },
	        any: function () {
	                 return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
	        }
	};
		
	if( isMobile.iOS() ) {
		$("input[name='platformCd']").val('${PLATFORM_IOS}');
	} else if( isMobile.iPad() ) {
		$("input[name='platformCd']").val('${PLATFORM_IOS_TBL}');
	} else if( isMobile.Android() || isMobile.BlackBerry() ) {
		$("input[name='platformCd']").val("${PLATFORM_ANDROID}");
	} else {
		$("input[name='platformCd']").val("");
	}
}

</script>