package com.mink.connectors.hybridtest.grid;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mink.connectors.hybridtest.common.BaseMan;
import com.mink.connectors.hybridtest.common.CommonUtil;
import com.thinkm.mink.commons.util.ApplicationContextUtil;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class GridConnector extends BaseMan {

    /* Connector에서 HttpServletRequest, HttpServletResponse객체를 사용하는 방법 추가 */
    private HttpServletRequest req = null;
    private HttpServletResponse res = null;

    public void setHttpServletRequest(HttpServletRequest request) {
        this.req = request;
    }

    public void setHttpServletResponse(HttpServletResponse response) {
        this.res = response;
    }
    /*여기까지*/


    public String updateDataList(Map<String, String> params, Object connection) {
        StringBuilder sbResult = new StringBuilder();
        Map<String, Object> resultMap = new HashMap<>();
        String errorMsg = "";

        try {
            GridService service =
                ApplicationContextUtil.getBean("hybridtest.GridService", GridService.class);

            String encodedMatrixOrderList = params.get("updateList");
            String decodedMatrixOrderList = URLDecoder
                .decode(encodedMatrixOrderList, "UTF-8");
            JsonParser parser = new JsonParser();
            JsonArray jaParam = parser.parse(decodedMatrixOrderList).getAsJsonArray();

            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("updateList", getListMapFromJsonArray(jaParam));

            service.updateDataList(paramMap);

            resultMap.put("code", 200);
            resultMap.put("res", "Success");
        } catch (Exception e) {
            errorMsg = e.getMessage();
            resultMap.put("code", -1);
        }
        if (!"".equals(errorMsg)) {
            resultMap.put("msg", errorMsg);
        }
        sbResult.append(CommonUtil.convertJson(resultMap));
        return sbResult.toString();
    }

    public String selectDataList(Map<String, Object> params, Object connection) {
        StringBuilder sbResult = new StringBuilder();
        Map<String, Object> resultMap = new HashMap<>();
        String errorMsg = "";

        try {
            // 페이징 세팅
            String end = String.valueOf(params.get("end")).trim();
            if ("".equals(end)
                || "null".equalsIgnoreCase(end)
                || "undefined".equalsIgnoreCase(end)) {
                // End 없으면 -1으로 세팅 (제한 없이 모두 가져오기)
                params.put("end", -1);
            } else {
                // End 있으면 int로 형변환하여 세팅
                params.put("end", Integer.parseInt(end));

                // Get Start Num
                String start = String.valueOf(params.get("start"));
                if (!"".equals(start)
                    && !"null".equalsIgnoreCase(start)
                    && !"undefined".equalsIgnoreCase(start)) {
                    // start 있으면 int로 형변환하여 세팅
                    params.put("start", Integer.parseInt(start));
                }
            }

            GridService service =
                ApplicationContextUtil.getBean("hybridtest.GridService", GridService.class);

            List<Map<String, Object>> resultList = service.selectDataList(params);
            resultMap.put("code", 200);
            resultMap.put("res", resultList);
        } catch (Exception e) {
            errorMsg = e.getMessage();
            resultMap.put("code", -1);
        }
        if (!"".equals(errorMsg)) {
            resultMap.put("msg", errorMsg);
        }
        sbResult.append(CommonUtil.convertJson(resultMap));
        return sbResult.toString();
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
