package com.usercom.crm.settings.service;

import com.usercom.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    /**  用户登录 查询用户和密码
     * @param map
     * @return
     */
    User selectUserByActAndPwd(Map<String,Object> map);

//活动市场获取已有用户信息
    List<User> queryAllUsers();
}
