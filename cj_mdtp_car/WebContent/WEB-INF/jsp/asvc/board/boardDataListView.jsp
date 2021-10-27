<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig"%>
<%
	/*
	 * 게시글 관리 화면 - 목록 및 등록/수정/삭제 (boardDataListView.jsp)
	 * 
	 * @author juni
	 * @since 2014.03.11
	 * @modify chlee, 2015.09.24 
	 * - 네이버 스마트 에디터 추가, 푸시 연동 추가, 패키지 별 게시판, 게시판 구분 추가
	 * @modify chlee, 2019.04.04 
	 * - 네이버 스마트 에디터 버전 업데이트(2.9.1) 다국어 지원 
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp"%>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp"%>
<title><mink:message code="mink.label.page_title" /></title>
<script type="text/javascript" src="${contextPath}/se2/js/service/HuskyEZCreator.js" charset="utf-8"></script>

<% 
	String locale = MinkConfig.getConfig().get("resource.locale");
	if ("en".equals(locale)) {
		locale = "en_US";
	} else if ("jp".equals(locale)) {
		locale = "ja_JP";
	} else if ("zh_CN".equals(locale)) {
		locale = "zh_CN";
	} else if ("zh_TW".equals(locale)) {
		locale = "zh_TW";
	} else if ("ko".equals(locale)) {
		locale = "ko_KR";
	} else {
		locale = "ko_KR";
	}
%>

<script type="text/javascript">
	
<%-- Naver Smart Editor 관련 시작 --%>
	var oEditorsInsert = [];
	var oEditorsDetail = [];
	var sLang = '<%=locale%>';	// 언어 (ko_KR/ en_US/ ja_JP/ zh_CN/ zh_TW), default = ko_KR
	
	var skin = "/se2/SmartEditor2Skin";
	if (sLang == 'en_US') {
		skin += "_en_US.html";
	} else if (sLang == 'ja_JP') {
		skin += "_ja_JP.html";
	} else if (sLang == 'zh_CN') {
		skin += "_zh_CN.html";
	} else if (sLang == 'zh_TW') {
		skin += "_zh_TW.html";
	} else if (sLang == 'ko_KR') {
		skin += ".html";
	} else {
		skin += ".html";
	}

	$(function() {
		nhn.husky.EZCreator.createInIFrame({
			oAppRef : oEditorsInsert,
			elPlaceHolder : "contents_insert",
			sSkinURI : "${contextPath}" + skin,						
			fCreator : "createSEditor2",
			htParams : {
				bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				I18N_LOCALE : sLang
			} 
		});

		nhn.husky.EZCreator.createInIFrame({
			oAppRef : oEditorsDetail,
			elPlaceHolder : "contents_detail",
			sSkinURI : "${contextPath}" + skin,
			fCreator : "createSEditor2",
			htParams : {
				bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				I18N_LOCALE : sLang
			} 
		});		
<%-- Naver Smart Editor 관련 끝 --%>

		//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
		if ("0" == "${search.boardId}") {
			init_accordion('app', '${loginUser.menuListString}');
			$("#topMenuTile").html("<mink:message code='mink.menu.app_management'/>" + " > " + "<c:out value='${board.boardNm}'/>");
		} else {
			init_accordion('board', '${loginUser.menuListString}');
			$("#topMenuTile").html("<mink:message code='mink.menu.board'/>" +  " > " + "<c:out value='${board.boardNm}'/>");
		}
		
		init(); // 이벤트 핸들러 세팅	
		showList(); // 목록 보이기
		showPageHtml(); // 페이징 html 생성

		// 등록 및 수정 시 검색조건 셋팅
		$("select[name='searchApp']").val("<c:out value='${search.searchApp}'/>");
		$("select[name='searchSeparator']").val("<c:out value='${search.searchSeparator}'/>");
		$("input[name='searchKey']").val("<c:out value='${search.searchKey}'/>");
		$("input[name='searchValue']").val("<c:out value='${search.searchValue}'/>");
	});


	// 목록검색
	function goList(pageNum) {
		
		<%-- XSS 방어 --%>
		var _searchVal = defenceXSS(document.SearchFrm.searchValue.value); 
		document.SearchFrm.searchValue.value = _searchVal;
		
		document.SearchFrm.pageNum.value = defenceXSS(pageNum); // 이동할 페이지
		document.SearchFrm.action = 'boardDataListView.miaps?';
		document.SearchFrm.submit();
	}

	//입력 값 검증
	function validation(formName) {
		var frm = $("#" + formName);
		var result = false;

		if (frm.find("input[name='subject']").val() == "") {
			alert("<mink:message code='mink.message.enter_subject'/>");
			frm.find("input[name='subject']").focus();
			return true;
		}

		if (frm.find("#taskIdSetYn").val() == "Y") {
			if (frm.find("input[name='pushMsg']").val() == "") {
				alert("<mink:message code='mink.message.enter_push_message'/>");
				frm.find("input[name='pushMsg']").focus();
				return true;
			}
			if (85 < frm.find("input[name='pushMsg']").val().length) {
				alert("<mink:message code='mink.message.over_length_push_message'/>");
				frm.find("input[name='pushMsg']").focus();
				return true;
			}
		}
		
		if (frm.find("input[name='startDt']").val() != "") {
			if (frm.find("input[name='endDt']").val() == "") {
				alert("<mink:message code='mink.message.enter_closing_date'/>");
				frm.find("input[name='endDt']").focus();
				return true;
			}
		}
		if (frm.find("input[name='endDt']").val() != "") {
			if (frm.find("input[name='startDt']").val() == "") {
				alert("<mink:message code='mink.message.enter_start_date'/>");
				frm.find("input[name='startDt']").focus();
				return true;
			}
		}

		// 에디터의 내용이 textarea에 적용된다.
		if (formName == 'insertFrm') {
			oEditorsInsert.getById["contents_insert"].exec(
					"UPDATE_CONTENTS_FIELD", []);
		} else if (formName == 'detailFrm') {
			oEditorsDetail.getById["contents_detail"].exec(
					"UPDATE_CONTENTS_FIELD", []);
		}

		//alert(frm.find("textarea[name='contents']").val());

		// 에디터의 내용에 대한 값 검증은 이곳에서 document.getElementById("ir1").value를 이용해서 처리한다.
		if (frm.find("textarea[name='contents']").val() == "") {
			alert("<mink:message code='mink.message.enter_contents'/>");
			//nseFocus(formName);
			return true;
		}

		return result;
	}

	//상세조회호출(ajax)
	function goDetail(contentNo) {
		checkedTrCheckbox($("#listTr" + contentNo)); // 선택된 row 색깔변경
		$("#detailFrm").find("input[name='contentNo']").val(contentNo); // (선택한)상세
		
		ajaxComm('boardDataDetail.miaps?', $('#detailFrm'), function(data) {
			fnDetailProcess_Borad(data.boardData);
			var tmpTaskIdSet = $("#detailFrm")
					.find("input[name='taskIdSetYn']").val();
			if (tmpTaskIdSet == 'N') {
				$("#btnReSendPush").css("display", "none");
			} else {
				$("#btnReSendPush").removeAttr("style");
			}
		});

	}

	// 삭제(ajax) 후 목록 호출
	function goDelete() {
		if (!confirm("<mink:message code='mink.message.is_delete'/>"))
			return;

		ajaxComm('boardDataDelete.miaps?', $('#detailFrm'), function(data) {
			resultMsg(data.msg);
			$("#SearchFrm").find("input[name='contentNo']").val(
					data.boardData.contentNo); // (삭제한)상세 비움
			goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
		});
	}

	//여러개 삭제요청(ajax)
	function goDeleteAll() {
		// 검증
		if ($("#listTbody").find(":checkbox:checked").length < 1) {
			alert("<mink:message code='mink.message.select_delete_item'/>");
			return;
		}

		if (!confirm("<mink:message code='mink.message.is_delete'/>"))
			return;
		ajaxComm('boardDataDelete.miaps?', $('#SearchFrm'), function(data) {
			resultMsg(data.msg);
			document.SearchFrm.contentNo.value = ''; // (삭제한)상세 비움
			goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
		});

	}

<%-- 상세 ajax 세부작업 : 게시판용 --%>
	function fnDetailProcess_Borad(dto) {
		showDetail_Borad(); // 상세 보이기
		fnAjaxInfoMapping(dto); // ajax 로 가져온 data 를 알맞은 위치에 삽입
	}

<%-- Naver Smart Editor 관련 시작 
     editor 사이즈 조정: 기본 설정은 초기 숨김형태일 경우 height(contentWindow.document.body.scrollHeight = 0)를 얻지 못하므로 여기서 설정한다. --%>
	function resizeEditor(id) {
		var iframeEditor = document.getElementById(id).nextSibling;
<%-- 1. iframe 사이즈 변경 (id,name없음)--%>
	var ieHeight = iframeEditor.contentWindow.document.body.scrollHeight;
	
	//console.log("ieHeight:" + ieHeight);
	
		iframeEditor.style.width = "100%";
		<%-- ieHeight 취득 값이 너무 작아서 팝업에서 에디터를 표시할 때 작게 표시되어 height 기본값을 지정 함.
		iframeEditor.style.height = ieHeight + "px";
		--%> 
		iframeEditor.style.height = 470 + "px";
		
<%-- 2. iframe내 div 중 에디터 사이즈 변경(id:smart_editor2) --%>
	iframeEditor.contentWindow.document.getElementById("smart_editor2").style.width = "100%";
		//alert(iframeEditor.contentWindow.document.getElementById("smart_editor2"));
<%-- 3. iframe내 div 중 입력창 사이즈 변경 (id,name없음, class로 검색)--%>
	var inputAreaElements = iframeEditor.contentWindow.document
				.getElementsByClassName("se2_input_area husky_seditor_editing_area_container");
		if (inputAreaElements[0]) {
			inputAreaElements[0].style.width = "100%";
			inputAreaElements[0].style.height = 400 + "px";
		}
<%-- 4. iframe내의 또 하나의 iframe(id:se2_iframe, name:se2_iframe)의 height가 IE는 0, chrome은 정상, .. IE일 경우 높이를 지정한다. : height가0이면 NSE에 텍스트를 붙여넣어도 표시되지 않음.--%>
	//iframeEditor.contentWindow.document.getElementById("se2_iframe").style.height = "100%";
	iframeEditor.contentWindow.document.getElementById("se2_iframe").style.height = 400 + "px";

<%-- 5. Jquery UI dailog에 se2를 넣을 경우 '입력창 크기 조절' 부분의 z-index가 낮거나 없어서 마우스로 클릭이 안됨.(JqueryUI dialog의 기본 z-index가 100)
	 WebContents/se2/SmartEditor2Skin.html 의 <div class="se2_conversion_mode">를 <div id="thinkm_add_id_se2cm" class="se2_conversion_mode"> 이렇게 수정
	 id를 추가하고 해당 id를 찾아 z-index 100을 추가
	 
	 2019.04.04 chlee: 2.9.1버전으로 업데이트 후 아래 처리를 하면 오류가 발생하여 삭제함.
--%>
	 //iframeEditor.contentWindow.document.getElementById("thinkm_add_id_se2cm").style.zIndex = "100";
	}

	/*
	function nseFocus(formName) {
		var oSelection;
		if (formName == 'insertFrm') {
			oSelection = oEditorsInsert.getById["contents_insert"]
					.getEmptySelection();
			oSelection
					.selectNodeContents(oEditorsInsert.getById["contents_insert"]
							.getWYSIWYGDocument().body);
			oSelection.collapseToEnd();
			oSelection.select();
			oEditorsInsert.getById["contents_insert"].exec("FOCUS");
		} else if (formName == 'detailFrm') {
			oSelection = oEditorsDetail.getById["contents_detail"]
					.getEmptySelection();
			oSelection
					.selectNodeContents(oEditorsDetail.getById["contents_detail"]
							.getWYSIWYGDocument().body);
			oSelection.collapseToEnd();
			oSelection.select();
			oEditorsDetail.getById["contents_detail"].exec("FOCUS");
		}
	}*/
<%-- Naver Smart Editor 관련 끝 --%>
	
</script>
</head>
<body>

<%-- 등록 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/board/boardDataRegDialog.jsp"%>
<%-- 상세 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/board/boardDataDetailDialog.jsp"%>
<input type="hidden" id="tempContents">
	
<div id="miaps-container">
	<div id="miaps-header">
    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
  	</div>
	<!-- 좌측 메뉴 -->
	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp"%>
	</div>
	<div id="miaps-top-buttons">
		<button class='btn-dash' onclick="javascript:showInsert_Borad()"><mink:message code="mink.web.text.regist"/></button>
		<button class='btn-dash' onclick="javascript:goDeleteAll();"><mink:message code="mink.web.text.delete"/></button>
	</div>
	<div id="miaps-content">
		<!-- 	<div class="searchDivFrm"> -->
		<form id="SearchFrm" name="SearchFrm" method="post"
			onSubmit="return false;">
			<!-- 검색 hidden -->
			<input type="hidden" name="regNo" value="<c:out value='${loginUser.userNo}'/>" />
			<input type="hidden" name="updNo" value="<c:out value='${loginUser.userNo}'/>" />
			<input type="hidden" name="contentNo" />
			<!-- 상세 -->
			<input type="hidden" name="pageNum" value="<c:out value='${search.currentPage}'/>" />
			<input type="hidden" name="boardId" value="<c:out value='${board.boardId}'/>" />
			<input type="hidden" name="cdGrpId" value="<c:out value='${board.cdGrpId}'/>" />
	
			<!-- 검색 화면 -->
			<div>
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<td class="search" style="text-align: left; padding-left: 5px;">
					
						</td>
						<td class="search">
						<select name="searchApp">
								<option value=""><mink:message code="mink.label.all_app_nm_pkgnm"/></option>
								<c:forEach var="searchApp" items="${search.packageNmList}">
									<option value="<c:out value="${searchApp.packageNm}"/>"><c:out value="${searchApp.appNm}" /></option>
								</c:forEach>
						</select> &nbsp;
						<select name="searchSeparator">
								<option value=""><mink:message code="mink.label.devision_all"/></option>
								<c:forEach var="spDto" items="${search.boardSeparateList}"
									varStatus="i">
									<option value="${spDto.cdGrpId}${spDto.cdDtlId}">${spDto.cdDtlNm}</option>
								</c:forEach>
						</select> &nbsp;
						<select name="searchKey">
								<option value="subject"
									${search.searchKey == 'subject' ? 'selected' : ''}><mink:message code="mink.label.subject"/></option>
								<option value="contents"
									${search.searchKey == 'contents' ? 'selected' : ''}><mink:message code="mink.label.content"/></option>
								<option value="regNm"
									${search.searchKey == 'regNm' ? 'selected' : ''}><mink:message code="mink.web.text.register"/></option>
						</select>
						<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>" />
						<select name="searchPageSize">
							<option value="10" ${search.searchPageSize == '10' ? 'selected' : ''}><mink:message code='mink.web.text.rows10'/></option>
							<option value="20" ${(search.searchPageSize == null || search.searchPageSize == '20') ? 'selected' : ''}><mink:message code="mink.web.text.rows20"/></option>
							<option value="50" ${search.searchPageSize == '50' ? 'selected' : ''}><mink:message code="mink.web.text.rows50"/></option>
							<option value="100" ${search.searchPageSize == '100' ? 'selected' : ''}><mink:message code="mink.web.text.rows100"/></option>
						</select>
						<button class='btn-dash' onclick="javascript:goList('1')"><mink:message code="mink.web.text.search"/></button>
						</td>
					</tr>
				</table>
			</div>
	
			<!-- 목록 화면 -->
			<div>
				<table class="listTb" border="0" cellspacing="0" cellpadding="0"
					width="100%">
					<colgroup>
						<col width="3%" />
						<col width="8%" />
						<col width="8%" />
						<col width="35%" />
						<col width="23%" />
						<col width="10%" />
						<col width="14%" />
					</colgroup>
					<thead>
						<tr>
							<td><input type="checkbox" name="boardDataCheckboxAll" /></td>
							<td><mink:message code="mink.label.reg_date"/></td>
							<td><mink:message code="mink.label.devision"/></td>
							<td><mink:message code="mink.label.subject"/></td>
							<td><mink:message code="mink.label.app_nm_pkgnm"/></td>
							<td><mink:message code="mink.label.check_push_yn"/></td>
							<td><mink:message code="mink.label.post_period"/></td>
						</tr>
					</thead>
					<tbody id="listTbody">
						<!-- 목록이 있을 경우 -->
						<c:forEach var="dto" items="${boardDataList}" varStatus="i">
							<tr id="listTr<c:out value='${dto.contentNo}'/>"
								onclick="javascript:goDetail(<c:out value='${dto.contentNo}'/>);">
								<td><input type="checkbox" id="" name="contentNos"
									value="<c:out value='${dto.contentNo}'/>" onclick="checkedCheckboxInTr(event)" /></td>
								<td>${dto.regDt}</td>
								<td>${dto.separationNm}</td>
								<td align="left"><c:out value='${dto.subject}'/></td>
								<td align="left"><c:set var="dtoAppNm" value="${dto.packageNm}" /> 
									<c:forEach var="searchApp2" items="${search.packageNmList}">
										<c:if test="${searchApp2.packageNm == dto.packageNm}">
											<c:set var="dtoAppNm" value="${searchApp2.appNm}" />
										</c:if>
									</c:forEach><c:out value='${dtoAppNm}'/></td>
								<td>
									<c:if test="${!empty dto.pushId}"><mink:message code="mink.label.send_push"/></c:if>
									<c:if test="${empty dto.pushId}"><mink:message code="mink.label.no_entry_push"/></c:if>
								</td>
								<td align="left">
									<c:if test="${!empty dto.startDt}">
									${dto.startDt} ~ ${dto.endDt}
									</c:if>
								</td>
							</tr>
						</c:forEach>
					</tbody>
					<tfoot id="listTfoot">
						<!-- 목록이 없을 경우 -->
						<tr>
							<td colspan="7"><mink:message code="mink.web.text.noexist.result"/></td>
						</tr>
					</tfoot>
				</table>
			</div>
	
			<div id="paginateDiv" class="paginateDiv">
				<div class="paginateDivSub">
					<!-- start paging -->
					<%@ include file="/WEB-INF/jsp/include/pagination.jsp"%>
					<!-- end paging -->
				</div>
			</div>
			<div style="padding: 10px; background-color: white;">
				<!-- <span class='btn-dash'><button class='btn-dash' onclick="javascript:goDeleteAll();">삭제</button></span> -->
			</div>
		</form>
	</div>
	<div id="miaps-footer">
		<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
	</div>
</div>
</body>
</html>
