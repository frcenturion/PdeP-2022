% 6 - Parcial Lógico - Karate

%alumnoDe(Maestro, Alumno)
alumnoDe(miyagui, sara).
alumnoDe(miyagui, bobby).
alumnoDe(miyagui, sofia).
alumnoDe(chunLi, guidan).
alumnoDe(maestro1, franco).
alumnoDe(maestro1, ivan).
alumnoDe(maestro1, alejo).
alumnoDe(maestro1, tobias).

% destreza(alumno, velocidad, [habilidades]).
destreza(sofia, 80, [golpeRecto(40, 3), codazo(20)]).
destreza(sara, 70, [patadaRecta(80, 2), patadaDeGiro(90, 95, 2), golpeRecto(1, 90), codazo(100)]).
destreza(bobby, 80, [patadaVoladora(100, 3, 2, 90), patadaDeGiro(50, 20, 1)]).
destreza(guidan, 70, [patadaRecta(60, 1), patadaVoladora(100, 3, 2, 90), patadaDeGiro(70, 80, 1)]).
destreza(franco, 80, [codazo(100), patadaRecta(80, 2), patadaDeGiro(90, 95, 2), golpeRecto(1, 90)]).
destreza(ivan, 80, [codazo(100), patadaRecta(80, 2), patadaDeGiro(90, 95, 2), golpeRecto(1, 90)]).
destreza(alejo, 80, [codazo(100), patadaRecta(80, 2), patadaDeGiro(90, 95, 2), golpeRecto(1, 90)]).
destreza(tobias, 80, [codazo(100), patadaRecta(80, 2), patadaDeGiro(90, 95, 2), golpeRecto(1, 90)]).

%categoria(Alumno, Cinturones)
categoria(sofia, [blanco]).
categoria(sara, [blanco, amarillo, naranja, rojo, verde, azul, violeta, marron, negro]).
categoria(bobby, [blanco, amarillo, naranja, rojo, verde, azul, violeta, marron, negro]).
categoria(guidan, [blanco, amarillo, naranja]).
categoria(franco, [blanco, amarillo, naranja, rojo, verde, azul, violeta, marron, negro]).
categoria(ivan, [blanco, amarillo, naranja, rojo, verde, azul, violeta, marron, negro]).
categoria(tobias, [blanco, amarillo, naranja, rojo, verde, azul, violeta, marron, negro]).
categoria(alejo, [blanco, amarillo, naranja, rojo, verde, azul, violeta, marron, negro]).






% 1) Es bueno

esBueno(Alumno) :-
    sabeHacerDosPatadasDistintas(Alumno),
    sabeGolpeRectoAVelocidadMedia(Alumno).

sabeHacerDosPatadasDistintas(Alumno) :-
    destreza(Alumno, _, Habilidades),
    esPatada(Patada),
    member(Patada, Habilidades),
    esPatada(Patada2),
    member(Patada2, Habilidades),
    Patada \= Patada2.

esPatada(patadaRecta(_, _)).
esPatada(patadaVoladora(_, _, _, _ )).
esPatada(patadaDeGiro(_, _, _)).

sabeGolpeRectoAVelocidadMedia(Alumno) :-
    destreza(Alumno, Velocidad, Habilidades),
    member(golpeRecto(_, _), Habilidades),
    between(50, 80, Velocidad).
    

% 2) Es apto para torneo

esAptoParaTorneo(Alumno) :-
    esBueno(Alumno),
    categoria(Alumno, Cinturones),
    member(verde, Cinturones).


% 3) Total potencia

totalPotencia(Alumno, PotenciaTotal) :-
    destreza(Alumno, _, Habilidades),
    findall(Potencia, (potenciaHabilidad(Habilidad, Potencia), member(Habilidad, Habilidades)), ListaPotencias),
    sum_list(ListaPotencias, PotenciaTotal).
    
potenciaHabilidad(golpeRecto(Potencia, _), Potencia).
potenciaHabilidad(codazo(Potencia), Potencia).
potenciaHabilidad(patadaRecta(Potencia, _), Potencia).
potenciaHabilidad(patadaDeGiro(Potencia, _, _), Potencia).
potenciaHabilidad(patadaVoladora(Potencia, _, _, _), Potencia).


% 4) Alumno con mayor potencia

alumnoConMayorPotencia(Alumno) :-
    totalPotencia(Alumno, PotenciaTotal),
    forall(totalPotencia(_, PotenciaTotal2), PotenciaTotal >= PotenciaTotal2).


% 5) Sin patadas

sinPatadas(Alumno) :-
    destreza(Alumno, _, Habilidades),
    forall(member(Habilidad, Habilidades), not(esPatada(Habilidad))).


% 6) Solo sabe patear

soloSabePatear(Alumno) :-
    destreza(Alumno, _, Habilidades),
    forall(member(Habilidad, Habilidades), esPatada(Habilidad)).


% 7) Potenciales semifinalistas
 
potencialesSemifinalistas(PosiblesSemifinalistas) :-
    findall(Alumno, cumpleRequisitos(Alumno), PosiblesSemifinalistasRepetidos),
    list_to_set(PosiblesSemifinalistasRepetidos, PosiblesSemifinalistas).
    
cumpleRequisitos(Alumno) :-
    esAptoParaTorneo(Alumno),
    provieneDeMaestroCapo(Alumno),
    sabeHabilidadConBuenEstilo(Alumno).

provieneDeMaestroCapo(Alumno) :-
    alumnoDe(Maestro, Alumno),
    cantidadAlumnos(Maestro, Alumnos),
    Alumnos > 1.
 
cantidadAlumnos(Maestro, Alumnos) :-
    alumnoDe(Maestro, _),
    findall(Alumno, alumnoDe(Maestro, Alumno), ListaAlumnos),
    length(ListaAlumnos, Alumnos).
    
sabeHabilidadConBuenEstilo(Alumno) :-
    destreza(Alumno, _, Habilidades),
    habilidadConBuenEstilo(Habilidad),
    member(Habilidad, Habilidades).

habilidadConBuenEstilo(Habilidad) :-
    potenciaHabilidad(Habilidad, Potencia),
    Potencia is 100.
habilidadConBuenEstilo(Habilidad) :-
    punteriaHabilidad(Habilidad, Punteria),
    Punteria is 90.
    
punteriaHabilidad(patadaDeGiro(_, Punteria, _), Punteria).
punteriaHabilidad(patadaVoladora(_, _, _, Punteria), Punteria).


% 8) Semifinalistas     

semifinalistas(SemifinalistasPosibles) :-
    potencialesSemifinalistas(Semifinalistas),
    combinar(Semifinalistas, SemifinalistasPosibles),
    length(SemifinalistasPosibles, CantidadSemifinalistas),
    CantidadSemifinalistas is 4.
    

combinar([], []).
combinar([Semifinalista|Semifinalistas], [Semifinalista|SemifinalistasPosibles]) :-
    combinar(Semifinalistas, SemifinalistasPosibles).

combinar([_|Semifinalistas], SemifinalistasPosibles) :-
    combinar(Semifinalistas, SemifinalistasPosibles).


% 9) Justificar donde se aprovecharon los conceptos de polimorfismo y orden superior. Y qué beneficios tiene su uso en la solución.

/*
    > Polimorfismo: se utilizó en los predicados potenciaHabilidad, punteriaHabilidad y esPatada. El beneficio
    que tiene el uso de polimorfismo en estas soluciones es que permite tratar a las habilidades indistintamente de su
    forma, para poder obtener la potencia, la punteria y para saber si la habilidad es una patada, respectivamente.

    > Orden superior: se utilizó en los predicados:

    - totalPotencia: se utilizó el predicado de orden superior findall para poder obtener la lista de las potencias
    de todas las habilidades.

    - alumnoConMayorPotencia: se utilizó el predicado de orden superior forall para establecer que para toda potencia,
    esta sea menor que otra potencia.

    - sinPatadas: se utilizó el predicado de orden superior forall para establecer que para toda habilidad que tenga un
    alumno, la misma no es patada.

    - soloSabePatear: se utilizó el predicado de orden superior forall para establecer que para toda habildad que tenga un
    alumno, la misma sea patada.

    - potencialesSemifinalistas: se utilizó el predicado de orden superior findall para encontrar la lista de todos los
    alumnos que cumplen una serie de condiciones.

    - cantidadAlumnos: se utilizó el predicado de orden superior findall para encontrar la lista de alumnos de un maestro.
*/















    



