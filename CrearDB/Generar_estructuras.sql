-- command : dbaccess - select_simple.sql
-- CREATE TABLE IF NOT EXISTS Usuarios

CONNECT TO 'gestion_utu@miServidor' USER 'admin_proyecto'  USING 'XXXXXXXX';

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
  baja boolean 
 );

-- 
-- DROP TABLE IF EXISTS Usuarios;

-- select tabname,colname,coltype,collength from systables as a join syscolumns as b on a.tabid=b.tabid where tabname='Usuarios';
-- select tabname,colname,coltype,collength from systables as a join syscolumns as b on a.tabid=b.tabid where tabname='Usuarios';





