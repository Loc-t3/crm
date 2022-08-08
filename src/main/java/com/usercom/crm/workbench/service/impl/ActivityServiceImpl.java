package com.usercom.crm.workbench.service.impl;

import com.usercom.crm.workbench.domain.Activity;
import com.usercom.crm.workbench.mapper.ActivityMapper;
import com.usercom.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("activityService")
public class ActivityServiceImpl implements ActivityService {
    @Autowired(required = false)
    private ActivityMapper activityMapper;
    @Override
    public int SaveCreateActivity(Activity acivity) {
        return activityMapper.insertActivity(acivity);
    }
}
