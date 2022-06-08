module Library where
import PdePreludat

type Rareza = Number
type Artefacto = (String, Rareza)
type Tarea = Heroe -> Heroe

-- 1) Modelado de héroes

data Heroe = Heroe {
    epiteto :: String,
    reconocimiento :: Number,
    artefactos :: [Artefacto],
    listaTareas :: [Tarea]
} deriving (Show, Eq)

lanzaDelOlimpo = ("Lanza del Olimpo", 100)
xiphos = ("Xiphos", 50)
relampagoDeZeus = ("El relampago de Zeus", 500)

-- 2) Función pasaALaHistoria

type Reconocimiento = Number

pasaALaHistoria :: Heroe -> Reconocimiento -> Heroe
pasaALaHistoria heroe reconocimiento
    |reconocimiento > 1000 = heroe {epiteto = "El mitico"}
    |reconocimiento <= 500 = heroe {epiteto = "El magnifico"}
    |reconocimiento > 100 && reconocimiento < 500 = heroe {epiteto = "Hoplita"}
    |otherwise = heroe

-- Version alternativa

pasaALaHistoria2 :: Heroe -> Reconocimiento -> Heroe
pasaALaHistoria2 heroe reconocimiento
    |reconocimiento > 1000 = modificarEpiteto heroe "El mitico"
    |reconocimiento <= 500 = modificarEpiteto heroe "El magnifico"
    |reconocimiento > 100 && reconocimiento < 500 = modificarEpiteto heroe "Hoplita"
    |otherwise = heroe

modificarEpiteto :: Heroe -> String -> Heroe
modificarEpiteto heroe epitetoNuevo = heroe {epiteto = epitetoNuevo}

-- 3) Modelado de tareas

-- Tarea "Encontrar artefacto"
encontrarArtefacto :: Artefacto -> Tarea
encontrarArtefacto artefacto heroe = heroe {reconocimiento = reconocimiento heroe + rarezaArtefacto artefacto, artefactos = artefacto : artefactos heroe}

rarezaArtefacto :: Artefacto -> Rareza
rarezaArtefacto artefacto = snd artefacto

nombreArtefacto :: Artefacto -> String
nombreArtefacto artefacto = fst artefacto

-- Version alternativa

encontrarArtefacto2 :: Artefacto -> Tarea
encontrarArtefacto2 artefacto heroe = (modificarReconocimiento (rarezaArtefacto artefacto) . agregarArtefacto artefacto) heroe

modificarReconocimiento :: Number -> Heroe -> Heroe
modificarReconocimiento delta heroe = heroe {reconocimiento = reconocimiento heroe + delta}

agregarArtefacto :: Artefacto -> Heroe -> Heroe
agregarArtefacto artefacto heroe = heroe {artefactos = artefacto : artefactos heroe}


-- Tarea "Escalar el Olimpo"
escalarElOlimpo :: Tarea
escalarElOlimpo heroe = heroe {reconocimiento = reconocimiento heroe + 500, artefactos =  relampagoDeZeus : (desecharArtefactos . triplicarRarezaDeArtefactos) (artefactos heroe)}

triplicarRarezaDeUnArtefacto :: Artefacto -> Artefacto
triplicarRarezaDeUnArtefacto (nombre, rareza) = (nombre, rareza * 3)

triplicarRarezaDeArtefactos :: [Artefacto] -> [Artefacto]
triplicarRarezaDeArtefactos artefactos = map triplicarRarezaDeUnArtefacto artefactos

desecharArtefactos :: [Artefacto] -> [Artefacto]
desecharArtefactos artefactos = filter (rarezaEsMayorA1000 . rarezaArtefacto) artefactos

rarezaEsMayorA1000 :: Number -> Bool
rarezaEsMayorA1000 rareza = rareza > 1000

-- Version alternativa

escalarElOlimpo2 :: Tarea
escalarElOlimpo2 heroe = (modificarReconocimiento 500 . agregarArtefacto relampagoDeZeus . modificarArtefactos) heroe

modificarArtefactos :: Heroe -> Heroe
modificarArtefactos heroe = heroe {artefactos = (desecharArtefactos . triplicarRarezaDeArtefactos) (artefactos heroe)}


-- Tarea "Ayudar a cruzar la calle"
type Cuadras = Number

ayudarACruzarLaCalle :: Cuadras -> Tarea
ayudarACruzarLaCalle cuadras heroe = heroe {epiteto = "Gros" ++ take cuadras listaDeOInfinitas} 

listaDeOInfinitas = repeat 'o'

-- Tarea "Matar una bestia"
type Debilidad = Heroe -> Bool

data Bestia = Bestia {
    nombre :: String,
    debilidad :: Debilidad
} deriving (Show, Eq)

matarUnaBestia :: Bestia -> Tarea
matarUnaBestia bestia heroe
    |(debilidad bestia) heroe = heroe {epiteto = "El asesino de" ++ nombre bestia}
    |otherwise = heroe {artefactos = drop 1 (artefactos heroe), epiteto = "El cobarde"}


-- 4) Modelar a Heracles

pistola = ("Pistola", 1000)

heracles = Heroe "Guardian del Olimpo" 700 [pistola, relampagoDeZeus] [matarAlLeonDeNemea] 

-- 5) Modelar la tarea "matar al Leon de Nemea"

debilidadLeon :: Debilidad
debilidadLeon heroe = length (epiteto heroe) >= 20 

leonDeNemea = Bestia "Leon de Nemea" debilidadLeon

matarAlLeonDeNemea :: Tarea
matarAlLeonDeNemea heroe = matarUnaBestia leonDeNemea heroe

-- 6) Hacer que un héroe haga una tarea

hacerTarea :: Heroe -> Tarea -> Heroe
hacerTarea heroe tarea = agregarTareaRealizada tarea (tarea heroe)

agregarTareaRealizada :: Tarea -> Heroe -> Heroe
agregarTareaRealizada tarea heroe = heroe {listaTareas = tarea : (listaTareas heroe)} 

-- 7) Presumir logros

type Ganador = Heroe

type Perdedor = Heroe

type Podio = (Ganador, Perdedor)

presumirLogros :: Heroe -> Heroe -> Podio
presumirLogros heroe1 heroe2 
    |reconocimiento heroe1 > reconocimiento heroe2 = (heroe1, heroe2)
    |reconocimiento heroe1 == reconocimiento heroe2 && sumatoriaRarezasArtefactos heroe1 > sumatoriaRarezasArtefactos heroe2 = (heroe1, heroe2)
    |otherwise = presumirLogros (realizarTareasDelOtro heroe1 heroe2) (realizarTareasDelOtro heroe2 heroe1) 

sumatoriaRarezasArtefactos :: Heroe -> Number
sumatoriaRarezasArtefactos heroe =  (sum . (map rarezaArtefacto) . artefactos) heroe

realizarTareasDelOtro :: Heroe -> Heroe -> Heroe
realizarTareasDelOtro heroe1 heroe2 = realizarLabor (listaTareas heroe2) heroe1 


-- 8) ¿Cuál es el resultado de hacer que presuman dos héroes con reconocimiento 100, ningún artefacto y ninguna tarea realizada?

heroe1 = Heroe "heroe1" 100 [] []
heroe2 = Heroe "heroe2" 100 [] []

{-
    Cuando se presumen el héroe 1 y el héroe 2, como los dos héroes son iguales, entonces la funcion presumirLogros nunca logrará determinar 
    quien es el ganador y quién es el perdedor, pues se quedará evaluando infinitamente y nunca se llegará a cumplir
    ninguno de los casos bases de la recursividad
-}


-- 9) Realizar una labor

type Labor = [Tarea]

labor1 = [escalarElOlimpo, encontrarArtefacto pistola]

realizarLabor :: Labor -> Heroe -> Heroe
realizarLabor labor heroe = foldl hacerTarea heroe labor


-- 10) Si invocamos la función anterior con una labor infinita, ¿se podrá conocer el estado final del héroe? ¿Por qué

laborInfinita = repeat escalarElOlimpo

{-
    Si invocamos la función realizarLabor con una labor infinita, no se podrá conocer el estado final del héroe, ya que como
    tenemos infinitas tareas, Haskell se quedará haciendo el foldl se quedará aplicando los elementos de la lista al valor
    resultante y nunca terminará de evaluar ya que siempre tiene otro elemento que aplicarle
-}









