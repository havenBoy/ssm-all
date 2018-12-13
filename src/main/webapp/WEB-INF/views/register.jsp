<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="../js/common.jsp" %>
<html>
<head>
    <title>密码更换</title>
</head>
<html>
<body background="${pageContext.request.getContextPath()}/static/image/login.jpg">
<div class="login-main">
    <header class="layui-elip" style="width: 82%">密码更换</header>
    <!-- 表单选项 -->
    <form class="layui-form">
        <div class="layui-input-inline">
            <!-- 用户名 -->
            <div class="layui-inline" style="width: 85%">
                <input type="text" id="user" name="account" required  lay-verify="required" placeholder="请输入用户名" autocomplete="off" class="layui-input">
            </div>
            <!-- 对号 -->
            <div class="layui-inline">
                <i class="layui-icon" id="ri" style="color: green;font-weight: bolder;" hidden></i>
            </div>
            <!-- 错号 -->
            <div class="layui-inline">
                <i class="layui-icon" id="wr" style="color: red; font-weight: bolder;" hidden>ဆ</i>
            </div>
        </div>
        <!-- 密码 -->
        <div class="layui-input-inline">
            <div class="layui-inline" style="width: 85%">
                <input type="password" id="pwd" name="password" required  lay-verify="required" placeholder="请输入原始密码" autocomplete="off" class="layui-input">
            </div>
            <!-- 对号 -->
            <div class="layui-inline">
                <i class="layui-icon" id="pri" style="color: green;font-weight: bolder;" hidden></i>
            </div>
            <!-- 错号 -->
            <div class="layui-inline">
                <i class="layui-icon" id="pwr" style="color: red; font-weight: bolder;" hidden>ဆ</i>
            </div>
        </div>
        <!-- 确认密码 -->
        <div class="layui-input-inline">
            <div class="layui-inline" style="width: 85%">
                <input type="password" id="rpwd" name="repassword" required  lay-verify="required" placeholder="请输入修改密码" autocomplete="off" class="layui-input">
            </div>
            <!-- 对号 -->
            <div class="layui-inline">
                <i class="layui-icon" id="rpri" style="color: green;font-weight: bolder;" hidden></i>
            </div>
            <!-- 错号 -->
            <div class="layui-inline">
                <i class="layui-icon" id="rpwr" style="color: red; font-weight: bolder;" hidden>ဆ</i>
            </div>
        </div>
        <div class="layui-input-inline login-btn" style="width: 85%">
            <button type="submit" lay-submit lay-filter="sub" class="layui-btn">确认</button>
        </div>

        <hr style="width: 85%" />
        <p style="width: 85%"><a href="#" class="fl"></a><a href="${pageContext.request.getContextPath()}/" class="fr">立即登陆-></a></p>
    </form>

    <script type="text/javascript">
        //绑定全局的回车事件
        $(function(){
            document.onkeydown = function(e){
                var ev = document.all ? window.event : e;
                if(ev.keyCode==13) {
                    //$('.layui-btn').click();
                }
            }
            $("input[name='account']").focus();
        });

        $("input[name='account']").blur(function(){
            var name = $("input[name='account']").val();
            $.ajax({
                url: '${pageContext.request.getContextPath()}/checkName',
                dataType: 'json',
                async: false,
                data: {
                    name : name
                },
                type: 'POST', // 请求方式
                contentType: 'application/x-www-form-urlencoded; charset=utf-8',
                //请求完成时的处理
                success: function (ret) {
                    if(ret.code == 1) {
                        layer.msg('用户名不存在，请重新输入!');
                        $('#wr').removeAttr('hidden');
                        $('#ri').attr('hidden','hidden');
                    } else {
                        $('#ri').removeAttr('hidden');
                        $('#wr').attr('hidden','hidden');
                    }
                }
            });
        });

        $(".layui-btn").click(function(){
            var name = $("input[name='account']").val();
            var password = $("input[name='password']").val();
            var repassword = $("input[name='repassword']").val();
            layer.msg("di");
        });
        // 为密码添加正则验证
        $('#pwd').blur(function() {
            var reg = /^[\w]{3,12}$/;
            if(!($('#pwd').val().match(reg))){
                $('#pwr').removeAttr('hidden');
                $('#pri').attr('hidden','hidden');
                layer.msg('请输入合法密码');
            }else {
                $('#pri').removeAttr('hidden');
                $('#pwr').attr('hidden','hidden');
            }
        });
    </script>
</div>
</body>
</html>
