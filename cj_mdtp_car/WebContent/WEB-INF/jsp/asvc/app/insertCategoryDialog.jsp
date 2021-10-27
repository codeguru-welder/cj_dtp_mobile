<%-- 앱 카테고리 등록 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<div id="insertCategoryDialog" title="<mink:message code='mink.web.text.category.regist'/>" class="dlgStyle">
	<div class="miaps-popup-top-buttons">
		&nbsp;
		<span><button class='btn-dash' onclick="javascript:goInsert();"><mink:message code="mink.web.text.save"/></button></span>
		<span><button class='btn-dash' onclick="javascript:$('#insertCategoryDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
	</div>
	<div id="insertDiv">
		<form id="insertFrm" name="insertFrm" method="post" class="detailFrm1" onSubmit="return false;">
			<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
			<input type="hidden" name="searchKey" value=""/>	<!-- 검색조건 -->
			<input type="hidden" name="searchValue" value=""/>	<!-- 검색조건 -->		
			<table class="insertTb" border="0" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="20%" />
					<col width="80%" />
				</colgroup>
				<tbody>
					<tr>
						<th><span class="criticalItems"><mink:message code="mink.web.text.category.name"/></span></th>
						<td><input type="text" name="categNm" /></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.description.category"/></th>
						<td><input type="text" name="categDesc" /></td>
					</tr>
				</tbody>
				<tfoot></tfoot>
			</table>
		</form>
	</div>	<!-- insertDiv -->
</div>	<!-- insertCategoryDialog -->

<script type="text/javascript">

	$("#insertCategoryDialog").dialog({
		  autoOpen: false,
		  resizable: false,
		  width: 'auto',
		  modal: true,
			// add a close listener to prevent adding multiple divs to the document
		  close: function(event, ui) {
		      $(this).dialog( "close" );
		  }
	});
</script>