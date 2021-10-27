<%-- 카테고리 앱 추가 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<div id="appListViewDialog" title="<mink:message code='mink.web.text.appmanage'/>" class="dlgStyle">
	<div class="miaps-popup-top-buttons">
		&nbsp;
		<span><button class='btn-dash' onclick="javascript:addAppCategory();"><mink:message code="mink.web.text.select"/></button></span>
		<span><button class='btn-dash' onclick="javascript:closeAppListViewDialog();"><mink:message code="mink.web.text.cancel"/></button></span>
	</div>
	<div>
		<div>
			<form id="SearchFrm4appListDialog" name="appListViewSearchFrm" method="post" onSubmit="return false;">
				<!-- 검색 hidden -->
				<input type="hidden" name="appId" /><!-- 상세 -->
				<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->
				<input type="hidden" name="isPopup" value="Y" />
				<input type="hidden" name="categId" value="${search.categId}"/><!-- 부모창의 id -->
				<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
			
			<div style="text-align: right; font: italic 13px 맑은 고딕, 돋움, arial; color:#808080;"><mink:message code="mink.web.text.invisible.nopublicapp"/></div>
			
			<!-- 검색 화면 -->
			<div>
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr> 	
						<td class="search">
							<select name="searchKey">
								<option value="" ${search.searchKey == '' ? '' : ''}><mink:message code="mink.web.text.full.all"/></option>
								<option value="appNm" ${search.searchKey == 'appNm' ? 'selected' : ''}><mink:message code="mink.web.text.appname"/></option>
								<option value="appId" ${search.searchKey == 'appId' ? 'selected' : ''}><mink:message code="mink.web.text.appid"/></option>
								<option value="packageNm" ${search.searchKey == 'packageNm' ? 'selected' : ''}><mink:message code="mink.web.text.packagename"/></option>
							</select>
							<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>"/>
							<button class='btn-dash' onclick="javascript:selectAppList();"><mink:message code="mink.web.text.search"/></button>
						</td>
					</tr>
				</table>
			</div>
			
			<!-- 목록 화면 -->
			<div>
				<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="6%" />
						<col width="40%" />
						<col width="11%" />
						<col width="14%" />
						<col width="15%" />
						<col width="14%" />
					</colgroup>
					<thead>
						<tr>
							<td><input type="checkbox" name="appCheckboxAll" /></td>
							<!-- <td>순번</td> -->
							<td><mink:message code="mink.web.text.appname"/></td>
							<td><mink:message code="mink.web.text.platform"/></td>
							<td><mink:message code="mink.web.text.status.regist"/></td>
							<td><mink:message code="mink.web.text.status.commonapp"/></td>
							<td><mink:message code="mink.web.text.regdate"/></td>
						</tr>
					</thead>
					<tbody id="appListTbody">
					</tbody>
					<tfoot id="appListTfoot">
					</tfoot>
				</table>
			</div>
			
			<div id="paginateDiv" class="paginateDiv" >
				<div class="paginateDivSub">
				<!-- start paging -->
				<%@ include file="/WEB-INF/jsp/include/pagination.jsp" %>
				<!-- end paging -->
				</div>
			</div>
			</form>	<!-- SearchFrm4appListDialog -->
		</div>
	</div>
</div>	<!-- appListViewDialog -->

<script type="text/javascript">

$("#appListViewDialog").dialog({
	  autoOpen: false,
	  resizable: false,
	  width: 'auto',
	  modal: true,
		// add a close listener to prevent adding multiple divs to the document
	  close: function(event, ui) {
	      $(this).dialog( "close" );
	      $("#SearchFrm4appListDialog").find("input[name='searchKey']").val('');
		  $("#SearchFrm4appListDialog").find("input[name='searchValue']").val('');
	  }
	});
	
	
//카테고리 앱 추가 > 선택click
function addAppCategory() {
	var checkedCnt = $("#appListTbody").find(":checkbox:checked").length;
	if(checkedCnt < 1) {
		alert("<mink:message code='mink.web.alert.select.regapp'/>");
		return;
	}
	
	if( !confirm(checkedCnt+ " <mink:message code='mink.web.alert.is.registapp'/>") ) return;
	ajaxComm('appCategoryMemberInsert.miaps?', $('#SearchFrm4appListDialog'), function(data){
		goAppMemberList("1");
		$("#appListViewDialog").dialog("close");
	});
}	
		
//카테고리 앱 추가 리스트그리기
function setTbodyList(data, categId) {
	
	$("#SearchFrm4appListDialog").find("input[name='categId']").val(categId);
	$('#appListTbody').empty();
	var tBody = "";
	if(data != null) {
		for(var i = 0;i < Object.keys(data).length; i++) {
			
			var platformNm = "";
			var launcherNm = "";
			var publicNm = "";
			
			if(data[i].platformCd == "2000012") platformNm = "ANDROID";
			if(data[i].platformCd == "2000013") platformNm = "IOS";
			if(data[i].platformCd == "2000023") platformNm = "IOS";
			
			if(data[i].launcherYn == "Y") launcherNm = "<mink:message code='mink.web.text.approval'/>";
			if(data[i].launcherYn == "N") launcherNm = "<mink:message code='mink.web.text.unapproval'/>";
			
			if(data[i].publicYn == "Y") publicNm = "<mink:message code='mink.web.text.common'/>";
			if(data[i].publicYn == "N") publicNm = "<mink:message code='mink.web.text.commonapp'/>";
			
			tBody += "<tr id='listTrr"+data[i].appId+ "'>";
			tBody += 	"<td>";
			tBody +=		"<input type='checkbox' name='appIds' value='"+data[i].appId+"' onclick='checkedCheckboxInTr(event)'/>";
			tBody +=		"<input type='hidden' name='appNm' value='"+defenceXSS(data[i].appNm)+"' />";
			tBody +=		"<input type='hidden' name='platformCd' value='"+data[i].platformCd+"' />";
			tBody +=		"<input type='hidden' name='launcherYn' value='"+data[i].launcherYn+"' />"
			tBody +=		"<input type='hidden' name='publicYn' value='"+data[i].publicYn+"' />"
			tBody +=		"<input type='hidden' name='regDt' value='"+data[i].regDt+"' />"
			tBody +=	"</td>";
			tBody +=	"<td align='left'>"+defenceXSS(data[i].appNm)+"</td>";
			tBody +=	"<td align='left'>"+platformNm+"</td>";
			tBody +=	"<td>"+launcherNm+"</td>";
			tBody +=	"<td>"+publicNm+"</td>";
			tBody +=	"<td>"+data[i].regDt+"</td>";
			tBody += "</tr>";	
		}
		
		$('#appListTbody').append(tBody);		
	} else {
		tBody += "<tr>";
		tBody += "<mink:message code='mink.web.text.noexist.result'/>";
		tBody += "</tr>";
		
		$('#appListTfoot').html(tBody);
	}
	
}

//검색 초기화 및 화면닫기
function closeAppListViewDialog() {
	$("#SearchFrm4appListDialog").find("input[name='searchKey']").val('');
	$("#SearchFrm4appListDialog").find("input[name='searchValue']").val('');
	$('#appListViewDialog').dialog('close');
}
</script>