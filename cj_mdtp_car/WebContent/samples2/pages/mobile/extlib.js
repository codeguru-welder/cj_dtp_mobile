require(["jquery", "miaps", "bootstrap"
         ], function($, miaps) {
	

  	$("#btnRun").on("click", goRun);
  	$("#btnBack").on("click", function() {window.history.back();});      	
	$("#extName").focus();
	
	function goRun() {
		miaps.cursor('iconLogin', 'wait', true);
		
		var ext_lib_param = {
			name: $("#extName").val(), // KIDO, KTB,....
			method: $("#extMethod").val(),
			param: $("#extParams").val(),
			res: $("#extReturn").val()
		};
		var config = {
			type: "EXTLIB",
			param: ext_lib_param,
			callback: "_cb.cbRun"
		};
		miaps.mobile(config, _cb.cbRun);	
	}
	
	var callback = {	
		cbRun : function (data) {
			miaps.cursor('iconLogin', 'default');
			console.log('typeof: ' + typeof data);
			console.log(data);
			
			alert('typeof: ' + typeof data);
			if (typeof data == 'object') {
				alert(JSON.stringify(data));
			}
			
			var obj = miaps.parse(data);
						
			console.log(obj);
		}
	};
	window._cb = callback;
});