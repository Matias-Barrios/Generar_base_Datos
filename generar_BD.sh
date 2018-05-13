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
lista_orientaciones="ADMINISTRACIÓN ELECTROELECTRÓNICA QUÍMICA_BÁSICA QUÍMICA_INDUSTRIAL AERONÁUTICA ELECTROMECÁNICA TERMODINÁMICA AGRARIO ELECTROMECÁNICA_AUTOMOTRIZ TURISMO CONSTRUCCIÓN INFORMÁTICA DEPORTE_Y_RECREACIÓN MAQUINISTA_NAVAL ARTES_GRÁFICAS ENERGÍAS_RENOVABLES AUDIOVISUAL"
lista_grupos_letras="A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
lista_turnos="Vespertino Matutino Nocturno"
lista_materias=$( cat ./lista_materias.txt)
lista_ciudades="Maldonado Piriapolis Montevideo San_Jose Colonia Pando Colonia San_Luis Piedras_Blancas La_Union San_Peperino_Pomoro"
lista_departamentos="Artigas Canelones Cerro_Largo Colonia Durazno Flores Florida Lavalleja Maldonado Montevideo Paysandú Río_Negro Rivera Rocha Salto San_José Soriano Tacuarembó Treinta_y_Tres"
lista_tipos_evaluacion="Trabajo_laboratorio Trabajo_domiciliario Trabajo_practico Trabajo_investigacion Trabajo_escrito Oral Parcial Primera_entrega_proyecto Segunda_entrega_proyecto Defensa_individual Defensa_grupal"


    


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
	digito_verificador=`awk -v digito1="${digitos[0]}"  -v digito2="${digitos[1]}" -v digito3="${digitos[2]}" -v digito4="${digitos[3]}" -v digito5="${digitos[4]}" -v digito6="${digitos[5]}" -v digito7="${digitos[6]}" 'BEGIN { print   ( (digito1 * 8) + (digito2 * 1) + (digito3 * 2) + (digito4 * 3) + (digito5 * 4) + (digito6 * 7) + (digito7 * 6) )    % 10  } ';`
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
# Una vez definidas todas las funciones, iteramos generando records ficticios
##########################################################################


echo "$( date ) - Proceso iniciado..."

###########################################
## Tabla Ciudad
###########################################

# CREATE TABLE Ciudad
#  (
#   id_ciudad SERIAL PRIMARY KEY  CONSTRAINT Ciudad_clave_primaria,
#   nombre_ciudad varchar(50) NOT NULL CONSTRAINT Ciudad_nombre_vacio,
#   nombre_departamento varchar(50) NOT NULL CONSTRAINT Departamento_nombre_vacio,
#   baja boolean NOT NULL CONSTRAINT Ciudad_baja_vacio
#  );
	echo "Generando Ciudad"	
	i=0;
	> ./todos_codigos_ciudad.txt
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 02_AUTOMATICO_ingresar_ciudades_auto.sql
	echo -e '\n' >> 02_AUTOMATICO_ingresar_ciudades_auto.sql

	while read ciudad
	do
	
		echo "INSERT INTO Ciudad (nombre_ciudad, nombre_departamento,baja)" >> 02_AUTOMATICO_ingresar_ciudades_auto.sql
		nombre_ciudad="$ciudad" 
		nombre_departamento=`Item_Aleatorio "$lista_departamentos"`
		echo "VALUES ( \"$nombre_ciudad\" , \"$nombre_departamento\" , \"f\" );" >> 02_AUTOMATICO_ingresar_ciudades_auto.sql
		(( i++ ))
		echo "$i" >> ./todos_codigos_ciudad.txt

	done <<< "$( echo $lista_ciudades | tr ' ' '\n' )"
###########################################
## FIN
###########################################

###########################################
## Tabla Materias
###########################################
#  CREATE TABLE Materias
#  (
#   id_materia  SERIAL PRIMARY KEY  CONSTRAINT Materias_clave_primaria,
#   nombre_materia  varchar(25) NOT NULL CONSTRAINT Materias_nombre_not_null,
#   descripcion   varchar(255),
#   baja boolean NOT NULL CONSTRAINT Materias_baja_vacio
#  );
	echo "Generando Grupos"	
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 04_AUTOMATICO_ingresar_materia_auto.sql
	echo -e '\n' >> 04_AUTOMATICO_ingresar_materia_auto.sql
	i=0;
	> ./todos_codigos_materia.txt
	while read materia
	do

		echo "INSERT INTO Materias (nombre_materia, descripcion,baja)" >> 04_AUTOMATICO_ingresar_materia_auto.sql
		nombre_materia="$materia" 
		descripcion="Esto se supone que es una descripcion"
		echo "VALUES ( \"$nombre_materia\" , \"$descripcion\" , \"f\" );" >> 04_AUTOMATICO_ingresar_materia_auto.sql
		(( i++ ))
		echo "$i" >> ./todos_codigos_materia.txt
	done <<< "$( cat ./lista_materias.txt )"
###########################################
## FIN
###########################################

###########################################
## Tabla Grupos
###########################################

# CREATE TABLE Grupos
#  (
#   id_grupo  SERIAL PRIMARY KEY  CONSTRAINT Grupos_clave_primaria,
#   nombre_grupo  varchar(5) NOT NULL CONSTRAINT Grupos_nombre_not_null,
#   orientacion   varchar(25) NOT NULL CHECK (orientacion IN ('ADMINISTRACIÓN','ELECTROELECTRÓNICA','QUÍMICA_BÁSICA','QUÍMICA_INDUSTRIAL','AERONÁUTICA','ELECTROMECÁNICA','TERMODINÁMICA','AGRARIO','ELECTROMECÁNICA_AUTOMOTRIZ','TURISMO','CONSTRUCCIÓN','INFORMÁTICA','DEPORTE_Y_RECREACIÓN','MAQUINISTA_NAVAL','ARTES_GRÁFICAS','ENERGÍAS_RENOVABLES','AUDIOVISUAL')) CONSTRAINT orientacion_valida,
#   turno   varchar(25) NOT NULL CHECK (turno IN ('Vespertino', 'Matutino', 'Nocturno')) CONSTRAINT turno_valido,
#   baja boolean NOT NULL CONSTRAINT Grupos_baja_vacio,

#   foranea_id_instituto INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT Grupos_fk_id_instituto
#  );
	echo "Generando Grupos"	
	> ./todos_codigos_grupos.txt
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 05_AUTOMATICO_ingresar_grupos_auto.sql
	echo -e '\n' >> 05_AUTOMATICO_ingresar_grupos_auto.sql
	i=0;
	while [ $i -le 20 ]
	do

		echo "INSERT INTO Grupos (nombre_grupo, orientacion, turno, baja)" >> 05_AUTOMATICO_ingresar_grupos_auto.sql
		nombre_grupo="3I"`Item_Aleatorio "$lista_grupos_letras"` 
		orientacion="INFORMÁTICA"
		turno=`Item_Aleatorio "$lista_turnos"` 
		echo "VALUES ( \"$nombre_grupo\" , \"$orientacion\" , \"$turno\" , \"f\" );" >> 05_AUTOMATICO_ingresar_grupos_auto.sql
		(( i++ ))
		echo "$i" >> ./todos_codigos_grupos.txt
	done <<< "$lista_materias"

###########################################
## FIN
###########################################

###########################################
## Tabla Personas
###########################################
# CREATE TABLE Personas
#  (
#   CI  INT PRIMARY KEY  CONSTRAINT Personas_clave_primaria,
#   primer_nombre   varchar(25) NOT NULL CONSTRAINT primer_nombre_vacio,
#   segundo_nombre   varchar(25),
#   primer_apellido   varchar(25) NOT NULL CONSTRAINT primer_apellido_vacio,
#   segundo_apellido   varchar(25),
#   fecha_nacimiento DATE NOT NULL CONSTRAINT fecha_nacimiento_vacio,
#   email varchar(80),
#   encriptacion_hash varchar(250),
#   encriptacion_sal varchar(250),
#   baja boolean NOT NULL CONSTRAINT Personas_baja_vacio
#  );
	echo "Generando Personas"	  
	> ./todas_las_CI_personas.txt

	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 06_AUTOMATICO_ingresar_personas_auto.sql
	echo -e '\n' >> 06_AUTOMATICO_ingresar_personas_auto.sql
	i=0;
	while [ $i -le 650 ]
	do
		
		echo "INSERT INTO Personas (CI, primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,fecha_nacimiento,email,encriptacion_hash,encriptacion_sal,baja)" >> 06_AUTOMATICO_ingresar_personas_auto.sql

		CI=`Cedula_Aleatoria` 
		echo "$CI" >> ./todas_las_CI_personas.txt
		primer_nombre=`Item_Aleatorio "$lista_nombres"`
		segundo_nombre=`Item_Aleatorio "$lista_nombres"` 
		primer_apellido=`Item_Aleatorio "$lista_apellidos"` 
		segundo_apellido=`Item_Aleatorio "$lista_apellidos"` 
		numero_dias=`Numero_Aleatorio 5400 19000` 
		fecha_nacimiento="`date +%m/%d/%Y --date "$numero_dias days ago"`"
		email="$primer_nombre.$segundo_nombre.$primer_apellido.$segundo_apellido@`Item_Aleatorio "$lista_pro_email"`"
		hace_proyecto=`Numero_Aleatorio 1 30`
		if [[ hace_proyecto -gt 29 ]]
		then
			hace_proyecto="t"
		else
			hace_proyecto="f"
		fi
		tipo="Alumno"
		echo "VALUES ( $CI , \"$primer_nombre\" , \"$segundo_nombre\" , \"$primer_apellido\" , \"$segundo_apellido\" , \"$fecha_nacimiento\" , \"$email\" , NULL , NULL , \"f\" );" >> 06_AUTOMATICO_ingresar_personas_auto.sql
		
		
		
		(( i++ ))
	done
###########################################
## FIN 
###########################################

###########################################
## Tabla Alumnos
###########################################
#  CREATE TABLE Alumno
#  (
#   CI_alumno INT PRIMARY KEY REFERENCES Personas (CI) CONSTRAINT Alumno_fk_personas_CI,
#   hace_proyecto boolean NOT NULL CONSTRAINT hace_proyecto_vacio,
#   nota_final INT CHECK ( nota_final > 0 AND nota_final < 13) CONSTRAINT nota_final_valida,
#   baja boolean NOT NULL CONSTRAINT Alumno_baja_vacio
#  );

    echo "Generando Alumnos"	  
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 07_AUTOMATICO_ingresar_alumno_auto.sql
	echo -e '\n' >> 07_AUTOMATICO_ingresar_alumno_auto.sql

	lista_CI_alumno=$( tail -550  ./todas_las_CI_personas.txt)
	> ./todas_CI_alumno.txt
	i=0;
	while read CI_alumno
	do
		
		echo "INSERT INTO Alumno (CI_alumno, hace_proyecto, nota_final, baja)" >> 07_AUTOMATICO_ingresar_alumno_auto.sql

		CI_alumno="$CI_alumno"
		echo "$CI_alumno" >> ./todas_CI_alumno.txt
		nota_final=1
		echo "VALUES ( $CI_alumno, \"t\", $nota_final, \"f\" );" >> 07_AUTOMATICO_ingresar_alumno_auto.sql
		
		
		(( i++ ))
	done <<< "$lista_CI_alumno"
###########################################
## FIN 
###########################################

###########################################
## Tabla Profesores
###########################################
#  CREATE TABLE Profesor
#  (
#   CI_profesor INT PRIMARY KEY REFERENCES Personas (CI) CONSTRAINT Profesor_fk_personas_CI,
#   grado INT CHECK ( grado > 0 AND grado < 8) CONSTRAINT grado_valido,
#   baja boolean NOT NULL CONSTRAINT Profesor_baja_vacio
#  );
	echo "Generando Profesores"	
	lista_CI_profesor=$( head -50  ./todas_las_CI_personas.txt)
	> ./todas_CI_Profesores.txt
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 08_AUTOMATICO_ingresar_profesor_auto.sql
	echo -e '\n' >> 08_AUTOMATICO_ingresar_profesor_auto.sql
	i=0;
	while read CI_profesor
	do
	
		echo "INSERT INTO Profesor (CI_profesor, grado, baja)" >> 08_AUTOMATICO_ingresar_profesor_auto.sql

		CI_profesor="$CI_profesor"
		echo "$CI_profesor" >> ./todas_CI_Profesores.txt
		grado=`Numero_Aleatorio 1 7`
		echo "VALUES ( $CI_profesor, $grado, \"f\" );" >> 08_AUTOMATICO_ingresar_profesor_auto.sql
		
		
		(( i++ ))
	done <<< "$lista_CI_profesor"
###########################################
## FIN 
###########################################

###########################################
## Tabla relacion_Grupos_tienen_Materias
###########################################
# CREATE TABLE relacion_Grupos_tienen_Materias
# (
#     foranea_id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT relacion_Grupos_tienen_Materias_fk_Grupos_id_grupo,
#     foranea_id_materia  INTEGER REFERENCES Materias (id_materia) CONSTRAINT relacion_Grupos_tienen_Materias_fk_id_materia,
#     PRIMARY KEY (foranea_id_grupo,foranea_id_materia) CONSTRAINT relacion_Grupos_tienen_Materias_clave_primaria
# );

	echo "Generando relacion_Grupos_tienen_Materias"
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
	echo -e '\n' >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql

	while read id_grupo
	do
		
		echo "INSERT INTO relacion_Grupos_tienen_Materias (foranea_id_grupo, foranea_id_materia)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 56 );" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "INSERT INTO relacion_Grupos_tienen_Materias (foranea_id_grupo, foranea_id_materia)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 57 );" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "INSERT INTO relacion_Grupos_tienen_Materias (foranea_id_grupo, foranea_id_materia)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 58 );" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "INSERT INTO relacion_Grupos_tienen_Materias (foranea_id_grupo, foranea_id_materia)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 59 );" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "INSERT INTO relacion_Grupos_tienen_Materias (foranea_id_grupo, foranea_id_materia)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 60 );" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "INSERT INTO relacion_Grupos_tienen_Materias (foranea_id_grupo, foranea_id_materia)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 61 );" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "INSERT INTO relacion_Grupos_tienen_Materias (foranea_id_grupo, foranea_id_materia)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 62 );" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		
	done <<< "$( cat ./todos_codigos_grupos.txt )"

###########################################
## FIN 
###########################################

###########################################
## Tabla relacion_Grupos_pertenecen_Institutos
###########################################
# CREATE TABLE relacion_Grupos_pertenecen_Institutos
# (
#     foranea_id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT relacion_Grupos_pertenecen_Institutos_fk_Grupos_id_grupo,
#     foranea_id_instituto  INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT relacion_Grupos_pertenecen_Institutos_fk_id_instituto,
#     PRIMARY KEY (foranea_id_grupo, foranea_id_instituto) CONSTRAINT relacion_Grupos_pertenecen_Institutos_clave_primaria
# );

	echo "Generando relacion_Grupos_pertenecen_Institutos"
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 10_AUTOMATICO_relacion_Grupos_pertenecen_Institutos_auto.sql
	echo -e '\n' >> 10_AUTOMATICO_relacion_Grupos_pertenecen_Institutos_auto.sql

	while read id_grupo
	do
		
		echo "INSERT INTO relacion_Grupos_pertenecen_Institutos (foranea_id_grupo, foranea_id_instituto)" >> 10_AUTOMATICO_relacion_Grupos_pertenecen_Institutos_auto.sql
		echo "VALUES ( $id_grupo, 1 );" >> 10_AUTOMATICO_relacion_Grupos_pertenecen_Institutos_auto.sql
		
		
	done <<< "$( cat ./todos_codigos_grupos.txt )"

###########################################
## FIN 
###########################################


###########################################
## Tabla relacion_Profesor_pertenece_Instituto
###########################################
# CREATE TABLE relacion_Profesor_pertenece_Instituto
# (
#     foranea_CI_profesor INTEGER REFERENCES Profesor (CI_profesor) CONSTRAINT relacion_Profesor_pertenece_Instituto_fk_Personas_CI,
#     foranea_id_instituto  INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT relacion_Profesor_pertenece_Instituto_fk_id_instituto,
#     PRIMARY KEY (foranea_CI_profesor, foranea_id_instituto) CONSTRAINT relacion_Profesor_pertenece_Instituto_clave_primaria
# );

	echo "Generando relacion_Profesor_pertenece_Instituto"
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 11_AUTOMATICO_relacion_Profesor_pertenece_Instituto_auto.sql
	echo -e '\n' >> 11_AUTOMATICO_relacion_Profesor_pertenece_Instituto_auto.sql

	while read id_profesor
	do
		
		echo "INSERT INTO relacion_Profesor_pertenece_Instituto (foranea_CI_profesor, foranea_id_instituto)" >> 11_AUTOMATICO_relacion_Profesor_pertenece_Instituto_auto.sql
		echo "VALUES ( $id_profesor, 1 );" >> 11_AUTOMATICO_relacion_Profesor_pertenece_Instituto_auto.sql
		
		
	done <<< "$( cat ./todas_CI_Profesores.txt )"

###########################################
## FIN 
###########################################


###########################################
## Tabla relacion_Alumno_pertenece_Instituto
###########################################
# CREATE TABLE relacion_Alumno_pertenece_Instituto
# (
#     foranea_CI_alumno INTEGER REFERENCES Personas (CI) CONSTRAINT relacion_Alumno_pertenece_Instituto_fk_Personas_CI,
#     foranea_id_instituto  INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT relacion_Alumno_pertenece_Instituto_fk_id_instituto,
#     PRIMARY KEY (foranea_CI_alumno, foranea_id_instituto) CONSTRAINT relacion_Alumno_pertenece_Instituto_clave_primaria
# );

	echo "Generando relacion_Alumno_pertenece_Instituto"
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 12_AUTOMATICO_relacion_Alumno_pertenece_Instituto_auto.sql
	echo -e '\n' >> 12_AUTOMATICO_relacion_Alumno_pertenece_Instituto_auto.sql

	while read id_alumno
	do
		
		echo "INSERT INTO relacion_Alumno_pertenece_Instituto (foranea_CI_alumno, foranea_id_instituto)" >> 12_AUTOMATICO_relacion_Alumno_pertenece_Instituto_auto.sql
		echo "VALUES ( $id_alumno, 1 );" >> 12_AUTOMATICO_relacion_Alumno_pertenece_Instituto_auto.sql
		
		
	done <<< "$( cat ./todas_CI_alumno.txt )"

###########################################
## FIN 
###########################################

###########################################
## Tabla relacion_Alumno_Materias_Grupos
###########################################
# CREATE TABLE relacion_Alumno_Materias_Grupos
# (
#     foranea_CI_alumno INTEGER REFERENCES Personas (CI) CONSTRAINT relacion_Alumno_Materias_Grupos_fk_Personas_CI,
#     foranea_id_materia  INTEGER REFERENCES Materias (id_materia) CONSTRAINT relacion_Alumno_Materias_Grupos_fk_id_materia,
#     foranea_id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT relacion_Alumno_Materias_Grupos_fk_id_grupo,
#     PRIMARY KEY (foranea_CI_alumno, foranea_id_materia, foranea_id_grupo) CONSTRAINT rrelacion_personas_pertenecen_grupos_clave_primaria
# );
	> ./lista_alumnos_asignados_a_materia_y_grupo.txt
	echo "Generando relacion_Alumno_Materias_Grupos"
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 13_AUTOMATICO_relacion_Alumno_Materias_Grupos_auto.sql
	echo -e '\n' >> 13_AUTOMATICO_relacion_Alumno_Materias_Grupos_auto.sql
	offset=0
	while read id_grupo
	do
		i=56
		while [ $i -le 62 ]
		do
			while read alumno
			do
				echo "INSERT INTO relacion_Alumno_Materias_Grupos (foranea_CI_alumno, foranea_id_materia, foranea_id_grupo)" >> 13_AUTOMATICO_relacion_Alumno_Materias_Grupos_auto.sql
				echo "VALUES ( $alumno, $i, $id_grupo );"  >> 13_AUTOMATICO_relacion_Alumno_Materias_Grupos_auto.sql
				echo "$alumno $i $id_grupo" >> ./lista_alumnos_asignados_a_materia_y_grupo.txt
			done <<< "$( tail -n +$offset ./todas_CI_alumno.txt | head  -25 )"
			(( i++ ))
		done 
		offset=$(( offset + 26 ))
	done <<< "$( cat ./todos_codigos_grupos.txt )"
###########################################
## FIN 
###########################################


###########################################
## Tabla relacion_Profesor_Materias_Grupos
###########################################
# CREATE TABLE relacion_Profesor_Materias_Grupos
# (
#     foranea_CI_profesor INTEGER REFERENCES Profesor (CI_profesor) CONSTRAINT relacion_Profesor_Materias_Grupos_fk_Personas_CI,
#     foranea_id_materia  INTEGER REFERENCES Materias (id_materia) CONSTRAINT relacion_Profesor_Materias_Grupos_fk_id_materia,
#     foranea_id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT relacion_Profesor_Materias_Grupos_fk_id_grupo,
#     PRIMARY KEY (foranea_CI_profesor, foranea_id_materia, foranea_id_grupo) CONSTRAINT relacion_Profesor_Materias_Grupos_clave_primaria
# );
	echo "Generando relacion_Profesor_Materias_Grupos"
	> ./lista_profesores_asignados_a_materia_y_grupo.txt
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 14_AUTOMATICO_relacion_Profesor_Materias_Grupos_auto.sql
	echo -e '\n' >> 14_AUTOMATICO_relacion_Profesor_Materias_Grupos_auto.sql
	offset=0
	while read id_grupo
	do
		i=56
		while [ $i -le 62 ]
		do
				lista_CI_profesor=$( echo "$lista_CI_profesor" | tr '\n' ' ' )
				profe=`Item_Aleatorio "$lista_CI_profesor"`
				echo "INSERT INTO relacion_Profesor_Materias_Grupos (foranea_CI_profesor, foranea_id_materia, foranea_id_grupo)" >> 14_AUTOMATICO_relacion_Profesor_Materias_Grupos_auto.sql
				echo "VALUES ( $profe, $i, $id_grupo );"  >> 14_AUTOMATICO_relacion_Profesor_Materias_Grupos_auto.sql
				echo "$profe $i $id_grupo" >> ./lista_profesores_asignados_a_materia_y_grupo.txt
				(( i ++ ))
		done 
		offset=$(( offset + 21 ))
	done <<< "$( cat ./todos_codigos_grupos.txt )"


###########################################
## FIN 
###########################################

###########################################
## Tabla Evaluaciones
###########################################
#  CREATE TABLE Evaluaciones
#  (
#   id_evaluacion  SERIAL,
#   CI_profesor INTEGER REFERENCES Personas (CI) CONSTRAINT evaluaciones_fk_personas_CI_profesor,
#   CI_alumno INTEGER REFERENCES Personas (CI) CONSTRAINT evaluaciones_fk_personas_CI_alumno,
#   id_materia INTEGER REFERENCES Materias (id_materia) CONSTRAINT evaluaciones_fk_materias_id_materia,
#   id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT evaluaciones_fk_grupos_id_grupo,
#   nombre_evaluacion varchar(40) NOT NULL CONSTRAINT Evaluaciones_nombre_vacio,
#   categoria varchar(30) NOT NULL CHECK (categoria IN ('Trabajo_laboratorio', 'Trabajo_domiciliario', 'Trabajo_practico', 'Trabajo_investigacion', 'Trabajo_escrito', 'Oral', 'Parcial', 'Primera_entrega_proyecto', 'Segunda_entrega_proyecto', 'Tercera_entrega_proyecto', 'Defensa_individual', 'Defensa_grupal')) CONSTRAINT Evaluaciones_categoria_valida,
#   fecha_eva DATE NOT NULL CONSTRAINT fecha_eva_vacio,
#   descripcion   varchar(255),
#   nota INT CHECK ( nota > 0 AND nota < 13) CONSTRAINT evaluaciones_nota_valida,
#   baja boolean NOT NULL CONSTRAINT Evaluaciones_baja_vacio,

#   PRIMARY KEY (id_evaluacion,CI_profesor, CI_alumno, id_materia, id_grupo ) CONSTRAINT evaluaciones_clave_primaria
#  );

	echo "Generando Evaluaciones"
	
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 15_AUTOMATICO_ingresar_Evaluaciones_auto.sql
	echo -e '\n' >> 15_AUTOMATICO_ingresar_Evaluaciones_auto.sql
	i=0
	while [ $i -le 100 ]
	do
	
			lista_CI_profesor=$( cat ./lista_profesores_asignados_a_materia_y_grupo.txt | awk '{ print $1}' | tr '\n' ' ' )
			profe=`Item_Aleatorio "$lista_CI_profesor"`
			echo "Buscando un grupo, un alumno y una materia relacionados con $profe..."
			grupos_del_profe=`grep "$profe" ./lista_profesores_asignados_a_materia_y_grupo.txt | awk '{ print $3}' | tr '\n' ' '`
			un_grupo_del_profe=`Item_Aleatorio "$grupos_del_profe"`
			
			materias_que_da_para_ese_grupo=`grep "$profe" ./lista_profesores_asignados_a_materia_y_grupo.txt | grep -E "$un_grupo_del_profe"'$' | awk '{ print $2}' | tr '\n' ' '`
			
			una_materia_que_da_el_profe=`Item_Aleatorio "$materias_que_da_para_ese_grupo"`
			echo "Buscando alumnos de ese grupo y esa materia :  $un_grupo_del_profe y $una_materia_que_da_el_profe"
			alumnos_de_ese_grupo_y_esa_materia=`grep " $una_materia_que_da_el_profe $un_grupo_del_profe" ./lista_alumnos_asignados_a_materia_y_grupo.txt | awk '{ print $1}' | tr '\n' ' ' `
			un_alumno_random=`Item_Aleatorio "$alumnos_de_ese_grupo_y_esa_materia"`
			numero_dias=`Numero_Aleatorio 1 90` 
			fecha_eva="`date +%m/%d/%Y --date "$numero_dias days ago"`"
			categoria=`Item_Aleatorio "$lista_tipos_evaluacion"`
			nota=`Numero_Aleatorio 1 12` 
			echo "Insertando $profe $un_alumno_random $una_materia_que_da_el_profe $un_grupo_del_profe $categoria $fecha_eva $nota ..."
			echo "INSERT INTO Evaluaciones (CI_profesor, CI_alumno, id_materia, id_grupo, nombre_evaluacion, categoria, fecha_eva , descripcion, nota, baja )" >> 15_AUTOMATICO_ingresar_Evaluaciones_auto.sql
			
			echo "VALUES ( $profe, $un_alumno_random, $una_materia_que_da_el_profe, $un_grupo_del_profe, \"Un trabajillo\",  \"$categoria\", \"$fecha_eva\", \"Esto es una descripcion\", $nota, \"f\");"  >> 15_AUTOMATICO_ingresar_Evaluaciones_auto.sql
			
			(( i ++ ))
	done


###########################################
## FIN 
###########################################



echo "$( date ) - Proceso completado!!!"
