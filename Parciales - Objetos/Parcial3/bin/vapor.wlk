// 3. PARCIAL OBJETOS - VAPOR


/*----------------------------- LOGROS ----------------------------- */

class Logro {
	const property juego
	var property jugador
	
	method gemas()
	
	method esImportante() = self.gemas() > 500
	
	 
}

class Avance inherits Logro {

	override method gemas() = juego.dificultad() * jugador.horasJugadas()

	override method esImportante() = false
}

class SecretoDesbloqueado inherits Logro {
	var property gemas
	
}

class ExperienciaAlcanzada inherits Logro {
	
	override method gemas() = juego.dificultad() + jugador.experienciaGamer() / 10

}

class Genio inherits ExperienciaAlcanzada {
	
	override method gemas() = super() * 2 + jugador.cantidadDeLogros()
}


/*-----------------------------  JUEGO ----------------------------- */

class Juego {
	var property dificultad
	var property sangre
	var property precio
	//var property comprado = false
	var property estilo					//un juego puede cambiar de estilo -> debemos usar composicion porque de clase no se puede cambiar
		
	//method fueComprado() { comprado = true }
	
	method esRosita() = sangre < 1 || dificultad <= 2
	
	method otorgarLogro(jugador, horas) {
		if(jugador.experienciaGamer() % 100 == 0) {
			const logroNuevo = new ExperienciaAlcanzada(juego = self, jugador = jugador)
			jugador.logros().add(logroNuevo)
		}
		estilo.otorgarLogrosExtras(jugador, horas, self)  //segun el estilo de juego otorgaremos logros extras
	}
	
	method instalarExpansion() {
		dificultad += 1
		if(self.esDeAventura()) {
			estilo = pelea
		}
	}
	
	method esDeAventura() = estilo == aventura
}

/*----------------------------- JUGADOR ----------------------------- */

class Jugador {
	var property gemas
	var property billetera
	var property logros = []
	var property horasJugadas
	var property juegos = []
	
	method cantidadDeLogros() = logros.size()
	
	method tieneJuego(juego) = juegos.contains(juego)
	
	method experienciaGamer() = horasJugadas * 25
	
	method calcularGemas() {gemas = logros.sum{logro => logro.gemas()}}
	
	method puedeComprar(juego) = juego.precio() <= (billetera + gemas) && !self.tieneJuego(juego)
	
	method comprar(juego) {							
		if(self.puedeComprar(juego)) {
			if(juego.precio() < billetera)
			{
				self.transformarLogros()
			}
			billetera -= juego.precio()
			juegos.add(juego)
		}
		else {
			throw new DomainException (message = "Fondos insuficientes para comprar el juego")
		}
	}
	
	method transformarLogros() {
		self.calcularGemas()			//calcula cuantas gemas tiene. esto va a cambiar el estado interno
		billetera += gemas 				//suma las gemas al dinero que ya tenia
		gemas = 0
	}
	
	method jugar(juego, horas) {
		horasJugadas += horas
		juego.otorgarLogro(self, horas)		
	}
	
	method juegosLogrosImportantes() = logros.filter{logro => logro.esImportante()}.map{logro => logro.juego()}.filter{juego => !juego.esRosita()}
}


/*----------------------------- ESTILOS DE JUEGOS ----------------------------- */

object aventura {
	method otorgarLogrosExtras(jugador, horas, juego) {
		const logroNuevo = new SecretoDesbloqueado(gemas = 1/jugador.experienciaGamer(), juego = juego, jugador = jugador)
		jugador.logros().add(logroNuevo)
	}
}

object pelea {
	method otorgarLogrosExtras(jugador, horas, juego) {
		const logroNuevo = new Avance(juego = juego, jugador = jugador)
		jugador.logros().add(logroNuevo)
		
		if(horas * juego.sangre() > 10) {
			const logroNuevo2 = new SecretoDesbloqueado(gemas = jugador.horasJugadas() / 10, juego = juego, jugador = jugador)
			jugador.logros().add(logroNuevo2)
		}
	}	
}

object logica {
	method otorgarLogrosExtras(jugador, horas, juego) {
		if(horas * juego.dificultad() > 17) {
			const logroNuevo = new Genio(juego = juego, jugador = jugador)
			jugador.logros().add(logroNuevo)
		}
	}
}

object fps {
	method otorgarLogrosExtras(jugador, horas) {
		
	}
}


/*----------------------------- Punto 7 ----------------------------- */

const cacho = new Jugador(billetera = 100, gemas = 0, horasJugadas = 8)

const tetris = new Juego(dificultad = 5, precio = 10, estilo = logica, sangre = 1)

	
	


