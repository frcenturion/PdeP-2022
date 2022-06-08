module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

-- Primera parte

-- 1) Modelado de guantelete, personajes y universo; implementación de chasquido

--type Guantelete = (String, [Gema])

data Guantelete = Guantelete {
    nombreGuantelete :: String,
    gemas :: [Gema]
} deriving (Show, Eq)


data Personaje = Personaje {
    nombre :: String,
    edad :: Number,
    energia :: Number,
    habilidades :: [String],
    planeta :: String
} deriving (Show, Eq)

type Universo = [Personaje]


ironMan = Personaje "Iron Man" 50 90 ["xd", "hola"] "xd"
drStrange = Personaje "Dr Strange" 60 90 ["xd", "hola", "chau"] "xd"
groot = Personaje "Groot" 70 90 [] "xd"
wolverine = Personaje "Wolverine" 80 90 [] "xd"
viudaNegra = Personaje "Viuda Negra" 90 90 [] "xd"

universo1 = [ironMan, drStrange, groot, wolverine, viudaNegra]

chasquido :: Universo -> Universo
chasquido universo = take (cantidadHabitantes universo `div` 2) universo

cantidadHabitantes :: Universo -> Number
cantidadHabitantes universo = length universo

-- 2) Utilizar orden superior

esAptoPendex :: Universo -> Bool
esAptoPendex = algunoTieneMenosde45 . edadPersonajes

edadPersonajes :: Universo -> [Number]
edadPersonajes universo = map edad universo

algunoTieneMenosde45 :: [Number] -> Bool
algunoTieneMenosde45 edades = any (< 45) edades


energiaTotal :: Universo -> Number
energiaTotal = sumatoriaEnergias . energiaIntegrantes . tienenMasDeUnaHabilidad

tienenMasDeUnaHabilidad :: Universo -> Universo
tienenMasDeUnaHabilidad universo = filter ((>1) . length . habilidades) universo

energiaIntegrantes :: Universo -> [Number]
energiaIntegrantes universo = map energia universo

sumatoriaEnergias :: [Number] -> Number
sumatoriaEnergias energias = sum energias


-- Segunda parte

type Gema = Personaje -> Personaje

-- 3) Modelado de gemas

-- La mente
laMente :: Number -> Gema
laMente valor personaje = modificarEnergia valor personaje

modificarEnergia :: Number -> Personaje -> Personaje
modificarEnergia valor personaje = personaje {energia = energia personaje + valor}

-- El alma
elAlma :: String -> Gema
elAlma habilidad personaje =  modificarEnergia (-10) . quitarHabilidadParticular habilidad $ personaje

quitarHabilidadParticular :: String -> Personaje -> Personaje
quitarHabilidadParticular habilidad personaje
    | poseeDichaHabilidad habilidad personaje = personaje {habilidades = filter (/= habilidad) $ habilidades personaje} 
    | otherwise = personaje

poseeDichaHabilidad :: String -> Personaje -> Bool
poseeDichaHabilidad habilidad personaje = elem habilidad (habilidades personaje)

-- El espacio
elEspacio :: String -> Gema
elEspacio planeta personaje = modificarEnergia (-20) . transportarAPlaneta planeta $ personaje

transportarAPlaneta :: String -> Personaje -> Personaje
transportarAPlaneta planeta personaje = personaje {planeta = planeta}


-- El poder
elPoder :: Gema
elPoder personaje = quitarHabilidades . modificarEnergia (-(energia personaje)) $ personaje

quitarHabilidades :: Personaje -> Personaje
quitarHabilidades personaje
    |tieneDosHabilidadesOMenos personaje = personaje {habilidades = []}
    |otherwise = personaje

tieneDosHabilidadesOMenos :: Personaje -> Bool
tieneDosHabilidadesOMenos personaje = length (habilidades personaje) <= 2


-- El tiempo
elTiempo :: Gema
elTiempo personaje = modificarEnergia (-50) . modificarEdad (-mitadDeLaEdad personaje) $ personaje

mitadDeLaEdad :: Personaje -> Number
mitadDeLaEdad personaje = (edad personaje) `div` 2

modificarEdad :: Number -> Personaje -> Personaje
modificarEdad valor personaje = personaje {edad = edad personaje + valor}


-- La Gema Loca
gemaLoca :: Gema -> Personaje -> Personaje
gemaLoca gema personaje = gema . gema $ personaje


-- 4) Ejemplos de guanteletes

guantelete1 = Guantelete "Guantelete Falopa" [elTiempo, elAlma "usar Mjolnir", gemaLoca (elAlma "programacion en Haskell")]

-- 5) Utilizar

utilizar :: [Gema] -> Personaje -> Personaje
utilizar gemas personaje = foldl (\p g -> g p) personaje gemas


-- 6) Gema mas poderosa


-- SI MODELAMOS EL GUANTELETE COMO DATA --

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa guantelete personaje = produceMayorPerdidaEnergia personaje $ gemas guantelete

produceMayorPerdidaEnergia :: Personaje -> [Gema] -> Gema
produceMayorPerdidaEnergia _ [] = undefined
produceMayorPerdidaEnergia _ [g] = g
produceMayorPerdidaEnergia personaje (g1:g2:g)
    | energia (g1 personaje) < energia (g2 personaje) = produceMayorPerdidaEnergia personaje (g1:g)
    | otherwise = produceMayorPerdidaEnergia personaje (g2:g)


{- 

-- SI MODELAMOS AL GUANTELETE COMO TUPLA --

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa (x, []) personaje = undefined
gemaMasPoderosa (x, [g1]) personaje = g1
gemaMasPoderosa (x, (g1:g2:g)) personaje 
    | energia (g1 personaje) < energia (g2 personaje) = gemaMasPoderosa (x, (g1:g)) personaje
    | otherwise = gemaMasPoderosa (x, (g2:g)) personaje


guanteleteFalopa = ("Falopa", [elAlma "xd", elEspacio "falopa", elPoder])

 -}

-- 7)

{-
     Dada la función generadora de gemas y un guantelete de locos:
    
    infinitasGemas :: Gema -> [Gema]
    infinitasGemas gema = gema:(infinitasGemas gema)
    
    guanteleteDeLocos :: Guantelete
    guanteleteDeLocos = Guantelete "vesconite" (infinitasGemas tiempo)
    
    Y la función
    
    usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
    usoLasTresPrimerasGemas guantelete = (utilizar2 . take 3. gemas) guantelete


    Justifique si se puede ejecutar, relacionándolo con conceptos vistos en la cursada:
    
    1. gemaMasPoderosa punisher guanteleteDeLocos
    2. usoLasTresPrimerasGemas guanteleteDeLocos punisher

-}

{-
    1. La función gemaMasPoderosa con el guanteleteDeLocos no se va a poder ejecutar, ya que para poder determinar cuál
    es la gema más poderosa, Haskell necesita evaluar la lista completa de gemas para poder establecer comparaciones. Como la lista
    de gemas es infinita, nunca terminará de evaluar y por ende nunca podrá devolver una gema específica.

    2. La función usoLasTresPrimerasGemas con el guanteleteDeLocos si se puede ejecutar, ya que, como Haskell trabaja con Lazy Evaluation,
    no necesita evaluar la lista entera de gemas para poder ejecutarse, sino que solo evaluará lo que necesita. 
    En este caso, solo tomará las primeras tres gemas y se las aplicará a un personaje.
-}