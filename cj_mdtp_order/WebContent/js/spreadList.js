/**
 * 더보기 목록
 * @author eunkyu
 * @since 2014.04.04
 */
// 펼쳐진 목록 숨기기/보이기
var spreadListObject = {
		'tbodyId':'spreadListTbody' // 목록 tbody
		, 'showSpanId':'spreadListShowSpan' // 펼침 버튼 span
		, 'hiddenSpanId':'spreadListHiddenSpan' // 숨김 버튼 span
		, 'defaultShowIndex':5 // 한번에 몇 개씩 보여줄 개수
		, 'set':function(tbodyId, showSpanId, hiddenSpanId){ // 변수 세팅
			spreadListObject.set2(tbodyId, showSpanId, hiddenSpanId, spreadListObject.defaultShowIndex);
		}
		, 'set2':function(tbodyId, showSpanId, hiddenSpanId, defaultShowIndex){  // 변수 세팅
			spreadListObject.tbodyId = tbodyId;
			spreadListObject.showSpanId = showSpanId;
			spreadListObject.hiddenSpanId = hiddenSpanId;
			spreadListObject.defaultShowIndex = defaultShowIndex;
		}
		, 'show':function(){ // 펼침
			var hiddenIndex = 0;
			$("#"+spreadListObject.tbodyId).find("tr").each(function(i, tr){
				if($(tr).is(":hidden")) {
					if(0 < spreadListObject.defaultShowIndex - hiddenIndex) $(tr).show();
					hiddenIndex += 1;
				}
			});
			if(0 < hiddenIndex) $("#"+spreadListObject.hiddenSpanId).show();
			if(hiddenIndex < spreadListObject.defaultShowIndex) $("#"+spreadListObject.showSpanId).hide();
		}
		, 'hidden':function(){ // 숨김
			var $tbodyTrs = $("#"+spreadListObject.tbodyId).find("tr");
			if(spreadListObject.defaultShowIndex < $tbodyTrs.length) {
				$tbodyTrs.hide();
				$tbodyTrs.each(function(i, tr){
					if(i < spreadListObject.defaultShowIndex) $(tr).show();
				});
				$("#"+spreadListObject.showSpanId).show();
				$("#"+spreadListObject.hiddenSpanId).hide();
			}
		}
};