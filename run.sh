#!/bin/bash

march="$(uname -m)"
pkgname="dnscrypt-proxy"
pkgver=(
$(curl --no-progress-meter \
https://github.com/DNSCrypt/dnscrypt-proxy/releases/latest/|\
cut -d/ -f8 | cut -d\" -f1))

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
	echo -e "--------------------------"
	echo -e "| Run The Script As Root |"
	echo -e "--------------------------"

else	
	clear && title
	echo -e "---------------------"
	echo -e "| [1] Configure     |"
	echo -e "| [2] Deconfigure   |"
	echo -e "| [3] Check Service |"
	echo -e "---------------------"
	read -p "[*] Enter Choice [1, 2, 3]: " input

	if [[ ${input} == 1 ]]
	then
		clear && title
		echo -e "-------------------------------------------"
		echo -e "| Downloading & Installing DNSCrypt-Proxy |"
		echo -e "-------------------------------------------"
		curl -LO "https://github.com/DNSCrypt/${pkgname}/releases/download/${pkgver}/${pkgname}-linux_${march}-${pkgver}.tar.gz"
		tar xf *tar*
		rm -rf /usr/share/licenses/${pkgname}
		mkdir /usr/share/licenses/${pkgname}
		mv linux-${march}/${pkgname} /usr/bin/
		mv linux-${march}/LICENSE /usr/share/licenses/${pkgname}/LICENSE
		rm -rf *tar* linux-${march}

		echo -e "--------------------------------------"
		echo -e "| Disabling SystemD-Resolved Service |"
		echo -e "--------------------------------------"
		systemctl disable --now systemd-resolved -f
			
		echo -e "---------------------------------------------------"
		echo -e "| Initializing Hardened-Anonymized-DNSCrypt-Proxy |"
		echo -e "---------------------------------------------------"
		cp -rf *service* /usr/lib/systemd/system/
		systemctl enable --now ${pkgname}.service -f

		echo -e "--------------------------------------------------------------"
		echo -e "| Applying Hardened-Anonymized-DNSCrypt-Proxy Configurations |"
		echo -e "--------------------------------------------------------------"
		mkdir /etc/${pkgname}
		touch /etc/dnscrypt-proxy/{allowed,blocked}-{ips,names}.txt
		cp -rf ${pkgname}.toml /etc/${pkgname}
		
		echo -e "-------------------------------------------"
		echo -e "| Configuring & Restarting NetworkManager |"
		echo -e "-------------------------------------------"
		rm -rf /etc/resolv.conf /etc/resolv.conf.bak
		rm -rf /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.bak
		echo -e "[device]\nwifi.scan-rand-mac-address=yes" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "ethernet.cloned-mac-address=random" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "wifi.cloned-mac-address=random\n" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "[main]\ndns=none" >> /etc/NetworkManager/NetworkManager.conf
		systemctl restart --now NetworkManager -f
		echo -e "nameserver 127.0.0.1\noptions edns0 single-request-reopen" > /etc/resolv.conf
			
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
		systemctl disable --now ${pkgname} -f

		echo -e "-------------------------------"
		echo -e "| Uninstalling DNSCrypt-Proxy |"
		echo -e "-------------------------------"
		rm -rf /usr/lib/systemd/system/${pkgname}.service
		rm -rf /usr/share/licenses/${pkgname} /usr/bin/${pkgname}
		
		echo -e "---------------------------------------------------------------"
		echo -e "| Reverting Hardened-Anonymized-DNSCrypt-Proxy Configurations |"
		echo -e "---------------------------------------------------------------"
		rm -rf /etc/${pkgname}

		echo -e "-------------------------------------"
		echo -e "| Enabling SystemD-Resolved Service |"
		echo -e "-------------------------------------"
		systemctl enable --now systemd-resolved -f

		echo -e "-------------------------------------------"
		echo -e "| Configuring & Restarting NetworkManager |"
		echo -e "-------------------------------------------"
		rm -rf /etc/resolv.conf /etc/resolv.conf.bak
		rm -rf /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.bak		
		echo -e "[device]\nwifi.scan-rand-mac-address=yes" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "ethernet.cloned-mac-address=random" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "wifi.cloned-mac-address=random\n" >> /etc/NetworkManager/NetworkManager.conf
		systemctl restart --now NetworkManager -f

		echo -e "--------------------------------------"
		echo -e "| Hardened-Anonymized-DNSCrypt-Proxy |"
		echo -e "|    Successfully Deconfigured !     |"
		echo -e "--------------------------------------"
		
	elif [[ ${input} == 3 ]]
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
