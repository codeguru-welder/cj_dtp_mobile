require(["jquery",         
		 "miaps", 
		 "miapspage"
			 
         ], function($,miaps, miapspage) {
    $(function () {
        // MapLoad(33.450701, 126.570667);
    });       
    
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

	$("#btngpscall").on("click", startMove);		
	
    var Lat = '';
    var Lng = '';

    // Drawing Manager에서 데이터를 가져와 도형을 표시할 아래쪽 지도 div
    var mapContainer = document.getElementById('map'),
        mapOptions = { 
            center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
            level: 5 // 지도의 확대 레벨
        };

    // 지도 div와 지도 옵션으로 지도를 생성합니다
    var map = new kakao.maps.Map(mapContainer, mapOptions),
        overlays = []; // 지도에 그려진 도형을 담을 배열

    
	/*
	 * 위치 추적 지도 표시
	 */
	function lineTraking() {	   
        // 아래 지도에 그려진 도형이 있다면 모두 지웁니다
        // overlays[0].setMap(null);
        // overlays = [];
        

        //
        var lines = [{type: "polyline", 
            points: [{x: 126.56612047568746,y: 33.451090676226706},{x: 126.56625353371662,y: 33.450288716524135}],
            coordinate: "wgs84"}];

        // var points = [{x: 126.56612047568746,y: 33.451090676226706},{x: 126.56625353371662,y: 33.450288716524135}];
        // lines.push(points);

        console.log(lines);

        // 지도에 가져온 데이터로 선을 그립니다
        drawPolyline(lines);
    }

     // 지도 표시
    function MapLoad(Lat, Lng) {

        // 이동할 위도 경도 위치를 생성합니다 
        var moveLatLon = new kakao.maps.LatLng(Lat, Lng);
		// 지도에 표시된 마커 객체를 가지고 있을 배열입니다
        var markers = [];
        // 지도 중심을 부드럽게 이동시킵니다
        // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
        map.panTo(moveLatLon);   

        // 마커가 표시될 위치입니다
        var markerPosition = new kakao.maps.LatLng(Lat, Lng);

        // 마커를 생성합니다
        var marker = new kakao.maps.Marker({
            position: markerPosition,
        });

        // 마커가 지도 위에 표시되도록 설정합니다
        marker.setMap(map);
		/*markers.push(marker);
		for(i in markers) {
			marker.setMap(null);
		}*/
        map.setMaxLevel(6); //최고 레벨 값 5           
    }   

    // Drawing Manager에서 가져온 데이터 중 선을 아래 지도에 표시하는 함수입니다
    function drawPolyline(lines) {
        var path = pointsToPath(lines[0].points);
        
        console.log(path);

        var polyline = new kakao.maps.Polyline({
            map: map,
            path: path,
            strokeColor: "#39f",
            strokeOpacity: 1,
            strokeStyle: "solid",
            strokeWeight: 3
        });

        overlays.push(polyline);      
    }

    // Drawing Manager에서 가져온 데이터 중
      // 선과 다각형의 꼭지점 정보를 kakao.maps.LatLng객체로 생성하고 배열로 반환하는 함수입니다
      function pointsToPath(points) {
        var len = points.length,
          path = [],
          i = 0;

        for (; i < len; i++) {
          var latlng = new kakao.maps.LatLng(points[i].y, points[i].x);
          path.push(latlng);
        }

        return path;
      }


    var points = [
        {x: 126.57146949682881, y: 33.450369964799215}
        ,{x: 126.57145812081946, y: 33.450496149715384}
        ,{x: 126.57145754436468, y: 33.45061335593662}
        ,{x: 126.57145701224964, y: 33.450721546292705}
        ,{x: 126.57144563617052, y: 33.45084773120007}
        ,{x: 126.57144514838063, y: 33.45094690568931}
        ,{x: 126.57145528285614, y: 33.4510731649368}
        ,{x: 126.57146541735892, y: 33.45119942418114}
        ,{x: 126.57144346326987, y: 33.45128950845799}
        ,{x: 126.57143213143446, y: 33.451406677489956}
        ,{x: 126.57143159927186, y: 33.45151486783178}
        ,{x: 126.57144186682287, y: 33.451614079484436}
        ,{x: 126.57160306437503, y: 33.45164168457241}
        ,{x: 126.57171066242286, y: 33.451633040262685}
        ,{x: 126.57181821614321, y: 33.45163341172145}
        ,{x: 126.5719043034192, y: 33.45162469295917}
        ,{x: 126.57197959101792, y: 33.45162495287245}
        ,{x: 126.57205483433492, y: 33.451634228602366}
        ,{x: 126.57217314343437, y: 33.4516346368735}
        ,{x: 126.57226998605066, y: 33.451625954967}
        ,{x: 126.57234522940142, y: 33.45163523052092}
        ,{x: 126.57243131663061, y: 33.451626511392334}
        ,{x: 126.57253887035303, y: 33.45162688222594}
        ,{x: 126.5726356687049, y: 33.45162721589643}
        ,{x: 126.5727431782196, y: 33.45163660241589}
        ,{x: 126.57284002078629, y: 33.45162792006375}
        ,{x: 126.57294757451622, y: 33.451628290542864}
        ,{x: 126.5730443728748, y: 33.45162862389429}
        ,{x: 126.57318419272893, y: 33.451629105268516}
        ,{x: 126.57327027987466, y: 33.45162038555667}
        ,{x: 126.57336707822856, y: 33.45162071865612}
        ,{x: 126.57350685394341, y: 33.45163021553041}
        ,{x: 126.57364671792651, y: 33.45162168051893}
        ,{x: 126.57373271680409, y: 33.45163099221417}
    ];

	var count = points.length;
    var time = 0;

    function startMove(){
        clearInterval (time);

        time = setInterval(MarkerMove, 100); // 0.1초 간격으로 갱신

    }

    function MarkerMove(){
        count = count -1;
        if( count > 0) {  // 카운트 진행중
            var x = points[count].y;
            var y = points[count].x;
            MapLoad(x, y);        
        } else if ( count == 0 ) {
            clearInterval(time); 
			count = points.length;
			time = 0;
        }
    }
});