% 8 - Parcial Lógico - Who you gonna call

herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

% 1) Agregar a la base de conocimiento

tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(egon, sopapa).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).

/* 
    Para reflejar que Ray y Winston no tienen un trapeador, y que nadie tiene una bordeadora, utilizamos 
    el concepto de universo cerrado, por el cual se asume falso todo aquello que no agreguemos a la base
    de conocimiento. 
*/


% 2) Satisface la necesidad

satisfaceNecesidad(Persona, aspiradora(PotenciaRequerida)) :-
    tiene(Persona, aspiradora(Potencia)),
    Potencia >= PotenciaRequerida.
satisfaceNecesidad(Persona, HerramientaRequerida) :-
    tiene(Persona, HerramientaRequerida).


% 3) Puede realizar una tarea


puedeRealizarTarea(Persona, Tarea) :-
    herramientasRequeridas(Tarea, _),
    tiene(Persona, varitaDeNeutrones).
puedeRealizarTarea(Persona, Tarea) :-
    tiene(Persona, _),
    herramientasRequeridas(Tarea, HerramientasRequeridas),
    forall(member(Herramienta, HerramientasRequeridas), satisfaceNecesidad(Persona, Herramienta)).


% 4) Cuanto se le debe cobrar a un cliente por las tareas que pide

tareaPedida(franco, limpiarBanio, 10).
tareaPedida(franco, limpiarTecho, 10).
tareaPedida(alejandro, cortarPasto, 10).


precio(limpiarBanio, 10).
precio(limpiarTecho, 10).


cuantoCobrar(Cliente, Pedido, Total) :-
    pedido(Cliente, Pedido),
    maplist(calcularPrecio, Pedido, Precios),
    sum_list(Precios, Total).

pedido(Cliente, Pedido) :-
    tareaPedida(Cliente, _, _),
    findall(TareaPedida, tareaPedida(Cliente, TareaPedida, _), Pedido).  % SE PODRIA NO HABER HECHO

calcularPrecio(Tarea, Precio) :-
    tareaPedida(_, Tarea, MetrosCuadrados),
    precio(Tarea, Costo),
    Precio is MetrosCuadrados * Costo.

% Sin maplist

cuantoCobrarV2(Cliente, Pedido, Total) :-
    pedido(Cliente, Pedido),
    findall(Precio, (calcularPrecio(Tarea, Precio), member(Tarea, Pedido)), Precios),
    sum_list(Precios, Total).

% Mejor version:

cuantoCobrarV3(Cliente, Total) :-
    tareaPedida(Cliente, _, _),
    findall(Precio, calcularPrecioV2(_, Precio, Cliente), Precios),
    sum_list(Precios, Total).

calcularPrecioV2(Tarea, Precio, Cliente) :-
    tareaPedida(Cliente, Tarea, MetrosCuadrados),
    precio(Tarea, Costo),
    Precio is MetrosCuadrados * Costo.


% 5) Acepta el pedido

aceptaPedido(Persona, Pedido) :-
    puedeRealizarTarea(Persona, _),
    pedido(_, Pedido),
    forall((tareaPedida(_, Tarea, _), member(Tarea, Pedido)), puedeRealizarTarea(Persona, Tarea)),
    estaDispuestoAAceptarlo(Persona, Pedido).

estaDispuestoAAceptarlo(ray, Pedido) :-
    pedido(_, Pedido),
    not(member(limpiarTecho, Pedido)).
estaDispuestoAAceptarlo(winston, Pedido) :-
    pedido(_, Pedido),
    cuantoCobrar(_, Pedido, Total),
    Total > 500.
estaDispuestoAAceptarlo(egon, Pedido) :-
    pedido(_, Pedido),
    noTieneTareasComplejas(Pedido).
estaDispuestoAAceptarlo(peter, Pedido) :-
    pedido(_, Pedido).

noTieneTareasComplejas(Pedido) :-
    forall(member(Tarea, Pedido), not(tareaCompleja(Tarea))).

tareaCompleja(limpiarTecho).
tareaCompleja(Tarea) :-
    herramientasRequeridas(Tarea, HerramientasRequeridas),
    length(HerramientasRequeridas, CantidadHerramientas),
    CantidadHerramientas > 2.


% Otra version:

tareaComplejaV2(limpiarTecho).
tareaComplejaV2(Tarea) :-
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, Cantidad),
    Cantidad > 2.

aceptaPedidoV2(Persona, Cliente) :-
    puedeHacerPedido(Persona, Cliente),
    estaDispuestoAAceptarloV2(Persona, Cliente).

puedeHacerPedido(Persona, Cliente) :-
    tareaPedida(Cliente, _, _),
    tiene(Persona, _),
    forall(tareaPedida(Cliente, Tarea, _), puedeRealizarTarea(Persona, Tarea)).

estaDispuestoAAceptarloV2(peter, _).
estaDispuestoAAceptarloV2(ray, Cliente) :-
    not(tareaPedida(Cliente, limpiarTecho, _)).
estaDispuestoAAceptarloV2(winston, Cliente) :-
    cuantoCobrarV3(Cliente, Total),
    Total >= 500.
estaDispuestoAAceptarloV2(egon, Cliente) :-
    forall(tareaPedida(Cliente, Tarea, _), not(tareaCompleja(Tarea))).




% 6) Agregar la posibilidad de tener herramientas reemplazables 

satisfaceNecesidad(Persona, ListaRemplazables):-
	member(Herramienta, ListaRemplazables),
	satisfaceNecesidad(Persona, Herramienta).








