-- command : dbaccess - select_simple.sql
-- CREATE TABLE IF NOT EXISTS Usuarios

CONNECT TO 'gestion_utu@miServidor' USER 'admin_proyecto'  USING 'XXXXXXXX';



-- ACA CREAMOS LAS TABLAS DE ENTIDAD
------------------------------------

DROP TABLE IF EXISTS Usuarios;
DROP TABLE IF EXISTS Grupos;
DROP TABLE IF EXISTS Materias;
DROP TABLE IF EXISTS Tareas;
DROP TABLE IF EXISTS Institutos;

CREATE TABLE Usuarios
 (
  CI  INT PRIMARY KEY,
  primer_nombre   varchar(25) NOT NULL,
  segundo_nombre   varchar(25),
  primer_apellido   varchar(25) NOT NULL,
  segundo_apellido   varchar(25),
  grado INT CHECK ( grado > 0 AND grado < 8) CONSTRAINT validar_grado,
  fecha_nacimiento DATE NOT NULL,
  nota INT CHECK ( nota > 0 AND nota < 13) CONSTRAINT nota_valida,
  email varchar(80),
  hace_proyecto boolean,
  tipo varchar(20) CHECK (tipo IN ('Admin', 'Docente', 'Alumno')) CONSTRAINT tipo_valido,
  encriptacion_hash varchar(250),
  encriptacion_sal varchar(250),
  baja boolean NOT NULL
 );

CREATE TABLE Grupos
 (
  nombre_grupo  varchar(5) PRIMARY KEY ,
  orientacion   varchar(25) NOT NULL CHECK (orientacion IN ('Informatica', 'Mecanica', 'Electronica', 'Electromecanica')) CONSTRAINT orientacion_valida,
  turno   varchar(25) NOT NULL CHECK (turno IN ('Vespertino', 'Matutino', 'Nocturno')) CONSTRAINT turno_valido,
  baja boolean NOT NULL
 );
 
 CREATE TABLE Materias
 (
  nombre_materia  varchar(25) PRIMARY KEY ,
  descripcion   varchar(255),
  baja boolean NOT NULL
 );

 CREATE TABLE Tareas
 (
  id_tarea  INT PRIMARY KEY,
  nombre_tarea  varchar(40),
  categoria varchar(30) NOT NULL CHECK (categoria IN ('Trabajo_laboratorio', 'Trabajo_domiciliario', 'Trabajo_practico', 'Trabajo_investigacion', 'Trabajo_escrito', 'Oral', 'Parcial', 'Primera_entrega_proyecto', 'Segunda_entrega_proyecto', 'Tercera_entrega_proyecto', 'Defensa_individual', 'Defensa_grupal')) CONSTRAINT tarea_categoria_valida,
  descripcion   varchar(255),
  baja boolean NOT NULL
 );

CREATE TABLE Institutos
 (
  id_instituto  INT PRIMARY KEY,
  calle   varchar(50) NOT NULL,
  numero   INT,
  baja boolean NOT NULL
 );



-- ACA CREAMOS LAS TABLAS DE RELACIONES
------------------------------------

DROP TABLE IF EXISTS relacion_Usuarios_pertenecen_Instituto;
                                        
CREATE TABLE relacion_Usuarios_pertenecen_Instituto
 (
  foranea_CI_usuario CONSTRAINT 'foranea_Usuarios' FOREIGN KEY ('foranea_CI_usuario') REFERENCES 'Usuarios' ('CI') ON DELETE CASCADE ON UPDATE CASCADE,
  foranea_id_instituto  CONSTRAINT 'foranea_Instituto' FOREIGN KEY ('foranea_id_instituto') REFERENCES 'Institutos' ('id_instituto') ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (foranea_CI_usuario,foranea_id_instituto)
 );
                                        
-- 
                                        
                                        
