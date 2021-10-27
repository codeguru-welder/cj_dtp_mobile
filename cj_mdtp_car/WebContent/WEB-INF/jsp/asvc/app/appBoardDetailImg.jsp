<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
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
});
</script>
<title>${imgAlt}</title>
</head>
<body><img alt="${imgAlt}" title="${imgAlt}" src="${imgUrl}" /></body>
</html>
