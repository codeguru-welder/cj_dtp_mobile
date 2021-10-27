package com.mink.connectors.mdtpcar.controller.intro;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.mink.connectors.mdtpcar.mapper.GetUserMapper;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

/**
 * biz logic 처리
 * @author user
 *
 */
@Service("intro.IntroTestService")
public class IntroTestService extends EgovAbstractDAO {

	
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	// use MyBatis
	@Resource(name="GetUserMapper")
	private GetUserMapper getUserMapper;
	
	public String selectGetUser(Map<String, String> paramMap) throws Exception {
		
		String userId = ""; 
		
		try {
			
			//MyBatis
			List<Map<String, Object>> resDataMap = (List<Map<String, Object>>) getUserMapper.selectGetUser(paramMap);
			//userId = resDataMap.get(0).get("userId").toString();
					
		} catch(Exception e) {
			if(logger.isDebugEnabled()) {
				logger.debug("=============> selectGetUser()" + e.getMessage());
			}
		}
		
		return userId;
	
	}
	
	
	/**
	 * 여러개 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List selectUserList(Map<String, String> paramMap) throws Exception {
		//MyBatis
		List<Map<String, Object>> resDataMap = (List<Map<String, Object>>) getUserMapper.selectGetUser(paramMap);
		
		
		//Iterator 통한 전체 조회
		Iterator iterator = resDataMap.iterator();
		while (iterator.hasNext()) {
		    String element = (String) iterator.next();
		     
		}
		 
		//for-loop 통한 전체 조회 
		for(Object object : resDataMap) {
		    String element = (String) object;
		}
		
		
		for (int i = 0; i < resDataMap.size(); i++) {
			
			System.out.println("1");
		}
		
		return resDataMap;
	}
	
}
