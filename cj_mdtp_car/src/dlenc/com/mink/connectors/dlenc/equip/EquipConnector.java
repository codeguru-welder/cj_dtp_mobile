package com.mink.connectors.dlenc.equip;

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

public class EquipConnector extends BaseMan {

    private final Logger log = LoggerFactory.getLogger(EquipConnector.class);

    /* Connector에서 HttpServletRequest, HttpServletResponse객체를 사용하는 방법 추가 */
    private HttpServletRequest req = null;
    private HttpServletResponse res = null;

    public void setHttpServletRequest(HttpServletRequest request) {
        this.req = request;
    }

    public void setHttpServletResponse(HttpServletResponse response) {
        this.res = response;
    }

    public String deleteLocWorkDtl(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EquipConnector.selectLocationCode() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            EquipService service =
                ApplicationContextUtil.getBean("dlenc.EquipService", EquipService.class);
            service.deleteLocWorkDtl(params);
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

    public String insertLocWork(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EquipConnector.selectLocationCode() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            EquipService service =
                ApplicationContextUtil.getBean("dlenc.EquipService", EquipService.class);
            service.insertLocWork(params);
            List<Map<String, Object>> results = new ArrayList<>();
            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("res", "Success");
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

    public String insertLocWorkDtl(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EquipConnector.selectLocationCode() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            EquipService service =
                ApplicationContextUtil.getBean("dlenc.EquipService", EquipService.class);

            String encodedMatrixOrderList = params.get("insertList");
            String decodedBase64MatrixOrderList = new String(
                Base64.decodeBase64(encodedMatrixOrderList.getBytes()), StandardCharsets.UTF_8);
            String decodedMatrixOrderList = URLDecoder
                .decode(decodedBase64MatrixOrderList, "UTF-8");

            JsonParser parser = new JsonParser();
            JsonArray jaParam = parser.parse(decodedMatrixOrderList).getAsJsonArray();

            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("insertList", getListMapFromJsonArray(jaParam));
            service.insertLocWorkDtl(paramMap);
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

    public String selectLocWorkDtl(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EquipConnector.selectLocationCode() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            EquipService service =
                ApplicationContextUtil.getBean("dlenc.EquipService", EquipService.class);
            List<Map<String, Object>> results = service.selectLocWorkDtl(params);
            setResultMap(sbResult, results);
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    public String selectLocWork(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EquipConnector.selectLocationCode() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            EquipService service =
                ApplicationContextUtil.getBean("dlenc.EquipService", EquipService.class);
            List<Map<String, Object>> results = service.selectLocWork(params);
            setResultMap(sbResult, results);
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    public String selectLocationCode(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EquipConnector.selectLocationCode() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            EquipService service =
                ApplicationContextUtil.getBean("dlenc.EquipService", EquipService.class);
            List<Map<String, Object>> results = service.selectLocationCode(null);
            setResultMap(sbResult, results);
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    public String selectEquipType(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EquipConnector.selectEquipType() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            EquipService service =
                ApplicationContextUtil.getBean("dlenc.EquipService", EquipService.class);
            List<Map<String, Object>> results = service.selectEquipType(null);
            setResultMap(sbResult, results);
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    public String selectEquipStd(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EquipConnector.selectEquipStd() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            Map<String, Object> sqlParams = new HashMap<>();
            sqlParams.put("cd_id", params.get("cd_id"));

            EquipService service =
                ApplicationContextUtil.getBean("dlenc.EquipService", EquipService.class);
            List<Map<String, Object>> results = service.selectEquipStd(sqlParams);
            log.debug("=====\n{}\n=====", results);

            setResultMap(sbResult, results);
        } catch (Exception e) {
            log.error("Can not execute selectUser connector...", e);
            setErrorMap(sbResult, e);
        }

        return sbResult.toString();
    }

    public String selectEquipPlan(Map<String, String> params, Object connection) {
        if (log.isTraceEnabled()) {
            log.trace("MiAPS connector - EquipConnector.selectEquipPlan() is called...");
        }

        StringBuilder sbResult = new StringBuilder();

        try {
            Map<String, Object> sqlParams = new HashMap<>();
            sqlParams.put("cd_id", params.get("cd_id"));

            EquipService service =
                ApplicationContextUtil.getBean("dlenc.EquipService", EquipService.class);
            List<Map<String, Object>> results = service.selectEquipPlan(sqlParams);
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
