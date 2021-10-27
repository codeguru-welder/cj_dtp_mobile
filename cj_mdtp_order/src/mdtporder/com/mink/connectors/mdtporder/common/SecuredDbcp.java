package com.mink.connectors.mdtporder.common;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.thinkm.mink.commons.encryption.AESCipher;


/**
 * 데이터베이스 비밀번호 보안.md 파일 참조
 * @author thinkm
 *
 */
public class SecuredDbcp {
	
	private static String BASE64_PATTERN = "^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$";
	private static String _k = "thinkmisthebestm"; //aes128, 16bit
	
	public String getUsername(String username) throws Exception {
		String decUsername = username;
		if (decUsername != null) {
			Pattern pattern = Pattern.compile(BASE64_PATTERN);
			Matcher matcher = pattern.matcher(decUsername);
			
			if (matcher.matches()) {
				return AESCipher.decrypt(decUsername, _k);
			} else {
				return decUsername;
			}
		}
		return decUsername;
	}

	public String getPassword(String password) throws Exception {
		String decPassword = password;
		if (decPassword != null) {
			Pattern pattern = Pattern.compile(BASE64_PATTERN);
			Matcher matcher = pattern.matcher(decPassword);
			
			if (matcher.matches()) {
				return AESCipher.decrypt(decPassword, _k);
			} else {
				return decPassword;
			}
		}
		return decPassword;
	}
}
