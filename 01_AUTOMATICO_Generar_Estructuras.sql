CONNECT TO 'gestion_utu@miServidor' USER 'XXXNOMBREUSUARIOXXX'  USING 'XXXPASSWORDXXX';



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
DROP TABLE IF EXISTS Calificaciones;

CREATE TABLE Ciudad
 (
  id_ciudad SERIAL PRIMARY KEY  CONSTRAINT Ciudad_clave_primaria,
  nombre_ciudad varchar(50) NOT NULL CONSTRAINT Ciudad_nombre_vacio,
  nombre_departamento varchar(50) NOT NULL CONSTRAINT Departamento_nombre_vacio,
  baja boolean NOT NULL CONSTRAINT Ciudad_baja_vacio
 );

 
 CREATE TABLE Materias
 (
  id_materia  SERIAL PRIMARY KEY  CONSTRAINT Materias_clave_primaria,
  nombre_materia  varchar(25) NOT NULL CONSTRAINT Materias_nombre_not_null,
  descripcion   varchar(255),
  baja boolean NOT NULL CONSTRAINT Materias_baja_vacio
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

  foranea_id_ciudad INTEGER REFERENCES Ciudad (id_ciudad) CONSTRAINT Institutos_fk_id_ciudad
 ); 

CREATE TABLE Grupos
 (
  id_grupo  SERIAL PRIMARY KEY  CONSTRAINT Grupos_clave_primaria,
  nombre_grupo  varchar(5) NOT NULL CONSTRAINT Grupos_nombre_not_null,
  orientacion   varchar(25) NOT NULL CHECK (orientacion IN ('ADMINISTRACIÓN','ELECTROELECTRÓNICA','QUÍMICA_BÁSICA','QUÍMICA_INDUSTRIAL','AERONÁUTICA','ELECTROMECÁNICA','TERMODINÁMICA','AGRARIO','ELECTROMECÁNICA_AUTOMOTRIZ','TURISMO','CONSTRUCCIÓN','INFORMÁTICA','DEPORTE_Y_RECREACIÓN','MAQUINISTA_NAVAL','ARTES_GRÁFICAS','ENERGÍAS_RENOVABLES','AUDIOVISUAL')) CONSTRAINT orientacion_valida,
  turno   varchar(25) NOT NULL CHECK (turno IN ('Vespertino', 'Matutino', 'Nocturno')) CONSTRAINT turno_valido,
  baja boolean NOT NULL CONSTRAINT Grupos_baja_vacio,

  foranea_id_instituto INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT Grupos_fk_id_instituto
 );




CREATE TABLE Personas
 (
  CI  INT PRIMARY KEY  CONSTRAINT Personas_clave_primaria,
  primer_nombre   varchar(25) NOT NULL CONSTRAINT primer_nombre_vacio,
  segundo_nombre   varchar(25),
  primer_apellido   varchar(25) NOT NULL CONSTRAINT primer_apellido_vacio,
  segundo_apellido   varchar(25),
  fecha_nacimiento DATE NOT NULL CONSTRAINT fecha_nacimiento_vacio,
  email varchar(80),
  grado INT CHECK ( grado > 0 AND grado < 8) CONSTRAINT grado_valido,
  hace_proyecto boolean NOT NULL CONSTRAINT hace_proyecto_vacio,
  nota_final INT CHECK ( nota_final > 0 AND nota_final < 13) CONSTRAINT nota_final_valida,
  juicio_final varchar(30) NOT NULL CHECK ( juicio_final IN ('Examen Febrero', 'Examen Diciembre', 'Aprobado')) CONSTRAINT Personas_Juicio_valido,
  tipo varchar(30) NOT NULL CHECK ( tipo IN ('Alumno', 'Profesor', 'Administrador')) CONSTRAINT Personas_tipo_valido,
  encriptacion_hash varchar(250),
  encriptacion_sal varchar(250),
  es_admin boolean NOT NULL CONSTRAINT Personas_es_admin_vacio,
  baja boolean NOT NULL CONSTRAINT Personas_baja_vacio
 );
 
 CREATE TABLE Calificaciones
 (
  id_calificacion  SERIAL,
  CI_profesor INTEGER REFERENCES Personas (CI) CONSTRAINT Calificaciones_fk_personas_CI_profesor,
  CI_alumno INTEGER REFERENCES Personas (CI) CONSTRAINT Calificaciones_fk_personas_CI_alumno,
  id_materia INTEGER REFERENCES Materias (id_materia) CONSTRAINT Calificaciones_fk_materias_id_materia,
  id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT Calificaciones_fk_grupos_id_grupo,
  nombre_evaluacion varchar(40) NOT NULL CONSTRAINT Calificaciones_nombre_vacio,
  comentario varchar(500) NOT NULL CONSTRAINT Calificaciones_nombre_vacio,
  categoria varchar(30) NOT NULL CHECK (categoria IN ('Trabajo_laboratorio', 'Trabajo_domiciliario', 'Trabajo_practico', 'Trabajo_investigacion', 'Trabajo_escrito', 'Oral', 'Parcial', 'Primera_entrega_proyecto', 'Segunda_entrega_proyecto', 'Entrega_final_proyecto', 'Defensa_individual', 'Defensa_grupal', 'Es_proyecto')) CONSTRAINT Calificaciones_categoria_valida,
  fecha_eva DATE NOT NULL CONSTRAINT Calificaciones_fecha_eva_vacio,
  descripcion   varchar(255),
  nota INT CHECK ( nota > 0 AND nota < 13) CONSTRAINT Calificaciones_nota_valida,
  baja boolean NOT NULL CONSTRAINT Calificaciones_baja_vacio,
  
  PRIMARY KEY (id_calificacion) CONSTRAINT Calificaciones_clave_primaria
 );

                                        
-- ACA CREAMOS LAS TABLAS DE RELACIONES
------------------------------------ nota INT CHECK ( nota > 0 AND nota < 13) CONSTRAINT nota_valida,
-- grado INT CHECK ( grado > 0 AND grado < 8) CONSTRAINT validar_grado,
-- tipo varchar(20) CHECK (tipo IN ('Admin', 'Docente', 'Alumno')) CONSTRAINT tipo_valido,


DROP TABLE IF EXISTS relacion_Grupos_tienen_Materias;
DROP TABLE IF EXISTS relacion_Grupos_pertenecen_Institutos;
DROP TABLE IF EXISTS relacion_Profesor_pertenece_Instituto;
DROP TABLE IF EXISTS relacion_Alumno_pertenece_Instituto;
DROP TABLE IF EXISTS relacion_Alumno_Materias_Grupos;

DROP TABLE IF EXISTS relacion_Profesor_Materias_Grupos;



                                        
CREATE TABLE relacion_Profesor_pertenece_Instituto
(
    foranea_CI_profesor INTEGER REFERENCES Personas (CI) CONSTRAINT relacion_Profesor_pertenece_Instituto_fk_Personas_CI,
    foranea_id_instituto  INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT relacion_Profesor_pertenece_Instituto_fk_id_instituto,
    PRIMARY KEY (foranea_CI_profesor, foranea_id_instituto) CONSTRAINT relacion_Profesor_pertenece_Instituto_clave_primaria
);

CREATE TABLE relacion_Alumno_pertenece_Instituto
(
    foranea_CI_alumno INTEGER REFERENCES Personas (CI) CONSTRAINT relacion_Alumno_pertenece_Instituto_fk_Personas_CI,
    foranea_id_instituto  INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT relacion_Alumno_pertenece_Instituto_fk_id_instituto,
    PRIMARY KEY (foranea_CI_alumno, foranea_id_instituto) CONSTRAINT relacion_Alumno_pertenece_Instituto_clave_primaria
);


CREATE TABLE relacion_Grupos_pertenecen_Institutos
(
    foranea_id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT relacion_Grupos_pertenecen_Institutos_fk_Grupos_id_grupo,
    foranea_id_instituto  INTEGER REFERENCES Institutos (id_instituto) CONSTRAINT relacion_Grupos_pertenecen_Institutos_fk_id_instituto,
    PRIMARY KEY (foranea_id_grupo, foranea_id_instituto) CONSTRAINT relacion_Grupos_pertenecen_Institutos_clave_primaria
);

CREATE TABLE relacion_Grupos_tienen_Materias
(
    foranea_id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT relacion_Grupos_tienen_Materias_fk_Grupos_id_grupo,
    foranea_id_materia  INTEGER REFERENCES Materias (id_materia) CONSTRAINT relacion_Grupos_tienen_Materias_fk_id_materia,
    PRIMARY KEY (foranea_id_grupo,foranea_id_materia) CONSTRAINT relacion_Grupos_tienen_Materias_clave_primaria
);

CREATE TABLE relacion_Alumno_Materias_Grupos
(
    foranea_CI_alumno INTEGER REFERENCES Personas (CI) CONSTRAINT relacion_Alumno_Materias_Grupos_fk_Personas_CI,
    foranea_id_materia  INTEGER REFERENCES Materias (id_materia) CONSTRAINT relacion_Alumno_Materias_Grupos_fk_id_materia,
    foranea_id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT relacion_Alumno_Materias_Grupos_fk_id_grupo,
    PRIMARY KEY (foranea_CI_alumno, foranea_id_materia, foranea_id_grupo) CONSTRAINT rrelacion_personas_pertenecen_grupos_clave_primaria
);

CREATE TABLE relacion_Profesor_Materias_Grupos
(
    foranea_CI_profesor INTEGER REFERENCES Personas (CI) CONSTRAINT relacion_Profesor_Materias_Grupos_fk_Personas_CI,
    foranea_id_materia  INTEGER REFERENCES Materias (id_materia) CONSTRAINT relacion_Profesor_Materias_Grupos_fk_id_materia,
    foranea_id_grupo INTEGER REFERENCES Grupos (id_grupo) CONSTRAINT relacion_Profesor_Materias_Grupos_fk_id_grupo,
    PRIMARY KEY (foranea_CI_profesor, foranea_id_materia, foranea_id_grupo) CONSTRAINT relacion_Profesor_Materias_Grupos_clave_primaria
);




-- 
                                        
                                        
