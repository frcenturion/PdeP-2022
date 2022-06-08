module Library where
import PdePreludat


-- 1 -- Modelado de turista y ejemplos

type Idioma = String

data Turista = UnTurista {
    cansancio :: Number,
    stress :: Number,
    viajaSolo :: Bool,
    idiomas :: [Idioma]
} deriving (Show, Eq)


ana = UnTurista {cansancio = 0, stress = 21, viajaSolo = False, idiomas = ["Espaniol"]}

beto = UnTurista {cansancio = 15, stress = 15, viajaSolo = True, idiomas = ["Aleman"]}

cathi = UnTurista {cansancio = 15, stress = 15, viajaSolo = True, idiomas = ["Aleman", "Catalan"]}

-- 2 -- Modelado de excursiones

type Excursion = Turista -> Turista

irALaPlaya :: Excursion
irALaPlaya turista 
    | viajaSolo turista = turista {cansancio = cansancio turista - 5}
    | otherwise = turista {stress = stress turista - 1} 

apreciarAlgunElementoDelPaisaje :: String -> Excursion
apreciarAlgunElementoDelPaisaje elemento turista = turista {stress = stress turista - length elemento}

saleAHablarIdioma :: String -> Excursion
saleAHablarIdioma idioma turista = turista {viajaSolo = viajaSolo turista == True, idiomas = idioma : idiomas turista}

caminarMinutos :: Number -> Excursion
caminarMinutos minutos turista = turista {cansancio = cansancio turista + intensidadCaminata minutos, stress = stress turista - intensidadCaminata minutos}

intensidadCaminata :: Number -> Number
intensidadCaminata minutos = div minutos 4

data Marea 
    = Tranquila
    | Moderada
    | Fuerte

paseoEnBarco :: Marea -> Excursion
paseoEnBarco Fuerte turista = turista {stress = stress turista + 6, cansancio = cansancio turista + 10}
paseoEnBarco Moderada turista = turista
paseoEnBarco Tranquila turista = ((caminarMinutos 10).(apreciarAlgunElementoDelPaisaje "mar").(saleAHablarIdioma "aleman"))turista

-- a)

hacerExcursion :: Excursion -> Turista -> Turista
hacerExcursion excursion turista = (reducirStressEn10 . excursion) turista

reducirStressEn10 :: Turista -> Turista
reducirStressEn10 turista = turista {stress = stress turista - (stress turista * 0.10)}

-- b)

deltaSegun :: (a -> Number) -> a -> a -> Number
deltaSegun f algo1 algo2 = f algo1 - f algo2

type Indice = Turista -> Number

deltaExcursionSegun :: Indice -> Turista -> Excursion -> Number
deltaExcursionSegun indice turista excursion = deltaSegun indice (hacerExcursion excursion turista) turista


-- c)

-- i 

cantidadIdiomas :: Turista -> Number 
cantidadIdiomas turista = length (idiomas turista)

esExcursionEducativa :: Turista -> Excursion -> Bool
esExcursionEducativa turista excursion = deltaExcursionSegun cantidadIdiomas turista excursion > 0

-- ii

excursionesDesestresantes :: Turista -> [Excursion] -> [Excursion]
excursionesDesestresantes turista excursiones = filter (esExcursionDesestresante turista) excursiones

esExcursionDesestresante :: Turista -> Excursion -> Bool
esExcursionDesestresante turista excursion = deltaExcursionSegun stress turista excursion <= -3


-- 3

type Tour = [Excursion]

completo :: Tour
completo = [caminarMinutos 20, apreciarAlgunElementoDelPaisaje "cascada", caminarMinutos 40, saleAHablarIdioma "melmacquiano"]

ladoB :: Excursion -> Tour
ladoB excursionElegida = [paseoEnBarco Tranquila, hacerExcursion excursionElegida, caminarMinutos 120]

islaVecina :: Marea -> Tour
islaVecina mareaVecina = [paseoEnBarco mareaVecina, excursionEnIslaVecina mareaVecina, paseoEnBarco mareaVecina]

excursionEnIslaVecina :: Marea -> Excursion
excursionEnIslaVecina Fuerte = apreciarAlgunElementoDelPaisaje "lago"
excursionEnIslaVecina _  = irALaPlaya

-- a)

hacerTour :: Turista -> Tour -> Turista
hacerTour turista tour = foldl (flip hacerExcursion) (aumentarStressTour turista tour) tour

aumentarStressTour :: Turista -> Tour -> Turista
aumentarStressTour turista tour = turista {stress = stress turista + length tour}

-- b)

esPropuestaConvincente :: Turista -> [Tour] -> Bool
esPropuestaConvincente turista conjuntoTour = any (esTourConvincente turista) conjuntoTour

esTourConvincente :: Turista -> Tour -> Bool
esTourConvincente turista tour = any (dejaAcompaniado turista) (excursionesDesestresantes turista tour)

dejaAcompaniado :: Turista -> Excursion -> Bool
dejaAcompaniado turista excursion = viajaSolo (hacerExcursion excursion turista) == False

-- c)

efectividadTour :: [Turista] -> Tour -> Number
efectividadTour conjuntoTuristas tour = (sum . map (espiritualidadAportada tour) . filter (flip esTourConvincente tour)) conjuntoTuristas

espiritualidadAportada :: Tour -> Turista -> Number
espiritualidadAportada tour turista = abs (perdidaCansancioStressDespuesDeTour tour turista)

perdidaCansancioStressDespuesDeTour :: Tour -> Turista -> Number
perdidaCansancioStressDespuesDeTour tour turista = deltaSegun sumaCansancioStress (hacerTour turista tour) turista 

sumaCansancioStress :: Turista -> Number
sumaCansancioStress turista = stress turista + cansancio turista

-- 4

-- a)

tourInfinitasPlayas :: Tour
tourInfinitasPlayas = repeat irALaPlaya

{- -- b)

Para el caso de Ana, es posible saber si el tour de inifitas playas es convincente, dado que la primera actividad que evalúa
ya es desestresante y siempre está acompañada.

En cambio, en el caso de Beto, no es posible saber si el tour de infinitas playas es convincente, ya que nunca se cumplirá al menos la primera
condición, que es que esté acompañado. Entonces, Haskell se quedará evaluando infinitamente los tours y ninguno lo dejará acompañado, por lo
que nunca terminará de evaluar.

-- c)

Solamente se podrá conocer la efectividad de un tour cuando le mandemos una lista vacía de turistas. En este caso, la efectividad será 0.
Para los otros casos, como se debe evaluar la espiritualidad aportada de cada tour (lo que implica hacer operaciones), Haskell no puede 
conocer la efectividad porque se quedará haciendo operaciones infinitamente.

 -}

