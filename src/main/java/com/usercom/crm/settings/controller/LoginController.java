package com.usercom.crm.settings.controller;

import com.mysql.cj.Session;
import com.sun.deploy.net.HttpResponse;
import com.usercom.crm.commons.constant.constant;
import com.usercom.crm.commons.domain.ReturnObject;
import com.usercom.crm.commons.utils.DateUtil;
import com.usercom.crm.settings.domain.User;
import com.usercom.crm.settings.service.UserService;
import com.usercom.crm.settings.service.impl.UserServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.HttpRequestHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/*
* url 要和 Controller 处理完请求后的 响应信息返回的资源目录路径一致
* */
@Controller
public class LoginController {
    @Autowired
    private UserServiceImpl userService;


    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        /*请求转发至登录界面*/

        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String loginRem, HttpServletRequest request, HttpSession session, HttpServletResponse response){

        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userService.selectUserByActAndPwd(map);

         //创建实体类对象
        ReturnObject returnObject = new ReturnObject();

        //对数据进行判断
        if (user== null){
            //查找为空 登录失败 账户或密码为空
            returnObject.setCode(constant.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("登录失败,账户或密码错误");
        }else{
            //进一步判断用户是否合法
            //对时效进行判断
                 String format = DateUtil.formdateTime(new Date());
            if (format.compareTo(user.getExpireTime())>0) {
                //登录失败 时效过期
                System.out.println("format.compareTo(user.getExpireTime()) = " + format.compareTo(user.getExpireTime()));
                String a = user.getExpireTime();
                System.out.println("user.getExpireTime() = " + a);
                returnObject.setCode("0");
                returnObject.setMessage("时效过期");
            }//对锁定状态进行判断
            else if("0".equals(user.getLockState())){
                //登录失败， 账户已锁定
                returnObject.setCode(constant.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号锁定");
            }
            //对ip属地进行判断  request.getRemoteAddr()--获取用户的ip地址
//            else if(!user.getAllowIps().contains(request.getRemoteAddr())){
//                returnObject.setCode(constant.RETURN_OBJECT_CODE_FAIL);
//                returnObject.setMessage("非常用ip地址");
//            }
            else{
                //登录成功
                returnObject.setCode(constant.RETURN_OBJECT_CODE_SUCCESS);
                //登录成功之后将 User 保存进 session 中
                session.setAttribute(constant.SESSION_USER,user);
                //实现记住密码功能，通过设置cookie来实现
                if ("true".equals(loginRem)){
                    final Cookie loginAct1 = new Cookie("loginAct", user.getLoginAct());
                    loginAct1.setMaxAge(24*60*10*60);
                    //服务端向客户端发送数据 用 response
                    response.addCookie(loginAct1);
                    final Cookie loginPwd1 = new Cookie("loginPwd", user.getLoginPwd());
                    loginPwd1.setMaxAge(24*60*10*60);

                    response.addCookie(loginPwd1);

                }else{
                    //当用户不在想要保存密码的时候，将cookie进行一个更改
                    final Cookie loginAct1 = new Cookie("loginAct", "1");
                    //将cookie的值进行清除
                    loginAct1.setMaxAge(0);
                    //服务端向客户端发送数据 用 response
                    response.addCookie(loginAct1);
                    final Cookie loginPwd1 = new Cookie("loginPwd", "1");
                    loginPwd1.setMaxAge(0);
                    response.addCookie(loginPwd1);


                }


            }
        }
        return returnObject;
    }


    //安全退出
    @RequestMapping("/settings/qx/user/loginout.do")
    public  String loginout(HttpServletResponse response,HttpSession session){
        final Cookie c1 = new Cookie("loginAct", null);
        c1.setPath("/");
        c1.setMaxAge(0);
        response.addCookie(c1);
        final Cookie c2 = new Cookie("loginPwd", null);
        c2.setPath("/");
        c2.setMaxAge(0);
        response.addCookie(c2);
        //撤销session
//        session.removeAttribute(constant.SESSION_USER);
        session.invalidate();

        //当cookie清除时 跳转至主页面
        return "redirect:/";//结束Springmvc来进行重定向，response.sendRedirect("/");






    }
}
