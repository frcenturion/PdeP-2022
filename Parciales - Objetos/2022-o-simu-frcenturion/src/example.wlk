class Personaje {
	
	var property copas
	
	method destreza()
	method tieneEstrategia()
	
	method ganarCopas(numero) {copas += numero}
	
}

class Arquero inherits Personaje {
	
	var agilidad
	var rango
	
	override method destreza() = agilidad * rango
	override method tieneEstrategia() = rango > 100 
}

class Guerrera inherits Personaje {
	
	var fuerza
	var estrategia
	
	override method tieneEstrategia() = estrategia
	
	override method destreza() = fuerza * 1.5
	
	
}

class Ballestero inherits Arquero {
	
	override method destreza() = 2 * super()	
}


class Mision {
	
	var property copasEnJuego
	const dificultad
	
	method puedeSerSuperada()
	method puedeRealizarla()
	method ganar()
	method perder()
	method realizarMision() {
		if(!self.puedeRealizarla()) {
			throw new DomainException(message = "Mision no puede comenzar")
		}
		else {
			if(self.puedeSerSuperada()) {
				self.ganar()
			}
			else {
				self.perder()
			} 
		}		
	}
}
	


class MisionIndividual inherits Mision {
	
	var personaje
	var tipo
	
	override method copasEnJuego() = 2 * dificultad 
	
	override method puedeSerSuperada() = personaje.tieneEstrategia() || personaje.destreza() > dificultad
	
	override method puedeRealizarla() = personaje.copas() < 10
	
	override method ganar() = personaje.ganarCopas(self.copasEnJuego())
	
	override method perder() = personaje.ganarCopas(-self.copasEnJuego())
}


class MisionPorEquipo inherits Mision {
	
	var property participantes = []
	const cantidadParticipantes = participantes.size()
	var tipo
	
	override method copasEnJuego() = 50 / cantidadParticipantes
	
	override method puedeSerSuperada() = participantes.all{participante => participante.destreza() > 400} || 
													participantes.count{participante => participante.tieneEstrategia()} > cantidadParticipantes/2
													
	override method puedeRealizarla() = participantes.sum{participante => participante.copas()} < 60
	
	override method ganar() = participantes.forEach{participante => participante.ganarCopas(self.copasEnJuego())}
	
	override method perder() = participantes.forEach{participante => participante.ganarCopas(-self.copasEnJuego())}
	
}


class Bonus {
	override method copasEnJuego() = cantidadDeParticipantes + super() 
	
} 

class Boost inherits Mision {
	var multiplicador
	
	override method copasEnJuego() = multiplicador * super()
}

