function jiance() {
if [ ! -e "/dev/net/tun" ]; then
    echo
    echo -e "\033[1;32m安装出错\033[0m \033[5;31m[原因：系统存在异常！]\033[0m 
	\033[1;32m错误码：\033[31mVFVOL1RBUOiZmuaLn+e9keWNoeS4jeWtmOWcqA== \033[0m\033[0m"
	exit 0;
fi
if [ ! -f /bin/mv ]; then
	echo
	echo "\033[1;31m\033[05m 警告！检测到非法系统环境，请检查服务器或者重装系统后重试！错误码：bXbkuI3lrZjlnKg= \033[0m"
	exit
fi
if [ ! -f /bin/cp ]; then
	echo
	echo "\033[1;31m\033[05m 警告！检测到非法系统环境，请检查服务器或者重装系统后重试！错误码：Y3DkuI3lrZjlnKg= \033[0m"
	exit
fi
if [ ! -f /bin/rm ]; then
	echo
	echo "\033[1;31m\033[05m 警告！检测到非法系统环境，请检查服务器或者重装系统后重试！错误码：cm3kuI3lrZjlnKg= \033[0m"
	exit
fi
if [ ! -f /bin/ps ]; then
	echo
	echo "\033[1;31m\033[05m 警告！检测到非法系统环境，请检查服务器或者重装系统后重试！错误码：cHPkuI3lrZjlnKg= \033[0m"
	exit
fi
if [ -f /etc/os-release ];then
OS_VERSION=`cat /etc/os-release |awk -F'[="]+' '/^VERSION_ID=/ {print $2}'`
if [ $OS_VERSION != "7" ];then
echo
echo "警告！系统环境异常，当前系统为："$OS_VERSION" ，请更换系统为 CentOS 7.0-7.4 后重试！"
rm -rf $0 >/dev/null 2>&1
exit 0;
fi
elif [ -f /etc/redhat-release ];then
OS_VERSION=`cat /etc/redhat-release |grep -Eos '\b[0-9]+\S*\b' |cut -d'.' -f1`
if [ $OS_VERSION != "7" ];then
echo
echo "警告！系统环境异常，当前系统为："$OS_VERSION" ，请更换系统为 CentOS 7.0-7.4后重试！"
rm -rf $0 >/dev/null 2>&1
exit 0;
fi
else
echo
echo "警告！系统环境异常，当前系统为：未知 ，请更换系统为 CentOS 7.0-7.4 后重试！"
rm -rf $0 >/dev/null 2>&1
exit 0;
fi
if [ ! -f /etc/openvpn/auth_config.conf ]; then
	echo
	echo "\033[1;31m\033[05m 警告！系统检测到您还未搭建FAS系统，请前往(ml.fxgnt.cn)进行安装！ \033[0m"
	exit
fi
if [ ! -f /bin/FasAUTH.bin ]; then
	echo
	echo "\033[1;31m\033[05m 警告！系统检测到您还未搭建FAS系统，请前往(ml.fxgnt.cn)进行安装！ \033[0m"
	exit
fi
if [ ! -f /bin/rate.bin ]; then
	echo
	echo "\033[1;31m\033[05m 警告！系统检测到您还未搭建FAS系统，请前往(ml.fxgnt.cn)进行安装！ \033[0m"
	exit
fi
if [ ! -f /var/www/html/config.php ]; then
	echo
	echo "\033[1;31m\033[05m 警告！系统检测到您还未搭建FAS系统，请前往(ml.fxgnt.cn)进行安装！ \033[0m"
	exit
fi
if [ ! -f /bin/jk.sh ]; then
	echo
	echo "\033[1;31m\033[05m 警告！系统检测到您还未搭建FAS系统，请前往(ml.fxgnt.cn)进行安装！ \033[0m"
	exit
fi
if [ ! -f /bin/vpn ]; then
	echo
	echo "\033[1;31m\033[05m 警告！系统检测到您还未搭建FAS系统，请前往(ml.fxgnt.cn)进行安装！ \033[0m"
	exit
fi
}
function fuji() {
	clear
	echo
	read -p "请输入主机数据库账号：" fassqluser
	if [ -z "$fassqluser" ];then
	fassqluser=
	fi
	
	echo
	read -p "请输入主机数据库密码：" fassqlpass
	if [ -z "$fassqlpass" ];then
	fassqlpass=
	fi
	
	echo
	read -p "请输入主机数据库端口：" fassqlport
	if [ -z "$fassqlport" ];then
	fassqlport=
	fi
	
	echo
	read -p "请输入主机服务器IP：" fassqlip
	if [ -z "$fassqlip" ];then
	fassqlip=
	fi
	
	echo
	echo "正在为进行负载，请稍等..."
	sleep 3
	SQL_RESULT=`mysql -h${fassqlip} -P${fassqlport} -u${fassqluser} -p${fassqlpass} -e quit 2>&1`;
	SQL_RESULT_LEN=${#SQL_RESULT};
	if [[ !${SQL_RESULT_LEN} -eq 0 ]];then
	echo
	echo "连接主机数据库失败，请检查数据库密码后重试，脚本停止！";
	exit;
	fi

	rm -rf /etc/openvpn/auth_config.conf
	echo '#!/bin/bash
#兼容配置文件 此文件格式既可以适应shell也可以适应FasAUTH，但是这里不能使用变量，也不是真的SHELL文件，不要写任何shell在这个文件
#FAS监控系统配置文件
#请谨慎修改
#数据库地址
mysql_host='$fassqlip'
#数据库用户
mysql_user='$fassqluser'
#数据库密码
mysql_pass='$fassqlpass'
#数据库端口
mysql_port='$fassqlport'
#数据库表名
mysql_data=vpndata
#本机地址
address='$IP'
#指定异常记录回收时间 单位s 600即为十分钟
unset_time=600
#删除僵尸记录地址
del="/root/res/del"

#进程1监控地址
status_file_1="/var/www/html/openvpn_api/online_1194.txt 7075 1194 tcp-server"
status_file_2="/var/www/html/openvpn_api/online_1195.txt 7076 1195 tcp-server"
status_file_3="/var/www/html/openvpn_api/online_1196.txt 7077 1196 tcp-server"
status_file_4="/var/www/html/openvpn_api/online_1197.txt 7078 1197 tcp-server"
status_file_5="/var/www/html/openvpn_api/user-status-udp.txt 7079 53 udp"
#睡眠时间
sleep=3'>/etc/openvpn/auth_config.conf && chmod -R 0777 /etc/openvpn/auth_config.conf
rm -rf /var/www/html/config.php
echo '<?php
/* 本文件由系统自动生成 如非必要 请勿修改 */
define("_host_","'$fassqlip'");
define("_user_","'$fassqluser'");
define("_pass_","'$fassqlpass'");
define("_port_","'$fassqlport'");
define("_ov_","vpndata");
define("_openvpn_","openvpn");
define("_iuser_","iuser");
define("_ipass_","pass");
define("_isent_","isent");
define("_irecv_","irecv");
define("_starttime_","starttime");
define("_endtime_","endtime");
define("_maxll_","maxll");
define("_other_","dlid,tian");
define("_i_","i");'>/var/www/html/config.php && chmod -R 0777 /var/www/html/config.php
	systemctl stop mariadb.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告，MariaDB停止失败，请手动停止MariaDB查看失败原因，脚本停止！"
	exit
	fi
	
	sleep 5
	echo
	echo "已成功进行负载，主机IP为："$fassqlip"！"
}
function zhuji() {
	clear
	echo
	read -p "请输入本机数据库账号：" fassqluser
	if [ -z "$fassqluser" ];then
	fassqluser=
	fi
	
	echo
	read -p "请输入本机数据库密码：" fassqlpass
	if [ -z "$fassqlpass" ];then
	fassqlpass=
	fi
	
	echo
	read -p "请输入本机数据库端口：" fassqlport
	if [ -z "$fassqlport" ];then
	fassqlport=
	fi
	
	echo
	echo "正在进行负载，请稍等..."
	sleep 3
	SQL_RESULT=`mysql -hlocalhost -P${fassqlport} -u${fassqluser} -p${fassqlpass} -e quit 2>&1`;
	SQL_RESULT_LEN=${#SQL_RESULT};
	if [[ !${SQL_RESULT_LEN} -eq 0 ]];then
	echo
	echo "数据库连接失败，请检查您的数据库密码后重试，脚本停止！";
	exit;
	fi
	
	iptables -A INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
	service iptables save >/dev/null 2>&1
	systemctl restart iptables.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告，IPtables重启失败，请手动重启IPtables查看失败原因，脚本停止！"
	exit
	fi
	mysql -hlocalhost -P${fassqlport} -u${fassqluser} -p${fassqlpass} <<EOF
grant all privileges on *.* to '${fassqluser}'@'%' identified by '${fassqlpass}' with grant option;
flush privileges;
EOF
	systemctl restart mariadb.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告，MariaDB重启失败，请手动重启MariaDB查看失败原因，脚本停止！"
	exit
	fi
	
	sleep 5
	echo
	echo "已成功进行负载，您可以在任何搭载FAS系统机器上对接至本服务器！"
	
}
function menufuzai() {
	clear
	sleep 2
	echo
	echo -e "************************************************"
	echo -e "           欢迎使用FAS系统快速负载助手          "
	echo -e "************************************************"
	echo -e "请选择："
	echo
	echo -e "\033[36m 1.主机开启远程数据库权限 \033[0m \033[31m（在主机执行，主机只需开启一次，后续直接副机对接主机即可）\033[0m"
	echo ""
	echo -e "\033[36m 2.副机连接主机数据库 \033[0m \033[31m（在负载机执行，每个机子无限负载主机，仅生效最后一次负载的机器）\033[0m"
	echo
	echo -e "\033[36m 3.退出脚本\033[0m"
	echo
	echo 
	read -p " 请输入安装选项并回车：" a
	echo
	echo
	k=$a

	if [[ $k == 1 ]];then
	zhuji
	exit;0
	fi
	
	if [[ $k == 2 ]];then
	fuji
	exit;0
	fi

	if [[ $k == 3 ]];then
	exit;0
	fi	
	
	echo -e "\033[31m 输入错误，请重新运行脚本！\033[0m "
	exit;0
}
function logo() {
clear
echo "请问作者帅不帅？"
echo " 1.帅"
echo " 2.非常帅"
echo
read -p " 请选择：" a
echo
k=$a

if [[ $k == 1 ]];then
clear
sleep 2
echo "--------------------欢迎使用FAS系统负载管理脚本-------------------------"
echo "                                                                        "
echo "   本脚本仅适用于学习与研究等个人用途，请勿用于任何违法国家法律的活动   "
echo "                                                                        "
echo "-------------------------同意 请回车继续--------------------------------"
read
menufuzai
fi

if [[ $k == 2 ]];then
clear
sleep 2
echo "--------------------欢迎使用FAS系统负载管理脚本-------------------------"
echo "                                                                        "
echo "   本脚本仅适用于学习与研究等个人用途，请勿用于任何违法国家法律的活动   "
echo "                                                                        "
echo "-------------------------同意 请回车继续--------------------------------"
read
menufuzai
fi

sleep 2
echo -e "\033[31m 说我不帅的你就别想着负载了！\033[0m "
reboot
exit;0
}
function main() {
rm -rf $0 >/dev/null 2>&1
clear 
echo
echo "正在为脚本运行做准备..."
sleep 5 
echo
echo "正在检查安装环境 (预计三分钟内完成)..."
sleep 3
jiance
yum -y install curl wget openssl >/dev/null 2>&1
logo
}
main
exit;0
