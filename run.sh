#!/bin/bash

pkgname=dnscrypt-proxy
march=`lscpu | grep Ar | awk '{print $2}'`
pkgver=(`curl --no-progress-meter \
https://github.com/DNSCrypt/dnscrypt-proxy/releases/latest/|\
cut -d/ -f8 | cut -d\" -f1`)

title()
{
	echo -e "--------------------------------------"
	echo -e "| Hardened-Anonymized-DNSCrypt-Proxy |"
	echo -e "| Wipe Snoopers Out Of Your Networks |"
	echo -e "|      Creator : BL4CKH47H4CK3R      |"
	echo -e "--------------------------------------"
}
	
if ! [[ ${UID} == 0 ]]
then
	clear && title
	echo -e "--------------------------------------"
	echo -e "| Please Execute This With Privilege |"
	echo -e "--------------------------------------"

else	
	clear && title
	echo -e "----------------------------"
	echo -e "| [1] Configure DNSCrypt   |"
	echo -e "| [2] Deconfigure DNSCrypt |"
	echo -e "| [3] Update Configuration |"
	echo -e "| [4] Check Service Status |"
	echo -e "----------------------------"
	read -p "[*] Enter Choice [1, 2, 3, 4]: " input
	
	if [[ ${input} == 1 ]]
	then
		clear && title
		echo -e "------------------------------------"
		echo -e "| Installing Latest DNSCrypt-Proxy |"
		echo -e "------------------------------------"

		if [[ ${march} == "aarch64" ]]
		then
			curl -OLC - "https://github.com/DNSCrypt/${pkgname}/releases/download/${pkgver}/${pkgname}-linux_arm64-${pkgver}.tar.gz"
		else
			curl -OLC - "https://github.com/DNSCrypt/${pkgname}/releases/download/${pkgver}/${pkgname}-linux_${march}-${pkgver}.tar.gz"
		fi

		tar xf *tar*
		mv *linux*/${pkgname} /usr/bin/
		rm -rf *tar* *linux*

		echo -e "--------------------------------------"
		echo -e "| Disabling SystemD-Resolved Service |"
		echo -e "--------------------------------------"
		systemctl daemon-reload && systemctl disable --now systemd-resolved -f
			
		echo -e "---------------------------------------------------"
		echo -e "| Initializing Hardened-Anonymized-DNSCrypt-Proxy |"
		echo -e "---------------------------------------------------"
		cp -rf *service* *socket* /usr/lib/systemd/system/
		systemctl daemon-reload && systemctl enable --now ${pkgname}.{service,socket} -f

		echo -e "--------------------------------------------------------------"
		echo -e "| Applying Hardened-Anonymized-DNSCrypt-Proxy Configurations |"
		echo -e "--------------------------------------------------------------"
		rm -rf /etc/${pkgname} && mkdir /etc/${pkgname}
		touch /etc/dnscrypt-proxy/{allowed,blocked}-{ips,names}.txt
		cp -rf ${pkgname}.toml /etc/${pkgname}
		
		echo -e "-------------------------------------------"
		echo -e "| Configuring & Restarting NetworkManager |"
		echo -e "-------------------------------------------"
		rm -rf /etc/*resolv*
		rm -rf /etc/NetworkManager/conf.d/*
		rm -rf /var/lib/NetworkManager/*conf*
		rm -rf /etc/NetworkManager/*NetworkManager*
		echo -e "[main]\ndns=none\n" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "[device]\nwifi.scan-rand-mac-address=yes" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "ethernet.cloned-mac-address=random" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "wifi.cloned-mac-address=random" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "[connectivity]\n.set.enabled=false" >> /var/lib/NetworkManager/NetworkManager-intern.conf
		echo -e "nameserver 127.0.0.1\noptions edns0 single-request-reopen" > /etc/resolv.conf
		systemctl daemon-reload && systemctl disable --now NetworkManager-{dispatcher,wait-online} -f
		systemctl daemon-reload && systemctl restart --now NetworkManager -f
					
		echo -e "--------------------------------------"
		echo -e "| Hardened-Anonymized-DNSCrypt-Proxy |"
		echo -e "|     Successfully Configured !      |"
		echo -e "--------------------------------------"
							
	elif [[ ${input} == 2 ]]
	then
		clear && title
		echo -e "------------------------------------------------"
		echo -e "| Disabling Hardened-Anonymized-DNSCrypt-Proxy |"
		echo -e "------------------------------------------------"
		systemctl daemon-reload && systemctl disable --now ${pkgname}.{service,socket} -f

		echo -e "-------------------------------"
		echo -e "| Uninstalling DNSCrypt-Proxy |"
		echo -e "-------------------------------"
		rm -rf /usr/bin/${pkgname}
		rm -rf /usr/lib/systemd/system/${pkgname}.{service,socket}
		
		echo -e "---------------------------------------------------------------"
		echo -e "| Reverting Hardened-Anonymized-DNSCrypt-Proxy Configurations |"
		echo -e "---------------------------------------------------------------"
		rm -rf /etc/${pkgname}

		echo -e "-------------------------------------"
		echo -e "| Enabling SystemD-Resolved Service |"
		echo -e "-------------------------------------"
		systemctl daemon-reload && systemctl enable --now systemd-resolved -f

		echo -e "-------------------------------------------"
		echo -e "| Configuring & Restarting NetworkManager |"
		echo -e "-------------------------------------------"
		rm -rf /etc/*resolv*
		rm -rf /etc/NetworkManager/conf.d/*
		rm -rf /var/lib/NetworkManager/*conf*
		rm -rf /etc/NetworkManager/*NetworkManager*
		echo -e "[device]\nwifi.scan-rand-mac-address=yes" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "ethernet.cloned-mac-address=random" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "wifi.cloned-mac-address=random" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "[connectivity]\n.set.enabled=false" >> /var/lib/NetworkManager/NetworkManager-intern.conf
		systemctl daemon-reload && systemctl disable --now NetworkManager-{dispatcher,wait-online} -f
		systemctl daemon-reload && systemctl restart --now NetworkManager -f

		echo -e "--------------------------------------"
		echo -e "| Hardened-Anonymized-DNSCrypt-Proxy |"
		echo -e "|    Successfully Deconfigured !     |"
		echo -e "--------------------------------------"
		
	elif [[ ${input} == 3 ]]
	then
		clear && title
		echo -e "-----------------------------------------"
		echo -e "| Hardened-Anonymized-DNSCrypt-Proxy    |"
		echo -e "| Configuaration Successfully Updated ! |"
		echo -e "-----------------------------------------"
		rm -rf /etc/${pkgname}/${pkgname}.toml
		cp -rf ${pkgname}.toml /etc/${pkgname}/${pkgname}.toml

		echo -e "-------------------------------------------------"
		echo -e "| Restarting Hardened-Anonymized-DNSCrypt-Proxy |"
		echo -e "-------------------------------------------------"
		systemctl daemon-reload && systemctl restart --now ${pkgname}.{service,socket} -f

		echo -e "--------------------------------------------------"
		echo -e "| Restarting NetworkManager & Necessary Services |"
		echo -e "--------------------------------------------------"
		systemctl daemon-reload && systemctl restart --now NetworkManager -f

	elif [[ ${input} == 4 ]]
	then
		clear && title
		echo -e "--------------------------------------------------------------"
		echo -e "| Checking Hardened-Anonymized-DNSCrypt-Proxy Service Status |"
		echo -e "--------------------------------------------------------------"
		${pkgname} -config /etc/${pkgname}/${pkgname}.toml --show-certs

		echo -e "--------------------------------------"
		echo -e "| Hardened-Anonymized-DNSCrypt-Proxy |"
		echo -e "|       Successfully Checked !       |"
		echo -e "--------------------------------------"
		
	fi
fi
