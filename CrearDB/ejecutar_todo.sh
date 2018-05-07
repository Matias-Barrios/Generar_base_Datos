#/bin/bash

echo "Ejecutar todo - $( date )"

dbaccess - Generar_estructuras.sql && \
dbaccess - ingresar_alumnos_auto.sql && \
dbaccess - ingresar_docentes_auto.sql && \
dbaccess - ingresar_departamentos_auto.sql && \
dbaccess - ingresar_institutos_auto.sql && \
dbaccess - ingresar_materias_auto.sql && \
dbaccess - ingresar_grupos_auto.sql

echo "Completado!! "`date`


	
