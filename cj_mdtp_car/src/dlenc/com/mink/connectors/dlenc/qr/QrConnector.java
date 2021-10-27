package com.mink.connectors.dlenc.qr;

import com.mink.connectors.dlenc.common.BaseMan;
import com.mink.connectors.dlenc.common.CommonUtil;
import com.thinkm.mink.commons.util.ApplicationContextUtil;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class QrConnector extends BaseMan {

    private final Logger log = LoggerFactory.getLogger(QrConnector.class);

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

    public String selectQrList(Map<String, String> params, Object connection) {
        StringBuilder sbResult = new StringBuilder();
        Map<String, Object> resultMap = new HashMap<>();
        String errorMsg = "";

        try {
            if ("".equals(params.get("userId"))) {
                errorMsg = "No User ID";
            } else {
                QrService service =
                    ApplicationContextUtil.getBean("dlenc.QrService", QrService.class);

                // QR 리스트 리턴
                List<Map<String, Object>> resultList = service.selectQrList(params);
                resultMap.put("code", 200);
                resultMap.put("res", resultList);
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMsg = e.getMessage();
            resultMap.put("code", -1);
        }
        if (!"".equals(errorMsg)) {
            resultMap.put("msg", errorMsg);
        }
        sbResult.append(CommonUtil.convertJson(resultMap));
        return sbResult.toString();
    }

    public String insertQrCode(Map<String, String> params, Object connection) {
        StringBuilder sbResult = new StringBuilder();
        Map<String, Object> resultMap = new HashMap<>();
        String errorMsg = "";

        try {
            if ("".equals(params.get("userId"))) {
                errorMsg = "No User ID";
            } else if ("".equals(params.get("qrcode"))) {
                errorMsg = "No Qr Code";
            } else {
                QrService service =
                    ApplicationContextUtil.getBean("dlenc.QrService", QrService.class);

                // insert QR
                service.insertQrCode(params);

                // insert 성공시 QR 리스트 리턴
                List<Map<String, Object>> resultList = service.selectQrList(params);
                resultMap.put("code", 200);
                resultMap.put("res", resultList);
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMsg = e.getMessage();
            resultMap.put("code", -1);
        }
        if (!"".equals(errorMsg)) {
            resultMap.put("msg", errorMsg);
        }
        sbResult.append(CommonUtil.convertJson(resultMap));
        return sbResult.toString();
    }
}
