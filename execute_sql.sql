USE prueba_matias;
CREATE TABLE Usuarios 
 (
  id_usuario  SERIAL PRIMARY KEY,
  nombre   CHAR(20),
  apellido   CHAR(20)
 );
   
   
INSERT INTO Usuarios (nombre, apellido)
VALUES ("Matias","Barrios");

