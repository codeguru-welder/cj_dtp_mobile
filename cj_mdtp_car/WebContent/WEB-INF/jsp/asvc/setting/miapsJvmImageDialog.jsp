<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
     
<div id="miapsJvmImageDialog" title="Java Virtual Machine" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:$('#miapsJvmImageDialog').dialog('close');">닫기</button></span>
</div>
	<div><img src="${contextURL}/asvc/images/jvm.jpg"></div>
</div>

<script type="text/javascript">
function openMiapsJvmImageDialog() {
	$("#miapsJvmImageDialog").dialog( "open" );
}

$("#miapsJvmImageDialog").dialog({
	autoOpen: false,
    resizable: false,
    width: 'auto',
    modal: false,
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    }
});
</script>