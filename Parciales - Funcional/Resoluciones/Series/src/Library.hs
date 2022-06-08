module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

-- Modelado de series

data Serie = Serie {
    nombre :: String,
    actores :: [Actor],
    presupuesto :: Number,
    temporadas :: Number,
    rating :: Number,
    cancelada :: Bool
} deriving (Show, Eq)

-- Modelado de actores

data Actor = Actor {
    nombreActor :: String,
    sueldo :: Number,
    restricciones :: [String]
} deriving (Show, Eq)

paulrudd = Actor "Paul Rudd" 41 ["no actuar en bata", "comer ensalada de rucula todos los dias"]

-- 1) 

-- a. Serie en rojo

serieEstaEnRojo :: Serie -> Bool
serieEstaEnRojo serie = presupuesto serie < sueldosActoresTotal serie

sueldosActores :: Serie -> [Number]
sueldosActores serie = map (sueldo) (actores serie)  

sueldosActoresTotal :: Serie -> Number
sueldosActoresTotal serie = sum (sueldosActores serie)

-- b. Serie problemática

esSerieProblematica :: Serie -> Bool
esSerieProblematica serie = length (actoresConMasDeUnaRestriccion serie) > 3 

restriccionesActores :: Serie -> [[String]]
restriccionesActores serie = map (restricciones) (actores serie)

actoresConMasDeUnaRestriccion :: Serie -> [[String]]
actoresConMasDeUnaRestriccion serie = filter ((>1) . length) (restriccionesActores serie)

-- OTRA FORMA -> En vez de filtrar la lista de restricciones filtramos los actores

esSerieProblematicaV2 :: Serie -> Bool
esSerieProblematicaV2 serie = length (actoresConMasDeUnaRestriccionV2 serie) > 3 

actoresConMasDeUnaRestriccionV2 :: Serie -> [Actor]
actoresConMasDeUnaRestriccionV2 serie = filter (tieneMasDeUnaRestriccion) (actores serie)

tieneMasDeUnaRestriccion :: Actor -> Bool
tieneMasDeUnaRestriccion actor = length (restricciones actor) > 1


-- 2) Modelado de productores  

-- a. Con favoritismos

type Favoritos = [Actor]
type Productor = Serie -> Serie

conFavoritismos :: Favoritos -> Productor
conFavoritismos favoritos serie =  agregarActores favoritos . eliminarPrimerosDosActores $ serie 

eliminarPrimerosDosActores :: Serie -> Serie
eliminarPrimerosDosActores serie = serie {actores = drop 2 (actores serie)}

agregarActores :: Favoritos -> Serie -> Serie
agregarActores favoritos serie = serie {actores = favoritos ++ actores serie}


-- b. Tim Burton

johnnydepp = Actor "Johnny Depp" 20 []
helenabonham = Actor "Helena Bonham" 15 []

timBurton :: Productor
timBurton serie = conFavoritismos [johnnydepp, helenabonham] serie

-- c. Gatopardeitor

gatopardeitor :: Productor
gatopardeitor serie = serie

-- d. Estireitor 

estireitor :: Productor
estireitor serie = duplicarTemporadas serie

duplicarTemporadas :: Serie -> Serie
duplicarTemporadas serie = serie {temporadas = temporadas serie  * 2} 


-- e. Desespereitor

tomholland = Actor "Tom Holland" 50 ["que haya cafe"]
zendaya = Actor "Zendaya" 30 ["que este Tom Holland"]

desespereitor :: Productor
desespereitor serie = (estireitor . timBurton) serie


-- f. Canceleitor 

canceleitor :: Number -> Productor
canceleitor numero serie 
    |serieEstaEnRojo serie || ratingEsMasBajoQue numero serie = serie {cancelada = True}
    |otherwise = serie

ratingEsMasBajoQue :: Number -> Serie -> Bool
ratingEsMasBajoQue numero serie = rating serie < numero

-- 3) Calcular el bienestar de una serie

bienestarSerie :: Serie -> Number
bienestarSerie serie
    | cancelada serie = 0
    | otherwise = bienestarPorLongitud serie + bienestarPorReparto serie

bienestarPorLongitud :: Serie -> Number
bienestarPorLongitud serie
    | temporadas serie > 4 = 5
    | otherwise = (10 - temporadas serie) * 2 

bienestarPorReparto :: Serie -> Number
bienestarPorReparto serie 
    | length (actores serie) < 10 = 3 
    | otherwise = max 2 $ (10 - (cantidadDeActoresConRestricciones . actoresConRestricciones $ actores serie)) * 2

cantidadDeActoresConRestricciones :: [Actor] -> Number
cantidadDeActoresConRestricciones actores = length actores

actoresConRestricciones :: [Actor] -> [Actor]
actoresConRestricciones actores = filter tieneRestricciones actores

tieneRestricciones :: Actor -> Bool
tieneRestricciones actor = length (restricciones actor) > 0 


-- 4) Aplicar para cada serie el productor que la haga mas efectiva (que le deje mas bienestar)

aplicarProductorMasEfectivo :: [Serie] -> [Productor] -> [Serie]
aplicarProductorMasEfectivo series productores = map (masEfectivo productores) series

masEfectivo :: [Productor] -> Serie -> Serie
masEfectivo [productor] serie = productor serie
masEfectivo (p1:p2:p) serie
    | bienestarSerie (p1 serie) > bienestarSerie (p2 serie) = p1 serie
    | otherwise = masEfectivo p serie 


-- 5) Responder:

-- a. ¿Se puede aplicar el productor ​gatopardeitor​ cuando tenemos una lista infinita de actores?
{-
    Si, se puede aplicar el productor gatopardeitor cuando tenemos una lista infinita de actores, ya que este productor
    devuelve simplemente la serie tal como estaba, no necesita evaluar ninguna condición.
-}


-- b. ¿Y a uno ​con favoritismos​? ¿De qué depende?
{-
    En este caso, es posible aplicar el productor con favoritismos siempre y cuando el mismo agregue a sus actores favoritos al principio
    de la lista de actores. Si se quisiera agregar al final, no se podría aplicar, ya que Haskell necesitaría evaluar toda la lista de 
    actores para después agregarlos al final.
-}


-- 6) Serie controvertida

esControvertida :: Serie -> Bool
esControvertida serie = not (cobranMasQueElSiguiente $ actores serie)

cobraMas :: Actor -> Actor -> Bool
cobraMas actor1 actor2 = sueldo actor1 > sueldo actor2

cobranMasQueElSiguiente :: [Actor] -> Bool
cobranMasQueElSiguiente [] = undefined
cobranMasQueElSiguiente [actor] = True
cobranMasQueElSiguiente (actor1:actor2:actores) = cobraMas actor1 actor2 && cobranMasQueElSiguiente (actor2:actores)

actores1 = [tomholland, zendaya, johnnydepp, helenabonham]

-- 7)  Explicar la inferencia del tipo de la siguiente función:

funcionLoca x y = filter (even.x) . map (length.y)

{-
    funcionLoca :: (Number -> Number) -> (a -> [b]) -> [a] -> [Number]
-}
