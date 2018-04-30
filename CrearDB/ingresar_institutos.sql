-- command : dbaccess - select_simple.sql

CONNECT TO 'gestion_utu@miServidor' USER 'admin_proyecto'  USING 'XXXXXXXX';

INSERT INTO Institutos (nombre, calle, numero, telefonos, email, baja)
VALUES ('Escuela Técnica "Arroyo Seco"',"Av. Agraciada Esq. Aguilar",2544,"etas010@gmail.com","f");


