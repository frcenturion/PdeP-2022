% 19 - Parcial Lógico - Supermercado

%primeraMarca(Marca)
primeraMarca(laSerenisima).
primeraMarca(gallo).
primeraMarca(vienisima).

%precioUnitario(Producto,Precio)
%donde Producto puede ser arroz(Marca), lacteo(Marca,TipoDeLacteo), salchichas(Marca,Cantidad)
precioUnitario(arroz(gallo),25.10).
precioUnitario(lacteo(laSerenisima,leche), 6.00).
precioUnitario(lacteo(laSerenisima,crema), 4.00).
precioUnitario(lacteo(gandara,queso(gouda)), 13.00).
precioUnitario(lacteo(vacalin,queso(mozzarella)), 12.50).
precioUnitario(lacteo(gandara,queso(mozzarella)), 12.50).
precioUnitario(salchichas(vienisima,12), 9.80).
precioUnitario(salchichas(vienisima, 6), 5.80).
precioUnitario(salchichas(granjaDelSol, 8), 5.10).

%descuento(Producto, Descuento) -> Estan en el punto 1


%compro(Cliente,Producto,Cantidad)
compro(juan,lacteo(laSerenisima,crema),2).
compro(juan,lacteo(gandara,queso(mozzarella)), 1).


% 1) Agregar descuentos

descuento(lacteo(laSerenisima,leche), 0.20).
descuento(lacteo(laSerenisima,crema), 0.70).
descuento(lacteo(gandara,queso(gouda)), 0.70).
descuento(lacteo(vacalin,queso(mozzarella)), 0.05).
descuento(arroz(_), 1.50).
descuento(salchichas(Marca, _), 0.50) :-
    Marca \= vienisima.
descuento(lacteo(Marca, leche), 2) :-
    Marca \= laSerenisima.
descuento(lacteo(Marca, queso(_)), 2) :-
    primeraMarca(Marca).
descuento(Producto, Descuento) :-
    productoConMayorPrecio(Producto, Precio),
    Descuento is Precio * 0.5.

productoConMayorPrecio(Producto, Precio) :-
    precioUnitario(Producto, Precio),
    forall(precioUnitario(_, OtroPrecio), Precio >= OtroPrecio).


% 2) Es comprador compulsivo

esCompradorCompulsivo(Cliente) :-
    compro(Cliente, _, _),
    forall(esDePrimeraMarcaYTieneDescuento(Producto), compro(Cliente, Producto, _)).

esDePrimeraMarcaYTieneDescuento(Producto) :-
    primeraMarca(Producto),
    descuento(Producto, _).


% 3) Total a pagar

totalAPagar(Cliente, TotalAPagar) :-
    compro(Cliente, _, _),
    findall(Precio, calcularPrecioFinal(Cliente, _, Precio), Precios),
    sum_list(Precios, TotalAPagar).

calcularPrecio(Producto, Precio) :-
    descuento(Producto, Descuento),
    precioUnitario(Producto, PrecioUnitario),
    Precio is PrecioUnitario - Descuento.
calcularPrecio(Producto, Precio) :-
    not(descuento(Producto, _)),
    precioUnitario(Producto, Precio). 

calcularPrecioFinal(Cliente, Producto, PrecioFinal) :-
    compro(Cliente, Producto, Cantidad),
    calcularPrecio(Producto, Precio),
    PrecioFinal is Precio * Cantidad.


% 4) Cliente fiel           % FALTA TERMINAR

clienteFiel(Cliente, Marca) :-
    compro(Cliente, Producto, _),
    loVende(Marca, Producto).

loVende(Marca, Producto) :-
    precioUnitario(Producto, _),
    queMarcaEs(Producto, Marca).

queMarcaEs(arroz(Marca), Marca).
queMarcaEs(lacteo(Marca, _), Marca).
queMarcaEs(salchicha(Marca, _), Marca).


% 5) Provee

%Se agrega el predicado dueño que relaciona dos marcas siendo que la primera es dueña de la otra.
duenio(laSerenisima, gandara).
duenio(gandara, vacalin).

provee(Empresa, Productos) :-
    findall(Producto, loVendeLaEmpresaOSuFilial(Empresa, Producto), Productos).

loVendeLaEmpresaOSuFilial(Empresa, Producto) :-
    loVende(Empresa, Producto).
loVendeLaEmpresaOSuFilial(Empresa, Producto) :-
    tieneACargo(Empresa, Filial),
    loVende(Filial, Producto).

tieneACargo(Empresa, Filial) :-
    duenio(Empresa, Filial).
tieneACargo(Empresa, Filial) :-
    duenio(Empresa, OtraEmpresa),
    duenio(OtraEmpresa, Filial).












