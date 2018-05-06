CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';



-- ACA CREAMOS LAS TABLAS DE ENTIDAD
------------------------------------

DROP TABLE IF EXISTS Personas;
DROP TABLE IF EXISTS Grupos;
DROP TABLE IF EXISTS Materias;
DROP TABLE IF EXISTS Evaluaciones;
DROP TABLE IF EXISTS Institutos;
DROP TABLE IF EXISTS Departamentos;

CREATE TABLE Personas
 (
  CI  INT PRIMARY KEY  CONSTRAINT Personas_clave_primaria,
  primer_nombre   varchar(25) NOT NULL CONSTRAINT primer_nombre_vacio,
  segundo_nombre   varchar(25),
  primer_apellido   varchar(25) NOT NULL CONSTRAINT primer_apellido_vacio,
  segundo_apellido   varchar(25),
  grado INT CHECK ( grado > 0 AND grado < 8) CONSTRAINT validar_grado,
  fecha_nacimiento DATE NOT NULL CONSTRAINT fecha_nacimiento_vacio,
  nota INT CHECK ( nota > 0 AND nota < 13) CONSTRAINT nota_valida,
  email varchar(80),
  hace_proyecto boolean NOT NULL CONSTRAINT hace_proyecto_vacio,
  tipo varchar(20) CHECK (tipo IN ('Admin', 'Docente', 'Alumno')) CONSTRAINT tipo_valido,
  encriptacion_hash varchar(250),
  encriptacion_sal varchar(250),
  baja boolean NOT NULL CONSTRAINT Personas_baja_vacio
 );

CREATE TABLE Grupos
 (
  id_grupo  SERIAL PRIMARY KEY  CONSTRAINT Grupos_clave_primaria,
  nombre_grupo  varchar(5) NOT NULL CONSTRAINT Grupos_nombre_not_null,
  orientacion   varchar(25) NOT NULL CHECK (orientacion IN ('Informatica', 'Mecanica', 'Electronica', 'Electromecanica')) CONSTRAINT orientacion_valida,
  turno   varchar(25) NOT NULL CHECK (turno IN ('Vespertino', 'Matutino', 'Nocturno')) CONSTRAINT turno_valido,
  baja boolean NOT NULL CONSTRAINT Grupos_baja_vacio,

  foranea_id_instituto INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT Grupos_fk_id_instituto
 );

 
 CREATE TABLE Materias
 (
  nombre_materia  varchar(25) PRIMARY KEY  CONSTRAINT Materias_clave_primaria,
  descripcion   varchar(255),
  baja boolean NOT NULL CONSTRAINT Materias_baja_vacio
 );

 CREATE TABLE Evaluaciones
 (
  id_evaluacion  SERIAL PRIMARY KEY CONSTRAINT Evaluaciones_clave_primaria,
  nombre_tarea  varchar(40) NOT NULL CONSTRAINT Evaluaciones_nombre_vacio,
  categoria varchar(30) NOT NULL CHECK (categoria IN ('Trabajo_laboratorio', 'Trabajo_domiciliario', 'Trabajo_practico', 'Trabajo_investigacion', 'Trabajo_escrito', 'Oral', 'Parcial', 'Primera_entrega_proyecto', 'Segunda_entrega_proyecto', 'Tercera_entrega_proyecto', 'Defensa_individual', 'Defensa_grupal')) CONSTRAINT Evaluaciones_categoria_valida,
  descripcion   varchar(255),
  baja boolean NOT NULL CONSTRAINT Evaluaciones_baja_vacio
 );

CREATE TABLE Institutos
 (
  id_instituto  SERIAL PRIMARY KEY  CONSTRAINT Institutos_clave_primaria,
  nombre  varchar(50) NOT NULL CONSTRAINT Institutos_nombre_vacio,
  calle   varchar(50) NOT NULL CONSTRAINT Institutos_calle_vacio,
  numero  INT,
  telefonos varchar(100),
  email varchar(80),
  baja boolean NOT NULL CONSTRAINT Institutos_baja_vacio,

  foranea_id_departamento INTEGER REFERENCES Departamentos (id_departamento) CONSTRAINT Institutos_fk_id_departamento
 );

CREATE TABLE Departamentos
 (
  id_departamento SERIAL PRIMARY KEY  CONSTRAINT Departamentos_clave_primaria,
  nombre_departamento varchar(50) NOT NULL CONSTRAINT Departamentos_nombre_vacio,
  baja boolean NOT NULL CONSTRAINT Departamentos_baja_vacio
 );
                                        
                                        
-- ACA CREAMOS LAS TABLAS DE RELACIONES
------------------------------------

DROP TABLE IF EXISTS relacion_personas_pertenecen_instituto;
DROP TABLE IF EXISTS relacion_materias_pertenecen_grupos;
DROP TABLE IF EXISTS relacion_ternaria_Personas_Grupos_Evaluaciones;
DROP TABLE IF EXISTS relacion_Evaluaciones_pertenecen_Personas;




                                        
CREATE TABLE relacion_personas_pertenecen_instituto
(
    foranea_ci INTEGER REFERENCES Personas (ci) CONSTRAINT relacion_personas_pertenecen_instituto_fk_ci,
    foranea_id_instituto  INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT relacion_personas_pertenecen_instituto_fk_id_instituto,
    PRIMARY KEY (foranea_ci, foranea_id_instituto) CONSTRAINT relacion_personas_pertenecen_instituto_clave_primaria
);

CREATE TABLE relacion_materias_pertenecen_grupos
(
    foranea_id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT relacion_materias_pertenecen_grupos_fk_id_grupo,
    foranea_id_materia  INTEGER REFERENCES Materias (id_materia) CONSTRAINT relacion_materias_pertenecen_grupos_fk_id_materia,
    PRIMARY KEY (foranea_id_grupo, foranea_id_materia) CONSTRAINT relacion_materias_pertenecen_grupos_clave_primaria
);


CREATE TABLE relacion_ternaria_Personas_Grupos_Evaluaciones
(
    foranea_ci INTEGER REFERENCES Personas (ci) CONSTRAINT relacion_ternaria_Personas_Grupos_Evaluaciones_fk_ci,
    foranea_id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT relacion_ternaria_Personas_Grupos_Evaluaciones_fk_id_grupo,
    foranea_id_evaluacion  INTEGER REFERENCES Materias (id_evaluacion) CONSTRAINT relacion_ternaria_Personas_Grupos_Evaluaciones_fk_id_materia,
    PRIMARY KEY (foranea_ci,foranea_id_grupo, foranea_id_materia) CONSTRAINT relacion_ternaria_Personas_Grupos_Evaluaciones_clave_primaria
);

CREATE TABLE relacion_Evaluaciones_pertenecen_Personas
(
    foranea_ci INTEGER REFERENCES Personas (ci) CONSTRAINT relacion_ternaria_Personas_Grupos_Evaluaciones_fk_ci,
    foranea_id_evaluacion  INTEGER REFERENCES Materias (id_evaluacion) CONSTRAINT relacion_ternaria_Personas_Grupos_Evaluaciones_fk_id_materia,
    PRIMARY KEY (foranea_ci,foranea_id_materia) CONSTRAINT relacion_ternaria_Personas_Grupos_Evaluaciones_clave_primaria
);






-- 
                                        
                                        
