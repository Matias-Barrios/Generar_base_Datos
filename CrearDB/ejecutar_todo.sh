#/bin/bash

echo "Ejecutar todo - $( date )"

dbaccess - Generar_estructuras.sql && \
dbaccess - LEO_ingresar_ciudades_auto.sql && \
dbaccess - LEO_ingresar_materias_auto.sql  && \
dbaccess - LEO_ingresar_institutos_auto.sql && \
dbaccess - LEO_ingresar_grupos_auto.sql && \
dbaccess - LEO_ingresar_personas_auto.sql && \
dbaccess - LEO_ingresar_profesor_auto.sql && \
dbaccess - LEO_ingresar_alumnos_auto.sql && \
dbaccess - LEO_relacion_Alumno_Materias_Grupos_Autos.sql && \
dbaccess - LEO_relacion_Alumno_pertenece_Instituto.sql && \
dbaccess - LEO_relacion_Grupos_pertenecen_Institutos_Auto.sql && \
dbaccess - LEO_relacion_Grupos_tienen_Materias_auto.sql && \
dbaccess - LEO_relacion_Profesor_Materias_Grupos_Autos.sql && \
dbaccess - LEO_relacion_Profesor_pertenece_Instituto_auto.sql && \
dbaccess - LEO_ingresar_evaluaciones.sql

echo "Completado!! "`date`


	
