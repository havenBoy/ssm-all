<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 导入JSTL标签 -->
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>Insert title here</title>
	<!-- 引入静态文件 -->
	<script src="${pageContext.request.getContextPath()}/js/jquery.js" charset="utf-8"></script>
	<script src="${pageContext.request.getContextPath()}/layer/layui.js" charset="utf-8"></script>
	<link rel="stylesheet" href="${pageContext.request.getContextPath()}/layer/css/layui.css"  media="all">
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
    <h1 align="center">员工信息列表</h1>
    <table class="layui-hide" id="list" lay-filter="list"></table>
	<script type="text/html" id="toolbarDemo">
		<div class="layui-btn-container">
			<button class="layui-btn layui-btn-sm" lay-event="addCheckData">新增</button>
			<button class="layui-btn layui-btn-sm" lay-event="saveCheckData">修改</button>
			<button class="layui-btn layui-btn-sm" lay-event="delCheckData">删除</button>
		</div>
	</script>
	<script type="text/javascript">
        layui.use('table', function(){
            var table = layui.table;
            table.render({
                elem: '#list'
                ,url:'${pageContext.request.getContextPath()}/listPage'
                ,toolbar: '#toolbarDemo'
                ,cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
                ,parseData: function(res){ //res 即为原始返回的数据
                    return {
                        "code": res.code, //解析接口状态
                        "msg": res.msg, //解析提示文本
                        "count": res.count, //解析数据长度
                        "data": res.data //解析数据列表
                    };
                }
                ,cols: [[
                    {type: 'checkbox', fixed: 'right'}
                    ,{field:'id', title: 'ID', sort: true}
                    ,{field:'username', title: '用户名', edit: 'text'}
                    ,{field:'age', title: '年龄', edit: 'text'}
                    ,{field:'address', title: '地址',edit: 'text'}
                    ,{field:'desc', title: '描述',edit: 'text'}
                ]]
				,page: true
            });
            //头工具栏事件
            table.on('toolbar(list)', function(obj){
                var checkStatus = table.checkStatus(obj.config.id);
                var arr = checkStatus.data;
                switch(obj.event){
                    //修改员工信息
                    case 'saveCheckData':
                        if(arr.length > 1) {
                            layer.msg("只能修改一行数据哦");
						} else if(arr.length == 1){
                            $.ajax({
                                url: '${pageContext.request.getContextPath()}/saveUser',
                                dataType: 'json',
                                async: false,
                                data: {
                                    id : arr[0].id,
									name : arr[0].username,
									age : arr[0].age,
                                    address : arr[0].address,
									desc : arr[0].desc
                                },
                                type: 'POST', // 请求方式
                                contentType: 'application/x-www-form-urlencoded; charset=utf-8',
								//请求完成时的处理
                                success: function (data) {
                                    if(data == 0) {
                                        layer.msg("修改失败！");
									} else {
                                        layer.msg("修改成功！");
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
						} else {
                            layer.msg("没有选择数据哦");
						}
                        break;
                    case 'delCheckData':
                        var ids = "";
                        for (var i=0;i<arr.length;i++){
                            ids += arr[i].id + ",";
						}
						ids = ids.substr(0,ids.length-1);
						if(ids != "") {
                            $.ajax({
                                url: '${pageContext.request.getContextPath()}/delUser',
                                dataType:'json',
                                async:false,
                                data: {
                                    ids : ids
                                },
                                type: 'POST',   //请求方式
                                contentType: 'application/x-www-form-urlencoded; charset=utf-8',
                                success: function(data) {
                                    //请求成功时处理
                                    if(data == null ||  data == undefined) {
                                        layer.msg("删除失败！");
                                    } else if(data.code == 0 && data.count > 0){
                                        layer.msg("删除成功！",function() {
                                            window.location.href = '${pageContext.request.getContextPath()}/list';
										});
                                    }
                                },
                                error: function(s) {
                                    var old=s.error;
                                    var errHeader=s.errorHeader||'jumppay';
                                    var errMsg =  s.getResponseHeader(errHeader);
                                    window.location = errMsg;
                                    //请求出错处理
                                }
                            });
						} else {
                            layer.msg("请选择数据哦！");
						}
                        break;
					//新增员工
                    case 'addCheckData':
                        window.location.href = '${pageContext.request.getContextPath()}/openAdd';
                        break;
                };
            });
        });
	</script>
</body>
</html>