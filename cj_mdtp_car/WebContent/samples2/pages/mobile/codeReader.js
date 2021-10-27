require(["jquery", "miaps", "bootstrap"
         ], function($, miaps) {

  	$("#btnRun").on("click", goRun);
  	$("#btnBack").on("click", function() {window.history.back();});      	
	
	function goRun() {
		var config = {
			type: "SCAN",
			param: 'webtest1234',
			callback: "_cb.cbRun"
		};
		miaps.mobile(config, _cb.cbRun);	
	}
	
	var callback = {	
		cbRun : function (data) {
			console.log('typeof: ' + typeof data);
			console.log(data);
			
			if (typeof data == 'object') {
				alert('typeof: ' + typeof data + ', ' + JSON.stringify(data));
			} else if (typeof data == 'string') {
				alert('typeof: ' + typeof data + ', ' + data);
			}
			
			var obj = miaps.parse(data);
			
			$("#readData").val("");
			$("#readData").val(data.res);
						
			console.log(obj);
		}
	};
	window._cb = callback;
});