module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

-- Las leyes

data Ley = Ley {
    tema :: String,
    presupuesto :: Number,
    sectoresQueLaImpulsan :: [String]
} deriving (Show, Eq)

cannabis = Ley "Uso medicinal del cannabis" 5 ["partido cambio de todos", "sector financiero"]

educacionSuperior = Ley "Educacion superior" 30 ["docentes univeritarios", "partido central federal"]

profesionalizacionTenistaMesa = Ley "Tenis" 1 ["partido central federal", "liga de deportistas autonomos", "club paleta veloz"]

tenis = Ley "Tenis" 2 ["liga de deportistas autonomos"]

-- 1) Averiguar si dos leyes son compatibles

sonCompatibles :: Ley -> Ley -> Bool
sonCompatibles ley1 ley2 = tienenAlMenosUnSectorComunQueApoya ley1 ley2 && temaEstaIncluido ley1 ley2

tienenAlMenosUnSectorComunQueApoya :: Ley -> Ley -> Bool
tienenAlMenosUnSectorComunQueApoya ley1 ley2 = (/=0). length. interseccionListas (sectoresQueLaImpulsan ley1) $ sectoresQueLaImpulsan ley2

interseccionListas :: Eq a => [a] -> [a] -> [a]
interseccionListas lista1 lista2 = filter (\x -> elem x lista2) lista1

temaEstaIncluido :: Ley -> Ley -> Bool
temaEstaIncluido ley1 ley2 = tema ley1 == tema ley2


-- Constitucionalidad de las leyes

-- Jueces

type Juez = Ley -> Constitucionalidad
type Agenda = [String]
type Constitucionalidad = Bool

juez1 :: Agenda -> Juez
juez1 agenda ley = elem (tema ley) agenda

juez2 :: Juez
juez2 ley = talSectorApoya ley "sector financiero"

talSectorApoya :: Ley -> String -> Bool
talSectorApoya ley sector = elem sector (sectoresQueLaImpulsan ley)

juez3 :: Juez
juez3 ley = not $ presupuestoEsMayorA ley 10

presupuestoEsMayorA :: Ley -> Number -> Bool
presupuestoEsMayorA ley n = presupuesto ley > n

juez4 :: Juez
juez4 ley = not $ presupuestoEsMayorA ley 20

juez5 :: Juez
juez5 ley = talSectorApoya ley "partido consevador"

-- 1) Hacer que una Corte Suprema determine si se considera constitucional o no una ley

type CorteSuprema = [Juez]

cortesuprema1 agenda = [juez1 agenda, juez2, juez3, juez4, juez5]

agenda = ["Uso medicinal del cannabis", "Educacion superior"]

esConstitucional :: CorteSuprema -> Ley -> Bool
esConstitucional corte ley = (cantidadVotos . votosPositivos . listaVotos corte) ley > (cantidadVotos . votosNegativos . listaVotos corte ) ley

listaVotos :: CorteSuprema -> Ley -> [Bool]
listaVotos corte ley = map (\juez -> juez ley) corte

votosPositivos :: [Bool] -> [Bool]
votosPositivos votos = filter (==True) votos

votosNegativos :: [Bool] -> [Bool]
votosNegativos votos = filter (==False) votos

cantidadVotos :: [Bool] -> Number
cantidadVotos votos = length votos


-- 2) Agregar nuevos jueces

-- a.

juez6 :: Juez
juez6 ley = True

-- b. Vamos a hacer un juez que solo vote a favor de la ley si el tema de la misma es "Tenis"

juez7 :: Juez
juez7 ley = tema ley == "Educacion superior"

juezFalopa :: Juez
juezFalopa ley = False

-- c.

juez8 :: Juez
juez8 ley = not $ presupuestoEsMayorA ley 80


-- 3) Dada una serie de leyes, cuáles que no serían consideradas constitucionales con la actual conformación de la corte sí lo serían en caso de agregarle un conjunto de nuevos integrantes.

cualesSerianConsideradasConstitucionales :: [Ley] -> CorteSuprema -> [Juez] -> [Ley]
cualesSerianConsideradasConstitucionales leyes corte integrantes =  constitucionalesCorteNueva (integrantes ++ corte) (noConstitucionalesCorteActual leyes corte)

noConstitucionalesCorteActual :: [Ley] -> CorteSuprema -> [Ley]
noConstitucionalesCorteActual leyes corte = filter (not . esConstitucional corte) leyes

constitucionalesCorteNueva :: CorteSuprema -> [Ley] -> [Ley]
constitucionalesCorteNueva corte leyes = filter (esConstitucional corte) leyes

corte2 = [juezFalopa]

leyes1 = [cannabis, educacionSuperior]


-- Cuestión de principios

-- 1) Borocotizar

borocotizar :: CorteSuprema -> CorteSuprema
borocotizar corte = map (\juez -> not . juez) corte


-- 2) Un juez coincide con su posición con un sector social

-- Pedimos que todas las leyes que vote positivo, en su lista de sectores aparezca al que apoya el juez 

coincideConPosicion :: Juez -> String -> [Ley] -> Bool
coincideConPosicion juez sector leyes = sonApoyadasPorSector sector . leyesQueVotaPositivo juez $ leyes 

sonApoyadasPorSector :: String -> [Ley] -> Bool
sonApoyadasPorSector sector leyes = all (seCumple sector) leyes

seCumple :: String -> Ley -> Bool
seCumple sector ley = any (==sector) (sectoresQueLaImpulsan ley)

leyesQueVotaPositivo :: Juez -> [Ley] -> [Ley]
leyesQueVotaPositivo juez leyes = filter (votaAFavor juez) leyes

votaAFavor :: Juez -> Ley -> Bool
votaAFavor juez ley = juez ley == True


-- Tests 



-- Para pensar

corteFalopa = [juez2, juez6, juez6, juez6]

leySectoresInfinitos = Ley "Falopa" 5 (repeat "pete")

{-
    Si hubiera una ley apoyada por infinitos sectores ¿puede ser declarada constitucional?
    ¿cuáles jueces podrián votarla y cuáles no? Justificar

    Si una ley es apoyada por infinitos sectores, aquellas cortes que no tengan jueces cuyo voto esté influenciado por los sectores
    que apoyen dicha ley podrán definir si una ley es constitucional o no.
    
    En el caso de que este tipo de jueces esté dentro de la corte, solo se podrá definir la constitucionalidad de una ley si:

        - Dentro de esos sectores infinitos se encuentra el "sector financiero" (juez2) o el "partido conservador"(juez5).

        En caso de que no se encuentren estos sectores en la lista infinita, Haskell no podrá determinar si uno de estos jueces vota a favor o en contra
        de la constitucionalidad de una ley, pues no podrá contar la totalidad de votos a favor y en contra que tiene esa ley dentro
        de la corte. Es decir, el juez2 y el juez5 no podrán votar la ley dado que Haskell se quedará evaluando la lista infinita para
        encontrar a los sectores pertinentes, y no los encontrará nunca.


-}
















