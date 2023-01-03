#!/bin/bash
# Author = Vø1dn3t
# My github = "https://github.com/Voidnet01"

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


trap ctrl_c INT

function ctrl_c(){
	clear
	echo
	echo -e "${redColour} [+] Saliendo...${endColour}"
	tput cnorm; exit 1
}

function panel(){
	sleep 1
	echo
	echo -e " ${redColour}                                                                                                   "
	echo -e "	                 ____  _   _  ____    ____  __  __  __  __  ____  __    ____  _  _   ___                 "
        echo -e "                        (_  _)( )_( )( ___)  (  _ \(  )(  )(  \/  )(  _ \(  )  (_  _)( \( ) / __)               "
        echo -e "                          )(   ) _ (  )__)    )   / )(__)(  )    (  ) _ < )(__  _)(_  )  ( ( (_-.               "
        echo -e "                         (__) (_) (_)(____)  (_)\_)(______)(_/\/\_)(____/(____)(____)(_)\_) \___/               "
	echo -e "                                                                                                                "
	echo -e "                                                                                                                "
	echo -e "                                                                     ${redColour}code By = Vø1dn3t ${endColour} "
	echo -e "                                                                                                                 "
	echo -e "                                                           ${redColour} My github = https://github.com/Voidnet01/ ${endColour} "
	echo -e "                                                                                                    ${endColour}"

}


function helpPanel(){
	panel
	echo
	echo -e "\n${blueColour}[+]${endColour}${grayColour} Uso: ./TheRumbling.sh -u scanme.nmap.org ${endColour}"
	echo -e "\n\t${blueColour}[u]${endColour}${greenColour} Especifica una direccion URL para realizar un escaneo${endColour}"
	echo -e "\n\t${blueColour}[e]${endColour}${greenColour} Evadir un firewall${endColour}"
	echo -e "\n\t${blueColour}[v]${endColour}${greenColour} Buscar vulnerabilidades ${endColour}"
	echo -e "\n\t${blueColour}[n]${endColour}${greenColour} Busca usuarios con contraseñas vacias ${endColour}"
	echo -e "\n\t${blueColour}[a]${endColour}${greenColour} Detectar si la url es vulnerable al ataque DOS${endColour}"
	echo -e "\n\t${blueColour}[h]${endColour}${greenColour} Panel de ayuda${endColour}"
	exit 0
}

function attacking(){
	clear
	echo
	echo -e "\n${redColour} [!] EL RETUMBAR ESTA ESCANEADO . . . ${endColour}"
	sleep 2
	echo
	nmap -sS -sCV -n -vvv -Pn -sV --min-rate 5000 --script vuln $URL -oG resultados.txt && echo -e "\n\t${redColour}[+] Retumbar terminado [+]${endColour}"

}

function firewall(){
	clear
	echo
	echo -e "\n${redColour} [!] EL RETUMBAR ESTA EVADIENDO UN FIREWALL . . . ${endColour}"
	sleep 2
	echo
	nmap -sT -Pn --spoof-mac 0 $URL && echo -e "${redColour}[!] EL RETUMBAR TERMINO DE EVADIR EL FIREWALL${endColour}"
}

function attacking2(){
	clear
	echo
	echo -e "\n${redColour} [*] EL RETUMBAR ESTA PROBANDO SI HAY USUARIOS CON CONTRASEÑAS VACIAS. . . ${endColour}"
	sleep 2
	echo
	nmap -f -sS -sV --script auth $URL && echo -e "\n${redColour} [*] El retumbar termino de comprobar si hay usuarios con contraseñas vacias${endColour}"
}

function attacking3(){
	clear
	echo
	echo -e "\n${redColour} [*] EL RETUMBAR ESTA DETECTANDO SI ES VULNERABLE AL ATAQUE DOS ${endColour}"
	sleep 2
	echo 
	nmap --script http-slowloris -Pn -n $URL && echo -e "\n${redColour} [*] El retumbar termino el escaneo"
}

function vuln(){
	clear
	echo
	echo -e "\n${redColour} [*] EL RETUMBAR ESTA BUSCANDO VULNERABILIDADES . . .${endColour}"
	sleep 2
	echo
	nikto -Tuning 3 -h $URL && echo -e "\n${redColour} [*] El retumbar termino el escanear ${endColour}"
}



function dependencies(){
	tput civis
	clear; dependencies=( nmap nikto )

	echo -e "${yellowColour}[*]${endColour}${grayColour} Comprobando programas necesarios...${endColour}"
	sleep 2

	for program in "${dependencies[@]}"; do
		echo -ne "\n${yellowColour}[*]${endColour}${blueColour} Herramienta${endColour}${purpleColour} $program${endColour}${blueColour}...${endColour}"

		test -f /usr/bin/$program

		if [ "$(echo $?)" == "0" ]; then
			echo -e " ${greenColour}(V)${endColour}"
		else
			echo -e " ${redColour}(X)${endColour}\n"
			echo -e "${yellowColour}[*]${endColour}${grayColour} Instalando herramienta ${endColour}${blueColour}$program${endColour}${yellowColour}...${endColour}"
			sudo apt-get install $program -y > /dev/null 2>&1
		fi; sleep 1
	done
}

if [ "$(id -u)" == "0" ]; then
	declare -i parameter_counter=0; while getopts "evnahu:" arg; do
		case $arg in
			u) URL=$OPTARG; let parameter_counter+=1 ;;
			e) let parameter_counter+=1 ;;
			v) let parameter_counter+=2 ;;
			n) let parameter_counter+=3 ;;
			a) let parameter_counter+=4 ;;
			h) helpPanel;;

                        \?) # invalid option
				echo
		                echo -e "${redColour}\n[x] Error: opcion invalida, ¿de que vamos?.${endColour}"
			        tput cnorm; exit;;
		esac
	done

	if [ $parameter_counter -eq 1 ]; then
	        dependencies
        	attacking

	elif [ $parameter_counter -eq 2 ]; then
		dependencies
		firewall

	elif [ $parameter_counter -eq 3 ]; then
		dependencies
		vuln

	elif [ $parameter_counter -eq 4 ]; then
		dependencies
		attacking2

	elif [ $parameter_counter -eq 5 ]; then
		dependencies
		attacking3


	else helpPanel

	fi
else
	echo -e "\n${redColour}[*] No eres root${endColour}\n"
fi
