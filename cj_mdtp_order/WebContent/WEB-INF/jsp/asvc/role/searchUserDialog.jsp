<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>

<!-- 사용자 검색 dialog -->
<div id="searchUserDialog" title="<mink:message code='mink.web.text.info.user'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button id="searchUserDlgSelectedButton" class='btn-dash'><mink:message code="mink.web.text.select"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#searchUserDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>

	<!-- 검색 화면 -->
	<div>
		<table class="userTable" border="0" cellspacing="0" cellpadding="0" width="100%">
			<!-- 그룹검색 tr -->
			<tr>
				<td class="navigationTd">
					<span class="leftFloatSpan">
						<span id="searchUserGroupNavigationSpan">${loginUser.adminYn == ynYes ? corporationName : loginUser.userGroup.grpNavigation}</span><!-- 그룹 네비게이션 -->
					</span>
					<span class="rightFloatSpan">
						<input id="searchUserGroupId" type="hidden" name="searchUserGroupId" value="${loginUser.adminYn == ynYes ? corporation : loginUser.userGroup.grpId}" /><!-- 검색그룹ID -->
						<input id="searchUserGroupNm" type="hidden" value="${loginUser.adminYn == ynYes ? corporationName : loginUser.userGroup.grpNm}" /><!-- 검색그룹NM -->
						<span><label><input id="searchUserGroupSubAllChekbox" type="checkbox" name="searchUserGroupSubAllYn" value="${ynYes}" />${subGroupContainText}</label></span><!-- 하위그룹 검색포함여부 -->
						<span><button id="searchUserGroupTreeviewDialogOpenerButton" class='btn-dash'><mink:message code="mink.web.text.search.group"/></button></span><!-- 그룹 조직도(treeview) 다이얼로그 오프너 -->
					</span>
				</td>
			</tr>
			<tr>
				<td class="search">
					<select name="searchKey">
						<option value=""><mink:message code="mink.web.text.totaluser"/></option>
						<option value="userNm"><mink:message code="mink.web.text.username"/></option>
						<option value="userId"><mink:message code="mink.web.text.userid"/></option>
						<option value="userNo"><mink:message code="mink.web.text.userno"/></option>
					</select>
					<input type="text" name="searchValue" />
					<button id="actionSearchUserButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.search"/></button>
				</td>
			</tr>
		</table>
	</div>
	
	<!-- 목록 화면 -->
	<div class="searchUserListDialogScroll">
		<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
			<colgroup>
				<col width="10%" />
				<col width="35%" />
				<col width="30%" />
				<col width="20%" />
			</colgroup>
			<thead id="listTheadSearchUser">
				<tr>
					<td><input type="checkbox" name="CheckboxAll" /></td>
					<td><mink:message code="mink.web.text.username"/></td>
					<td><mink:message code="mink.web.text.userid"/></td>
					<td><mink:message code="mink.web.text.userno"/></td>
				</tr>
			</thead>
			<tbody id="listTbodySearchUser">
			</tbody>
			<tfoot id="listTfootSearchUser">
				<tr>
					<td colspan="4"><mink:message code="mink.web.alert.search.user"/></td>
				</tr>
			</tfoot>
		</table>
	</div>
</div>

<script type="text/javascript">
/** document ready **/
$(function(){
	var memTp = '';
	var UN = 'UN'; // memTp: 사용자NO
	var UD = 'UD'; // memTp: 사용자ID
	// 부모창
	var userNoParentOpenerBtnId = "#insertUserNoDialogOpenerButton";
	var userIdParentOpenerBtnId = "#insertUserIdDialogOpenerButton";
	// 서버
	var loginUserNo = "${loginUser.userNo}";
	var roleGrpId = "${roleGroup.roleGrpId}"; // 권한ID
	// 현재창
	var tableDialogId = "#searchUserDialog";
	var actionSearchId = "#actionSearchUserButton";
	//
	var titleId = "#searchUserDialogTitle";
	var theadId = "#listTheadSearchUser";
	var tbodyId = "#listTbodySearchUser";
	var tfootId = "#listTfootSearchUser";
	
	// 스크롤 맨 밑으로 이동시, 더보기 실행 변수
	var pageSize = 20; // PageUtil.pageSize = 20
	var startRow = 1;
	var endRow = pageSize;
	
	// 권한그룹에 사용자NO/사용자ID 등록
	var insert = function() {
		var $frm = $("<form method='post' />");
		
		var $memIds = $(":checkbox:checked", tbodyId).clone();
		var regNo = loginUserNo;
		
		if($memIds.length < 1) {
			alert("<mink:message code='mink.web.alert.select.item'/>");
			return true;
		}
		
		$frm.append($("<input type='hidden' name='roleGrpId' />").val(roleGrpId));
		$frm.append($("<input type='hidden' name='memTp' />").val(memTp));
		//$frm.append($("<input type='hidden' name='memId' />").val(memId));
		$frm.append($memIds); //$frm.append($("<input type='hidden' name='memIdList' />").val(memId));
		//$frm.append($("<input type='hidden' name='includeSubYn' />").val(includeSubYn));
		$frm.append($("<input type='hidden' name='regNo' />").val(regNo));
		
		// 서버검증
		// ajax
		var anwser = false;
		$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
		$.post('roleGroupMemberCount.miaps?', $frm.serialize(), function(data){
			if(0 < data.count) anwser = true;
		}, 'json');
		$.ajaxSetup({async:true}); // 비동기 옵션 켜기
		if(anwser) {
			alert("<mink:message code='mink.alert.already.user'/>");
			return;
		}
		//
		
		// 알림말
		var alertText = "<mink:message code='mink.web.text.total'/> " + $memIds.length + "<mink:message code='mink.web.alert.is.registuser'/>";
		if(!confirm(alertText)) return;
		// ajax
		$.post('roleGroupMemberInsert.miaps?', $frm.serialize(), function(data){
			resultMsg(data.msg);
			goList(); // 바로 검색
		}, 'json');
		//
	};
	
	// 사용자 검색
	var actionSearchUser = function() {
		if( pageSize < endRow ) $(".searchUserListDialogScroll").animate({ scrollTop: 0 }); // 스크롤 맨 위으로 이동
		
		// 스크롤 맨 밑으로 이동시, 더보기 실행 변수 초기화
		startRow = 1;
		endRow = pageSize;
		
		var searchKey = $(":input[name='searchKey']", tableDialogId).val();
		var searchValue = $(":input[name='searchValue']", tableDialogId).val();
		var $tr = $();
		var $checkbox = $();
		var alertText = "<mink:message code='mink.web.text.noexist.result'/>";
		
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
		$(tfootId).hide();
		
		$.post('../user/userListSearch.miaps?', {searchKey: searchKey, searchValue: searchValue, searchUserGroupId: searchUserGroupId, searchUserGroupSubAllYn: searchUserGroupSubAllYn}, function(data){
			$(tbodyId).html("");
			
			if(data.userList.length < 1) {
				$tr = $(tfootId).find("tr").clone();
				
				$tr.find("td:eq(0)").html(alertText);
				
				$(tbodyId).append($tr);
			}
			else {
				for(var i = 0; i < data.userList.length; i++) {
					$tr = $(theadId).find("tr").clone();
					
					$checkbox = $("<input type='checkbox' name='memIdList' onclick=\"checkedCheckboxInTr(event);\" />");
					var userNo = '';
					var userId = '';
					var userNm = '';
					
					userNo = data.userList[i].userNo;
					userId = defenceXSS(data.userList[i].userId);
					userNm = defenceXSS(data.userList[i].userNm);
					
					if(UN == memTp) $checkbox.val(userNo);
					else if(UD == memTp) $checkbox.val(userId);
					
					$tr.find("td:eq(0)").html($checkbox);
					$tr.find("td:eq(1)").attr("align", "left").html(userNm);
					$tr.find("td:eq(2)").html("<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('"+userNo+"')\">"+userId+"</a>");
					$tr.find("td:eq(3)").html(userNo);

					$tr.click(function(){
						clickTrCheckedCheckbox(this);
					});

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
				$.post('../user/userListSearch.miaps?', {searchKey: searchKey, searchValue: searchValue, searchUserGroupId: searchUserGroupId, searchUserGroupSubAllYn: searchUserGroupSubAllYn, startRow: startRow}, function(data){
					
					if( 0 < data.userList.length ) {
						for(var i = 0; i < data.userList.length; i++) {
							$tr = $(theadId).find("tr").clone();
							
							$checkbox = $("<input type='checkbox' name='memIdList' onclick=\"checkedCheckboxInTr(event);\" />");
							var userNo = '';
							var userId = '';
							var userNm = '';
							
							userNo = data.userList[i].userNo;
							userId = defenceXSS(data.userList[i].userId);
							userNm = defenceXSS(data.userList[i].userNm);
							
							if(UN == memTp) $checkbox.val(userNo);
							else if(UD == memTp) $checkbox.val(userId);
							
							$tr.find("td:eq(0)").html($checkbox);
							$tr.find("td:eq(1)").attr("align", "left").html(userNm);
							$tr.find("td:eq(2)").html("<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('"+userNo+"')\">"+userId+"</a>");
							$tr.find("td:eq(3)").html(userNo);

							$tr.click(function(){
								clickTrCheckedCheckbox(this);
							});

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
	var showSearchUserDialog = function(event) {
		if(UN == event.data.memTp) {
			memTp = UN;
		}
		else if(UD == event.data.memTp) {
			memTp = UD;
		}
		
		$(titleId).html("<mink:message code='mink.web.text.permissionmember_registuser'/>");
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
		/*, buttons: {
			"선택": function() {
				insert();
            }
			, "취소": function() {
				$( this ).dialog( "close" );
            }
		}*/
	});
	
	// 사용자 검색 다이얼로그 팝업 나타나기
	$(userNoParentOpenerBtnId).bind("click", {memTp: UN}, showSearchUserDialog);
	
	// 사용자 검색 다이얼로그 팝업 나타나기
	$(userIdParentOpenerBtnId).bind("click", {memTp: UD}, showSearchUserDialog);
	
	// 사용자 검색
	$(actionSearchId).bind("click", actionSearchUser);
	
	$("#searchUserDlgSelectedButton").bind("click", insert);
	
});

</script>