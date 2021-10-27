// 달력 한글화
$.datepicker.regional['en']= {
		 closeText:'Close',
		 prevText:'Prev',
		 nextText:'Next',
		 currentText:'Today',
		 monthNames:['January','Feburary','March','April','May','June','July','August','September)','October','November','December'],
		 monthNamesShort:['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'],
		 dayNames:['Su','Mo','Tu','We','Th','Fr','Sa'],
		 dayNamesShort:['Su','Mo','Tu','We','Th','Fr','Sa'],
		 dayNamesMin:['Su','Mo','Tu','We','Th','Fr','Sa'],
		 weekHeader:'Wk',
		 dateFormat:'yy-mm-dd',
		 format:'yy-mm-dd',
		 firstDay:0,
		 isRTL:false,
		 showMonthAfterYear:false,
		 yearSuffix:''
};
$.datepicker.setDefaults($.datepicker.regional['en']);