select C.campeonato, STRING_AGG(P.pais, ', ') organizadores, G.grupo, PG.pais
	from campeonato C
		left join campeonatopais CP on c.id = cp.idcampeonato
		left join pais P on CP.idpais = P.id
		left join grupo G on C.id = G.idcampeonato
		left join grupopais GP ON G.id = GP.idgrupo
		left join pais PG ON GP.idpais = PG.id
	where C.campeonato = 'FIFA World Cup 2022'
	group by C.campeonato, G.grupo, PG.pais
	order by 1, 2, 3
	
select C.ciudad, E.estadio, E.capacidad
	from ciudad C
		JOIN pais P ON C.idpais = P.id
		JOIN estadio E ON E.idciudad = C.id
		WHERE P.pais = 'Catar'