-- command : dbaccess - select_simple.sql
-- CREATE TABLE IF NOT EXISTS Usuarios

CONNECT TO 'gestion_utu@miServidor' USER 'admin_proyecto'  USING 'XXXXXXXX';

INSERT INTO Usuarios (CI, primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,grado,fecha_nacimiento,nota,email,hace_proyecto,tipo,encriptacion_hash,encriptacion_sal,baja)
VALUES (41217832,"Gabriel","Matias","Barrios","Cabrera",1,"10/28/1986",1,"soymatiasbarrios@gmail.com","t","Alumno",NULL,NULL,"f");

 
