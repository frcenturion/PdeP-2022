% 2 - Parcial Funcional - Alquimia

% Base de conocimiento

herramienta(ana, circulo(50,3)).    % Los círculos alquímicos tienen diámetro en cms y cantidad de niveles.
herramienta(ana, cuchara(40)).      % Las cucharas tienen una longitud en cms.      
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).   % Hay distintos tipos de libro.
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).

% 1) Modelado de jugadores y elementos

jugador(ana, [agua, vapor, tierra, hierro]).
jugador(beto, Inventario) :-
    jugador(ana, Inventario).
jugador(cata, [fuego, tierra, agua, aire]).

esNecesarioParaConstruir(pasto, [agua, tierra]).
esNecesarioParaConstruir(hierro, [fuego, agua, tierra]).
esNecesarioParaConstruir(huesos, [pasto, agua]).
esNecesarioParaConstruir(presion, [hierro, vapor]).
esNecesarioParaConstruir(vapor, [agua, fuego]).
esNecesarioParaConstruir(playStation, [silicio, hierro, plastico]).
esNecesarioParaConstruir(silicio, [tierra]).
esNecesarioParaConstruir(plastico, [huesos, presion]).

% 2) Tiene ingredientes para

tieneIngredientePara(Jugador, ElementoCompuesto) :-
    tieneTalElemento(Jugador, _),
    esNecesarioParaConstruir(ElementoCompuesto, _),
    forall(requiereTalElemento(ElementoCompuesto, Elementos), tieneTalElemento(Jugador, Elementos)).

tieneTalElemento(Jugador, Elemento) :-
    jugador(Jugador, Elementos),
    member(Elemento, Elementos).

requiereTalElemento(ElementoCompuesto, Elemento) :-
    esNecesarioParaConstruir(ElementoCompuesto, Elementos),
    member(Elemento, Elementos).


% 3) Está vivo

estaVivo(agua).
estaVivo(fuego).
estaVivo(ElementoCompuesto) :-
    requiereTalElemento(ElementoCompuesto, Elemento),
    estaVivo(Elemento).


% 4) Personas que pueden construir un elemento

puedeConstruir(Jugador, ElementoCompuesto) :-
    tieneIngredientePara(Jugador, ElementoCompuesto),
    herramienta(Jugador, Herramienta),
    sirveParaConstruir(Herramienta, ElementoCompuesto).


sirveParaConstruir(libro(vida), ElementoCompuesto) :-
    estaVivo(ElementoCompuesto).
sirveParaConstruir(libro(inerte), ElementoCompuesto) :-
    not(estaVivo(ElementoCompuesto)).
sirveParaConstruir(Herramienta, ElementoCompuesto) :-
    cantidadIngredientes(ElementoCompuesto, CantidadIngredientes),
    soportaCantidadIngredientes(Herramienta, CantidadIngredientes).

soportaCantidadIngredientes(cuchara(Longitud), CantidadIngredientes) :-
    Longitud / 10 >= CantidadIngredientes. 
soportaCantidadIngredientes(circulo(Diametro, Niveles), CantidadIngredientes) :-
    Diametro / 100 * Niveles >= CantidadIngredientes.

cantidadIngredientes(ElementoCompuesto, CantidadIngredientes) :-
    esNecesarioParaConstruir(ElementoCompuesto, Elementos),
    length(Elementos, CantidadIngredientes).


% 5) Todopoderoso

todopoderoso(Jugador) :-
    todosSusElementosSonPrimitivos(Jugador),
    tieneHerramientasParaConstruirElementosFaltantes(Jugador).

todosSusElementosSonPrimitivos(Jugador) :-
    tieneTalElemento(Jugador, _),
    forall(tieneTalElemento(Jugador, Elemento), esPrimitivo(Elemento)).

esPrimitivo(Elemento) :-
    esElemento(Elemento),
    not(requiereTalElemento(Elemento, _)).

esElemento(Elemento) :-
    tieneTalElemento(_, Elemento).
esElemento(Elemento) :-
    requiereTalElemento(_, Elemento).
esElemento(Elemento) :-
    tieneTalElemento(Elemento, _).

tieneHerramientasParaConstruirElementosFaltantes(Jugador) :-
    herramienta(Jugador, Herramienta),
    forall(not(tieneTalElemento(Jugador, Elemento)), sirveParaConstruir(Herramienta, Elemento)).


% 6) Quien Gana

quienGana(Jugador) :-
    jugador(Jugador, _),
    forall((jugador(Jugador, _), jugador(OtroJugador, _), Jugador \= OtroJugador), construyeMasCosas(Jugador, OtroJugador)).

construyeMasCosas(Jugador, OtroJugador) :-
    cantidadDeElementosQueConstruye(Jugador, Cantidad),
    cantidadDeElementosQueConstruye(OtroJugador, OtraCantidad),
    Cantidad > OtraCantidad.

cantidadDeElementosQueConstruye(Jugador, Cantidad) :-
    findall(Elemento, puedeConstruir(Jugador, Elemento), Elementos),
    list_to_set(Elementos, ElementosSinRepetidos),
    length(ElementosSinRepetidos, Cantidad).



% 7) Mencionar un lugar de la solución donde se haya hecho uso del concepto de universo cerrado.

/*
    Por ejemplo, cuando en el punto 1 se modelo a Cata, se utilizó el principio de universo cerrado cuando
    no se incluyó entre sus elementos al vapor, pues el enunciado decía explicitamente que no tenía este elemento.

    Asimismo, en el punto 4, cuando ideamos el predicado:

    soportaCantidadIngredientes(cuchara(Longitud), CantidadIngredientes) :-
    Longitud / 10 >= CantidadIngredientes. 
    soportaCantidadIngredientes(circulo(Diametro, Niveles), CantidadIngredientes) :-
    Diametro / 100 * Niveles >= CantidadIngredientes.

    Utilizamos el principio de universo cerrado para darle a entender a nuestra base de conocimiento que los libros
    no soportan ninguna cantidad de ingredientes.

*/





