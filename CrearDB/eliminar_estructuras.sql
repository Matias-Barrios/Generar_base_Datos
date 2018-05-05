-- command : dbaccess - select_simple.sql
-- CREATE TABLE IF NOT EXISTS Usuarios

CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX' USING 'XXXPASSWORDXXX';


-- ACA CREAMOS LAS TABLAS DE ENTIDAD
------------------------------------

DROP TABLE IF EXISTS Personas;
DROP TABLE IF EXISTS Grupos;
DROP TABLE IF EXISTS Materias;
DROP TABLE IF EXISTS Evaluaciones;
DROP TABLE IF EXISTS Institutos;
DROP TABLE IF EXISTS Departamentos;
