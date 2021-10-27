<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script type="text/javascript">
function goHome() {
	var frm = document.searchFrm;
	frm.platformCd.value = "${search.platformCd}";
	frm.startRow.value = 0; // 이동할 페이지
	frm.addList.value = "";
	frm.searchValue.value = "";
	frm.searchKey.value = "";
	frm.action = 'appClientListView.miaps?';
	frm.submit();
	
}

// 탭 목록검색
function goTabList(gubun) {
	var frm = document.searchFrm;
	frm.platformCd.value = "${search.platformCd}";
	frm.startRow.value = 0; // 이동할 페이지
	frm.gubun.value = gubun;
	frm.addList.value = "";
	frm.searchValue.value = "";
	frm.searchKey.value = "";
	frm.action = 'appClientListGubunView.miaps?';
	frm.submit();
}

// 카테고리 목록검색
function goCategory() {
	var frm = document.searchFrm;
	frm.platformCd.value = "${search.platformCd}";
	frm.startRow.value = 0; // 이동할 페이지
	frm.addList.value = "";
	frm.searchValue.value = "";
	frm.searchKey.value = "";
	frm.action = 'appCategoryListView.miaps?';
	frm.submit();
}

// 상세조회호출
function goDetail(appId) {
	var frm = document.searchFrm;
	frm.platformCd.value = "${search.platformCd}";
	frm.appId.value = appId;
	frm.searchValue.value = "";
	frm.searchKey.value = "";
	frm.action = 'appClientDetail.miaps?appId='+appId;
	frm.submit();
}

function goSearch() {
	var frm = document.searchFrm;
	frm.platformCd.value = "${search.platformCd}";
	frm.startRow.value = 0; // 이동할 페이지
	frm.gubun.value = "";
	frm.addList.value = "";
	frm.searchValue.value = "_^&%$_"; <%-- 최초검색방지문자 --%>
	frm.searchKey.value = "appNm";
	frm.action = 'appClientListSearchView.miaps?';
	frm.submit();
}

function goBack() {
	window.history.back();
}
</script>    
    
<table class="menu-bar">
<colgroup>
	<col width="16.6%" />
	<col width="16.6%" />
	<col width="16.6%" />
	<col width="16.6%" />
	<col width="16.6%" />
	<col width="16.6%" />	
</colgroup><tr>
<td><a href="javascript:goBack();"><img src="${contextPath}/app/images/app_menu_back.png" width="32px" height="32px"></a></td>
<td><a href="javascript:goHome();"><img src="${contextPath}/app/images/app_menu_home.png" width="32px" height="32px"></a></td>
<td><a href="javascript:goTabList('');"><img src="${contextPath}/app/images/app_menu_all.png" width="32px" height="32px"></a></td>
<td><a href="javascript:goTabList('my');"><img src="${contextPath}/app/images/app_menu_my.png" width="32px" height="32px"></a></td>
<td><a href="javascript:goSearch();"><img src="${contextPath}/app/images/app_menu_search.png" width="32px" height="32px"></a></td>
<td><a href="javascript:goCategory();"><img src="${contextPath}/app/images/app_menu_category.png" width="32px" height="32px"></a></td>
</tr><tr>
<td><a style="text-decoration: none;" href="javascript:goBack();"><mink:message code="mink.web.text.back"/></a></td>
<td><a style="text-decoration: none;" href="javascript:goHome();"><mink:message code="mink.web.text.home"/></a></td>
<td><a style="text-decoration: none;" href="javascript:goTabList('');"><mink:message code="mink.web.text.totalapp"/></a></td>
<td><a style="text-decoration: none;" href="javascript:goTabList('my');"><mink:message code="mink.web.text.myapp"/></a></td>
<td><a style="text-decoration: none;" href="javascript:goSearch();"><mink:message code="mink.web.text.search"/></a></td>
<td><a style="text-decoration: none;" href="javascript:goCategory();"><mink:message code="mink.web.text.category"/></a></td>
</tr></table>