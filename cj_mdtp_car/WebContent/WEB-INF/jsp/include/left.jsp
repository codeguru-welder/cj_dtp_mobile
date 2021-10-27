<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="menuList" value="${loginUser.menuList}" />

<c:set var="liStartTg" value="<li class='has-sub'>" />
<c:set var="ulStartTg" value="<ul>" />
<c:set var="liEndTg" value="</li>" />
<c:set var="ulEndTg" value="</ul>" />

<form id="leftMenuFrm" name="leftMenuFrm" method="post" onSubmit="return false;">
	<div id='leftMenu'>
		<ul id="leftMenuUl">
		   <li id="m000000" class='active'><a href='${contextURL}/asvc/common/commonMainView.miaps?type=GET'><span>Home</span></a></li>
			   
		   <c:forEach var="dto" items="${menuList}" varStatus="i">
		   <%-- 닫기 태그 --%>
		   <c:if test="${0 < i.index}">
		   <c:if test="${'0' == dto.upMenuId}">${ulEndTg}${liEndTg}</c:if>
		   </c:if>
		   
		   <%-- 최상위 메뉴 : 20150203 chlee, 메뉴아이콘을 각 메뉴에 맞게 할당하기 위해 span에 class명을 등록한다. --%>
		   <c:if test="${'0' == dto.upMenuId}">
		   ${liStartTg}<a href='#'><span class='icon_${fn:split(dto.menuUrl,"/")[1]}'>${dto.menuNm}</span></a>${ulStartTg}
		   </c:if>
		   
		   <%-- 하위 메뉴 --%>
		   <c:if test="${'0' != dto.upMenuId}">
		   	<li>
		   		<a href="javascript:viewPagePost('${contextURL}${dto.menuUrl}')"><span>${dto.menuNm}</span></a>
		   		<a class='leftTab' onclick="javascript:viewPagePostNewTab('${contextURL}${dto.menuUrl}')" target='_blank' rel="noopener noreferrer"><span class='btn-new-tab'><mink:message code="mink.menu.new.tab"/></span></a>	
		   	</li>
		   </c:if>
		   
		   <%-- 하위 메뉴 &gt; 게시판 --%>
		   <c:if test="${'050000' == dto.menuId && 'N' == dto.deleteYn}">
		   <c:forEach var="bdto" items="${loginUser.boardMenuList}" varStatus="j">
		   <c:if test="${'0' != bdto.boardId}">
		   <li>
		   		<a href="javascript:viewPagePost('${contextURL}/asvc/board/boardDataListView.miaps?type=POST&boardId=<c:out value='${bdto.boardId}'/>')"><span>${bdto.boardNm}</span></a>
		   		<a class='leftTab' onclick="javascript:viewPagePostNewTab('${contextURL}/asvc/board/boardDataListView.miaps?type=POST&boardId=<c:out value='${bdto.boardId}'/>')" target='_blank' rel="noopener noreferrer"><span class='btn-new-tab'><mink:message code="mink.menu.new.tab"/></span></a></li>
		   </c:if>
		   </c:forEach>
		   </c:if>
		   
		   <%-- 닫기 태그 --%>
		   <c:if test="${fn:length(menuList) - 1 == i.index}">${ulEndTg}${liEndTg}</c:if>
		   </c:forEach>
		</ul>
	</div>
</form>
<%--  메뉴form --%>
<form id="menuFrm" name="menuFrm" method="post" onSubmit="return false;">
	<input type="hidden" name="userId" value="${loginUser.userId}" />
	<input type="hidden" name="userNo" value="${loginUser.userNo}"/>
	<input type="hidden" name="grpId" value="${loginUser.userGroup.grpId}"/>
	<input type="hidden" name="upGrpId" value="${loginUser.userGroup.upGrpId}"/>
	<input type="hidden" name="roleGrpId" value="${loginUser.roleGrpIdList}"/> <%-- 권한그룹ID --%>
</form>

<script type="text/javascript">
$(function() {
	<%-- goBoardMenu();	// 게시판 메뉴생성 --%>
	
	<%--  메뉴 권한 검증 --%>
	var leftMenuUrl = document.location.href; <%-- ex)http://localhost:8080/miaps/asvc/user/userListView.miaps? --%>
	leftMenuUrl = leftMenuUrl.split('.miaps'); <%-- ex)http://localhost:8080/miaps/asvc/user/userListView --%>
	leftMenuUrl = leftMenuUrl[0].split('/'); <%-- ex)[0]=http:, ..., [5]=user, [6]=userListView --%>
	leftMenuUrl = leftMenuUrl[leftMenuUrl.length - 1]; <%-- 파일명 추출 // ex)userListView --%>
	
		
	var existAuth = false;
	var url = '';
	$("a", "#leftMenuUl").each(function(){
		<%-- url = $(this).attr("href"); 
			2018.05.28 chlee, a태그의 href에서 새탭열기 스크립트 호출이 동작되지 않아, 새탭열기는 onclick으로 수정하여, href에 url이 undefined일경우, onclick에서 얻는다. 
		--%>
			
		
		if (typeof $(this).attr("href") === 'undefined') {
			url = $(this).attr("onclick");			
		} else {
			url = $(this).attr("href"); 
		}
		url = url.split('.miaps');
		url = url[0].split('/'); <%-- ex)[0]=http:, ..., [5]=user, [6]=userListView --%>
		url = url[url.length - 1]; <%-- 파일명 추출 // ex)userListView --%>
		
		if( !existAuth && url == leftMenuUrl ) {
			existAuth = true;
		}

	});
	
	<%-- 
		TODO: 서버 검증으로 변경필요 (요청 페이지를 출력전에 빠져나가야 함)
		pushDataDetail은 예외처리(메뉴권한 없이 푸시등록완료 후 표시되는 화면URL)
	--%>
	/*
	if(!existAuth && "pushDataDetail" != leftMenuUrl) { 
		//alert('권한이 없는 메뉴입니다.');
		alert("<mink:message code='mink.web.text.nopermission.menu'/>");
		location.href = '../common/commonMainView.miaps?';
	}
	*/
	
});

<%-- 게시판 메뉴생성 --%>
function goBoardMenu() {
	
	$.post('commonBoardMenuList.miaps?', $("#menuFrm").serialize(), function(data){
		$("#leftMenuUl li:not('#m000000')").hide();
		
		<%-- DB에 들어있는 게시판(Y) 메뉴로 동적생성 --%>
		var boardMenu = "";
		for( var i=0; i < data.boardMenuLIstSize; i++ ) {
			var newAlik = "<li><a href=\"javascript:viewPagePost('${contextURL}/asvc/board/boardDataListView.miaps?type=POST&boardId=" 
					+ defenceXSS(data.boardMenuLIst[i].boardId) + "')\">"
					+ defenceXSS(data.boardMenuLIst[i].boardNm) + "</a></li>";
			boardMenu = boardMenu + newAlik;
		}
		$('#boardMenu').html(boardMenu);
		
		var newMenu = "";
		var menuList = null;
		if( "Y" == '${loginUser.adminYn}' ) {	<%-- 슈퍼관리자 권한일 경우 권한에 상관없이 모든 메뉴 표시 --%>
			menuList = data.menuAllList;
		} else {
			menuList = data.menuList;
		}

		var upMenuId = "";
		var last = "";
		for( var i=0; i < menuList.length; i++ ) {
			var dto = menuList[i];
			$("#m"+dto.menuId).show();
			if( nvl(dto.upMenuId) != "" ) {
				/* newMenu = "<ul>";
				newMenu += "<li><a href='${contextURL}"+dto.menuUrl+"'><span>"+dto.menuNm+"</span></a><a class='leftTab' href='${contextURL}"+dto.menuUrl+"' target='_blank' ><span class='btn-dash'>새탭</span></a></li>";
				newMenu += "</ul>";
				$("#m"+dto.upMenuId).append(newMenu); */
			} else {
				
				/* ( "600000" == dto.menuId )? last=" last" : last="";	// 게시판관리
				newMenu = "</li><li class='has-sub'><a href='${contextURL}"+dto.menuUrl+"'><span>"+dto.menuNm+"</span></a>";
				$("#leftMenuUl").append(newMenu); */
			}
			
			
		}
		//$("#leftMenuUl").append("</li>");
		
	}, 'json');
}

<%-- 2018/04/20 유상천
//메뉴 POST로 이동 
//보안 진단(취약점 동적진단) 에서 GET방식은 심각도 '하'의 문제 유형으로 스캔된다.
//보안 권고문 - 본문 매개변수가 조회에서 허용됨
--%> 
function viewPagePost(url) {	
	document.leftMenuFrm.action = url;
	document.leftMenuFrm.submit();
}

<%-- 2018.05.28 chlee, 새탭열기를 post로 열때  viewPagePost함수로는 새탭페이지가 열리지 않으므로 window.open을 이용하도록 새탭함수를 따로 작성. --%>
function viewPagePostNewTab(url) {	
	//window.open("", "_blank");
  	document.leftMenuFrm.action = url;
  	document.leftMenuFrm.target = "_blank";
  	document.leftMenuFrm.submit();
}

</script>
<script type="text/javascript" src="${contextPath}/js/accordion.js"></script>