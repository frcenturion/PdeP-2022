% 18 - Parcial Lógico - Toy Story

% Relaciona al dueño con el nombre del juguete y la cantidad de años que lo ha tenido
duenio(andy, woody, 8).
duenio(sam, jessie, 3).
duenio(andy, buzz, 3).



% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)

juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa, caraDePapa([original(pieIzquierdo), original(pieDerecho), repuesto(nariz)])).

% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, 1, [sombrero])).

% Dice si una persona es coleccionista
esColeccionista(sam).


% 1)

% a. Temática

tematica(Juguete, caraDePapa) :-
    juguete(Juguete, caraDePapa(_)).
tematica(Juguete, Tematica) :-
    juguete(Juguete, Forma),
    buscarTematica(Forma, Tematica).

buscarTematica(deTrapo(Tematica), Tematica).
buscarTematica(deAccion(Tematica, _), Tematica).
buscarTematica(miniFiguras(Tematica, _), Tematica).


% b. Es de plástico

esDePlastico(Juguete) :-
    juguete(Juguete, Forma),
    esMiniFiguraOCaraDePapa(Forma).

esMiniFiguraOCaraDePapa(miniFiguras(_, _)).
esMiniFiguraOCaraDePapa(caraDePapa(_)).


% c. Es de colección

esDeColeccion(Juguete) :-
    juguete(Juguete, Forma),
    esDeAccionOCaraDePapa(Forma),
    esRaro(Forma).

esDeColeccion(Juguete) :-
    juguete(Juguete, deTrapo(_)).

esDeAccionOCaraDePapa(deAccion(_, _)).
esDeAccionOCaraDePapa(caraDePapa(_)).


% 2) Amigo fiel

amigoFiel(Duenio, Juguete) :-
    duenio(Duenio, Juguete, _),
    not(esDePlastico(Juguete)),
    loTieneHaceMasTiempo(Duenio, Juguete).

loTieneHaceMasTiempo(Duenio, Juguete) :-
    duenio(Duenio, Juguete, Anios),
    forall((duenio(Duenio, OtroJuguete, OtrosAnios), not(esDePlastico(OtroJuguete))), Anios >= OtrosAnios).
    

% 3) Super valioso

superValioso(Juguete) :-
    duenio(Duenio, Juguete, _),
    not(esColeccionista(Duenio)),
    tieneSusPiezasOriginales(Juguete).

tieneSusPiezasOriginales(Juguete) :-
    juguete(Juguete, Forma),
    not(esDeAccionOCaraDePapa(Forma)).
tieneSusPiezasOriginales(Juguete) :-
    juguete(Juguete, Forma),
    esDeAccionOCaraDePapa(Forma),
    piezasJuguete(Forma, Piezas),
    not(member(repuesto(_)), Piezas).

piezasJuguete(deAccion(_, Piezas), Piezas).
piezasJuguete(caraDePapa(Piezas), Piezas).


% 4) Duo dinámico

duoDinamico(Duenio, Juguete1, Juguete2) :-
    pertenecenAlMismoDuenio(Duenio, Juguete1, Juguete2),
    hacenBuenaPareja(Juguete1, Juguete2).

pertenecenAlMismoDuenio(Duenio, Juguete1, Juguete2) :-
    duenio(Duenio, Juguete1, _),
    duenio(Duenio, Juguete2, _),
    Juguete1 \= Juguete2.

hacenBuenaPareja(woody, buzz).
hacenBuenaPareja(Juguete1, Juguete2) :-
    tematica(Juguete1, Tematica),
    tematica(Juguete2, Tematica),
    Juguete1 \= Juguete2.


% 5) Felicidad

felicidad(Duenio, Felicidad) :-
    duenio(Duenio, Juguete, _),
    juguete(Juguete, Forma),
    findall(Felicidad, calcularFelicidad(Forma, Felicidad), Felicidades),
    sum_list(Felicidades, Felicidad).
    

calcularFelicidad(miniFiguras(_, CantidadFiguras), Felicidad) :-
    Felicidad is 20 * CantidadFiguras.
calcularFelicidad(deTrapo(_), 100).
calcularFelicidad(deAccion(_, _), 100).
calcularFelicidad(deAccion(_, _), 120) :-
    juguete(Juguete, deAccion(_, _)),
    esDeColeccion(Juguete),
    duenio(Duenio, Juguete, _),
    esColeccionista(Duenio). 
calcularFelicidad(caraDePapa(Piezas), Felicidad) :-
    findall(Pieza, member(original(Pieza), Piezas), PiezasOriginales),
    length(PiezasOriginales, CantidadPiezasOriginales),
    findall(Pieza, member(repuesto(Pieza), Piezas), PiezasRepuesto),
    length(PiezasRepuesto, CantidadPiezasRepuesto),
    Felicidad is CantidadPiezasOriginales * 5 + CantidadPiezasRepuesto * 8.

    

% 6) Puede jugar con

puedeJugarCon(Persona, Juguete) :-
    duenio(Persona, Juguete, _).
puedeJugarCon(Persona, Juguete) :-
    puedeJugarCon(OtraPersona, Juguete),
    puedePrestar(OtraPersona, Persona),
    OtraPersona \= Persona.

puedePrestar(OtraPersona, Persona) :-
    tieneMasJuguetes(OtraPersona, Persona).

tieneMasJuguetes(OtraPersona, Persona) :-
    cantidadJuguetes(OtraPersona, CantidadJuguetes),
    cantidadJuguetes(Persona, OtraCantidadJuguetes),
    CantidadJuguetes > OtraCantidadJuguetes.
    
    
cantidadJuguetes(Persona, CantidadJuguetes) :-
    duenio(Persona, _, _),
    findall(Juguete, duenio(Persona, Juguete, _), Juguetes),
    length(Juguetes, CantidadJuguetes).




% 7) Podria donar



    
    


% 8) Comentar donde se aprovechó el polimorfismo

/*

    El polimorfismo se aprovechó en...


*/



