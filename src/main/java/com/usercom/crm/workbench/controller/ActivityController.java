package com.usercom.crm.workbench.controller;

import com.usercom.crm.settings.domain.User;
import com.usercom.crm.settings.mapper.UserMapper;
import com.usercom.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;
//    @RequestMapping("/workbench/activity/index.do")
    @RequestMapping("/workbench/activity/index.do")

    public String index(HttpServletRequest request){
        //调用Service方法 查询所有用户
         List<User> userlist = userService.queryAllUsers();

        //将数据进行保存至request中
        request.setAttribute("userlist",userlist);
        //跳转至市场活动主页
        return "workbench/activity/index";


    }

}
