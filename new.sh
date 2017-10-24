#!/bin/sh
#OpenVPN-56mini-53
openvpnroute="/etc/openvpn/";
app="/root/app.tar.gz";
vpnport=53
clear
echo ".........................................................."
echo "                   OpenVpn53端口一键脚本                  "
echo ".........................................................."
echo "开始安装!!! y安装/n卸载 ？"
echo -e -n "[输入 y/n]：" 
read openvpn
if [ "$openvpn" = "y" ];then
echo "输入公网IP地址或者动态域名（回车默认自动获取当前网络公网IP）"
echo -n "[输入]：" 
read ip 
if [[ -z $ip ]] 
then 
echo  "已设置IP `curl -s http://ipecho.net/plain`;" 
ip=`curl -s http://ipecho.net/plain`;
else 
echo "已设置IP/动态域名：$ip"
fi 
echo
if [ -f $app ]; then
	echo -e "检测到root目录下app.tar.gz文件,开始解压"
	cd /root
	tar -xvzf app.tar.gz > /dev/null 2>&1
	sleep 1
	else
	echo -e "没有检测到root目录下app.tar.gz文件,脚本退出"
	sleep 1
	exit
fi
echo
echo "替换源，某些系统的源没有openvpn包会导致openvpn安装失败"
echo "openvpn安装失败将无法启动，重新执行脚本 卸载后再选择你的系统版本替换源"
echo
echo "选择系统及版本 <不输入数字回车，脚本默认将不替换源继续执行>"
echo "1.centos5-32位 2.centos5-64位 3.centos6-32位 4.centos6-64位"
echo -e -n "[输入 1/2/3/4] 单选 ？：" 
read yuan
if [ "$yuan" = "1" ];then
echo "已选择centos5-32位"
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
mv /root/Centos-5.repo /etc/yum.repos.d/CentOS-Base.repo
cd /root
rpm -ivh epel-release-5-4.noarch-i386.rpm > /dev/null 2>&1
#sed -i '/mirrorlist=https/d' /etc/yum.repos.d/epel.repo
sed -i 's/#//g' /etc/yum.repos.d/epel.repo
sed -i '/mirrorlist/s/^/#&/' /etc/yum.repos.d/epel.repo
yum clean all
yum makecache
fi
if [ "$yuan" = "2" ];then
echo "已选择centos5-64位"
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
mv /root/Centos-5.repo /etc/yum.repos.d/CentOS-Base.repo
cd /root
rpm -ivh epel-release-5-4.noarch-x86_64.rpm > /dev/null 2>&1
#sed -i '/mirrorlist=https/d' /etc/yum.repos.d/epel.repo
sed -i 's/#//g' /etc/yum.repos.d/epel.repo
sed -i '/mirrorlist/s/^/#&/' /etc/yum.repos.d/epel.repo
yum clean all
yum makecache
fi
if [ "$yuan" = "3" ];then
echo "已选择centos6-32位"
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
mv /root/Centos-6.repo /etc/yum.repos.d/CentOS-Base.repo
cd /root
rpm -ivh epel-release-6-8.noarch-i386.rpm > /dev/null 2>&1
#sed -i '/mirrorlist=https/d' /etc/yum.repos.d/epel.repo
sed -i 's/#//g' /etc/yum.repos.d/epel.repo
sed -i '/mirrorlist/s/^/#&/' /etc/yum.repos.d/epel.repo
yum clean all
yum makecache
fi
if [ "$yuan" = "4" ];then
echo "已选择centos6-64位"
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
mv /root/Centos-6.repo /etc/yum.repos.d/CentOS-Base.repo
cd /root
rpm -ivh epel-release-6-8.noarch-x86_64.rpm > /dev/null 2>&1
#sed -i '/mirrorlist=https/d' /etc/yum.repos.d/epel.repo
sed -i 's/#//g' /etc/yum.repos.d/epel.repo
sed -i '/mirrorlist/s/^/#&/' /etc/yum.repos.d/epel.repo
yum clean all
yum makecache
fi
echo
echo -e "正在更新YUM........"
#yum update -y 
sleep 1
echo "正在安装OpenVPN"
yum remove openvpn -y > /dev/null 2>&1
rm -rf /etc/openvpn
mkdir /etc/openvpn
mkdir /root/53
yum install openvpn -y 
sleep 2
echo -e "安装证书"
mkdir /etc/openvpn/keys
mkdir /etc/openvpn/log
cd /etc/openvpn/keys/
cp /root/keys.tar.gz /etc/openvpn/keys > /dev/null 2>&1
if [ -f keys.tar.gz ]; then
	echo -e "复制成功"
	else
	echo -e "复制失败请检查权限"
	exit
fi
tar -xvzf keys.tar.gz > /dev/null 2>&1
echo -e "安装认证脚本"
mkdir /etc/openvpn/author
cd /etc/openvpn/author/
cp /root/logins.sh /etc/openvpn/author > /dev/null 2>&1
if [ -f logins.sh ]; then
	echo -e "复制成功"
	else
	echo -e "复制失败请检查权限"
	exit
fi
chmod +x /etc/openvpn/author/logins.sh
echo -e "安装用户管理脚本"
mkdir /etc/openvpn/user
touch /etc/openvpn/passwd.txt
cd /etc/openvpn/user/
cp /root/useradd.sh /etc/openvpn/user > /dev/null 2>&1
if [ -f useradd.sh ]; then
	echo -e "复制成功"
	else
	echo -e "复制失败请检查权限"
	exit
fi
chmod +x /etc/openvpn/user/useradd.sh
chmod +x /etc/openvpn/passwd.txt
cd /root
ln -s /etc/openvpn/user/useradd.sh user > /dev/null 2>&1
echo
echo -e "正在写入服务端配置文件"
echo 'port 53
proto udp
dev tun
ca /etc/openvpn/keys/ca.crt
cert /etc/openvpn/keys/server.crt
key /etc/openvpn/keys/server.key
dh /etc/openvpn/keys/dh1024.pem
ifconfig-pool-persist /etc/openvpn/log/ipp.txt
server 10.10.0.0 255.255.255.0
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 114.114.114.114"
push "dhcp-option DNS 61.139.2.69"
client-to-client
keepalive 10 120
comp-lzo no
max-clients 50
persist-key
persist-tun
status /etc/openvpn/log/openvpn-status.log
log /etc/openvpn/log/openvpn.log
log-append /etc/openvpn/log/openvpn.log
verb 3
script-security 3
auth-user-pass-verify /etc/openvpn/author/logins.sh via-env
client-cert-not-required
username-as-common-name' >> /etc/openvpn/my-vpn.conf
echo
echo -n "添加一个VPN帐号（回车默认添加test帐号）：" 
read user
if [[ -z $user ]] 
then 
echo  "已设置VPN帐号：test" 
user=test
sed -i '/'"$user"'/d' /etc/openvpn/passwd.txt
else 
echo "已设置VPN帐号：$user"
sed -i '/'"$user"'/d' /etc/openvpn/passwd.txt
fi 
echo
echo -n "设置$user帐号密码（回车默认密码为text123456）：" 
read passwd
if [[ -z $passwd ]] 
then 
echo  "已设置$user帐号密码：test123456" 
passwd=test123465
else 
echo "已设置$user帐号密码：$passwd"
fi 
echo -e "添加帐号密码到配置文件"
echo "$user $passwd" >>/etc/openvpn/passwd.txt
echo "添加完成"
service openvpn restart
echo 
echo -e "生成OpenVPN客户端配置文件"
echo "client 
tls-client 
dev tun
proto udp
remote $ip $vpnport
resolv-retry infinite 
nobind
<ca>
`cat /etc/openvpn/keys/ca.crt`
</ca>
comp-lzo no 
persist-tun 
persist-key 
auth-user-pass
verb 3" >/root/53/$user.ovpn
echo
sleep 1
echo 'net.ipv4.ip_forward=1' >/etc/sysctl.conf
	echo "正在配置防火墙..."
	service stop iptables > /dev/null 2>&1
	service start iptables > /dev/null 2>&1
	iptables -F  > /dev/null 2>&1
	sleep 1
	setenforce 0 > /dev/null 2>&1
	echo 1 > /proc/sys/net/ipv4/ip_forward 
	iptables -F > /dev/null 2>&1
	iptables -t nat -F POSTROUTING > /dev/null 2>&1
	iptables -t nat -A POSTROUTING -s 10.10.0.0/24 -o eth0 -j MASQUERADE > /dev/null 2>&1
	iptables -t nat -A POSTROUTING -s 10.10.0.0/24 -j SNAT --to-source $ip > /dev/null 2>&1
	iptables -A INPUT -p tcp -m tcp --dport $vpnport -j ACCEPT  > /dev/null 2>&1
	iptables -A INPUT -p udp -m udp --dport $vpnport -j ACCEPT  > /dev/null 2>&1
	service iptables save > /dev/null 2>&1
	service iptables restart > /dev/null 2>&1
	echo "防火墙配置完成"
	sleep 1
echo "删除多余文件"
cd /root
rm -rf 53.zip Centos-6.repo Centos-5.repo epel-release-6-8.noarch-i386.rpm epel-release-5-4.noarch-i386.rpm epel-release-6-8.noarch-x86_64.rpm epel-release-5-4.noarch-x86_64.rpm keys.tar.gz logins.sh useradd.sh app.tar.gz new.sh > /dev/null 2>&1
service openvpn stop > /dev/null 2>&1
echo "启动Openvpn服务"
service openvpn start > /dev/null 2>&1
service openvpn restart > /dev/null 2>&1
sleep 1
clear 
echo "......................................................................."
echo "                         OpenVpn53端口一键脚本                         "
echo "                                                                       "
echo "      OpenVPN端口$vpnport   默认添加的帐号$user  密码$passwd           "
echo "                                                                       "
echo "      添加用户命令  ./user     添加多个用户可使用同客户端配置文件登录  "
echo "                                                                       "
echo "      客户端配置文件地址/root/$user.ovpn   配置文件可多不同用户登录    "
echo "......................................................................."
fi 
echo
if [ "$openvpn" == "n" ]; then
clear
echo -e "正在停止服务"
service openvpn stop > /dev/null 2>&1
echo -e "开始卸载OpenVPN"
	rpm -e openvpn > /dev/null 2>&1
	yum remove openvpn > /dev/null 2>&1
sleep 1
echo -e "删除残留文件夹以及配置"
	rm -f /root/user > /dev/null 2>&1
	rm -rf /root/53 > /dev/null 2>&1
	rm -rf /etc/openvpn > /dev/null 2>&1
	rm -rf /root/new.sh > /dev/null 2>&1
	rm -rf /root/app.tar.gz > /dev/null 2>&1
	cd /root
	service start iptables > /dev/null 2>&1
	iptables -F  > /dev/null 2>&1
	service iptables save > /dev/null 2>&1
	service stop iptables > /dev/null 2>&1
sleep 1
fi 
exit 