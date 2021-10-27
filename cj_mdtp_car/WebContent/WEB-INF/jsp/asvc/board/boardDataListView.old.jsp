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
	 * @ 2015.09.24에 백업(old 파일작성)
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
		// accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, role:2 device:3, app:4, push:5, board:6
		if ('${loginUser.menuListString}' == '')
			init_accordion(6);
		else
			init_accordion('board', '${loginUser.menuListString}');
		init(); // 이벤트 핸들러 세팅

		showList(); // 목록 보이기
		showPageHtml(); // 페이징 html 생성

		// 등록 및 수정 시 검색조건 셋팅
		$("input[name='searchKey']").val("<c:out value='${search.searchKey}'/>");
		$("input[name='searchValue']").val("<c:out value='${search.searchValue}'/>");

		// 상세가 있을 경우, 상세 보이기
		if (eval('${!empty boardData}')) {
			var dto = eval("(" + '${boardData}' + ")");
			fnDetailProcess(dto); // 상세정보 매핑
			checkedTrCheckbox($("#listTr" + dto.contentNo)); // 선택한 tr 의 checkbox 에 체크선택/css 변경
		}
	});

	//ajax 로 가져온 data 를 알맞은 위치에 삽입
	function fnAjaxInfoMapping(result) {
		// 상세화면 정보 출력
		var frm = $("#detailFrm");
		frm.find("input[name='contentNo']").val(result.contentNo);
		frm.find("input[name='subject']").val(result.subject);
		frm.find("textarea[name='contents']").val(result.contents);
		frm.find("input[name='readCnt']").val(result.readCnt);
		frm.find("input[name='regNm']").val(result.regNm);
		frm.find("input[name='regDt']").val(toDateFormatString(result.regDt));

		htmlEscapeAll(document); // 특수문자 전체 변환
	}

	// 목록검색
	function goList(pageNum) {
		document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
		document.SearchFrm.action = 'boardDataListView.miaps?';
		document.SearchFrm.submit();
	}

	//입력 값 검증
	function validation(frm) {
		var result = false;

		if (frm.find("input[name='subject']").val() == "") {
			alert("제목을 입력하세요.");
			frm.find("input[name='subject']").focus();
			return true;
		}
		if (frm.find("textarea[name='contents']").val() == "") {
			alert("내용을 입력하세요.");
			frm.find("textarea[name='contents']").focus();
			return true;
		}

		return result;
	}

	// 상세조회호출(ajax)
	function goDetail(contentNo) {
		//checkedTrCheckbox($("#listTr"+contentNo));	// 선택된 row 색깔변경
		$("#detailFrm").find("input[name='contentNo']").val(contentNo); // (선택한)상세
		ajaxComm('boardDataDetail.miaps?', $('#detailFrm'), function(data) {
			//fnDetailProcess(data.boardData); // 상세 ajax 세부작업
			$("#SearchFrm").find("input[name='contentNo']").val(
					data.boardData.contentNo); // (등록한)상세
			goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
		});
	}

	// 등록(ajax) 후 목록 호출
	function goInsert() {
		if (validation($("#insertFrm")))
			return; // 입력 값 검증

		if (!confirm("등록하시겠습니까?"))
			return;
		ajaxComm('boardDataInsert.miaps?', $('#insertFrm'), function(data) {
			$("#SearchFrm").find("input[name='contentNo']").val(
					data.boardData.contentNo); // (등록한)상세
			goList('1'); // 목록/검색(1 페이지로 초기화)
		});
	}

	// 수정(ajax) 후 목록 호출
	function goUpdate() {
		if (validation($("#detailFrm")))
			return; // 입력 값 검증
		if (!confirm("저장하시겠습니까?"))
			return;

		ajaxComm('boardDataUpdate.miaps?', $('#detailFrm'), function(data) {
			resultMsg(data.msg);
			$("#SearchFrm").find("input[name='contentNo']").val(
					data.boardData.contentNo); // 상세조회 key
			goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
		});
	}

	// 삭제(ajax) 후 목록 호출
	function goDelete() {
		if (!confirm("삭제하시겠습니까?"))
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
			alert("삭제할 항목을 선택하세요!");
			return;
		}

		if (!confirm("삭제하시겠습니까?"))
			return;
		ajaxComm('boardDataDelete.miaps?', $('#SearchFrm'), function(data) {
			resultMsg(data.msg);
			document.SearchFrm.contentNo.value = ''; // (삭제한)상세 비움
			goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
		});

	}
</script>
<!-- 탑 메뉴 -->
<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
</head>
<body>

	<!-- 본문 -->
	<div class="bodyContent">
		<!-- 왼쪽 메뉴 -->
		<div class="leftContent">
			<%@ include file="/WEB-INF/jsp/include/left.jsp"%>
		</div>
		<div id="miaps-content">
			<div class="searchDivFrm">
				<form id="SearchFrm" name="SearchFrm" method="post"
					onSubmit="return false;">
					<!-- 검색 hidden -->
					<input type="hidden" name="regNo" value="${loginUser.userNo}" />
					<!-- 로그인한 사용자 -->
					<input type="hidden" name="updNo" value="${loginUser.userNo}" />
					<!-- 로그인한 사용자 -->
					<input type="hidden" name="contentNo" />
					<!-- 상세 -->
					<input type="hidden" name="pageNum" value="${search.currentPage}" />
					<!-- 현재 페이지 -->
					<input type="hidden" name="boardId" value="${board.boardId}" />
					<!-- 게시판ID -->

					<div>
						<h3>
							<span>* ${board.boardNm}</span>
						</h3>
					</div>

					<!-- 검색 화면 -->
					<div>
						<table border="1" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td class="search"><select name="searchKey">
										<option value="" ${search.searchKey == '' ? 'selected' : ''}>전체</option>
										<option value="subject"
											${search.searchKey == 'subject' ? 'selected' : ''}>제목</option>
										<option value="contents"
											${search.searchKey == 'contents' ? 'selected' : ''}>내용</option>
										<option value="regNm"
											${search.searchKey == 'regNm' ? 'selected' : ''}>등록자</option>
								</select> <input type="text" name="searchValue"
									value="<c:out value='${search.searchValue}'/>" />
									<button class='btn-dash' onclick="javascript:goList('1')">검색</button>
								</td>
							</tr>
						</table>
					</div>

					<!-- 목록 화면 -->
					<div>
						<table class="listTb" border="1" cellspacing="0" cellpadding="0"
							width="100%">
							<colgroup>
								<col width="6%" />
								<!-- <col width="10%" /> -->
								<col width="50%" />
								<col width="14%" />
								<col width="15%" />
								<col width="15%" />
							</colgroup>
							<thead>
								<tr>
									<td><input type="checkbox" name="boardDataCheckboxAll" /></td>
									<!-- <td>순번</td> -->
									<td>제목</td>
									<td>조회수</td>
									<td>등록자</td>
									<td>등록일</td>
								</tr>
							</thead>
							<tbody id="listTbody">
								<!-- 목록이 있을 경우 -->
								<c:forEach var="dto" items="${boardDataList}" varStatus="i">
									<tr id="listTr${dto.contentNo}"
										onclick="javascript:goDetail('${dto.contentNo}');">
										<td><input type="checkbox" id="" name="contentNos"
											value="${dto.contentNo}" onclick="checkedCheckboxInTr(event)" /></td>
										<%-- <td>${search.number - i.index}</td> --%>
										<td align="left">${dto.subject}</td>
										<td>${dto.readCnt}</td>
										<td>${dto.regNm}</td>
										<td>${dto.regDt}</td>
									</tr>
								</c:forEach>
							</tbody>
							<tfoot id="listTfoot">
								<!-- 목록이 없을 경우 -->
								<tr>
									<td colspan="6">결과가 없습니다.</td>
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

					<div class="searchBtnArea">
						<span><button class='btn-dash'
								onclick="javascript:showInsert();">등록하기</button>
							<button class='btn-dash' onclick="javascript:goDeleteAll();">삭제하기</button></span>
					</div>
				</form>

				<!-- 등록화면 -->
				<div id="insertDiv" style="display: none">

					<form id="insertFrm" name="insertFrm" method="post"
						class="insertFrm" onSubmit="return false;">
						<input type="hidden" name="regNo" value="${loginUser.userNo}" />
						<!-- 로그인한 사용자 -->
						<input type="hidden" name="boardId" value="${board.boardId}" />
						<!-- 글 등록할 게시판 -->
						<input type="hidden" name="searchKey" value="" />
						<!-- 검색조건 -->
						<input type="hidden" name="searchValue" value="" />
						<!-- 검색조건 -->

						<div>
							<h3>
								<span>* 게시글 등록</span>
							</h3>
						</div>

						<table class="insertTb" border="1" cellspacing="0" cellpadding="0"
							width="100%">
							<colgroup>
								<col width="15%" />
								<col width="85%" />
							</colgroup>
							<tbody>
								<tr>
									<th><span class="criticalItems">제목</span></th>
									<td><input type="text" name="subject" size="30" /></td>
								</tr>
								<tr>
									<th><span class="criticalItems">내용</span></th>
									<td><textarea id="contents" name="contents" cols="50%"
											rows="10"></textarea></td>
								</tr>
							</tbody>
							<tfoot></tfoot>
						</table>

						<div class="insertBtnArea">
							<span><button class='btn-dash'
									onclick="javascript:goInsert();">저장하기</button>
								<button class='btn-dash'
									onclick="javascript:hiddenInsertDetail();">취소</button></span>
						</div>
					</form>
				</div>


				<!-- 상세화면 -->
				<div id="detailDiv" style="display: none">
					<form id="detailFrm" name="detailFrm" method="post"
						class="detailFrm" onSubmit="return false;">
						<input type="hidden" name="updNo" value="${loginUser.userNo}" />
						<!-- 로그인한 사용자 -->
						<input type="hidden" name="contentNo" value="" />
						<!-- key -->
						<input type="hidden" name="searchKey" value="" />
						<!-- 검색조건 -->
						<input type="hidden" name="searchValue" value="" />
						<!-- 검색조건 -->

						<div>
							<h3>
								<span>* 게시판 상세정보</span>
							</h3>
						</div>
						<table class="detailTb" border="1" cellspacing="0" cellpadding="0"
							width="100%">
							<colgroup>
								<col width="15%" />
								<col width="35%" />
								<col width="15%" />
								<col width="35%" />
							</colgroup>
							<tbody>
								<tr>
									<th><span class="criticalItems">제목</span></th>
									<td><input type="text" name="subject" size="30" /></td>
									<th>조회수</th>
									<td><input type="text" name="readCnt" readonly="readonly" /></td>
								</tr>
								<tr>
									<th><span class="criticalItems">내용</span></th>
									<td colspan="3"><textarea id="contents" name="contents"
											cols="50%" rows="10"></textarea></td>
								</tr>
								<tr>
									<th>등록자</th>
									<td><input type="text" name="regNm" readonly="readonly" /></td>
									<th>등록일</th>
									<td><input type="text" name="regDt" readonly="readonly" /></td>
								</tr>
							</tbody>
							<tfoot></tfoot>
						</table>

						<div class="detailBtnArea">
							<span><button class='btn-dash'
									onclick="javascript:goUpdate();">저장하기</button></span> <span><button
									class='btn-dash' onclick="javascript:hiddenInsertDetail();">닫기</button></span>
						</div>
					</form>
				</div>
			</div>

		</div>


		<!-- footer -->
		<div class="footerContent">
			<%@ include file="/WEB-INF/jsp/include/footer.jsp"%>
		</div>
	</div>
</body>
</html>
