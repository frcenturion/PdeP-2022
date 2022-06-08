module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero


-- Modelado de ladrones

data Ladron = Ladron {
    nombre :: String,
    habilidades :: [String],
    armas :: [Arma]
} deriving (Show, Eq)

data Rehen = Rehen {
    nombreRehen :: String,
    complot :: Number,
    miedo :: Number,
    plan :: [Plan]
} deriving (Show, Eq)


-- Modelado de armas

type Arma = Rehen -> Rehen

type Calibre = Number

pistola :: Calibre -> Arma
pistola calibre rehen = modificarComplot (-5*calibre) . modificarMiedo (3*letrasNombre rehen) $ rehen 

letrasNombre :: Rehen -> Number
letrasNombre rehen = length (nombreRehen rehen)

modificarComplot :: Number -> Rehen -> Rehen
modificarComplot numero rehen = rehen {complot = complot rehen + numero} 

modificarMiedo :: Number -> Rehen -> Rehen
modificarMiedo numero rehen = rehen {miedo = miedo rehen + numero} 


type BalasRestantes = Number

ametralladora :: BalasRestantes -> Arma
ametralladora balas rehen = modificarComplot (- complot rehen `div` 2) . modificarMiedo (balas) $ rehen


-- Formas de intimidar a los rehenes

type Intimidacion = Rehen -> Ladron -> Rehen

disparos :: Rehen -> Ladron -> Rehen
disparos rehen ladron = (maximizaMiedo rehen (armas ladron)) rehen

maximizaMiedo :: Rehen -> [Arma] -> Arma
maximizaMiedo rehen armas = foldl1 (armaQueGeneraMasMiedo rehen) armas

cuantoMiedoGenera :: Arma -> Rehen -> Number
cuantoMiedoGenera arma = miedo . arma 

armaQueGeneraMasMiedo :: Rehen -> Arma -> Arma -> Arma
armaQueGeneraMasMiedo rehen arma1 arma2
    |cuantoMiedoGenera arma1 rehen > cuantoMiedoGenera arma2 rehen = arma1
    |otherwise = arma2 


hacerseElMalo :: Rehen -> Ladron -> Rehen
hacerseElMalo rehen ladron
    |nombre ladron == "Berlin" = modificarMiedo (cantidadLetrasHabilidades ladron) rehen
    |nombre ladron == "Rio" = modificarComplot 20 rehen
    |otherwise = modificarMiedo 10 rehen 

cantidadLetrasHabilidades :: Ladron -> Number
cantidadLetrasHabilidades ladron = length $ foldl1 (++) (habilidades ladron) 


-- Planes de los rehenes (pueden incluir a otro rehen)

type Plan = Ladron -> Ladron

atacarAlLadron :: Rehen -> Ladron -> Ladron
atacarAlLadron rehen ladron = quitarArmas (cantidadLetrasRehen rehen) ladron

cantidadLetrasRehen :: Rehen -> Number
cantidadLetrasRehen rehen = length (nombreRehen rehen) 

quitarArmas :: Number -> Ladron -> Ladron
quitarArmas numero ladron = ladron {armas = drop numero (armas ladron)}

esconderse :: Ladron -> Ladron 
esconderse ladron = quitarArmas (cantidadHablidades ladron) ladron

cantidadHablidades :: Ladron -> Number
cantidadHablidades ladron = length (habilidades ladron)

-- 1) Modelado de personajes

tokio = Ladron "tokio" ["trabajo psicologico", "entrar en moto"] [pistola 9, ametralladora 30]

profesor = Ladron "profesor" ["disfrazarse de linyera", "disfrazarse de payaso", "estar siempre un paso adelante"] []

pablo = Rehen "pablo" 40 30 [esconderse]

arturito = Rehen "arturito" 70 50 [esconderse, atacarAlLadron pablo]


-- 2) Saber si un ladrón es inteligente

esInteligente :: Ladron -> Bool
esInteligente ladron
    |nombre ladron == "profesor" = True
    |otherwise = cantidadHablidades ladron > 2

-- 3) Conseguir un arma nueva

conseguirArma :: Ladron -> Arma -> Ladron
conseguirArma ladron arma = aniadirArma ladron arma

aniadirArma :: Ladron -> Arma -> Ladron
aniadirArma ladron arma = ladron {armas = arma : armas ladron}

-- 4) Intimidar a rehen

-- VER TIPO
intimidarRehen ladron intimidacion rehen = intimidacion rehen ladron


-- 5) Calmar las aguas

calmarAguas :: Ladron -> [Rehen] -> [Rehen]
calmarAguas ladron rehenes = map (flip disparos ladron) $ rehenesConMasDe60DeComplot rehenes

rehenesConMasDe60DeComplot :: [Rehen] -> [Rehen]
rehenesConMasDe60DeComplot rehenes = filter ((>60) . complot) rehenes


-- 6) Puede escaparse

puedeEscaparse :: Ladron -> Bool
puedeEscaparse ladron = empiezaConDisfrazarseDe (habilidades ladron)

empiezaConDisfrazarseDe :: [String] -> Bool
empiezaConDisfrazarseDe habilidades = any (=="disfrazarse de") (primeras14LetrasDeCadaHabilidad habilidades)

primeras14LetrasDeCadaHabilidad :: [String] -> [String]
primeras14LetrasDeCadaHabilidad habilidades = map (take 14) habilidades


-- 7) La cosa pinta mal

pintaMal :: [Ladron] -> [Rehen] -> Bool
pintaMal ladrones rehenes = complotPomedio rehenes > miedoPomedio rehenes * cantidadArmasGrupo ladrones

cantidadArmasGrupo :: [Ladron] -> Number
cantidadArmasGrupo ladrones = sum . map (cantidadArmas) $ ladrones

cantidadArmas :: Ladron -> Number
cantidadArmas ladron = length (armas ladron)

--OTRA FORMA DE CONTAR ARMAS
armasLadrones :: [Ladron] -> [Arma]
armasLadrones ladrones = concatMap armas ladrones

cantidadArmasLadrones :: [Ladron] -> Number
cantidadArmasLadrones ladrones = length (armasLadrones ladrones)
--

complotPomedio :: [Rehen] -> Number
complotPomedio rehenes =  (`div` length rehenes) . sum . map (complot) $ rehenes

miedoPomedio :: [Rehen] -> Number
miedoPomedio rehenes =  (`div` length rehenes) . sum . map (miedo) $ rehenes


-- 8) Rebelarse

rebelarse :: [Rehen] -> Ladron -> Ladron
rebelarse rehenes ladron = foldl (\l p -> p l) ladron $ planesRehenes (todosPierdenComplot rehenes)

planesRehenes :: [Rehen] -> [Plan]
planesRehenes rehenes = concatMap plan rehenes

todosPierdenComplot :: [Rehen] -> [Rehen]
todosPierdenComplot rehenes = map (modificarComplot (-10)) rehenes 


-- 9) Plan Valencia

type Dinero = Number

planValencia :: [Ladron] -> [Rehen] -> Dinero
planValencia ladrones rehenes =  (*1000000) . cantidadArmasGrupo . losRehenesSeRebelanContra rehenes $ seArmanTodos ladrones

losRehenesSeRebelanContra :: [Rehen] -> [Ladron] -> [Ladron]
losRehenesSeRebelanContra rehenes ladrones = map (rebelarse rehenes) ladrones

seArmanTodos :: [Ladron] -> [Ladron]
seArmanTodos ladrones = map (flip aniadirArma (ametralladora 45)) ladrones


-- 10) ¿Se puede ejecutar el plan valencia si uno de los ladrones tiene una cantidad infinita de armas?
{-
    No, no se puede ejecutar, ya que Haskell necesita saber cuantas armas en total tiene el grupo, y si tienen infinitas armas,
    nunca se podrá saber ese número, es decir, se estaría haciendo el length de una lista infinita.
-}


-- 11) ¿Se puede ejecutar el plan valencia si uno de los ladrones tiene una cantidad infinita de habilidades?
{-
    Si, se podrá ejecutar, ya que como Haskell trabaja con Lazy Evaluation, no importa si la cantidad de habilidades es infinita, ya
    que es algo que no se necesita evaluar en el plan valencia. Es decir, Haskell tomará solo lo que necesita para poder ejecutar la
    función, en este caso, la cantidad de armas del grupo de ladrones.
-}


-- 12) Dar el tipo de la siguiente función: 

funcion cond num lista str = (> str) . sum . map (length . num) . filter (lista cond)

{-
    funcion :: b -> (a -> [c]) -> (b -> a -> Bool) -> Number -> [a] -> Bool
-}








