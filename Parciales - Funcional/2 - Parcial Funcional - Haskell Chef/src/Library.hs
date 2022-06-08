module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

-- Parte A

type Componente = (String, Number)

data Plato = Plato {
    dificultad :: Number,
    componentes :: [Componente]
} deriving (Show, Eq)

type Truco = Plato -> Plato

data Participante = Participante {
    nombre :: String,
    trucos :: [Truco],
    especialidad :: Plato
} deriving (Show, Eq)

-- Trucos

plato1 = Plato 10 [("Falopa", 10), ("Merca", 20), ("Sal", 40)]

-- 1. Endulzar

endulzar :: Number -> Truco
endulzar cantidad plato = agregarComponentes "Azucar" cantidad plato

agregarComponentes :: String -> Number -> Truco
agregarComponentes nombre cantidad plato = plato {componentes = (nombre, cantidad) : componentes plato}


-- 2. Salsar

salsar :: Number -> Truco
salsar cantidad plato = agregarComponentes "Sal" cantidad plato


-- 3. Dar sabor 

darSabor :: Number -> Number -> Truco
darSabor cantSal cantAzucar plato = (endulzar cantAzucar . salsar cantSal) plato 


-- 4. Duplicar porcion

duplicarPorcion :: Truco
duplicarPorcion plato = plato {componentes = map (\(x, y) -> (x, y * 2)) (componentes plato)}

-- 5. Simplificar

simplificar :: Truco 
simplificar plato
    |tieneMasDe5Componentes plato && tieneDificultadMayorA7 plato = (dejarCon5Dificultad . quitarComponentes) plato
    |otherwise = plato

tieneMasDe5Componentes :: Plato -> Bool
tieneMasDe5Componentes plato = cantidadComponentes plato > 5

tieneDificultadMayorA7 :: Plato -> Bool
tieneDificultadMayorA7 plato = dificultad plato > 7

cantidadComponentes :: Plato -> Number
cantidadComponentes plato = length (componentes plato)

dejarCon5Dificultad :: Plato -> Plato
dejarCon5Dificultad plato = plato {dificultad = 5}

quitarComponentes :: Plato -> Plato
quitarComponentes plato = plato {componentes = filter ((>10).snd) (componentes plato)}

-- Platos


-- 1. Es vegano

nombresComponentes :: Plato -> [String]
nombresComponentes plato = map (fst) (componentes plato)

esVegano :: Plato -> Bool
esVegano = all (\x -> notElem x ["Carne", "Huevo", "Leche", "Queso", "Crema"]) . nombresComponentes 

tieneTalComponente :: String -> Plato -> Bool
tieneTalComponente componente plato = elem (componente) (nombresComponentes plato)


-- 2. Es sin tacc

esSinTacc :: Plato -> Bool
esSinTacc = not . tieneTalComponente "Harina" 


-- 3. Es complejo

esComplejo :: Plato -> Bool
esComplejo plato = tieneMasDe5Componentes plato && tieneDificultadMayorA7 plato


-- 4. noAptoHipertension

noAptoHipertension :: Plato -> Bool
noAptoHipertension plato = any tieneMuchaSal (componentes plato)

tieneMuchaSal :: Componente -> Bool
tieneMuchaSal (nombre, cantidad) = nombre == "Sal" && cantidad > 2


-- Parte B

pepe = Participante "Pepe Ronccino" [darSabor 2 5, simplificar, duplicarPorcion] platoPepe

platoPepe = Plato 10 [("Salsa", 23), ("Pimienta", 3), ("Albahaca", 5), ("Tomate", 5), ("Cebolla", 7)]


-- Parte C

-- 1. Cocinar

cocinar :: Participante -> Plato
cocinar participante = foldl (\x f -> f x) (especialidad participante) (trucos participante)

-- 2. Es mejor que

esMejorQue :: Plato -> Plato -> Bool
esMejorQue plato1 plato2 = tieneMasDificultad plato1 plato2 && esMasLiviano plato1 plato2

esMasLiviano :: Plato -> Plato -> Bool
esMasLiviano plato1 plato2 = sumaPesosComponentes plato1 < sumaPesosComponentes plato2

tieneMasDificultad :: Plato -> Plato -> Bool
tieneMasDificultad plato1 plato2 = dificultad plato1 > dificultad plato2

sumaPesosComponentes :: Plato -> Number
sumaPesosComponentes = sum . pesosComponentes 

pesosComponentes :: Plato -> [Number]
pesosComponentes = map snd . componentes 


-- 3. Participante estrella

participanteEstrella :: [Participante] -> Participante
participanteEstrella [] = undefined
participanteEstrella [p] = p
participanteEstrella (p1:p2:p)
    |esMejorQue (cocinar p1) (cocinar p2) = participanteEstrella (p1:p)
    |otherwise = participanteEstrella (p2:p)

-- Parte D

platinum = Plato 10 (zip nombreIngredientes [1..])

nombreIngredientes = zipWith (++) (repeat "Ingrediente") (map show [1..])

{-
    - ¿Qué sucede si aplicamos cada uno de los trucos modelados en la Parte A al
    platinum?

    Si aplicamos cada uno de los trucos modelados en la Parta A al plato platinum, ocurrirá lo siguiente para cada truco

    1. endulzar: se podrá aplicar, ya que lo que hace esta función es agregar el componente azúcar al principio de lista, sin importar
    que esta sea infinita

    2. salsar: idem endulzar pero con sal.

    3. darSabor: se podrá aplicar, ya que agrega azúcar y sal al principio de la lista, sin importar que esta sea infinita, utilizando Lazy Evaluation.

    4. duplicarPorcion: se podrá aplicar, ya que simplemente lo que se hace a partir de Lazy Evaluation es duplicar las porciones de todos los ingredientes, sin importar
    que estos sean infinitos. Eso si, nunca terminará de devolver un plato, ya que se quedará duplicando infinitamente las porciones.

    5. simplificar: no se podrá aplicar, ya que si bien Haskell puede saber su dificultad, no podrá evaluar si nuestro plato tendrá 
    más de 5 componentes (ya que debe hacer length de una lista infinita) y además, nunca terminará de evaluar aquellos componentes cuyas cantidades 
    son mayores que 10 para quitarlos, pues estará evaluando una lista infinita.

    
        
    - ¿Cuáles de las preguntas de la Parte A (esVegano, esSinTacc, etc.) se pueden
    responder sobre el platinum?

    1. esVegano: no se puede responder, ya que estará buscando en la lista infinita de ingredientes si hay alguno que no 
    contenga carne, huevos, o productos lácteos. Nunca terminará de evaluar la lista, porque nunca lo encontrará.
    Si se diera el caso de que algun ingrediente fuera uno de estos, sí se podría responder gracias al Lazy Evaluation.

    2. esSinTacc: idem esVegano, pero con el componente "harina".

    3. esComplejo: si bien Haskell puede evaluar si la dificultad es mayor a 7, no podemos evaluar el length de una lista infinita para 
    determinar si tiene más de 5 componentes. Por ende, no se podrá responder.

    4. noAptoHipertension: no se podrá responder ya que Haskell se quedará buscando si algún ingrediente es sal y tiene mas de 2 gramos
    y nunca lo encontrará, pues ninguno de los ingredientes de platinum corresponde a lo que se está buscando.



    - ¿Se puede saber si el platinum es mejor que otro plato?

    No, ya que si bien se puede saber si un plato tiene más dificultad que otro, no se puede averiguar si uno es mas liviano que el otro, ya que
    Haskell necesita conocer las cantidades de todos los ingredientes de ambos platos para sumarlos, y resulta que platinum tiene ingredientes infinitos,
    por lo que nunca terminará de hacer tal suma para platinum.

-}


