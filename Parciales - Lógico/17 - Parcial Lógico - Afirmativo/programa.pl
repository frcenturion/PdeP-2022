% 17 - Parcial Lógico - Afirmativo

%tarea(agente, tarea, ubicacion)
%tareas:
%  ingerir(descripcion, tamaño, cantidad)
%  apresar(malviviente, recompensa)
%  asuntosInternos(agenteInvestigado)
%  vigilar(listaDeNegocios)

tarea(vigilanteDelBarrio, ingerir(pizza, 1.5, 2),laBoca).
tarea(vigilanteDelBarrio, vigilar([pizzeria, heladeria]), barracas).
tarea(canaBoton, asuntosInternos(vigilanteDelBarrio), barracas).
tarea(sargentoGarcia, vigilar([pulperia, haciendaDeLaVega, plaza]),puebloDeLosAngeles).
tarea(sargentoGarcia, ingerir(vino, 0.5, 5),puebloDeLosAngeles).
tarea(sargentoGarcia, apresar(elzorro, 100), puebloDeLosAngeles). 
tarea(vega, apresar(neneCarrizo,50),avellaneda).
tarea(jefeSupremo, vigilar([congreso,casaRosada,tribunales]),laBoca).

%Las ubicaciones que existen son las siguientes:
ubicacion(puebloDeLosAngeles).
ubicacion(avellaneda).
ubicacion(barracas).
ubicacion(marDelPlata).
ubicacion(laBoca).
ubicacion(uqbar).

%Por último, se sabe quién es jefe de quién:
%jefe(jefe, subordinado)
jefe(jefeSupremo,vega ).
jefe(vega, vigilanteDelBarrio).
jefe(vega, canaBoton).
jefe(jefeSupremo,sargentoGarcia).


% 1) Frecuenta

frecuenta(Agente, Ubicacion) :-
    tarea(Agente, _, Ubicacion).
frecuenta(_, buenosAires).
frecuenta(vega, quilmes).
frecuenta(Agente, marDelPlata) :-
    tarea(Agente, vigilar(Lugares), _),
    vendeAlfajores(Lugar),
    member(Lugar, Lugares).

vendeAlfajores(havanna).


% 2) Es inaccesible

inaccesible(Ubicacion) :-
    ubicacion(Ubicacion),
    not(frecuenta(_, Ubicacion)).


% 3) Afincado

afincado(Agente) :-
    tarea(Agente, _, Ubicacion),
    forall(tarea(Agente, _, OtraUbicacion), Ubicacion == OtraUbicacion).


% 4) Cadena de mando

cadenaDeMando([_]).
cadenaDeMando([Persona1, Persona2|Personas]) :-
    jefe(Persona1, Persona2),
    cadenaDeMando([Persona2|Personas]).


% 5) Agente premiado

agentePremiado(Agente) :-
    calcularPuntuacion(Agente, Puntuacion),
    forall(calcularPuntuacion(_, OtraPuntuacion), Puntuacion >= OtraPuntuacion).

agente(Agente) :-
    tarea(Agente, _, _).

calcularPuntuacion(Agente, Puntuacion) :-
    agente(Agente),
    findall(Puntos, (tarea(Agente, Tarea, _), puntosTarea(Tarea, Puntos)), Puntajes),
    sum_list(Puntajes, Puntuacion).
    
puntosTarea(vigilar(Negocios), Puntos) :-
    length(Negocios, CantidadNegocios),
    Puntos is 5 * CantidadNegocios.
puntosTarea(ingerir(_, Tamanio, Cantidad), Puntos) :-
    Puntos is (Tamanio * Cantidad) * -10.
puntosTarea(apresar(_, Recompensa), Puntos) :-
    Puntos is Recompensa/2.
puntosTarea(asuntosInternos(Vigilado), Puntos) :-
    calcularPuntuacion(Vigilado, Puntuacion),
    Puntos is Puntuacion * 2.


% 6)

/*
    > Polimorfismo: se utilizó el concepto de polimorfismo para el predicado puntosTarea/2, ya que el puntaje se calcula de distinta
    manera según el tipo de tarea del que se trate. En este sentido, este predicado es polimórfico.

    > Orden superior: n

    > Inversibilidad: los predicados que se hicieron son inversibles en la medida en que, además de realizar la consulta particular, se puede
    hacer la consulta existencial, según la cual Prolog nos dice cuáles son aquellos individuos que cumplen con cierto predicado.

*/


