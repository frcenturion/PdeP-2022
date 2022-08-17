% 7 - Parcial Lógico - La Leyenda de Aang

% esPersonaje/1 nos permite saber qué personajes tendrá el juego
esPersonaje(aang).
esPersonaje(katara).
esPersonaje(zoka).
esPersonaje(appa).
esPersonaje(momo).
esPersonaje(toph).
esPersonaje(tayLee).
esPersonaje(zuko).
esPersonaje(azula).
esPersonaje(iroh).

% esElementoBasico/1 nos permite conocer los elementos básicos que pueden controlar algunos personajes
esElementoBasico(fuego).
esElementoBasico(agua).
esElementoBasico(tierra).
esElementoBasico(aire).

% elementoAvanzadoDe/2 relaciona un elemento básico con otro avanzado asociado
elementoAvanzadoDe(fuego, rayo).
elementoAvanzadoDe(agua, sangre).
elementoAvanzadoDe(tierra, metal).

% controla/2 relaciona un personaje con un elemento que controla
controla(zuko, rayo).
controla(toph, metal).
controla(katara, sangre).
controla(aang, aire).
controla(aang, agua).
controla(aang, tierra).
controla(aang, fuego).
controla(azula, rayo).
controla(iroh, rayo).

% visito/2 relaciona un personaje con un lugar que visitó. Los lugares son functores que tienen la siguiente forma:
% reinoTierra(nombreDelLugar, estructura)
% nacionDelFuego(nombreDelLugar, soldadosQueLoDefienden)
% tribuAgua(puntoCardinalDondeSeUbica)
% temploAire(puntoCardinalDondeSeUbica)
visito(aang, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(iroh, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(zuko, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(toph, reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios, enfermeria, salaDeGuerra, templo, zonaDeRecreo])).
visito(aang, nacionDelFuego(palacioReal, 1000)).
visito(katara, tribuAgua(norte)).
visito(franco, tribuAgua(norte)).
visito(alejo, tribuAgua(norte)).
visito(tobias, tribuAgua(norte)).
visito(martina, tribuAgua(norte)).
visito(katara, tribuAgua(sur)).
visito(aang, temploAire(norte)).
visito(aang, temploAire(oeste)).
visito(aang, temploAire(este)).
visito(aang, temploAire(sur)).


% 1) El avatar

esElAvatar(Personaje) :-
    controla(Personaje, _),
    forall(esElementoBasico(Elemento), controla(Personaje, Elemento)).


% 2) Clasificación

noEsMaestro(Personaje) :-
    esPersonaje(Personaje),
    not(controla(Personaje, _)).
    
esMaestroPrincipiante(Personaje) :-
    controla(Personaje, Elemento),
    esElementoBasico(Elemento),
    not(elementoAvanzadoDe(_, Elemento)).

esMaestroAvanzado(Personaje) :-
    controla(Personaje, Elemento),
    elementoAvanzadoDe(_, Elemento).
esMaestroAvanzado(Personaje) :-
    esElAvatar(Personaje).


% 3) Sigue a otro

sigueA(Personaje, OtroPersonaje) :-
    esPersonaje(Personaje),
    esPersonaje(OtroPersonaje),
    Personaje \= OtroPersonaje,
    forall(visito(Personaje, Lugares), visito(OtroPersonaje, Lugares)).
sigueA(zuko, aang).


% 4) Es digno de conocer

esDignoDeConocer(temploAire(_)).
esDignoDeConocer(tribuAgua(norte)).
esDignoDeConocer(reinoTierra(_, Facilidades)) :-
    not(member(muro, Facilidades)).

% TOMY:
esDignoDeConocer(temploAire(_)).
esDignoDeConocer(tribuAgua(norte)).
esDignoDeConocer(reinoTierra(Nombre, Estructura)):-
    visito(_, reinoTierra(Nombre, Estructura)),
    not(member(muro, Estructura)).


% 5) Es popular

esPopular(Lugar) :-
    visito(_, Lugar),
    personajesQueVisitaron(Personajes, Lugar),
    length(Personajes, CantidadPersonajes),
    CantidadPersonajes > 4.
    

personajesQueVisitaron(Personajes, Lugar) :-
    findall(Personaje, visito(Personaje, Lugar), Personajes).



% 6) Modelado de personajes desbloqueables en el juego

esPersonaje(bumi).
controla(bumi, tierra).
visito(bumi, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).

esPersonaje(suki).
visito(suki, nacionDelFuego(prisionDeMaximaSeguridad, 200)).






