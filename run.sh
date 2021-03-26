#!/bin/sh

title()
{
	echo -e "--------------------------------------------"
	echo -e "|    Hardened-Anonymized-DNSCrypt-Proxy    |"
	echo -e "|    Wipe Snoopers Out Of Your Networks    |"
	echo -e "|         Creator : BL4CKH47H4CK3R         |"
	echo -e "--------------------------------------------"
}

gateway=$(ip r | tail -1 | cut -d " " -f 1)
	
if [[ ${UID} != 0 ]]
then
	clear && title
	echo -e "----------------------------"
	echo -e "|  Run The Script As Root  |"
	echo -e "----------------------------"
else
	clear && title
	echo -e "-------------------------"
	echo -e "|   [1] Configure       |"
	echo -e "|   [2] Deconfigure     |"
	echo -e "|   [3] Configuration   |"
	echo -e "-------------------------"
	read -p "[*] Enter Choice [1, 2, 3]: " input

	if [[ ${input} == 1 ]]
	then
		clear && title
		echo -e "-----------------------------------"
		echo -e "|  Installing DNSCrypt-Proxy ...  |"
		echo -e "-----------------------------------"
		
		if ! [[ -z `which pacman 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "-------------------------------------"
			echo -e "|  Detected OS : Arch / Arch Based  |"
			echo -e "-------------------------------------"
			pacman -Sy dnscrypt-proxy --needed

		elif ! [[ -z `which apt 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "-----------------------------------------"
			echo -e "|  Detected OS : Debian / Debian Based  |"
			echo -e "-----------------------------------------"
			curl -O http://ftp.debian.org/debian/pool/main/d/dnscrypt-proxy/dnscrypt-proxy_2.0.45+ds1-1_amd64.deb
			apt install dnscrypt-proxy_2.0.45+ds1-1_amd64.deb && rm -rf dnscrypt-proxy_2.0.45+ds1-1_amd64.deb

		elif ! [[ -z `which emerge 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "--------------------------"
			echo -e "|  Detected OS : Gentoo  |"
			echo -e "--------------------------"
			emerge -av dnscrypt-proxy

		elif ! [[ -z `which apk 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "--------------------------"
			echo -e "|  Detected OS : Alpine  |"
			echo -e "--------------------------"
			curl -O http://dl-cdn.alpinelinux.org/alpine/edge/community/x86_64/dnscrypt-proxy-2.0.45-r0.apk
			apk add --allow-untrusted dnscrypt-proxy-2.0.45-r0.apk && rm -rf dnscrypt-proxy-2.0.45-r0.apk
		
		elif ! [[ -z `which dnf 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "--------------------------"
			echo -e "|  Detected OS : Fedora  |"
			echo -e "--------------------------"
			dnf install dnscrypt-proxy

		elif ! [[ -z `which urpmi 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "--------------------------"
			echo -e "|  Detected OS : Mageia  |"
			echo -e "--------------------------"
			urpmi dnscrypt-proxy

		elif ! [[ -z `which zypper 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "----------------------------"
			echo -e "|  Detected OS : OpenSUSE  |"
			echo -e "----------------------------"
			zypper in dnscrypt-proxy

		elif ! [[ -z `which eopkg 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "-------------------------"
			echo -e "|  Detected OS : Solus  |"
			echo -e "-------------------------"
			eopkg install dnscrypt-proxy
		fi

		echo -e "--------------------------------------"
		echo -e "|    Disabling SystemD-Resolved ...  |"
		echo -e "--------------------------------------"
		systemctl disable --now systemd-resolved -f

		echo -e "---------------------------------------------------------------------"
		echo -e "|   Applying Hardened-Anonymized-DNSCrypt-Proxy Configurations ...  |"
		echo -e "---------------------------------------------------------------------"
		cp -rf allowed-ips.txt /etc/dnscrypt-proxy
		cp -rf blocked-ips.txt /etc/dnscrypt-proxy
		cp -rf allowed-names.txt /etc/dnscrypt-proxy
		cp -rf blocked-names.txt /etc/dnscrypt-proxy
		cp -rf dnscrypt-proxy.toml /etc/dnscrypt-proxy
		
		echo -e "------------------------------------------------------------"
		echo -e "|   Initializing Hardened-Anonymized-DNSCrypt-Proxy ...    |"
		echo -e "------------------------------------------------------------"
		systemctl enable --now dnscrypt-proxy.socket dnscrypt-proxy.service -f
		dnscrypt-proxy -service start
		
		echo -e "----------------------------------------------------"
		echo -e "|   Configuring & Restarting NetworkManager . . .  |"
		echo -e "----------------------------------------------------"
		rm -rf /etc/resolv.conf /etc/resolv.conf.bak
		rm -rf /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.bak
		echo -e "[device]\nwifi.scan-rand-mac-address=yes" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "ethernet.cloned-mac-address=random" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "wifi.cloned-mac-address=random\n" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "[main]\ndns=none" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "nameserver 0.0.0.0\noptions edns0 single-request-reopen" > /etc/resolv.conf
		systemctl restart --now NetworkManager -f
		
		echo -e "-----------------------------------------"
		echo -e "|   Hardened-Anonymized-DNSCrypt-Proxy  |"
		echo -e "|       Successfully Configured !       |"
		echo -e "-----------------------------------------"

	elif [[ ${input} == 2 ]]
	then
		clear && title
		echo -e
		echo -e "-------------------------------------"
		echo -e "|  Uninstalling DNSCrypt-Proxy ...  |"
		echo -e "-------------------------------------"

		if ! [[ -z `which pacman 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "-------------------------------------"
			echo -e "|  Detected OS : Arch / Arch Based  |"
			echo -e "-------------------------------------"
			pacman -Rcnsu dnscrypt-proxy

		elif ! [[ -z `which apt 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "-----------------------------------------"
			echo -e "|  Detected OS : Debian / Debian Based  |"
			echo -e "-----------------------------------------"
			apt purge dnscrypt-proxy

		elif ! [[ -z `which emerge 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "--------------------------"
			echo -e "|  Detected OS : Gentoo  |"
			echo -e "--------------------------"
			emerge -Cav dnscrypt-proxy

		elif ! [[ -z `which apk 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "--------------------------"
			echo -e "|  Detected OS : Alpine  |"
			echo -e "--------------------------"
			apk del dnscrypt-proxy

		elif ! [[ -z `which dnf 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "--------------------------"
			echo -e "|  Detected OS : Fedora  |"
			echo -e "--------------------------"
			dnf remove dnscrypt-proxy

		elif ! [[ -z `which urpmi 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "--------------------------"
			echo -e "|  Detected OS : Mageia  |"
			echo -e "--------------------------"
			urpme dnscrypt-proxy

		elif ! [[ -z `which zypper 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "----------------------------"
			echo -e "|  Detected OS : OpenSUSE  |"
			echo -e "----------------------------"
			zypper rm dnscrypt-proxy

		elif ! [[ -z `which eopkg 2> /dev/null` && `nmcli networking` = "enabled" ]]
		then
			echo -e "-------------------------"
			echo -e "|  Detected OS : Solus  |"
			echo -e "-------------------------"
			eopkg remove dnscrypt-proxy
		fi

		echo -e "------------------------------------------------------"
		echo -e "|  Disabling Hardened-Anonymized-DNSCrypt-Proxy ...  |"
		echo -e "------------------------------------------------------"
		systemctl disable --now dnscrypt-proxy.socket dnscrypt-proxy.service -f
		
		echo -e "---------------------------------------------------------------------"
		echo -e "|  Reverting Hardened-Anonymized-DNSCrypt-Proxy Configurations ...  |"
		echo -e "---------------------------------------------------------------------"
		rm -rf /etc/dnscrypt-proxy

		echo -e "-----------------------------------"
		echo -e "|  Enabling SystemD-Resolved ...  |"
		echo -e "-----------------------------------"		
		systemctl enable --now systemd-resolved -f

		echo -e "---------------------------------------------"
		echo -e "|  Configuring & Restarting NetworkManager  |"
		echo -e "---------------------------------------------"
		rm -rf /etc/resolv.conf /etc/resolv.conf.bak
		rm -rf /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.bak		
		echo -e "[device]\nwifi.scan-rand-mac-address=yes\n" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "ethernet.cloned-mac-address=random\n" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "wifi.cloned-mac-address=random" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "nameserver ${gateway}" > /etc/resolv.conf && systemctl restart --now NetworkManager -f

		echo -e "-----------------------------------------"
		echo -e "|   Hardened-Anonymized-DNSCrypt-Proxy  |"
		echo -e "|      Successfully Deconfigured !      |"
		echo -e "-----------------------------------------"
		
	elif [[ ${input} == 3 ]]
	then
		clear && title
		echo -e "---------------------------"
		echo -e "|   [1] Check Service     |"
		echo -e "|   [2] Enable Service    |"
		echo -e "|   [3] Disable Service   |"
		echo -e "|   [4] Restart Service   |"
		echo -e "---------------------------"
		read -p "[*] Enter Choice [1, 2, 3, 4]: " input

		if [[ ${input} == 1 ]]
		then
			clear && title
			echo -e "------------------------------------------------------------------------"
			echo -e "|   Checking Hardened-Anonymized-DNSCrypt-Proxy Service Status . . .   |"
			echo -e "------------------------------------------------------------------------"
			dnscrypt-proxy -config /etc/dnscrypt-proxy.toml -show-certs

			echo -e "-----------------------------------------"
			echo -e "|   Hardened-Anonymized-DNSCrypt-Proxy  |"
			echo -e "|         Successfully Checked !        |"
			echo -e "-----------------------------------------"

		elif [[ ${input} == 2 ]]
		then
			clear && title
			systemctl disable --now systemd-resolved -f
			systemctl enable --now dnscrypt-proxy.socket dnscrypt-proxy.service -f
			dnscrypt-proxy -service start
			rm -rf /etc/resolv.conf
			echo -e "nameserver 0.0.0.0\noptions edns0 single-request-reopen" > /etc/resolv.conf
			systemctl restart --now NetworkManager -f
			
			echo -e "-----------------------------------------"
			echo -e "|   Hardened-Anonymized-DNSCrypt-Proxy  |"
			echo -e "|         Successfully Enabled !        |"
			echo -e "-----------------------------------------"
			
		elif [[ ${input} == 3 ]]
		then
			clear && title
			systemctl disable --now dnscrypt-proxy.socket dnscrypt-proxy.service -f
			systemctl enable --now systemd-resolved -f
			dnscrypt-proxy -service stop
			rm -rf /etc/resolv.conf
			echo -e "nameserver ${gateway}" > /etc/resolv.conf
			systemctl restart --now NetworkManager -f
			
			echo -e "-----------------------------------------"
			echo -e "|   Hardened-Anonymized-DNSCrypt-Proxy  |"
			echo -e "|        Successfully Disabled !        |"
			echo -e "-----------------------------------------"
			
		elif [[ ${input} == 4 ]]
		then
			clear && title
			dnscrypt-proxy -service restart
			rm -rf /etc/resolv.conf
			echo -e "nameserver 0.0.0.0\noptions edns0 single-request-reopen" > /etc/resolv.conf
			systemctl restart --now NetworkManager -f
						
			echo -e "-----------------------------------------"
			echo -e "|   Hardened-Anonymized-DNSCrypt-Proxy  |"
			echo -e "|        Successfully Restarted !       |"
			echo -e "-----------------------------------------"
		fi
	fi
fi
