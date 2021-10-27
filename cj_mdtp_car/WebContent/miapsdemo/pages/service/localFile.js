require(["jquery", 
         "underscore",
         "handlebars",
		 "miaps", 
		 "miapspage",
		 "bootstrap",
		 "moment"		 
         ], function($, _, handlebars, miaps, miapspage, moment) {

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
	
	var source = $('#display-template').html();
	var tempTemplate = handlebars.compile(source);
	
	const ResourceRoot = "${ResourceRoot}";
	var appid;
	
	// 앱 패키지명
	miaps.mobile({
		type: 'appid',
		param: ''
	}, function(data){
		var obj = miaps.parse(data);
		appid = obj.res;
	});
	
	filelist(ResourceRoot);
	
	function filelist(fileListPath) {
		var config = {
			type: "FILELIST",
			param: {	
				// 상대경로 (Android, iOS는 앱의 프로젝트 폴더가 기준경로입니다.)
				path: fileListPath
				// Android외부저장소의 경우
				//path: "${ExternalRoot}/Download"
			}
		};
		miaps.mobile(config, function(data){
		
			var obj = miaps.parse(data);
			console.log(obj);
			
			var listFullPath;
			
			// 현재 폴더위치 찾기 시작
			// (첫 filelist 호출일 경우 ResourceRoot로 앱 프로젝트 경로를 가져오기때문에 결과값에서 수기로 추출)
			if(fileListPath == ResourceRoot){
				var origin = obj.res[0].fullpath;
				var splitOrigin = origin.split("/");
				var arrLength = splitOrigin.length;
				var arrFileName = splitOrigin[arrLength-1];
				listFullPath = origin.substr(0, origin.length - arrFileName.length - 1);
			}else{
				listFullPath = fileListPath;
			}
			
			obj.fullpath = listFullPath;
			// 현재 폴더위치 찾기 끝
			
			var moment = require('moment');
			
			for(var i in obj.res){
				// 파일 수정날짜 포맷
				var qdate = moment(obj.res[i].date.substr(0,7)).format('YYYY년 MM월 DD일 ');
				var qtime = obj.res[i].date.substr(8,2) + ':' + obj.res[i].date.substr(10,2);
				obj.res[i].date = qdate + qtime;
				
				// 파일사이즈 포맷
				obj.res[i].size = formatByteSizeString(obj.res[i].size, 2);
				
				// directory 여부에 따른 아이콘 변경
				if(obj.res[i].isdir == 'Y') obj.res[i].imgsrc = '/miapsdemo/resource/img/icon03.png';
				else obj.res[i].imgsrc = '/miapsdemo/resource/img/icon02.png';
			}
			
			// 파일 이름순으로 정렬
			obj.res.sort(function(a, b){
				return a.filename < b.filename ? -1 : a.filename > b.filename ? 1 : 0;
			});
			
			// 폴더인 경우 위로 정렬
			obj.res.sort(function(a, b){
				return a.isdir > b.isdir ? -1 : a.isdir < b.isdir ? 1 : 0;
			});
			
			// 상위폴더로 가기 추가 시작
			var upfolderLastSlash = listFullPath.lastIndexOf('/');
			var upfolderPath = listFullPath.substr(0, upfolderLastSlash);
			
			// 현재 폴더 경로가 패키지네임과 일치할 경우엔 상위폴더 이동 기능X
			if(listFullPath.split('/').reverse()[0] != appid){
				obj.res.splice(0, 0, {
					fullpath: upfolderPath,
					filename:"상위폴더로",
					size:"",
					date:"",
					isdir:"Y",
					imgsrc: "/miapsdemo/resource/img/img_layer_arrow.png"
				});
			}
			// 상위폴더로 가기 추가 끝
			
			$("#contents-list *").remove();
			$("#contents-list").append(tempTemplate(obj));
		});
	}
	
	/**
	 * byte 용량을 환산하여 반환
	 * 용량의 크기에 따라 MB, KB, byte 단위로 환산함
	 * @param bytes  		byte 값
	 * @param decimals     	환산된 용량의 소수점 자릿수
	 * @returns {String}
	 */
	function formatByteSizeString(bytes, decimals = 2) {
		if (bytes == 0) {
			return '0 Byte';
		}
		const k = 1000;
		const dm = decimals;
		const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
		const i = Math.floor(Math.log(bytes) / Math.log(k));
		return `${parseFloat((bytes / Math.pow(k, i)).toFixed(dm))} ${sizes[i]}`;
	}
	
	// miapsPage.openPopup을 사용하는 부모페이지에서 정의돼야 오류메시지가 안뜸
	window.miapsOnPopupReceive = function() {
	}
	
	var localFile = {
		/**
		 * 지정한 파일의 내용을 취득
		 * txt,jpg,jpeg,png,gif파일만 지원합니다.
		 * @param isdir  		디렉토리 여부 (Y,N)
		 * @param fullpath     	파일의 절대경로
		 */
		filecontents : function(isdir, fullpath){
			// 디렉토리의 경우 해당 경로로 리스트 재생성
			if(isdir == 'Y'){
				filelist(fullpath);
			}else{
				var config = {
					type: "filecontents",
					param: {
						// 절대경로
						path: fullpath
						// 상대경로 (Android, iOS는 앱의 프로젝트 폴더가 기준경로입니다.)
						//path: "${ResourceRoot}\\res"
					}
				};
				miaps.mobile(config, function(data){
					var obj = miaps.parse(data);
					if(obj.code == '200'){
						var lastDot = fullpath.lastIndexOf(".");
						var format = fullpath.substring(lastDot + 1, fullpath.length).toLowerCase();
						
						var result = {};
						
						if(format == 'txt'){	// 텍스트
							result.type = 'txt';
							result.res = obj.res;
						}else{	// 이미지 파일
							result.type = 'image';
							result.res = obj.res.src;
						}
						miapsPage.openPopup('pages/service/localFileContents.html', result);
					}else{
						alert(obj.msg);
					}
					
					console.log(obj);
				});
			}
		}
	}
	window.localFile = localFile;
});