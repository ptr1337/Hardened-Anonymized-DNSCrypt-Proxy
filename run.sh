#!/bin/sh

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
		echo -e "-----------------------------"
		echo -e "| Installing DNSCrypt-Proxy |"
		echo -e "-----------------------------"

		if [[ -f /bin/dnscrypt-proxy ]]
		then
			echo -e "----------------------------"
			echo -e "| DNSCrypt-Proxy Installed |"
			echo -e "----------------------------"

		elif [[ -f /bin/pacman ]]
		then
			echo -e "-----------------------------------"
			echo -e "| Detected OS : Arch / Arch Based |"
			echo -e "-----------------------------------"
			pacman -S dnscrypt-proxy

		elif [[ -f /bin/apt ]]
		then
			echo -e "---------------------------------------"
			echo -e "| Detected OS : Debian / Debian Based |"
			echo -e "---------------------------------------"
			curl -O http://ftp.debian.org/debian/pool/main/d/dnscrypt-proxy/dnscrypt-proxy_2.0.45+ds1-1_amd64.deb
			apt install dnscrypt-proxy_2.0.45+ds1-1_amd64.deb && rm -rf dnscrypt-proxy_2.0.45+ds1-1_amd64.deb

		elif [[ -f /bin/dnf ]]
		then
			echo -e "------------------------"
			echo -e "| Detected OS : Fedora |"
			echo -e "------------------------"
			dnf install dnscrypt-proxy

		elif [[ -f /bin/yum ]]
		then
			echo -e "---------------------------------"
			echo -e "| Detected OS : CentOS / RedHat |"
			echo -e "---------------------------------"
			yum install dnscrypt-proxy

		elif [[ -f /bin/urpmi ]]
		then
			echo -e "------------------------"
			echo -e "| Detected OS : Mageia |"
			echo -e "------------------------"
			urpmi dnscrypt-proxy

		elif [[ -f /bin/zypper ]]
		then
			echo -e "--------------------------"
			echo -e "| Detected OS : OpenSUSE |"
			echo -e "--------------------------"
			zypper in dnscrypt-proxy

		elif [[ -f /bin/eopkg ]]
		then
			echo -e "-----------------------"
			echo -e "| Detected OS : Solus |"
			echo -e "-----------------------"
			eopkg install dnscrypt-proxy
		fi

		echo -e "------------------------------"
		echo -e "| Disabling SystemD-Resolved |"
		echo -e "------------------------------"
		systemctl disable --now systemd-resolved -f

		echo -e "--------------------------------------------------------------"
		echo -e "| Applying Hardened-Anonymized-DNSCrypt-Proxy Configurations |"
		echo -e "--------------------------------------------------------------"
		cp -rf dnscrypt-proxy.toml /etc/dnscrypt-proxy
				
		echo -e "---------------------------------------------------"
		echo -e "| Initializing Hardened-Anonymized-DNSCrypt-Proxy |"
		echo -e "---------------------------------------------------"
		systemctl enable --now dnscrypt-proxy.service -f
		
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
		echo -e "-------------------------------"
		echo -e "| Uninstalling DNSCrypt-Proxy |"
		echo -e "-------------------------------"

		if ! [[ -f /bin/dnscrypt-proxy ]]
		then
			echo -e "-------------------------------"
			echo -e "| DNSCrypt-Proxy Not Intalled |"
			echo -e "-------------------------------"

		elif [[ -f /bin/pacman ]]
		then
			echo -e "-----------------------------------"
			echo -e "| Detected OS : Arch / Arch Based |"
			echo -e "-----------------------------------"
			pacman -Rcnsu dnscrypt-proxy

		elif [[ -f /bin/apt ]]
		then
			echo -e "---------------------------------------"
			echo -e "| Detected OS : Debian / Debian Based |"
			echo -e "---------------------------------------"
			apt purge dnscrypt-proxy

		elif [[ -f /bin/dnf ]]
		then
			echo -e "------------------------"
			echo -e "| Detected OS : Fedora |"
			echo -e "------------------------"
			dnf remove dnscrypt-proxy

		elif [[ -f /bin/yum ]]
		then
			echo -e "---------------------------------"
			echo -e "| Detected OS : CentOS / RedHat |"
			echo -e "---------------------------------"
			yum remove dnscrypt-proxy
			

		elif [[ -f /bin/urpmi ]]
		then
			echo -e "------------------------"
			echo -e "| Detected OS : Mageia |"
			echo -e "------------------------"
			urpme dnscrypt-proxy

		elif [[ -f /bin/zypper ]]
		then
			echo -e "--------------------------"
			echo -e "| Detected OS : OpenSUSE |"
			echo -e "--------------------------"
			zypper rm dnscrypt-proxy

		elif [[ -f /bin/eopkg ]]
		then
			echo -e "-----------------------"
			echo -e "| Detected OS : Solus |"
			echo -e "-----------------------"
			eopkg remove dnscrypt-proxy
		fi

		echo -e "------------------------------------------------"
		echo -e "| Disabling Hardened-Anonymized-DNSCrypt-Proxy |"
		echo -e "------------------------------------------------"
		systemctl disable --now dnscrypt-proxy.service -f
		
		echo -e "---------------------------------------------------------------"
		echo -e "| Reverting Hardened-Anonymized-DNSCrypt-Proxy Configurations |"
		echo -e "---------------------------------------------------------------"
		rm -rf /etc/dnscrypt-proxy

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
		dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -show-certs

		echo -e "--------------------------------------"
		echo -e "| Hardened-Anonymized-DNSCrypt-Proxy |"
		echo -e "|       Successfully Checked !       |"
		echo -e "--------------------------------------"

	fi
fi
