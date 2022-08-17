% PARCIAL FUNCIONAL - EscaPdeP

% Base de conocimiento

%En nuestra base de conocimientos contamos con los siguientes datos de las personas que se crearon una cuenta en nuestra página:

%persona(Apodo, Edad, Peculiaridades).
persona(ale, 15, [claustrofobia, cuentasRapidas, amorPorLosPerros]).
persona(agus, 25, [lecturaVeloz, ojoObservador, minuciosidad]).
persona(fran, 30, [fanDeLosComics]).
persona(rolo, 12, []).


%Hay varias empresas metidas en este rubro y cada una tiene distintas salas:

%esSalaDe(NombreSala, Empresa).
esSalaDe(elPayasoExorcista, salSiPuedes).
esSalaDe(socorro, salSiPuedes).
esSalaDe(linternas, elLaberintoso).
esSalaDe(guerrasEstelares, escapepepe).
esSalaDe(fundacionDelMulo, escapepepe).


%Las salas no son todas iguales. Contamos con las siguientes experiencias:

%terrorifica(CantidadDeSustos, EdadMinima).
%familiar(Tematica, CantidadDeHabitaciones).
%enigmatica(Candados).

%sala(Nombre, Experiencia).
sala(elPayasoExorcista, terrorifica(100, 18)).
sala(socorro, terrorifica(20, 12)).
sala(linternas, familiar(comics, 5)).
sala(guerrasEstelares, familiar(futurista, 7)).
sala(fundacionDelMulo, enigmatica([combinacionAlfanumerica, deLlave, deBoton])).
sala(falopa, terrorifica(10,9)).


% 1) Nivel de dificultad de la sala

nivelDeDificultadDeLaSala(Sala, Dificultad) :-
    sala(Sala, Experiencia),
    calcularDificultad(Experiencia, Dificultad).

calcularDificultad(terrorifica(CantidadDeSustos, EdadMinima), Dificultad) :-
    Dificultad is CantidadDeSustos - EdadMinima.
calcularDificultad(familiar(futurista, _), 15).
calcularDificultad(familiar(Tematica, CantidadDeHabitaciones), CantidadDeHabitaciones) :-
    Tematica \= futurista.
calcularDificultad(enigmatica(Candados), Dificultad) :-
    length(Candados, Dificultad).
    
    
% 2) Puede salir

puedeSalir(Persona, Sala) :-
    persona(Persona, _, _),
    nivelDeDificultadDeLaSala(Sala, 1),
    not(esClaustrofobica(Persona)).
puedeSalir(Persona, Sala) :-
    persona(Persona, Edad, _),
    Edad > 13,
    nivelDeDificultadDeLaSala(Sala, Dificultad),
    Dificultad < 5,
    not(esClaustrofobica(Persona)).

esClaustrofobica(Persona) :-
    persona(Persona, _, Peculiaridades),
    member(claustrofobia, Peculiaridades).


% 3) Tiene suerte

tieneSuerte(Persona, Sala) :-
    persona(Persona, _, Peculiaridades),
    puedeSalir(Persona, Sala),
    length(Peculiaridades, 0).


% OTRA FORMA

tieneSuerteV2(Persona, Sala) :-
    sinPeculiaridades(Persona),
    puedeSalir(Persona, Sala).

sinPeculiaridades(Persona) :-
    persona(Persona, _, []).


% 4) Es macabra 

esMacabra(Empresa) :-
    esSalaDe(_, Empresa),
    forall(esSalaDe(Sala, Empresa), sala(Sala, terrorifica(_, _))).


% 5) Empresa copada

empresaCopada(Empresa) :-
    not(esMacabra(Empresa)),
    esSalaDe(_, Empresa),
    findall(Dificultad, (nivelDeDificultadDeLaSala(Sala, Dificultad), esSalaDe(Sala, Empresa)), ListaDificultades),
    promedio(ListaDificultades, Promedio),
    Promedio < 4.
    
promedio(ListaDificultades, Promedio) :-
    sum_list(ListaDificultades, SumatoriaDificultades),
    length(ListaDificultades, Cantidad),
    Promedio is SumatoriaDificultades/Cantidad.


% 6) Nuevas empresas

esSalaDe(estrellasDePelea, supercelula).
esSalaDe(choqueDeLaRealeza, supercelula).
esSalaDe(miseriaDeLaNoche, skPista).

sala(estrellasDePelea, familiar(videojuegos, 7)).
sala(miseriaDeLaNoche, terrorifica(75,21)).
