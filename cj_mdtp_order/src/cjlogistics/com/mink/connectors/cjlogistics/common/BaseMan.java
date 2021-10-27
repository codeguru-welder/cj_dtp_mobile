package com.mink.connectors.cjlogistics.common;

import com.thinkm.mink.commons.util.ApplicationContextUtil;

public class BaseMan {
	
	public Object getBean(String beanName) {
		Object ob = ApplicationContextUtil.getBean(beanName);
		return ob;
	}
}
