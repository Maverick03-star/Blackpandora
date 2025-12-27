#!/bin/bash
# ==========================================================
#  BLACK PANDORA v3 – Termux Cyberpunk Toolbox
#  Features:
#  - SHA256 Password Auth (no plaintext!)
#  - Matrix Glitch Animation (Mode M2)
#  - Auto Self Update (GitHub raw)
# ==========================================================

# ---- CONFIG ----
SCRIPT_NAME="blackpandora.sh"
VERSION="3.0"
PASSWORD_HASH="ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f"
GITHUB_RAW="https://raw.githubusercontent.com/Maverick03-star/BlackPandora/main/blackpandora.sh"

# ---- COLORS ----
R='\033[31m'; G='\033[32m'; Y='\033[33m'; C='\033[36m'; NC='\033[0m'

# ---- MATRIX (M2 glitch aesthetic) ----
matrix_m2(){
  clear
  for i in {1..20}; do
    echo -e "${C}$(cat /dev/urandom | tr -dc '01/\\|-' | head -c $(( RANDOM % 60 + 10 )))${NC}"
    sleep 0.05
  done
}

# ---- Password Auth (SHA256) ----
login(){
  clear
  echo -e "${G}======= BLACK PANDORA ACCESS =======${NC}"
  read -sp "Enter Password: " PASSINPUT
  echo ""
  INPUT_HASH=$(echo -n "$PASSINPUT" | sha256sum | awk '{print $1}')
  if [[ "$INPUT_HASH" != "$PASSWORD_HASH" ]]; then
     echo -e "${R}ACCESS DENIED${NC}"
     sleep 1
     exit
  fi
}

# ---- Auto-Self Update ----
check_update(){
  ONLINE_VERSION=$(curl -s $GITHUB_RAW | grep VERSION= | head -1 | sed 's/.*="//;s/".*//')
  if [[ ! -z "$ONLINE_VERSION" ]] && [[ "$ONLINE_VERSION" != "$VERSION" ]]; then
     echo -e "${Y}[+] UPDATE AVAILABLE — Auto Updating...${NC}"
     curl -s "$GITHUB_RAW" > "$0"
     chmod +x "$0"
     exec "$0"
     exit
  fi
}

# ---- Banner ----
banner(){
clear
echo -e "${C}"
echo "██████╗ ██╗      █████╗  ██████╗██╗  ██╗    ██████╗ █████╗ ███╗   ██╗██████╗ ██████╗ █████╗"
echo "██╔════╝ ██║     ██╔══██╗██╔════╝██║ ██╔╝    ██╔══██╗██╔══██╗████╗  ██║██╔══██╗██╔═══██╗██╔══██╗"
echo "██║  ███╗██║     ███████║██║     █████╔╝     ██████╔╝███████║██╔██╗ ██║██║  ██║██║   ██║███████║"
echo "██║   ██║██║     ██╔══██║██║     ██╔═██╗     ██╔══██╗██╔══██║██║╚██╗██║██║  ██║██║   ██║██╔══██║"
echo "╚██████╔╝███████╗██║  ██║╚██████╗██║  ██╗    ██║  ██║██║  ██║██║ ╚████║██████╔╝╚██████╔╝██║  ██║"
echo " ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝"
echo -e "${NC}"
}

menu(){
echo -e "
${Y}[ MAIN MENU ]${NC}
${G}1.${NC} System Update & Upgrade
${G}2.${NC} Install Coding Packages
${G}3.${NC} Install Pentest Kit
${G}4.${NC} System Monitor
${G}5.${NC} Network Tools
${G}6.${NC} Change Banner
${G}7.${NC} Backup & Restore
${C}9.${NC} Manual Update Check
${R}0.${NC} Exit
"
read -p "Select > " IN
case $IN in
1) apt update && apt upgrade -y ;;
2) pkg install python php ruby clang nodejs golang git curl wget vim nano neovim openssh zip unzip dnsutils -y ;;
3) pkg install nmap hydra sqlmap nikto unstable-repo -y; pkg install metasploit -y ;;
4) pkg install neofetch htop -y; neofetch ;;
5) pkg install net-tools -y; echo "IP: $(curl -s ifconfig.me)" ;;
6) read -p "New Banner Text > " TXT; echo "toilet -f bigascii12 '$TXT'" > ~/.bashrc ;;
7) echo "1=Backup 2=Restore"; read -p "> " BR; [[ $BR == 1 ]] && cp -r $HOME /sdcard/Backup-Termux || cp -r /sdcard/Backup-Termux/* $HOME ;;
9) check_update ;;
0) exit ;;
*) echo "Invalid" ;;
esac
}

# ---- EXECUTION START ----
login
matrix_m2
check_update
while true; do banner; menu; done
