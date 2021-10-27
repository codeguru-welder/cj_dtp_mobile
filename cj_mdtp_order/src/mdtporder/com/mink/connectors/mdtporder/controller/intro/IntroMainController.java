package com.mink.connectors.mdtporder.controller.intro;


import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.mink.connectors.mdtporder.common.BaseMan;


@Controller
@RequestMapping("/mdtporder/intro")
public class IntroMainController extends BaseMan {
	
	private static Logger logger = LoggerFactory.getLogger(IntroMainController.class);
	
	@RequestMapping(value="/main", method=RequestMethod.GET)
	public ModelAndView introMain(HttpServletRequest request, HttpServletResponse response) throws Exception {	
					
		String userId = ""; 
		
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("id", userId);
			
		/* service call logic  extends BaseMan */ 
		userId = ((IntroTestService) getBean("intro.IntroTestService")).selectGetUser(paramMap);
		
		ModelAndView mv = new ModelAndView("/mdtporder/intro/main");
		
		logger.debug(" IntroMainController ==============> main" );
		return mv;
	}
	
	@RequestMapping(value="/login", method=RequestMethod.GET)
	public ModelAndView login(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView("/mdtporder/intro/main");
		
		logger.debug(" IntroMainController ==============> login" );
		
		return mv;
	}
	
}