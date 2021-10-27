<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 환경설정 - 코드 그룹 화면 (settingCodeGroupView.jsp)
	 * 
	 * @author chlee
	 * @since 2015.09.18	 
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
<title><mink:message code="mink.label.page_title"/></title>

<c:set var="CODE_DETAIL_ID_TEXT" value="50자리이내의 숫자/문자" />

<!-- 좌측리스트용 script -->
<script type="text/javascript">
$(document).ready(function() {
	//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
	init_accordion('setting', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.setting_codeclassification'/>");
	
	init(); // 이벤트 핸들러 세팅
	
	showList(); <%-- 목록 보이기 --%>
	showPageHtml();
});

function textareaResize(obj) {
	obj.style.height = "1px";
	obj.style.height = (20 + obj.scrollHeight) + "px";
}

<%-- 코드그룹(좌측리스트) 목록검색 --%>
function goList(pageNum) {
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.SearchFrm.searchValue.value); 
	document.SearchFrm.searchValue.value = _searchVal;
	
	document.SearchFrm.pageNum.value = pageNum; <%-- 이동할 페이지 --%>
	document.SearchFrm.action = 'settingCodeGroupListView.miaps?';
	document.SearchFrm.submit();
}

<%-- 코드그룹(좌측리스트) 상세팝업 --%>
function goDetail(cdGrpId) {
	cancelPropagation(event);	//tr클릭 이벤트 막음
	$("#detailFrm").find("input[name='cdGrpId']").val(cdGrpId); <%-- (선택한)상세 --%>
	
	ajaxComm('settingCodeGroup.miaps?', $('#detailFrm'), function(data){
		fnSetCodeGroupDetail(data.codeGroup); <%-- 상세 ajax 세부작업 --%>
		});
}
<%-- 코드그룹 상세팝업으로 가져온 값을 세팅 --%>
function fnSetCodeGroupDetail(result) {
	var frm = $("#detailFrm");
	frm.find("input[name='cdGrpId']").val(result.cdGrpId);
	frm.find("input[name='cdGrpNm']").val(result.cdGrpNm);
	frm.find("input[name='orderSeq']").val(result.orderSeq);
	frm.find("input:radio[name='systemYn'][value='" + result.systemYn + "']").prop('checked', true); <%-- //.attr("checked", "true"); --%>
	frm.find("textarea[name='cdGrpDesc']").val(result.cdDtlDesc);
	
	if ('000' == result.cdGrpId) $("#updateBtn_settingCodeGroupModiDialog").hide(); // [기본게시판]앱 공지사항
	else $("#updateBtn_settingCodeGroupModiDialog").show();
	
	$("#settingCodeGroupModiDialog").dialog( "open" );
}

function onfocusCdGrpId(obj) {
	obj.value = '';
}

function onfocusoutCdGrpId(obj) {
	if(obj.value == null || obj.value == '') {
		obj.value = "<mink:message code='mink.web.text.3numchar'/>";
	}
}

<%-- 코드그룹(좌측리스트) 여러개 삭제요청(ajax) --%>
function goDeleteAll() {
	<%-- 검증 --%>
	if($("#listTbody").find(":checkbox:checked").length < 1) {
		alert("<mink:message code='mink.web.alert.select.deleteitem'/>");
		return;
	}
	if( !confirm("<mink:message code='mink.web.alert.is.delete'/>") ) return;
	ajaxComm('settingCodeGroupDelete.miaps?', $('#SearchFrm'), function(data){
		resultMsg(data.msg);
		document.SearchFrm.cdGrpId.value = ''; <%-- (삭제한)상세 비움 --%>
		goList('1'); <%-- 목록/검색 --%>
	});
}
</script>

<!-- 우측리스트용 script -->
<script type="text/javascript">

<%-- 코드상세(우측리스트) 목록검색 --%>
function goListR(pageNum, cdGrpId) {
	checkedTrCheckbox($("#listTr"+cdGrpId));	<%-- 선택된 row 색깔변경 --%>
	document.SearchFrmR.pageNum.value = pageNum; <%-- 이동할 페이지 --%>		
	$("#SearchFrm").find("input[name='cdGrpId']").val(cdGrpId);	//코드그룹(좌측리스트)에 값 저장해놓음
	
	ajaxComm('settingCodeDetailListViewJSON.miaps?', $('#SearchFrm'), function(data) {
		setTbodyRList(data.cdDtlList);
	});
}

<%-- 코드상세(우측리스트) 리스트 그리기 --%>
function setTbodyRList(data) {

	$('#listTbodyR').empty();
	var tBody = "";
	if($(data).length > 0) {
		for(var i = 0;i < Object.keys(data).length; i++) {
			var cdId = data[i].cdGrpId + '' + data[i].cdDtlId;
			tBody += "<tr id='listTrr"+ cdId + "' " + "onclick=\"javascript:goDetailR('"+data[i].cdGrpId+"', '"+ data[i].cdDtlId +"');\">";
			tBody += 	"<td>";
			if ('000001' == cdId) {
				tBody +=""; // [기본게시판]앱 공지사항 - 공지
			} else if ('000002' == cdId) {
				tBody +=""; // [기본게시판]앱 공지사항 - 점검
			} else if ('000003' == cdId) {
				tBody +=""; // [기본게시판]앱 공지사항 - 업데이트
			} else {
				tBody +="<input type='checkbox' name='cdDtlIds' value='"+ cdId +"' onclick='checkedCheckboxInTr(event)'/>";
			}
			tBody +=	"</td>";
			tBody +=	"<input type='hidden' name='cdGrpNm' value='"+ defenceXSS(data[i].cdGrpNm) +"'>";	//코드상세 팝업창 오픈 시 코드그룹 이름을 구하기위해 저장 or 쿼리수정
			tBody +=	"<td align='center'>"+data[i].orderSeq+"</td>";
			tBody +=	"<td align='center'>"+data[i].cdDtlId+"</td>";
			tBody +=	"<td align='left'>"+defenceXSS(data[i].cdDtlNm)+"</td>";
			tBody +=	"<td>"+data[i].regDt+"</td>";
			tBody += "</tr>";	
		}
		
		$('#listTbodyR').append(tBody);		
		$('#listTfootR').hide();
	} else {
		tBody += "<tr>";
		tBody += 	"<td colspan='6'><mink:message code='mink.web.text.noexist.result'/></td>";
		tBody += "</tr>";
		$('#listTfootR').html(tBody);
		$('#listTfootR').show();
	}
	
}

<%-- 코드상세(우측리스트) 에서 검색시 --%>
function goListRR(pageNum) {
	var cdGrpId = $("#SearchFrm").find("input[name='cdGrpId']").val(); // 선택한 코드그룹 코드
	document.SearchFrmR.pageNum.value = pageNum; <%-- 이동할 페이지 --%>
	$("#SearchFrmR").find("input[name='cdGrpId']").val(cdGrpId);	//검색 시 사용될 코드그룹 코드 세팅
	ajaxComm('settingCodeDetailListViewJSON.miaps?', $('#SearchFrmR'), function(data) {
		setTbodyRList(data.cdDtlList);
	});
}

<%-- 코드상세(우측리스트) 상세팝업 --%>
function goDetailR(cdGrpId, cdDtlId) {
	$("#detailFrmR").find("select[name='cdGrpId']").empty();
	$("#detailFrmR").find("select[name='cdGrpId']").append("<option value='"+ cdGrpId+"'>"); <%-- (선택한)상세 --%>
	$("#detailFrmR").find("input[name='cdDtlId']").val(cdDtlId); <%-- (선택한)상세 --%>
	
	ajaxComm('settingCodeDetailContents.miaps?', $('#detailFrmR'), function(data){
		fnSetCodeDetailDetail(data.codeDetail); <%-- 상세 ajax 세부작업 --%>
	});
}

<%-- 코드상세 상세팝업으로 가져온 값을 세팅 --%>
function fnSetCodeDetailDetail(result) {
	var cdGrpId = result.cdGrpId;
	var cdDtlId = result.cdDtlId;
	var cdGrpNm = $("#SearchFrmR").find("tr[id='listTrr"+ cdGrpId+cdDtlId +"'] input[name='cdGrpNm']").val(); //팝업창에 표시될 코드그룹명

	var frm = $("#detailFrmR");
	frm.find("select[name='cdGrpId']").empty();
	frm.find("select[name='cdGrpId']").append("<option value='"+ cdGrpId+"' selected>"+defenceXSS(cdGrpNm)+"("+cdGrpId+")</option>");
	frm.find("input[name='cdDtlId']").val(cdDtlId);
	frm.find("input[name='cdDtlNm']").val(result.cdDtlNm);
	frm.find("input[name='orderSeq']").val(result.orderSeq);
	frm.find("textarea[name='cdDtlDesc']").val(result.cdDtlDesc);
	
	// 저장버튼 숨김
	var cdId = result.cdGrpId + '' + result.cdDtlId;
	if ('000001' == cdId) $("#updateBtn_settingCodeDetailModiDialog").hide(); // [기본게시판]앱 공지사항 - 공지
	else if ('000002' == cdId) $("#updateBtn_settingCodeDetailModiDialog").hide(); // [기본게시판]앱 공지사항 - 점검
	else if ('000003' == cdId) $("#updateBtn_settingCodeDetailModiDialog").hide(); // [기본게시판]앱 공지사항 - 업데이트
	else $("#updateBtn_settingCodeDetailModiDialog").show();
	
	$("#settingCodeDetailModiDialog").dialog( "open" );
}

function onfocusCdDtlId(obj) {
	obj.value = '';
}

function onfocusoutCdDtlId(obj) {
	if(obj.value == null || obj.value == '') {
//		obj.value = '${CODE_DETAIL_ID_TEXT}';
		obj.value = "<mink:message code='mink.web.text.under50numchar'/>";
	}
}

<%-- 입력 값 검증 --%>
function validation(frm) {
	if (frm.find("selectbox[name=cdGrpId]").val() == "") {
		alert("<mink:message code='mink.web.text.code.message1'/>");
		frm.find("selectbox[name='cdGrpId']").focus();
		return true;
	}
	var tmpcdDtlId = frm.find("input[name='cdDtlId']").val();
	//if( tmpcdDtlId == "" || tmpcdDtlId == "${CODE_DETAIL_ID_TEXT}") {
	if( tmpcdDtlId == "" || tmpcdDtlId == "<mink:message code='mink.web.text.under50numchar'/>") {
		alert("<mink:message code='mink.web.alert.input.codeid'/>");
		frm.find("input[name='cdDtlId']").focus();
		return true;
	}
	if( frm.find("input[name='cdDtlNm']").val()=="" ) {
		alert("<mink:message code='mink.web.alert.input.codename'/>");
		frm.find("input[name='cdDtlNm']").focus();
		return true;
	}
	var tmpOrderSEQ = frm.find("input[name='orderSeq']").val();
	if( tmpOrderSEQ =="" ) {
		alert("<mink:message code='mink.web.alert.input.order'/>");
		frm.find("input[name='orderSeq']").focus();
		return true;
	}
	if( tmpOrderSEQ !="" && !$.isNumeric(tmpOrderSEQ)) {
		alert("<mink:message code='mink.web.alert.input.number'/>");
		frm.find("input[name='orderSeq']").focus();
		return true;
	}
	
	return false;
}

<%-- 코드상세 등록--%>
function goInsertR() {
	if(validation($("#insertFrmR"))) return; <%-- 입력 값 검증 --%>

	if(!confirm("<mink:message code='mink.web.alert.is.regist'/>")) return;

    ajaxFileComm('settingCodeDetailInsert.miaps?', $("#insertFrmR"), function(data){
    	resultMsg(data.msg);
    	if (data.codeDetail != undefined) {
    		$("#SearchFrmR").find("input[name='cdDtlId']").val(data.codeDetail.cdDtlId);
    		goListRR('1');
			$('#settingCodeDetailRegDialog').dialog('close');
    	}
    });
}

<%-- 코드상세 삭제 --%>
function goDeleteAllR() {
	<%-- 검증 --%>
	if($("#listTbodyR").find(":checkbox:checked").length < 1) {
		alert("<mink:message code='mink.web.alert.select.deleteitem'/>");
		return;
	}
	if( !confirm("<mink:message code='mink.web.alert.is.delete'/>") ) return;
	ajaxComm('settingCodeDetailDelete.miaps?', $('#SearchFrmR'), function(data){
		resultMsg(data.msg);
		$("#SearchFrmR").find("input[name='cdDtlId']").val('');
		goListRR('1'); <%-- 목록/검색 --%>
		$('#settingCodeDetailRegDialog').dialog('close');
	});
}
</script>
</head>
<body>
<!-- 코드관리 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/asvc/setting/settingCodeGroupRegDialog.jsp" %> <!-- 코드그룹 등록 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/asvc/setting/settingCodeGroupModiDialog.jsp" %> <!-- 코드그룹 상세(수정) 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/asvc/setting/settingCodeDetailModiDialog.jsp" %> <!-- 코드상세 등록 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/asvc/setting/settingCodeDetailRegDialog.jsp" %> <!-- 코드상세 상세(수정) 다이얼로그 -->

<div id="miaps-container">
	<%-- 탑 메뉴 --%>
	<div id="miaps-header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
	</div>
	
	<%-- 왼쪽 메뉴 --%>
	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>		
	</div>
	
	<%-- 등록, 삭제 버튼 --%>
	<div id="miaps-top-buttons">
		<span><button class='btn-dash' onclick="javascript:openSettingCodeGroupRegDialog();"><mink:message code="mink.web.text.regist.codegroup"/></button></span>
		<span><button class='btn-dash' onclick="javascript:goDeleteAll();"><mink:message code="mink.web.text.delete.codegroup"/></button></span>
		<span><button class='btn-dash' onclick="javascript:openSettingCodeDetailRegDialog();"><mink:message code="mink.web.text.regist.codedetail"/></button></span>
		<span><button class='btn-dash' onclick="javascript:goDeleteAllR();"><mink:message code="mink.web.text.delete.codedetail"/></button></span>
	</div>

	<%-- 본문 --%>
	<div id="miaps-content">
		<!-- 코드그룹 Start -->
		<div id="miaps-popup-sidebar">
			<form id="SearchFrm" name="SearchFrm" method="post" onSubmit="return false;">
				<%-- 검색 hidden --%>
				<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
				<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
				<input type="hidden" name="cdGrpId" />
				<input type="hidden" name="pageNum" value="${search.currentPage}" /><%-- 현재 페이지 --%>
				
				<%-- 검색 화면Start --%>
				<div>
					<table border="0" cellspacing="0" cellpadding="0" width="100%">
						<tr>
							<td class="search">
								<select name="searchKey">
									<option value="" ${search.searchKey == '' ? '' : ''}><mink:message code="mink.web.text.full.all"/></option>
									<option value="cdGrpId" ${search.searchKey == 'cdGrpId' ? 'selected' : ''}><mink:message code="mink.web.text.codeid"/></option>
									<option value="cdGrpNm" ${search.searchKey == 'cdGrpNm' ? 'selected' : ''}><mink:message code="mink.web.text.codegroupname"/></option>						
								</select>
								<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>"/>
								<button class='btn-dash' onclick="javascript:goList('1');"><mink:message code="mink.web.text.search"/></button>
							</td>
						</tr>
					</table>
				</div>
				<%-- 검색 화면End --%>
				
				<%-- 목록 화면Start --%>
				<div>
					<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="3%" />
							<col width="12%" />
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="20%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="appCheckboxAll" /></td>
								<td><mink:message code="mink.web.text.sequence"/></td>
								<td><mink:message code="mink.web.text.codegroupid"/></td>
								<td><mink:message code="mink.web.text.codegroupname"/></td>
								<td><mink:message code="mink.text.classification"/></td>
								<td><mink:message code="mink.web.text.regdate"/></td>
							</tr>
						</thead>
						<tbody id="listTbody">
							<%-- 목록이 있을 경우 --%>
							<c:forEach var="dto" items="${cdGrpList}" varStatus="i">
							<tr id="listTr${dto.cdGrpId}" onclick="javascript:goListR('1', '${dto.cdGrpId}')">
								<td>
									<c:if test="${'000' != dto.cdGrpId}">
									<input type="checkbox" name="cdGrpIds" value="${dto.cdGrpId}" onclick="checkedCheckboxInTr(event)" />
									</c:if>
								</td>
								<td align="center">${dto.orderSeq}</td>
								<td align="center"><a href="javascript:return;" id="btnGoCodeDetail" onclick="javascript:goDetail('${dto.cdGrpId}');">${dto.cdGrpId}</a></td>
								<td align="left"><c:out value="${dto.cdGrpNm}"/></td>
								<td align="center">								
									<c:choose>
										<c:when test="${dto.systemYn=='Y'}"><mink:message code="mink.web.text.forsystem"/></c:when>
										<c:when test="${dto.systemYn=='N'}"><mink:message code="mink.web.text.public"/></c:when>
										<c:otherwise>${dto.systemYn}</c:otherwise>
									</c:choose>
								</td>
								<td>${dto.regDt}</td>
							</tr>
							</c:forEach>
						</tbody>
						<tfoot id="listTfoot">
							<tr>
								<td colspan="6"><mink:message code="mink.web.text.noexist.result"/></td>
							</tr>
						</tfoot>
					</table>
				</div>
				<%-- 목록 화면End --%>
				<br/>			
				<div id="paginateDiv" class="paginateDiv" >
					<div class="paginateDivSub">
					<%-- start paging --%>
					<%@ include file="/WEB-INF/jsp/include/pagination.jsp" %>
					<%-- end paging --%>
					</div>
				</div>
				
				<div style="padding: 10px;  background-color: white;">
					<!-- <span class='btn-dash'><button class='btn-dash' onclick="javascript:goDeleteAll();">삭제</button></span> -->
				</div>
			</form> <!-- SearchFrm -->
		</div> <!-- miaps-popup-sidebar -->
		<!-- 코드그룹(좌측리스트) End -->
		
		<!-- 코드상세(우측리스트) Start -->
		<div id="miaps-popup-content">	
			<form id="SearchFrmR" name="SearchFrmR" method="post" onSubmit="return false;">
				<%-- 검색 hidden --%>
				<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
				<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
				<input type="hidden" name="cdDtlId" /><%-- 상세 --%>
				<input type="hidden" name="cdGrpId" />
				<input type="hidden" name="pageNum" value="${search.currentPage}" /><%-- 현재 페이지 --%>
				
				<%-- 검색 화면Start --%>
				<div>
					<table border="0" cellspacing="0" cellpadding="0" width="100%">
						<tr>
							<td class="search">
								<select name="searchKey">
									<option value="" ${search.searchKey == '' ? '' : ''}><mink:message code="mink.web.text.full.all"/></option>
									<option value="cdDtlId" ${search.searchKey == 'cdDtlId' ? 'selected' : ''}><mink:message code="mink.web.text.codeid"/></option>
									<option value="cdDtlNm" ${search.searchKey == 'cdDtlNm' ? 'selected' : ''}><mink:message code="mink.web.text.codename"/></option>						
								</select>
								<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>"/>
								<button class='btn-dash' onclick="javascript:goListRR('1');"><mink:message code="mink.web.text.search"/></button>
							</td>
						</tr>
					</table>
				</div>
				<%-- 검색 화면End --%>
				
				<%-- 목록 화면Start --%>
				<div>
					<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="3%" />
							<col width="12%" />
							<col width="15%" />
							<col width="48%" />
							<col width="22%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="appCheckboxAll" /></td>
								<td><mink:message code="mink.web.text.sequence"/></td>
								<td><mink:message code="mink.web.text.codeid"/></td>
								<td><mink:message code="mink.web.text.codename"/></td>
								<td><mink:message code="mink.web.text.regdate"/></td>
							</tr>
						</thead>
						<tbody id="listTbodyR">
							<%-- 목록이 있을 경우 --%>
							<c:forEach var="dto" items="${cdDtlList}" varStatus="i">
							<tr id="listTrr${dto.cdGrpId}${dto.cdDtlId}" onclick="javascript:goDetailR('${dto.cdGrpId}','${dto.cdDtlId}');">
								<td><input type="checkbox" name="cdDtlIds" value="${dto.cdGrpId}${dto.cdDtlId}" onclick="checkedCheckboxInTr(event)" /></td>
								<td align="center">${dto.orderSeq}</td>
								<td align="center">${dto.cdDtlId}</td>
								<td align="left"><c:out value="${dto.cdDtlNm}"/></td>
								<td>${dto.regDt}</td>
							</tr>
							</c:forEach>
						</tbody>
						<tfoot id="listTfootR">
							<tr>
								<td colspan="5"><mink:message code="mink.web.text.noexist.result"/></td>
							</tr>
						</tfoot>
					</table>
				</div> 
				<%-- 목록 화면End --%>
				<br/>			
				<div id="paginateDiv" class="paginateDiv" >
					<div class="paginateDivSub">
					<%-- start paging --%>
					<%@ include file="/WEB-INF/jsp/include/pagination.jsp" %>
					<%-- end paging --%>
					</div>
				</div>
				<div style="padding: 10px;  background-color: white;">
					<!-- <span class='btn-dash'><button class='btn-dash' onclick="javascript:goDeleteAll();">삭제</button></span> -->
				</div>
			</form> <!-- SearchFrmR -->
		</div> <!-- miaps-popup-content -->
		<!-- 코드상세(우측리스트) End -->
	</div> <!-- miaps-content -->
	<%-- footer --%>
	<div id="miaps-footer">
		<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
	</div>
</div>

</body>
</html>
