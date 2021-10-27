package com.mink.connectors.mdtpcar.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.apache.commons.lang3.StringUtils;


@Controller
public class fileUpload {
	
	private static Logger logger = LoggerFactory.getLogger(fileUpload.class);
	
	@RequestMapping(value="/mdtpcar/fileUplaodCamera")
	public ModelAndView fileUploadView(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView("mdtpcar/main");
		
		logger.debug("### {}.fileUploadView() End ###", this.getClass().getName());
		
		return mv;
	}
	
	/**
	 * 모바일 Intro page 최초작성 by codeguru 21/10/20
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/mdtpcar/main")
	public ModelAndView intro(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView("mdtpcar/main");
		
		logger.debug("### mobile main page  ###", this.getClass().getName());
		
		return mv;
	}
	
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/mdtpcar/egovSampleList")
	public ModelAndView egovSampleList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView("mdtp/egovSampleList");
		
		logger.debug("### mobile intro page  ###", this.getClass().getName());
		
		return mv;
	}
	
	
	@RequestMapping(value="/mdtpcar/test-ajax")
	public ModelAndView testAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView("mdtpcar/test-ajax");
		
		logger.debug("### mobile test-ajax page  ###", this.getClass().getName());
		
		return mv;
	}
	

}
