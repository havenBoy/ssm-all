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
            <button type="button" class="layui-btn layui-btn-normal" id="login">登录</button>
        </div>
        <p><a href="register.html" class="fl"></a><a href="javascript:;" class="fr">忘记密码？</a></p>
    </form>

    <script type="text/javascript">
        $('#login').click(function () {
            var name = $("input[name='account']").val();
            var password = $("input[name='password']").val();
            $.ajax({
                url: '${pageContext.request.getContextPath()}/login',
                dataType: 'json',
                async: false,
                data: {
                    name : name,
                    password : password
                },
                type: 'POST', // 请求方式
                contentType: 'application/x-www-form-urlencoded; charset=utf-8',
                //请求完成时的处理
                success: function (ret) {
                    if(ret.code == 1) {
                        layer.msg("登录成功！");
                    } else {
                        layer.msg("登录失败！");
                    }
                },
                error: function (s) {
                    var old = s.error;
                    var errHeader = s.errorHeader || 'jumppay';
                    var errMsg = s.getResponseHeader(errHeader);
                    window.location = errMsg;
                    // 请求出错处理
                }
            });
        });
    </script>
</div>
</body>
</html>
