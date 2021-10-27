package com.mink.connectors.dlenc.equip;

import com.mink.connectors.dlenc.mapper.EquipMapper;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

@Service("dlenc.EquipService")
public class EquipService {

    @Resource(name="equipMapper")
    private EquipMapper dlencDao;

    public List<Map<String, Object>> selectLocationCode(Map<String, Object> params) {
        return dlencDao.selectLocationCode(params);
    }

    public List<Map<String, Object>> selectEquipType(Map<String, Object> params) {
        return dlencDao.selectEquipType(params);
    }

    public List<Map<String, Object>> selectEquipStd(Map<String, Object> params) {
        return dlencDao.selectEquipStd(params);
    }

    public List<Map<String, Object>> selectEquipPlan(Map<String, Object> params) {
        return dlencDao.selectEquipPlan(params);
    }

    public List<Map<String, Object>> selectLocWork(Map<String, String> params) {
        return dlencDao.selectLocWork(params);
    }

    public List<Map<String, Object>> selectLocWorkDtl(Map<String, String> params) {
        return dlencDao.selectLocWorkDtl(params);
    }

    public void deleteLocWorkDtl(Map<String, String> params) {
        dlencDao.deleteLocWorkDtl(params);
    }

    public void insertLocWork(Map<String, String> params) {
        dlencDao.insertLocWork(params);
    }

    public void insertLocWorkDtl(Map<String, Object> params) {
        dlencDao.insertLocWorkDtl(params);
    }
}
