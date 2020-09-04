/**
 * 
 */
var WebSocket_Url;
$(function(){
	$.ajax({
	      type : "post",  
	      async : false,
	      url : "td/AllTdbf",  
	      data : {},  
	      dataType : "json", //返回数据形式为json  
	      success : function(result) {
	          if (result) {
	        	  WebSocket_Url = result.web_socket;
	          }  
	      },
	      error : function(errorMsg) {  
	          alert("数据请求失败，请联系系统管理员!");  
	      }  
	});
})

function control(){
	document.getElementById("fm").style.display="none";
	document.getElementById("cfm").style.display="block";
	$('#dchanel').hide();//通道号
	$('#rchanel').hide();
	if(machineModel == 184){
		$('#newchanel').combobox('clear');
		$('#newchanel').combobox('loadData', {});//清空option选项   
		var str = "";
		var value = 1;
		for (var i = 0; i < 100; i++) {
			str += '<option value="' + i + '">通道号' + i + '</option>';
		}
		$('#newchanel').html(str);
		$('#newchanel').combobox('select', 0);
		$('#newchanel').combobox();
		$('#dchanel').show();//通道号
		$('#rchanel').show();
		return;
	}
}

function parameter(){
	document.getElementById("fm").style.display="block";
	document.getElementById("cfm").style.display="none";
}

function controlfun(){
	var pwdflag=0;
	var con = $("input[name='free']:checked").val();
	if(con.length<2){
		var length = 2 - con.length;
        for(var i=0;i<length;i++){
        	con = "0" + con;
        }
    };
	var machine;
	if(machga!=null){
		for(var q=0;q<machga.length;q++){
			if(machga[q].id==node11.id){
				if(machga[q].gatherId){
					machine = parseInt(machga[q].gatherId).toString(16);
					if(machine.length<4){
						var length = 4 - machine.length;
				        for(var i=0;i<length;i++){
				        	machine = "0" + machine;
				        };
				        break;
					}
				}else{
					alert("该焊机未对应采集编号!!!");
					websocket.close();
					return;
				}
			}
		}
	};
	if(machineModel == 184){
		var nchanel = parseInt($('#newchanel').combobox('getValue')).toString(16);
		if (nchanel.length < 2) {
			var length = 2 - nchanel.length;
			for (var i = 0; i < length; i++) {
				nchanel = "0" + nchanel;
			}
		}
		var xiafasend1 = machine+con+nchanel;
	}else{
		var xiafasend1 = machine+con;
	}
	var xxx = xiafasend1.toUpperCase();
	var data_length = ((parseInt(xxx.length)+12)/2).toString(16);
	if(data_length.length<2){
		var length = 2 - data_length.length;
        for(var i=0;i<length;i++){
        	data_length = "0" + data_length;
        }
    };
    xxx="7E"+data_length+"01010154"+xiafasend1;
    var check = 0;
	for (var i = 0; i < (xxx.length/2); i++)
	{
		var tstr1=xxx.substring(i*2, i*2+2);
		var k=parseInt(tstr1,16);
		check += k;
	}
	var checksend = parseInt(check).toString(16);
	var a2 = checksend.length;
	checksend = checksend.substring(a2-2,a2);
	checksend = checksend.toUpperCase();
	var xiafasend2 = (xxx+checksend).substring(2);
	
	var message = new Paho.MQTT.Message("7E" + xiafasend2 + "7D");
	message.destinationName = "webdatadown";
	client.send(message);
	var oneMinuteTimer = window.setTimeout(function() {
		if (pwdflag==0) {
			client.unsubscribe("webdataup", {
				onSuccess : function(e) {
					console.log("取消订阅成功");
				},
				onFailure : function(e) {
					console.log(e);
				}
			})
			alert("下发超时");
		}
	}, 3000);
	client.subscribe("webdataup", {
		qos: 0,
		onSuccess:function(e){  
            console.log("订阅成功");  
        },
        onFailure: function(e){  
            console.log(e);  
        }
	})
	client.onMessageArrived = function(e){
		console.log("onMessageArrived:" + e.payloadString);
		var fan = e.payloadString;
		if (fan.substring(0, 2) == "7E" && fan.substring(10, 12) == "54" && machine == fan.substring(12, 16)) {
			client.unsubscribe("webdataup", {
				onSuccess : function(e) {
					console.log("取消订阅成功");
				},
				onFailure : function(e) {
					console.log(e);
				}
			});
			pwdflag = 1;
			window.clearTimeout(oneMinuteTimer);
			if(parseInt(fan.substring(16,18),16)==1){
				alert("下发失败");
			}else{
				alert("下发成功");
			}
		}
	}
}

function passfun() {
	var pwdflag = 0;
	var con = parseInt($('#passwd').numberbox('getValue')).toString(16);
	if (con.length < 4) {
		var length = 4 - con.length;
		for (var i = 0; i < length; i++) {
			con = "0" + con;
		}
	}
	;
	var machine;
	if (machga != null) {
		for (var q = 0; q < machga.length; q++) {
			if (machga[q].id == node11.id) {
				if (machga[q].gatherId) {
					machine = parseInt(machga[q].gatherId).toString(16);
					if (machine.length < 4) {
						var length = 4 - machine.length;
						for (var i = 0; i < length; i++) {
							machine = "0" + machine;
						}
						;
						break;
					}
				} else {
					alert("该焊机未对应采集编号!!!");
					websocket.close();
					return;
				}
			}
		}
	}
	;
	var xiafasend1 = machine + con;
	var xxx = xiafasend1.toUpperCase();
	var data_length = ((parseInt(xxx.length) + 12) / 2).toString(16);
	if (data_length.length < 2) {
		var length = 2 - data_length.length;
		for (var i = 0; i < length; i++) {
			data_length = "0" + data_length;
		}
	}
	;
	xxx = "7E" + data_length + "01010153" + xiafasend1;
	var check = 0;
	for (var i = 0; i < (xxx.length / 2); i++) {
		var tstr1 = xxx.substring(i * 2, i * 2 + 2);
		var k = parseInt(tstr1, 16);
		check += k;
	}
	var checksend = parseInt(check).toString(16);
	var a2 = checksend.length;
	checksend = checksend.substring(a2 - 2, a2);
	checksend = checksend.toUpperCase();
	var xiafasend2 = (xxx + checksend).substring(2);
	
	var message = new Paho.MQTT.Message("7E" + xiafasend2 + "7D");
	message.destinationName = "webdatadown";
	client.send(message);
	var oneMinuteTimer = window.setTimeout(function() {
		if (pwdflag==0) {
			client.unsubscribe("webdataup", {
				onSuccess : function(e) {
					console.log("取消订阅成功");
				},
				onFailure : function(e) {
					console.log(e);
				}
			})
			alert("下发超时");
		}
	}, 3000);
	client.subscribe("webdataup", {
		qos: 0,
		onSuccess:function(e){  
            console.log("订阅成功");  
        },
        onFailure: function(e){  
            console.log(e);  
        }
	})
	client.onMessageArrived = function(e){
		console.log("onMessageArrived:" + e.payloadString);
		var fan = e.payloadString;
		if (fan.substring(0, 2) == "7E" && fan.substring(10, 12) == "53" && machine == fan.substring(12, 16)) {
			client.unsubscribe("webdataup", {
				onSuccess : function(e) {
					console.log("取消订阅成功");
				},
				onFailure : function(e) {
					console.log(e);
				}
			});
			pwdflag = 1;
			window.clearTimeout(oneMinuteTimer);
			if(parseInt(fan.substring(16,18),16)==1){
				alert("下发失败");
			}else{
				alert("下发成功");
			}
		}
	}
}

function openPassDlg(){
	$('#pwd').window( {
		title : "密码下发",
		modal : true
	});
	$('#pwd').window('open');
}