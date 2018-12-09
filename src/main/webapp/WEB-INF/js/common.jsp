<!-- 导入JSTL标签 -->
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <!-- 引入静态文件 -->
    <script src="${pageContext.request.getContextPath()}/js/jquery.js" charset="utf-8"></script>
    <script src="${pageContext.request.getContextPath()}/layer/layui.js" charset="utf-8"></script>
    <link rel="stylesheet" href="${pageContext.request.getContextPath()}/layer/css/layui.css"  media="all">
    <link rel="stylesheet" href="${pageContext.request.getContextPath()}/static/css/style.css"  media="all">
    <!-- layer的初始化 -->
    <script type="text/javascript">
        $(function() {
            layui.use(['form', 'layedit', 'laydate'], function(){
                var layer = layui.layer,
                    layedit = layui.layedit,
                    laydate = layui.laydate;
            });
        });
    </script>
</head>
<body>

</body>
</html>
