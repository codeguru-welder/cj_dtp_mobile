<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<c:if test="${isFixedScale == 'true'}">
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=yes" />
</c:if>
<c:if test="${isFixedScale == 'false'}">
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes" />
</c:if>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<c:set var="protocol" value="http" />
<c:if test="<%=request.isSecure()%>">
<c:set var="protocol" value="https" />
</c:if>
<c:set var="searverName" value="${pageContext.request.serverName}" />
<c:set var="serverPort" value="${pageContext.request.serverPort}" />
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:set var="contextURL" value="${contextPath}" />

<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.10.2.js"></script>
<style type="text/css">
img {
	width: inherit;
	max-width: 100%;
	heigth: auto;
}
</style>
<script type="text/javascript">
$(function() {
	var blankUrl = "mink://minkReturnByWeb?url={url}"; // 새창으로 열기(브라우저앱 실행)

	if (eval("${isFixedScale}") == true) {
		$("img").each(function() {
			var imgUrl_o = $(this).attr("src");
			var imgUrl = encodeURIComponent(imgUrl_o);
			var title = $(this).attr("title");
			var imgAlt = encodeURIComponent(title);
			$(this).attr("alt", title);
			$(this).click(function(){
				var url = "${fileUrl}" + "/app/appBoardDetailImg.miaps?imgUrl=" + imgUrl + "&imgAlt=" + imgAlt; // 이미지 클릭시 원본이미지 보기(새창)
				url = encodeURIComponent(url);
				var newUrl = blankUrl.replace("{url}", url);
				//alert("imgUrl_o: " + imgUrl_o + "\n\nnewUrl: " + newUrl); // 디버깅용(원본URL 팝업)
				location.href = newUrl;
			});
		});
	}

	$("a").each(function() {
		var aUrl_o = $(this).attr("href");
		var url = encodeURIComponent(aUrl_o);
		var newUrl = blankUrl.replace("{url}", url);
		//$(this).click(function(){ alert("aUrl_o: " + aUrl_o + "\n\nnewUrl: " + newUrl); }); // 디버깅용(원본URL 팝업)
		$(this).attr("href", newUrl);
	});

});
</script>
<title>${boardData.subject}</title>
</head>
<body>${contents}</body>
</html>
