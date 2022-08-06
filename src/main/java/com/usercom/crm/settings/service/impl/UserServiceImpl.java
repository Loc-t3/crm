package com.usercom.crm.settings.service.impl;

import com.usercom.crm.settings.domain.User;
import com.usercom.crm.settings.mapper.UserMapper;
import com.usercom.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
@Service("userService")
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    public User selectUserByActAndPwd(Map<String, Object> map) {
        return userMapper.selectUserByActAndPwd(map);
    }
//    查询 dao层用select service层用query
    @Override
    public List<User> queryAllUsers() {
        return userMapper.SelectAllUsers();
    }
}
