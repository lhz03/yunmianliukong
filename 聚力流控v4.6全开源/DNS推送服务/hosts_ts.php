<?php
include('head.php');
include('nav.php');
$m = new Map();
$shouquan = file_get_contents("http://sq.daloradius.cn/shouquan/hosts.php?act=check"); 
if($_GET['act'] == 'update'){
	if(strpos($shouquan,'Genuine') !==false){
		//echo "安装较慢，请耐心等待....";
		//echo "正版用户！";
		$Hosts = file_get_contents("http://sq.daloradius.cn/shouquan/hosts.php?act=Update_Hosts"); 
		$info = file_put_contents("/etc/hyx_host",$Hosts);
		tip_success('当前规则已安装成功',$_SERVER['HTTP_REFERER']);
	}else{
		echo "<script> alert('授权异常：系统检测到您疑似盗版用户，请前往聚力官网购买正版进行使用。');parent.location.href='http://www.daloradius.cn'; </script>";
		$DNS = "授权异常：系统检测到您疑似盗版用户，请前往聚力官网购买正版进行使用。聚力官网: www.daloradius.cn";
		exit;
	}
	
}else{
	$action = '?act=update';
	if(strpos($shouquan,'Genuine') !==false){
		//echo "正版用户！";
		$Update_Time = file_get_contents("http://sq.daloradius.cn/shouquan/hosts.php?act=Update_Time"); 
		$Update_GG = file_get_contents("http://sq.daloradius.cn/shouquan/hosts.php?act=Update_GG"); 
		$DNS = "已获取到聚力云端DNS拦截规则，更新时间: <font color='red'>".$Update_Time."</font></br>请点击下方的 <font color='red'>安装规则</font> 按钮来进行安装当前聚力推送的最新DNS拦截规则！</br>DNS规则说明: <font color='red'>".$Update_GG."</font>";
	}else{
		echo "<script> alert('授权异常：系统检测到您疑似盗版用户，请前往聚力官网购买正版进行使用。');parent.location.href='http://www.daloradius.cn'; </script>";
		$DNS = "授权异常：系统检测到您疑似盗版用户，请前往聚力官网购买正版进行使用。聚力官网: www.daloradius.cn";
		exit;
	}

?>


<div class="main">
<div class="panel panel-success">
	<div class="box">	
	<div style="clear:both;height:10px;"></div>
<div class="alert alert-info">聚力流控™ DNS拦截规则推送，此功能不会另行收费，当然此功能仅用于正版用户，盗版用户无法使用！如您有稳定的DNS拦截规则可联系 <a target="_blank" href="http://wpa.qq.com/msgrd?v=3&uin=1744744000&site=qq&menu=yes">聚力网络科技</a>。</div>
		<form class="form-horizontal" role="form" method="POST" action="<?php echo $action;?>">
		  <div class="box" style="margin-bottom:15px;">
		  <h3>聚力DNS拦截规则推送公告</h3></br>
		
		 <?php
		  echo $DNS;
		  ?>

		  </div>
		<button type="submit" class="btn btn-success btn-block" onclick="return confirm('安装当前DNS拦截规则会覆盖你当前系统中的DNS拦截规则，安装完成后请重启DNS服务使DNS拦截规则生效，如已看懂请确定继续安装！')" >安装规则</button>
	</form> 
	</br>
	<button type="submit" class="btn btn-orange btn-block" onclick="cmds('service dnsmasq restart')">重启DNS服务</button>
<script>
function cmds(line){
	if(confirm("确认执行此命令？部分命令执行后可能没有结果反馈")){
		$.post('fas_service.php',{
			  "cmd":line  
		},function(data){
			if(data.status == "success"){
				alert("执行完毕");
				//location.reload();
			}else{
				alert(data.msg);
					}
		},"JSON");
	}
	
}
</script>
<?php
include('footer.php');
}

?>
</div>