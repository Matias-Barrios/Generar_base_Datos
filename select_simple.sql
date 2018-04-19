# command : dbaccess - select_simple.sql
CONNECT TO 'gestion_utu@miServidor' USER 'admin_proyecto'  USING 'XXXXXXXX';

DROP TABLE IF EXISTS Usuarios;

CREATE TABLE IF NOT EXISTS Usuarios
 (
  id_usuario  SERIAL PRIMARY KEY,
  nombre   CHAR(20),
  apellido   CHAR(20)
 );



