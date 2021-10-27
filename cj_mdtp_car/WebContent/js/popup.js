
var popupStatus = 0;

function loadPopup(lo){
	//loads popup only if it is disabled
	if(lo==1){
		if(popupStatus==0){
			$("#grpBackground").css({
				"opacity": "0.7"
			});
			$("#grpBackground").fadeIn("slow");
			$("#popupGrp").fadeIn("slow");
			popupStatus = 1;
		}
	}

	if(lo==2){
		if(popupStatus==0){
			$("#userBackground").css({
				"opacity": "0.7"
			});
			$("#userBackground").fadeIn("slow");
			$("#popupUser").fadeIn("slow");
			popupStatus = 1;
		}
	}

	if(lo==3){
		if(popupStatus==0){
			$("#devBackground").css({
				"opacity": "0.7"
			});
			$("#devBackground").fadeIn("slow");
			$("#popupDev").fadeIn("slow");
			popupStatus = 1;
		}
	}
}

function disablePopup(di){
	//disables popup only if it is enabled
	if(di==1){
		if(popupStatus==1){
			$("#grpBackground").fadeOut("slow");
			$("#popupGrp").fadeOut("slow");
			popupStatus = 0;
		}
	}

	if(di==2){
		if(popupStatus==1){
			$("#userBackground").fadeOut("slow");
			$("#popupUser").fadeOut("slow");
			popupStatus = 0;
		}
	}

	if(di==3){
		if(popupStatus==1){
			$("#devBackground").fadeOut("slow");
			$("#popupDev").fadeOut("slow");
			popupStatus = 0;
		}
	}
}

//centering popup
function centerPopup(num){
	//request data for centering
	var windowWidth = document.documentElement.clientWidth;
	var windowHeight = document.documentElement.clientHeight;
	if(num==1){
		var popupHeight = $("#popupGrp").height();
		var popupWidth = $("#popupGrp").width();
		//centering
		$("#popupGrp").css({
			"position": "absolute",
			"top": windowHeight/2-popupHeight/2,
			"left": windowWidth/2-popupWidth/2
		});
		//only need force for IE6
		$("#grpBackground").css({
			"height": windowHeight
		});
	}
		
	if(num==2){
		var popupHeight = $("#popupUser").height();
		var popupWidth = $("#popupUser").width();
		//centering
		$("#popupUser").css({
			"position": "absolute",
			"top": windowHeight/2-popupHeight/2,
			"left": windowWidth/2-popupWidth/2
		});
		//only need force for IE6
		$("#userBackground").css({
			"height": windowHeight
		});
	}

	if(num==3){
		var popupHeight = $("#popupDev").height();
		var popupWidth = $("#popupDev").width();
		//centering
		$("#popupDev").css({
			"position": "absolute",
			"top": windowHeight/2-popupHeight/2,
			"left": windowWidth/2-popupWidth/2
		});
		//only need force for IE6
		$("#devBackground").css({
			"height": windowHeight
		});
	}
}

//CONTROLLING EVENTS IN jQuery
$(document).ready(function(){

	//LOADING POPUP
	//Click the button event!
	$("#pushGrpbutton").click(function(){
		//centering with css
		centerPopup(1);
		//load popup
		loadPopup(1);
	});

	$("#pushUserbutton").click(function(){
		//centering with css
		centerPopup(2);
		//load popup
		loadPopup(2);
	});

	$("#pushDevbutton").click(function(){
		//centering with css
		centerPopup(3);
		//load popup
		loadPopup(3);
	});

	//CLOSING POPUP
	//Click the x event!
	$("#popupGrpClose").click(function(){
		disablePopup(1);
	});

	$("#popupUserClose").click(function(){
		disablePopup(2);
	});

	$("#popupDevClose").click(function(){
		disablePopup(3);
	});
	//Click out event!
	//$("#backgroundPopup").click(function(){
		//disablePopup();
	//});

	//Press Escape event!
	$(document).keypress(function(e){
		if(e.keyCode==27 && popupStatus==1){
			disablePopup();
			userdisablePopup();
		}
	});

});