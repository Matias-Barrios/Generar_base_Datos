# command : dbaccess - select_simple.sql
CONNECT TO 'gestion_utu@miServidor' USER 'matias' USING 'PASSWORDHERE';

USE gestion_utu;

CREATE TABLE IF NOT EXISTS Usuarios 
 (
  id_usuario  SERIAL PRIMARY KEY,
  nombre   CHAR(20),
  apellido   CHAR(20)
 );
 
   
