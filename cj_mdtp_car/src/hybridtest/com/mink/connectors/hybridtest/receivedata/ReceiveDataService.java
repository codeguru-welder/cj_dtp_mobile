package com.mink.connectors.hybridtest.receivedata;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Map;

import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonSyntaxException;
import com.google.gson.internal.bind.TypeAdapters;
import com.google.gson.stream.JsonReader;

@Service("project.ReceiveDataService")
public class ReceiveDataService {

	private Logger log = LoggerFactory.getLogger(getClass());
	
	private static String JVAL_CONTENTS = "{\"code\":\"%d\", \"msg\":\"%s\"";
	private static String JVAL_END = "}";
	
	/**
	 * @param paramMap
	 * @return
	 * @throws Exception 
	 */
	public String receiveData(Map<String, String> paramMap) throws Exception {

		if (log.isDebugEnabled()) {
			log.debug("params : " + paramMap);
		}
		
		String param1 = paramMap.get("param1"); // get json string
		
		// gson 방법1) 일반적인 방법 : String json 데이터가 Heap메모리 허용 이하라면 이것을 사용
		/*
		Gson gson = new GsonBuilder().setPrettyPrinting().create();
		JsonElement jelem = gson.fromJson(param1, JsonElement.class);
		JsonObject gsonJsonObj = jelem.getAsJsonObject();
		*/
		
		// gson 방법2) Json String이 너무 클 경우 Stream방식으로 읽어서 Json Object로 변경 합니다 (허용된 Heap이상 사용할 경우  이 방식을 사용)
		JsonObject gsonJsonObj = getGsonJsonObject(param1, true); 
		
		// print request json data
		log.info(beautify(gsonJsonObj.toString()));
		
		StringBuffer resultSb = new StringBuffer();
		resultSb.append(String.format(JVAL_CONTENTS, 200, "OK")).append(JVAL_END);
		
		return resultSb.toString();		
		
	}
	
	private JsonElement jsonReaderParse(JsonReader reader) throws JsonParseException {
	    boolean isEmpty = true;
	    try {
	    	reader.peek();
	        isEmpty = false;
	        return (JsonElement) TypeAdapters.JSON_ELEMENT.read(reader);
	    } catch (Throwable e) {
	        if (isEmpty) {
	            return JsonNull.INSTANCE;
	        }
	        throw new JsonSyntaxException(e);
	    }
	}
	
	/**
	 * Json String을 Gson JsonObject로 변환합니다.
	 * @param jsonStr Json String
	 * @param bStream Gson JsonObject변환 방식을 설정 합니다.<br>
	 *  true : Json String이 너무 클 경우 Stream방식으로 읽어서 Json Object로 변경 합니다.<br>
	 *  false: 기본적인 방법으로 변경 합니다.
	 * @return com.google.gson.JsonObject
	 */
	private JsonObject getGsonJsonObject(String jsonStr, boolean bStream) {
		
		JsonElement jelem = null;
		
		// jsonStr 사이즈가 너무 클 경우 gson object변환중 OutOfMemory가 발생할 수 있다. 이경우는 bStream을 true로 하여 Stream방식으로 변환하도록 한다.
		if (bStream) {
			InputStream in = new ByteArrayInputStream(jsonStr.getBytes());		
			JsonReader reader = null;
						
			try {
				reader = new JsonReader(new InputStreamReader(in, "UTF-8"));		        
				jelem = jsonReaderParse(reader);				
		        reader.close();
		        
			} catch (IOException e) {
				e.printStackTrace();
			} catch (Exception e2) {
				e2.printStackTrace();
			} finally {
				if (reader != null) {
					try {reader.close();} catch (IOException e) {e.printStackTrace();}
				}
				if (in != null) {
					try {in.close();} catch (IOException e) { e.printStackTrace(); }
				}
			}
		} else {
			Gson gson = new GsonBuilder().setPrettyPrinting().create();
			jelem = gson.fromJson(jsonStr, JsonElement.class);
		}
		
		return jelem.getAsJsonObject();	
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