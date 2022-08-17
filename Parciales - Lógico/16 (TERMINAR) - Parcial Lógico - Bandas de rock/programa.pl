% 15 - Parcial Lógico - Bandas de rock

% Base de conocimiento

anioActual(2015).


%festival(nombre, lugar, bandas, precioBase).
%lugar(nombre, capacidad).
festival(lulapaluza, lugar(hipodromo,40000), [miranda, paulMasCarne, muse], 500).
festival(mostrosDelRock, lugar(granRex, 10000), [kiss, judasPriest, blackSabbath], 1000).
festival(personalFest, lugar(geba, 5000), [tanBionica, miranda, muse, pharrellWilliams], 300).
festival(cosquinRock, lugar(aerodromo, 2500), [erucaSativa, laRenga], 400).

%banda(nombre, año, nacionalidad, popularidad).
banda(paulMasCarne,1960, uk, 70).
banda(muse,1994, uk, 45).
banda(kiss,1973, us, 63).
banda(erucaSativa,2007, ar, 60).
banda(judasPriest,1969, uk, 91).
banda(tanBionica,2012, ar, 71).
banda(miranda,2001, ar, 38).
banda(laRenga,1988, ar, 70).
banda(blackSabbath,1968, uk, 96).
banda(pharrellWilliams,2014, us, 85).


%entradasVendidas(nombreDelFestival, tipoDeEntrada, cantidadVendida).
% tipos de entrada: campo, plateaNumerada(numero de fila), plateaGeneral(zona).
entradasVendidas(lulapaluza,campo, 600).
entradasVendidas(lulapaluza,plateaGeneral(zona1), 200).
entradasVendidas(lulapaluza,plateaGeneral(zona2), 300).
entradasVendidas(mostrosDelRock,campo,20000).
entradasVendidas(mostrosDelRock,plateaNumerada(1),40).
entradasVendidas(mostrosDelRock,plateaNumerada(2),0).
entradasVendidas(mostrosDelRock,plateaNumerada(10),25).
entradasVendidas(mostrosDelRock,plateaGeneral(zona1),300).
entradasVendidas(mostrosDelRock,plateaGeneral(zona2),500).

plusZona(hipodromo, zona1, 55).
plusZona(hipodromo, zona2, 20).
plusZona(granRex, zona1, 45).
plusZona(granRex, zona2, 30).
plusZona(aerodromo, zona1, 25).


% 1) Esta de moda

estaDeModa(Banda) :-
    banda(Banda, _, _, Popularidad),
    esReciente(Banda),
    Popularidad > 70.

esReciente(Banda) :-
    banda(Banda, Anio, _, _),
    anioActual(AnioActual),
    ultimos5Anios(AnioActual, Ultimos5Anios),
    between(Ultimos5Anios, AnioActual, Anio).
    
ultimos5Anios(AnioActual, Ultimos5Anios) :-
    Ultimos5Anios is AnioActual - 5.


% 2) Es careta

esCareta(Festival) :-
    festival(Festival, _, _, _),
    cumpleCondiciones(Festival). 

cumpleCondiciones(Festival) :-
    tieneDosOMasBandasDeModa(Festival).
cumpleCondiciones(Festival) :-
    participa(miranda, Festival).
cumpleCondiciones(Festival) :-
    not(entradaRazonable(Festival, _)). 

tieneDosOMasBandasDeModa(Festival) :-
    festival(Festival, _, Bandas, _),
    findall(Banda, (estaDeModa(Banda), member(Banda, Bandas)), BandasDeModa),
    length(BandasDeModa, CantidadBandasDeModa),
    CantidadBandasDeModa >= 2.

participa(Banda, Festival) :-
    festival(Festival, _, Bandas, _),
    member(Banda, Bandas).


% 3) Entrada razonable

entradaRazonable(Festival, plateaGeneral(Zona)) :-
    calcularPrecio(Festival, plateaGeneral(Zona), Precio),
    plusZona(_, Zona, Plus),
    Plus < Precio * 0.10.
entradaRazonable(Festival, campo) :-
    calcularPrecio(Festival, campo, Precio),
    popularidadTotal(Festival, PopularidadTotal),
    Precio < PopularidadTotal.
entradaRazonable(Festival, plateaNumerada(Fila)) :-
    calcularPrecio(Festival, plateaNumerada(Fila), Precio),
    participa(Banda, Festival),
    not(estaDeModa(Banda)),
    Precio < 750.
entradaRazonable(Festival, plateaNumerada(Fila)) :-
    calcularPrecio(Festival, plateaNumerada(Fila), Precio),
    participa(Banda, Festival),
    estaDeModa(Banda),
    festival(Festival, lugar(_, Capacidad), _, _),
    popularidadTotal(Festival, PopularidadTotal),
    Precio < Capacidad/PopularidadTotal.

popularidadTotal(Festival, PopularidadTotal) :-
    findall(Popularidad, (banda(Banda, _, _, Popularidad), participa(Banda, Festival)), Popularidades),
    sum_list(Popularidades, PopularidadTotal).
    

calcularPrecio(Festival, campo, PrecioBase) :-
    festival(Festival, _, _, PrecioBase),
    entradasVendidas(Festival, campo, _).
calcularPrecio(Festival, plateaNumerada(Fila), Precio) :-
    festival(Festival, _, _, PrecioBase),
    entradasVendidas(Festival, plateaNumerada(Fila), _),
    Precio is PrecioBase + 200/Fila.
calcularPrecio(Festival, plateaGeneral(Zona), Precio) :-
    festival(Festival, _, _, PrecioBase),
    entradasVendidas(Festival, plateaGeneral(Zona), _),
    plusZona(_, Zona, Plus),
    Precio is PrecioBase + Plus.



% 4) Nac & Pop FALTA CONDICION DE LAS ENTRADAS RAZONABLES

nacanpop(Festival) :-
    festival(Festival, _, _, _),
    forall(participa(Banda, Festival), esNacional(Banda)),
    entradaRazonable(Festival, _).

esNacional(Banda) :-
    banda(Banda, _, ar, _).


% 5) Recaudacion

/* recaudacion(Festival, Transf) :-
    findall(Entrada, entradasVendidas(Festival, Entrada, Cantidad), Entradas),
    maplist(precioTotal, Entradas, Transf).
    
precioTotal(Entrada, Total) :-
    entradasVendidas(_, Entrada, Cantidad),
    calcularPrecio(_, Entrada, Precio),
    Total is Precio * Cantidad.


 */
    


% 6) Esta bien planeado

%estaBienPlaneado(Festival) :-


banda(falopa, 1, ar, 1).
banda(hola, 1, ar, 2).
banda(chau, 1, ar, 3).


vanCreciendoEnPopularidad([_]).
vanCreciendoEnPopularidad([Banda1,Banda2|Bandas]) :-
    esMenosPopular(Banda1, Banda2),
    vanCreciendoEnPopularidad([Banda2|Bandas]).

esMenosPopular(Banda1, Banda2) :-
    banda(Banda1, _, _, Popularidad1),
    banda(Banda2, _, _, Popularidad2),
    Popularidad1 =< Popularidad2,
    Banda1 \= Banda2.


esLegendaria(Banda) :-
    surgioAntesDe1980(Banda),
    esInternacional(Banda),
    popularidadMayorAModa(Banda).

surgioAntesDe1980(Banda) :-
    banda(Banda, Anio, _, _),
    Anio < 1980.

esInternacional(Banda) :-
    banda(Banda, _, Pais, _),
    Pais \= ar.

popularidadMayorAModa(Banda) :-
    banda(Banda, _, _, Popularidad),
    forall((banda(BandaDeModa, _, _, PopularidadModa), estaDeModa(BandaDeModa)), Popularidad > PopularidadModa).