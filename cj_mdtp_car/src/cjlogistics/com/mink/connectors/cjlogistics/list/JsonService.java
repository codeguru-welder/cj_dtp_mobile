package com.mink.connectors.cjlogistics.list;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.thinkm.mink.commons.util.MiapsResultConverter;

public class JsonService {
	private static final Logger log = LoggerFactory.getLogger(JsonService.class);

	private static final char FS = 0x08;
	private static final char RS = 0x0C;

	public JsonService() {
	}

	/**
	 * 커넥터 메소드 실행.
	 * 
	 * 폼에서 호출 방법: 
	 * 	query url="http://url.to.server/minkSvc", NoSql, UTF8, 
	 * 			classname="com.mink.connectors.test.JsonService", methodname="run", 
	 * 			paramName1="value1", paramName2="value2", ...;
	 * 
	 * @param params
	 * @param connection
	 * @return
	 */
	public String run(Map<String, String> params, Object connection) throws Exception {
		// 0. 사용하지 않을 시 시스템(예약) 파라메타 제거할 수 있음
		params.remove("uid");
		params.remove("cmd");	// select(query), execute(exec)
		params.remove("param");
		params.remove("mod");
		params.remove("cid");
		params.remove("pos");
		params.remove("deviceid");	// 장치 번호 (miaps_device.device_id)
		params.remove("target");	// 업무명 (miaps_target_url.url_id)
		params.remove("userid");	// 사용자 ID (miaps_user.user_id)
		params.remove("version");	// 프로토콜 버전
		params.remove("userno");	// 사용자 번호 (miaps_user.user_no)
		params.remove("groupid");	// 그룹(조직) ID (miaps_user_group.grp_id)

		// 1. 클라이언트에서 요청한 파라메타 읽기
		String salNo = params.get("sal_no");
		String listDate = params.get("list_date");

		// 2. 기간계 API 실행
		String json = executeLegacy(salNo, listDate);

		// 3. 결과 변환
		/*
		fieldNm1[FS]fieldNm2[FS]fieldNm3[FS]fieldNm4[RS]
		value001[FS]value002[FS]value003[FS]value004[RS]
		value011[FS]value012[FS]value013[FS]value014[RS]
		...
		 */
		String result = jsonToMsv(json);

		// 4. 결과 반환
		/*
		code[FS]message[RS]
		200[FS]Success[RS]
		{{{+results+}}}[RS]
		sal_no[FS]prod_id[FS]sal_nm[FS]list_id[FS]sal_amt[FS]price[FS]sal_sum[FS]list_date[RS]
		2005-07-00001[FS]성수사업부[FS]안영희[FS]국어교재[FS]60[FS]66000[FS]396000[FS]20030717[RS]
		2005-07-00002[FS]수유사업부[FS]김길영[FS]불어교재[FS]200[FS]3000[FS]600000[FS]20030711[RS]
		...
		 */
		//return result;
		
		return MiapsResultConverter.convertJsonFromMiapsString(result);
		
	}

	private String executeLegacy(String salNo, String listDate) {
		InputStream in = null;
		StringBuilder results = new StringBuilder();

		try {
			// 기간계 시스템 실행하여 결과 받음.
			// 기간계 시스템은 파일이라는 가정.
			in = this.getClass().getClassLoader().getResourceAsStream("com/mink/connectors/cjlogistics/list/results.json");
			BufferedReader r = new BufferedReader(new InputStreamReader(in, "UTF-8"));
			String line = null;
			while ((line = r.readLine()) != null) {
				results.append(line);
			}
		} catch (Exception e) {
			log.error("Can not execute legacy.", e);
		} finally {
			if (in != null) {
				try { in.close(); } catch (Exception e) {}
			}
		}

		return results.toString();
	}

	private String jsonToMsv(String json) {
		StringBuilder msv = new StringBuilder();

		JSONObject j = (JSONObject) JSONSerializer.toJSON(json);
		JSONObject status = (JSONObject) j.get("status");
		JSONArray results = (JSONArray) j.get("results");

		// 메시지 테이블
		msv.append("code").append(FS).append("msg").append(RS);
		msv.append(status.get("code")).append(FS).append(status.get("message")).append(RS);

		int size = results.size();
		if (size <= 0) {
			if (log.isWarnEnabled()) {
				log.warn("No results returned.");
			}
			return msv.toString();
		}

		// 결과 테이블을 위한 정보 만들기 (테이블명=results)
		msv.append("{{{+res+}}}").append(RS);
		
		// 결과 테이블 헤더(필드명) 만들기
		ArrayList<String> headers = readHeader((JSONObject) results.get(0));
		writeHeader(msv, headers);

		// 결과 테이블 데이터 리스트 만들기
		for (int i = 0; i < size; i++) {
			j = (JSONObject) results.get(i);
			writeRecord(msv, j, headers);
		}

		return msv.toString();
	}

	private ArrayList<String> readHeader(JSONObject j) {
		ArrayList<String> headers = new ArrayList<String>();

		@SuppressWarnings("unchecked")
		Iterator<String> iter = j.keys();
		while (iter.hasNext()) {
			String k = iter.next();
			headers.add(k);
		}

		return headers;
	}

	private void writeHeader(StringBuilder msv, ArrayList<String> headers) {
		int size = headers.size();
		for (int i = 0; i < size; i++) {
			if (i > 0) {
				msv.append(FS);
			}
			msv.append(headers.get(i));
		}
		msv.append(RS);
	}

	private void writeRecord(StringBuilder msv, JSONObject j, ArrayList<String> headers) {
		int size = headers.size();
		for (int i = 0; i < size; i++) {
			if (i > 0) {
				msv.append(FS);
			}
			String k = headers.get(i);
			String v = j.getString(k);
			msv.append(v);
		}
		msv.append(RS);
	}

}
