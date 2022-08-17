% 5 - Parcial Funcional - Age of Empires

% Base de conocimiento

% …jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).
jugador(franco, 1567, jemeres).

% …tiene(Nombre, QueTiene).
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(carreta, 10)).
tiene(franco, unidad(espadachin, 5)).



% militar​(​Tipo, costo(Madera, Alimento, Oro), Categoria​)​.
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(50, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).


% aldeano​(​Tipo, produce(Madera, Alimento, Oro)​)​.
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).


% edificio​(​Edificio, costo(Madera, Alimento, Oro)​)​.
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).


% 1) Es un afano

esUnAfano(Jugador, OtroJugador) :-
    jugador(Jugador, Rating, _),
    jugador(OtroJugador, OtroRating, _),
    diferenciaRating(Rating, OtroRating, Diferencia),
    Diferencia > 500.

diferenciaRating(Rating, OtroRating, Diferencia) :-
    Diferencia is Rating - OtroRating.


% 2) Es efectivo

esEfectivo(samurai, OtraUnidad) :-
    militar(OtraUnidad, _, unica).
esEfectivo(Unidad, OtraUnidad) :-
    leGana(Unidad, OtraUnidad).

leGana(caballeria, arqueria).
leGana(arqueria, infanteria).
leGana(infanteria, piquero).
leGana(piquero, caballeria).


% 3) Alarico

alarico(Jugador) :-
    tiene(Jugador, _),
    soloTieneUnidadesDe(Jugador, infanteria).
    
soloTieneUnidadesDe(Jugador, Tipo) :-
    forall(tiene(Jugador, unidad(Unidad, _)), esUnidadDeTipo(Unidad, Tipo)).

esUnidadDeTipo(Unidad, Tipo) :-
    militar(Unidad, _, Tipo).


% 4) Leonidas

leonidas(Jugador) :-
    tiene(Jugador, _),
    soloTieneUnidadesDe(Jugador, piquero).


% 5) Nomada

nomada(Jugador) :-
    jugador(Jugador, _, _),
    noTieneCasas(Jugador).

noTieneCasas(Jugador) :-
    not(tiene(Jugador, edificio(casa, _))).


% 6) Cuanto cuesta

cuantoCuesta(Tipo, Costo) :-
    militar(Tipo, Costo, _).
cuantoCuesta(Tipo, Costo) :-
    edificio(Tipo, Costo).
cuantoCuesta(Tipo, costo(0, 50, 0)) :-
    aldeano(Tipo, _).
cuantoCuesta(Tipo, costo(100, 0, 50)) :-
    carretaOUrna(Tipo).

carretaOUrna(carreta).
carretaOUrna(urnaMercante).


% 7) Produccion

produccion(Tipo, Produccion) :-
    aldeano(Tipo, Produccion).
produccion(Tipo, produce(0, 0, 32)) :-
    carretaOUrna(Tipo).
produccion(keshik, produce(0, 0, 32)).


% 8) Producción total           REVISAR ESTE PUNTO


% 9) Esta peleado

estaPeleado(Jugador, OtroJugador) :-
    jugador(Jugador, _, _),
    jugador(OtroJugador, _, _),
    Jugador \= OtroJugador,
    noEsUnAfanoParaNinguno(Jugador, OtroJugador),
    tienenMismaCantidadUnidades(Jugador, OtroJugador).
%  falta hacer 8 para terminarlo.

noEsUnAfanoParaNinguno(Jugador, OtroJugador) :-
    not(esUnAfano(Jugador, OtroJugador)).

tienenMismaCantidadUnidades(Jugador, OtroJugador) :-
    cantidadUnidades(Jugador, Cantidad1),
    cantidadUnidades(OtroJugador, Cantidad2),
    Cantidad1 is Cantidad2.

cantidadUnidades(Jugador, Cantidad) :-
    tiene(Jugador, _),
    findall(Unidad, tiene(Jugador, Unidad), Unidades),
    length(Unidades, Cantidad).    


% 10) Avanza a

edad(media).
edad(feudal).
edad(castillos).
edad(imperial).

avanzaA(_, media).
avanzaA(Jugador, Edad) :-
    cumpleRequisitos(Jugador, Edad).

cumpleRequisitos(Jugador, feudal) :-
    cumpleAlimento(Jugador, 500),
    tieneEdificio(Jugador, casa).

cumpleRequisitos(Jugador, castillos) :-
    cumpleAlimento(Jugador, 800),
    cumpleOro(Jugador, 200),
    edificioCastillos(EdificioCastillos),
    tieneEdificio(Jugador, EdificioCastillos).

cumpleRequisitos(Jugador, imperial) :-
    cumpleAlimento(Jugador, 1000),
    cumpleOro(Jugador, 800),
    tieneEdificio(Jugador, castillo),
    tieneEdificio(Jugador, universidad).

edificioCastillos(herreria).
edificioCastillos(establo).
edificioCastillos(galeriaDeTiro).

cumpleAlimento(Jugador, Cantidad) :-
    tiene(Jugador, recurso(_, Alimento, _)),
    Alimento >= Cantidad.

cumpleOro(Jugador, Cantidad) :-
    tiene(Jugador, recurso(_, _, Oro)),
    Oro >= Cantidad.

tieneEdificio(Jugador, Edificio) :-
    tiene(Jugador, edificio(Edificio, _)).

cantidadRecursos(Jugador, Madera, Alimento, Oro) :-
    tiene(Jugador, recurso(Madera, Alimento, Oro)).

