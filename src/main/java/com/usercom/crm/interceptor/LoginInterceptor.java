package com.usercom.crm.interceptor;

import com.usercom.crm.commons.constant.constant;
import com.usercom.crm.settings.domain.User;
import org.springframework.lang.Nullable;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        //通过session进行判断用户是否登录
        HttpSession session = request.getSession();
        System.out.println("session = " + session);
        // 通过getAttribute()获取User对象中的session，判断User对象中的session是否为空
        User user = (User) session.getAttribute(constant.SESSION_USER);
        if (user==null){
            //为空 则跳转至配置的项目首页
            response.sendRedirect(request.getContextPath());//重定向  url需包含项目配置项
            return  false;
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable ModelAndView modelAndView) throws Exception {
    }
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable Exception ex) throws Exception {
    }
}
