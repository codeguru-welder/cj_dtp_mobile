package com.mink.connectors.hybridtest.login;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import com.thinkm.mink.asvc.dto.User;
import com.thinkm.mink.commons.login.LegacyLogin;

@Service("extLoginService")
public class ExtLoginService implements LegacyLogin {

	@Override
	public User login(HttpServletRequest request) {
		// TODO Auto-generated method stub
		return null;	
	}

	@Override
	public User login(User param) {
		// TODO Auto-generated method stub
		return null;
	}
}