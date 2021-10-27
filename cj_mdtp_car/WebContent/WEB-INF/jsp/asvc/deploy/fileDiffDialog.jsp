<style type="text/css">
label:hover {
	text-decoration: underline;
	cursor: pointer;
}
.spacer {
	margin-left: 10px;
}
.viewType {
	font-size: 16px;
	clear: both;
	text-align: center;
	padding: 1em;
}
#diffoutput {
	width: 100%;
}
</style>

<script type="text/javascript">
/*
function diffUsingJS() {
    // get the baseText and newText values from the two textboxes, and split them into lines
    var base = difflib.stringAsLines($("baseText").value);
    var newtxt = difflib.stringAsLines($("newText").value);

    // create a SequenceMatcher instance that diffs the two sets of lines
    var sm = new difflib.SequenceMatcher(base, newtxt);

    // get the opcodes from the SequenceMatcher instance
    // opcodes is a list of 3-tuples describing what changes should be made to the base text
    // in order to yield the new text
    var opcodes = sm.get_opcodes();
    var diffoutputdiv = $("diffoutput");
    while (diffoutputdiv.firstChild) diffoutputdiv.removeChild(diffoutputdiv.firstChild);
    var contextSize = $("contextSize").value;
    contextSize = contextSize ? contextSize : null;

    // build the diff view and add it to the current DOM
    diffoutputdiv.appendChild(diffview.buildView({
        baseTextLines: base,
        newTextLines: newtxt,
        opcodes: opcodes,
        // set the display titles for each resource
        baseTextName: "Base Text",
        newTextName: "New Text",
        contextSize: contextSize,
        viewType: $("inline").checked ? 1 : 0
    }));
}*/
function diffUsingJS(viewType) {
	"use strict";
	var byId = function (id) { return document.getElementById(id); },
		base = difflib.stringAsLines(byId("baseText").value),
		newtxt = difflib.stringAsLines(byId("newText").value),
		sm = new difflib.SequenceMatcher(base, newtxt),
		opcodes = sm.get_opcodes(),
		diffoutputdiv = byId("diffoutput");
		/*contextSize = byId("contextSize").value;*/

	while (diffoutputdiv.firstChild) diffoutputdiv.removeChild(diffoutputdiv.firstChild);		
		
	//diffoutputdiv.innerHTML = "";
	/*contextSize = contextSize || null;*/

	diffoutputdiv.appendChild(diffview.buildView({
		baseTextLines: base,
		newTextLines: newtxt,
		opcodes: opcodes,
		baseTextName: "Local Text",
		newTextName: "Remote Text",
		/*contextSize: contextSize,*/
		viewType: viewType
	}));
}

function openFileDiffDlg(fileNm, dirNm) {
	
	var frm = $("#fileDiffModuleFrm");
	frm.find("input[name='fileNm']").val("");
	frm.find("input[name='dirNm']").val("");
	frm.find("input[name='fileNm']").val(fileNm);
	frm.find("input[name='dirNm']").val(dirNm);
	frm.find("input[name='url']").val($('#deployFrm [name="url"]').val());
	frm.find("input[name='accessId']").val($('#deployFrm [name="accessId"]').val());
	frm.find("input[name='accessPw']").val($('#deployFrm [name="accessPw"]').val());
	frm.find("input[name='localPath']").val($('#deployFrm [name="localPath"]').val());
	frm.find("input[name='projectPath']").val($('#deployFrm [name="projectPath"]').val());
	
	ajaxFileComm('fileContentsDiff.miaps', $("#fileDiffModuleFrm"), function(data){
		$("#baseText").val(data.local);
    	$("#newText").val(data.remote);
    	diffUsingJS(0);
    });
	var opt = {
	        autoOpen: false,
	        modal: true,
	        width: '90%',
		    modal: true,
		    title:  (dirNm != null && dirNm != '') ? 'Compare File: ' + dirNm + '/' + fileNm : 'Compare File: ' + fileNm,
			// add a close listener to prevent adding multiple divs to the document
		    close: function(event, ui) {
		        // remove div with all data and events
		        $(this).dialog( "close" );
		    }
	};
	
	//console.log("param:" + dirNm + "/" + fileNm);
	
	$("#fileDiffDialog").dialog(opt).dialog("open");
}
</script>

<div id="fileDiffDialog" title="Compare File" class="dlgStyle">
	<input type="hidden" id="baseText">
	<input type="hidden" id="newText">
	<div class="viewType">
		<input type="radio" name="_viewtype" id="sidebyside" onclick="diffUsingJS(0);" /> <label for="sidebyside">Side by Side Diff</label>
		&nbsp; &nbsp;
		<input type="radio" name="_viewtype" id="inline" onclick="diffUsingJS(1);" /> <label for="inline">Inline Diff</label>
	</div>
	<div style="width:100%; scroll: auto;">
		<div id="diffoutput"> </div>
	</div>
</div>

<form id="fileDiffModuleFrm" name="fileDiffModuleFrm" method="post" >
	<input type="hidden" name="fileNm" value="" />
	<input type="hidden" name="dirNm" value=""/>
	<input type="hidden" name="url" value="" />
	<input type="hidden" name="accessId" value="" />
	<input type="hidden" name="accessPw" value="" />
	<input type="hidden" name="localPath" value="" />
	<input type="hidden" name="projectPath" value="" />
</form>		