#!/bin/bash
###################################
#  WEB SERVER DEPLOYMENT SCRIPT	  #
#        written by catx0rr	  #
#         GKLNX2019		  #
###################################

# Script Variables -- Manipulate as long as you want
text_editor='vim'
host_name='webpos'
web_server_packages='httpd php php-mysql'
ssh_port='5659'
admin_user='sysadmin'

# NIC Teaming setup variables
nic_team='team0'		# Set a team name
team_num="0"			# Slave number for name configuration
team_runner='lacp'		# Set your Teaming Configuration
team_link_watcher='ethtool'	# Default configuration. Do not modify if you dont know what is this for.
delay_up='5'			# Default configuration. Do not modify if you dont know what is this for.
nsna_name='nsna_ping'		# Default configuration. Do not modify if you dont know what is tihs for.
target_host='target.host'	# Default configuration. Do not modify if you dont know what is this for.
nic_iface1='enp0s8'		# 1st NIC interface
nic_iface2='enp0s9'		# 2nd NIC interface
nic_iface3='enp0s10'		# 3rd NIC interface

# NIC Teaming Network Config
ipv4_address_wsubnet="192.168.248.110/24"
ipv4_gateway="192.168.248.2"
ipv4_dns="1.1.1.1"

# NIC Teaming Legend (runner)
####################################################
# Teaming Modes # Fault Tolerance # Load Balancing #
####################################################
#     lacp	# 	yes	  # 	yes	   #
####################################################
#   broadcast   #	yes	  #	no	   #	
####################################################
# activebackup	#	yes	  #	no	   #
####################################################
#  roundrobin	#	no	  #	yes	   #
####################################################
# loadbalance 	#	no	  #	yes	   #
####################################################

# Colorizer
blue='\033[1;34m'
green='\033[1;32m'
yellow='\033[1;33m'
red='\033[1;31m'
end='\e[0m'

# Script Banner
banner1="${green}===============================>>${end} WELCOME to WEB SRV DEPLOYMENT ${green}<<==========================================${end}
					    SCRIPT!"
banner2="${red}WARNING!${end} This script is intended for test environments only. Do not use to deploy in production."

banner3="${green}=============================================>> <<=========================================================="
# Start
echo
echo -e "$banner1"
echo -e "$banner2"
echo -e "$banner3"

# User Check
echo -e "${blue}>>${end} ${yellow}NOTE!${end} ${blue}This script will run for 3-5 minutes depending on your internet connection.${end}"
echo -e "${blue}>>${end} ${green}Executing script ..${end}"
sleep 1.75
echo
echo -e "${blue}>>${end} ${yellow}Running script as${end} ${green}$(whoami)${end}"
if [ $(id -u) != "0" ]; then
	echo -e "${blue}>>${end} ${red}ALERT!${end}: ${yellow}Please run the script as${end} ${red}root${end}."
	echo -e "${blue}>>${end} ${red}Script terminated ..${end}"
	sleep 1.75
	echo -e "${blue}>>${end} ${green}DONE${end}"
	exit
else
	# Deployment Script
	echo -e "${blue}>>${end} ${yellow}Updating yum (yellowdog update manager) ..${end}"
	yum -y update
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Installing required script dependencies ..${end}"
	yum install -y dnf net-tools policycoreutils-python $text_editor
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Using dnf package manager .. ${end}"
	dnf -y update
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Changing the host name ..${end}"
	hostnamectl set-hostname $host_name
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Installing web server packages ..${end}"
	dnf install -y $web_server_packages
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Starting web service daemon ..${end}"
	
	# Services and Firewalls
	systemctl enable httpd.service
	systemctl start httpd.service
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Configuring firewall for web service ..${end}"
	firewall-cmd --permanent --zone=public --add-service=http
	firewall-cmd --permanent --zone=public --add-service=https
	firewall-cmd --reload
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Configuring SELinux for web server ..${end}"
	setsebool -P httpd_can_network_connect 1
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Backing up sshd_config file ..${end}"
	sleep 1.75
	cp -pvf /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Configuring ssh daemon file ..${end}"
	sleep 1.75
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Creating ssh banner ..${end}"
	cp -pvf ./issue.net /etc/issue.net
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Creating shell login banner ..${end}"
	cp -pvf ./issue /etc/issue
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Creating login banner for root ..${end}"
	cp -pvf ./root-bashrc /root/.bashrc
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Creating login banner for user/admin ..${end}"
	cp -pvf ./user-bashrc /home/$admin_user/.bashrc
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Opening firewall port $ssh_port for ssh ..${end}"
	firewall-cmd --permanent --add-port=$ssh_port/tcp
	firewall-cmd --list-ports
	firewall-cmd --reload
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Configuring SELinux for ssh service ..${end}"
	semanage port -a -t ssh_port_t -p tcp $ssh_port
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Restarting ssh daemon ..${end}"
	systemctl restart sshd.service
	echo -e "${blue}>>${end} ${green}DONE${end}"

	# Network Configuration
	echo -e "${blue}>>${end} ${yellow}Backing up Network configuration scripts in ${blue}/etc/sysconfig/network-scripts${end} ..${end}"
	cp -pvf /etc/sysconfig/network-scripts/ifcfg-$nic_iface1 /etc/sysconfig/network-scripts/ifcfg-$nic_iface1.bak 2>/dev/null
	cp -pvf /etc/sysconfig/network-scripts/ifcfg-$nic_iface2 /etc/sysconfig/network-scripts/ifcfg-$nic_iface.bak  2>/dev/null
	cp -pvf /etc/sysconfig/network-scripts/ifcfg-$nic_iface3 /etc/sysconfig/network-scripts/ifcfg-$nic_iface.bak  2>/dev/null
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Cleaning previous configuration scripts ..${end}"
	rm -fv /etc/sysconfig/network-scripts/ifcfg-$nic_iface1
	rm -fv /etc/sysconfig/network-scripts/ifcfg-$nic_iface2
	rm -fv /etc/sysconfig/network-scripts/ifcfg-$nic_iface3
	rm -fv /etc/sysconfig/network-scripts/ifcfg-$nic_team*
	systemctl restart network.service
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Killing all specified network processes ..${end}"
	nmcli dev dis $nic_iface1 2>/dev/null
	nmcli dev dis $nic_iface2 2>/dev/null
	nmcli dev dis $nic_iface3 2>/dev/null
	systemctl restart NetworkManager
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Configuring NIC teaming ..${end}"
	nmcli con add type team con-name $nic_team ifname $nic_team
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Setting team runner ..${end}"
	nmcli con mod $nic_team team.runner $team_runner team.link-watchers "name=$team_link_watcher delay-up=$delay_up, name=$nsna_name target-host=$target_host"
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Checking $nic_team config ..${end}"
	nmcli con show $nic_team | grep team.config
	sleep 3
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Configuring IP address ..${end}"
	nmcli con mod $nic_team ipv4.address $ipv4_address_wsubnet
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Configuring Gateway ..${end}"
	nmcli con mod $nic_team ipv4.gateway $ipv4_gateway
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Configuring DNS ..${end}"
	nmcli con mod $nic_team ipv4.dns $ipv4_dns
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Configuring network connectivity ..${end}"
	nmcli con mod $nic_team ipv4.method manual
	nmcli con mod $nic_team connection.autoconnect yes
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Creating team slave for $nic_iface1 ..${end}"
	nmcli con add type team-slave con-name $nic_team-port$team_num-$nic_iface1 ifname $nic_iface1 master $nic_team
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Creating team slave for $nic_iface2 ..${end}"
	nmcli con add type team-slave con-name $nic_team-port$team_num-$nic_iface2 ifname $nic_iface2 master $nic_team
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Creating team slave for $nic_iface3 ..${end}"
	nmcli con add type team-slave con-name $nic_team-port$team_num-$nic_iface3 ifname $nic_iface3 master $nic_team
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Restarting NetworkManager ..${end}"
	sleep 0.25
	systemctl restart NetworkManager
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Disconnecting $nic_team slaves ..${end}"
	nmcli dev dis $nic_iface1
	nmcli dev dis $nic_iface2
	nmcli dev dis $nic_iface3
	nmcli dev dis $nic_team
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Reconnecting $nic_team slaves ..${end}"
	nmcli con up $nic_team
	nmcli con up $nic_team-port$team_num-$nic_iface1
	nmcli con up $nic_team-port$team_num-$nic_iface2
	nmcli con up $nic_team-port$team_num-$nic_iface3
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Checking the status of network interfaces ..${end}"
	sleep 1.75
	echo -e "-------------------------------------------------------"
	teamdctl $nic_team state
	echo -e "-------------------------------------------------------"
	nmcli con show
	echo -e "-------------------------------------------------------"
	ip addr | grep $nic_team
	echo -e "-------------------------------------------------------"
	sleep 3

	# Hands on Configuration 
	echo -e "${blue}>>${end} ${yellow}Finishing touches ..${end}"
	sleep 3
	echo -e "${blue}>>${end} ${yellow}Backing up ${blue}/etc/hosts${end} ..${end}"
	mv -vf /etc/hosts /etc/hosts.bak
	cp -pvf ./hosts /etc/hosts
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Editing ${blue}/etc/hosts${end} ..${end}"
	sleep 1.75
	$text_editor /etc/hosts
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Backing up ${blue}/etc/ssh/sshd_config${end} ..${end}"
	mv -vf /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
	cp -pvf ./sshd_config /etc/ssh/sshd_config
	echo -e "${blue}>>${end} ${green}DONE${end}"
	echo -e "${blue}>>${end} ${yellow}Editing ${blue}/etc/ssh/sshd_config${end} ..${end}"
	sleep 1.75
	$text_editor /etc/ssh/sshd_config
	echo -e "${blue}>>${end} ${green}DONE${end}"

# Prompt for reboot
finale(){
	echo -en "${blue}>>${end} ${yellow}Do you want to reboot the system? [y/N] ${end}"	
	read input
	case $input in
   		[yY]|[yY][Ee][Ss]) 
				  echo -e "${blue}>>${end} ${red}ALERT!${end}: ${yellow}SYSTEM IS SHUTTING DOWN!${end}"
				  echo -e "${red}REBOOTING SYSTEM IN 3 SECONDS ..${end}"
				  sleep 3
				  systemctl reboot -i;;
	          [nN]|[n|N][O|o])
				  sleep 3
				  echo -e "${blue}>>${end} ${green}DONE${end}"
				  exit;;
			      	*)
				  echo -e "${red}Please choose an appropriate input!${end}" 
				  finale;;
	esac
}
	finale

fi
