% 10 - Parcial Lógico - Pulp Fiction

% Base de conocimientos

%personaje(Nombre, Habilidad)
personaje(pumkin,     ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).
personaje(franco, mafioso(maton)).

pareja(marsellus, mia).
pareja(pumkin,    honeyBunny).
pareja(marvin, jules).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).
trabajaPara(jules, vincent).
trabajaPara(vincent, franco).
trabajaPara(franco, jules).

amigo(vincent, jules).
amigo(jules, vincent).
amigo(jules, jimmie).
amigo(vincent, elVendedor).
amigo(vincent, marvin).

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent, cuidar(mia)).
encargo(vincent, elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).
encargo(marsellus, jules, buscar(butch, losAngeles)).



% 1) Es peligroso

esPeligroso(Personaje) :-
    personaje(Personaje, Actividad),
    esActividadPeligrosa(Actividad),
    trabajaPara(Personaje, Empleado),
    esPeligroso(Empleado).


esActividadPeligrosa(mafioso(maton)).
esActividadPeligrosa(ladron([Lugares])) :-
    member(licoreria, Lugares).
    
tieneEmpleadosPeligrosos(Personaje) :-
    trabajaPara(Personaje, Empleado),
    esPeligroso(Empleado).


% 2) Duo temible

duoTemible(Personaje, OtroPersonaje) :-
    esPeligroso(Personaje),
    esPeligroso(OtroPersonaje),
    sonParejaOAmigos(Personaje, OtroPersonaje).

sonParejaOAmigos(Personaje, OtroPersonaje) :-
    pareja(Personaje, OtroPersonaje).
sonParejaOAmigos(Personaje, OtroPersonaje) :-
    amigo(Personaje, OtroPersonaje).


% 3) Está en problemas

estaEnProblemas(butch).
estaEnProblemas(Personaje) :-
    trabajaPara(Jefe, Personaje),
    pareja(Jefe, ParejaJefe),
    esPeligroso(Jefe),
    encargo(Jefe, Personaje, cuidar(ParejaJefe)).
estaEnProblemas(Personaje) :-
    encargo(_, Personaje, buscar(Buscado, _)),
    personaje(Buscado, boxeador).


% 4) San Cayetano

sanCayetano(Personaje) :-
    tieneCerca(Personaje, _),
    forall(tieneCerca(Personaje, OtroPersonaje), encargo(Personaje, OtroPersonaje, _)).

tieneCerca(Personaje, OtroPersonaje) :-
    amigo(Personaje, OtroPersonaje).
tieneCerca(Personaje, OtroPersonaje) :-
    trabajaPara(Personaje, OtroPersonaje).


% 5) Mas atareado

masAtareado(Personaje) :-
    cantidadEncargos(Personaje, Cantidad),
    forall(cantidadEncargos(_, OtraCantidad), Cantidad >= OtraCantidad).

cantidadEncargos(Personaje, Cantidad) :-
    personaje(Personaje, _),
    findall(Encargo, encargo(_, Personaje, Encargo), Encargos),
    length(Encargos, Cantidad).
    

% 6) Personajes respetables ??????????????????

personajesRespetables(PersonajesRespetables) :-
    findall(Personaje, esRespetable(Personaje), PersonajesRespetables).

esRespetable(Personaje) :-
    personaje(Personaje, Habilidad),
    nivelRespeto(Habilidad, Nivel),
    Nivel > 9.

nivelRespeto(actriz(Peliculas), Nivel) :-
    length(Peliculas, CantidadPeliculas),
    Nivel is CantidadPeliculas / 10.
nivelRespeto(mafioso(resuelveProblemas), 10).
nivelRespeto(mafioso(maton), 1).
nivelRespeto(mafioso(capo), 20). 


% 7) Harto de

hartoDe(Personaje, OtroPersonaje) :-
    personaje(Personaje, _),
    personaje(OtroPersonaje, _),
    Personaje \= OtroPersonaje,
    encargo(_, Personaje, _),
    forall(encargo(_, Personaje, Tarea), involucraAElOAlAmigo(OtroPersonaje, Tarea)).

involucraAElOAlAmigo(Personaje, cuidar(Personaje)).
involucraAElOAlAmigo(Personaje, ayudar(Personaje)).
involucraAElOAlAmigo(Personaje, buscar(Personaje, _)).
involucraAElOAlAmigo(Personaje, cuidar(OtroPersonaje)) :-
    amigo(Personaje, OtroPersonaje).
involucraAElOAlAmigo(Personaje, buscar(OtroPersonaje, _)) :-
    amigo(Personaje, OtroPersonaje).
involucraAElOAlAmigo(Personaje, ayudar(OtroPersonaje)) :-
    amigo(Personaje, OtroPersonaje).



% 8) Duo diferenciable

caracteristicas(vincent, [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules, [tieneCabeza, muchoPelo]).
caracteristicas(marvin, [negro]).

duoDiferenciable(Personaje, OtroPersonaje) :-
    sonParejaOAmigos(Personaje, OtroPersonaje),
    caracteristicas(Personaje, Caracteristicas),
    caracteristicas(OtroPersonaje, OtrasCaracteristicas),
    member(Caracteristica, Caracteristicas),
    not(member(Caracteristica, OtrasCaracteristicas)).



    

