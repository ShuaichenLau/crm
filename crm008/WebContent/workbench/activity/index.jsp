<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="com.bjpowernode.crm.settings.qx.user.domain.User"
    %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">

	$(function(){
		
		//以下日历插件在FF中存在兼容问题，在IE浏览器中可以正常使用。
		/*
		$("#startTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
	        autoclose: true,
	        todayBtn: true,
	        pickerPosition: "bottom-left"
		});
		
		$("#endTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
	        autoclose: true,
	        todayBtn: true,
	        pickerPosition: "bottom-left"
		});
		*/
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		
		
		//给"创建"按钮添加单击事件
		$("#createActivityBtn").click(function(){
			$.ajax({
				url:'workbench/activity/createMarketActivity.do',
				type:'post',
				success:function(data){
					//设置所有者
					var htmlStr="";
					$.each(data,function(index,obj){
						if(obj.id=='${user.id}'){
							htmlStr+="<option value='"+obj.id+"' selected>"+obj.name+"</option>";
						}else{
							htmlStr+="<option value='"+obj.id+"'>"+obj.name+"</option>";
						}
					});
					$("#create-marketActivityOwner").html(htmlStr);
					//显示模态窗口
					$("#createActivityModal").modal("show");
				}
			});
		});
		
		//给"保存"按钮添加单击事件
		$("#saveCreateActivityBtn").click(function(){
			//收集参数
			var owner=$("#create-marketActivityOwner").val();
			var type=$("#create-marketActivityType").val();
			var name=$.trim($("#create-marketActivityName").val());
			var state=$("#create-marketActivityState").val();
			var startDate=$("#create-startDate").val();
			var endDate=$("#create-endDate").val();
			var budgetCost=$.trim($("#create-budgetCost").val());
			var actualCost=$.trim($("#create-actualCost").val());
			var description=$.trim($("#create-describe").val());
			//表单验证
			if(name==null||name.length==0){
				alert("名称不能为空！");
				return;
			}
			if(startDate!=null&&startDate.length>0&&endDate!=null&&endDate.length>0){
				if(startDate>endDate){//yyyy-MM-dd
					alert("结束日期不能比开始日期小！");
					return;
				}
			}
			var regExp=/^([1-9][0-9]*||0)$/;
			if(!regExp.test(budgetCost)){
				alert("预算成本只能为非负整数！");
				return;
			}
			if(!regExp.test(actualCost)){
				alert("实际成本只能为非负整数！");
				return;
			}
			//发送请求
			$.ajax({
				url:'workbench/activity/saveCreateMarketActivity.do',
				data:{
					owner:owner,
					type:type,
					name:name,
					state:state,
					startDate:startDate,
					endDate:endDate,
					budgetCost:budgetCost,
					actualCost:actualCost,
					description:description
				},
				type:'post',
				success:function(data){
					if(data.success){
						//关闭模态窗口
						$("#createActivityModal").modal("hide");
						//刷新列表
						display(1,5);
					}else{
						alert("创建失败！");
						$("#createActivityModal").modal("show");
					}
				}
			});
		});
		
		//当页面加载成功之后，显示第一页数据
		display(1,5);
		
		//给"查询"按钮添加单击事件
		$("#queryActivityBtn").click(function(){
			display(1,5);
		});
	});
	
	function display(pageNo,pageSize){
		$.ajax({
			url:'workbench/activity/queryMarketActivityForPage.do',
			data:{
				pageNo:pageNo,
				pageSize:pageSize,
				name:$.trim($("#query-name").val()),
				owner:$.trim($("#query-owner").val()),
				type:$("#query-type").val(),
				state:$("#query-state").val(),
				startDate:$.trim($("#query-startDate").val()),
				endDate:$.trim($("#query-endDate").val())
			},
			type:'post',
			success:function(data){
				//设置市场活动列表
				var htmlStr="";
				$.each(data.dataList,function(index,obj){
					htmlStr+="<tr>";
					htmlStr+="<td><input value='"+obj.id+"' type='checkbox' /></td>";
					htmlStr+="<td><a style='text-decoration: none; cursor: pointer;' onclick='window.location.href=\"detail.html\";'>"+obj.name+"</a></td>";
					htmlStr+="<td>"+obj.type+"</td>";
					htmlStr+="<td>"+obj.state+"</td>";
					htmlStr+="<td>"+obj.startDate+"</td>";
					htmlStr+="<td>"+obj.endDate+"</td>";
					htmlStr+="<td>"+obj.owner+"</td>";
					htmlStr+="<td>"+obj.budgetCost+"</td>";
					htmlStr+="<td>"+obj.actualCost+"</td>";
					htmlStr+="<td>"+obj.createBy+"</td>";
					htmlStr+="<td>"+obj.createTime+"</td>";
					htmlStr+="<td>"+obj.editBy+"</td>";
					htmlStr+="<td>"+obj.editTime+"</td>";
					htmlStr+="<td>"+obj.description+"</td>";
					htmlStr+="</tr>";
				});
				$("#activityListTBody").html(htmlStr);
				//设置总页数
				$("#totalCount").html(data.totalCount);
				//隔行换颜色
				$("#activityListTBody tr:even").addClass("active");
			}
		});
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
					<h4 class="modal-title" id="myModalLabel">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								  <!-- <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option> -->
								</select>
							</div>
							<label for="create-marketActivityType" class="col-sm-2 control-label">类型</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityType">
								  <option></option>
								  <c:if test="${not empty activityTypeList }">
								  	<c:forEach var="at" items="${activityTypeList }">
								  		<option value="${at.id }">${at.text }</option>
								  	</c:forEach>
								  </c:if>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-marketActivityName">
							</div>
							<label for="create-marketActivityState" class="col-sm-2 control-label">状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityState">
								  <option></option>
								  <c:if test="${not empty acitivityStatusList }">
								  	<c:forEach var="as" items="${acitivityStatusList }">
								  		<option value="${as.id }">${as.text }</option>
								  	</c:forEach>
								  </c:if>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-startDate">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-endDate">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-actualCost" class="col-sm-2 control-label">实际成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-actualCost">
							</div>
							<label for="create-budgetCost" class="col-sm-2 control-label">预算成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-budgetCost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveCreateActivityBtn" type="button" class="btn btn-primary">保存</button>
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
					<h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-marketActivityType" class="col-sm-2 control-label">类型</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityType">
								  <option></option>
								  <option>会议</option>
								  <option>web研讨</option>
								  <option>交易会</option>
								  <option>公开媒介</option>
								  <option>合作伙伴</option>
								  <option>推举程序</option>
								  <option selected>广告</option>
								  <option>条幅广告</option>
								  <option>直接邮件</option>
								  <option>邮箱</option>
								  <option>电子市场</option>
								  <option>其它</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
							</div>
							<label for="edit-marketActivityState" class="col-sm-2 control-label">状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityState">
								  <option></option>
								  <option>计划中</option>
								  <option selected>激活的</option>
								  <option>休眠</option>
								  <option>完成</option>
								</select>
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
							<label for="edit-actualCost" class="col-sm-2 control-label">实际成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-actualCost" value="4,000">
							</div>
							<label for="edit-budgetCost" class="col-sm-2 control-label">预算成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-budgetCost" value="5,000">
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
						请选择要上传的文件：<small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
					</div>
					<div style="position: relative;top: 40px; left: 50px;">
						<input type="file">
					</div>
					<div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
						<h3>重要提示</h3>
						<ul>
							<li>给定文件的第一行将视为字段名。</li>
							<li>请确认您的文件大小不超过5MB。</li>
							<li>从XLS/XLSX文件中导入全部重复记录之前都会被忽略。</li>
							<li>复选框值应该是1或者0。</li>
							<li>日期值必须为MM/dd/yyyy格式。任何其它格式的日期都将被忽略。</li>
							<li>日期时间必须符合MM/dd/yyyy hh:mm:ss的格式，其它格式的日期时间将被忽略。</li>
							<li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
							<li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
						</ul>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">导入</button>
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
		<div style="width: 130%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="query-type">
					  	  <option></option>
					      <c:if test="${not empty activityTypeList }">
					      	<c:forEach var="at" items="${activityTypeList }">
					      		<option value="${at.id }">${at.text }</option>
					      	</c:forEach>
					      </c:if>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">状态</div>
					  <select class="form-control" id="query-state">
					  	<option></option>
					    <c:if test="${not empty acitivityStatusList }">
					      	<c:forEach var="as" items="${acitivityStatusList }">
					      		<option value="${as.id }">${as.text }</option>
					      	</c:forEach>
					    </c:if>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="query-startDate" />
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="query-endDate">
				    </div>
				  </div>
				  
				  <button id="queryActivityBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createActivityBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal"><span class="glyphicon glyphicon-import"></span> 导入</button>
				  <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 导出</button>
				</div>
				
				<div class="btn-group" style="position: relative; top: 18%; left: 5px;">
					<button type="button" class="btn btn-default">添加字段</button>
					<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
						<span class="caret"></span>
						<span class="sr-only">Toggle Dropdown</span>
					</button>
					<ul id="definedColumns" class="dropdown-menu" role="menu"> 
						<li><a href="javascript:void(0);"><input type="checkbox"/> 名称</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 类型</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 状态</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 开始日期</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 结束日期</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 所有者</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 预算成本</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 实际成本</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 创建者</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 创建时间</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 修改者</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 修改时间</a></li>
						<li><a href="javascript:void(0);"><input type="checkbox"/> 描述</a></li>
					</ul>
				</div>

				<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
					<form class="form-inline" role="form">
					  <div class="form-group has-feedback">
					    <input type="email" class="form-control" style="width: 300px;" placeholder="支持任何字段搜索">
					    <span class="glyphicon glyphicon-search form-control-feedback"></span>
					  </div>
					</form>
				</div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>名称</td>
							<td>类型</td>
							<td>状态</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td>预算成本</td>
							<td>实际成本</td>
							<td>创建者</td>
							<td>创建时间</td>
							<td>修改者</td>
							<td>修改时间</td>
							<td width="10%">描述</td>
						</tr>
					</thead>
					<tbody id="activityListTBody">
						<!-- <tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
							<td>广告</td>
							<td>激活的</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td>5,000</td>
							<td>4,000</td>
							<td>zhangsan</td>
							<td>2017-01-18 10:10:10</td>
							<td>zhangsan</td>
							<td>2017-01-19 10:10:10</td>
							<td>发传单....</td>
						</tr>
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
							<td>广告</td>
							<td>激活的</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td>5,000</td>
							<td>4,000</td>
							<td>zhangsan</td>
							<td>2017-01-18 10:10:10</td>
							<td>zhangsan</td>
							<td>2017-01-19 10:10:10</td>
							<td>发传单....</td>
						</tr> -->
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalCount">50</b>条记录</button>
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
			</div>
			
		</div>
		
	</div>
</body>
</html>