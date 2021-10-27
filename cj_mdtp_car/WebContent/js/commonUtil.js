// 비동기 통신 namespace 선언
AsyncComm = {};

// 비동기 통신 facade 함수
AsyncComm.ajax = function (pstrUrl, pjsonParam, pblnAsync, pfnResultHandler, pfnErrorHandler) {
	var requestParam = {  type : "post"
		, contentType : 'application/x-www-form-urlencoded'
		, data : { param : encodeURIComponent(jQuery.toJSON(pjsonParam))}
		, dataType : "json"
		, async : pblnAsync
		, success : fnResultHandler
		, error : fnErrorHandler
		};	// ajax 파라미터

	jQuery.ajax(pstrUrl, requestParam);

	// 처리결과 후 실행 핸들러처리
	function fnResultHandler(retData, textStatus, jqXHR) {
		if(typeof(pfnResultHandler) == "undefined") {
			if(typeof(progress_closeWindow) == "function") {
				progress_closeWindow();
			}

			alert(textStatus);
		} else {
			pfnResultHandler(retData, textStatus, jqXHR);
		}
	}

	// 오류 후 실행 핸들러처리
	function fnErrorHandler(jqXHR, textStatus, errorThrown) {
		if(typeof(pfnErrorHandler) == "undefined") {
			if(typeof(progress_closeWindow) == "function") {
				progress_closeWindow();
			}

			alert(textStatus);
		} else {
			pfnErrorHandler(jqXHR, textStatus, errorThrown);
		}
	}
};

// 지정된 태그아이디에 포함되는 태그들의 json 키 값과 id 값에 맞춰 값을 세트
// [{key:keyVal_1, value:valueVal_1}, {key:keyVal_2, value:valueVal_2}, ..., {key:keyVal_n, value:valueVal_n}]
function distributeInfo(pTarget, pjsonData) {
	var jobjSource = null;
	var jsonSourceDataItem = { };	// key, value
	var jobjTarget = null;

	switch(typeof(pTarget)) {
		case "object" :
			jobjSource = pTarget;

			break;
		case "string" :
			jobjSource = jQuery("#" + pTarget);

			break;
		default :
			return;
			break;
	}

	for(var i = 0; i < pjsonData.length; i++) {
		jsonSourceDataItem = pjsonData[i];

		// text, hidden, image, password
		jobjTarget = jobjSource.find("input[id='" + jsonSourceDataItem.key + "']");

		if(jobjTarget.length == 1) {
			if(jQuery(jobjTarget).attr("type") == "text"
				|| jQuery(jobjTarget).attr("type") == "hidden") {
				jobjSource.find("input[id='" + jsonSourceDataItem.key +"']").val(jsonSourceDataItem.value);

				continue;
			}
		} else if (jobjTarget.length > 1) {
			for(var j = 0; j < jobjTarget.length; j++) {
				if(jQuery(jobjTarget[j]).attr("type") == "text"
					|| jQuery(jobjTarget[j]).attr("type") == "hidden") {
					jobjSource.find("input[id='" + jsonSourceDataItem.key +"']:eq(" + j + ")").val(jsonSourceDataItem.value);

					continue;
				}
			}
		}

		// radio, checkbox
		jobjTarget = jobjSource.find("input[id^='" + jsonSourceDataItem.key + "_']");

		if(jobjTarget.length > 0) {
			if(jQuery(jobjTarget[0]).attr("type") == "radio"
				|| jQuery(jobjTarget[0]).attr("type") == "checkbox") {
				jobjSource.find("input[id^='" + jsonSourceDataItem.key + "_'][value='" + jsonSourceDataItem.value + "']").attr("checked", "checked");

				continue;
			}
		}

		// textarea, select, span
		jobjTarget = jobjSource.find("select[id='" + jsonSourceDataItem.key + "']");

		if(jobjTarget.length == 1) {
			jobjTarget.find("option[value='" + jsonSourceDataItem.value + "']").attr("selected", "selected");

			continue;
		}

		jobjTarget = jobjSource.find("textarea[id='" + jsonSourceDataItem.key + "'], span[id='" + jsonSourceDataItem.key + "']");

		if(jobjTarget.length == 1) {
			jobjTarget.html(jsonSourceDataItem.value);

			continue;
		}
	}
}