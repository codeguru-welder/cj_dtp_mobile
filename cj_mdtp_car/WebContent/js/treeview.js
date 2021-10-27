/**
 * treeview
 * @author eunkyu
 * @since 2014.04.04
 * 
 * url: '../user/userGroupListTreeview.miaps?'(Child Node), '../user/userGroupListTreeviewAllNode.miaps?'(All Node, 모두 펼쳐진 상태)
 * ulId: '#sample' <ur id="sample"> treeview 타겟ID(# 필수)
 * node: 'a/span' a link 노드/span 노드 선택(span 노드는 클릭시 하위노드 토글기능이 기본기능임)
 * checkbox: true/false checkbox 사용여부
 * chainReaction: true/false checkbox 사용시, 노드를 클릭하면 checkbox checked 기능여부
 * callbackFn: 노드 클릭시 이벤트 함수(원하는 기능)
 */
function treeview(url, ulId, node, checkbox, chainReaction, callbackFn) {
	$(ulId).treeview({
		url: url // Get ajax json
		, animated: "fast" //  Sets the animation speed.(slow, normal, fast)
		, collapsed: true // Sets whether all nodes should be collapsed by default.
		//, unique: true
		, persist: "location" // Persists the tree's expand/collapse state in one of two ways: 1. "location", 2. "cookie"
		//, persist: "cookie"
		//, cookieId: "rememberme"
		//, control: controlId // Collapse All, Expand All, Expand All, *Checked All, *Checked Sub All,  *Checked OnlyOne // *<==custom control
		/* ** custom options ** */
		, node: node //  Sets the node type.(span, a)
		, checkbox: checkbox // Use checkbox?
		, chainReaction: chainReaction // click node, check checkbox?
		, callbackFn: callbackFn // click node, callback function
	});
}

// jquery.treeview.async.js ==> a link href='return false'
function returnFalseAlink() {
	return;
}

// 트리 완료 후 콜백 함수(jsp 페이지에 따로 구현 필요)
// 2015.02.01 이 함수를 삭제 하지 않으니 따로 구현한 completeTreeview가 호출되지 않아 삭제함.
//function completeTreeview(treeview) {
//
//}

/* 커스텀 treeview
 * - 노드는 a link 임. 노드 클릭시 callbackFn 함수 동작.
 * 
 * url: '../user/userGroupListTreeview.miaps?'(Child Node), '../user/userGroupListTreeviewAllNode.miaps?'(All Node, 모두 펼쳐진 상태)
 * ulId: '#ulId' <ur id="uild"> treeview 타겟ID(# 필수)
 * callbackFn: a link 노드 클릭시 이벤트 함수(원하는 기능)
*/
// 트리뷰 node = alink
function treeviewAlink(url, ulId, callbackFn) {
	treeview(url, ulId, 'a', false, false, callbackFn);
}

/* 커스텀 treeview
 * - checkbox 있음. 노드는 a link 임. 노드 클릭시 checkbox checked 동작.
 * 
 * url: '../user/userGroupListTreeview.miaps?'(Child Node), '../user/userGroupListTreeviewAllNode.miaps?'(All Node, 모두 펼쳐진 상태)
 * ulId: '#ulId' <ur id="uild"> treeview 타겟ID(# 필수)
*/
// 트리뷰 node = alink, checkbox = true, chainReaction = true
function treeviewAlinkCheckbox(url, ulId) {
	treeview(url, ulId, 'a', true, true, null);
}

// 트리뷰 node = span, checkbox = true, chainReaction = true
function treeviewSpanCheckbox(url, ulId) {
	treeview(url, ulId, 'span', true, true, null);
}

// treeview ul 초기화(삭제) 후 체크박스 있는 treeview 불러오기
function treeviewAlinkCheckboxAfterReset(url, ulId, parentElement) {
	$(ulId).remove();
	$(parentElement).append("<ul id="+ ulId.substring(1) +" class='treeview'></ul>");
	
	treeview(url, ulId, 'a', true, true, null);
}