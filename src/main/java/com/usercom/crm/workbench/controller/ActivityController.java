package com.usercom.crm.workbench.controller;

import com.usercom.crm.commons.constant.constant;
import com.usercom.crm.commons.domain.ReturnObject;
import com.usercom.crm.commons.utils.DateUtils;
import com.usercom.crm.commons.utils.UUIDUtil;
import com.usercom.crm.settings.domain.User;
import com.usercom.crm.settings.service.UserService;
import com.usercom.crm.workbench.domain.Activity;
import com.usercom.crm.workbench.service.ActivityService;
import org.apache.poi.ss.usermodel.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;
    @Autowired(required = false)
    private Activity activity;
    @Autowired
    private ActivityService activityService;


    @RequestMapping("/workbench/activity/index.do")

    public String index(HttpServletRequest request){
        //调用Service方法 查询所有用户
         List<User> userlist = userService.queryAllUsers();

        //将数据进行保存至request中
        request.setAttribute("userlist",userlist);
        //跳转至市场活动主页
        return "workbench/activity/index";


    }
/*多态的思想 返回值为返回值的父类*/
    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    @ResponseBody
    public Object saveCreateActivity(Activity activity, HttpSession session){
         User user = (User) session.getAttribute(constant.SESSION_USER);
        //封装参数
        activity.setId(UUIDUtil.getuuid());
        activity.setCreateTime(DateUtils.formdateTime(new Date()));
        activity.setCreateBy(user.getId());
        ReturnObject re          = new ReturnObject();
        try{
            //调用service层方法
            int ret = activityService.SaveCreateActivity(activity);
            //返回 返回值 是否正确返回 通过 @ResponseBody 可将下方的数据转换为json格式
            if (ret>0){
                re.setCode(constant.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                re.setCode(constant.RETURN_OBJECT_CODE_FAIL);
                re.setMessage("系统忙，请稍后再试...");
            }
        }
        catch (Exception e){
            e.printStackTrace();
            re.setCode(constant.RETURN_OBJECT_CODE_FAIL);
            re.setMessage("系统忙，请稍后再试...");

        }


        return null;

    }

}
