-- Que grupos tiene asignados un profesor

SELECT nombre_grupo FROM Grupos 
WHERE id_grupo IN ( 
    SELECT foranea_id_grupo FROM relacion_Profesor_Materias_Grupos 
    WHERE foranea_CI_profesor = 47530149
     );

 
-- Alumnos que pertenecen a un profesor
SELECT A.foranea_CI_alumno
    FROM relacion_Alumno_Materias_Grupos A, relacion_Profesor_Materias_Grupos P
    WHERE  A.foranea_id_grupo = P.foranea_id_grupo AND A.foranea_id_materia = P.foranea_id_materia
    AND P.foranea_CI_profesor = 35879723;


-- Profesores que tiene un alumno
SELECT P.foranea_CI_profesor
    FROM relacion_Alumno_Materias_Grupos A, relacion_Profesor_Materias_Grupos P
    WHERE  A.foranea_id_grupo = P.foranea_id_grupo AND A.foranea_id_materia = P.foranea_id_materia
    AND A.foranea_CI_alumno = 18426866;


-- De que da clases un Profesor

SELECT nombre_materia FROM Materias 
WHERE id_materia IN ( 
    SELECT foranea_id_materia FROM relacion_Profesor_Materias_Grupos 
    WHERE foranea_CI_profesor=47530149 );

-- Que clases tiene un Alumno

SELECT nombre_materia FROM Materias 
WHERE id_materia IN ( 
    SELECT foranea_id_materia FROM relacion_Alumno_Materias_Grupos 
    WHERE foranea_CI_alumno=23639175 );

-- Notas relacionadas al Proyecto
SELECT nota FROM Evaluaciones 
    WHERE CI_alumno = 45245241 AND 
    categoria IN ( 'Primera_entrega_proyecto', 
                   'Segunda_entrega_proyecto', 
                   'Entrega_final_proyecto', 
                   'Defensa_individual', 
                   'Defensa_grupal', 
                   'Es_proyecto');

-- Promedio de las calificaciones de proyecto

SELECT (avg(nota) * 0.60) FROM Evaluaciones 
    WHERE CI_alumno = 33137078 AND 
    categoria IN ( 'Primera_entrega_proyecto', 
                   'Segunda_entrega_proyecto', 
                   'Entrega_final_proyecto', 
                   'Defensa_individual', 
                   'Defensa_grupal', 
                   'Es_proyecto');


-- TOP 5 alumnos con mas notas relacionadas al proyecto
 -- Por cedula
    SELECT CI_alumno,count(*)
        FROM Evaluaciones
            WHERE categoria IN ( 'Primera_entrega_proyecto',
                                    'Segunda_entrega_proyecto',
                                    'Entrega_final_proyecto',
                                    'Defensa_individual',
                                    'Defensa_grupal',
                                    'Es_proyecto')
        GROUP BY CI_alumno ORDER BY count(*) DESC;

 -- Por Nombre y apellido
    SELECT FIRST 5
            *,
        count(*)
        FROM Personas
                INNER JOIN Evaluaciones
                        ON Evaluaciones.CI_alumno = Personas.CI
        WHERE categoria IN ( 'Primera_entrega_proyecto',
                                    'Segunda_entrega_proyecto',
                                    'Entrega_final_proyecto',
                                    'Defensa_individual',
                                    'Defensa_grupal',
                                    'Es_proyecto')
        GROUP BY 
                    CI,
                    primer_nombre,
                    primer_apellido
        ORDER BY count(*) DESC;

    -- Sacar todos las evaluaciones de un alumno

    SELECT * FROM Evaluaciones WHERE CI_alumno = 33137078;


    -- Edad promedio de personas

    SELECT CAST ( avg(CAST ( fecha_nacimiento AS FLOAT)) AS DATE ) 
        FROM Personas;

    -- Alumnos que hacen proyecto

    SELECT ( primer_nombre || ' ' ||  primer_apellido) AS Nombre
        FROM Personas 
        WHERE CI IN (
                SELECT CI_alumno
                    FROM Alumno
                    WHERE hace_proyecto = "t"
                );
   