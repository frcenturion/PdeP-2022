module Library where
import PdePreludat

-- 1

-- a)

data Pais = UnPais {
    ingresoPerCapita :: Number,
    poblacionActivaSPublico :: Number,
    poblacionActivaSPrivado :: Number,
    recursosNaturales :: [String],
    deuda :: Number --en millones de USD
} deriving (Show, Eq)

-- b)

namibia = UnPais 4140 400000 650000 ["Mineria", "Ecoturismo"] 50

{-

Otra forma de generar a namibia es:

namibia = UnPais {ingresoPerCapita = 4140, poblacionActivaSPublico = 400000, poblacionActivaSPrivado = 650000, recursosNaturales = ["Minería", "Ecoturismo"], deuda = 50}

-}

-- 2

-- Modelamos las estrategias, que son funciones

type Estrategia = Pais -> Pais

prestarNMillones :: Number -> Estrategia
prestarNMillones n pais = pais {deuda = deuda pais + (1.5 * n)}

reducirXPuestosDeTrabajoSectorPublico :: Number -> Pais -> Pais 
reducirXPuestosDeTrabajoSectorPublico x pais = pais {poblacionActivaSPublico = poblacionActivaSPublico pais - x, ingresoPerCapita = disminuirIngresoPerCapita x pais}

disminuirIngresoPerCapita :: Number -> Pais -> Number
disminuirIngresoPerCapita x pais 
    | x > 100 = ingresoPerCapita pais - (0.2 * ingresoPerCapita pais)
    | otherwise = ingresoPerCapita pais - (0.15 * ingresoPerCapita pais)

explotarRecurso :: String -> Estrategia
explotarRecurso recurso pais = pais {deuda = deuda pais - 2, recursosNaturales = filter (/=recurso) (recursosNaturales pais)}

establecerBlindaje :: Estrategia
establecerBlindaje pais = (prestarNMillones ((pbiPais pais * 0.5) / 1000000).reducirXPuestosDeTrabajoSectorPublico 500) pais

pbiPais :: Pais -> Number
pbiPais pais = ingresoPerCapita pais * sumaPuestosDeTrabajoPais pais

sumaPuestosDeTrabajoPais :: Pais -> Number
sumaPuestosDeTrabajoPais pais = poblacionActivaSPrivado pais + poblacionActivaSPublico pais

-- 3 

-- a)

type Receta = [Estrategia]

receta = [prestarNMillones 50, explotarRecurso "Mineria"]
receta2 = [reducirXPuestosDeTrabajoSectorPublico 100, explotarRecurso "Petroleo"]

-- b) 

-- Aplicamos la receta a Namibia

aplicarReceta :: Receta -> Pais -> Pais
aplicarReceta receta pais = foldl (\unPais unaEstrategia -> unaEstrategia unPais) pais receta


-- 4

-- a)

argentina = UnPais 6000 900000 950000 ["Petroleo", "Ecoturismo"] 30
arabia = UnPais 7000 700000 750000 ["Petroleo", "Mineria"] 20

lista = [argentina, arabia, namibia]

puedenZafar :: [Pais] -> [Pais]
puedenZafar listaPaises = filter (elem "Petroleo" . recursosNaturales) listaPaises

{-

Sin aplicación parcial ni orden superior:

puedenZafar :: [Pais] -> [Pais]
puedeZafar listaPaises = filter tienePetroleo listaPaises

tienePetroleo :: Pais -> Bool
tienePetroleo pais = any (=="Petroleo") (recursosNaturales pais)

-}


-- b) 

totalDeuda :: [Pais] -> Number
totalDeuda = (sum . map deuda)

-- 5

listaEstaOrdenada :: Pais -> [Receta] -> Bool
listaEstaOrdenada pais [receta] = True
listaEstaOrdenada pais (receta1:receta2:recetas) = (pbiPais . aplicarReceta receta1) pais <= (pbiPais . aplicarReceta receta2) pais && listaEstaOrdenada pais (receta2:recetas)

-- 6

{-

Si un pais tiene infinitos recursos naturales, modelada con la funcion 

recursosNaturalesInfinitos :: [String]
recursosNaturalesInfinitos = "Energia" : recursosNaturalesInfinitos

-}

-- a)

{- 

Cuando evaluamos la función 

puedenZafar :: [Pais] -> [Pais]
puedenZafar listaPaises = filter (elem "Petroleo" . recursosNaturales) listaPaises

Con esos recursos naturales infinitos, no terminará nunca, dado que esta función está buscando que algún país tenga "Petroleo" entre 
sus recursos naturales, y nunca encontrará dicho recurso dado que la lista infinita solo contiene el recurso "Energia"

 -}

 -- b)

 {-

 Cuando evaluamos la función 

totalDeuda :: [Pais] -> Number
totalDeuda = (sum . map deuda)

Con esos recursos naturales infinitos, en este caso sí devolverá un resultado, ya que lo que se está evaluando en este caso es
la deuda que tiene cada país, no sus recursos naturales. Como Haskell utiliza evaluación diferida, no importa que uno de los 
componentes del data país sea infinito, solo evalúa lo que necesita, que en este caso son los valores de las deudas.

-}

