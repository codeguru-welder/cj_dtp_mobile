<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mink" uri="/WEB-INF/tld/mink.tld" %>
<%@ page import = "com.thinkm.mink.commons.util.DateUtil" %>

<!-- 메뉴 구성원인 '업체'사용자(NO/ID) 등록 dialog (사용자 검색) -->
<div>
	<div id="searchUserDialogByLegacy" title="<mink:message code='mink.web.text.info.bizuser'/>" class="dlgStyle">
	
		<div id="searchUserDialogTitleByLegacy" class="dialogTitle">
			<mink:message code="mink.web.text.regist.menumember.bizuser"/>
		</div>
		
		<div class="hiddenHrDivSmall"></div>
	
		<!-- 검색 화면 -->
		<div>
			<table class="userTable" border="1" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<td class="search">
						<select name="searchKey">
							<option value=""><mink:message code="mink.web.text.totaluser"/></option>
							<option value="userId"><mink:message code="mink.web.text.userid"/></option>
							<option value="userNm"><mink:message code="mink.web.text.username"/></option>
						</select>
						<input type="text" name="searchValue" />
						<button id="actionSearchUserButtonByLegacy" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.search"/></button>
					</td>
				</tr>
			</table>
		</div>
		
		<!-- 목록 화면 -->
		<div class="searchUserListDialogScroll">
			<table class="read_listTb" border="1" cellspacing="0" cellpadding="0" width="100%">
				<thead id="listTheadSearchUserByLegacy">
					<tr>
						<td><input type="checkbox" name="CheckboxAll" /></td>
						<td><mink:message code="mink.web.text.group"/></td>
						<td><mink:message code="mink.web.text.userid"/></td>
						<td><mink:message code="mink.web.text.username"/></td>
					</tr>
				</thead>
				<tbody id="listTbodySearchUserByLegacy">
				</tbody>
				<tfoot id="listTfootSearchUserByLegacy">
					<tr>
						<td colspan="4"><mink:message code="mink.web.alert.search.user"/></td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>
</div>

<script type="text/javascript">
/** document ready **/
$(function(){
	var roleTp = '';
	var UN = 'UN'; // roleTp: 사용자NO
	var UD = 'UD'; // roleTp: 사용자ID
	// 부모창
	var userNoParentOpenerBtnId = "#insertUserNoDialogOpenerButtonByLegacy";
	//var userIdParentOpenerBtnId = "#insertUserIdDialogOpenerButtonByLegacy";
	// 서버
	var loginUserNo = "${loginUser.userNo}";
	//var menuId = "${menu.menuId}"; // 메뉴ID
	// 현재창
	/** URL **/
	var searchUserUrl = "../app/appRoleSearchLegacyUser.miaps?";
	//var vaildationCountUrl = "appRoleCount.miaps?";
	var insertMenuRoleUrl = "appRoleAndUserInsert.miaps?";
	/***/
	var tableDialogId = "#searchUserDialogByLegacy";
	var actionSearchId = "#actionSearchUserButtonByLegacy";
	//
	var titleId = "#searchUserDialogTitleByLegacy";
	var theadId = "#listTheadSearchUserByLegacy";
	var tbodyId = "#listTbodySearchUserByLegacy";
	var tfootId = "#listTfootSearchUserByLegacy";
	
	// 스크롤 맨 밑으로 이동시, 더보기 실행 변수
	var pageSize = 20; // PageUtil.pageSize = 20
	var startRow = 1;
	var endRow = pageSize;
	
	// 메뉴에 사용자NO/사용자ID 등록
	var insertLegacyUser = function() {
		var $frm = $("<form method='post' />");
		
		var $roleIds = $(":checkbox:checked", tbodyId).clone();
		var regNo = loginUserNo;
		
		if($roleIds.length < 1) {
			alert("<mink:message code='mink.web.alert.select.item'/>");
			return true;
		}
		
		var packageNm = $("#searchFrm3").find("input[name='packageNm']").val();
		var appId = $("#searchFrm3").find("input[name='appId']").val();
		
		$frm.append($("<input type='hidden' name='packageNm' />").val(packageNm));
		$frm.append($("<input type='hidden' name='roleTp' />").val(roleTp));
		//$frm.append($("<input type='hidden' name='roleId' />").val(roleId));
		$frm.append($roleIds); //$frm.append($("<input type='hidden' name='roleIdList' />").val(roleId));
		//$frm.append($("<input type='hidden' name='includeSubYn' />").val(includeSubYn));
		$frm.append($("<input type='hidden' name='regNo' />").val(regNo));
		
		// 알림말
		var alertText = "<mink:message code='mink.web.text.total'/>" + $roleIds.length + "<mink:message code='mink.web.alert.is.registuser'/>";
		if(!confirm(alertText)) return;
		
		// 서버검증 : insertMenuRoleUrl 안에 포함 시킴.
		// ajax
		/*$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
		var anwser = false;
		$.post(vaildationCountUrl, $frm.serialize(), function(data){
			if(0 < data.count) anwser = true;
		}, 'json');
		$.ajaxSetup({async:true}); // 비동기 옵션 켜기
		if(anwser) {
			alert("이미 등록한 사용자가 있습니다!");
			return;
		}*/
		//
		
		// ajax : 업체 사용자 등록 및 앱 권한 등록
		$.post(insertMenuRoleUrl, $frm.serialize(), function(data){
			resultMsg(data.msg);
						
			if (data.code == null || data.code == '') {
				goDetail(appId);
				$( tableDialogId ).dialog( "close" );	
			}
		}, 'json');
		//
	};
	
	// 사용자 검색
	var actionSearchUserByLegacy = function() {
		
		console.log("actionSearchUserByLegacy");
		
		if( pageSize < endRow ) $(".searchUserListDialogScroll").animate({ scrollTop: 0 }); // 스크롤 맨 위으로 이동
		
		// 스크롤 맨 밑으로 이동시, 더보기 실행 변수 초기화
		startRow = 1;
		endRow = pageSize;
		
		var searchKey = $(":input[name='searchKey']", tableDialogId).val();
		var searchValue = $(":input[name='searchValue']", tableDialogId).val();
		var $tr = $();
		var $checkbox = $();
		var alertText = "<mink:message code='mink.web.text.noexist.result'/>";
		
		$(tfootId).hide();
		
		$.post(searchUserUrl, {searchKey: searchKey, searchValue: searchValue}, function(data){
			$(tbodyId).html("");
			
			if(data.userList.length < 1) {
				$tr = $(tfootId).find("tr").clone();
				
				$tr.find("td:eq(0)").html(alertText);
				
				$(tbodyId).append($tr);
			}
			else {
				for(var i = 0; i < data.userList.length; i++) {
					/*
					<thead id="listTheadSearchUserByLegacy">
						<tr>
							<td><input type="checkbox" name="checkAll" /></td>
							<td>조직</td>
							<td>사용자ID</td>
							<td>사용자명</td>
						</tr>
					</thead>
					*/
					$tr = $(theadId).find("tr").clone();
					
					$checkbox = $("<input type='checkbox' name='roleIdList' />");
					var grpNm = ''; // TODO: 조직정보로 바꿈
					var userId = '';
					var userNm = '';
					
					grpNm = data.userList[i].grpNm;
					userId = defenceXSS(data.userList[i].userId);
					userNm = defenceXSS(data.userList[i].userNm);
					
					$checkbox.val(userId + "^" + userNm);
					
					$tr.find("td:eq(0)").html($checkbox);
					$tr.find("td:eq(1)").html(grpNm);
					$tr.find("td:eq(2)").html(userId);
					$tr.find("td:eq(3)").html(userNm);
					
					$(tbodyId).append($tr);
				}
				
				startRow = pageSize + 1; // 시작줄을 마지막줄로 초기화
				endRow = pageSize; // 마지막줄 저장
			}
		}, 'json');
	};
	
	// 스크롤 맨 밑으로 이동시, 더보기 실행
	$(".searchUserListDialogScroll").scroll( function() { // 스크롤 이벤트
		var elem = $(".searchUserListDialogScroll");
		
		if ( elem[0].scrollHeight - elem.scrollTop() == elem.outerHeight()) { // 스크롤 맨 밑 도달
			
			// 더 조회할 목록이 없으면 빠져나감
			if( $("#listTbodySearchUser").find("tr").length < endRow ) return;
			
			showLoading(); // 로딩바 실행
			
			//
			var searchKey = $(":input[name='searchKey']", tableDialogId).val();
			var searchValue = $(":input[name='searchValue']", tableDialogId).val();
			
			// root 나 그룹없음 검색일 경우, 하위포함여부 체크해제
			var searchUserGroupId = $(":input[name='searchUserGroupId']", tableDialogId).val();
			var searchUserGroupSubAllYn = $(":input[name='searchUserGroupSubAllYn']", tableDialogId).val();
			if(searchUserGroupId == '${unclassified}' || searchUserGroupId == '${corporation}') {
				if($(":checkbox[name='searchUserGroupSubAllYn']", tableDialogId).get(0).checked) {
					$(":checkbox[name='searchUserGroupSubAllYn']", tableDialogId).get(0).checked = false;
				}
			}
			if(!$(":checkbox[name='searchUserGroupSubAllYn']", tableDialogId).get(0).checked) searchUserGroupSubAllYn = '';
			//
			
			var $tr = $();
			var $checkbox = $();
			setTimeout(function(){
				$.post(searchUserUrl, {searchKey: searchKey, searchValue: searchValue, startRow: startRow}, function(data){
					
					if( 0 < data.userList.length ) {
						for(var i = 0; i < data.userList.length; i++) {
							$tr = $(theadId).find("tr").clone();
							
							$checkbox = $("<input type='checkbox' name='roleIdList' />");
							var grpNm = '';
							var userId = '';
							var userNm = '';
							
							grpNm = data.userList[i].grpNm;
							userId = data.userList[i].userId;
							userNm = data.userList[i].userNm;
							
							$checkbox.val(userId + "^" + userNm);
							
							$tr.find("td:eq(0)").html($checkbox);
							$tr.find("td:eq(1)").html(grpNm);
							$tr.find("td:eq(2)").html(userId);
							$tr.find("td:eq(3)").html(userNm);
							
							$(tbodyId).append($tr);
						}
					}
					
					startRow = parseInt(data.search.endRow) + 1; // 시작줄을 마지막줄로 초기화
					endRow = parseInt(data.search.endRow); // 마지막줄 저장
					
				}, 'json');
			}, 1000); // end setTimeout() 1초씩 텀을 줌.
		} // end 스크롤 맨 밑 도달
	}); // end 스크롤 이벤트
	
	// 사용자 검색 다이얼로그 팝업 나타나기
	var showSearchUserDialogByLegacy = function(event) {
		if(UN == event.data.roleTp) {
			roleTp = UN;
		}
		else if(UD == event.data.roleTp) {
			roleTp = UD;
		}
				
		$(titleId).html("<mink:message code='mink.web.text.regist.bizuser'/>");
		$(tbodyId).html("");
		$(tfootId).show();
		
		// 스크롤 맨 밑으로 이동시, 더보기 실행 변수 초기화
		startRow = 1;
		endRow = pageSize;
		
		$( tableDialogId ).dialog( "open" ); // 사용자 검색 다이얼로그 팝업 나타나기
		$(":input[name='searchValue']", tableDialogId).focus();
		
		// 엔터 검색
		$(":input[name='searchValue']", tableDialogId).on("keypress", function(e){
			if (e.which == 13) {
				actionSearchUser();
				return false;
			}
		});
	};
	
	// 사용자 검색 다이얼로그
	$( tableDialogId ).dialog({
		autoOpen: false
		, modal: true
		, width: 600
		, buttons: {
			"<mink:message code='mink.web.text.select'/>": function() {
				insertLegacyUser();
            }
			, "<mink:message code='mink.web.text.cancel'/>": function() {
				$( this ).dialog( "close" );
            }
		}
		, position: "top"
	});
	
	// 사용자 검색 다이얼로그 팝업 나타나기
	$(userNoParentOpenerBtnId).bind("click", {roleTp: UN}, showSearchUserDialogByLegacy);
		
	// 사용자 검색
	$(actionSearchId).bind("click", actionSearchUserByLegacy);
});

</script>