#/bin/bash

echo "Ejecutar todo - $( date )"

dbaccess - Generar_estructuras.sql && \
dbaccess - LEO_ingresar_ciudades_auto.sql && \
dbaccess - LEO_ingresar_materias_auto.sql  && \
dbaccess - LEO_ingresar_institutos_auto.sql && \
dbaccess - LEO_ingresar_grupos_auto.sql && \
dbaccess - LEO_ingresar_personas_auto.sql


echo "Completado!! "`date`


	
