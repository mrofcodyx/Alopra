#!/bin/bash
#Cores
bold="\e[1m"
Underlined="\e[4m"
red="\e[31m"
green="\e[32m"
blue="\e[34m"
end="\e[0m"

#Verificando se o Gron está Instalado!
if ! type gron &>/dev/null; then
echo -e "$red${bold}[!] Gron não está instalado. Instalando...$end"
sleep 3
sudo apt-get update
sudo apt-get install gron
chmod +x Alopra
fi
