-- Script IDEMPOTENTE para registrar la informacion del mundial Qatar 2022, incluyendo:
-- * Paises Participantes
-- * Paises Organizadores
-- * Ciudades y Estadios
-- * Grupos y los paises integrantes
-- * Encuentros de la fase de grupos

--1. Agregar Paises
INSERT INTO pais
	(pais, entidad)
	VALUES
	('Alemania', 'Federación Alemana de Fútbol'),
	('Arabia Saudita', 'Federación de Fútbol de Arabia Saudita'),
	('Argentina', 'Asociación del Fútbol Argentino'),
	('Australia', 'Football Australia'),
	('Bélgica', 'Real Asociación Belga de Fútbol'),
	('Brasil', 'Confederación Brasileña de Fútbol'),
	('Camerún', 'Federación Camerunesa de Fútbol'),
	('Canadá', 'Canada Soccer'),
	('Catar', 'Asociación de Fútbol de Catar'),
	('Corea del Sur', 'Asociación de Fútbol de Corea'),
	('Costa Rica', 'Federación Costarricense de Fútbol'),
	('Croacia', 'Federación Croata de Fútbol'),
	('Dinamarca', 'Asociación Danesa de Fútbol'),
	('Ecuador', 'Federación Ecuatoriana de Fútbol'),
	('España', 'Real Federación Española de Fútbol'),
	('Estados Unidos', 'Federación de Fútbol de los Estados Unidos'),
	('Francia', 'Federación Francesa de Fútbol'),
	('Gales', 'Asociación de Fútbol de Gales'),
	('Ghana', 'Asociación de Fútbol de Ghana'),
	('Inglaterra', 'The Football Association'),
	('Irán', 'Federación Islámica de Fútbol de Irán'),
	('Japón', 'Asociación Japonesa de Fútbol'),
	('Marruecos', 'Real Federación Marroquí de Fútbol'),
	('México', 'Federación Mexicana de Fútbol'),
	('Países Bajos', 'Real Asociación Neerlandesa de Fútbol'),
	('Polonia', 'Asociación Polaca de Fútbol'),
	('Portugal', 'Federación Portuguesa de Fútbol'),
	('Senegal', 'Federación Senegalesa de Fútbol'),
	('Serbia', 'Asociación de Fútbol de Serbia'),
	('Suiza', 'Asociación Suiza de Fútbol'),
	('Túnez', 'Federación Tunecina de Fútbol'),
	('Uruguay', 'Asociación Uruguaya de Fútbol')
	ON CONFLICT(pais)
	DO UPDATE
		SET entidad = excluded.entidad
		WHERE excluded.entidad<>'';

--2. Agregar Campeonato
INSERT INTO campeonato
	(campeonato, año)
	VALUES('FIFA World Cup 2022', 2022)
	ON CONFLICT(campeonato)
	DO UPDATE
		SET año = excluded.año;

--3. Agregar Paises Organizadores
INSERT INTO campeonatopais
	(idcampeonato, idpais)
	SELECT C.id, P.id
		FROM campeonato C, pais P
		WHERE P.pais IN ('Catar')
			AND campeonato = 'FIFA World Cup 2022'
	ON CONFLICT(idcampeonato, idpais)
	DO NOTHING;

--4. Agregar los grupos
INSERT INTO grupo
	(idcampeonato, grupo)
	SELECT C.id, datos.grupo
		FROM campeonato C
			JOIN(
			VALUES
				('A'),
				('B'),
				('C'),
				('D'),
				('E'),
				('F'),
				('G'),
				('H')
			) datos(grupo)
			ON C.campeonato = 'FIFA World Cup 2022'
		ON CONFLICT(idcampeonato, grupo)
		DO NOTHING;

--5. Agregar las selecciones de cada grupo
INSERT INTO GrupoPais
	(idGrupo, idPais)
	SELECT G.id, P.id
		FROM grupo G
			JOIN campeonato C on G.idcampeonato = C.id
			JOIN (
				VALUES
					-- Grupo A
					('A', 'Catar'),
					('A', 'Ecuador'),
					('A', 'Senegal'),
					('A', 'Países Bajos'),
					
					-- Grupo B
					('B', 'Inglaterra'),
					('B', 'Irán'),
					('B', 'Estados Unidos'),
					('B', 'Gales'),
					
					-- Grupo C
					('C', 'Argentina'),
					('C', 'Arabia Saudita'),
					('C', 'México'),
					('C', 'Polonia'),
					
					-- Grupo D
					('D', 'Francia'),
					('D', 'Australia'),
					('D', 'Dinamarca'),
					('D', 'Túnez'),
					
					-- Grupo E
					('E', 'España'),
					('E', 'Costa Rica'),
					('E', 'Alemania'),
					('E', 'Japón'),
					
					-- Grupo F
					('F', 'Bélgica'),
					('F', 'Canadá'),
					('F', 'Marruecos'),
					('F', 'Croacia'),
					
					-- Grupo G
					('G', 'Brasil'),
					('G', 'Serbia'),
					('G', 'Suiza'),
					('G', 'Camerún'),
					
					-- Grupo H
					('H', 'Portugal'),
					('H', 'Ghana'),
					('H', 'Uruguay'),
					('H', 'Corea del Sur')
			) datos(grupo, pais)
			ON G.grupo = datos.grupo
			JOIN pais P ON datos.pais = P.pais
			WHERE C.campeonato = 'FIFA World Cup 2022'
		ON CONFLICT(idgrupo, idpais)
			DO NOTHING;

--6. Agregar ciudades
INSERT INTO Ciudad
	(ciudad, idpais)
	SELECT datos.ciudad, P.id
		FROM (
			VALUES
			('Al Khor', 'Catar'),
			('Lusail', 'Catar'),
			('Doha', 'Catar'),
			('Rayán', 'Catar'),
			('Al Wakrah', 'Catar')
		)datos(ciudad, pais)
		JOIN Pais P ON P.pais = datos.pais
	ON CONFLICT
		DO NOTHING;

--7. Agregar estadios
INSERT INTO estadio
	(estadio, capacidad, idciudad)
	SELECT datos.estadio, datos.capacidad, C.id
		FROM (
			VALUES
			('Lusail Stadium', 88966, 'Lusail'),
			('Al Bayt Stadium', 68895, 'Al Khor'),
			('Khalifa International Stadium', 45857, 'Rayán'),
			('Ahmad Bin Ali Stadium', 45032, 'Rayán'),
			('Education City Stadium', 44667, 'Rayán'),
			('Al Thumama Stadium', 44400, 'Doha'),
			('Al Janoub Stadium', 44325, 'Al Wakrah'),
			('Stadium 974', 44089, 'Doha')
		) datos(estadio, capacidad, ciudad)
		JOIN ciudad C ON C.ciudad = datos.ciudad
	ON CONFLICT(estadio)
		DO UPDATE
			SET capacidad = excluded.capacidad;	

--8. Agregar los Encuentros de la Fase de Grupos
INSERT INTO encuentro
	(idpais1, idpais2, fecha, idestadio, idfase, idcampeonato, goles1, goles2)
	SELECT P1.id, P2.id, datos.fecha::DATE, E.id, F.id, C.id, datos.goles1, datos.goles2
		FROM(
			VALUES
				-- GRUPO A
				('Catar', 'Ecuador', '2022-11-20', 'Al Bayt Stadium', 0, 2),
				('Senegal', 'Países Bajos', '2022-11-21', 'Al Thumama Stadium', 0, 2),
				('Catar', 'Senegal', '2022-11-25', 'Al Thumama Stadium', 1, 3),
				('Países Bajos', 'Ecuador', '2022-11-25', 'Khalifa International Stadium', 1, 1),
				('Ecuador', 'Senegal', '2022-11-29', 'Khalifa International Stadium', 1, 2),
				('Países Bajos', 'Catar', '2022-11-29', 'Al Bayt Stadium', 2, 0),
				
				-- GRUPO B
				('Inglaterra', 'Irán', '2022-11-21', 'Khalifa International Stadium', 6, 2),
				('Estados Unidos', 'Gales', '2022-11-21', 'Ahmad Bin Ali Stadium', 1, 1),
				('Gales', 'Irán', '2022-11-25', 'Ahmad Bin Ali Stadium', 0, 2),
				('Inglaterra', 'Estados Unidos', '2022-11-25', 'Al Bayt Stadium', 0, 0),
				('Gales', 'Inglaterra', '2022-11-29', 'Ahmad Bin Ali Stadium', 0, 3),
				('Irán', 'Estados Unidos', '2022-11-29', 'Al Thumama Stadium', 0, 1),
				
				-- GRUPO C
				('Argentina', 'Arabia Saudita', '2022-11-22', 'Lusail Stadium', 1, 2),
				('México', 'Polonia', '2022-11-22', 'Stadium 974', 0, 0),
				('Polonia', 'Arabia Saudita', '2022-11-26', 'Education City Stadium', 2, 0),
				('Argentina', 'México', '2022-11-26', 'Lusail Stadium', 2, 0),
				('Polonia', 'Argentina', '2022-11-30', 'Stadium 974', 0, 2),
				('Arabia Saudita', 'México', '2022-11-30', 'Lusail Stadium', 1, 2),
				
				-- GRUPO D
				('Dinamarca', 'Túnez', '2022-11-22', 'Education City Stadium', 0, 0),
				('Francia', 'Australia', '2022-11-22', 'Al Janoub Stadium', 4, 1),
				('Túnez', 'Australia', '2022-11-26', 'Al Janoub Stadium', 0, 1),
				('Francia', 'Dinamarca', '2022-11-26', 'Stadium 974', 2, 1),
				('Australia', 'Dinamarca', '2022-11-30', 'Al Janoub Stadium', 1, 0),
				('Túnez', 'Francia', '2022-11-30', 'Education City Stadium', 1, 0),
				
				-- GRUPO E
				('Alemania', 'Japón', '2022-11-23', 'Khalifa International Stadium', 1, 2),
				('España', 'Costa Rica', '2022-11-23', 'Al Thumama Stadium', 7, 0),
				('Japón', 'Costa Rica', '2022-11-27', 'Ahmad Bin Ali Stadium', 0, 1),
				('España', 'Alemania', '2022-11-27', 'Al Bayt Stadium', 1, 1),
				('Japón', 'España', '2022-12-01', 'Khalifa International Stadium', 2, 1),
				('Costa Rica', 'Alemania', '2022-12-01', 'Al Bayt Stadium', 2, 4),
				
				-- GRUPO F
				('Marruecos', 'Croacia', '2022-11-23', 'Al Bayt Stadium', 0, 0),
				('Bélgica', 'Canadá', '2022-11-23', 'Ahmad Bin Ali Stadium', 1, 0),
				('Bélgica', 'Marruecos', '2022-11-27', 'Al Thumama Stadium', 0, 2),
				('Croacia', 'Canadá', '2022-11-27', 'Khalifa International Stadium', 4, 1),
				('Croacia', 'Bélgica', '2022-12-01', 'Ahmad Bin Ali Stadium', 0, 0),
				('Canadá', 'Marruecos', '2022-12-01', 'Al Thumama Stadium', 1, 2),
				
				-- GRUPO G
				('Suiza', 'Camerún', '2022-11-24', 'Al Janoub Stadium', 1, 0),
				('Brasil', 'Serbia', '2022-11-24', 'Lusail Stadium', 2, 0),
				('Camerún', 'Serbia', '2022-11-28', 'Al Janoub Stadium', 3, 3),
				('Brasil', 'Suiza', '2022-11-28', 'Stadium 974', 1, 0),
				('Serbia', 'Suiza', '2022-12-02', 'Stadium 974', 2, 3),
				('Camerún', 'Brasil', '2022-12-02', 'Lusail Stadium', 1, 0),
				
				-- GRUPO H
				('Uruguay', 'Corea del Sur', '2022-11-24', 'Education City Stadium', 0, 0),
				('Portugal', 'Ghana', '2022-11-24', 'Stadium 974', 3, 2),
				('Corea del Sur', 'Ghana', '2022-11-28', 'Education City Stadium', 2, 3),
				('Portugal', 'Uruguay', '2022-11-28', 'Lusail Stadium', 2, 0),
				('Ghana', 'Uruguay', '2022-12-02', 'Al Janoub Stadium', 0, 2),
				('Corea del Sur', 'Portugal', '2022-12-02', 'Education City Stadium', 2, 1)

		) datos(pais1, pais2, fecha, estadio, goles1, goles2)
		JOIN pais P1 ON P1.pais = datos.pais1
		JOIN pais P2 ON P2.pais = datos.pais2
		JOIN campeonato C on C.campeonato = 'FIFA World Cup 2022'
		JOIN fase F on F.fase = 'Grupos'
		JOIN estadio E on E.estadio = datos.estadio
	ON CONFLICT(idpais1, idpais2, idfase, idcampeonato)
		DO UPDATE
			SET fecha = excluded.fecha,
				idestadio = excluded.idestadio,
				goles1 = excluded.goles1,
				goles2 = excluded.goles2;