package com.mink.connectors.cjlogistics.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;


@Controller
public class fileUpload {
	
	private static Logger logger = LoggerFactory.getLogger(fileUpload.class);
	
	@RequestMapping(value="/cj/fileUploadView.mdtp")
	public ModelAndView fileUploadView(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView("cj/fileUploadCamera");
		
		logger.debug("### {}.fileUploadView() End ###", this.getClass().getName());
		
		return mv;
	}
}
