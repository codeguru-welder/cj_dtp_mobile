<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig"%>
<%
	/*
	 * 게시판 관리 화면 - 목록 및 등록/수정/삭제 (boardListView.jsp)
	 * 
	 * @author juni
	 * @since 2014.03.10
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
		$("#topMenuTile").html("<mink:message code='mink.menu.setting'/>" + " > " + "<mink:message code='mink.menu.setting_board'/>");
		
		init(); // 이벤트 핸들러 세팅

		showList(); // 목록 보이기
		showPageHtml(); // 페이징 html 생성

		// 등록 및 수정 시 검색조건 셋팅
		$("input[name='searchKey']").val("<c:out value='${search.searchKey}'/>");
		$("input[name='searchValue']").val("<c:out value='${search.searchValue}'/>");

		if (eval('${!empty board}')) {
			<%-- var dto = eval("(" + '${board}' + ")"); --%>
			<%
				String _strJson = (String) request.getAttribute("board");
				if (_strJson != null && _strJson.length() > 0) {
					_strJson = _strJson.replace("/", "\\/");
				}
			%>
			var dto = <%=_strJson%>;
			fnDetailProcess(dto); // 상세정보 매핑
			checkedTrCheckbox($("#listTr" + dto.boardId)); // 선택한 tr 의 checkbox 에 체크선택/css 변경
		}
		
	});

	//ajax 로 가져온 data 를 알맞은 위치에 삽입
	function fnAjaxInfoMapping(result) {
		// 상세화면 정보 출력
		var frm = $("#detailFrm");
		frm.find("input[name='boardId']").val(result.boardId);
		frm.find("input[name='boardNm']").val(result.boardNm);
		frm.find("input[name='boardDesc']").val(result.boardDesc);
		frm.find("input[name='orderSeq']").val(result.orderSeq);
		frm.find("input[name='publicYn'][value=" + result.publicYn + "]").attr(
				"checked", "checked");
		//frm.find("input[name='deleteYn'][value=" + result.deleteYn + "]").attr("checked", "checked");
		frm.find("select[name=cdGrpId]").val(result.cdGrpId);
		frm.find("input[name='regNm']").val(result.regNm);
		frm.find("input[name='regDt']").val(result.regDt);
		if (result.defaultBoard == 'Y') { // id가 특정번호(0)일 경우 한줄공지 게시판으로 구분되어 수정버튼 숨김
			$('#updateBtnDiv').hide();
		} else {
			$('#updateBtnDiv').show();
		}

		htmlEscapeAll(document); // 특수문자 전체 변환
	}

	// 목록검색
	function goList(pageNum) {
		document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
		document.SearchFrm.action = 'boardListView.miaps?';
		document.SearchFrm.submit();
	}

	// 상세 조회
	function boardDetail(boardId) {
		checkedTrCheckbox($("#listTr" + boardId)); // 선택된 row 색깔변경
		$("#detailFrm").find("input[name='boardId']").val(boardId); // (선택한)상세
		ajaxComm('boardDetail.miaps?', $('#detailFrm'), function(data) {
			fnDetailProcess(data.board); // 상세 ajax 세부작업
		});
		$("#boardDetail").dialog("open");
	}

	// 수정(ajax) 후 목록 호출
	/* function goUpdate() {
	 if(validation($("#detailFrm"))) return; // 입력 값 검증
	 if(!confirm("저장하시겠습니까?")) return;
	
	 ajaxComm('boardUpdate.miaps?', $('#detailFrm'), function(data){
	 resultMsg(data.msg);
	 $("#SearchFrm").find("input[name='boardId']").val(data.board.boardId);	// 상세조회 key
	 goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
	 });
	 } */

	// 삭제(ajax) 후 목록 호출
	function goDelete() {
		if (!confirm("<mink:message code='mink.message.is_delete'/>"))
			return;

		ajaxComm('boardDelete.miaps?', $('#detailFrm'), function(data) {
			resultMsg(data.msg);
			$("#SearchFrm").find("input[name='boardId']").val(
					data.board.boardId); // (삭제한)상세 비움
			goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
		});
	}

	//여러개 삭제요청(ajax)
	function goDeleteAll() {
		// 특정게시판 삭제 불가능
		/* $("#listTbody input:checked").each(function(idx, row){
			if( $(row).val() == '0' ) {
				alert("한줄공지 게시판은 삭제하실 수 없습니다.");
				$(row).attr("checked", false);
			} 
			
		}); */
		// 검증
		if ($("#listTbody").find(":checkbox:checked").length < 1) {
			alert("<mink:message code='mink.message.select_delete_item'/>");
			return;
		}
		if (!confirm("<mink:message code='mink.message.is_delete'/>"))
			return;
		ajaxComm('boardDelete.miaps?', $('#SearchFrm'), function(data) {
			resultMsg(data.msg);
			document.SearchFrm.boardId.value = ''; // (삭제한)상세 비움
			goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
		});

	}
</script>
<!-- 탑 메뉴 -->
<%-- <%@ include file="/WEB-INF/jsp/include/header.jsp" %> --%>
</head>
<body>
	<%-- 등록하기 다이얼로그 --%>
	<%@ include file="/WEB-INF/jsp/asvc/board/boardInsertDialog.jsp"%>
	<%-- 상세보기 다이얼로그 --%>
	<%@ include file="/WEB-INF/jsp/asvc/board/boardDetailDialog.jsp"%>
	<div id="miaps-header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
	</div>
	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp"%>
	</div>
	<div id="miaps-top-buttons">
		<span><button class='btn-dash'onclick="javascript:openBoardRegDialog();"><mink:message code="mink.web.text.regist"/></button></span>
		<span><button class='btn-dash' onclick="javascript:goDeleteAll();"><mink:message code="mink.web.text.delete"/></button></span>
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
			<input type="hidden" name="boardId" />
			<!-- 상세 -->
			<input type="hidden" name="pageNum" value="${search.currentPage}" />
			
			<!-- 현재 페이지 -->
			<!-- 검색 화면 -->
			<div>
				<table class="search" border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<td class="search"><select name="searchKey">
								<option value="" ${search.searchKey == '' ? 'selected' : ''}><mink:message code='mink.label.all'/></option>
								<option value="boardNm"
									${search.searchKey == 'boardNm' ? 'selected' : ''}><mink:message code='mink.label.board_name'/></option>
								<option value="boardDesc"
									${search.searchKey == 'boardDesc' ? 'selected' : ''}><mink:message code='mink.label.board_explain'/></option>
						</select> <input type="text" name="searchValue"
							value="<c:out value='${search.searchValue}'/>" />
							<!--
							<select name="searchPageSize">
								<option value="10" ${search.searchPageSize == '10' ? 'selected' : ''}>10줄</option>
								<option value="20" ${(search.searchPageSize == null || search.searchPageSize == '20') ? 'selected' : ''}>20줄</option>
								<option value="50" ${search.searchPageSize == '50' ? 'selected' : ''}>50줄</option>
								<option value="100" ${search.searchPageSize == '100' ? 'selected' : ''}>100줄</option>
							</select>
							-->
							<button class='btn-dash' onclick="javascript:goList('1');"><mink:message code='mink.web.text.search'/></button>
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
						<col width="10%" />
						<col width="42%" />
						<col width="14%" />
						<col width="16%" />
						<col width="15%" />
					</colgroup>
					<thead>
						<tr>
							<td><input type="checkbox" name="boardCheckboxAll" /></td>
							<td><mink:message code='mink.label.order'/></td>
							<td><mink:message code='mink.label.board_name'/></td>
							<td><mink:message code='mink.label.common_use'/></td>
							<td><mink:message code='mink.label.board_devision_code_group'/></td>
							<td><mink:message code='mink.label.reg_date'/></td>
						</tr>
					</thead>
					<tbody id="listTbody">
						<!-- 목록이 있을 경우 -->
						<c:forEach var="dto" items="${boardList}" varStatus="i">
							<tr id="listTr${dto.boardId}"
								onclick="javascript:boardDetail('${dto.boardId}');">
								<td><c:if test="${dto.defaultBoard != 'Y'}">
										<input type="checkbox" name="boardIds"
											value="${dto.boardId}" onclick="checkedCheckboxInTr(event)" />
									</c:if></td>
								<td>${dto.orderSeq}</td>
								<td align="left"><c:out value='${dto.boardNm}'/></td>
								<td><c:choose>
										<c:when test="${dto.publicYn=='Y'}"><mink:message code='mink.label.all'/></c:when>
										<c:when test="${dto.publicYn=='N'}"><mink:message code='mink.label.relevant_group'/></c:when>
										<c:otherwise>${dto.publicYn}</c:otherwise>
									</c:choose></td>
								<td><c:out value='${dto.cdGrpNm}'/></td>
								<td>${dto.regDt}</td>
							</tr>
						</c:forEach>
					</tbody>
					<tfoot id="listTfoot">
						<!-- 목록이 없을 경우 -->
						<tr>
							<td colspan="6"><mink:message code='mink.web.text.noexist.result'/></td>
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

	<%--  	<!-- 등록화면 -->
	<div id="insertDiv" style="display: none">
	
		<form id="insertFrm" name="insertFrm" method="post" class="detailFrm" onSubmit="return false;">
			<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
			<input type="hidden" name="searchKey" value=""/>	<!-- 검색조건 -->
			<input type="hidden" name="searchValue" value=""/>	<!-- 검색조건 -->
			<input type="hidden" name="regGrpId" value="${loginUser.userGroup.grpId}"/>	<!-- 게시판 등록자의 그룹 ID로 게시판 메뉴 권한 생성 -->
			<input type="hidden" name="regAdminYn" value="${loginUser.adminYn}"/>	<!-- 게시판 등록자가 슈퍼관리자일 경우 전체가 볼수 있는 권한 생성 -->
			
			<div>
				<h3><span>* 게시판 등록</span></h3>
			</div>
	
			<table class="insertTb" border="1" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tbody>
					<tr>
						<th><span class="criticalItems">게시판명</span></th>
						<td><input type="text" name="boardNm" /></td>
						<th><span class="criticalItems">게시판 구분 코드그룹</span></th>
						<td>
							<select class="selectSpace" name="cdGrpId">
								<option value="">사용안함</option>
								<c:forEach var="cgDto" items="${codeGroupList}" varStatus="i">
									<option value="${cgDto.cdGrpId}" >${cgDto.cdGrpNm}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th><span class="criticalItems">우선 순위</span></th>
						<td><input type="text" name="orderSeq" size="5" onKeyPress="return keyPressNum(event)"/></td>
						<th><span class="criticalItems">공통사용여부</span></th>
						<td>
							<input type="radio" name="publicYn" value="Y" id="publicYn_i_y" /><label for="publicYn_i_y" >전체&nbsp;&nbsp;</label>
							<input type="radio" name="publicYn" value="N" id="publicYn_i_n" /><label for="publicYn_i_n" >해당그룹&nbsp;&nbsp;</label>
						</td>
					</tr>
					<tr>
						<th>게시판 설명</th>
						<td colspan="3"><input type="text" name="boardDesc" size="70"/></td>
					</tr>
				</tbody>
				<tfoot></tfoot>
			</table>
		
			<div class="insertBtnArea">
				<span><button class='btn-dash' onclick="javascript:goInsert();">저장하기</button> <button class='btn-dash' onclick="javascript:hiddenInsertDetail();">취소</button></span>
			</div>
		</form>
	</div>
 --%>

	<!-- 상세화면 -->
	<%-- <div id="detailDiv" style="display: none">
		<form id="detailFrm" name="detailFrm" method="post" class="detailFrm" onSubmit="return false;">
			<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
			<input type="hidden" name="boardId" value=""/>	<!-- key -->
			<input type="hidden" name="searchKey" value=""/>	<!-- 검색조건 -->
			<input type="hidden" name="searchValue" value=""/>	<!-- 검색조건 -->
				
			<div>
				<h3><span>* 게시판 상세정보</span></h3>
			</div>
			<table class="detailTb" border="1" cellspacing="0" cellpadding="0" width="100%">
				<tbody>
					<tr>
						<th><span class="criticalItems">게시판명</span></th>
						<td><input type="text" name="boardNm" /></td>
						<th><span class="criticalItems">게시판 구분 코드그룹</span></th>
						<td>
							<select class="selectSpace" name="cdGrpId">
								<option value="">사용안함</option>
								<c:forEach var="cgDto" items="${codeGroupList}" varStatus="i">
									<option value="${cgDto.cdGrpId}" >${cgDto.cdGrpNm}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th><span class="criticalItems">우선순위</span></th>
						<td><input type="text" name="orderSeq" size="5" onKeyPress="return keyPressNum(event)"/></td>
						<th><span class="criticalItems">공통사용여부</span></th>
						<td>
							<input type="radio" name="publicYn" value="Y" id="publicYn_y" /><label for="publicYn_y" >전체&nbsp;&nbsp;</label>
							<input type="radio" name="publicYn" value="N" id="publicYn_n" /><label for="publicYn_n" >해당그룹&nbsp;&nbsp;</label>
						</td>
					</tr>
					<tr>
						<th>게시판 설명</th>
						<td colspan="3"><input type="text" name="boardDesc" size="70"/></td>
					</tr>
					<tr>
						<th>등록자</th>
						<td><input type="text" name="regNm" readonly="readonly"/></td>
						<th>등록일</th>
						<td><input type="text" name="regDt" readonly="readonly"/></td>
					</tr>
				</tbody>
				<tfoot></tfoot>
			</table>
			
			<div class="detailBtnArea">
					<span id="updateBtnDiv"><button class='btn-dash' onclick="javascript:goUpdate()">저장하기</button></span>
					<span><button class='btn-dash' onclick="javascript:hiddenInsertDetail();">닫기</button></span>
			</div>
		</form>
	</div>  --%>
	</div>

	</div>


	<!-- footer -->
	<div id="miaps-footer">
		<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
	</div>

</body>
</html>
