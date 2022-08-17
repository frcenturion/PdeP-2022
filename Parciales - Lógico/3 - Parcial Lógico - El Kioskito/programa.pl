% 3 - Parcial Lógico - El Kioskito

% 1) Calentando motores

atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).
atiende(lucas, martes, 10, 20).
atiende(juanC, sabado, 18, 22).
atiende(juanC, domingo, 18, 22).
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).
atiende(martu, miercoles, 23, 24).

% Vale atiende los mismos dias que dodain y juanC

atiende(vale, Dia, Inicio, Fin) :-
    atiende(dodain, Dia, Inicio, Fin).
atiende(vale, Dia, Inicio, Fin) :-
    atiende(juanC, Dia, Inicio, Fin).

% Nadie hace el mismo horario que leoC

/* 
    A partir del principio de universo cerrado, al no agregar ninguna clausula que contenga otro individuo que
    atienda el mismo dia que leoC, incorporamos a la base de conocimiento la información de que nadie hace
    el mismo horario que leoC.

*/

% maiu está pensando si hace el horario de 0 a 8 los martes y miércoles

/*
    Por principio de universo cerrado, lo desconocido se presume falso.

*/


% 2) Quién atiende el kiosko...

quienAtiendeTalDiaATalHora(Dia, Hora, Persona) :-
    atiende(Persona, Dia, Inicio, Fin),
    between(Inicio, Fin, Hora).
    

% 3) Forever alone 

estaForeverAlone(Persona, Dia, Hora) :-
    quienAtiendeTalDiaATalHora(Dia, Hora, Persona),
    not((quienAtiendeTalDiaATalHora(Dia, Hora, OtraPersona), Persona \= OtraPersona)).


% 4) Posibilidades de atención

podrianEstarAtendiendo(Dia, Personas) :-
    findall(Persona, quienAtiendeTalDiaATalHora(Dia, _, Persona), PersonasPosiblesRepetidas),
    list_to_set(PersonasPosiblesRepetidas, PersonasPosibles),
    combinar(PersonasPosibles, Personas). 

combinar([], []).
combinar([Persona|PersonasPosibles], [Persona|Personas]) :-
    combinar(PersonasPosibles, Personas).
combinar([_|PersonasPosibles], Personas) :-
    combinar(PersonasPosibles, Personas).

% ¿Qué conceptos resuelven este requerimiento?

/*
    > findall como herramienta para poder generar un conjunto de soluciones que satisfacen un predicado.
    > mecanismo de backtracking de Prolog, que permite encontrar todas las soluciones posibles.
*/


% 5) Ventas/suertudas

venta(dodain, fecha(10, 8), [golosinas(1200), cigarrillos(jockey), golosinas(50)]).
venta(dodain, fecha(12, 8), [bebidas(true, 8), bebidas(false, 1), golosinas(10)]).
venta(martu, fecha(12, 8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
venta(lucas, fecha(11, 8), [golosinas(600)]).
venta(lucas, fecha(18, 8), [bebidas(false, 2), cigarrillos(derby)]).

esSuertuda(Persona) :-
    venta(Persona, _, _),
    forall(venta(Persona, _, [Venta|_]), esImportante(Venta)).

esImportante(golosinas(Monto)) :-
    Monto > 100.
esImportante(golosinas(Marcas)) :-
    length(Marcas, CantidadMarcas),
    CantidadMarcas > 2.
esImportante(bebidas(true, _)).
esImportante(bebidas(_, Cantidad)) :-
    Cantidad > 5.