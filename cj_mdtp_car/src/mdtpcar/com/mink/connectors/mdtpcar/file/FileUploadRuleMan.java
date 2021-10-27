package com.mink.connectors.mdtpcar.file;

import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.thinkm.mink.commons.web.MultipartFormData;
import com.thinkm.mink.commons.web.UploadedFileSaveRule;

/**
 * '파일업로드 저장규칙' 구현 클래스(UploadedFileSaveRule)
 */
@Service("uploadedFileSaveRule")
public class FileUploadRuleMan implements UploadedFileSaveRule {
	private Logger log = LoggerFactory.getLogger(FileUploadRuleMan.class);

	
	@Override
	public boolean saveFileByRule(MultipartFormData multipartFormData) throws Exception {
		
		Map<String, Object> params = multipartFormData.getParameters();
		
		//Set<String> mapKey = (Set<String>) params.keySet();
		
		//if (this.log.isInfoEnabled()) {
			logParams(multipartFormData.getParameters(), "All Parameters");
			logParams(multipartFormData.getFileParameters(), "File Parameters");
		//}
		
		//multipartFormData.setFileParam("file0", "chlee");
		
		logParams(multipartFormData.getParameters(), "All Parameters");
		logParams(multipartFormData.getFileParameters(), "File Parameters");
			
		//return true;  // 임시파일 삭제
		return false;	// 임시파일 삭제 안함.
		
	}
	
	private void logParams(Map<String, Object> params, String paramType) {
		StringBuilder sb = new StringBuilder("== " + paramType + " infos ==\n");

		Iterator<String> iter = null;
		String name = null;
		Object value = null;

		iter = params.keySet().iterator();
		while (iter.hasNext()) {
			name = iter.next();
			value = params.get(name);
			if (value instanceof String) {
				sb.append(name + " = " + value + "\n");
			} else if (value instanceof String[]) {
				sb.append(name + " = ");
				String[] values = (String[]) value;
				for (int i = 0; i < values.length; i++) {
					if (i > 0) {
						sb.append(", ");
					}
					sb.append(values[i]);
				}
				sb.append("\n");
			} else {
				sb.append(name + " = " + value.toString() + "\n");
			}
		}

		this.log.info(sb.toString());
	}

}
