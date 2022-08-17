% 14 - Parcial Lógico - Minecraft

% Base de conocimiento

jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).
jugador(franco, [placaDeMadera], 3).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

% 1) Jugando con los ítems

% a. Tiene item

tieneItem(Jugador, Item) :-
    jugador(Jugador, Items, _),
    member(Item, Items).

% b. Se preocupa por su salud REVISAR!!!!!!!!

sePreocupaPorSuSalud(Jugador) :-
    tieneItem(Jugador, Item),
    comestible(Item).

% c. 

cantidadDeItem(Jugador, Item, Cantidad) :-
    findall(Item, tieneItem(Jugador, Item), Items),
    length(Items, Cantidad).

% d. 

tieneMasDe(Jugador, Item) :-
    tieneItem(Jugador, Item),
    cantidadDeItem(Jugador, Item, Cantidad),
    forall(cantidadDeItem(_, Item, OtraCantidad), Cantidad >= OtraCantidad).


% 2) Alejarse de la oscuridad

% a. Lugares en los que hay monstruos

hayMonstruos(Lugar) :-
    lugar(Lugar, _, NivelOscuridad),
    NivelOscuridad > 6.


% b. Corre peligro

correPeligro(Jugador) :-
    lugar(Lugar, Jugadores, _),
    member(Jugador, Jugadores),
    hayMonstruos(Lugar).
correPeligro(Jugador) :-
    estaHambriento(Jugador),
    not(tieneComestibles(Jugador)).

estaHambriento(Jugador) :-
    jugador(Jugador, _, Hambre),
    Hambre < 4.

tieneComestibles(Jugador) :-
    tieneItem(Jugador, Item),
    comestible(Item).


% c. Nivel de peligrosidad

hambrientos(Lugar, Porcentaje) :-
    lugar(Lugar, Jugadores, _),
    findall(Jugador, (estaHambriento(Jugador), member(Jugador, Jugadores)), Hambrientos),
    length(Hambrientos, CantidadHambrientos),
    length(Jugadores, CantidadJugadores),
    CantidadJugadores \= 0,
    Porcentaje is (CantidadHambrientos*100) / CantidadJugadores.
    
poblacionTotal(Lugar, Poblacion) :-
    lugar(Lugar, Jugadores, _),
    length(Jugadores, Poblacion).

nivelPeligrosidad(Lugar, Peligrosidad) :-
    not(hayMonstruos(Lugar)),
    hambrientos(Lugar, Porcentaje),
    poblacionTotal(Lugar, Poblacion),
    Peligrosidad is Porcentaje/Poblacion.
nivelPeligrosidad(Lugar, 100) :-
    hayMonstruos(Lugar).
nivelPeligrosidad(Lugar, Peligrosidad) :-
    lugar(Lugar, [], NivelOscuridad),
    Peligrosidad is min(NivelOscuridad * 10, 100).


% 3) A construir


item(horno, [itemSimple(piedra, 8)]).
item(placaDeMadera, [itemSimple(madera, 1)]).
item(palo, [itemCompuesto(placaDeMadera)]).
item(antorcha, [itemCompuesto(palo), itemSimple(carbon, 1)]).

puedeConstruir(Jugador, Item) :-
    jugador(Jugador, _, _),
    item(Item, Materiales),
    forall(member(Material, Materiales), tieneSuficiente(Jugador, Material)).

tieneSuficiente(Jugador, itemCompuesto(Material)) :-
    puedeConstruir(Jugador, Material).

tieneSuficiente(Jugador, itemSimple(Material, CantidadNecesaria)) :-
    cantidadDeItem(Jugador, Material, Cantidad),
    Cantidad >= CantidadNecesaria.















% 4) Para pensar sin bloques

% a. ¿Qué sucede si se consulta el nivel de peligrosidad del desierto? ¿A qué se debe?

/*
    Si se consulta el nivel de peligrosidad del desierto, Prolog responderá false, ya que el lugar desierto
    no se encuentra en la base de datos, por ende, no puede hacer el cálculo correspondiente del nivel de peligrosidad
    del mismo.
*/

    


