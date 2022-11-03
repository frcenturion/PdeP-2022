// 4. PARCIAL OBJETOS - FIESTA DE DISFRACES


/*---------------------------------- FIESTAS ---------------------------------- */

const disfraz1 = new Disfraz(fechaConfeccion = 2, nombre = "falopa", caracteristicas = [sexy])
const franco = new Persona(disfraz = disfraz1, edad = 18, personalidad = taciturna)
const pepe = new Persona(disfraz = disfraz1, edad = 20, personalidad = alegre)
const fiesta1 = new Fiesta(lugar = "argentina", fecha = 1, invitados = [franco, pepe])

class Fiesta {
	const property lugar
	const property fecha
	var property invitados = #{}
	
	
	method esUnBodrio() = invitados.all{invitado => !invitado.estaConformeConSuDisfraz()}
	
	method mejorDisfraz() = invitados.map{invitado => invitado.disfraz()}//.find{disfraz1, disfraz2 => disfraz1.puntuacion() > disfraz2.puntuacion()}
	
	method agregarAsistente(persona) {
		if(persona.tieneDisfraz() && !invitados.contains(persona)) {
			invitados.add(persona)
		}
		else {
			throw new DomainException(message = "La persona ya esta invitada a la fiesta")
		}
	}
	
	method esInolvidable() = invitados.all{invitado => invitado.esSexyYEstaConforme()}
	
	method puedenIntercambiar(persona1, persona2) = self.estanEnLaFiesta(persona1, persona2) 
													&& self.algunoEstaDisconforme(persona1, persona2)
													&& self.pasanAEstarConformes(persona1, persona2)
	
	method estanEnLaFiesta(persona1, persona2) = invitados.contains(persona1) && invitados.contains(persona2)
	
	method algunoEstaDisconforme(persona1, persona2) = !persona1.estaConformeConSuDisfraz() || !persona2.estaConformeConSuDisfraz()
	
	method pasanAEstarConformes(persona1, persona2) {
		persona1.disfraz(persona2.disfraz())
		persona2.disfraz(persona1.disfraz())
		
		return persona1.estaConformeConSuDisfraz() || persona2.estaConformeConSuDisfraz()
	}
}


/*---------------------------------- DISFRACES ---------------------------------- */

class Disfraz {
	var property nombre
	var property fechaConfeccion
	var property caracteristicas = []
	
	method puntuacion(persona, fiesta) = caracteristicas.sum{caracteristica => caracteristica.puntuacion(persona, fiesta)}
	
	method nombrePar() = nombre.size().even()
	
	method estaHechoHaceMenosDe30Dias(fiesta) = fechaConfeccion - fiesta.fecha() < 30
}


class Gracioso {
	var property gracia
	
	method nivelValido(unNivelDeGracia) = unNivelDeGracia > 0 && unNivelDeGracia < 10
	
	method gracia(unNivelDeGracia) {
		if(self.nivelValido(unNivelDeGracia)) {
			gracia = unNivelDeGracia
		}
		else {
			throw new DomainException(message = "El nivel de gracia no está entre 1 y 10")
		}
	}
	
	method puntuacion(persona, fiesta) {
		if(persona.edad() > 50) {
			
			return gracia * 3
		}
		else {
			return gracia
		}
	}
	
	
	 	
}

class Tobara {
	var property diaDeAdquisicion
	
	method puntuacion(persona, fiesta) {
		if((fiesta.fecha() - diaDeAdquisicion).abs() >= 2) {
			return 5
		}
		else {
			return 3
		}
	}	
}

class Careta {
	var property personajeQueSimula																		
	
	method puntuacion(fiesta, persona) = personajeQueSimula.valor() 	
}

object sexy {
	
	method puntuacion(fiesta, persona) {
		if(persona.esSexy()) return 15 else return 2
	}
	
}


/*---------------------------------- PERSONAS ---------------------------------- */

class Persona {
	var property disfraz					//puede cambiar de disfraz
	var property personalidad
	var property edad
	
	method esSexy() = personalidad.esSexy(self)
	
	method estaConformeConSuDisfraz(fiesta) = disfraz.puntuacion() > 10
	
	method tieneDisfraz() = disfraz != 0
	
	method esSexyYEstaConforme(fiesta) = self.esSexy() && self.estaConformeConSuDisfraz(fiesta)
	
}

class Caprichoso inherits Persona {
	
	override method estaConformeConSuDisfraz(fiesta) = super(fiesta) && disfraz.nombrePar()
}

class Pretensioso inherits Persona {
	
	override method estaConformeConSuDisfraz(fiesta) = super(fiesta) && disfraz.estaHechoHaceMenosDe30Dias()	
}

class Numerologo inherits Persona {
	var property puntaje
	
	override method estaConformeConSuDisfraz(fiesta) = super(fiesta) && disfraz.puntuacion(self, fiesta) == puntaje
	
}



/*---------------------------------- PERSONALIDADES ---------------------------------- */

object alegre {
	
	method esSexy(persona) = false
}

object taciturna {
	
	method esSexy(persona) = persona.edad() < 30
}


