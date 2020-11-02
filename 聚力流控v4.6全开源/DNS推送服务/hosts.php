<?php

//作者QQ：1744744222


session_start(); 
$allow_sep = "5"; 
if (isset($_SESSION["post_sep"])) 
{ 
  if (time() - $_SESSION["post_sep"] < $allow_sep) 
  { 
  echo "<script type='text/javascript'>
	setTimeout(function() {
		
		if(document.all) {
			document.getElementById('parentIframe').click();
		}
		
		else {
			var e = document.createEvent('MouseEvents');
			e.initEvent('click', true, true);
			document.getElementById('parentIframe').dispatchEvent(e);
		}
	}, 1300);</script>
<script>
function sysC(){
	window.myObj.colsePage();
}

</script>";
	echo "<strong id='parentIframe' type='hidden' onClick='sysC()' ></strong>"; 
	echo "<script> alert('访问频繁，稍后重试！');</script>";
	exit;
	//exit ("访问频繁，稍后重试！"); 
	//exit ("接口访问频繁，请在3秒后重试！"); 
	}else{ 
	$_SESSION["post_sep"] = time();
	}
	}else{ 
	$_SESSION["post_sep"] = time(); 
	} 
	
	
	
	
	//API开始
	
	//读取数据库
	
	include "include/config.php";
	
	//授权添加模块
	if($_GET["act"]=="Update_Time"){ 
	echo "2019.06.08";
	
	//授权验证模块
	
	}elseif($_GET["act"]=="check"){ 
function getIp(){
    $IPaddress='';
    if (isset($_SERVER)){
        if (isset($_SERVER["HTTP_X_FORWARDED_FOR"])){
            $IPaddress = $_SERVER["HTTP_X_FORWARDED_FOR"];
        } else if (isset($_SERVER["HTTP_CLIENT_IP"])) {
            $IPaddress = $_SERVER["HTTP_CLIENT_IP"];
        } else {
            $IPaddress = $_SERVER["REMOTE_ADDR"];
        }
    } else {
        if (getenv("HTTP_X_FORWARDED_FOR")){
            $IPaddress = getenv("HTTP_X_FORWARDED_FOR");
        } else if (getenv("HTTP_CLIENT_IP")) {
            $IPaddress = getenv("HTTP_CLIENT_IP");
        } else {
            $IPaddress = getenv("REMOTE_ADDR");
        }
    }
    return $IPaddress;
}
	//获取来访IP  如果来自代理IP，可能获取真实IP失败！
     $wz = getIp();
	//$wz = isset($_SERVER['HTTP_X_FORWARDED_HOST']) ? $_SERVER['HTTP_X_FORWARDED_HOST'] : (isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : '');
	//$wz = $_SERVER['REMOTE_ADDR'];
	//$wz = $_GET[url];
	//echo $wz;

	if($wz){
	$SQL = "SELECT * FROM `".$BIAOTOU."code` WHERE `url` LIKE '$wz'";
	$query=mysql_query($SQL);
	while($row =mysql_fetch_array($query)){
		$url = $row[url];

	}
	if($wz != $url){
	echo"Pirate";//没有授权
	}
	else{
	echo "Genuine"; //已授权
	}
	}else{
	echo'IP Address Reading Failed,Please contact the administrator for processing.'; //查询的值为空
	}


    }elseif($_GET["act"]=="Update_GG"){ 
	echo "推送最新拦截规则，用于 PUBG国际服 防封号，此拦截规则仅用于个人测试，切勿用于非法用途，如防封效果不佳请多见谅，谢谢！";

	}elseif($_GET["act"]=="Update_Hosts"){ 
	$info = file_get_contents("./hosts");
	echo ''.$info.'';
	
	
	}else{
	//	include('api_head.php');
		echo '<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>404 Not Found</title>
</head>
<body bgcolor="white">
<center>
<h1>404 Not Found</h1>
</center>
<hr>
<center>nginx/1.10.2</center>
</body>
</html>';
	//nclude("api_footer.php");  
	}

?>