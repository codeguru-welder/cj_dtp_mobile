require(["jquery",         
		 "miaps", 
		 "miapspage"
			 
         ], function($,miaps, miapspage) {
            $(function () {
                MapLoad(33.450701, 126.570667);
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

	$("#btngpscall").on("click", Currentlocation);		
	
	/*
	 * 현재위치 지도 표시
	 */
	function Currentlocation() {	   
        miaps.mobile(
            {
                type: "geolocation",
                param: { start: true, onetime: true, type: "navigate" },
            },
            function (data) {  
                if (data.code !== 200)    {
                    alert('위치정보가 없습니다.') ;  
                    return;
                }

                var obj = miaps.parse(data);
                var LatLng = obj.res.split(";");
                var Lat = LatLng[0];
                var Lng = LatLng[1];        
                
                // 지도로딩
                MapLoad(Lat, Lng);
            }
        );      
    }

    // 33.450701, 126.570667
    function MapLoad(Lat, Lng) {
        var mapContainer = document.getElementById("map"), // 지도를 표시할 div
            mapOption = {
                center: new kakao.maps.LatLng(Lat, Lng), // 지도의 중심좌표
                level: 3, // 지도의 확대 레벨
            };

        var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

        // 마커가 표시될 위치입니다
        var markerPosition = new kakao.maps.LatLng(Lat, Lng);

        // 마커를 생성합니다
        var marker = new kakao.maps.Marker({
            position: markerPosition,
        });

        // 마커가 지도 위에 표시되도록 설정합니다
        marker.setMap(map);
        map.setMaxLevel(6); //최고 레벨 값 5       
    }               
});