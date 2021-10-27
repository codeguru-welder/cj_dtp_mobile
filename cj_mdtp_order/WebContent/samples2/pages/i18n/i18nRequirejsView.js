require(["jquery", "miaps", "i18n!resource/js/nls/resources", "bootstrap"
         ], function($, miaps, res) {

	var locale = localStorage.getItem('locale') || navigator.language || navigator.userLanguage;
	console.log(locale);
	
	$(function(){
      	$("#btnBack").on("click", function() {window.history.back();});
      	$("#i18nKR").on("click", function() { changeLang('ko-kr'); });
      	$("#i18nUS").on("click", function() { changeLang('en-us'); });
		$("#userid").focus();
		
		/* 다국어 표시 */
		$("#txtId").html(res.id);
		$("#txtPw").html(res.pw);
		$("#txtLogin").html(res.login);
		$("#txtBack").html(res.back);
	});
	
	var changeLang = function (lang) {
		
		locale = localStorage.getItem('locale');
	    if (!locale || locale !== lang) {
	    	localStorage.setItem('locale', lang);
	    	//reload the app
			location.reload();
	    }
	}	
});