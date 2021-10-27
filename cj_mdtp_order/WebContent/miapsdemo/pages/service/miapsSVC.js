require(["jquery", 
         "underscore",
         "handlebars",
		     "miaps", 
		     "miapspage",
         "miapswp",
		     "bootstrap"		 
         ], function($, _, handlebars, miaps, miapspage, miapsWp) {

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
	
	$("#miapsSvc").on("click", miapsSvcScript);
	
	$("#miapsSvcSp").on("click", miapsSvcSpScript);
	
	$("#miapswp").on("click", miapswpScript);
	
  $("#proc_btn").on("click", function(){
    console.log(selectstat);
    if(selectstat == undefined) {
      miaps.mobile(
        {
          type: "toasts",
          param: { msg: '서비스를 선택하세요.' },
        },
        function (data) {}
      );     
    } else {
      if(selectstat == "miapsSvc")  {
        miapsSvc();
      } else if(selectstat == "miapsSvcSp")  {
        miapsSvcSp();
      } else if(selectstat == "miapsWp")  {
        miapswp();
      }
    }    
  });
  
  var selectstat;

  function miapsSvcScript() {
    selectstat= 'miapsSvc';
    var svcScript = 
      `miaps.miapsSvc(
        "com.mink.connectors.hybridtest.login.LoginMan",
        "welfareList",
        "",
        "/minkSvc",
        "_cb.cbmiapsSvc", _cb.cbmiapsSvc);

      var callback = {
        cbmiapsSvc : function (data) {
            .
            .
            .
        }
      };
      window._cb = callback;`;

    $('#scriptarea').val(svcScript);  
  }

  function miapsSvcSpScript() {		
    selectstat= 'miapsSvcSp';
    var svcScript = 
      `miaps.miapsSvcSp(
        "com.mink.connectors.hybridtest.login.LoginMan",
        "welfareList",
        "",
        "/minkSvc",
        function (data) {
            .
            .
            .
        }
      );`;

      $('#scriptarea').val(svcScript); 
  }

  function miapswpScript(){
    selectstat= 'miapsWp';
    var svcScript = 
      `miapsWp.callService('com.mink.connectors.hybridtest.login.LoginMan',
        'welfareList',
        '' 
      ).then(function(data) {				
            .
            .
            .
      });`;

      $('#scriptarea').val(svcScript);
    }
	function miapsSvc() {
            // 웹 페이지에서 입력받은 데이터로 커넥터를 호출
        // Syntax
        //     miaps.miapsSvc(
        //     [connector class],
        //     [method],
        //     [target],
        //     [parameters],
        //     [function name],
        //     [function],
        //     [path name]);
        // Parameters
        //     connector class
        //     : 서버 개발자가 작성한 Class나 MiAPS Server에서 제공하고 있는 Class입니다.
        //     method
        //     :connector class에 정의한 Class에 존재하고, 호출 할 Method입니다.
        //     target
        //     : 어드민센터 업무구분 설정에 등록된 업무구분 값 입니다.
        //     parameters
        //     : method에 전달 할 parameter 입니다. serialize()한 데이터를 전달 합니다.
        //     function name
        //     : 앱에서 결과를 전달 할 콜백 함수 명 입니다.(stinng)
        //     function
        //     : 개발환경(PC)에서 결과를 전달 할 콜백 함수 입니다 (function)
        //     path name (optional)
        //     : MiAPS서버와 통신하는 서블릿 명입니다. 입력하지 않으면 기본값으로 /minkSvc을 사용합니다.

        
		miaps.cursor(null, "wait", true);
        miaps.miapsSvc(
          "com.mink.connectors.hybridtest.login.LoginMan",
          "welfareList",
          "",
          "/minkSvc",
          "_cb.cbmiapsSvc", _cb.cbmiapsSvc);
	}
	
	function miapsSvcSp() {		
         // 콜백 함수명을 임의로 생성하여 콜백함수를 따로 분리하여 개발하지 않을 경우에 사용합니다.
        // 업무 구분(target)은 class+method로 대체 됩니다.
    //    Syntax
    //         miaps.miapsSvcSp(
    //         [connector class],
    //         [method name],
    //         [parameters],
    //         [path name],
    //         [function],
    //         [iframe ID]);
    //     Parameters
    //         connector class
    //         : 서버 개발자가 작성한 Class나 MiAPS Server에서 제공하고 있는 Class입니다.
    //         method
    //         : connector class에 정의한 Class에 존재하고, 호출 할 Method입니다.
    //         parameters
    //         : method에 전달 할 parameter 입니다. JSON Object 또는 String 데이터를 입력 합니다.
    //         path name (optional)
    //         : MiAPS서버와 통신하는 서블릿 명입니다. 기본값은 /minkSvc입니다.
    //         function
    //         : 결과를 전달 할 콜백 함수 입니다 (function)
    //         iframe ID (optional)
    //         : 이 함수가 사용된 iframe ID

        miaps.cursor(null, "wait", true);
        miaps.miapsSvcSp(
          "com.mink.connectors.hybridtest.login.LoginMan",
          "welfareList",
          "",
          "/minkSvc",
          function (data) {
            var source = $("#entry-template").html();
      
              //핸들바 템플릿 컴파일
            var template = handlebars.compile(source);
      
            var obj = miaps.parse(data);
            if (obj.code != "200") {
              console.log(obj.msg);
            } else {
              var data = obj.res;
              console.log(data);        
      
              //커스텀 헬퍼 등록 (write를 인자로 받아서 box에 들어갈 div id를 반환)
              handlebars.registerHelper("box", function (write) {
                if (write == "9") {
                  return "wel_box new";
                } else {
                  return "wel_box";
                }
              });
      
              //핸들바 템플릿에 데이터를 바인딩해서 HTML 생성
              var resobjdata = { datas: obj.res };
      
              var html = template(resobjdata);
      
              //생성된 HTML을 DOM에 주입
              $("#handle").html("");
              $("#handle").append(html);
            }
            miaps.cursor(null, "default");
          }
        );
	}
	
	function miapswp(){   
    miaps.cursor(null, "wait", true);
		miapsWp.callService('com.mink.connectors.hybridtest.login.LoginMan',
				'welfareList',
				{id:1} 
			).then(function (data) {
        var source = $("#entry-template").html();
  
          //핸들바 템플릿 컴파일
        var template = handlebars.compile(source);
  
        var obj = miaps.parse(data);
        if (obj.code != "200") {
          console.log(obj.msg);
        } else {
          var data = obj.res;
          console.log(data);        
  
          //커스텀 헬퍼 등록 (write를 인자로 받아서 box에 들어갈 div id를 반환)
          handlebars.registerHelper("box", function (write) {
            if (write == "9") {
              return "wel_box new";
            } else {
              return "wel_box";
            }
          });
  
          //핸들바 템플릿에 데이터를 바인딩해서 HTML 생성
          var resobjdata = { datas: obj.res };
  
          var html = template(resobjdata);
  
          //생성된 HTML을 DOM에 주입
          $("#handle").html("");
          $("#handle").append(html);
        }
        miaps.cursor(null, "default");
      });
	}
	
	var callback = {	
    cbmiapsSvc : function (data) {
      var source = $("#entry-template").html();

        //핸들바 템플릿 컴파일
      var template = handlebars.compile(source);

      var obj = miaps.parse(data);
      if (obj.code != "200") {
        console.log(obj.msg);
      } else {
        var data = obj.res;
        console.log(data);        

        //커스텀 헬퍼 등록 (write를 인자로 받아서 box에 들어갈 div id를 반환)
        handlebars.registerHelper("box", function (write) {
          if (write == "9") {
            return "wel_box new";
          } else {
            return "wel_box";
          }
        });

        //핸들바 템플릿에 데이터를 바인딩해서 HTML 생성
        var resobjdata = { datas: obj.res };

        var html = template(resobjdata);

        //생성된 HTML을 DOM에 주입
        $("#handle").html("");
        $("#handle").append(html);
      }
      miaps.cursor(null, "default");
    }
	};
	window._cb = callback;
});