<%@ page contentType="text/html;charset=UTF-8" language="java"  %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
/*动态获取文件的路径*/
String basepath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>

<html>
<head>
	<%-- 此处必须包含在 head 中	作为基础的路径为接下来的链接进行拼接--%>
	<base href="<%=basepath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

		<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
		<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){


		//创建 按钮的点击事件
		$("#createActivityBtn").click(function (){
			//初始化工作
			//重置表单
			// $("#createActivityForm").get(0).reset();
		//	任意js代码


			$("#createActivityModal").modal("show");

		});
		//保存 按钮的点击事件
		$("#savaCreateActivityBtn").click(function (){
		//	收集参数
		var owner = $("#create-marketActivityOwner").val();
			var name = $.trim($("#create-marketActivityName").val());
			var startDate = $.trim($("#create-startTime").val());
			var endDate = $.trim($("#create-endTime").val());
			var cost = $.trim($("#create-cost").val());
			var descrition = $.trim($("#create-descrition").val());
		//	表单验证
			if (owner==""){
				alert("所有者不能为空")
			}
			if (name==""){
				alert("名称不能为空")
			}
			if (startDate!=""&&endDate!=""){
			//	制定日期规范 开始 >结束
				if (endDate<startDate){
					alert("结束日期不能小于开始日期")
				}
			}
		//	正则表达式 验证成本值为正整数
			var RegNum = /^(([1-9]\d*)|0)$/;
			if (!RegNum.test(cost)){
				alert("成本只能为非负整数");
				return;
			}
			debugger;
		//	发送请求
			$.ajax({
				url:"workbench/activity/saveCreateActivity.do",
				data:{
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					descrition:descrition
				},
				type:'post',
				dataType:'json',
				async:false,
				success : function(r){
					if (r.code=="1"){

					//	关闭模态框
						$("#createActivityModal").modal("hide");
					}
					else {
					//	错误消息提示
						alert(r.message)
					//	模块窗口不关闭
						$("#createActivityModal").modal("show");
					}

				},
				error : function (r){

				}

			})



		});
		//    当容器加载完毕后，对容器进行调用工具函数
		// if ("input[name='myDate']").datetimepicker({
		$(".myDate").datetimepicker({
			language:"zh-CN",//
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true, //当选择完毕日期后自动关闭日历插件
			todayBtn:true,// 是否显示今天的时间 默认为false
			clearBtn:true,//显示清空按钮
		})


		//当市场活动主页面加载完成，查询所有数据的第一页以及所有数据的总条数,默认每页显示10条
		queryActivityByConditionForPage(1,10);


	//	给查询按钮添加单击事件
		$("#queryActivityBtn").click(function () {
		//	查询所有符合条件数据的第一页以及所有条件数据的总条数
			queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
		})
	//	给全选按钮添加单击事件

		$("#chckAll").click(function () {
			//	查询所有符合条件数据的第一页以及所有条件数据的总条数
			$("#tBody input[type='checkbox']").prop("checked",this.checked)
		})
	//	当列表全选后 给 全选按钮添加上勾选
		$("#tBody").on('click',"input[type='checkbox']",function () {
			if ($("#tBody input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
				$("#chckAll").prop("checked",true)
			}else{
				$("#chckAll").prop("checked",false)
			}
		})
	//	给删除按钮添加事件
		 	$('#deleteActivityBtn').click(function () {

			//	收集参数
			//	获取列表的所有被选中的checkbox
				var checkids = $("#tBody input[type='checkbox']:checked");
				if (checkids.size()==0){
					alert("请选择要删除的市场活动")
					return;
				}
				if (window.confirm("确定要删除吗？")){
					var ids =""
					$.each(checkids,function (){
						ids+="id="+this.value+"&";
					})
					ids = ids.substr(0,ids.length-1);
				//	发送请求
					 $.ajax({
						 url:"workbench/activity/DeleteActivityByids.do",
						 data:ids,
						 type:"post",
						 dataType:"json",
						 success:function (data){
							 if(data.code=="1"){
								 //刷新市场活动列表,显示第一页数据,保持每页显示条数不变
								 queryActivityByConditionForPage(1,10);
							 }else{
								 //提示信息
								 alert(data.message);
							 }
						 }


					 })

				}

			})

		
		
	});

	//	当活动主页面加载完成后 查询所有数据的第一页和所有数据的总条数
	function queryActivityByConditionForPage(pageNo,pageSize) {

		//	收集参数
		var name=$("#query-name").val();
		var owner = $("#query-owner").val();
		var startDate=$("#query-startDate").val();
		var endDate = $("#query-endDate").val();
		var pageNo = 1;
		var pageSize =10;
		//	发送请求
		$.ajax({
			url:"workbench/activity/queryActivityByConditionForPage.do",
			data:{
				name:name,
				owner:owner,
				startDate:startDate,
				endDate:endDate,
				pageNo:pageNo,
				pageSize:pageSize


			},
			type: "post",
			dataType: "json",
			success:function (r){
				//	显示总条数  将请求到的后台的返回数据赋值
				$("tatolRowB").text = r.totalRows;
				//遍历 acticityList 循环所有行数据  遍历js中的变量用$.each();   遍历作用域中的数据用el表达式的foreach
				//	js作为一个弱类型语言法则 可以实现方法中实现 function
				//	index 为each 循环的下标    obj循环变量 获取每次遍历的数据
				var htmlStr = "";
				$.each(r.activitieList,function (index,obj) {
					htmlStr+="<tr class=\"active\">";
					htmlStr+="	<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
					htmlStr+="	<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.html';\">"+obj.name+"</a></td>";
					htmlStr+="	<td>"+obj.owner+"</td>";
					htmlStr+="	<td>"+obj.startDate+"</td>";
					htmlStr+="	<td>"+obj.endDate+"</td>";
					htmlStr+="	</tr>";



				});
				// 在指定的标签中显示jsp页面片段
				//html（）  覆盖显示
				//append（）追加显示
				$("#tBody").html(htmlStr)
			//	当翻页时 对全选进行重新赋值
				$("#chckAll").prop("checked",false);

			//	计算总页数
				var totalPages =1;
				if(data.totalRows%pageSize==0){
					totalPages = data.totalRows/pageSize;
				}else{
					totalPages =data.totalRows/pageSize+1;
				}

				//对容器调用bs_pagination工具函数，显示翻页信息
				$("#demo_pag1").bs_pagination({
					currentPage:pageNo,//当前页号,相当于pageNo

					rowsPerPage:pageSize,//每页显示条数,相当于pageSize
					totalRows:data.totalRows,//总条数
					totalPages: totalPages,  //总页数,必填参数.

					visiblePageLinks:5,//最多可以显示的卡片数

					showGoToPage:true,//是否显示"跳转到"部分,默认true--显示
					showRowsPerPage:true,//是否显示"每页显示条数"部分。默认true--显示
					showRowsInfo:true,//是否显示记录的信息，默认true--显示

					//用户每次切换页号，都自动触发本函数;
					//每次返回切换页号之后的pageNo和pageSize
					onChangePage: function(event,pageObj) { // returns page_num and rows_per_page after a link has clicked
						//js代码
						//alert(pageObj.currentPage);
						//alert(pageObj.rowsPerPage);
						queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});



			}


		})

	}
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
									<c:forEach items="${userlist}" var="u">
										<option value="${u.id}" >${u.name}</option>

									</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" name="myDate" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" name="myDate" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-descrition" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-descrition"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="savaCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
								  <c:forEach items="${userlist}" var="u">
									  <option value="${u.id}" >${u.name}</option>

								  </c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >开始日期</div>
					  <input class="form-control" type="text" id="startTime" id="query-startDate"/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >结束日期</div>
					  <input class="form-control" type="text" id="endTime" id="query-endDate">
				    </div>
				  </div>
				  
				  <button  class="btn btn-default" id="queryActivityBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>

				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="chckAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			<div id="demo_pag1"></div>
			<%--<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="tatolRowB">50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>