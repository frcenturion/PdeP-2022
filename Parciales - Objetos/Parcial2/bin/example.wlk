/*-------------------- PRODUCTOS -------------------- */

class Producto {
	
	const property nombre
	const property precioBase
	
	method precio() = precioBase * 1.21
	
	method obtenerNombreDeOferta() 
	
	
}

class Mueble inherits Producto {
	
	override method precio() = super() + 1000
	
	override method obtenerNombreDeOferta() = "SUPER OFERTA" + nombre
}

class Indumentaria inherits Producto {
	
	override method obtenerNombreDeOferta() = "SUPER OFERTA" + nombre
}

class Ganga inherits Producto {
	
	override method precio() = 0
	
	override method obtenerNombreDeOferta() = nombre + "COMPRAME POR FAVOR"
	
}

/* -------------------- CUPONES -------------------- */

class Cupon {
	const property porcentajeDescuento
	var property usado = false
	
	method estaUsado() { usado = true }
		
}


/* -------------------- USUARIOS -------------------- */

class Usuario {
	const property nombre
	var property dinero
	var property puntos = 0
	var property nivel = bronce
	var property carrito = []
	var property cupones = []
	
	
	method agregarProducto(producto) {
		if(!self.estaAlLimite()) {
			carrito.add(producto)
		}
		else {
			self.error("No se puede comprar porque ya tiene el carrito lleno")
		}	
	}
	
	method estaAlLimite() = carrito.size() == nivel.maximoProductos()

	method comprarCarrito() {
		const cuponesNoUsados = cupones.filter{cupon => !cupon.estaUsado()}  
		
		const precioFinal = self.precioTotalConCupon(cuponesNoUsados.anyOne())
		
		self.disminuirDinero(precioFinal)
		
		self.sumarPuntos(precioFinal * 1.10)	
	}
	
	method precioTotal() = carrito.sum{producto => producto.precio()}
	
	method disminuirDinero(valor) { dinero -= valor }
	
	method sumarPuntos(valor) { puntos += valor }
	
	method precioTotalConCupon(cupon) = self.precioTotal() *- cupon.porcentajeDescuento()
	
	method esMoroso() = self.dinero() < 0
	
	method eliminarCuponUsado() {
		cupones.removeAllSuchThat{cupon => cupon.estaUsado()}  
	}
	
	method actualizarNivel() {
		if(puntos >= 5000) {
			nivel = plata
		}
		if(puntos >= 15000) {
			nivel = oro
		}
	}	
	
	/*method actualizarNivel2() {
		if(puntos >= nivel.puntosNecesarios()) {
			nivel = 
		}
	}*/
}



class Nivel {
	method puntosNecesarios() = 0
}

object bronce inherits Nivel {
	
	method maximoProductos() = 1
}

object plata inherits Nivel {
	
	override method puntosNecesarios() = 5000
	
	method maximoProductos() = 5
}

object oro inherits Nivel {
	
	override method puntosNecesarios() = 15000
	
	method maximoProductos() = 999999999999999999 //maximo simbolico
}


/* -------------------- PdePLibre -------------------- */

object aplicacion {
	var property usuarios = []
	var property productos = []
	
	method reducirPuntos() {
		const usuariosMorosos = usuarios.filter{usuario => usuario.esMoroso()}
		usuariosMorosos.forEach{usuario => usuario.sumarPuntos(-1000)}
	}
	
	method eliminarCupoUsado() {
		usuarios.forEach{usuario => usuario.eliminarCuponUsado()}
	}
	
	method obtenerNombresDeOferta() {
		productos.forEach{producto => producto.obtenerNombreDeOferta()}
	}
	
	method actualizarNiveles() {
		usuarios.forEach{usuario => usuario.actualizarNivel()}
	}
}



/* REVISAR:
 			1. COMPRAR CARRITO
 			2. NIVELES -> VER SI DEJAR LOS METODOS O USAR ATRIBUTOS
 			3. VER LO DE ACTUALIZAR NIVEL
 */






