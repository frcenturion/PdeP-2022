module Library where
import PdePreludat

-- 1) Modelado de la pizza

type Tamanio = Number
type Ingrediente = String

individual = 4
chica = 6
grande = 8
gigante = 10

data Pizza = Pizza {
    ingredientes :: [Ingrediente],
    tamanio :: Tamanio,
    calorias :: Number
} deriving (Show, Eq)

grandeDeMuzza = Pizza ["salsa", "mozzarella", "oregano"] grande 350

-- 2) Nivel de satisfacción que da una pizza

nivelSatisfaccion :: Pizza -> Number
nivelSatisfaccion pizza 
    |tieneTalIngrediente pizza "palmito" = 0
    |tieneMenos500Calorias pizza = calcularSatisfaccion pizza
    |otherwise = calcularSatisfaccion pizza `div` 2


tieneTalIngrediente :: Pizza -> Ingrediente -> Bool
tieneTalIngrediente pizza ingrediente = elem ingrediente (ingredientes pizza)

tieneMenos500Calorias :: Pizza -> Bool
tieneMenos500Calorias pizza = calorias pizza < 500

cantidadIngredientes :: Pizza -> Number
cantidadIngredientes pizza = length (ingredientes pizza)

calcularSatisfaccion :: Pizza -> Number
calcularSatisfaccion pizza = (cantidadIngredientes pizza) * 80

-- 3) Valor de una pizza

valorPizza :: Pizza -> Number
valorPizza pizza = ((*tamanio pizza).(*120).cantidadIngredientes) pizza

-- 4) Funciones

-- a.
nuevoIngrediente :: Pizza -> Ingrediente -> Pizza
nuevoIngrediente pizza ingrediente = (agregarCalorias (length ingrediente * 2) . agregarIngrediente ingrediente) pizza 

agregarIngrediente :: Ingrediente -> Pizza -> Pizza
agregarIngrediente ingrediente pizza = pizza {ingredientes = ingrediente : ingredientes pizza}

agregarCalorias :: Number -> Pizza -> Pizza
agregarCalorias cantidad pizza = pizza {calorias = calorias pizza + cantidad}


-- b.
agrandar :: Pizza -> Pizza
agrandar pizza = agregarPorciones 2 pizza

agregarPorciones :: Number -> Pizza -> Pizza
agregarPorciones cantidad pizza = pizza {tamanio = max 10 (tamanio pizza + cantidad)}


-- c.

mezcladita :: Pizza -> Pizza -> Pizza
mezcladita pizza1 pizza2 = ((agregarCalorias (calorias pizza1 / 2)) . (combinarIngredientes pizza1)) pizza2


combinarIngredientes :: Pizza -> Pizza -> Pizza
combinarIngredientes pizza1 pizza2 = pizza2 {ingredientes = ingredientes pizza1 ++ (ingredientesQueFaltanEnLaPrimera pizza1 pizza2)}

ingredientesQueFaltanEnLaPrimera :: Pizza -> Pizza -> [String]
ingredientesQueFaltanEnLaPrimera pizza1 pizza2 = filter (\x -> notElem x (ingredientes pizza1)) (ingredientes pizza2)

anchoas = Pizza ["salsa", "anchoas", "anana"] 270 8

interseccionListas :: Eq a => [a] -> [a] -> [a]
interseccionListas lista1 lista2 = filter (\x -> elem x lista2) lista1


-- 5) Nivel de satisfacción de un pedido

type Pedido = [Pizza]

nivelSatisfaccionPedido :: Pedido -> Number
nivelSatisfaccionPedido pedido = (sum . map nivelSatisfaccion) pedido

-- Versión alternativa (no es lo que pide el parcial)

nivelSatisfaccionPedido2 :: Pedido -> Number
nivelSatisfaccionPedido2 pedido = foldl1 (+) (map nivelSatisfaccion pedido) 

-- 6) Modelado de las pizzerías


-- a
type Pizzeria = Pedido -> Pedido

pizzeriaLosHijosDePato :: Pizzeria
pizzeriaLosHijosDePato pedido = map (agregarIngrediente "palmito") pedido


-- b
{- pizzeriaElResumen :: Pedido -> Pedido
pizzeriaElResumen [] = []
pizzeriaElResumen [pizza] = [pizza]
pizzeriaElResumen (pizza1:pizza2:pizzas) = mezcladita pizza1 pizza2 : pizzeriaElResumen (pizza2:pizzas)


-- c
pizzeriaEspecial :: Pizza -> Pedido -> Pedido
pizzeriaEspecial pizza pedido = map (mezcladita pizza) pedido

anchoas = Pizza ["salsa", "anchoas"] 270 8

pizzeriaPescadito :: Pedido -> Pedido
pizzeriaPescadito pedido = pizzeriaEspecial anchoas pedido
 -}
--d
type Exquisitez = Number

pizzeriaGourmet :: Exquisitez -> Pizzeria
pizzeriaGourmet exquisitez pedido = (map agrandar . (filter (satisfaccionSuperaExquisitez exquisitez))) pedido

satisfaccionSuperaExquisitez :: Exquisitez -> Pizza -> Bool
satisfaccionSuperaExquisitez exquisitez pizza = nivelSatisfaccion pizza > exquisitez

pizzeriaLaJauja :: Pizzeria
pizzeriaLaJauja pedido = pizzeriaGourmet 399 pedido

-- 7) Pizzerías y pedidos

-- a
sonDignasDeCalleCorrientes :: Pedido -> [Pizzeria] -> [Pizzeria]
sonDignasDeCalleCorrientes pedido pizzerias = filter (mejoraSatisfaccionDelPedido pedido) pizzerias

mejoraSatisfaccionDelPedido :: Pedido -> Pizzeria -> Bool
mejoraSatisfaccionDelPedido pedido pizzeria = nivelSatisfaccionPedido pedido < nivelSatisfaccionPedido (pizzeria pedido)

-- b

listaPizzerias = [pizzeriaLosHijosDePato, pizzeriaGourmet 40]

--pizzeriaQueMaximizaSatisfaccion :: Pedido -> [Pizzeria] -> Pizzeria 
--pizzeriaQueMaximizaSatisfaccion pedido pizzerias = foldl  


-- 8) Explicar el tipo de la siguiente función: yoPidoCualquierPizza x y z = any (odd . x . fst) z && all (y . snd) z

{-
    yoPidoCualquierPizza :: (a -> Number) -> (b -> Bool) -> [(a, b)] -> Bool

    Esta función recibe 3 parámetros:
        -   Una función x que recibe un elemento 'a' y devuelve un número. El elemento 'a' debe ser del mismo tipo que el primer 
        elemento de las tuplas que se encuentran en la lista z, esto debido a que x recibe el primer elemento de la lista de tuplas.

        - Una función y que recibe un elemento 'b' y devuelve un booleano. El elemento 'b' debe ser del mismo tipo que el segundo
        elemento de la tupla que se encuentra en la lista z, esto debido a que y recibe el segundo elemento de la tupla-

        - Una lista de tuplas

    Y devuelve un Booleano, dado que aplica el operador && en ultima instancia.
-}


-- 9) Bonus

--laPizzeriaPredilecta :: [Pizzeria] -> Pizzeria
--laPizzeriaPredilecta pizzerias =




