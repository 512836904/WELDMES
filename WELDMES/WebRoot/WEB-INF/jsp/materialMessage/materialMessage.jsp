<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>物料管理</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">

<link rel="stylesheet" type="text/css" href="" />
<link rel="stylesheet" type="text/css" href="resources/themes/icon.css" />
<link rel="stylesheet" type="text/css" href="resources/css/datagrid.css" />
<link rel="stylesheet" type="text/css" href="resources/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="resources/css/base.css" />

<script type="text/javascript" src="resources/js/jquery.min.js"></script>
<script type="text/javascript" src="resources/js/jquery.easyui.min.js"></script>
<!-- <script type="text/javascript" src="resources/js/datagrid-detailview.js"></script> -->
<script type="text/javascript" src="resources/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="resources/js/easyui-extend-check.js"></script>
<script type="text/javascript" src="resources/js/materialMessage/materialMessage.js"></script>
<script type="text/javascript" src="resources/js/search/search.js"></script>
</head>

<body class="easyui-layout">
	<jsp:include  page="./materialList.jsp"/>
	<div region="center"  hide="true"  split="true">
		<div id="body">
			<div class="functiondiv">
				<div>
					<a href="javascript:addMaterial();" class="easyui-linkbutton" iconCls="icon-newadd">新增</a>&nbsp;&nbsp;&nbsp;&nbsp;
					 <a href="javascript:insertSearchEquipmentAppointment();" class="easyui-linkbutton" iconCls="icon-select">查找</a>
				</div>
			</div>	
			<div class="fitem">
				<lable>物料编码：</lable>
				<input class="easyui-textbox" id="code" readonly="readonly"/>
				<lable>物料名称：</lable>
				<input class="easyui-textbox" id="name" readonly="readonly"/>
				<lable>物料类型：</lable>
				<input class="easyui-textbox" id="materialType" readonly="readonly"/>
				<lable>存放位置：</lable>
				<input class="easyui-textbox" id="location" readonly="readonly"/>
			</div>
			<div class="fitem">
				<lable>库存：</lable>
				<input class="easyui-textbox" id="inventory" readonly="readonly"/>
				<lable>库存变动类型：</lable>
				<input class="easyui-textbox" id="inventoryChangeType" readonly="readonly"/>
				<lable>变动地址：</lable>
				<input class="easyui-textbox" id="changeAddress" readonly="readonly"/>
				<lable>数量：</lable>
				<input class="easyui-textbox" id="changeNumber" readonly="readonly"/>
			</div>
			<div class="fitem">
				<lable>入出库类型：</lable>
				<input class="easyui-textbox" id="putGetStorageType" readonly="readonly"/>
				<lable>变动时间：</lable>
				<input class="easyui-textbox" id="changeTime" readonly="readonly"/>
				<lable>订单号：</lable>
				<input class="easyui-textbox" id="changeOrder" readonly="readonly"/>
				<lable>供应商：</lable>
				<input class="easyui-textbox" id="supplierName" readonly="readonly"/>
			</div>
			
			<!-- <input type="hidden" id="parentId" name="parentId"> -->
			<table id="materialMessageTable" style="table-layout: fixed; width:100%;">
			
			</table>
			<!-- 自定义多条件查询 -->
			<div id="searchdiv" class="easyui-dialog"
				style="width:800px; height:400px;" closed="true"
				buttons="#searchButton" title="自定义条件查询">
				<div id="div0">
					<select class="fields" id="fields"></select> <select
						class="condition" id="condition"></select> <input class="content"
						id="content" /> <select class="joint" id="joint"></select> <a
						href="javascript:newSearchWeldingMachine();"
						class="easyui-linkbutton" iconCls="icon-add"></a> <a
						href="javascript:removeSerach();" class="easyui-linkbutton"
						iconCls="icon-remove"></a>
				</div>
			</div>
			<div id="searchButton">
				<a href="javascript:searchWeldingmachine();"
					class="easyui-linkbutton" iconCls="icon-ok">查询</a> <a
					href="javascript:close();" class="easyui-linkbutton"
					iconCls="icon-cancel">取消</a>
			</div>
			
			<div id="dlg" class="easyui-dialog" style="width: 500px; height: 650px; padding:10px 20px" closed="true" buttons="#dlg-buttons">
				<form id="fm" class="easyui-form" method="post"data-options="novalidate:true">
					<div class="fitem">
						<lable><span class="required">*</span>物料编码</lable>
						<input type="hidden" id="materialId" name="materialId">
						<input type="hidden" id="parentId" name="parentId">
						<input type="hidden" id="supplierId" name="supplierId">
						<input class="easyui-textbox" name="code" id="code_material" data-options="required:true" />
					</div>
					<div class="fitem">
						<lable><span class="required">*</span>物料名称</lable>
						<input class="easyui-textbox" name="name" id="name_material" data-options="required:true" />
					</div>
					<div class="fitem">
						<lable><span class="required">*</span>物料类型</lable>
						<select class="easyui-combobox" name="materialType" id="materialType_material"></select>
					</div>
					<div class="fitem" id="divparentId">
						<lable><span class="required">*</span>所属父级物料列表</lable>
						<select class="easyui-combobox" name="parentIdlist" id="parentIdlist"></select>
					</div>
					<div class="fitem">
						<lable><span class="required">*</span>存放位置</lable>
						<input class="easyui-textbox" name="location" id="location_material" data-options="required:true"/>
					</div>
					<div class="fitem">
						<lable><span class="required">*</span>库存</lable>
						<input class="easyui-textbox" name="inventory" id="inventory_material" data-options="required:true"/>
					</div>
					<div class="fitem">
						<lable><span class="required">*</span>库存变动类型</lable>
						<select class="easyui-combobox" name="inventoryChangeType" id="inventoryChangeType_material"></select>
					</div>
					<div class="fitem">
						<lable><span class="required">*</span>变动地址</lable>
						<input class="easyui-textbox" name="changeAddress" id="changeAddress_material" data-options="required:true"/>
					</div>
					<div class="fitem">
						<lable><span class="required">*</span>变动数量</lable>
						<input class="easyui-textbox" name="changeNumber" id="changeNumber_material" data-options="required:true"/>
					</div>
					<div class="fitem">
						<lable>订单号</lable>
						<input class="easyui-textbox" name="changeOrder" id="changeOrder_material"/>
					</div>
					<div class="fitem">
						<lable>入出库类型</lable>
						<select class="easyui-combobox" name="putGetStorageType" id="putGetStorageType_material"></select>
					</div>
					<div class="fitem">
						<lable><span class="required">*</span>入出库时间</lable>
						<input class="easyui-datetimebox" name="changeTime" id="changeTime_material" data-options="required:true"/>
					</div>
					<div class="fitem">
						<lable>单位</lable>
						<input class="easyui-textbox" name="unit" id="unit" data-options="required:true"/>
					</div>
					<div class="fitem">
						<lable>单价</lable>
						<input class="easyui-textbox" name="univalence" id="univalence" data-options="required:true"/>
					</div>
					<div class="fitem">
						<lable>总价</lable>
						<input class="easyui-textbox" name="totalPrices" id="totalPrices" data-options="required:true"/>
					</div>
				</form>
			</div>
			<div id="dlg-buttons">
				<a href="javascript:saveMaterial();" class="easyui-linkbutton"
					iconCls="icon-ok">保存</a> <a href="javascript:closeDialog('dlg');"
					class="easyui-linkbutton" iconCls="icon-cancel">取消</a>
			</div>
		</div>
	</div>
</body>
</html>
