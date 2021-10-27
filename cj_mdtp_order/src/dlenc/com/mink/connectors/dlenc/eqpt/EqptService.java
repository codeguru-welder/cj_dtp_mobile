package com.mink.connectors.dlenc.eqpt;

import com.mink.connectors.dlenc.mapper.EqptMapper;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

@Service("dlenc.EqptService")
public class EqptService {

    @Resource(name="eqptMapper")
    private EqptMapper dlencDao;

    public List<Map<String, Object>> selectSiteCode(Map<String, Object> params) {
        return dlencDao.selectSiteCode(params);
    }

    public List<Map<String, Object>> selectEqptType(Map<String, Object> params) {
        return dlencDao.selectEqptType(params);
    }

    public List<Map<String, Object>> selectEqptStd(Map<String, Object> params) {
        return dlencDao.selectEqptStd(params);
    }

    public List<Map<String, Object>> selectEqptPlan(Map<String, Object> params) {
        return dlencDao.selectEqptPlan(params);
    }

    public List<Map<String, Object>> selectSiteWork(Map<String, String> params) {
        return dlencDao.selectSiteWork(params);
    }

    public List<Map<String, Object>> selectSiteWorkInfo(Map<String, String> params) {
        return dlencDao.selectSiteWorkInfo(params);
    }

    public void deleteSiteWorkInfo(Map<String, String> params) {
        dlencDao.deleteSiteWorkInfo(params);
    }

    public void insertSiteWork(Map<String, String> params) {
        dlencDao.insertSiteWork(params);
    }

    public void insertSiteWorkInfo(Map<String, Object> params) {
        dlencDao.insertSiteWorkInfo(params);
    }
}
