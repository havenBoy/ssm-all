package com.xiong.controller;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author DOCO
 * 2018/12/14 11:12
 */
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o) throws Exception {
        //首页和登录的请求不拦截
        if(httpServletRequest.getRequestURL().indexOf("/index") > 0 || httpServletRequest.getRequestURL().indexOf("/login") > 0) return  true;
        if(httpServletRequest.getSession().getAttribute("name") != null) return  true;
        httpServletRequest.setAttribute("msg","请先登录！");
        httpServletRequest.getRequestDispatcher("/views/index.jsp").forward(httpServletRequest, httpServletResponse);
        return false;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
