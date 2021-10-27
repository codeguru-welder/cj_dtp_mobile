<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mink" uri="/WEB-INF/tld/mink.tld" %>

<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />

<%@ page import = "com.thinkm.mink.commons.MinkTotalConstants" %>
<%@ page import = "com.thinkm.mink.commons.MinkTotalConstantsProperties" %>
<%@ page import = "com.thinkm.mink.commons.util.DateUtil" %>
<%@ page import = "com.thinkm.mink.asvc.dto.*" %>
<c:set var="protocol" value="http" />
<c:if test="<%=request.isSecure()%>">
<c:set var="protocol" value="https" />
</c:if>
<c:set var="searverName" value="${pageContext.request.serverName}" />
<c:set var="serverPort" value="${pageContext.request.serverPort}" />
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:set var="contextURL" value="${contextPath}" />

<c:set var="corporation" value="<%=MinkTotalConstants.CORPORATION_GROUP%>" /><%-- 회사 그룹ID(최상위): 0000000000 --%>
<c:set var="corporationName" value="<%=MinkTotalConstantsProperties.CORPORATION_NAME%>" /><%-- 회사명: root --%>
<c:set var="unclassified" value="<%=MinkTotalConstants.UNCLASSIFIED_GROUP%>" /><%-- 그룹없음ID: unclassified --%>
<c:set var="unclassifiedName" value="<%=MinkTotalConstantsProperties.UNCLASSIFIED_GROUP_NAME%>" /><%-- 그룹없음명: 그룹없음 --%>
<c:set var="superAdmin" value="<%=MinkTotalConstantsProperties.SUPER_ADMIN_ROLE_NAME%>" /><%-- 권한명: 슈퍼관리자 --%>
<c:set var="subAdmin" value="<%=MinkTotalConstantsProperties.SUB_ADMIN_ROLE_NAME%>" /><%-- 권한명: 그룹관리자 --%>
<c:set var="commUser" value="<%=MinkTotalConstantsProperties.COMM_USER_ROLE_NAME%>" /><%-- 권한명: 일반사용자 --%>
<c:set var="subGroupContainText" value="<%=MinkTotalConstantsProperties.SUB_GROUP_CONTAIN_TEXT%>" /><%-- 그룹하위포함여부명: 하위포함 --%>
<c:set var="ynYes" value="<%=MinkTotalConstants.YN_YES%>" /><%-- Y --%>
<c:set var="ynNo" value="<%=MinkTotalConstants.YN_NO%>" /><%-- N --%>
<c:set var="twSearchUserGroup" value="${search.searchUserGroup}" /><%-- treeview 그룹검색시, 검색한 그룹정보 --%>
<c:set var="twSearchSubAllYn" value="${search.searchUserGroupSubAllYn}" /><%-- treeview 그룹검색시, 하위그룹포함여부 --%>

<%-- CODE Constants --%>
<c:set var="PLATFORM_IOS" value="<%=MinkTotalConstants.PLATFORM_IOS%>" />
<c:set var="PLATFORM_IOS_TBL" value="<%=MinkTotalConstants.PLATFORM_IOS_TBL%>" />
<c:set var="PLATFORM_ANDROID" value="<%=MinkTotalConstants.PLATFORM_ANDROID%>" />
<c:set var="PLATFORM_ANDROID_TBL" value="<%=MinkTotalConstants.PLATFORM_ANDROID_TBL%>" />
<c:set var="PLATFORM_WEB" value="<%=MinkTotalConstants.PLATFORM_WEB%>" />
<c:set var="APP_REG_ST" value="<%=MinkTotalConstants.APP_REG_ST%>" />
<c:set var="DEVICE_ST_ACTIVE" value="<%=MinkTotalConstants.DEVICE_ST_ACTIVE%>" />
<c:set var="DEVICE_ST_SUSPENDED" value="<%=MinkTotalConstants.DEVICE_ST_SUSPENDED%>" />
<c:set var="DEVICE_ST_DISUSED" value="<%=MinkTotalConstants.DEVICE_ST_DISUSED%>" />
<c:set var="PUSH_DATA_ST_NEW" value="<%=MinkTotalConstants.PUSH_DATA_ST_NEW%>" />
<c:set var="PUSH_DATA_ST_DELETED" value="<%=MinkTotalConstants.PUSH_DATA_ST_DELETED%>" />
<c:set var="PUSH_DATA_ST_TARGETED" value="<%=MinkTotalConstants.PUSH_DATA_ST_TARGETED%>" />
<c:set var="PUSH_DATA_ST_SENT" value="<%=MinkTotalConstants.PUSH_DATA_ST_SENT%>" />
<c:set var="loginUser" value="" /><%-- 로그인 사용자 --%>