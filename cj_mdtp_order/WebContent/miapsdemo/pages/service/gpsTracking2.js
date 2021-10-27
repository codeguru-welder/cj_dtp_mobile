require(["jquery",
    "miaps",
    "miapspage"

], function ($, miaps, miapspage) {
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

    var mapContainer = document.getElementById('map'), // 지도를 표시할 div
        mapOption = {
            center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
            level: 3 // 지도의 확대 레벨
        };

    // 지도 div와 지도 옵션으로 지도를 생성합니다
    var map = new kakao.maps.Map(mapContainer, mapOption)

    var imgSrc = '/miapsdemo/resource/img/truck.png',
        imgSize = new kakao.maps.Size(45, 45),
        imgOption = {offset: new kakao.maps.Point(23, 33)}

    var markerImg = new kakao.maps.MarkerImage(imgSrc, imgSize, imgOption),
        markerPosition = new kakao.maps.LatLng(map.getCenter())

    // 지도를 클릭한 위치에 표출할 마커입니다
    var marker = new kakao.maps.Marker({
        // 지도 중심좌표에 마커를 생성합니다
        position: markerPosition,
        image: markerImg
    });

    var points = [
        {x: 126.57146949682881, y: 33.450369964799215}
        , {x: 126.57145812081946, y: 33.450496149715384}
        , {x: 126.57145754436468, y: 33.45061335593662}
        , {x: 126.57145701224964, y: 33.450721546292705}
        , {x: 126.57144563617052, y: 33.45084773120007}
        , {x: 126.57144514838063, y: 33.45094690568931}
        , {x: 126.57145528285614, y: 33.4510731649368}
        , {x: 126.57146541735892, y: 33.45119942418114}
        , {x: 126.57144346326987, y: 33.45128950845799}
        , {x: 126.57143213143446, y: 33.451406677489956}
        , {x: 126.57143159927186, y: 33.45151486783178}
        , {x: 126.57144186682287, y: 33.451614079484436}
        , {x: 126.57160306437503, y: 33.45164168457241}
        , {x: 126.57171066242286, y: 33.451633040262685}
        , {x: 126.57181821614321, y: 33.45163341172145}
        , {x: 126.5719043034192, y: 33.45162469295917}
        , {x: 126.57197959101792, y: 33.45162495287245}
        , {x: 126.57205483433492, y: 33.451634228602366}
        , {x: 126.57217314343437, y: 33.4516346368735}
        , {x: 126.57226998605066, y: 33.451625954967}
        , {x: 126.57234522940142, y: 33.45163523052092}
        , {x: 126.57243131663061, y: 33.451626511392334}
        , {x: 126.57253887035303, y: 33.45162688222594}
        , {x: 126.5726356687049, y: 33.45162721589643}
        , {x: 126.5727431782196, y: 33.45163660241589}
        , {x: 126.57284002078629, y: 33.45162792006375}
        , {x: 126.57294757451622, y: 33.451628290542864}
        , {x: 126.5730443728748, y: 33.45162862389429}
        , {x: 126.57318419272893, y: 33.451629105268516}
        , {x: 126.57327027987466, y: 33.45162038555667}
        , {x: 126.57336707822856, y: 33.45162071865612}
        , {x: 126.57350685394341, y: 33.45163021553041}
        , {x: 126.57364671792651, y: 33.45162168051893}
        , {x: 126.57373271680409, y: 33.45163099221417}
    ];

    function pointsToPath(points) {
        var len = points.length,
            path = []

        for (var i = 0; i < len; i++) {
            var latlng = new kakao.maps.LatLng(points[i].y, points[i].x);
            path.push(latlng);
        }

        return path;
    }

    var path = pointsToPath(points)
    console.log(path)

    var time = 0

    var interval

    function startMove() {
        interval = setInterval(movePosition, 50)
    }

    function movePosition() {
        console.log(time)
        marker.setPosition(path[time])
        map.setCenter(path[time])
        time += 1
        if (time >= path.length) {
            clearInterval(interval)
            time = 0
        }
    }

    marker.setMap(map);
});