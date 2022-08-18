package com.usercom.crm.workbench.service;

import com.usercom.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
//    插入活动
    int SaveCreateActivity(Activity acivity);
//    分页查询
    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);
//    根据不同条件查询获取的总数目
    int queryCountOfActivityByCondition(Map<String,Object> map);

}
