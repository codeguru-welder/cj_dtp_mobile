package com.mink.connectors.hybridtest.list;

import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;


//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.mink.connectors.hybridtest.common.CommonUtil;
import com.mink.connectors.hybridtest.common.ProjectDao;
import com.mink.connectors.hybridtest.mapper.ProjectMapper;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Service("project.ListService")
public class ListService extends EgovAbstractDAO {

	//private Logger log = LoggerFactory.getLogger(getClass());
	
	//use iBatis
	//@Resource(name="project.ProjectDao")
	//private ProjectDao projectDao;
	
	// use MyBatis
	@Resource(name="projectMapper")
	private ProjectMapper projectDao;


	/**
	 * select speed_test table 
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getSpeedTestList(String limit) throws Exception {
		// use iBatis
		//List<Map<String, Object>> result = (List<Map<String, Object>>) projectDao.list("ProjectUser.getSpeedTestList", limit);
		
		// use MyBatis
		List<Map<String, Object>> result = (List<Map<String, Object>>) projectDao.getSpeedTestList(Integer.parseInt(limit));

		return result;
	}
	
	/**
	 * 화물 리스트
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public String getUserList(Map<String, String> params) throws Exception {

		LinkedHashMap<String, Object> miapsResultMap;

		try {
			miapsResultMap = new LinkedHashMap<String, Object>();
			
			// 리스트 취득
			List<Map<String, Object>> result = (List<Map<String, Object>>) projectDao.getUserList(params);
			miapsResultMap.put("userList", result);
			
			int startRow = Integer.parseInt(params.get("END_ROW").toString())  + 1;
			int endRow = startRow;
			
			params.put("START_ROW", startRow + "");
			params.put("END_ROW", endRow + "");
			
			// 다음 리스트가 있는지 확인
			List<Map<String, Object>> resultNext = (List<Map<String, Object>>) projectDao.getUserList(params);
			
			if ( resultNext.size() > 0 ){				
				miapsResultMap.put("nextList", "Y");
			}else{			    
				miapsResultMap.put("nextList", "N");
			}
			
			// total count
            Map<String, Object> resultCnt = (Map<String, Object>) projectDao.getUserTotalCnt();
            miapsResultMap.put("userListCnt", resultCnt.get("CNT"));
			
			miapsResultMap.put("errCode", "S");
            miapsResultMap.put("errMsg", "OK");
            
            return CommonUtil.convertJson(miapsResultMap);

		} catch(Exception e) {
			throw e;
		}		
	}
}
