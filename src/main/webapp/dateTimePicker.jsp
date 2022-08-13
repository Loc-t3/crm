<%--
  Created by IntelliJ IDEA.
  User: Hu
  Date: 2022/8/14
  Time: 6:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>日历插件测试页面</title>
<%--    jquery--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<%--    bootstrap--%>
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<%--    日历插件--%>
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"/>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"/>

<script type="text/javascript">
   $( function (){

   //    当容器加载完毕后，对容器进行调用工具函数
        $("#myDate").datetimepicker({

            language:"zh-CN",//
            format:'yyyy-mm-dd',
            minView:'month',
            initialDate:new Date(),
            autoclose:true, //当选择完毕日期后自动关闭日历插件
            todayBtn:true,// 是否显示今天的时间 默认为false
            clearBtn:ture,//显示清空按钮
        })

   })
</script>
</head>
<body>
<input type="text" id="myDate" readonly/>
</body>
</html>
