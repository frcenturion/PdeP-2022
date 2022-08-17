% 4 - Parcial Funcional - Vocaloid

% a) Base de conocimientos inicial

cantante(megurineLuka, cancion(nightFever, 4)).
cantante(megurineLuka, cancion(foreverYoung, 5)).
cantante(hatsuneMiku, cancion(tellYourWorld, 4)).
cantante(gumi, cancion(foreverYoung, 4)).
cantante(gumi, cancion(tellYourWorld, 5)).
cantante(seeU, cancion(novemberRain, 6)).
cantante(seeU, cancion(nightFever, 5)).

% 1) Cantantes novedosos

esNovedoso(Cantante) :-
    esCantante(Cantante),
    cantidadCanciones(Cantante, CantidadCanciones),
    CantidadCanciones > 2,
    duracionTotalCanciones(Cantante, DuracionTotalCanciones),
    DuracionTotalCanciones < 15.

esCantante(Cantante) :-
    cantante(Cantante, _).

cantidadCanciones(Cantante, CantidadCanciones) :-
    findall(Cancion, cantante(Cantante, cancion(Cancion, _)), Canciones),
    length(Canciones, CantidadCanciones).

duracionTotalCanciones(Cantante, DuracionTotalCanciones) :-
    findall(Duracion, cantante(Cantante, cancion(_, Duracion)), Duraciones),
    sum_list(Duraciones, DuracionTotalCanciones).


% 2) Es acelerado

esAcelerado(Cantante) :-
    esCantante(Cantante),
    not((tiempoCancion(Cantante, _, Tiempo), Tiempo > 4)).

tiempoCancion(Cantante, Cancion, Tiempo) :-
    cantante(Cantante, cancion(Cancion, Tiempo)).


% b) Parte 2

% 1) Modelado de conciertos

% concierto(Nombre, Pais, Fama, Tipo)

% gigante(CantidadMinimaCancionesQueSabe, CantidadDada).
% mediano(CantidadDada). 
% pequenio(CantidadDada).

concierto(mikuExpo, eeuu, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, eeuu, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

% 2) Puede participar


puedeParticipar(hatsuneMiku, Concierto) :-
    concierto(Concierto, _, _, _).
puedeParticipar(Cantante, Concierto) :-
    esCantante(Cantante),
    Cantante \= hatsuneMiku,
    concierto(Concierto, _, _, TipoConcierto),
    cumpleRequisitos(Cantante, TipoConcierto).


cumpleRequisitos(Cantante, gigante(CantidadMinimaCancionesQueSabe, CantidadDada)) :-
    cantidadCanciones(Cantante, CantidadCanciones),
    CantidadCanciones >= CantidadMinimaCancionesQueSabe,
    duracionTotalCanciones(Cantante, DuracionTotalCanciones),
    DuracionTotalCanciones > CantidadDada.

cumpleRequisitos(Cantante, mediano(CantidadDada)) :-
    duracionTotalCanciones(Cantante, DuracionTotalCanciones),
    DuracionTotalCanciones < CantidadDada.

cumpleRequisitos(Cantante, pequenio(CantidadDada)) :-
    cantante(Cantante, cancion(Cantante, cancion(_, Tiempo))),
    Tiempo > CantidadDada.


% 3) Vocaloid más famoso

masFamoso(Cantante) :-
    esCantante(Cantante),
    forall((esCantante(Cantante), esCantante(OtroCantante), Cantante \= OtroCantante), esMasFamoso(Cantante, OtroCantante)).

masFamoso2(Cantante) :-
    nivelDeFama(Cantante, NivelMasFamoso),
    forall(nivelDeFama(_, Nivel), NivelMasFamoso >= Nivel).

esMasFamoso(Cantante, OtroCantante) :-
    nivelDeFama(Cantante, Fama),
    nivelDeFama(OtroCantante, OtraFama),
    Fama > OtraFama.
    
nivelDeFama(Cantante, Fama) :-
    famaTotal(Cantante, FamaTotal),
    cantidadCanciones(Cantante, CantidadCanciones),
    Fama is FamaTotal * CantidadCanciones.

famaTotal(Cantante, FamaTotal) :-
    esCantante(Cantante),
    findall(Fama, famaConcierto(Cantante, Fama), Famas),
    sum_list(Famas, FamaTotal).

famaConcierto(Cantante, Fama) :-
    puedeParticipar(Cantante, Concierto),
    fama(Concierto, Fama).

fama(Concierto, Fama) :-
    concierto(Concierto, _, Fama, _).


% 4) Es el único que participa de un concierto

conoceA(megurineLuka, hatsuneMiku).
conoceA(megurineLuka, gumi).
conoceA(gumi, seeU).
conoceA(seeU, kaito).

esElUnico(Cantante, Concierto) :-
    puedeParticipar(Cantante, Concierto),
    not(conocido(Cantante, OtroCantante)),
    puedeParticipar(OtroCantante, Concierto).

conocido(Cantante, OtroCantante) :-
    conoceA(Cantante, OtroCantante).
conocido(Cantante, OtroCantanteMas) :-
    conoceA(Cantante, OtroCantante),
    conoceA(OtroCantante, OtroCantanteMas).


% 5) 

/*
    Supongamos que aparece un nuevo tipo de concierto y necesitamos tenerlo en cuenta en
    nuestra solución, explique los cambios que habría que realizar para que siga todo
    funcionando. ¿Qué conceptos facilitaron dicha implementación?

    RTA: Para que todo siga funcionando, se debería agregar una cláusula del predicado cumpleRequisitos que tenga
    en cuenta los requisitos que se deben cumplir para poder participar de este nuevo tipo de concierto.

    El concepto de polimorfismo facilita esta implementación, ya que nos permite tratar de distinta manera a cada
    tipo de concierto, que tienen distintas formas.
*/





    