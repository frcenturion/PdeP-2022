module Library where
import PdePreludat

-- Parcial Functional Master Series

-- Nombre: Apellido, Nombre (reemplazar por el tuyo)
-- Legajo: 999999-9 (reemplazar por el tuyo)

type Palabra = String
type Verso = String
type Estrofa = [Verso]

esVocal :: Char -> Bool
esVocal = flip elem "aeiouáéíóú"

tieneTilde :: Char -> Bool
tieneTilde = flip elem "áéíóú"

cumplen :: (a -> b) -> (b -> b -> Bool) -> a -> a -> Bool
cumplen f comp v1 v2 = comp (f v1) (f v2)


-- RIMAS

-- 1

rimaAsonante :: Palabra -> Palabra -> Bool
rimaAsonante palabra1 palabra2 = ultimasDosVocales palabra1 == ultimasDosVocales palabra2 && (palabra1 /= palabra2)

rimaConsonante :: Palabra -> Palabra -> Bool
rimaConsonante palabra1 palabra2 = ultimasTresLetras palabra1 == ultimasTresLetras palabra2 && (palabra1 /= palabra2)

ultimasDosVocales :: Palabra -> Palabra
ultimasDosVocales palabra = (reverse.(take 2).(filter(esVocal)).reverse) palabra

ultimasTresLetras :: Palabra -> Palabra
ultimasTresLetras palabra = (reverse.(take 3).reverse) palabra

-- a)

palabrasRiman :: Palabra -> Palabra -> Bool
palabrasRiman palabra1 palabra2 = rimaAsonante palabra1 palabra2 || rimaConsonante palabra1 palabra2

-- b)

-- Hecho en el Spec 


-- CONJUGACIONES

-- 2

type Conjugacion = Verso -> Verso -> Bool

-- Conjugación por rimas

conjugacionPorMedioDeRimas :: Conjugacion
conjugacionPorMedioDeRimas verso1 verso2 = palabrasRiman (ultimaPalabra verso1) (ultimaPalabra verso2) 

ultimaPalabra :: Verso -> Palabra
ultimaPalabra verso = (last.words)verso 

-- Conjugación por anadiplosis

conjugacionPorAnadiplosis :: Conjugacion
conjugacionPorAnadiplosis verso1 verso2 = primeraPalabra verso2 == ultimaPalabra verso1 

primeraPalabra :: Verso -> Palabra
primeraPalabra verso = (head.words)verso


-- PATRONES

-- 3

-- a)

type Patron = Estrofa -> Bool

-- Patron Simple
estrofa1 = ["esta rima es facil como patear un penal", "solamente tiene como objetivo servir de ejemplo", "los versos del medio son medio fríos", "porque el remate se retoma al final"]

patronSimple ::  Number -> Number -> Estrofa -> Bool
patronSimple posicion1 posicion2 estrofa =  conjugacionPorMedioDeRimas (estrofa !! posicion1) (estrofa !! posicion2) 

-- Patron Esdrújula
estrofa2 = ["a ponerse los guantes y subir al cuadrilátero", "que después de este parcial acerca el paradigma lógico", "no entiendo por qué está fallando mi código", "si todas estas frases terminan en esdrújulas"]

patronEsdrujula :: Estrofa -> Bool
patronEsdrujula estrofa = all esEsdrujula (ultimasPalabrasEstrofa estrofa)

ultimasPalabrasEstrofa :: Estrofa -> [Palabra]
ultimasPalabrasEstrofa estrofa = map ultimaPalabra estrofa 

antepenultimaVocal :: Palabra -> Char
antepenultimaVocal palabra = (last.(take 3).(filter(esVocal)).reverse) palabra

esEsdrujula :: Palabra -> Bool
esEsdrujula palabra = tieneTilde (antepenultimaVocal palabra) 

-- Patron Anáfora
estrofa3 = ["paradigmas hay varios, recién vamos por funcional", "paradigmas de programación es lo que analizamos acá", "paradigmas que te invitan a otras formas de razonar", "paradigmas es la materia que más me gusta cursar"]

patronAnafora :: Estrofa -> Bool
patronAnafora estrofa = (iguales . map primeraPalabra) estrofa

iguales :: Eq a => [a] -> Bool
iguales [] = False
iguales (x1:xs) = all (==x1) xs

-- Patron Cadena
estrofa4 = ["este es un ejemplo de un parcial compuesto", "compuesto de funciones que se operan entre ellas", "ellas también pueden pasarse por parámetro", "parámetro que recibe otra función de alto orden"]

patronCadena :: Conjugacion -> Estrofa -> Bool
patronCadena _ [] = True
patronCadena _ [x] = True 
patronCadena conjugacion (x1:x2:xs) = conjugacion x1 x2 && patronCadena conjugacion (x2:xs)

-- Patron CombinaDos
estrofa5 = ["estrofa que sirve como caso ejémplico", "estrofa dedicada a la gente fanática", "estrofa comenzada toda con anáfora", "estrofa que termina siempre con esdrújulas"]

patronCombinaDos :: Patron -> Patron -> Estrofa -> Bool
patronCombinaDos patron1 patron2 estrofa = patron1 estrofa && patron2 estrofa 

-- b)
 
aabb estrofa = patronCombinaDos (patronSimple 0 1) (patronSimple 2 3) estrofa
abab estrofa = patronCombinaDos (patronSimple 0 2) (patronSimple 1 3) estrofa
abba estrofa = patronCombinaDos (patronSimple 0 3) (patronSimple 1 2) estrofa
hardcore estrofa = patronCombinaDos (patronCadena conjugacionPorMedioDeRimas) (patronEsdrujula) estrofa
 
-- c) 

estrofa9 = ["compuesto es un ejemplo de un parcial compuesto", "compuesto de funciones que se operan entre compuesto"]


estrofaInfinita :: Estrofa
estrofaInfinita = cycle estrofa9

{-  

Si tenemos una estrofa con infinitos versos:

Se puede chequear si la misma cumple con el patrón hardcore, ya que se deben cumplir dos patrones, el patrón cadena por medio de rimas
y el patrón esdrújula. Entonces, lo que hará Haskell es utilizar evaluación diferida, tomando los elementos que sean necesarios, hasta
que se cumplan ambos patrones. Si encuentra un caso que no cumpla ya dará false. No puede darse el caso

Sí es posible chequear si cumple el patrón aabb, ya que para este patron debe chequear si se cumplen los patrones simples en las
posiciones 1 y 2, y en las posiciones 2 y 3. Entonces Haskell, utilizando evaluación diferida, solo debe tomar los versos de las posiciones
mencionadas para poder evaluar si la estrofa cumple los patrones, es decir, no necesita evaluar toda la estrofa infinita.

-}


-- PUESTAS EN ESCENA

data PuestaEnEscena = UnaPuestaEnEscena {
    publicoExaltado :: Bool,
    potencia :: Number,
    estrofa :: Estrofa,
    artista :: String
} deriving (Show, Eq)


puestaEnEscena1 = UnaPuestaEnEscena False 100 estrofa2 "Trueno"

-- Estilos

type Estilo = PuestaEnEscena -> PuestaEnEscena

gritar :: Estilo
gritar puestaEnEscena = puestaEnEscena {potencia = potencia puestaEnEscena * 1.5}

responderUnAcote :: Bool -> Estilo
responderUnAcote efectividad puestaEnEscena 
    |efectividad = puestaEnEscena {potencia = potencia puestaEnEscena * 1.2, publicoExaltado = True}
    |otherwise = puestaEnEscena {potencia = potencia puestaEnEscena * 1.2}

tirarTecnicas :: Patron -> Estilo
tirarTecnicas patron puestaEnEscena
    |patron (estrofa puestaEnEscena) = puestaEnEscena {potencia = potencia puestaEnEscena * 1.1, publicoExaltado = True}
    |otherwise = puestaEnEscena {potencia = potencia puestaEnEscena * 1.1}


-- 4

puestaBase :: String -> Estrofa -> PuestaEnEscena
puestaBase artista estrofa = UnaPuestaEnEscena {artista = artista, estrofa = estrofa, potencia = 1, publicoExaltado = False}

freestyle :: String -> Estrofa -> Estilo -> PuestaEnEscena
freestyle artista estrofa estilo = estilo (puestaBase artista estrofa)


-- JURADOS

-- 5

type Criterio = (PuestaEnEscena -> Bool, Number)

type Jurado = [Criterio]

-- a)

alToke puestaEnEscena = [(aabb (estrofa puestaEnEscena), 0.5), (patronCombinaDos (patronEsdrujula) (patronSimple 0 3) (estrofa puestaEnEscena), 1), (publicoExaltado puestaEnEscena, 1), (potencia puestaEnEscena > 1.5, 2)]


-- b)

puntaje :: PuestaEnEscena -> Jurado -> Number
puntaje puestaEnEscena criterios = (sumatoriaPuntajes . (map snd) . criteriosNumbereresantes criterios) puestaEnEscena

sumatoriaPuntajes :: [Number] -> Number
sumatoriaPuntajes puntajes = ((max 3) . sum) puntajes 

criteriosNumbereresantes :: [Criterio] -> PuestaEnEscena -> [Criterio]
criteriosNumbereresantes criterios puesta = filter (\(f, _) -> f puesta) criterios


