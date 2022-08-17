% 12 - Parcial Lógico - Predictivo

% mensaje(ListaDePalabras, Receptor).
%	Los receptores posibles son:
%	Persona: un simple átomo con el nombre de la persona; ó
%	Grupo: una lista de al menos 2 nombres de personas que pertenecen al grupo.
mensaje(['hola', ',', 'qué', 'onda', '?'], nico).
mensaje(['todo', 'bien', 'dsp', 'hablamos'], nico).
mensaje(['q', 'parcial', 'vamos', 'a', 'tomar', '?'], [nico, lucas, maiu]).
mensaje(['todo', 'bn', 'dsp', 'hablamos'], [nico, lucas, maiu]).
mensaje(['todo', 'bien', 'después', 'hablamos'], mama).
mensaje(['¿','y','q', 'onda', 'el','parcial', '?'], nico).
mensaje(['¿','y','qué', 'onda', 'el','parcial', '?'], lucas).

% abreviatura(Abreviatura, PalabraCompleta) relaciona una abreviatura con su significado.
abreviatura('dsp', 'después').
abreviatura('q', 'que').
abreviatura('q', 'qué').
abreviatura('bn', 'bien').

% signo(UnaPalabra) indica si una palabra es un signo.
signo('¿').    signo('?').   signo('.').   signo(','). 

% filtro(Contacto, Filtro) define un criterio a aplicar para las predicciones para un contacto
filtro(nico, masDe(0.5)).
filtro(nico, ignorar(['interestelar'])).
filtro(lucas, masDe(0.7)).
filtro(lucas, soloFormal).
filtro(mama, ignorar(['dsp','paja'])).


% 1) Recibio mensaje

recibioMensaje(Persona, Mensaje) :-
    mensaje(Mensaje, Personas),
    member(Persona, Personas).
recibioMensaje(Persona, Mensaje) :-
    mensaje(Mensaje, Persona).


% 2) Demasiado formal

primeraPalabra([Primera|_], Primera).

demasiadoFormal(Mensaje) :-
    mensaje(Mensaje, _),
    longitudMayorA20(Mensaje),
    not(tieneAbreviaturas(Mensaje)).
demasiadoFormal(Mensaje) :-
    primeraPalabra(Mensaje, '¿'),
    not(tieneAbreviaturas(Mensaje)).
    
longitudMayorA20(Mensaje) :-
    length(Mensaje, LongitudMensaje),
    LongitudMensaje > 20.

tieneAbreviaturas(Mensaje) :-
    abreviatura(Abreviatura, _),
    member(Abreviatura, Mensaje).


% 3) Es aceptable

esAceptable(Palabra, Persona) :-
    filtro(Persona, Tipo),
    pasaFiltro(Palabra, Tipo).

/* pasaFiltro(Palabra, masDe(N)) :-
    tasaDeUso(Palabra, Persona, Tasa),
    Tasa > N. */
pasaFiltro(Palabra, ignorar(Lista)) :-
    not(member(Palabra, Lista)).
pasaFiltro(Palabra, soloFormal) :-
    demasiadoFormal(Mensaje),
    member(Palabra, Mensaje).




cantidadDeApariciones(Palabra, Persona, Palabras) :-
    findall(Palabra, (recibioMensaje(Persona, Mensaje), member(Palabra, Mensaje)), Palabras).






% 4) Dicen lo mismo

/* dicenLoMismo(Mensaje, OtroMensaje) :-
    mensaje(Mensaje, _),
    mensaje(OtroMensaje, _),
    sonIgualesOEquivalentes(Mensaje, OtroMensaje).
 */


% 5) Frase célebre

%fraseCelebre(Mensaje) :-



% 6) Prediccion


