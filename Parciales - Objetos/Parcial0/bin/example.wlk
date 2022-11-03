//-----------------------------------------------------------------------------------------------------------------------------------------
// CONTENIDOS
//------------------------------------------------------------------------------------------------------------------------------------------
class Contenido {
	const property titulo
	var property vistas = 0
	var property ofensivo = false
	var property monetizacion //vamos a modelar los tipos de monetizacion con composición porque un contenido puede cambiar su forma de monetizarse
	
	method monetizacion(nuevaMonetizacion) {
		if(!nuevaMonetizacion.puedeAplicarseA(self))
			throw new DomainException(message = "Este contenido no soporta la forma de monetización")
		
		monetizacion = nuevaMonetizacion
	} //este no es el único caso donde debo hacer la comprobación, ya que también puedo mandarle una monetización a un contenido en el momento en que lo instancio
	
	override method initialize() { //este es un mensaje donde el objeto tiene una oportunidad de validar que sus características están bien
		if(!monetizacion.puedeAplicarseA(self))
			throw new DomainException(message = "Este contenido no soporta la forma de monetización")
		
	}
	
	//se puede hacer un método para no repetir la lógica de la validación
	
	/*method validarMonetizacion(nuevaMonetizacion) {		 
		if(!nuevaMonetizacion.puedeAplicarseA(self))
			throw new DomainException(message = "Este contenido no soporta la forma de monetización")*/  
	
	
	method recaudacion() = monetizacion.recaudacionDe(self)
	method esPopular()
	method recaudacionMaximaParaPublicidad()
	method puedeVenderse() = self.esPopular()
	method puedeAlquilarse()
}

class Video inherits Contenido {
	override method esPopular() = vistas > 10000
	override method recaudacionMaximaParaPublicidad() = 10000
	override method puedeAlquilarse() = true
}

const tagsDeModa = []

class Imagen inherits Contenido {
	const property tags = []
	
	override method esPopular() = tagsDeModa.all{ tag => tags.contains(tag) } //para cada uno de los tags de moda, mis tags lo incluyen
	override method recaudacionMaximaParaPublicidad() = 4000 
	override method puedeAlquilarse() = false
	
}

//-----------------------------------------------------------------------------------------------------------------------------------------
// MONETIZACIONES
//------------------------------------------------------------------------------------------------------------------------------------------

object publicidad { 						//es un objeto porque en donacion y descarga vamos a tener que manipular un estado interno, aca no
	method recaudacionDe(contenido) = (
		0.05 * contenido.vistas() +
		if(contenido.esPopular()) 2000 else 0
	).min(contenido.recaudacionMaximaParaPublicidad())
	
	method puedeAplicarseA(contenido) = !contenido.ofensivo()
}

class Donacion {
	var property donaciones = 0
	
	method recaudacionDe(contenido) = donaciones
	
	method puedeAplicarseA(contenido) = true
}

class Descarga {
	const property precio 
	
	//aca si queremos hacer una validación solo debemos preocuparnos por el initialize, ya que precio no tiene setter por ser const
	
	method initialize() {
		if(precio < 5) throw new DomainException(message = "Esto es muy barato")
	}
	
	
	
	method recaudacionDe(contenido) = contenido.vistas()
	
	//method puedeAplicarseA(contenido) = contenido.esPopular()
	method puedeAplicarseA(contenido) = contenido.puedeVenderse()
}

class Alquiler inherits Descarga {
	override method precio() = 1.max(super()) //el precio es el maximo entre 1 y el valor del precio
	
	//otra forma de hacerlo es validar el precio cuando se construye, con un initialize
	
	override method puedeAplicarseA(contenido) = super(contenido) && contenido.puedeAlquilarse()
	
}


//-----------------------------------------------------------------------------------------------------------------------------------------
// USUARIOS
//------------------------------------------------------------------------------------------------------------------------------------------

class Usuario {
	const property nombre
	const property email
	var property verificado = false
	const contenidos = []
	
	//method saldoTotal() = contenidos.map{contenido => contenido.recaudacion()}.sum()
	
	method saldoTotal() = contenidos.sum{contenido => contenido.recaudacion()}
	
	method esSuperUsuario() = contenidos.count{contenido => contenido.esPopular()} >= 10
	
	/*method publicar(contenido, monetizacion) {
		if(!monetizacion.puedeAplicarseA(contenido))
			throw new DomainException(message = "El contenido no soporta la forma de monetizacion")
	
		contenido.monetizacion(monetizacion)
		contenidos.add(contenido)*/
	
	/* El método de arriba está mal porque el contenido ya tiene asociada un tipo de monetización, entonces debe ser
	el contenido el encargado de mantener un estado interno consistente.
	En vez de hacer esto, vamos a validar la monetización en el setter de la clase Contenido*/
	
	method publicar(contenido) {
		contenidos.add(contenido)
	}
}

object usuarios {
	const todosLosUsuarios = []
	
	method emailsDeUsuariosRicos() = todosLosUsuarios
	.filter{usuario => usuario.verificado()}
	.sortedBy{uno, otro => uno.saldoTotal() > otro.saldoTotal()}
	.take(100)
	.map{usuario => usuario.email()}
	
	method cantidadDeSuperUsuarios() = todosLosUsuarios.count{usuario => usuario.esSuperUsuario()}
}

// 5)

/* 
 	a. Qué tan difícil es agregar: 
 	
 	
 	i. Nuevo tipo de contenido: 
 	
	 	Agregar un nuevo tipo de contenido es extremadamente fácil. Si agregáramos un contenido que no se
	 	parezca nada a los que ya existen (imágenes y videos), entonces debemos extender nuestra clase abstracta Contenido.
	 	Si aparece un caso particular de imagen o video, puedo extender a partir de ellos. 
	 	Además, tengo definidos algunos métodos abstractos, que me van a ayudar de manera mecánica.
 	
 	
 	ii. Permitir cambiar el tipo de un contenido:
 		
 		Como modelamos los tipos de contenidos con herencia, esto resulta complejo, ya que un objeto que nace como video
 		no puede nunca conevrtirse en una imagen.
 		Si queremos que un contenido pueda cambiar de un tipo a otro vamos a tener que cambiar el modelo. Tendríamos que modelarlo
 		con una composición, identificando un atributo "tipo" que haga referencia al tipo de contenido.
 		Esta solución resulta ser más compleja ya que debo hacer interactuar más objetos para representar un contenido: contenido,
 		monetización y tipo.
 	
 	
 	iii. Agregar un nuevo estado “verificación fallida” a los usuarios, que no les permita cargar ningún nuevo contenido:
 		
 		Podría ser tentador agregar un nuevo atributo que indique si la verificación falló o no, pero esto volvería compleja la
 		solución ya que tendría que estar verificando dos atributos al mismo tiempo: el que dice si es usuario verificado o no y 
 		el que indica si la verificación falló o no. 
 		
 		Lo más razonable sería agregar esta verificación con un atributo estado al que le pueda asignar un objeto, y ese objeto
 		es el encargado de decirme si el usuario puede o no publicar contenido. 
 		
 		
 	
 	b. ¿En qué parte de tu solución se está aprovechando más el uso de polimorfismo? ¿Por qué?
 	
 	Polimorfismo es el trato indistinto de uno o más objetos por parte de un tercero.
 	En nuestra implementación, hay dos lugares claros donde el polimorfismo está aprovechándose mucho:
 	
 	1. Cálculo del saldo total de un usuario: 
	 	
	 	El usuario trata indistintamente a todos los contenidos que tiene. No le importa si lo
	 	que tiene en la lista de contenidos son videos o imágenes
 	
 	
 	2. Recaudación de un contenido: 
 	
	 	Cuando el contenido calcula su recaudación, no distingue cuál es la monetización que tiene.
	 	Las monetizaciones son polimórficas entre ellas, por ello el contenido no debe preocuparse por la monetización que tiene establecida
	 	entre sus atributos
 	
 	Cuando nos hacen este tipo de preguntas, tenemos que pensar en qué lugar la solución sufriría si no tuviéramos polimorfismo. 
*/










