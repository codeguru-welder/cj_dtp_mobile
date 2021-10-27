package com.mink.connectors.dlenc.gps;

import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.ibm.icu.text.SimpleDateFormat;
import com.mink.connectors.dlenc.common.CommonUtil;
import com.mink.connectors.dlenc.mapper.GpsMapper;

@Service("project.GpsService")
public class GpsService {

    private Logger log = LoggerFactory.getLogger(getClass());
    // use MyBatis
    @Resource(name = "gpsMapper")
    private GpsMapper gpsDao;
    
    public String insertGpsInfo(Map<String, String> paramMap) throws Exception {

        if (log.isDebugEnabled()) {
            log.debug("params : " + paramMap);
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date dt = new Date();
        String dateTime = sdf.format(dt);
        
        Map<String, String> map = new LinkedHashMap<String, String>();
        map.put("userId", paramMap.get("userId"));
        map.put("latitude", paramMap.get("latitude"));
        map.put("longitude", paramMap.get("longitude"));
        map.put("regDt", dateTime);
        
        int rowCnt = gpsDao.insertGpsInfo(map);
        StringBuilder resultSb = new StringBuilder();
        
        if (rowCnt > 0) {
        	Map<String, Object> resultMap = new LinkedHashMap<>();
            resultMap.put("code", 200);
            resultMap.put("msg", "success");
            resultSb.append(CommonUtil.convertJson(resultMap));
        } else {
        	Map<String, Object> resultMap = new LinkedHashMap<>();
            resultMap.put("code", -1);
            resultMap.put("msg", "fail");
            resultSb.append(CommonUtil.convertJson(resultMap));
        }
        return resultSb.toString();
    }
}