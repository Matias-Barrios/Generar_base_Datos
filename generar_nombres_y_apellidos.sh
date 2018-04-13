#!/bin/bash

##
##  Este script genera una lista de tres columnas con dos nombres, dos apellidos y una edad de manera aleatoria basandose en dos lemarios que se encuentra en GitHub
##  
##  Nombre    : https://raw.githubusercontent.com/olea/lemarios/master/nombres-propios-es.txt
##  Apellidos : https://raw.githubusercontent.com/olea/lemarios/master/apellidos-es.txt
##

## Cargar nombres como array 

lista_nombres=$( cat ./nombres_propios.txt | tr '\n' ' ' )
lista_apellidos=$( cat ./apellidos.txt | tr '\n' ' ' )


Item_Aleatorio () {
	local arr=($1)
	## Obtenemos el tamaño del array y lo asignamos a una variable llamada size
	local size=${#arr[@]}
	printf "${arr[$( Numero_Aleatorio 0 $size )]}"
}
Numero_Aleatorio () {
	## Chequeamos que sean los dos primeros parametros no esten vacios y sean numericos
	if [ -z $1 ] || [ -z $2 ] || [ -z "$( echo $1 | grep -E '^[0-9]+$' )" ] || [ -z "$( echo $2 | grep -E '^[0-9]+$' )" ]
	then
		echo "Error! Se necesitan dos parametros numericos, minimo y maximo!!"
		exit 3
	fi
	minimo=$1
	maximo=$2
	(( maximo-- ))
	printf "$( shuf -i ${minimo}-${maximo} -n 1 )"
}

Generar_columnas () {
	Item_Aleatorio "$lista_nombres" ; 
		printf "|"; 
	Item_Aleatorio "$lista_nombres" ; 
		printf "|"; 
	Item_Aleatorio "$lista_apellidos" ;
		printf "|"
	Item_Aleatorio "$lista_apellidos" ;
		printf "|"
	Numero_Aleatorio 18 60
		printf "\n"
}  

##########################################################################
# Una vez definidas todas las funciones, iteramos generando 2000 nombres y edades ficticios
##########################################################################


echo "$( date ) - Proceso iniciado..."
i=0;

while [ $i -le 10 ]
do
	
	Generar_columnas # >> ./lista_nombres_apellidos_y_edades.txt
	echo "Generando fila $i..."
	(( i++ ))
done

echo "$( date ) - Proceso completado!!!"

