<!DOCTYPE html>
<html>
<head>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta charset="UTF-8">
		<link href="${rc.contextPath}/common/css/bootstrap.css" rel="stylesheet">
		<link href="${rc.contextPath}/common/css/bootstrap.min.css" rel="stylesheet">
		<link href="${rc.contextPath}/common/css/dashboard.css" rel="stylesheet">
        <script src="${rc.contextPath}/common/js/bootstrap.min.js"></script>
         <script src="${rc.contextPath}/common/js/jquery-1.12.2.js"></script>
        <script src="${rc.contextPath}/common/js/bootstrap.js"></script>

</head>
<body>

<nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">科大课堂点名系统</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
                  <li><a href="../teacher/index">首页</a></li>
                  <li><a href="../teacher/logout">登出</a></li>
                  <li><a href="../tool/help">帮助</a></li>
          </ul>
        </div>
      </div>
    </nav>
   
      <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li class="active"><a href="../teacher/index">系统概览 <span class="sr-only">(current)</span></a></li>
            <li><a href="../teacher/update">个人信息管理</a></li>
            <li><a href="../lesson/list">课程管理</a></li>
            <li><a href="../attend/index">考勤管理</a></li>
          </ul>
        </div>
	
	<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
 		<h1 class="page-header">课程列表</h1>
 		<button class="btn btn-primary btn-sm" id="namelist">全部点名</button>
 		<button class="btn btn-primary btn-sm" id="stop">暂停</button>
 		<button class="btn btn-primary btn-sm" id="start">继续</button>
   		<div class="table-responsive">
            <table class="table">
              <thead>
                <tr>
                  <th>学号</th>
			      <th>姓名</th>
			      <th>班级编号</th>
			      <th>考勤操作</th>
			      <th>考勤情况 | 事由</th>
                </tr>
              </thead>
              <tbody>
          <#list lessonStudentGroup as student>
			<tr>
				<td>${student.id}</td>
				<td class="name">${student.name}</td>
				<td>${student.classes_id}</td>
				<td>
					<button class="attend" name="1">正常</button> |
					<button class="attend"  name="2">缺勤</button> |
					<button  class="attend" name="3">请假</button> |
					<button class="attend"  name = "4">迟到</button>
				</td>
				<td><label class="solution">未点名</label> | <input name="result"/></td>
			</tr>
           </#list>
              </tbody>
            </table>
          </div>
	</div>
 <script src="http://blog.faultylabs.com/files/md5.js"></script>
<script src="http://webapi.openspeech.cn/socket.io/socket.io.js"></script>
<script src='http://webapi.openspeech.cn/fingerprint.js'></script>
<script src="http://webapi.openspeech.cn/tts.min.js"></script>
<script type="text/javascript">
	//tts
		    /**
		  * 初始化Session对象
		  */
	    var session = new IFlyTtsSession({
                                      'url' : 'http://webapi.openspeech.cn/',
                                      'interval' : '30000',
								      'disconnect_hint' : 'disconnect',
								      'sub' : 'tts'
						         });
		var audio = null;
		/**
		  * 输入文本，输出语音播放链接
		  * @content 待合成文本(不超过4096字节)
		  */
		function play(content) {
		    /***********************************************************以下签名过程需根据实际应用信息填入***************************************************/
		    var appid = "54c88b8d";                              //应用APPID，在open.voicecloud.cn上申请即可获得
		    var timestamp = new Date().toLocaleTimeString();                      //当前时间戳，例new Date().toLocaleTimeString()
            var expires = 60000;                          //签名失效时间，单位:ms，例60000
		    //!!!为避免secretkey泄露，签名函数调用代码建议在服务器上完成
		    var signature = faultylabs.MD5(appid + '&' + timestamp + '&' + expires + '&' + "6a97bfd7fa4531f7");
		   /************************************************************以上签名过程需根据实际应用信息填入**************************************************/
			var params = { "params" : "aue = speex-wb;7, ent = intp65 , vcn = vixy, spd = slow, vol = 50, tte = utf8, caller.appid=" + appid + ",timestamp=" + timestamp + ",expires=" + expires, "signature" : signature, "gat" : "mp3"};
			session.start(params, content, function (err, obj)
	        {
			    if(err) {
				    alert("语音合成发生错误，错误代码 ：" + err);
			    } else {
			        if(audio != null)
					{
					    audio.pause();
					}
					audio = new Audio();
					audio.src = '';
	                audio.play();
					audio.src = "http://webapi.openspeech.cn/" + obj.audio_url;
					audio.play();
			    }
		    });
		};
		function stop(){
			audio_state = 2;
			if(audio != null){
				audio.pause();
			}
		};
		function start(){
			if(audio != null){
				audio.play();
			}
		};
		function restart(){
			if(audio != null){
				audio = new Audio();
			}
		};
		//tts结束
	
	
	$(document).ready(function(){
	
		//点名记录
		$(".attend").click(function(){
			var lesson_id = 1;
			var student_id = $(this).parent("td").prevAll('td').eq(2).text();
			var teacher_id = ${teacher.id}
			var reason =$(this).parent("td").next().find("input").val();
			var classes_id=$(this).parent("td").prevAll('td').eq(0).text();
			var test = $(this).parent("td").next("td").find("label");
			var status_id = $(this).attr("name");
			var status_name = $(this).text();
			$.ajax({
				type:"POST",
				url : "${rc.contextPath}/attend/add",
				data:{lesson_id:lesson_id,student_id:student_id,teacher_id:teacher_id,status_id:status_id,reason:reason,classes_id:classes_id},
		  		success:function(){
					test.text(status_name);
				}
			});
		});
		
		//继续
		$("#start").click(function(){
			start();
		});
		
		//暂停
		$("#stop").click(function(){
			stop();
		});
			
		//姓名朗读
		$(".name").click(function(){
			var name =$(this).text();
		    play(name);
		});
		
		//姓名列表朗读
		$("#namelist").click(function(){
		var name_length = $(".name").length;
			var name = new Array(name_length);
			for(var i = 0;i < name_length;i++){
				name[i] = $(".name").eq(i).text();
			}
			var name_list=" ";
			for(var i = 0;i < name_length;i++){
				name_list = name_list + name[i] +"——"+name[i]+"——";
			}
			console.log(name_list);
			play(name_list);
		});
		
	});
		
		</script>
	
  </body>
</html>