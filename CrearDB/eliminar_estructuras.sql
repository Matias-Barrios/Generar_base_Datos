CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUSARIOXXX' USING 'XXXPASSWORDXXX';


-- ACA CREAMOS LAS TABLAS DE ENTIDAD
------------------------------------

DROP TABLE IF EXISTS Personas;
DROP TABLE IF EXISTS Evaluaciones;
DROP TABLE IF EXISTS Grupos;
DROP TABLE IF EXISTS Institutos;
DROP TABLE IF EXISTS Materias;
DROP TABLE IF EXISTS Ciudad;
DROP TABLE IF EXISTS Alumno;
DROP TABLE IF EXISTS Profesor;


DROP TABLE IF EXISTS relacion_Profesor_pertenece_Instituto;
DROP TABLE IF EXISTS relacion_Alumno_pertenece_Instituto;
DROP TABLE IF EXISTS relacion_Grupos_pertenecen_Institutos;
DROP TABLE IF EXISTS relacion_Grupos_tienen_Materias;
DROP TABLE IF EXISTS relacion_Alumno_Materias_Grupos;
DROP TABLE IF EXISTS relacion_Profesor_Materias_Grupos;
