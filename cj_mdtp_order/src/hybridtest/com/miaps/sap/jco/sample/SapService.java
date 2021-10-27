/**
 * Project : Mobile Office(Mink) Solution
 * 
 * Copyright 2009 by Solution Development Team, thinkM, Inc., All rights reserved.
 * This software is proprietary information
 * of thinkM, Inc. You shall not 
 * disclose such Confidential Information and shall use it 
 * only in accordance with the terms of the license agreement
 * you entered into with thinkM.
 */
package com.miaps.sap.jco.sample;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.miaps.sap.jco.ConncetorSapManager;
import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoMetaData;
import com.sap.conn.jco.JCoParameterFieldIterator;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoRecordFieldIterator;
import com.sap.conn.jco.JCoStructure;
import com.sap.conn.jco.JCoTable;
import com.thinkm.mink.commons.MinkTotalConstants;

/**
 * Sap 서비스
 * 
 * @version		2015.07.21
 * @author		thinkm(ek)
 */
@Service("sample.SapService")
public class SapService {
	private static final char FS = MinkTotalConstants.FS;
	private static final char RS = MinkTotalConstants.RS;

	private ConncetorSapManager sapMan = null;

	public ConncetorSapManager getSapMan() {
		return sapMan;
	}
	
	@Autowired
	ConncetorSapManager csm;

	//public void setSapMan(ConncetorSapManager sapMan) {
	public void setSapMan() {
		//this.sapMan = sapMan;
		this.sapMan = csm;
	}
	
	public Map<String, Object> execute(Map<String, String> params) throws Exception {
		return execute(params.remove("functionName"), params);
	}

	/**
	 * Sap 실행
	 * 
	 * @param functionName
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> execute(String functionName, Map<String, String> params) throws Exception {
		JCoFunction function = sapMan.getSAPJCoFunction(functionName);
		
		executeImport(function, params);
		
		sapMan.executeJCoFunction(function);
		
		return executeExport(function, params);
	}
	
	/**
	 * Sap Import
	 * 
	 * @param function
	 * @param params
	 */
	public void executeImport(JCoFunction function, Map<String, String> params) {
		JCoParameterList ipl = function.getImportParameterList();
		JCoParameterList tpl = function.getTableParameterList();
		
		// 사용하지 않을 시스템(예약) 파라메타 제거
		params.remove("uid");
		params.remove("cmd");	// select(query), execute(exec)
		params.remove("param");
		params.remove("mod");
		params.remove("cid");
		//params.remove("pos"); // 더보기용 페이징 시작 줄 정보
		params.remove("deviceid"); // 장치 번호 (miaps_device.device_id)
		params.remove("target"); // 업무명 (miaps_target_url.url_id)
		params.remove("userid"); // 사용자 ID (miaps_user.user_id)
		params.remove("version"); // 프로토콜 버전
		params.remove("userno"); // 사용자 번호 (miaps_user.user_no)
		params.remove("groupid"); // 그룹(조직) ID (miaps_user_group.grp_id)
		
		if (ipl != null) {
			JCoParameterFieldIterator pfi = ipl.getParameterFieldIterator();
			
			while (pfi.hasNextField()) {
				JCoField f = pfi.nextField();
				String name = f.getName();
				
				if (f.isStructure()) {
					// 1. structure 형식
					JCoStructure st = ipl.getStructure(name);
					
					String pValue = params.get(name);
					if (pValue != null) {
						List<Map<String, String>> pValues = convertListFromMiapsString(pValue);
						Map<String, String> pm = new HashMap<String, String>();
						if (pValues.size() > 0) pValues.get(0);
						
						for (String fn : pm.keySet()) {
							Object v = pm.get(fn);
							if (v != null) st.setValue(fn, v); // import
						}
					}
				} else if (f.isTable()) {
					// 2. table 형식
					JCoTable tb = ipl.getTable(name);
					
					String pValue = params.get(name);
					if (pValue != null) {
						List<Map<String, String>> pValues = convertListFromMiapsString(pValue);
						for (Map<String, String> pm : pValues) {
							tb.appendRow();
							
							for (String fn : pm.keySet()) {
								Object v = pm.get(fn);
								if (v != null) tb.setValue(fn, v); // import
							}
						}
					}
				} else {
					// 3. initialized 형식
					String pValue = params.get(name);
					if (pValue != null) ipl.setValue(name, pValue); // import
				}
			}
		}
		
		if (tpl != null) {
			JCoParameterFieldIterator pfi = tpl.getParameterFieldIterator();
			
			while (pfi.hasNextField()) {
				// 4. tableParameter 형식
				JCoField f = pfi.nextField();
				String name = f.getName();
				
				JCoTable tb = tpl.getTable(name);
				
				String pValue = params.get(name);
				if (pValue != null) {
					List<Map<String, String>> pValues = convertListFromMiapsString(pValue);
					
					for (Map<String, String> pm : pValues) {
						tb.appendRow();
						
						for (String fn : pm.keySet()) {
							Object v = pm.get(fn);
							if (v != null) tb.setValue(fn, v); // import
						}
					}
				}
			}
		}
	}
	
	/**
	 * Sap Export
	 * 
	 * @param function
	 * @param params
	 * @return
	 */
	public Map<String, Object> executeExport(JCoFunction function, Map<String, String> params) {
		// 1. List 형식 결과
		Map<String, Object> tableParameterList = new LinkedHashMap<String, Object>();
		
		JCoParameterList tpl = function.getTableParameterList();
		if (tpl != null) {
			JCoParameterFieldIterator pfi = tpl.getParameterFieldIterator();
			
			while (pfi.hasNextField()) {
				JCoField f = pfi.nextField();
				String name = f.getName();
				
				List<String> fieldNames = new ArrayList<String>();
				
				JCoTable table = tpl.getTable(name);
				JCoRecordFieldIterator rfi = table.getRecordFieldIterator();
				while (rfi.hasNextField()) {
					// 필드명
					JCoField f2 = rfi.nextField();
					fieldNames.add(f2.getName());
				}
				
				List<Map<String, Object>> values = new ArrayList<Map<String, Object>>();
				
				if (table.getNumRows() > 0) {
					do {
						Map<String, Object> value = new LinkedHashMap<String, Object>();
						for (String fn : fieldNames) {
							value.put(fn, table.getValue(fn)); // export
						}
						values.add(value);
					} while (table.nextRow());
				}
				
				tableParameterList.put(name, values);
			}
		}
		
		// 2. Map 형식 결과
		Map<String, Object> structure = new LinkedHashMap<String, Object>();
		
		// 3. 필드 형식 결과
		Map<String, Object> initialized = new LinkedHashMap<String, Object>();
		
		JCoParameterList epl = function.getExportParameterList();
		if (epl != null) {
			JCoParameterFieldIterator pfi = epl.getParameterFieldIterator();
			JCoMetaData md = epl.getMetaData();
			
			while (pfi.hasNextField()) {
				JCoField f = pfi.nextField();
				String name = f.getName();
				
				if (md.isStructure(name)) {
					JCoStructure st = epl.getStructure(name);
					JCoRecordFieldIterator rfi = st.getRecordFieldIterator();
					
					Map<String, Object> value = new LinkedHashMap<String, Object>();
					while (rfi.hasNextField()) {
						JCoField f2 = rfi.nextField();
						value.put(f2.getName(), f2.getValue()); // export
					}
					
					structure.put(name, value);
				} else {
					initialized.put(name, epl.getValue(name)); // export
				}
			}
		}
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("tableParameterList", tableParameterList); // 1. List 형식 결과
		result.put("structure", structure); // 2. Map 형식 결과
		result.put("initialized", initialized); // 3. 필드 형식 결과
		
		return result;
	}
	
	/**
	 * table 형태의 Base64String 파라메타(miaps 문자열)를 List로 변환
	 * 
	 * @param base64String
	 * @return List<Map<String, String>>
	 */
	public static List<Map<String, String>> convertListFromMiapsString(String base64String) {
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		
		if (StringUtils.isBlank(base64String)) return list;
		
		try {
			// table 형태의 Base64String 파라메타
			byte[] byteInfo = Base64.decodeBase64(base64String);
			
			String info = new String(byteInfo, "UTF-8");
			
			// List<Map<String, String>> 로 변환
			String[] arrRecord = info.split(new String(new byte[] {RS}));
			
			String[] arrKeySet = null;
			 
			for (int i =0 ; i < arrRecord.length; i++) {
				String[] arrField = arrRecord[i].split(new String(new byte[] {FS}), -1);
				if (i == 0) {
					arrKeySet = arrField;
				} else {
					Map<String, String> map = new HashMap<String, String>();
					for (int j =0 ; j < arrField.length; j++) {
						map.put(arrKeySet[j], arrField[j]);
					}
					list.add(map);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
}
