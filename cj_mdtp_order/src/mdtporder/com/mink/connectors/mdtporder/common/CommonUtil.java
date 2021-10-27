package com.mink.connectors.mdtporder.common;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

/**
 * @author yu
 * 
 * Miaps Hybrid 
 * 응답 Json 생성 유틸
 * 
 * 생성 예)
 * {"code":"200","msg":"정상 처리 되었습니다.","res":[{"TRP_ID":"1000000000","TRP_PUPS_CD":"02","TRP_PUPS_CD99":"영업-영업","TRP_IMS_CNNT":"","TRP_ST_DT":"2017-03-05 오전 12:00:00","TRP_END_DT":"2017-03-15 오전 12:00:00","EMP_NO99":"","EMP_NM99":"박현지","CNTY_CD99":"BM","CNTY_NM99":"버뮤다"}]}
 */
public class CommonUtil {
	
	private static final Logger log = LoggerFactory.getLogger(CommonUtil.class);

	private static final String CODE = "code";
	private static final String MSG = "msg";
	private static final String RES = "res";
	
	private static JSONObject toJsonObjResultFromObject(String code, String message, Object resultMiapsObject)  throws Exception {	
		JSONObject jo = new JSONObject();
		
		jo.put(CODE, code);
		jo.put(MSG, message);
		jo.put(RES, resultMiapsObject);
		
		return jo;
	}
	
	public static String toHybridResultFromMap(String code, String message, Map<String, Object> resultMiapsMap) throws Exception {	
		JSONObject resultJsonObject = null;
		resultJsonObject = toJsonObjResultFromObject(code, message, resultMiapsMap);
		return resultJsonObject.toString();
	}
		
	public static String toHybridResultFromJsonStr(String code, String message, String resultJsonStr) throws Exception {	
		JSONObject resultJsonObject = null;
		resultJsonObject = toJsonObjResultFromObject(code, message, resultJsonStr);
		return resultJsonObject.toString();
	}	 
	
	/**
	* @param code
	* @param message
	* @param object [JSONObject, JSONArray, String, Map<String, Map>,Map<String, List<Map>>] 
	* @return
	* @throws Exception
	*/
	@SuppressWarnings("unchecked")
	public static String toHybridResultFromObject(String code, String message, Object object) throws Exception {
	
		JSONObject resultJsonObject = null;
		JSONArray resultJsonArray = null;
		Map<String, Object> resultMap = null;
		ArrayList resultArrayList = null;
		String resultJsonStr = "";
		
		if (object instanceof JSONObject) {
			resultJsonObject = (JSONObject) object;
			resultJsonStr = toHybridResultFromJsonStr(code, message, resultJsonObject.toString());
		} else if (object instanceof JSONArray) {
			resultJsonArray = (JSONArray) object;
			resultJsonStr = toHybridResultFromJsonStr(code, message, resultJsonArray.toString());
		} else if (object instanceof Map) {
			resultMap = (Map<String, Object>) object;
			resultJsonStr = toHybridResultFromMap(code, message, resultMap);
		} else if (object instanceof String) {
			resultJsonStr = toJsonObjResultFromObject(code, message, object).toString();
		} else if (object instanceof ArrayList) {
			resultArrayList = (ArrayList) object;
			resultJsonStr = toJsonObjResultFromObject(code, message, resultArrayList).toString();
		} else {
			throw new Exception(object.getClass() + " instanceof not supported");
		}
		return resultJsonStr;
	}
	
	public static String makeJsonStrByCatchMsg(String code, String message) {
	
		JSONObject jo = new JSONObject();
		jo.put(CODE, code);
		jo.put(MSG, StringUtils.defaultString(message));
		return jo.toString();
	}
	
	/*
	public static String convertJson(Map<String, Object> map) {
		Type baseType = new TypeToken<Map<String, Object>>() {}.getType();
		return new Gson().toJson(map, baseType);
	}
	
	public static String convertJson(List<Map<String, Object>> list) {
		Type baseType = new TypeToken<List<Map<String, Object>>>() {}.getType();
		return new Gson().toJson(list, baseType);
	}
	*/
	
	public static String convertJson(Object convertObj) {
	    
	    GsonBuilder gb = new GsonBuilder(); 
	    gb.serializeNulls();  // json value값이 null일경우 null을 세팅하도록한다.(이 설정이 없으면 value가 null인 key는 목록에서 제외된다)	    
	    Gson gson = gb.disableHtmlEscaping().create(); // 특수문자를 유니코드로 변환하지 않도록 disableHtmlEscaping()를 실행한다. 
	    
        String jsonResult = "";
        if (convertObj instanceof List) {
            Type baseType = new TypeToken<List<Map<String, Object>>>() {}.getType();
            jsonResult = gson.toJson(convertObj, baseType);
            
        } else if (convertObj instanceof Map) {
            Type baseType = new TypeToken<Map<String, Object>>() {}.getType();
            jsonResult = gson.toJson(convertObj, baseType);
        }
        
        if(log.isDebugEnabled()) {
            log.debug("\n[MiAPS Hybrid Result] ===========================\n" + beautify(jsonResult));
        }

        return jsonResult;
    }
	
	public static String beautify(String json) {
	    String res = null;
	    try {
    	    ObjectMapper mapper = new ObjectMapper();
    	    Object obj = mapper.readValue(json, Object.class);
    	    res =  mapper.writerWithDefaultPrettyPrinter().writeValueAsString(obj);
    	    
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return res;
	}
}

