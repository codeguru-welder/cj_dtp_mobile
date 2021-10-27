package com.mink.connectors.hybridtest.logging;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.mink.connectors.hybridtest.mapper.LoggingMapper;
import com.thinkm.mink.commons.logging.DeviceLog;
import com.thinkm.mink.commons.logging.LogExpandRule;
import com.thinkm.mink.core.protocol.Cmd;
import com.thinkm.mink.core.protocol.Mink;
import com.thinkm.mink.core.protocol.Param;
import com.thinkm.mink.core.protocol.RCmd;
import com.thinkm.mink.core.protocol.RParam;

// 사용할 때 주석을 해제 하여 테스트 합니다.
//@Service("logExpandRule")
public class ExpandedLogService implements LogExpandRule {
	
	private Logger log = LoggerFactory.getLogger(ExpandedLogService.class);

	// use MyBatis
	@Resource(name="loggingMapper")
	private LoggingMapper loggingMapper;
	
	private String digit(int i) {
		return (i < 10 ? "0" : "")  + i;
	}
	
	@Override
	public void logging(HttpServletRequest request, HttpServletResponse response, DeviceLog deviceLog, Mink mink, RCmd rcmd) {
		/* 테스트 테이블
		//상상인 요청 응답 로그 
		CREATE TABLE miaps_ssi_log (
			log_tm NUMERIC(20) NOT NULL,
			ch_gid VARCHAR(20) NOT NULL,
			user_id VARCHAR(11) NOT NULL,	-- client cmd userid value
			uuid VARCHAR(50) NOT NULL,		-- client cmd deviceid value
			req_target VARCHAR(255) NULL,
			req_class VARCHAR(50)  NULL,
			req_method VARCHAR(50)  NULL,
			req_params VARCHAR(200) NULL,
			req_time VARCHAR(15) NULL, -- client cmd time value
			req_version VARCHAR(10) NULL,
			res_code INT NULL,
			res_msg VARCHAR(2000) NULL,
			log_year CHAR(4) NULL,
			log_month CHAR(2) NULL,
			log_date CHAR(2) NULL
		);		 
		*/
		
		log.debug(request.getSession().getId());
		
		try {
			Map<String, Object> logMap = new HashMap<String, Object>();
			
			// UUID1: 3d906748-488a-11ea-b77f-2e728ce88125
			// UUUD4: dc32010c-2a9a-47a8-8cdd-2d366b934c5e
			
			List<Cmd> minkCmd = mink.getCmds();
			List<Param> cmdParam = minkCmd.get(0).getUnits().get(0).getParams();
			List<RParam> rcmdRParam = rcmd.getRunits().get(0).getRparams();
			
			Calendar c = Calendar.getInstance();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmsss");
			String d = sdf.format(new Date());
			double dv =  Math.random();
			int iv = (int) (dv * 100000);
			
			String chGid = "GID" + d + String.valueOf(iv);
			String userId = mink.getUserid();
			String uuid = mink.getDeviceid();
			String className = "";
			String methodName = "";
			String targetName = minkCmd.get(0).getTarget();
			String reqTime = d;
			String reqVersion = mink.getVersionnm();
			String resCode = "";
			String resMsg = "";
			StringBuffer sbParam = new StringBuffer();
						
			for (int i = 0; i < cmdParam.size(); i++) {
				Param param = cmdParam.get(i);

				if ("classname".equalsIgnoreCase(param.getName())) {
					className = param.getValue();
				} else if ("methodname".equalsIgnoreCase(param.getName())) {
					methodName = param.getValue();
				} else if ("clientType".equalsIgnoreCase(param.getName())) {
					continue; // clientType은 제외
				} else {
					sbParam.append(param.getName()).append("=").append(param.getValue()).append("\n");
				}
			}
						
			RParam rparam = rcmdRParam.get(0);
			resCode = String.valueOf(rcmd.getRetcode());
			resMsg = rparam.getValue();			
			
			logMap.put("logTm", c.getTimeInMillis());		
			logMap.put("logYear", c.get(Calendar.YEAR));
			logMap.put("logMonth", digit(c.get(Calendar.MONTH) + 1));
			logMap.put("logDay", digit(c.get(Calendar.DATE)));
			
			logMap.put("chGid", chGid);
			logMap.put("userId", userId);
			logMap.put("uuid", uuid);
			logMap.put("reqTarget", targetName);
			logMap.put("reqClass", className);
			logMap.put("reqMethod", methodName);
			logMap.put("reqParams", sbParam.toString());
			logMap.put("reqTime", reqTime);
			logMap.put("reqVersion", reqVersion);
			logMap.put("resCode", resCode);
			logMap.put("resMsg", resMsg);
			
			loggingMapper.insertLog(logMap);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		/*[Cmd]
		com.thinkm.mink.core.protocol.Cmd@b894fff[
		  classid=miapsService
		  actionid=<null>
		  refid=1
		  autocommit=false
		  target=MIAPS-LOGIN-TEST
		  units=[com.thinkm.mink.core.protocol.Unit@3d04e177[
		  mode=runclass
		  refid=1
		  params=[com.thinkm.mink.core.protocol.Param@549004ad[
		  name=userId
		  mode=
		  type=
		  length=0
		  value=
		  unit=com.thinkm.mink.core.protocol.Unit@3d04e177
		], com.thinkm.mink.core.protocol.Param@22bbd4fe[
		  name=userPw
		  mode=
		  type=
		  length=0
		  value=
		  unit=com.thinkm.mink.core.protocol.Unit@3d04e177
		], com.thinkm.mink.core.protocol.Param@638c81e1[
		  name=classname
		  mode=
		  type=
		  length=0
		  value=com.mink.connectors.hybridtest.login.LoginMan
		  unit=com.thinkm.mink.core.protocol.Unit@3d04e177
		], com.thinkm.mink.core.protocol.Param@7999dbbe[
		  name=methodname
		  mode=
		  type=
		  length=0
		  value=login
		  unit=com.thinkm.mink.core.protocol.Unit@3d04e177
		], com.thinkm.mink.core.protocol.Param@66290e1d[
		  name=clientType
		  mode=in
		  type=String
		  length=0
		  value=hybrid
		  unit=<null>
		]]
		  resultParam=<null>
		  cmd=com.thinkm.mink.core.protocol.Cmd@b894fff
		]]
		  mink=com.thinkm.mink.core.protocol.Mink@58463765[
		  version=1.1
		  time=20200204172452
		  deviceid=MiAPS-WebAppEmulator
		  groupid=
		  userno=<null>
		  userid=
		  password=
		  packagenm=
		  platformcd=
		  versionnm=
		  comp=
		  lan=ko
		  resultCode=0
		  errorMsg=<null>
		  cmds=[com.thinkm.mink.core.protocol.Cmd@b894fff[
		  classid=miapsService
		  actionid=<null>
		  refid=1
		  autocommit=false
		  target=MIAPS-LOGIN-TEST
		  units=[com.thinkm.mink.core.protocol.Unit@3d04e177[
		  mode=runclass
		  refid=1
		  params=[com.thinkm.mink.core.protocol.Param@549004ad[
		  name=userId
		  mode=
		  type=
		  length=0
		  value=
		  unit=com.thinkm.mink.core.protocol.Unit@3d04e177
		], com.thinkm.mink.core.protocol.Param@22bbd4fe[
		  name=userPw
		  mode=
		  type=
		  length=0
		  value=
		  unit=com.thinkm.mink.core.protocol.Unit@3d04e177
		], com.thinkm.mink.core.protocol.Param@638c81e1[
		  name=classname
		  mode=
		  type=
		  length=0
		  value=com.mink.connectors.hybridtest.login.LoginMan
		  unit=com.thinkm.mink.core.protocol.Unit@3d04e177
		], com.thinkm.mink.core.protocol.Param@7999dbbe[
		  name=methodname
		  mode=
		  type=
		  length=0
		  value=login
		  unit=com.thinkm.mink.core.protocol.Unit@3d04e177
		], com.thinkm.mink.core.protocol.Param@66290e1d[
		  name=clientType
		  mode=in
		  type=String
		  length=0
		  value=hybrid
		  unit=<null>
		]]
		  resultParam=<null>
		  cmd=com.thinkm.mink.core.protocol.Cmd@b894fff
		]]
		  mink=com.thinkm.mink.core.protocol.Mink@58463765
		]]
		  rcmds=<null>
		  attachments=<null>
		]
		]
		 */
		
		/* [RCmd]
		com.thinkm.mink.core.protocol.RCmd@3dc665fa[
		  retcode=0
		  refid=1
		  runits=[com.thinkm.mink.core.protocol.RUnit@356eb08[
		  refid=1
		  rparams=[com.thinkm.mink.core.protocol.RParam@125ef24b[
		  mode=result
		  type=msv
		  length=0
		  value={"code":"-1", "msg":"아이디를 확인 하세요."}
		  colnames=<null>
		  rows=<null>
		]]
		  mode=runclass
		]]
		]
		 */
				
		
	}
}
