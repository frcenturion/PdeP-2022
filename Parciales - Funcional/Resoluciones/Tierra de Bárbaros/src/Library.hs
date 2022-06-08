module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

-- 1) Modelado de bárbaros y objetos

data Barbaro = Barbaro {
    nombre :: String,
    fuerza :: Number,
    habilidades :: [String],
    objetos :: [Objeto]
} deriving (Show, Eq)

dave = Barbaro "Dave" 100 ["tejer", "escribirPoesia"] [ardilla]

-- Objetos

type Objeto = Barbaro -> Barbaro
type Peso = Number

-- a. Espada

espada :: Peso -> Objeto
espada peso = modificarFuerza (peso * 2)

modificarFuerza :: Number -> Barbaro -> Barbaro
modificarFuerza valor barbaro = barbaro {fuerza = fuerza barbaro + valor}


-- b. Amuletos misticos

type Habilidad = String

amuletosMisticos :: Habilidad -> Objeto
amuletosMisticos = agregarHabilidad

agregarHabilidad :: Habilidad -> Barbaro -> Barbaro
agregarHabilidad habilidad barbaro = barbaro {habilidades = habilidad : habilidades barbaro}

-- c. Varitas defectuosas 

varitasDefectuosas :: Objeto
varitasDefectuosas = desaparecerObjetos . amuletosMisticos "hacer magia"

desaparecerObjetos :: Barbaro -> Barbaro
desaparecerObjetos barbaro = barbaro {objetos = []}

-- d. Ardilla

ardilla :: Objeto
ardilla barbaro = barbaro

-- e. Cuerda

cuerda :: Objeto -> Objeto -> Objeto
cuerda objeto1 objeto2 = objeto1 . objeto2 


-- 2) Megáfono

megafono :: Objeto
megafono = concatenarHabilidades

concatenarHabilidades :: Barbaro -> Barbaro
concatenarHabilidades barbaro = barbaro {habilidades = [foldl1 (++) (habilidades barbaro)]}

-- OTRA FORMA

megafono2 :: Objeto
megafono2 barbaro = barbaro {habilidades = [concatenarHabilidades2 (habilidades barbaro)]}

concatenarHabilidades2 :: [String] -> String
concatenarHabilidades2 habilidades = foldl1 (++) habilidades


-- FALTA TERMINAR


megafonoBarbarico :: Objeto -> Objeto -> Objeto
megafonoBarbarico objeto1 objeto2 = megafono . ardilla . (cuerda objeto1 objeto2)


-- 3) Eventos y Aventuras

type Evento = Barbaro -> Bool

-- Eventos

-- a. Invasión de sucios duendes

invasionDeSuciosDuendes :: Evento
invasionDeSuciosDuendes barbaro = elem "Escribir Poesia Atroz" $ habilidades barbaro


-- b. Cremallera del tiempo

cremalleraDelTiempo :: Evento
cremalleraDelTiempo = noTienePulgares

noTienePulgares :: Barbaro -> Bool
noTienePulgares barbaro = nombre barbaro == "Faffy" || nombre barbaro == "Astro" 

-- c. Ritual de fechorias

ritualDeFechorias :: [Evento] -> Evento
ritualDeFechorias eventos barbaro = any (\evento -> evento barbaro) eventos 


-- Saqueo

saqueo :: Barbaro -> Bool
saqueo barbaro =  tieneMasdeNFuerza 80 barbaro && tieneTalHabilidad "robar" barbaro

tieneMasdeNFuerza :: Number -> Barbaro -> Bool
tieneMasdeNFuerza valor barbaro = fuerza barbaro > valor

tieneTalHabilidad :: Habilidad -> Barbaro -> Bool
tieneTalHabilidad habilidad barbaro = elem habilidad (habilidades barbaro)

-- Grito de Guerra

type Poder = Number

gritoDeGuerra :: Barbaro -> Bool
gritoDeGuerra barbaro = poderBarbaro barbaro >= cantidadLetrasHabilidades barbaro 

cantidadLetrasHabilidades :: Barbaro -> Number
cantidadLetrasHabilidades = length . habilidades . concatenarHabilidades 

cantidadObjetos :: Barbaro -> Number
cantidadObjetos barbaro = length $ objetos barbaro

poderBarbaro :: Barbaro -> Number 
poderBarbaro barbaro = 4 * cantidadObjetos barbaro

-- Caligrafía

caligrafia :: Barbaro -> Bool
caligrafia barbaro =  (>3) . length . concatMap filtrarVocales  $ (habilidades barbaro)
 
comienzaConMayuscula :: String -> Bool
comienzaConMayuscula string = elem (head string) ['A'..'Z']

filtrarVocales :: String -> String
filtrarVocales palabra = filter (\x -> elem x "aeiouáéíóú") palabra


-- Aventuras

type Aventura = [Evento]

aventura1 = [invasionDeSuciosDuendes, cremalleraDelTiempo]

sobrevivientes :: [Barbaro] -> Aventura -> [Barbaro]
sobrevivientes barbaros aventura = filter (\barbaro -> pasaUnaAventura all barbaro aventura) barbaros

pasaUnaAventura criterio barbaro aventura = criterio (\evento -> evento barbaro) aventura


-- 4) Dinastía

-- a. Eliminar repetidos de una lista

sinRepetidos :: Eq a => [a] -> [a]
sinRepetidos [] = []
sinRepetidos (x:xs) = x : sinRepetidos (filter (/= x) xs)


-- b. Descendientes

descendiente :: Barbaro -> Barbaro
descendiente =  utilizarObjetos . mapNombre (++ "*") . mapHabilidades sinRepetidos

mapNombre :: (String -> String) -> Barbaro -> Barbaro 
mapNombre unaFuncion barbaro = barbaro {nombre = unaFuncion . nombre $ barbaro}

mapHabilidades :: ([String] -> [String]) -> Barbaro -> Barbaro
mapHabilidades unaFuncion barbaro = barbaro {habilidades = unaFuncion . habilidades $ barbaro}

utilizarObjetos :: Barbaro -> Barbaro
utilizarObjetos barbaro = foldl (\b o -> o b) barbaro (objetos barbaro)


descendientes :: Barbaro -> [Barbaro]
descendientes barbaro = iterate descendiente barbaro


-- c.  ¿Se podría aplicar sinRepetidos sobre la lista de objetos? ¿Y sobre el nombre de un bárbaro? ¿Por qué?
{-
    No, no se puede aplicar la función sinRepetidos sobre la lista de objetos, ya que los objetos son funciones y por ende,
    no son comparables.

    Sobre el nombre de un bárbaro si es posible aplicar la función sinRepetidos, ya que un nombre es un string y un string
    resulta ser una lista de char, por lo que son comparables y es posible aplicar la función.
-}
