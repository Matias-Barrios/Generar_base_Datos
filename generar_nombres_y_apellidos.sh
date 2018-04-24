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
lista_tipos_usuario="Admin Docente Alumno" 
lista_pro_email="hotmail.com gmail.com its.edu.uy yahoo.com antel.com.uy"

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

Cedula_Aleatoria () {
	
	numero="$(Numero_Aleatorio 1 6)$(Numero_Aleatorio 100000 999999)"
	digitos=( $(echo $numero | sed -e 's/\(.\)/\1 /g') )
	digito_verificador=`awk -v digito1="${digitos[0]}"  -v digito2="${digitos[1]}" -v digito3="${digitos[2]}" -v digito4="${digitos[3]}" -v digito5="${digitos[4]}" -v digito6="${digitos[5]}" -v digito7="${digitos[6]}" 'BEGIN { print  10 - ( ( ((digito1 * 2) % 10) + ((digito2 * 9) % 10) + ((digito3 * 8) % 10) + ((digito4 * 7) % 10) + ((digito5 * 6) % 10) + ((digito6 * 3) % 10) + ((digito7 * 4) % 10) ) % 10 ) } ';`
	printf "${numero}${digito_verificador}"
	
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



echo "CONNECT TO 'gestion_utu@miServidor' USER 'admin_proyecto'  USING 'XXXXPASSWORDXXXX';" > ingresar_usuarios_auto.sql

while [ $i -le 5 ]
do
	echo -e '\n' >> ingresar_usuarios_auto.sql
	echo "INSERT INTO Usuarios (CI, primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,grado,fecha_nacimiento,nota,email,hace_proyecto,tipo,encriptacion_hash,encriptacion_sal,baja)" >> ingresar_usuarios_auto.sql

	CI=`Cedula_Aleatoria` 
	primer_nombre=`Item_Aleatorio "$lista_nombres"`
	segundo_nombre=`Item_Aleatorio "$lista_nombres"` 
	primer_apellido=`Item_Aleatorio "$lista_apellidos"` 
	segundo_apellido=`Item_Aleatorio "$lista_apellidos"` 
	grado=`Numero_Aleatorio 1 7` 
	numero_dias=`Numero_Aleatorio 5400 19000` 
	fecha_nacimiento="`date +%m/%d/%Y --date "$numero_dias days ago"`"
	nota=1
	email="$primer_nombre.$segundo_nombre.$primer_apellido.$segundo_apellido@`Item_Aleatorio "$lista_pro_email"`"
	hace_proyecto=`Numero_Aleatorio 1 30`
	if [[ hace_proyecto -gt 29 ]]
	then
		hace_proyecto="t"
	else
		hace_proyecto="f"
	fi
	tipo="Alumno"
	echo "VALUES ( $CI , \"$primer_nombre\" , \"$segundo_nombre\" , \"$primer_apellido\" , \"$segundo_apellido\" , $grado, \"$fecha_nacimiento\" , $nota , \"$email\" , \"$hace_proyecto\" , \"$tipo\" , NULL , NULL , \"f\" );" >> ingresar_usuarios_auto.sql
	
	echo -e '\n' >> ingresar_usuarios_auto.sql
	echo "Generando fila $i..."
	(( i++ ))
done

echo "$( date ) - Proceso completado!!!"

