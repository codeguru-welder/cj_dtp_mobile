package com.mink.connectors.dlenc.common;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.thinkm.mink.asvc.service.PushService;
import com.thinkm.mink.asvc.util.DateUtil;

public class PushManager extends BaseMan {
	
	private final Logger log = LoggerFactory.getLogger(CommonUtil.class);
	
	public PushManager() {}

	public void savePushData(Map<String, String> params) {
        // ... 기타 작업 ...

        Map<String, Object> pushDataMap = new HashMap<String, Object>();
        List<Map<String, Object>> pushTaskList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> pushTargetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> pushDataStMap = new HashMap<String, Object>();
        
        // 0. PushService 객체 로드
        PushService pushService = (PushService) getBean("admincenter.pushService");

        try {
            // 0. 기초값
            long userNo = 0; // 메소드 실행 사용자 번호. 어드민 사용자 번호를 지정함
            long currTime = System.currentTimeMillis(); // 현재시각 (milli-seconds)
            String currentDt = DateUtil.toDateString(new Date(currTime)); // 현재시각(yyyyMMddHHmmss)

            // 1. push_id 생성
            long pushId = pushService.newPushId();

            // 2. 푸시데이터 생성
            pushDataMap.put("pushId", pushId);
            pushDataMap.put("pushMsg", params.get("msg"));
            pushDataMap.put("msgTp", "Text"); // Text, BText, Inbox
            pushDataMap.put("imgUrl", "");
            pushDataMap.put("reservedDt", ""); // {예약일시; yyyyMMddHHmmss}
            pushDataMap.put("dataSt", "N");
            pushDataMap.put("currTime", currTime);
            if (userNo >= 0) {
                pushDataMap.put("userNo", userNo);
            }
            pushDataMap.put("currentDt", currentDt);

            // 3. 할당된 푸시 업무 등록
            // for (푸시업무 개수만큼 반복) {
                Map<String, Object> pushTaskMap = new HashMap<String, Object>();
                pushTaskMap.put("pushId", pushId);
                pushTaskMap.put("taskId", params.get("taskId"));
                pushTaskList.add(pushTaskMap);
            // }

            // 4. 푸시 target 등록
            String targetTp = "DD";
            String targetId = params.get("deviceId"); // 장치 번호
            String includeSubYn = "N";

            Map<String, Object> pushTargetMap = new HashMap<String, Object>();
            pushTargetMap.put("pushId", pushId);
            pushTargetMap.put("targetTp", targetTp);
            pushTargetMap.put("targetId", targetId);
            pushTargetMap.put("includeSubYn", includeSubYn);
            if (userNo >= 0) {
                pushTargetMap.put("userNo", userNo);
            }
            pushTargetMap.put("currentDt", currentDt);
            pushTargetList.add(pushTargetMap);
            

            // 5. 푸시데이터 상태 저장
            pushDataStMap.put("pushId", pushId);
            pushDataStMap.put("currTime", currTime);
            pushDataStMap.put("dataSt", "T");

            pushService.insertPushDataByMap(pushDataMap, pushTaskList, pushTargetList, pushDataStMap);
        } catch (Exception e) {
            log.error("Can not save push message - " + e.getMessage());
        }

        // ... 다른 작업 ...
    }
}