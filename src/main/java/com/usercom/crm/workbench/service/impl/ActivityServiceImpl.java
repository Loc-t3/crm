package com.usercom.crm.workbench.service.impl;

import com.usercom.crm.workbench.domain.Activity;
import com.usercom.crm.workbench.mapper.ActivityMapper;
import com.usercom.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service("activityService")
public class ActivityServiceImpl implements ActivityService {
    @Autowired(required=false)
//    @Qualifier("activityMapper")
    private ActivityMapper activityMapper;

    @Override
    public int SaveCreateActivity(Activity acivity) {
        return activityMapper.insertActivity(acivity);
    }

    @Override
    public List<Activity> queryActivityByConditionForPage(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    @Override
    public int queryCountOfActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    @Override
    public int deleteActivityByids(String[] ids) {

        return activityMapper.deleteActivityByid(ids);
    }


}
