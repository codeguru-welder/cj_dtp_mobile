require(["jquery", "miaps", 
         "text!templates/query/create_table_ex.sql", 
         "text!templates/query/insert_ex.sql",
         "text!templates/query/insert_multi_ex.sql",
         "text!templates/query/select_ex.sql",
         "text!templates/query/deleteall_ex.sql",
         "bootstrap"
], function($, miaps, _create_table, _insert, _insertmulti, _select, _deleteall) {
	
	var g_mode = "";
	
	$(function() {	
		$("#btnRun").on("click", runMyQuery);
		$("#btnCreateTable").on("click", pasteCreateTable);
		$("#btnInsert").on("click", pasteInsert);
		$("#btnMultiInsert").on("click", pasteMultiInsert);		
		$("#btnSelect").on("click", pasteSelect);
		$("#btnDeleteAll").on("click", pasteDeleteAll);		
		
		$("#btnBack").on("click", function() {window.history.back();});
		$("#runQuery").on("mouseup", textareaResize);
		$("#runQuery").on("keyup", textareaResize);
		
		// 로딩중 숨김
		$('#lastPostsLoader').hide();
		
		$("#runQuery").val("");
		$("#runQuery").val("SELECT user_no, user_id, user_nm FROM miaps_user");
		// frm.find("textarea[name='appDesc']").val(result.appDesc);
	});
	
	function pasteCreateTable() {
		console.log(_create_table);
		$("#runQuery").val("");
		$("#runQuery").val(_create_table);
	}
	
	function pasteInsert() {
		console.log(_insert);
		$("#runQuery").val("");
		$("#runQuery").val(_insert);
	}
	
	function pasteMultiInsert() {
		console.log(_insertmulti);
		$("#runQuery").val("");
		$("#runQuery").val(_insertmulti);
	}
	
	function pasteSelect() {
		console.log(_select);
		$("#runQuery").val("");
		$("#runQuery").val(_select);
	}
	
	function pasteDeleteAll() {
		console.log(_deleteall);
		$("#runQuery").val("");
		$("#runQuery").val(_deleteall);
	}
	
	//목록검색
	function runMyQuery() {
		
		miaps.cursor('iconQuery', 'wait');
		
		var mode = $("#mode").val();
		var db = $("#db").val();
		var query = $("#runQuery").val();
		
		if (db == null || db == '') {
			alert("DB명을 입력 해 주세요.");
			return;
		}
		
		g_mode = mode;
			
		miaps.querySvc(mode, db, query, "_cb.cbGetResult", _cb.cbGetResult);
	}

	function textareaResize() {
		//console.log(obj);
		$("#runQuery").css("height", "1px");
		$("#runQuery").css("height", (20 + $("#runQuery").prop("scrollHeight") + "px"));
	}
	
	/* ---- callback function ---- */
	var callback = {
			
		cbGetResult : function (data) {
			miaps.cursor('iconQuery', 'default');
			
			console.log(data);
			var obj = miaps.parse(data);
			console.log(obj);
			
			if(obj.code != 200) {
				alert(obj.msg);
				return;
			}
			
			if (g_mode == 'select') {			
				var out = [];
				
				var parent = $("#listUl");
				parent.children('#result-table').remove();
					
				out.push("<table id='result-table' class='table'>");
				//make columns
				if (obj != null && obj.res.length > 0) {
					var dto = obj.res[0];
					var columns = Object.keys(dto);
					
					var tr = "<thead><tr>";
					for(var i = 0; i < columns.length; i++) {
						tr += "<th>" + columns[i] + "</th>";
					}	
					out.push(tr + "</tr></thead>");				
				}
				
				// make data rows
				var tr = "<tbody>";
				if (obj != null && obj.res.length > 0) {
					for (i = 0; i < obj.res.length; i++) {			
						tr = "<tr>";			
						for(var key in obj.res[i]) {
							//console.log('key:' + key + ' / ' + 'value:' + obj.results[i][key]);
							tr += "<td>" + obj.res[i][key] + "</td>";
						}
						out.push(tr + "</tr>");
					}
				}
				out.push("</tbody></table>");
					
				$('#listUl').append(out.join('')); //.listview('refresh');
					
				/* 붙여넣기 후 리스트 스크롤 */
				//$('body,html').animate({scrollTop: $("#sc"+paste_id).offset().top}, 500);
			} else { // execute
				alert("code: " + obj.code + ", res: " + obj.res);
			}
		}
	};
	window._cb = callback;
	
});