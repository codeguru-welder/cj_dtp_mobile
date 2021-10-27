<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig"%>
<%
	/*
	 * 메일서버 정보관리 화면 - 목록 및 등록/수정/삭제 (mailserverListView.jsp)
	 * 
	 * @author ek
	 * @since 2014.12.15
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp"%>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp"%>
<title><mink:message code="mink.label.page_title" /></title>

<script type="text/javascript">
	$(function() {
		//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
		init_accordion('setting', '${loginUser.menuListString}');
		$("#topMenuTile").html("<mink:message code='mink.web.text.setting_mailserver'/>");
		
		init(); // 이벤트 핸들러 세팅

		showList(); // 목록 보이기
		showPageHtml(); // 페이징 html 생성

		if (eval('${!empty mailserver}')) {
			<%-- var dto = eval("(" + '${mailserver}' + ")"); --%>
			<%
			String _strJson = "";
			if (request.getAttribute("mailserver") instanceof Mailserver) {
			%>
				var dto = eval("(" + '${mailserver}' + ")");
			<%
			} else if (request.getAttribute("mailserver") instanceof String) {
				_strJson = (String) request.getAttribute("mailserver");
				if (_strJson != null && _strJson.length() > 0) {
					_strJson = _strJson.replace("/", "\\/");
				}%>
				var dto = <%=_strJson%>;
			<%}%>
			
			fnDetailProcess(dto); // 상세정보 매핑
			checkedTrCheckbox($("#listTr" + dto.mailserverId)); // 선택한 tr 의 checkbox 에 체크선택/css 변경
		}
		
	});

	//ajax 로 가져온 data 를 알맞은 위치에 삽입
	function fnAjaxInfoMapping(result) {
		// 상세화면 정보 출력
		var frm = $("#detailFrm");
		frm.find("input[name='mailserverId']").val(result.mailserverId);
		frm.find("input[name='preMailserverId']").val(result.mailserverId);
		frm.find("input[name='defaultMail'][value=" + result.defaultMail + "]")
				.get(0).checked = true;
		frm.find("input[name='serverType']").val(result.serverType);
		frm.find("input[name='description']").val(result.description);
		frm.find("input[name='protocol']").val(result.protocol);
		frm.find("input[name='outServer']").val(result.outServer);
		frm.find("input[name='outPort']").val(result.outPort);
		frm.find("input[name='outAuth'][value=" + result.outAuth + "]").get(0).checked = true;
		frm.find("input[name='sslout'][value=" + result.sslout + "]").get(0).checked = true;
		frm.find("input[name='inServer']").val(result.inServer);
		frm.find("input[name='inPort']").val(result.inPort);
		frm.find("input[name='sslin'][value=" + result.sslin + "]").get(0).checked = true;
		frm.find("input[name='inboxName']").val(result.inboxName);
		frm.find("input[name='inboxActive'][value=" + result.inboxActive + "]")
				.get(0).checked = true;
		frm.find("input[name='outboxName']").val(result.outboxName);
		frm
				.find(
						"input[name='outboxActive'][value="
								+ result.outboxActive + "]").get(0).checked = true;
		frm.find("input[name='sentName']").val(result.sentName);
		frm.find("input[name='sentActive'][value=" + result.sentActive + "]")
				.get(0).checked = true;
		frm.find("input[name='draftsName']").val(result.draftsName);
		frm
				.find(
						"input[name='draftsActive'][value="
								+ result.draftsActive + "]").get(0).checked = true;
		frm.find("input[name='trashName']").val(result.trashName);
		frm.find("input[name='trashActive'][value=" + result.trashActive + "]")
				.get(0).checked = true;
	}

	// 목록검색
	function goList(pageNum) {
		<%-- XSS 방어 --%>
		var _searchVal = defenceXSS(document.SearchFrm.searchValue.value); 
		document.SearchFrm.searchValue.value = _searchVal;
		
		document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
		document.SearchFrm.action = 'mailserverListView.miaps?';
		document.SearchFrm.submit();
	}

	//입력 값 검증
	function validation(frm) {
		var result = false;

		if (frm.find("input[name='mailserverId']").val() == "") {
			alert("<mink:message code='mink.web.text.mail.input.servername'/>");
			frm.find("input[name='mailserverId']").focus();
			return true;
		}
		if (frm.find("input[name='serverType']").val() == "") {
			alert("<mink:message code='mink.web.text.mail.input.servertype'/>");
			frm.find("input[name='serverType']").focus();
			return true;
		}
		if (frm.find("input[name='protocol']").val() == "") {
			alert("<mink:message code='mink.web.text.mail.input.serverprotocol'/>");
			frm.find("input[name='protocol']").focus();
			return true;
		}
		if (frm.find("input[name='outServer']").val() == "") {
			alert("<mink:message code='mink.web.text.mail.input.sendserver.address'/>");
			frm.find("input[name='outServer']").focus();
			return true;
		}
		if (frm.find("input[name='outPort']").val() == "") {
			alert("<mink:message code='mink.web.text.mail.input.sendserver.port'/>");
			frm.find("input[name='outPort']").focus();
			return true;
		}
		if (isNaN(frm.find("input[name='outPort']").val())) {
			alert("<mink:message code='mink.web.text.mail.input.number.sendserver.port'/>");
			frm.find("input[name='outPort']").focus();
			return true;
		}
		if (frm.find("input[name='inServer']").val() == "") {
			alert("<mink:message code='mink.web.text.mail.input.receiveserver.adress'/>");
			frm.find("input[name='inServer']").focus();
			return true;
		}
		if (frm.find("input[name='inPort']").val() == "") {
			alert("<mink:message code='mink.web.text.mail.input.receiveserver.port'/>");
			frm.find("input[name='inPort']").focus();
			return true;
		}
		if (isNaN(frm.find("input[name='inPort']").val())) {
			alert("<mink:message code='mink.web.text.mail.input.number.receiveserver.port'/>");
			frm.find("input[name='inPort']").focus();
			return true;
		}

		return result;
	}

	// 상세조회호출(ajax)
	function goDetail(mailserverId) {
		checkedTrCheckbox($("#listTr" + mailserverId)); // 선택된 row 색깔변경
		$("#detailFrm").find("input[name='mailserverId']").val(mailserverId); // (선택한)상세
		ajaxComm('mailserverDetail.miaps?', $('#detailFrm'), function(data) {
			fnDetailProcess_mail(data.mailserver); // 상세 ajax 세부작업
		});
		/* $("#mailDeailDialog").dialog("open"); */
	}
<%-- 상세 ajax 세부작업 : 메일용 --%>
	function fnDetailProcess_mail(dto) {
		showDetail_mail(); // 상세 보이기
		fnAjaxInfoMapping(dto); // ajax 로 가져온 data 를 알맞은 위치에 삽입
	}

	function showDetail_mail() {
		$("#insertDiv").hide();
		$("#detailDiv").show();
		/* 	resizeEditor('contents_detail'); */
		$("#mailDeatilDialog").dialog("open");
	}

	// ID중복 검증
	function isDuplicatedMailserverId(frm) {
		var isDuplicated = false;

		$.ajaxSetup({
			async : false
		}); // 비동기 옵션 끄기(ajax 동기화)
		ajaxComm('mailserverIdValidate.miaps?', frm, function(data) {
			if (0 < data.cnt) {
				isDuplicated = true;
			}
		});
		$.ajaxSetup({
			async : true
		}); // 비동기 옵션 켜기

		return isDuplicated;
	}

	/* // 등록(ajax) 후 목록 호출
	function goInsert() {
		if (validation($("#insertFrm")))
			return; // 입력 값 검증

		// ID중복 검증
		if (isDuplicatedMailserverId($("#insertFrm"))) {
			alert("메일서버 이름이 중복되었습니다.");
			$("#insertFrm").find("input[name='mailserverId']").focus();
			return true;
		}

		if (!confirm("등록하시겠습니까?"))
			return;
		ajaxComm('mailserverInsert.miaps?', $('#insertFrm'), function(data) {
			resultMsg(data.msg);
			$("#SearchFrm").find("input[name='mailserverId']").val(
					data.mailserver.mailserverId); // (등록한)상세
			goList('1'); // 목록/검색(1 페이지로 초기화)
		});
	}
	 */
	// 수정(ajax) 후 목록 호출
	function goUpdate() {
		if (validation($("#detailFrm")))
			return; // 입력 값 검증

		if ($("#detailFrm").find("input[name='preMailserverId']").val() != $(
				"#detailFrm").find("input[name='mailserverId']").val()) {
			// ID중복 검증
			if (isDuplicatedMailserverId($("#detailFrm"))) {
				alert("<mink:message code='mink.web.text.mail.duplicate.servername'/>");
				$("#detailFrm").find("input[name='mailserverId']").focus();
				return true;
			}
		}

		if (!confirm("<mink:message code='mink.web.alert.is.save'/>"))
			return;
		ajaxComm('mailserverUpdate.miaps?', $('#detailFrm'), function(data) {
			resultMsg(data.msg);
			$("#SearchFrm").find("input[name='mailserverId']").val(
					data.mailserver.mailserverId); // 상세조회 key
			goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
		});
	}

	// 삭제(ajax) 후 목록 호출
	function goDelete() {
		if (!confirm("<mink:message code='mink.web.alert.is.delete'/>"))
			return;

		ajaxComm('mailserverDelete.miaps?', $('#detailFrm'), function(data) {
			resultMsg(data.msg);
			$("#SearchFrm").find("input[name='mailserverId']").val(
					data.mailserver.mailserverId); // (삭제한)상세 비움
			goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
		});
	}

	//여러개 삭제요청(ajax)
	function goDeleteAll() {
		// 검증
		if ($("#listTbody").find(":checkbox:checked").length < 1) {
			alert("<mink:message code='mink.web.alert.select.deleteitem'/>");
			return;
		}
		if (!confirm("<mink:message code='mink.web.alert.is.delete'/>"))
			return;
		ajaxComm('mailserverDelete.miaps?', $('#SearchFrm'), function(data) {
			resultMsg(data.msg);
			document.SearchFrm.mailserverId.value = ''; // (삭제한)상세 비움
			goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
		});
	}
</script>

</head>
<body>
	<%-- 등록하기 다이얼로그 --%>
	<%@ include file="/WEB-INF/jsp/asvc/mail/mailInsertDialog.jsp"%>
	<%-- 상세 다이얼로그 --%>
	<%@ include file="/WEB-INF/jsp/asvc/mail/mailDeatilDialog.jsp"%>
	<!-- 탑메뉴 -->
	<div id="miaps-header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
	</div>
	<!-- 왼쪽 메뉴 -->
	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp"%>
	</div>
	<div id="miaps-top-buttons">
		<span><button class='btn-dash' onclick="javascript:openInsertDialog();"><mink:message code="mink.web.text.regist2"/></button></span>
		<span><button class='btn-dash' onclick="javascript:goDeleteAll();"><mink:message code="mink.web.text.delete2"/></button></span>
	</div>
	<!-- 본문 -->
	<div id="miaps-content">
		<form id="SearchFrm" name="SearchFrm" method="post"
			onSubmit="return false;">
			<!-- 검색 hidden -->
			<input type="hidden" name="regNo" value="${loginUser.userNo}" />
			<!-- 로그인한 사용자 -->
			<input type="hidden" name="updNo" value="${loginUser.userNo}" />
			<!-- 로그인한 사용자 -->
			<input type="hidden" name="mailserverId" />
			<!-- 상세 -->
			<input type="hidden" name="pageNum" value="${search.currentPage}" />
			<!-- 현재 페이지 -->

			<!-- 검색 화면 -->
			<div>
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<td class="search"><select name="searchKey">
								<option value="" ${search.searchKey == '' ? 'selected' : ''}><mink:message code="mink.web.text.full.all"/></option>
								<option value="mailserverId"
									${search.searchKey == 'mailserverId' ? 'selected' : ''}><mink:message code="mink.web.text.mail.servername"/></option>
								<option value="defaultMail"
									${search.searchKey == 'defaultMail' ? 'selected' : ''}><mink:message code="mink.web.text.mail.defaultstatus"/></option>
								<option value="serverType"
									${search.searchKey == 'serverType' ? 'selected' : ''}><mink:message code="mink.web.text.mail.type"/></option>
								<option value="protocol"
									${search.searchKey == 'protocol' ? 'selected' : ''}><mink:message code="mink.web.text.mail.protocol"/></option>
						</select> <input type="text" name="searchValue"
							value="<c:out value='${search.searchValue}'/>" />
							<button class='btn-dash' onclick="javascript:goList('1');"><mink:message code="mink.web.text.search"/></button>
						</td>
					</tr>
				</table>
			</div>

			<!-- 목록 화면 -->
			<div>
				<table class="listTb" border="0" cellspacing="0" cellpadding="0"
					width="100%">
					<colgroup>
						<col width="4%" />
						<col width="10%" />
						<col width="6%" />
						<col width="10%" />
						<col width="10%" />
						<col width="16%" />
						<col width="6%" />
						<col width="16%" />
						<col width="6%" />
						<col width="16%" />
					</colgroup>
					<thead>
						<tr>
							<td><input type="checkbox" name="mailserverCheckboxAll" /></td>
							<td><mink:message code="mink.web.text.mail.servername"/></td>
							<td><mink:message code="mink.web.text.mail.defaultstatus"/></td>
							<td><mink:message code="mink.web.text.mail.type"/></td>
							<td><mink:message code="mink.web.text.mail.protocol"/></td>
							<td><mink:message code="mink.web.text.mail.sendmail.address"/></td>
							<td><mink:message code="mink.web.text.mail.port"/></td>
							<td><mink:message code="mink.web.text.mail.receivemail.adress"/></td>
							<td><mink:message code="mink.web.text.mail.port"/></td>
							<td><mink:message code="mink.web.text.mail.description"/></td>
						</tr>
					</thead>
					<tbody id="listTbody">
						<!-- 목록이 있을 경우 -->
						<c:forEach var="dto" items="${mailserverList}" varStatus="i">
							<tr id="listTr${dto.mailserverId}"
								onclick="javascript:goDetail('${dto.mailserverId}');">
								<td><input type="checkbox" name="mailserverIds"
									value="${dto.mailserverId}"
									onclick="checkedCheckboxInTr(event)" /></td>
								<td><c:out value='${dto.mailserverId}'/></td>
								<td><c:out value='${dto.defaultMail}'/></td>
								<td><c:out value='${dto.serverType}'/></td>
								<td><c:out value='${dto.protocol}'/></td>
								<td><c:out value='${dto.outServer}'/></td>
								<td><c:out value='${dto.outPort}'/></td>
								<td><c:out value='${dto.inServer}'/></td>
								<td><c:out value='${dto.inPort}'/></td>
								<td><c:out value='${dto.description}'/></td>
							</tr>
						</c:forEach>
					</tbody>
					<tfoot id="listTfoot">
						<!-- 목록이 없을 경우 -->
						<tr>
							<td colspan="10"><mink:message code="mink.web.text.noexist.result"/></td>
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
	<!-- footer -->
	<div id="miaps-footer">
		<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
	</div>
</body>
</html>
