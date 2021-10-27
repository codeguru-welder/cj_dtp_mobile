package com.mink.connectors.cjlogistics.list;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mink.connectors.cjlogistics.common.BaseMan;
import com.mink.connectors.cjlogistics.common.CommonUtil;

public class ListMan extends BaseMan {

	private Logger log = LoggerFactory.getLogger(getClass());

	/**
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String speedTest(Map<String, String> param, Object connection) throws Exception {

		try {
			String limit = param.get("limit");
			List<Map<String, Object>> resultMap = ((ListService) getBean("project.ListService")).getSpeedTestList(limit);
			
			String jsonRes = CommonUtil.convertJson(resultMap);
			jsonRes = "{\"code\":200,\"msg\":\"OK\",\"res\":" + jsonRes + "}";
			log.debug(jsonRes);
			
			return jsonRes;
			
		} catch (Exception e) {
			log.error(e.getMessage(), e);

			return "{\"code\":-1 , \"msg\":\""+ replaceJson(e.getMessage()) +"\"}";
		}
	
	}
	
	private String replaceJson(String str) {
		return str.replaceAll("\r", "\\\\r").replaceAll("\n", "\\\\n");
	}
	
    /**
     * 화물조회
     * @param param
     * @param connection
     * @return
     * @throws Exception
     */
    public String getUserList(Map<String, String> param, Object connection) throws Exception {
    	String result = null;

    	try {
    		ListService service = (ListService) getBean("project.ListService");
            result = service.getUserList(param);
           
        } catch (Exception e) {
        	log.error(e.getMessage(), e);
        	Map<String, Object> msgMap = new HashMap<String, Object>();
        	msgMap.put("code", -1);
        	msgMap.put("msg", e.getMessage());
            result = CommonUtil.convertJson(msgMap);   
        }
            
        return result;
    }
}

