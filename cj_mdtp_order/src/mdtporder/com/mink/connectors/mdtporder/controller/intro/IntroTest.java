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
import com.mink.connectors.mdtporder.controller.fileUpload;

@Controller
public class IntroTest extends BaseMan {
	

	private static Logger logger = LoggerFactory.getLogger(fileUpload.class);
	
	@RequestMapping(value="/main", method=RequestMethod.GET)
	public ModelAndView intro(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String pwd = "";
		String userId = "";
		
		userId = request.getParameter("userId");
		pwd = request.getParameter("pwd");
		
		
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("id", userId);
			
		/* service call logic */ 
		userId = ((IntroTestService) getBean("intro.IntroTestService")).selectGetUser(paramMap);
			
		logger.debug("userId=========> : " + userId);
		
		
		ModelAndView mv = new ModelAndView("mdtporder/test-ajax");
		mv.addObject("userId", userId);
		mv.addObject("pwd", pwd);
		
		logger.debug("### {}.intro() End ###", this.getClass().getName());
		
		return mv;
	}
	
}
