<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="../js/common.jsp" %>
<html>
<head>
    <title>Insert title here</title>
</head>
<html>
<body background="${pageContext.request.getContextPath()}/static/image/login.jpg">
<div class="login-main">
    <header class="layui-elip">登录</header>
    <form class="layui-form">
        <div class="layui-input-inline">
            <input type="text" name="account" required lay-verify="required" placeholder="用户名" autocomplete="off"
                   class="layui-input">
        </div>
        <div class="layui-input-inline">
            <input type="password" name="password" required lay-verify="required" placeholder="密码" autocomplete="off"
                   class="layui-input">
        </div>
        <div class="layui-input-inline login-btn">
            <button type="button" class="layui-btn layui-btn-normal">登录</button>
        </div>
        <p><a href="register.html" class="fl">立即注册</a><a href="javascript:;" class="fr">忘记密码？</a></p>
    </form>
</div>
</body>
</html>
