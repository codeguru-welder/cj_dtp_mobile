package com.mink.connectors.mdtpcar.common;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("project.MiapsDao")
public class MiapsDao extends EgovAbstractDAO {
	/**
	 * DB별 sqlMapClient지정
	 */
	@Resource(name = "miaps.sqlMapClient")
    public void setSuperSqlMapClient(SqlMapClient sqlMapClient) {
        super.setSuperSqlMapClient(sqlMapClient);
    }
}	
