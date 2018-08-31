#!/bin/bash

##
##  Este script genera una lista de tres columnas con dos nombres, dos apellidos y una edad de manera aleatoria basandose en dos lemarios que se encuentra en GitHub
##  
##  Nombre    : https://raw.githubusercontent.com/olea/lemarios/master/nombres-propios-es.txt
##  Apellidos : https://raw.githubusercontent.com/olea/lemarios/master/apellidos-es.txt
##
# ##
#  Sacar tildes
#
# while read file
# do
# 	echo "File:  $file"
# 	iconv -f UTF-8 -t ASCII//TRANSLIT $file > /tmp/tmp.txt && cat /tmp/tmp.txt > $file 

# done <<< "$all_Files"
## Cargar nombres como array 

lista_nombres=$( cat ./nombres_propios.txt | tr '\n' ' ' )
lista_apellidos=$( cat ./apellidos.txt | tr '\n' ' ' )
lista_tipos_usuario="Admin Docente Alumno" 
lista_pro_email="hotmail.com gmail.com its.edu.uy yahoo.com antel.com.uy"
lista_orientaciones=$( cat ./lista_orientaciones.txt)
lista_grupos_letras="A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
lista_turnos="Vespertino Matutino Nocturno"
lista_materias=$( cat ./lista_materias.txt)
lista_ciudades="Maldonado Piriapolis Montevideo San_Jose Colonia Pando Colonia San_Luis Piedras_Blancas La_Union San_Peperino_Pomoro"
lista_departamentos="Artigas Canelones Cerro_Largo Colonia Durazno Flores Florida Lavalleja Maldonado Montevideo Paysandú Río_Negro Rivera Rocha Salto San_José Soriano Tacuarembó Treinta_y_Tres"
lista_tipos_evaluacion="Trabajo_laboratorio Trabajo_domiciliario Trabajo_practico Trabajo_investigacion Trabajo_escrito Oral Parcial Primera_entrega_proyecto Segunda_entrega_proyecto Tercera_entrega_proyecto Defensa_individual Defensa_grupal Es_proyecto"
verdadero_o_falso="t f"
lista_tipos="Alumno Profesor Administrador"


    


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
## Tabla Asignturas
###########################################
#  CREATE TABLE Asignaturas
#  (
#   id_asignatura  SERIAL PRIMARY KEY  CONSTRAINT Materias_clave_primaria,
#   nombre_asignatura  varchar(25) NOT NULL CONSTRAINT Materias_nombre_not_null,
#   descripcion   varchar(255),
#   baja boolean NOT NULL CONSTRAINT Materias_baja_vacio
#  );

	echo "Generando Asignaturas"	
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 04_AUTOMATICO_ingresar_Asignturas_auto.sql
	echo -e '\n' >> 04_AUTOMATICO_ingresar_Asignturas_auto.sql
	i=0;
	> ./todos_codigos_materia.txt
	while read materia
	do

		echo "INSERT INTO Asignaturas (nombre_asignatura, descripcion,baja)" >> 04_AUTOMATICO_ingresar_Asignturas_auto.sql
		nombre_materia="$materia" 
		descripcion="Esto se supone que es una descripcion"
		echo "VALUES ( \"$nombre_materia\" , \"$descripcion\" , \"f\" );" >> 04_AUTOMATICO_ingresar_Asignturas_auto.sql
		(( i++ ))
		echo "$i" >> ./todos_codigos_materia.txt
	done <<< "$( cat ./lista_materias.txt )"
###########################################
## FIN
###########################################

###########################################
## Tabla Orientaciones
###########################################

# CREATE TABLE Orientaciones
#  (
#   id_orientacion SERIAL PRIMARY KEY CONSTRAINT Orientaciones_clave_primaria,
#   nombre_orientacion varchar(25) NOT NULL,
#   descripcion varchar (500),
#   baja boolean NOT NULL CONSTRAINT Orientaciones_baja_vacio
#  );

	echo "Generando Orientaciones"	
	> ./todos_codigos_orientacion.txt
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 05_AUTOMATICO_ingresar_orientaciones_auto.sql
	echo -e '\n' >> 05_AUTOMATICO_ingresar_orientaciones_auto.sql
	
	while read orientacion
	do

		echo "INSERT INTO Orientaciones (nombre_orientacion,descripcion, baja)" >> 05_AUTOMATICO_ingresar_orientaciones_auto.sql
		echo "VALUES ( \"$orientacion\" , \"$descripcion\" , \"f\" );" >> 05_AUTOMATICO_ingresar_orientaciones_auto.sql
		(( i++ ))
		echo "$i" >> ./todos_codigos_orientacion.txt
	done <<< "$lista_orientaciones"

###########################################
## FIN
###########################################

###########################################
## Tabla Grupos
###########################################

# CREATE TABLE Grupos
#  (
#   id_grupo  SERIAL,
#   foranea_id_instituto INTEGER REFERENCES Institutos (id_institutos) CONSTRAINT Grupos_fk_Instiuto_id_instituto,
#   nombre_grupo  varchar(5) NOT NULL CONSTRAINT Grupos_nombre_not_null,
#   turno   varchar(25) NOT NULL CHECK (turno IN ('Vespertino', 'Matutino', 'Nocturno')) CONSTRAINT turno_valido,
#   baja boolean NOT NULL CONSTRAINT Grupos_baja_vacio,
#   foranea_id_orientacion INTEGER REFERENCES Orientaciones (id_orientacion) CONSTRAINT Grupos_fk_id_Orientacion
#   PRIMARY KEY (id_grupo, foranea_id_instituto) CONSTRAINT Grupos_claves_primarias
#  );

	echo "Generando Grupos"	
	> ./todos_codigos_grupos.txt
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 06_AUTOMATICO_ingresar_grupos_auto.sql
	echo -e '\n' >> 06_AUTOMATICO_ingresar_grupos_auto.sql
	i=0;
	while [ $i -le 20 ]
	do

		echo "INSERT INTO Grupos (foranea_id_instituto,nombre_grupo, turno, baja, foranea_id_orientacion)" >> 06_AUTOMATICO_ingresar_grupos_auto.sql
		nombre_grupo="3I"`Item_Aleatorio "$lista_grupos_letras"` 
		turno=`Item_Aleatorio "$lista_turnos"` 
		echo "VALUES ( 1, \"$nombre_grupo\" , \"$turno\" , \"f\",  12 );" >> 06_AUTOMATICO_ingresar_grupos_auto.sql
		(( i++ ))
		echo "$i" >> ./todos_codigos_grupos.txt
	done <<< "$lista_materias"

###########################################
## FIN
###########################################

###########################################
## Tabla Personas - Alumnos
###########################################
# CREATE TABLE Personas
#  (
#   CI  INT PRIMARY KEY  CONSTRAINT Personas_clave_primaria,
#   primer_nombre varchar(25) NOT NULL CONSTRAINT primer_nombre_vacio,
#   segundo_nombre varchar(25) NOT NULL CONSTRAINT segundo_nombre_vacio,
#   primer_apellido varchar(25) NOT NULL CONSTRAINT primer_apellido_vacio,
#   segundo_apellido varchar(25) NOT NULL CONSTRAINT segundo_apellido_vacio,
#   fecha_nacimiento DATE NOT NULL CONSTRAINT fecha_nacimiento_vacio,
#   email varchar(80),
#   grado INT CHECK ( grado > 0 AND grado < 8) CONSTRAINT grado_valido,
#   hace_proyecto boolean NOT NULL CONSTRAINT hace_proyecto_vacio,
#   nota_final_pro INT CHECK ( nota_final_pro > 0 AND nota_final_pro < 13) CONSTRAINT nota_final_pro_valida,
#   juicio_final varchar(30) NOT NULL CHECK ( juicio_final IN ('Examen Febrero', 'Examen Diciembre', 'Aprobado')) CONSTRAINT Personas_Juicio_valido,
#   tipo varchar(30) NOT NULL CHECK ( tipo IN ('Alumno', 'Profesor', 'Administrador', 'Admin')) CONSTRAINT Personas_tipo_valido,
#   encriptacion_hash varchar(250),
#   encriptacion_sal varchar(250),
#   baja boolean NOT NULL CONSTRAINT Personas_baja_vacio
#  );
 
	echo "Generando Alumnos"	  
	> ./todas_CI_alumno.txt

	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 07_AUTOMATICO_ingresar_personas_alumnos_auto.sql
	echo -e '\n' >> 07_AUTOMATICO_ingresar_personas_alumnos_auto.sql
	i=0;
	while [ $i -le 1000 ]
	do
		
		echo "INSERT INTO Personas (CI, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, grado, hace_proyecto, nota_final_pro, juicio_final, tipo, encriptacion_hash, encriptacion_sal, baja)" >> 07_AUTOMATICO_ingresar_personas_alumnos_auto.sql

		CI=`Cedula_Aleatoria` 
		
		primer_nombre=`Item_Aleatorio "$lista_nombres"`
		segundo_nombre=`Item_Aleatorio "$lista_nombres"` 
		primer_apellido=`Item_Aleatorio "$lista_apellidos"` 
		segundo_apellido=`Item_Aleatorio "$lista_apellidos"` 
		numero_dias=`Numero_Aleatorio 5400 19000` 
		fecha_nacimiento="`date +%m/%d/%Y --date "$numero_dias days ago"`"
		email="$primer_nombre.$segundo_nombre.$primer_apellido.$segundo_apellido@`Item_Aleatorio "$lista_pro_email"`"
		tipo="Alumno"
		hace_proyecto="t"
		nota_final=1
		juicio_final="Examen Febrero"

		echo "VALUES ( $CI , \"$primer_nombre\" , \"$segundo_nombre\" , \"$primer_apellido\" , \"$segundo_apellido\" , \"$fecha_nacimiento\" , \"$email\" , NULL , \"$hace_proyecto\", $nota_final, \"$juicio_final\", \"$tipo\", NULL , NULL ,  \"f\" );" >> 07_AUTOMATICO_ingresar_personas_alumnos_auto.sql
		
		echo "$CI" >> ./todas_CI_alumno.txt
		
		
		(( i++ ))
	done
###########################################
## FIN 
###########################################

###########################################
## Tabla Personas - Profesores
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
#   grado INT CHECK ( grado > 0 AND grado < 8) CONSTRAINT grado_valido,
#   hace_proyecto boolean NOT NULL CONSTRAINT hace_proyecto_vacio,
#   nota_final INT CHECK ( nota_final > 0 AND nota_final < 13) CONSTRAINT nota_final_valida,
#   juicio_final varchar(30) NOT NULL CHECK ( juicio_final IN ('Examen Febrero', 'Examen Diciembre', 'Aprobado')) CONSTRAINT Personas_Juicio_valido,
#   tipo varchar(30) NOT NULL CHECK ( tipo IN ('Alumno', 'Profesor', 'Administrador')) CONSTRAINT Personas_tipo_valido,
#   encriptacion_hash varchar(250),
#   encriptacion_sal varchar(250),
#   baja boolean NOT NULL CONSTRAINT Personas_baja_vacio
#  );
	echo "Generando Profesores"	  
	> ./todas_CI_Profesores.txt

	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 08_AUTOMATICO_ingresar_personas_profesores_auto.sql
	echo -e '\n' >> 08_AUTOMATICO_ingresar_personas_profesores_auto.sql
	i=0;
	while [ $i -le 60 ]
	do
		
		echo "INSERT INTO Personas (CI, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, grado, hace_proyecto, nota_final_pro, juicio_final, tipo, encriptacion_hash, encriptacion_sal, baja)" >> 08_AUTOMATICO_ingresar_personas_profesores_auto.sql

		CI=`Cedula_Aleatoria` 
		
		primer_nombre=`Item_Aleatorio "$lista_nombres"`
		segundo_nombre=`Item_Aleatorio "$lista_nombres"` 
		primer_apellido=`Item_Aleatorio "$lista_apellidos"` 
		segundo_apellido=`Item_Aleatorio "$lista_apellidos"` 
		numero_dias=`Numero_Aleatorio 5400 19000` 
		fecha_nacimiento="`date +%m/%d/%Y --date "$numero_dias days ago"`"
		email="$primer_nombre.$segundo_nombre.$primer_apellido.$segundo_apellido@`Item_Aleatorio "$lista_pro_email"`"
		tipo="Profesor"
		grado=`Numero_Aleatorio 1 7` 
		hace_proyecto="t"
		nota_final=1
		juicio_final="Examen Febrero"

		echo "VALUES ( $CI , \"$primer_nombre\" , \"$segundo_nombre\" , \"$primer_apellido\" , \"$segundo_apellido\" , \"$fecha_nacimiento\" , \"$email\" , $grado, \"$hace_proyecto\", $nota_final, \"$juicio_final\", \"$tipo\", NULL , NULL ,  \"f\" );" >> 08_AUTOMATICO_ingresar_personas_profesores_auto.sql
		
		echo "$CI" >> ./todas_CI_Profesores.txt
		
		
		(( i++ ))
	done
###########################################
## FIN 
###########################################

###########################################
## Tabla Relacion_Grupos_Formado_Asignaturas
###########################################
# CREATE TABLE Relacion_Grupos_Formado_Asignaturas
# (
#     foranea_id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT Relacion_Grupos_Formado_Asignaturas_fk_Grupos_id_grupo,
#     foranea_id_asignatura  INTEGER REFERENCES Asignaturas (id_asignatura) CONSTRAINT Relacion_Grupos_Formado_Asignaturas_fk_id_asignatura,
#     foranea_id_instituto  INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT CONSTRAINT Relacion_Grupos_Formado_Asignaturas_fk_id_instituto,
#     PRIMARY KEY (foranea_id_grupo,foranea_id_asignatura,foranea_id_instituto) CONSTRAINT Relacion_Grupos_Formado_Asignaturas_clave_primaria
# );


	echo "Generando Relacion_Grupos_Formado_Asignaturas"
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
	echo -e '\n' >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql

	while read id_grupo
	do
		
		echo "INSERT INTO Relacion_Grupos_Formado_Asignaturas (foranea_id_grupo, foranea_id_asignatura, foranea_id_instituto)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 56, 1);" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "INSERT INTO Relacion_Grupos_Formado_Asignaturas (foranea_id_grupo, foranea_id_asignatura, foranea_id_instituto)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 57, 1);" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "INSERT INTO Relacion_Grupos_Formado_Asignaturas (foranea_id_grupo, foranea_id_asignatura, foranea_id_instituto)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 58, 1);" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "INSERT INTO Relacion_Grupos_Formado_Asignaturas (foranea_id_grupo, foranea_id_asignatura, foranea_id_instituto)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 59, 1);" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "INSERT INTO Relacion_Grupos_Formado_Asignaturas (foranea_id_grupo, foranea_id_asignatura, foranea_id_instituto)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 60, 1);" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "INSERT INTO Relacion_Grupos_Formado_Asignaturas (foranea_id_grupo, foranea_id_asignatura, foranea_id_instituto)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 61, 1);" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "INSERT INTO Relacion_Grupos_Formado_Asignaturas (foranea_id_grupo, foranea_id_asignatura, foranea_id_instituto)" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		echo "VALUES ( $id_grupo, 62, 1);" >> 09_AUTOMATICO_relacion_Grupos_tienen_Materias_auto.sql
		
	done <<< "$( cat ./todos_codigos_grupos.txt )"

###########################################
## FIN 
###########################################

###########################################
## Tabla Relacion_Docente_Trabaja_Instituto
###########################################
                                        
# CREATE TABLE Relacion_Docente_Trabaja_Instituto
# (
#     foranea_CI_docente INTEGER REFERENCES Persona (CI) CONSTRAINT Relacion_Docente_Trabaja_Instituto_fk_Personas_CI,
#     foranea_id_instituto  INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT Relacion_Docente_Trabaja_Instituto,
#     PRIMARY KEY (foranea_CI_docente, foranea_id_instituto) CONSTRAINT Relacion_Docente_Trabaja_Instituto
# );

	echo "Generando Relacion_Docente_Trabaja_Instituto"
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 10_AUTOMATICO_relacion_Profesor_pertenece_Instituto_auto.sql
	echo -e '\n' >> 10_AUTOMATICO_relacion_Profesor_pertenece_Instituto_auto.sql

	while read id_profesor
	do
		
		echo "INSERT INTO Relacion_Docente_Trabaja_Instituto (foranea_CI_docente, foranea_id_instituto)" >> 10_AUTOMATICO_relacion_Profesor_pertenece_Instituto_auto.sql
		echo "VALUES ( $id_profesor, 1 );" >> 10_AUTOMATICO_relacion_Profesor_pertenece_Instituto_auto.sql
		
		
	done <<< "$( cat ./todas_CI_Profesores.txt )"

###########################################
## FIN 
###########################################


###########################################
## Tabla Relacion_Alumno_Asiste_Instituto
###########################################
# CREATE TABLE Relacion_Alumno_Asiste_Instituto
# (
#     foranea_CI_alumno INTEGER REFERENCES Personas (CI) CONSTRAINT Relacion_Alumno_Asiste_Instituto_fk_Personas_CI,
#     foranea_id_instituto  INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT Relacion_Alumno_Asiste_Instituto_fk_id_instituto,
#     PRIMARY KEY (foranea_CI_alumno, foranea_id_instituto) CONSTRAINT Relacion_Alumno_Asiste_Instituto_clave_primaria
# );

	echo "Generando Relacion_Alumno_Asiste_Instituto"
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 11_AUTOMATICO_relacion_Alumno_pertenece_Instituto_auto.sql
	echo -e '\n' >> 11_AUTOMATICO_relacion_Alumno_pertenece_Instituto_auto.sql

	while read id_alumno
	do
		
		echo "INSERT INTO Relacion_Alumno_Asiste_Instituto (foranea_CI_alumno, foranea_id_instituto)" >> 11_AUTOMATICO_relacion_Alumno_pertenece_Instituto_auto.sql
		echo "VALUES ( $id_alumno, 1 );" >> 11_AUTOMATICO_relacion_Alumno_pertenece_Instituto_auto.sql
		
		
	done <<< "$( cat ./todas_CI_alumno.txt )"

###########################################
## FIN 
###########################################

###########################################
## Tabla relacion_Alumno_Materias_Grupos
###########################################

# CREATE TABLE Relacion_Alumno_Asignatura_Grupos
# (
#     foranea_CI_alumno INT REFERENCES Personas (CI) CONSTRAINT Relacion_Alumno_Asignatura_Grupos_fk_Personas_CI,
#     foranea_id_asignatura  INT REFERENCES Asignaturas (id_asignatura) CONSTRAINT Relacion_Alumno_Asignatura_Grupos_fk_id_asignatura,
#     foranea_id_grupo INT NOT NULL CONSTRAINT Relacion_Alumno_Asignatura_Grupos_fk_id_grupo,
#     foranea_id_instituto  INT NOT NULL CONSTRAINT Relacion_Alumno_Asignatura_Grupos_fk_id_instituto,
#     nota_final_asignatura INT CHECK ( nota_final_asignatura > 0 AND nota_final_asignatura < 13) CONSTRAINT nota_final_asignatura_valida,
#     nota_final_asignatura_proyecto INT CHECK ( nota_final_asignatura_proyecto > 0 AND nota_final_asignatura_proyecto < 13) CONSTRAINT nota_final_asignatura_proyecto_valida,
#     FOREIGN KEY  (foranea_id_grupo, foranea_id_instituto) REFERENCES Grupos CONSTRAINT Relacion_Alumno_Asignatura_Grupos_fk_clave_foranea_grupos_valida,
#     PRIMARY KEY (foranea_CI_alumno, foranea_id_asignatura, foranea_id_grupo, foranea_id_instituto) CONSTRAINT Relacion_Alumno_Asignatura_Grupos_clave_primaria
# );

	> ./lista_alumnos_asignados_a_materia_y_grupo.txt
	echo "Generando Relacion_Alumno_Asignatura_Grupos"
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 12_AUTOMATICO_relacion_Alumno_Materias_Grupos_auto.sql
	echo -e '\n' >> 12_AUTOMATICO_relacion_Alumno_Materias_Grupos_auto.sql
	offset=0
	while read id_grupo
	do
		i=56
		while [ $i -le 62 ]
		do
			while read alumno
			do
				echo "INSERT INTO Relacion_Alumno_Asignatura_Grupos (foranea_CI_alumno, foranea_id_asignatura, foranea_id_grupo, foranea_id_instituto, nota_final_asignatura, nota_final_asignatura_proyecto)" >> 12_AUTOMATICO_relacion_Alumno_Materias_Grupos_auto.sql
				echo "VALUES ( $alumno, $i, $id_grupo, 1, 1, 1);"  >> 12_AUTOMATICO_relacion_Alumno_Materias_Grupos_auto.sql
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
## Tabla Relacion_Docente_Asignatura_Grupos
###########################################
# CREATE TABLE Relacion_Docente_Asignatura_Grupos
# (
#     foranea_CI_docente INTEGER REFERENCES Persona (CI) CONSTRAINT Relacion_Docente_Asignatura_Grupos_fk_Personas_CI,
#     foranea_id_asignatura  INTEGER REFERENCES Asignaturas (id_asignatura) CONSTRAINT Relacion_Docente_Asignatura_Grupos_fk_id_asignatura,
#     foranea_id_instituto  INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT Relacion_Docente_Asignatura_Grupos_fk_id_instituto
#     foranea_id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT Relacion_Docente_Asignatura_Grupos_fk_id_grupo,
#     PRIMARY KEY (foranea_CI_docente, foranea_id_asignatura, foranea_id_grupo, foranea_id_instituto) CONSTRAINT Relacion_Docente_Asignatura_Grupos_clave_primaria
# );
	echo "Generando Relacion_Docente_Asignatura_Grupos"
	> ./lista_profesores_asignados_a_materia_y_grupo.txt
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 13_AUTOMATICO_Relacion_Docente_Asignatura_Grupos_auto.sql
	echo -e '\n' >> 13_AUTOMATICO_Relacion_Docente_Asignatura_Grupos_auto.sql
	offset=0
	while read id_grupo
	do
		i=56
		while [ $i -le 62 ]
		do
				lista_CI_profesor=$( cat ./todas_CI_Profesores.txt | tr '\n' ' ' )
				profe=`Item_Aleatorio "$lista_CI_profesor"`
				echo "INSERT INTO Relacion_Docente_Asignatura_Grupos (foranea_CI_docente, foranea_id_asignatura, foranea_id_grupo, foranea_id_instituto)" >> 13_AUTOMATICO_Relacion_Docente_Asignatura_Grupos_auto.sql
				echo "VALUES ( $profe, $i, $id_grupo, 1 );"  >> 13_AUTOMATICO_Relacion_Docente_Asignatura_Grupos_auto.sql
				echo "$profe $i $id_grupo" >> ./lista_profesores_asignados_a_materia_y_grupo.txt
				(( i ++ ))
		done 
		offset=$(( offset + 21 ))
	done <<< "$( cat ./todos_codigos_grupos.txt )"


###########################################
## FIN 
###########################################

###########################################
## Tabla Calificaciones
###########################################

# CREATE TABLE Calificaciones
#  (
#   id_calificacion SERIAL PRIMARY KEY  CONSTRAINT Calificaciones_clave_primaria,
#   CI_docente INT REFERENCES Personas (CI) CONSTRAINT calificaciones_fk_personas_docente_CI,
#   CI_alumno INT REFERENCES Personas (CI) CONSTRAINT calificaciones_fk_personas_alumno_CI,
#   id_asignatura INT REFERENCES Asignaturas (id_asignatura) CONSTRAINT calificaciones_fk_asignaturas_id_asignatura,
#   id_grupo INT NOT NULL CONSTRAINT calificaciones_fk_grupos_id_grupo,
#   id_instituto INT NOT NULL CONSTRAINT calificaciones_fk_instituto_id_instituto,
#   nombre_calificacion varchar(40) NOT NULL CONSTRAINT calificaciones_nombre_vacio,
#   categoria varchar(30) NOT NULL CHECK (categoria IN ('Trabajo_laboratorio', 'Trabajo_domiciliario', 'Trabajo_practico', 'Trabajo_investigacion', 'Trabajo_escrito', 'Oral', 'Parcial', 'Primera_entrega_proyecto', 'Segunda_entrega_proyecto', 'Tercera_entrega_proyecto', 'Defensa_individual', 'Defensa_grupal')) CONSTRAINT calificaciones_categoria_valida,
#   fecha DATE NOT NULL CONSTRAINT fecha_cal_vacio,
#   comentario varchar(255),
#   nota INT CHECK ( nota > 0 AND nota < 13) CONSTRAINT calificaciones_nota_valida,
#   baja boolean NOT NULL CONSTRAINT calificaciones_baja_vacio,
#   FOREIGN KEY  (id_grupo, id_instituto) REFERENCES Grupos CONSTRAINT calificaciones_fk_clave_foranea_valida
#  );


	echo "Generando Calificaciones"
	
	echo "CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';" > 14_AUTOMATICO_ingresar_Evaluaciones_auto.sql
	echo -e '\n' >> 14_AUTOMATICO_ingresar_Evaluaciones_auto.sql
	i=0
	while [ $i -le 10000 ]
	do
	
			lista_CI_profesor=$( cat ./lista_profesores_asignados_a_materia_y_grupo.txt | awk '{ print $1}' | tr '\n' ' ' )
			profe=`Item_Aleatorio "$lista_CI_profesor"`
			grupos_del_profe=`grep "$profe" ./lista_profesores_asignados_a_materia_y_grupo.txt | awk '{ print $3}' | tr '\n' ' '`
			un_grupo_del_profe=`Item_Aleatorio "$grupos_del_profe"`
			materias_que_da_para_ese_grupo=`grep "$profe" ./lista_profesores_asignados_a_materia_y_grupo.txt | grep -E "$un_grupo_del_profe"'$' | awk '{ print $2}' | tr '\n' ' '`
			una_materia_que_da_el_profe=`Item_Aleatorio "$materias_que_da_para_ese_grupo"`
			alumnos_de_ese_grupo_y_esa_materia=`grep " $una_materia_que_da_el_profe $un_grupo_del_profe" ./lista_alumnos_asignados_a_materia_y_grupo.txt | awk '{ print $1}' | tr '\n' ' ' `
			un_alumno_random=`Item_Aleatorio "$alumnos_de_ese_grupo_y_esa_materia"`
			numero_dias=`Numero_Aleatorio 1 90` 
			fecha_eva="`date +%m/%d/%Y --date "$numero_dias days ago"`"
			categoria=`Item_Aleatorio "$lista_tipos_evaluacion"`
			nota=`Numero_Aleatorio 1 12` 
			nombre_evaluacion="Un trabajillo"
						
			echo "INSERT INTO Calificaciones (CI_docente, CI_alumno, id_asignatura, id_grupo, id_instituto ,nombre_calificacion, categoria, fecha , comentario, nota, baja )" >> 14_AUTOMATICO_ingresar_Evaluaciones_auto.sql
			echo "VALUES ( $profe, $un_alumno_random, $una_materia_que_da_el_profe, $un_grupo_del_profe, 1 ,\"$nombre_evaluacion\",  \"$categoria\", \"$fecha_eva\", \"Esto es una descripcion\", $nota, \"f\" );"  >> 14_AUTOMATICO_ingresar_Evaluaciones_auto.sql
			
			(( i ++ ))
	done


###########################################
## FIN 
###########################################



echo "$( date ) - Proceso completado!!!"
