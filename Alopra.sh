#!/bin/bash
#Sim eu sei que o script tá cagado rsrsrs
#mais é o que tem pra hoje.
#Cores
bold="\e[1m"
Underlined="\e[4m"
red="\e[31m"
green="\e[32m"
blue="\e[34m"
end="\e[0m"

#Banner
echo -e "$blue${bold}                        /^\__/^\                        $end"
echo -e "$blue${bold}    _   _     ___     /\| _  _ |__________              $end"
echo -e "$blue${bold}   /_\ | |___| _ \_ _|/\|(${red}${bold}B${end}$blue${bold})(${end}${red}${bold}Y${end}$blue${bold})${end} ${red}${bold}Mr_ofcodyx${end}$blue${bold}|___________${end}"
echo -e "$blue${bold}  / _ \| / _ \  _/ '_/--\__--__|${red}${bold}Coleta automatizada de${end}$blue${bold}|${end}"
echo -e "$blue${bold} /_/ \_\_\___/_| |_|/_/\_\ ${red}${bold}endpoints da AlienVault OTX.${end}${end}"
echo -e "$end"
##########################################################################################
helpFunction()
{
   echo ""
   echo -e "$blue${bold}Uso: $0 -l domains.txt -p 1$end"
   echo -e "${red}${bold}\t-l Nome do arquivo com a lista de domínios$end"
   echo -e "${red}${bold}\t-p Quantidade de páginas a serem buscadas$end"
   echo -e "${red}${bold}\t-h Exibe esta mensagem de ajuda e sai.$end"
   exit 1 # Exit script
}

alert(){
echo -e "${red}${bold}[!] Falta argumento -h obrigatório$end"
exit 1
}
##########################################################################################
# Adicionando o parâmetro -l para especificar a lista de domínios
while getopts "l:p:h" opt; do
  case $opt in
    l)
      list=$OPTARG
      ;;
    p)
      pages=$OPTARG
      ;;
    h)
      helpFunction
      ;;
    ?)
      alert
      ;;
 esac
done
###########################################################################################
if [ $# -lt 1 ]; then
   echo -e "${red}${bold}[!] Falta argumento -h obrigatório$end"
   exit 1
fi
###########################################|Main|##########################################
data=$(date +'%H:%M:%S')
#Iniciando busca por Endpoints.
cat $list | while read dom; do
echo -e "$red${bold}[+] Verificando URLs de $dom [$data]$end"
echo ""
sleep 2
gron "https://otx.alienvault.com/otxapi/indicator/hostname/url_list/$dom?limit=500&page=$pages" | grep "\burl\b" | gron --ungron | jq | grep '\"url\"' | awk -F "\"" '{print $4}' | tee -a allurl.txt
echo -e "$red${bold}[!] URLs encontradas [$(cat allurl.txt | sort -u |grep "$dom" |wc -l)] $end"
echo ""
done
echo -e "$blue${bold}[+] Finalizando o Alopra [$data]$end"
sleep 5
echo -e "$red${bold}[!] Total de URLs encontradas [$(cat allurl.txt | sort -u | wc -l)] $end"
###########################################################################################

#Limpando resultados.
cat allurl.txt | sort -u >> urls.txt
rm allurl.txt
