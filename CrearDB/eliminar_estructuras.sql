CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX' USING 'XXXPASSWORDXXX';


-- ACA CREAMOS LAS TABLAS DE ENTIDAD
------------------------------------

DROP TABLE IF EXISTS Personas;
DROP TABLE IF EXISTS Grupos;
DROP TABLE IF EXISTS Materias;
DROP TABLE IF EXISTS Evaluaciones;
DROP TABLE IF EXISTS Institutos;
DROP TABLE IF EXISTS Departamentos;

DROP TABLE IF EXISTS relacion_personas_pertenecen_instituto;
DROP TABLE IF EXISTS relacion_materias_pertenecen_grupos;
DROP TABLE IF EXISTS relacion_ternaria_Personas_Grupos_Evaluaciones;
DROP TABLE IF EXISTS relacion_Evaluaciones_pertenecen_Personas;
