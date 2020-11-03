#!/bin/bash
rm -rf $0
unlock >/dev/null 2>&1
clear #清空屏幕

echo
echo -e "*********************************************"
echo -e "*        欢迎使用云端APP一键生成脚本        *"
echo -e "*********************************************"
echo
echo -e "使用本脚本必须先安装FAS流控"
echo -e ""
echo -e "\033[33m请回车确认执行\033[0m"
read -n1
clear 

wget_host="https://raw.githubusercontent.com/lenchanlhz/xiaolen/master/"


#获取用户输入的appkey

    echo
	read -p "请设置APP名称 (默认：fas云免)：" app_name
	if [ -z "$app_name" ];then
	app_name=fas云免
	fi
	echo -e "已设置APP名称为：\033[1;32m "$app_name"\033[0m"
	
	echo
	read -p "请设置WEB地址 (可输入域名或IP，不带http://)：" domain
	if [ -z "$domain" ];then
	domain=`curl -s http://members.3322.org/dyndns/getip`;
	fi
	echo -e "已设置WEB地址为：\033[1;32m "$domain"\033[0m"
	
	echo
	read -p "请设置WEB端口 (默认：1024)：" port
	if [ -z "$port" ];then
	port=1024
	fi
	echo -e "已设置WEB端口为：\033[1;32m "$port"\033[0m"
	
	echo
	read -p "请设置APP包名 (默认：net.dingd.vpn)：" app_baoming
	if [ -z "$app_baoming" ];then
	app_baoming=net.dingd.vpn
	fi
	echo -e "已设置APP包名为：\033[1;32m "$app_baoming"\033[0m"
	sleep 1
	echo
	echo "请稍等..."




file1="/home/wwwroot/default/"
file2="/data/www/default/Public/"
file3="/home/www/default/"
file4="/var/www/html/"
file5="/data/www/default/"

if test -f ${file1}index.php;then
	web_path=$file1
elif test -f ${file2}index.php;then
	web_path=$file2
elif test -f ${file3}index.php;then
	web_path=$file3
elif test -f ${file4}index.php;then
	web_path=$file4
elif test -f ${file5}index.php;then
	web_path=$file5
else 
    echo
	echo -e "系统未能检测到您的WEB目录，请手动输入："
	read web_path
		if test -d $web_path;then
		echo
			echo -e "已经确认WEB目录"
		else
		echo
			echo -e "抱歉！未能检测到该目录！请确认后重新执行本程序！"
		exit 0;
		fi
	fi
	echo
echo -e "你的流控目录为：$web_path"
chattr -R -i $web_path
chmod -R 0777 $web_path
	
function create_app()
{
echo
echo "正在制作APP..."
rm -rf /APP
mkdir /APP
cd /APP
wget -q ${wget_host}fas.apk&&wget -q ${wget_host}apktool.jar&&java -jar apktool.jar d fas.apk&&rm -rf fas.apk
sed -i 's/demo.dingd.cn:80/'${domain}:${port}'/g' `grep demo.dingd.cn:80 -rl /APP/fas/smali/net/openvpn/openvpn/`
sed -i 's/叮咚流量卫士/'${app_name}'/g' "/APP/fas/res/values/strings.xml"
sed -i 's/net.dingd.vpn/'${app_baoming}'/g' "/APP/fas/AndroidManifest.xml"
java -jar apktool.jar b fas
wget -q ${wget_host}signer.zip && unzip -o signer.zip >/dev/null 2>&1
mv /APP/fas/dist/fas.apk /APP/fas.apk
java -jar signapk.jar testkey.x509.pem testkey.pk8 /APP/fas.apk /APP/fas_sign.apk
cp -rf /APP/fas_sign.apk /var/www/html/app1.apk
rm -rf /APP
if [ ! -f /var/www/html/app1.apk ]; then
echo
echo -e "\033[1;33mAPP制作失败！\033[0m"
else
echo
echo -e "\033[1;34mAPP制作成功！\033[0m"
echo -e "APP下载地址：\033[1;32mhttp://${domain}:${port}/app1.apk\033[0m"
fi
}


create_app $domain $port $app_name $app_baoming
	
exit 0