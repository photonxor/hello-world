#!/bin/bash
# mw - 10/2024

# Basis: https://indibit.de/raspberry-pi-ssh-login-nachricht-anpassen-motd/
# Datum & Uhrzeit
DATUM=`date +"%A, %e %B %Y"`

# Hostname
HOSTNAME=`hostname -f`

#OS and versions  -  still need to implement error handling
OSRPN=`cat /etc/os-release | awk -F= '$1=="PRETTY_NAME" {print $2}'`
KERN = `uname -r`
LH = `lighttpd -version`
PH = `php -v | grep -m1 "PHP"`
PERL =`perl -V | grep -m 1  "Summary of.*" | cut -f 3 -d "y" | cut -f 1 -d "c"`
PY = `python -V`
NODE = `node --version`
DOCK = `docker -v`


# Uptime
UP0=`cut -d. -f1 /proc/uptime`
UP1=$(($UP0/86400))		# Tage
UP2=$(($UP0/3600%24))		# Stunden
UP3=$(($UP0/60%60))		# Minuten
UP4=$(($UP0%60))		# Sekunden

# letzter Login
LAST1=`last -2 -a | awk 'NR==2{print $3}'`	# Wochentag
LAST2=`last -2 -a | awk 'NR==2{print $5}'`	# Tag
LAST3=`last -2 -a | awk 'NR==2{print $4}'`	# Monat
LAST4=`last -2 -a | awk 'NR==2{print $6}'`	# Uhrzeit
LAST5=`last -2 -a | awk 'NR==2{print $10}'`	# Remote-Computer

# Durchschnittliche Auslasung
LOAD1=`cat /proc/loadavg | awk '{print $1}'`	# Letzte Minute
LOAD2=`cat /proc/loadavg | awk '{print $2}'`	# Letzte 5 Minuten
LOAD3=`cat /proc/loadavg | awk '{print $3}'`	# Letzte 15 Minuten

# Temperatur
TEMP=`vcgencmd measure_temp | cut -c "6-9"`

# Speicherbelegung
DISK1=`df -h | grep 'dev/root' | awk '{print $2}'`	# Gesamtspeicher
DISK2=`df -h | grep 'dev/root' | awk '{print $3}'`	# Belegt
DISK3=`df -h | grep 'dev/root' | awk '{print $4}'`	# Frei

# Arbeitsspeicher
RAM1=`free -h  | grep 'Mem' | awk '{print $2}'`	# Total
RAM2=`free -h  | grep 'Mem' | awk '{print $3}'`	# Used
RAM3=`free -h  | grep 'Mem' | awk '{print $4}'`	# Free
RAM4=`free -h  | grep 'Swap' | awk '{print $3}'`	# Swap used

# de locale
#RAM1=`free -h  | grep 'Spei' | awk '{print $2}'`	# Total
#RAM2=`free -h  | grep 'Spei' | awk '{print $3}'`	# Used
#RAM3=`free -h  | grep 'Spei' | awk '{print $4}'`	# Free
#RAM4=`free -h  | grep 'Swap' | awk '{print $3}'`	# Swap used

# IP-Adressen ermitteln
#if ( ifconfig | grep -q "eth0" ) ; then IP_LAN=`ifconfig eth0 | grep "inet " | awk -F'[: ]+' '{ print $3}'`; else IP_LAN="---" ; fi ;
#if ( ifconfig | grep -q "wlan0" ) ; then IP_WLAN=`ifconfig wlan0 | grep "inet " | awk -F'[: ]+' '{print $3}'` ; else IP_WLAN="---" ; fi ;
if ( dig +short myip.opendns.com @resolver1.opendns.com) ; then IP_PUB=`dig +short myip.opendns.com @resolver1.opendns.com`; else IP_PUB="---" ; fi

echo -e "\033[1;32m

                      | |                               
  ____ ____  ___ ____ | | _   ____  ____ ____           
 / ___) _  |/___)  _ \| || \ / _  )/ ___) ___) | | |    
| |  ( ( | |___ | | | | |_) | (/ /| |  | |   | |_| |    
|_|   \_||_(___/| ||_/|____/ \____)_|  |_|    \__  |    
                |_|                          (____/ PI  

\033[0;37m
+++++++++++++++++: System Data :+++++++++++++++++++
Datum      = $DATUM
Hostname   = \033[1;31m$HOSTNAME\033[m
Public IP  = IP_PUB
IP overview=

`ip -br addr`

Uptime     = $UP1 Tage, $UP2:$UP3 Stunden
Load       = $LOAD1 (1m) | $LOAD2 (5m) | $LOAD3 (15m)
Temp       = $TEMP °C
SD         = Total: $DISK1 | Used: $DISK2 | Free: $DISK3
RAM        = Total: $RAM1 | Used: $RAM2 | Free: $RAM3
++++++++++++++++++: User Data :++++++++++++++++++++
Username   = `whoami`
Current    = `who`
Last       = $LAST1, $LAST2 $LAST3 $LAST4 von $LAST5
++++++++++++++++: Version Data :+++++++++++++++++++
OS rel     = $OSRPN
kernel     = $KERN
lighttpd   = $LH
PHP        = $PH
Perl       =$PERL
Python     = $PY
NodeJS     = $NODE
Docker     = $DOCK
+++++++++++++++++++++++++++++++++++++++++++++++++++
"
