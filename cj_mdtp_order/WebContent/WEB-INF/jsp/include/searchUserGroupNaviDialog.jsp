<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>

<!-- 사용자 그룹 내비게이션 dialog -->
<div id="searchUserGroupNaviDialog" title="<mink:message code='mink.web.text.navi.usergroup'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons" style="border-bottom: 0px;">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:$('#searchUserGroupNaviDialog').dialog('close');"><mink:message code="mink.web.text.close"/></button></span>
</div>	
	<!-- 상세화면 -->
	<table class="detailTb" border="0" cellspacing="0" cellpadding="7" width="100%">
		<colgroup>
			<col width="30%" />
			<col width="70%" />
		</colgroup>
		<tbody>
			<tr>
				<th><mink:message code="mink.web.text.navi.usergroup"/></th>
				<td id="searchUserGroupNaviTd"></td>
			</tr>
		</tbody>
		<tfoot></tfoot>
	</table>
</div>

<script type="text/javascript">
//ajax 로 가져온 data 를 알맞은 위치에 삽입
function showSearchUserGroupNaviDialog(grpId) {
	cancelPropagation(event); // tr click 이벤트 막음
	
	var hrf = document.location.href; // ex)${contextURL}/asvc/user/userListView.miaps?type=GET
	hrf = hrf.split('.miaps'); // ex)${contextURL}/asvc/user/userListView
	hrf = hrf[0].split('/'); // ex)[0]=http:, ..., [5]=user, [6]=userListView
	hrf = hrf[hrf.length - 2]; // 파일 디렉토리(폴더) 추출 // ex)user
	
	var url = '../user/userGroupDetail.miaps?';
	if(hrf == 'user') {
		url = 'userGroupDetail.miaps?';
	}
	
	$.post(url, {grpId: grpId}, callbackSearchUserGroupNaviDialog, 'json');
}

function callbackSearchUserGroupNaviDialog(data) {
	var dto = data.userGroup;

	$("#searchUserGroupNaviTd").html(dto.grpNavigation + "(" + dto.grpId + ")");
	
	$("#searchUserGroupNaviDialog").dialog('open');
}

$(function(){
	// 사용자 그룹 네비게이션 상세정보 다이얼로그 팝업
	$("#searchUserGroupNaviDialog").dialog({
		autoOpen: false,
	   	resizable: true,
	   	width: '750px',
	   	modal: true,
	// add a close listener to prevent adding multiple divs to the document
	   	close: function(event, ui) {
	       // remove div with all data and events
	       $(this).dialog( "close" );
	   	}
	});
});

</script>