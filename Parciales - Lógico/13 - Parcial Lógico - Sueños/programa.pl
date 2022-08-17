% 13 - Parcial Lógico - Sueños


% 1)

% a. Base de conocimiento inicial

% Cree en
creeEn(gabriel, campanita).
creeEn(gabriel, magoDeOz).
creeEn(gabriel, cavenaghi).
creeEn(juan, conejoDePascua).
creeEn(macarena, reyesMagos).
creeEn(macarena, magoCapria).
creeEn(macarena, campanita).

% b. Como diego no cree en nadie, no lo agregamos a la base de conocimiento. Por el principio de universo cerrado, Prolog entiende que es falso que diego crea en alguien

% Tipos de sueño -> Lo hacemos con functores

% cantante(discosVendidos)
% futbolista(equipo)
% loteria([numerosApostados])

suenio(gabriel, loteria([5, 9])).
suenio(gabriel, futbolista(arsenal)).
suenio(juan, cantante(100000)).
suenio(macarena, cantante(10000)).

/* 
    b.

    Como macarena no quiere ganar la lotería, por principio de universo cerrado no lo agregamos a la base de datos, entonces Prolog entenderá que es falso que macarena
    tiene como sueño ganar la lotería.

    El concepto de functores entra en juego a la hora de modelar los tipos de sueño. La ventaja que nos da esto es que más adelante podremos tratar polimórficamente a
    los mismos.
*/


% 2) Es ambiciosa

esAmbiciosa(Persona) :-
    suenio(Persona, _),
    dificultadesSuenios(Persona, Dificultades),
    sum_list(Dificultades, DificultadTotal),
    DificultadTotal > 20.
    
dificultadSuenio(cantante(DiscosVendidos), 4) :-
    DiscosVendidos =< 500000.
dificultadSuenio(cantante(DiscosVendidos), 6) :-
    DiscosVendidos > 500000.
dificultadSuenio(loteria(NumerosApostados), Dificultad) :-
    length(NumerosApostados, CantidadNumerosApostados),
    Dificultad is 10 * CantidadNumerosApostados.
dificultadSuenio(futbolista(Equipo), 3) :-
    equipoChico(Equipo).
dificultadSuenio(futbolista(Equipo), 6) :-
    not(equipoChico(Equipo)).

equipoChico(arsenal).
equipoChico(aldosivi).

dificultadesSuenios(Persona, Dificultades) :-
    findall(Dificultad, (suenio(Persona, Suenio), dificultadSuenio(Suenio, Dificultad)), Dificultades).


% 3) Tiene química 

tieneQuimica(Personaje, Persona) :-
    creeEn(Persona, Personaje),
    cumpleCondiciones(Personaje, Persona).

cumpleCondiciones(campanita, Persona) :-
    suenio(Persona, Suenio), 
    dificultadSuenio(Suenio, Dificultad),
    Dificultad < 5.
cumpleCondiciones(_, Persona) :-
    suenio(Persona, _),
    forall(suenio(Persona, Suenio), esPuro(Suenio)),
    not(esAmbiciosa(Persona)).

esPuro(futbolista(_)).
esPuro(cantante(DiscosVendidos)) :-
    DiscosVendidos < 200000.


% 4) Puede alegrar


amigoIndirecto(Personaje, OtroPersonaje2) :-
    amigoDirecto(Personaje, OtroPersonaje),
    amigoDirecto(OtroPersonaje, OtroPersonaje2).
amigoDirecto(campanita, reyesMagos).
amigoDirecto(campanita, conejoDePascua).
amigoDirecto(conejoDePascua, cavenaghi).

amigo(Personaje, OtroPersonaje) :-
    amigoDirecto(Personaje, OtroPersonaje).
amigo(Personaje, OtroPersonaje) :-
    amigoIndirecto(Personaje, OtroPersonaje).

puedeAlegrar(Personaje, Persona) :-
    suenio(Persona, _),
    tieneQuimica(Personaje, Persona),
    noEnfermoOBackupEnfermo(Personaje).

enfermo(campanita).
enfermo(reyesMagos).
enfermo(conejoDePascua).

noEnfermoOBackupEnfermo(Personaje) :-
    not(enfermo(Personaje)).
noEnfermoOBackupEnfermo(Personaje) :-
    personajeBackup(Personaje, PersonajeBackup),
    not(enfermo(PersonajeBackup)).

personajeBackup(Personaje, PersonajeBackup) :-
    amigo(Personaje, PersonajeBackup).












