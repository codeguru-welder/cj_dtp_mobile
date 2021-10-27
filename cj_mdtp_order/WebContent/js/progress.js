/*
 작업처리중 팝업 화면을 열고 / 닫는 로직 구현 

 ********jsp에 아래 스크립트 추가
 <script LANGUAGE="JavaScript" src="/script/progress.js"></script>
 
 ******** 폼을 iframe에 서브밋 할때 호출(프로그래스바 보이기 시작)
 openWindow();

 ******** iframe에서 작업 끝내고 호출(프로그래스바 죽이기)
 closeWindow();
*/

var progressWindow = null; // 작업중 화면 reference 
 
document.onfocusin = getProgressFocusAgain;
	
function getProgressFocusAgain() 
{    
	try{
		if(progressWindow != null )
		{  
			if( document.hasFocus() && !(progressWindow.document.hasFocus()))  
			{
		  		progressWindow.focus();	  
			} 
		}
	}catch(e){}
}  
	
function progress_viewMessage() 
{ 
	//닫기버튼을 사용하지 못하게 할때 사용.
   //alert('닫기 버튼을 누르지마십시요') ;
   //progress_openWindow();  
   progressWindow = null;

}

 /**
 * @type   : function
 * @access : public
 * @desc   : 작업중 윈도우 표시  
 * @author : 최의엽
 * @modify : 
 */ 
function progress_openWindow() {
	 if(jQuery.browser.msie) {	// IE환경에서만 사용
		 var width = 350;
		 var height = 150;
		 var opt = "dialogWidth:270px;dialogHeight:135px;center:yes;dialogHide:yes;help:off;resizable:no;scroll:no;status:no;edge:sunken";

//		 progressWindow = window.showModelessDialog("progress.htm", window, opt );
		 	progressWindow = window.showModelessDialog("progress.jsp", window, opt );
//		 	progressWindow = window.open("progress.htm","","width=150,height=150, menubar=no");
	 }
}

 /**
 * @type   : function
 * @access : public
 * @desc   : 작업중 윈도우 종료  
 * @author : 최의엽
 * @modify : 
 */ 

function progress_closeWindow() 
{  
    try 
    {     
    	if( progressWindow != null ){
    		progressWindow.selfClose();
        	progressWindow = null;
    	}	
    }
    catch( Exception )
    { 
        // 윈도우가 이미 닫힌 경우 그냥 무시한다. 	    	 
    }
}
