% 11 - Parcial Lógico - Previaje

comercioAdherido(iguazu, grandHotelIguazu).
comercioAdherido(iguazu, gargantaDelDiabloTour).
comercioAdherido(bariloche, aerolineas).
comercioAdherido(iguazu, aerolineas).
comercioAdherido(bariloche, latam).
comercioAdherido(iguazu, iguazuHotel).

valorMaximoHotel(5000).

%factura(Persona, DetalleFactura).
%Detalles de facturas posibles:
% hotel(ComercioAdherido, ImportePagado)
% excursion(ComercioAdherido, ImportePagadoTotal, CantidadPersonas)
% vuelo(NroVuelo,NombreCompleto)

factura(estanislao, hotel(grandHotelIguazu, 2000)).
factura(ivan, hotel(iguazuHotel, 2000)).
factura(estanislao, hotel(falopa, 2000)).
factura(antonieta, excursion(gargantaDelDiabloTour, 5000, 4)).
factura(antonieta, vuelo(1515, antonietaPerez)).
factura(antonieta, vuelo(1345, antonietaPerez)).
factura(franco, vuelo(1345, francoCenturion)).
factura(franco, vuelo(6666, francoCenturion)).


%registroVuelo(NroVuelo,Destino,ComercioAdherido,Pasajeros,Precio)
registroVuelo(1515, iguazu, aerolineas, [estanislaoGarcia, antonietaPerez, danielIto], 10000).
registroVuelo(1345, bariloche, latam, [francoCenturion, antonietaPerez], 10000).
registroVuelo(6666, caba, aerolineas, [francoCenturion], 10000).


% 1) Monto a devolver a cada persona que presentó facturas

montoADevolverTotal(Persona, MontoTotal) :-
    montoTotalFacturas(Persona, MontoTotalFacturas),
    montoTotalCiudadesEnLasQueSeAlojo(Persona, MontoTotalCiudadesEnLasQueSeAlojo),
    penalidad(Persona, Penalidad),
    MontoTotal is min(MontoTotalFacturas + MontoTotalCiudadesEnLasQueSeAlojo - Penalidad, 100000).
    
montoTotalFacturas(Persona, MontoFinal) :-
    findall(Monto, montoADevolverPorFactura(Persona, Monto), MontoTotalFacturas),
    list_to_set(MontoTotalFacturas, MontosSinRepetir),
    sum_list(MontosSinRepetir, MontoFinal).

montoADevolverPorFactura(Persona, Devolucion) :-
    factura(Persona, Detalle),
    esFacturaValida(Detalle),
    calculoDevolucion(Detalle, Devolucion).

esFacturaValida(hotel(Comercio, ImportePagado)) :-
    comercioAdherido(_, Comercio),
    valorMaximoHotel(ValorMaximo),
    ImportePagado =< ValorMaximo.
esFacturaValida(excursion(Comercio, _, _)) :-
    comercioAdherido(_, Comercio).
esFacturaValida(vuelo(NroVuelo, NombreCompleto)) :-
    registroVuelo(NroVuelo, _, Aerolinea, ListaPasajeros, _),
    comercioAdherido(_, Aerolinea),
    member(NombreCompleto, ListaPasajeros).


calculoDevolucion(hotel(_, Monto), Devolucion) :-
    Devolucion is Monto * 0.5.
calculoDevolucion(vuelo(NroVuelo, _), Devolucion) :-
    registroVuelo(NroVuelo, Destino, _, _, Precio),
    Destino \= buenosAires,
    Devolucion is Precio * 0.3.
calculoDevolucion(vuelo(NroVuelo, _), 0) :-
    registroVuelo(NroVuelo, buenosAires, _, _, _).
calculoDevolucion(excursion(_, ImporteTotal, CantidadPersonas), Devolucion) :-
    Devolucion is (ImporteTotal * 0.8) / CantidadPersonas.


seAlojoEn(Persona, Ciudad) :-
    factura(Persona, Detalle),
    esFacturaValida(Detalle),
    buscarCiudad(Detalle, Ciudad).

buscarCiudad(hotel(Nombre, _), Ciudad) :-
    comercioAdherido(Ciudad, Nombre).

ciudadesEnLasQueSeAlojo(Persona, CiudadesVisitadas) :-
    findall(Ciudad, seAlojoEn(Persona, Ciudad), Ciudades),
    list_to_set(Ciudades, CiudadesVisitadas).

montoTotalCiudadesEnLasQueSeAlojo(Persona, MontoTotalCiudadesEnLasQueSeAlojo) :-
    ciudadesEnLasQueSeAlojo(Persona, CiudadesEnLasQueSeAlojo),
    length(CiudadesEnLasQueSeAlojo, CantidadCiudadesEnLasQueSeAlojo),
    MontoTotalCiudadesEnLasQueSeAlojo is CantidadCiudadesEnLasQueSeAlojo * 1000.
    

penalidad(Persona, Penalidad) :-
    factura(Persona, Detalle),
    not(esFacturaValida(Detalle)),
    Penalidad is 15000.
penalidad(Persona, Penalidad) :-
    factura(Persona, Detalle),
    esFacturaValida(Detalle),
    Penalidad is 0.


% 2) Destinos de trabajo

esDestinoDeTrabajo(Ciudad) :-
    tuvoVuelos(Ciudad),
    noTuvieronNingunAlojamientoOTienenUnSoloHotelAdherido(Ciudad).

tuvoVuelos(Ciudad) :-
    factura(_, vuelo(NroVuelo, _)),
    registroVuelo(NroVuelo, Ciudad, _, _, _).
    
noTuvieronNingunAlojamientoOTienenUnSoloHotelAdherido(Ciudad) :-
    not(seAlojoEn(_, Ciudad)).
noTuvieronNingunAlojamientoOTienenUnSoloHotelAdherido(Ciudad) :-
    hotelesAdheridos(Ciudad, Hoteles),
    length(Hoteles, 1).

hotelesAdheridos(Ciudad, Hoteles) :-
    findall(Hotel, (esHotel(Hotel), comercioAdherido(Ciudad, Hotel)), Hoteles).

esHotel(Comercio) :-
    factura(_, hotel(Comercio, _)).
    

% 3) Quienes son estafadores

esEstafador(Persona) :-
    factura(Persona, _),
    forall(factura(Persona, Detalle), not(esFacturaValida(Detalle))).
esEstafador(Persona) :-
    factura(Persona, _),
    forall(factura(Persona, Detalle), esDeMontoCero(Detalle)).


% VERSION MEJORADA:

esEstafador2(Persona) :-
    factura(Persona, _),
    forall(factura(Persona, Detalle), facturaTruchaODeMonto0(Detalle)).

facturaTruchaODeMonto0(Detalle) :-
    not(esFacturaValida(Detalle)).
facturaTruchaODeMonto0(Detalle) :-
    esDeMontoCero(Detalle).

esDeMontoCero(Detalle) :-
    obtenerImporte(Detalle, 0).

obtenerImporte(hotel(_, ImportePagado), ImportePagado).
obtenerImporte(excursion(_, ImportePagado, _), ImportePagado).
obtenerImporte(vuelo(NroVuelo, _), ImportePagado) :-
    registroVuelo(NroVuelo, _, _, _, ImportePagado).


% 4) Inventar un nuevo tipo de comercio

/*
    Vamos a inventar un nuevo tipo de comercio que va a constar de una visita a un parque nacional. Para ello, ahora disponemos de un nuevo functor que es
    parqueNacional(nombreDelParque, precioEntrada). Quizás el nombre comercio no resulte adecuado para referirse a un parque nacional, pero lo consideraremos como tal. 
    
    Al agregar este nuevo tipo de comercio, ahora, debemos agregar una nueva cláusula en el predicado calculoDevolucion/2, ya que esta vez elegiremos otro criterio
    de devolución para los parques nacionales, según el cuál se devuelve el 95% del precio de la entrada. 
    
    Asimismo, deberemos agregar una nueva cláusula en el predicado esFacturaValida/1, que contemple el caso en que la visita a los parques nacionales es válida. Consideraremos
    la misma como válida cuando el parque nacional sea un comercio adherido.

    Lo que nos permitió agregar este nuevo comercio adherido sin tener que modificar mucho código fue el concepto de polimorfismo, el cuál nos permite delegar en un
    predicado distinto al principal, la tarea de lidiar con el tipo de functor que se trabaje, en este caso, con el tipo de comercio.
    De esta forma, estamos tratando de distinta manera a cada tipo de comercio, ya que cada uno tiene sus propios criterios de devolución y sus propios criterios
    para considerarse como válido.
*/

% 5) Agregar hechos de ejemplo

% Los mismos fueron añadidos a lo largo del parcial.








    




    

