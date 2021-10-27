package com.mink.connectors.mdtpcar.controller.intro;


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

import com.mink.connectors.mdtpcar.common.BaseMan;


@Controller
@RequestMapping("/mdtpcar/intro")
public class IntroMainController extends BaseMan {
	
	private static Logger logger = LoggerFactory.getLogger(IntroMainController.class);
	
	@RequestMapping(value="/main", method=RequestMethod.GET)
	public ModelAndView introMain(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String pwd = "";
		String userId = "";
		
		userId = request.getParameter("userId");
		pwd = request.getParameter("pwd");
		
		try {
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("id", userId);
			
			/* service call logic */ 
			userId = ((IntroTestService) getBean("intro.IntroTestService")).selectGetUser(paramMap);
			
			logger.debug("userId=========> : " + userId);
			
		}catch (Exception e) {
			logger.debug("db error ===============>" + e.getMessage());
		}
		
		ModelAndView mv = new ModelAndView("/mdtpcar/intro/main");
		mv.addObject("userId", userId);
		mv.addObject("pwd", pwd);
		
		
		logger.debug(" IntroMainController ==============@@@@@@@@@@@@@@@@===> main" );
		return mv;
	}
	
	@RequestMapping(value="/login", method=RequestMethod.GET)
	public ModelAndView login(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView("/mdtpcar/intro/main");
		
		logger.debug(" IntroMainController ==============> login" );
		
		return mv;
	}
	
}