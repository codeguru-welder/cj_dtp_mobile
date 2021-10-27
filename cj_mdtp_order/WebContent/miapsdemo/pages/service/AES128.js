require(["jquery",         
		 "miaps", 
		 "miapspage",
		 "bootstrap"		 
         ], function($, miaps, miapspage) {

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
	
    $('#btnEncrypt').on('click', function() {
        // var aestype = $("#kind option:selected").val();
        var testdata = $("#data").val();
        if(!testdata)   {
            miaps.mobile(
                {
                  type: "toasts",
                  param: { msg: "데이터를 입력해주세요." },
                },
                function (data) {}
            );
            return;        
        }
        var config = {
            type: "encrypt",
            param: {type: "aes128", data: testdata},
            callback: "_cb.cbEncrypt"
        };
        miaps.mobile(config, _cb.cbEncrypt);
    });
    
    $('#btnDecrypt').on('click', function() {
        // var aestype = $("#kind option:selected").val();
        var testdata = $("#decdata").val();
        if(!testdata)   {
            miaps.mobile(
                {
                  type: "toasts",
                  param: { msg: "데이터를 입력해주세요." },
                },
                function (data) {}
            );
            return;
        }
        var config = {
            type: "decrypt",
            param: {type: "aes128", data: testdata},
            callback: "_cb.cbDecrypt"
        };
        miaps.mobile(config, _cb.cbDecrypt);
    });	
	
	$("#clearAllValue").on("click", function() {
        $("#data").val('');
        $("#decdata").val('');
        $("#resdata").val('');
    });	

	$( "#resdata" ).prop( "disabled", true );
	
	var callback = {
		cbEncrypt : function (data) {
			var obj = miaps.parse(data);
			console.log(obj);

			if(obj.code == '200') {
                $("#decdata").val(obj.res);
            } else  {
                console.log(JSON.stringify(obj).replace(/,"/g, ',\n"'));
                alert(JSON.stringify(obj).replace(/,"/g, ',\n"'));
            }			
		},			

		cbDecrypt : function (data) {
			var obj = miaps.parse(data);
			console.log(obj);

			if(obj.code == '200') {
                $("#resdata").val(obj.res);
            } else  {
                console.log(JSON.stringify(obj).replace(/,"/g, ',\n"'));
                alert(JSON.stringify(obj).replace(/,"/g, ',\n"'));
            }
		}
	};
	window._cb = callback;
});