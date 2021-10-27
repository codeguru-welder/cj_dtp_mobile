<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes" %>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
    /*
     * 장치 접속 현황 화면 - (deviceAccessView.jsp)
     *
     * @author changsh9155
     * @since 2021.04.08
     * @modify 2021.04.08~ changsh9155
     */
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
    <%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
    <title><mink:message code="mink.label.page_title"/></title>

    <%--  TOAST UI CHART  --%>
    <link rel="stylesheet" href="${contextPath}/css/toastui-chart.min.css"/>
    <script type="text/javascript" src="${contextPath}/js/toastui-chart.min.js"></script>
    <script type="text/javascript" src="${contextPath}/js/underscore.js"></script>

    <script type="text/javascript">
        const START_DATE = '2017-03-22';
        const END_DATE = '2021-04-08';

        $(function () {
            // accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
            init_accordion('monitoring', '${loginUser.menuListString}');
            $("#topMenuTile").html("<mink:message code='mink.web.text.monitoring_deviceaccess'/>");

            // TODO: onresize 추가

            init();

            // OS별 사용 데이터
            let osData = setData('${osAccessData}');
            // OS별 사용 내역 그래프 그리기
            drawChart(osData, 'chart');

            // TODO: 기종별 사용 데이터
            // TODO: 기종별 사용 내역 그래프 그리기
        })

        function setData(rawData) {
            let responseData = [];
            let groupedLogDt = {};
            let arrayData = [];

            let categoriesArray = [];
            let result = {};
            result.series = {};

            // TODO: 각각의 변수로 선언할 것을 array로 수정
            let androidArray = [];
            let iosArray = [];
            let ipadArray = [];
            let andTabArray = [];

            if (!rawData) {
                alert('데이터가 없습니다.');
            } else {
                responseData = listStringToJson(rawData);
                groupedLogDt = grouping(responseData, 'log_dt');
                arrayData = jsonToArray(groupedLogDt, Object.keys(groupedLogDt).length);
            }

            const strDate = '${search.startDt}';
            const endDate = '${search.endDt}';

            const strYM = strDate.substr(0, 4) + strDate.substr(5, 2);
            const endYM = endDate.substr(0, 4) + endDate.substr(5, 2);

            console.log(strYM + ' ~ ' + endYM);

            // total date array
            let tmpYM = strYM;
            const intervalMonth = getMonthBetweenDate(strDate, endDate);
            for (let i = 0; i < intervalMonth; i++) {
                categoriesArray.push(tmpYM.toString());
                tmpYM++;
                let tmpMonth = (tmpYM.toString()).substr(4, 2);

                // 12월에서 ++일 경우 1년을 넘긴다.
                if (parseInt(tmpMonth) > 12) {
                    tmpYM += 88;
                }
            }
            // 마지막 달 추가
            categoriesArray.push(endYM);

            // categoriesArray를 순회하면서 각 결과 리스트에 채워넣기
            for (let i = 0; i < Object.keys(categoriesArray).length; i++) {
                if (arrayData[categoriesArray[i]] === undefined) {
                    // result array에 0 추가
                    // TODO: 반복문 처리 필요
                    androidArray.push(0);
                    iosArray.push(0);
                    ipadArray.push(0);
                    andTabArray.push(0);
                } else {
                    if (categoriesArray[i] === arrayData[categoriesArray[i]][0].log_dt) {

                        // TODO: 반복문 처리 필요
                        let andObj = arrayData[categoriesArray[i]]
                        .filter(data => data.platform_cd.includes('2000012'))
                        let iosObj = arrayData[categoriesArray[i]]
                        .filter(data => data.platform_cd.includes('2000013'))
                        let ipadObj = arrayData[categoriesArray[i]]
                        .filter(data => data.platform_cd.includes('2000023'))
                        let andTabObj = arrayData[categoriesArray[i]]
                        .filter(data => data.platform_cd.includes('2000022'))

                        if (!andObj || andObj.length === 0) {
                            androidArray.push(0)
                        } else {
                            androidArray.push(parseInt(andObj[0]['count']))
                        }

                        if (!iosObj || iosObj.length === 0) {
                            iosArray.push(0)
                        } else {
                            iosArray.push(parseInt(iosObj[0]['count']))
                        }

                        if (!ipadObj || ipadObj.length === 0) {
                            ipadArray.push(0)
                        } else {
                            ipadArray.push(parseInt(ipadObj[0]['count']))
                        }

                        if (!andTabObj || andTabObj.length === 0) {
                            andTabArray.push(0)
                        } else {
                            andTabArray.push(parseInt(andTabObj[0]['count']))
                        }

                    } else {
                        console.log('no ym')
                    }
                }
            }

            result.categories = categoriesArray;

            // TODO: series refactoring
            result.series.android = androidArray;
            result.series.ios = iosArray;
            result.series.ipad = ipadArray;
            result.series.andTab = andTabArray;

            console.log(result)
            return result;
        }

        function drawChart(param, target) {
            const chart = toastui.Chart;
            const el = document.getElementById(target);

            let data = {};

            data.categories = param.categories;
            data.series = [];
            const seriesLength = Object.keys(param.series).length;

            for (let i = 0; i < seriesLength; i++) {
                let tmpObj = {};
                tmpObj['name'] = Object.keys(param.series)[i];
                tmpObj['data'] = param.series[Object.keys(param.series)[i]];

                data.series.push(tmpObj)
            }

            const options = {
                chart: {width: 1000, height: 400},
                series: {
                    zoomable: true,
                    dataLabels: {visible: false, offsetY: -10}
                },
                theme: {
                    series: {
                        dataLabels: {
                            fontFamily: 'monaco',
                            fontSize: 10,
                            fontWeight: 300,
                            useSeriesColor: true,
                            textBubble: {
                                visible: true,
                                paddingY: 3,
                                paddingX: 6,
                                arrow: {
                                    visible: true,
                                    width: 5,
                                    height: 5,
                                    direction: 'bottom'
                                }
                            }
                        }
                    }
                }
            };
            const chart1 = chart.lineChart({el, data, options});
        }

        // json String을 JSON으로 파싱
        function listStringToJson(str) {
            let result = '';
            if (str) {
                let tmp = str.replaceAll('{', '{"');
                tmp = tmp.replaceAll('=', '":"');
                tmp = tmp.replaceAll(', ', '","');
                tmp = tmp.replaceAll('}', '"}');
                tmp = tmp.replaceAll('}","{', '},{');
                result = JSON.parse(tmp);
            }
            return result;
        }

        // json grouping
        function grouping(jsonData, target) {
            return jsonData.reduce(function (result, current) {
                if (typeof current[target] === 'undefined')
                    current[target] = "All";

                result[current[target]] = result[current[target]] || [];
                result[current[target]].push(current);
                return result;
            }, {});
        }

        // 두 날짜 사이의 일수, 월수, 년수 구하기
        function getMonthBetweenDate(strDate, endDate) {
            let date1 = new Date(
                parseInt(strDate.substr(0, 4)),
                parseInt(strDate.substr(5, 2)) - 1,
                parseInt(strDate.substr(8, 2))
            )
            let date2 = new Date(
                parseInt(endDate.substr(0, 4)),
                parseInt(endDate.substr(5, 2)) - 1,
                parseInt(endDate.substr(8, 2))
            )
            const interval = date2 - date1;
            const day = 1000 * 60 * 60 * 24;
            const month = day * 30;
            const year = month * 12;

            const intervalDay = parseInt(interval / day);
            const intervalMonth = parseInt(interval / month);
            const intervalYear = parseInt(interval / year);

            // console.log("기간 날짜수: " + intervalDay + "일");
            // console.log("기간 개월수: 약 " + intervalMonth + "개월");
            // console.log("기간 개년수: 약 " + intervalYear + "년");

            return intervalMonth;
        }

        function jsonToArray(jsonData, dataSize) {
            let resultArray = []
            for (let i = 0; i < dataSize; i++) {
                resultArray[Object.keys(jsonData)[i]] = jsonData[Object.keys(jsonData)[i]]
            }
            return resultArray;
        }

    </script>
</head>
<body>
<%-- 사용자 접속현황 상세화면 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/device/deviceUserAccessListDialog.jsp" %>
<!-- 사용자 상세정보 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserDetailDialog.jsp" %>
<!-- 본문 -->
<div id="miaps-container">
    <div id="miaps-header">
        <%@ include file="/WEB-INF/jsp/include/header.jsp" %>
    </div>
    <div id="miaps-sidebar">
        <%@ include file="/WEB-INF/jsp/include/left.jsp" %>
    </div>
    <div id="miaps-content" class="content-main">
        <div class="searchForm">
            search
        </div>
        <div class="main-view">
            main view
            <div id="chart"></div>
        </div>
    </div>
    <!-- footer -->
    <div id="miaps-footer">
        <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    </div>
</div>
</body>
</html>
