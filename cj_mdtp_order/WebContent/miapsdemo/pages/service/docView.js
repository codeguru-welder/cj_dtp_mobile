require(["jquery", 
         "underscore",
         "handlebars",
		 "miaps", 
		 "miapspage",
		 "bootstrap"		 
         ], function($, _, handlebars, miaps, miapspage) {
	
	$(function(){
		$("#btnRunDocView").on("click", runDocView);
		
		$(".back_btn").on("click", function (e) {
			e.preventDefault();
			// 네이티브 기능 페이지 이동
			miapsPage.back();
		});
		
		$(".home_btn").on("click", function (e) {
			e.preventDefault();
			// 메인 페이지 이동
			miapsPage.goTopPage();
		});   	
		
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