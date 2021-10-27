package com.mink.connectors.dlenc.eqpt;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mink.connectors.dlenc.common.BaseMan;
import com.mink.connectors.dlenc.common.CommonUtil;
import com.mink.connectors.dlenc.common.PushManager;
import com.thinkm.mink.commons.util.ApplicationContextUtil;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EqptConnector extends BaseMan {

    private final Logger log = LoggerFactory.getLogger(EqptConnector.class);

    /* Connector에서 HttpServletRequest, HttpServletResponse객체를 사용하는 방법 추가 */
    private HttpServletRequest req = null;
    private HttpServletResponse res = null;

    public void setHttpServletRequest(HttpServletRequest request) {
        this.req = request;
    }

    public void setHttpServletResponse(HttpServletResponse response) {
        this.res = response;
    }

    public String deleteSiteWorkInfo(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EqptConnector.selectSiteCode() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            EqptService service =
                ApplicationContextUtil.getBean("dlenc.EqptService", EqptService.class);
            service.deleteSiteWorkInfo(params);
            List<Map<String, Object>> results = new ArrayList<>();
            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("res", "Success");
            resultMap.put("code", 200);

            results.add(resultMap);
            setResultMap(sbResult, results);
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    public String insertSiteWork(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EqptConnector.insertSiteWork() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            EqptService service =
                ApplicationContextUtil.getBean("dlenc.EqptService", EqptService.class);
            service.insertSiteWork(params);
            if(params.get("SEQ_SITE_EQPT") == null) {
            	params.put("SEQ_SITE_EQPT", params.get("SEQ"));
            	params.remove("SEQ");
            }
            
            List<Map<String, Object>> results = new ArrayList<>();
            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("res", params);
            resultMap.put("code", 200);
            results.add(resultMap);
            setResultMap(sbResult, results);
            
            // send push message
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
    		Calendar cal = Calendar.getInstance();
    		String date = sdf.format(cal.getTime());            
    		PushManager pushMng = new PushManager();
            Map<String, String> param = new LinkedHashMap<String, String>();
            param.put("taskId", "1");
            param.put("deviceId", params.get("deviceid"));
            param.put("msg", "현장 작업이 등록 되었습니다. (" + date + ")");
            pushMng.savePushData(param);
            
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    public String insertSiteWorkInfo(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EqptConnector.selectLocationCode() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            EqptService service =
                ApplicationContextUtil.getBean("dlenc.EqptService", EqptService.class);

            String encodedMatrixOrderList = params.get("insertList");
            String decodedBase64MatrixOrderList = new String(
                Base64.decodeBase64(encodedMatrixOrderList.getBytes()), StandardCharsets.UTF_8);
            String decodedMatrixOrderList = URLDecoder
                .decode(decodedBase64MatrixOrderList, "UTF-8");

            JsonParser parser = new JsonParser();
            JsonArray jaParam = parser.parse(decodedMatrixOrderList).getAsJsonArray();

            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("insertList", getListMapFromJsonArray(jaParam));
            service.insertSiteWorkInfo(paramMap);
            List<Map<String, Object>> results = new ArrayList<>();
            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("res", "Success");
            resultMap.put("code", 200);

            results.add(resultMap);
            setResultMap(sbResult, results);
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    public String selectSiteWorkInfo(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EqptConnector.selectSiteCode() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            EqptService service =
                ApplicationContextUtil.getBean("dlenc.EqptService", EqptService.class);
            List<Map<String, Object>> results = service.selectSiteWorkInfo(params);
            setResultMap(sbResult, results);
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    public String selectSiteWork(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EqptConnector.selectSiteCode() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            EqptService service =
                ApplicationContextUtil.getBean("dlenc.EqptService", EqptService.class);
            List<Map<String, Object>> results = service.selectSiteWork(params);
            setResultMap(sbResult, results);
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    public String selectSiteCode(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EqptConnector.selectSiteCode() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            EqptService service =
                ApplicationContextUtil.getBean("dlenc.EqptService", EqptService.class);
            List<Map<String, Object>> results = service.selectSiteCode(null);
            setResultMap(sbResult, results);
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    public String selectEqptType(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EquipConnector.selectEqptType() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
        	Map<String, Object> sqlParams = new HashMap<>();
            sqlParams.put("TY_SITE", params.get("TY_SITE"));
            log.debug( params.get("TY_SITE"));
            EqptService service =
                ApplicationContextUtil.getBean("dlenc.EqptService", EqptService.class);
            List<Map<String, Object>> results = service.selectEqptType(sqlParams);
            setResultMap(sbResult, results);
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    public String selectEqptStd(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EquipConnector.selectEqptStd() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            Map<String, Object> sqlParams = new HashMap<>();
            sqlParams.put("TY_EQPT", params.get("TY_EQPT"));

            EqptService service =
                ApplicationContextUtil.getBean("dlenc.EqptService", EqptService.class);
            List<Map<String, Object>> results = service.selectEqptStd(sqlParams);
            log.debug("=====\n{}\n=====", results);

            setResultMap(sbResult, results);
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    public String selectEqptPlan(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EqptConnector.selectEqptPlan() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            Map<String, Object> sqlParams = new HashMap<>();
            sqlParams.put("TY_EQPT", params.get("TY_EQPT"));
            log.debug(params.get("TY_EQPT"));
            EqptService service =
                ApplicationContextUtil.getBean("dlenc.EqptService", EqptService.class);
            List<Map<String, Object>> results = service.selectEqptPlan(sqlParams);
            log.debug("=====\n{}\n=====", results);

            setResultMap(sbResult, results);
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    private void setErrorMap(StringBuilder sbResult, Exception e) {
        Map<String, Object> errorMap = new HashMap<>();
        errorMap.put("code", -1);
        errorMap.put("msg", e.getMessage());

        sbResult.append(CommonUtil.convertJson(errorMap));
    }

    private void setResultMap(StringBuilder sbResult, List<Map<String, Object>> results) {
        log.debug("=====\n{}\n=====", results);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("res", results);
        resultMap.put("code", 200);
        resultMap.put("msg", "Success!");

        sbResult.append(CommonUtil.convertJson(resultMap));
    }

    /**
     * JsonObject를 Map<String, String>으로 변환한다.
     *
     * @param jsonObj JSONObject.
     * @return Map<String, Object>.
     */
	private Map<String, Object> getMapFromJsonObject(JsonObject jsonObj) {
        Map<String, Object> map = new HashMap<>();
        Gson gson = new Gson();
        try {
            map = (Map) gson.fromJson(jsonObj.toString(), map.getClass());
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }

    /**
     * JsonArray를 List<Map<String, String>>으로 변환한다.
     *
     * @param jsonArray JSONArray.
     * @return List<Map < String, Object>>.
     */
    private List<Map<String, Object>> getListMapFromJsonArray(JsonArray jsonArray) {
        List<Map<String, Object>> list = new ArrayList<>();

        if (jsonArray != null) {
            int jsonSize = jsonArray.size();
            for (int i = 0; i < jsonSize; i++) {
                Map<String, Object> map = getMapFromJsonObject((JsonObject) jsonArray.get(i));
                list.add(map);
            }
        }

        return list;
    }
    /*여기까지*/

    
    
}
