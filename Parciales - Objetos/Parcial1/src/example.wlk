/*--------------------------- USUARIOS --------------------------- */

const costoCombustible = 40

const usuario1 = new Usuario(nombre = "Franco", dni = 1234, dinero = 100, vehiculo = camioneta1)

class Usuario {
	const property nombre
	const property dni
	var property dinero
	var property vehiculo
	var property multas = []
	
	method recorrerDistancia(distancia) {
		vehiculo.distanciaRecorrida(distancia)	
	}
	
	method recargarCombustible(litros) {
		
		if(dinero >= vehiculo.costoCarga(litros)) {     //si el usuario cuenta con suficiente dinero
			dinero -= vehiculo.costoCarga(litros)		//se le descuenta el dinero que cuesta la carga (
			vehiculo.modificarCombustible(litros)
		}
		else {
			throw new DomainException(message = "El usuario no cuenta con el suficiente dinero para realizar la carga")
		}	
	}
	
	method pagarMultas() {
		multas.forEach{multa => self.pagarMulta(multa)}
		
	}
	
	method pagarMulta(multa) {
		if(multa.puedeSerPagada(self)) {
			multa.estaPagada()
		}
		else {
			multa.noSePudoPagar()
		}
		
	}
	
	method estaComplicado() {
		const multasSinPagar = multas.filter{multa => !multa.estaPagada()}
		const costoMultasSinPagar = multasSinPagar.sum{multa => multa.costo()}
		
		return costoMultasSinPagar > 5000
	}
}

class Multa {
	
	const intereses = 1.1
	var property costo
	var property pagada = false
	
	method estaPagada() { pagada = true }
	
	method puedeSerPagada(usuario) = usuario.dinero() >= costo
	
	method noSePudoPagar() {
		costo *= intereses
	}
}



/*--------------------------- VEHICULOS --------------------------- */

class Vehiculo {
	const property capacidad
	var property combustible
	const property velocidadPromedio
	var property distanciaRecorrida = 0
	
	method perdidaBase(distancia) = 2
	
	method esEcologico()
	
	method distanciaRecorrida(distancia) {
		distanciaRecorrida += distancia
		//combustible -= self.perdidaBase(distancia)
		self.modificarCombustible(-self.perdidaBase(distancia))
	} 
	
	method costoCarga(combustibleACargar) = (capacidad - combustibleACargar) * costoCombustible  //esa resta es la carga neta que se va a hacer, porque si ya tiene combustible cargado y la carga sobrepasa la capacidad del tanque, no se le va a cobrar todo
	
	method modificarCombustible(cantidad) {combustible = capacidad.min(combustible += cantidad)} 	//esto es para que no pueda cargar mas de lo permitido
}

class Camioneta inherits Vehiculo {
	
	override method esEcologico() = false
	
	override method perdidaBase(distancia) = 4 + 5 * distancia
	
}

const camioneta1 = new Camioneta(capacidad = 120, combustible = 24, velocidadPromedio = 60)

class Deportivo inherits Vehiculo {
	
	override method esEcologico() = velocidadPromedio < 120
	
	override method perdidaBase(distancia) = 0.2 * velocidadPromedio
	
}

class Familiar inherits Vehiculo {
	
	override method esEcologico() = true
	
	override method perdidaBase(distancia) = 0
	
}



/* --------------------------- ZONAS --------------------------- */

class Zona {
	const property velocidadMax
	var property usuarios = []
	var property controles = []
	
	method activarControles() {
		
		controles.forEach{control => control.aplicarMulta(usuarios, self)}
	}
	
	method cantidadDeUsuarios() = usuarios.size()
}


class Control {
	
	method aplicarMulta(usuarios, zona)
}


object controlVelocidad inherits Control {
	
	override method aplicarMulta(usuarios, zona){
		const usuariosVeloces = usuarios.filter{usuario => usuario.vehiculo().velocidadPromedio() > zona.velocidaMax()}
	
		usuariosVeloces.forEach{usuario => usuario.multas().add(new Multa(costo = 3000))}
	}
}

object controlEcologico inherits Control {
	
	override method aplicarMulta(usuarios, zona){
		const usuariosNoEcologicos = usuarios.filter{usuario => !usuario.vehiculo().esEcologico()}
	
		usuariosNoEcologicos.forEach{usuario => usuario.multas().add(new Multa(costo = 1500))}
	}
	
}

object controlRegulatorio inherits Control {
	
	override method aplicarMulta(usuarios, zona) {
		const dia = new Date().day()
		const usuariosPares = usuarios.filter{usuario => usuario.dni().even()}
		const usuariosImpares = usuarios.filter{usuario => usuario.dni().odd()}
		
		
		if(dia.even()) {
			
			usuariosImpares.forEach{usuario => usuario.multas().add(new Multa(costo = 2000)) }
		}
		else {
			usuariosPares.forEach{usuario => usuario.multas().add(new Multa(costo = 2000)) }
		}
	}
}


/* --------------------------- APLICACION --------------------------- */		

object aplicacion {
	
	var property usuarios = []
	var property zonas = []
	
	method pagarMultas() {
		usuarios.forEach{usuario => usuario.pagarMultas()}
	}
	
	method zonaMasTransitada() {
		return zonas.max{zona => zona.cantidadDeUsuarios()}
	}
	
	method usuariosComplicados() {
		usuarios.filter{usuario => usuario.estaComplicado()}
		
	}
}



