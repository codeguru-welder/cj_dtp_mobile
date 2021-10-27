require(["jquery", "miaps", "bootstrap"
         ], function($, miaps) {
	
	$(function(){
		$("#btnRunDocView").on("click", runDocView);
		$("#btnBack").on("click", function() {window.history.back();});
		
		//var docdata = "http://58.181.28.55|http://58.181.28.55/miaps/attachs/요건정의서.docx|D"; 
		//$("#docData").val(docdata);	
	});

	function runDocView() {
		var $frm = $("#frmDocView");
		var srvUrl = $frm.find("input[name='msurl']").val();
		var docUrl = $frm.find("input[name='docurl']").val();
		var docdata = srvUrl + '|' + docUrl + '|D';
		
		var config = {
			type: 'DOCVIEW',
			param: docdata,
			callback: '_cb.cbDocView'
		};
		
		miaps.mobile(config, _cb.cbDocView);
	}
	
	/* ---- callback function ---- */
	var callback = {
		cbDocView : function (data) {
			console.log(data);		
		}
	};
	window._cb = callback;
});