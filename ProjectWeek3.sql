USE cs_ny;
SELECT *
FROM parking_violations_issued_filtered;
-- ¿Cuál es la infracción más común por tipo de vehículo (Vehicle Body Type)?
SELECT p2.`Vehicle Body Type`,
	(SELECT `Violation Code`
    FROM parking_violations_issued_filtered AS p
    WHERE p.`Vehicle Body Type`=p2.`Vehicle Body Type`
    GROUP BY `Violation Code`
    ORDER BY COUNT(*)
    LIMIT 1) AS most_common_violation
FROM parking_violations_issued_filtered AS p2
GROUP BY `Vehicle Body Type`;
-- ¿Qué marca de vehículo (Vehicle Make) recibe más multas?
SELECT `Vehicle Make`, COUNT(`Violation Code`) AS number_multas
FROM parking_violations_issued_filtered
GROUP BY `Vehicle Make`
ORDER BY number_multas DESC;
-- ¿Cuál es la agencia emisora (Issuing Agency) con más actividad?
SELECT `Issuing Agency`, COUNT(`Issuing Agency`) AS act,
(COUNT(`Issuing Agency`)/(SELECT COUNT(*) FROM parking_violations_issued_filtered )*100 )AS proportion_from_total
FROM parking_violations_issued_filtered
GROUP BY `Issuing Agency`
ORDER BY act DESC
LIMIT 1;
-- ¿Qué calles  tienen la mayor cantidad de infracciones?
SELECT Street, COUNT(Street) AS s_c,
(COUNT(Street)/(SELECT COUNT(*) FROM parking_violations_issued_filtered )*100 )AS proportion_from_total
FROM parking_violations_issued_filtered
GROUP BY Street
ORDER BY s_c DESC
LIMIT 8;
-- ¿Cantidad de infracciones según el  mes?
SELECT MONTH(`Issue date`) AS month_, COUNT(`Violation Code`) AS count_violations
FROM parking_violations_issued_filtered
GROUP BY month_
ORDER BY month_ DESC;
-- ¿Cómo varían las infracciones según el dia de la semana?
SELECT DAYOFWEEK(`Issue date`) AS day_of_week, COUNT(`Violation Code`) AS count_violations
FROM parking_violations_issued_filtered
GROUP BY  day_of_week
ORDER BY day_of_week DESC;
-- ¿Cuál es el porcentaje de infracciones que involucran vehículos de empresas (placas comerciales) frente a vehículos particulares?
SELECT 
(SELECT COUNT(*) FROM parking_violations_issued_filtered WHERE `Plate Type`="COM")/COUNT(*)*100 AS commercial_percentage,
(SELECT COUNT(*) FROM parking_violations_issued_filtered WHERE `Plate Type`="PAS")/COUNT(*)*100 AS personal_porcentage,
(SELECT COUNT(*) FROM parking_violations_issued_filtered WHERE `Plate Type`NOT IN ("COM","PAS"))/COUNT(*)*100 AS other_porcentage
FROM parking_violations_issued_filtered;
