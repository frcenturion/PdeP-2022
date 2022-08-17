% 9 - Parcial Lógico - Las casas de Hogwarts

% Parte 1 - Sombrero seleccionador

sangre(harry, mestiza).
sangre(draco, pura).
sangre(hermione, impura).

caracteristica(harry, corajudo).
caracteristica(harry, amistoso).
caracteristica(harry, orgulloso).
caracteristica(harry, inteligente).
caracteristica(draco, orgulloso).
caracteristica(draco, inteligente).
caracteristica(hermione, orgulloso).
caracteristica(hermione, inteligente).
caracteristica(hermione, responsable).

odiaria(harry, slytherin).
odiaria(draco, hufflepuff).

caracteristicaPrincipal(gryffindor, corajudo).
caracteristicaPrincipal(slytherin, orgulloso).
caracteristicaPrincipal(slytherin, inteligente).
caracteristicaPrincipal(ravenclaw, inteligente).
caracteristicaPrincipal(ravenclaw, responsable).
caracteristicaPrincipal(hufflepuff, amistoso).


% 1) Saber si una casa permite entrar a un mago


casa(gryffindor).
casa(hufflepuff).
casa(slytherin).
casa(ravenclaw).

mago(Mago) :-
    sangre(Mago, _).

permiteEntrar(Casa, Mago) :-
    casa(Casa),
    mago(Mago),
    Casa \= slytherin.
permiteEntrar(slytherin, Mago) :-
    sangre(Mago, Sangre),
    Sangre \= impura.


% 2) Tiene caracter apropiado

caracterApropiado(Mago, Casa) :-
    mago(Mago),
    casa(Casa),
    forall(caracteristicaPrincipal(Casa, CaracteristicaPrincipal), caracteristica(Mago, CaracteristicaPrincipal)).


% 3) En que casa podría quedar seleccionado un mago

puedeQuedar(Mago, Casa) :-
    caracterApropiado(Mago, Casa),
    permiteEntrar(Casa, Mago),
    not(odiaria(Mago, Casa)).
puedeQuedar(hermione, gryffindor).


% 4) Cadena de amistades

%cadenaDeAmistades(Magos) :-
    

% Parte 2 - La copa de las casas

accion(harry, andarFueraDeLaCama).
accion(hermione, irA(seccionRestringida))
accion(harry, irA(bosque)).
accion(harry, irA(tercerPiso)).
accion(draco, irA(mazmorras)).
accion(ron, buenaAccion(50, ganarPartidaAjedrezMagico)).
accion(hermione, buenaAccion(50, salvarASusAmigos)).
accion(harry, buenaAccion(60, ganarleAVoldemort)).



hizoAlgunaAccion(Mago) :-
    accion(Mago, _).

hizoMalaAccion(Mago) :-
    accion(Mago, Accion),
    puntaje(Accion, Puntaje),
    Puntaje < 0.

puntaje(andarFueraDeLaCama, -50).
puntaje(Accion, Puntaje) :-


% 1) 

% a) Es buen alumno

esBuenAlumno(Mago) :-
    hizoAlgunaAccion(Mago),
    not(hizoMalaAccion(Mago)).




