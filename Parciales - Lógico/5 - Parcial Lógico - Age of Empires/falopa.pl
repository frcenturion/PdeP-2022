
destino(pepe, alejandria).
destino(pepe, jartum).
destino(pepe, roma).
destino(juancho, roma).
destino(juancho, belgrado).
destino(lucy, roma).
destino(lucy, belgrado).

idioma(alejandria, arabe).
idioma(jartum, arabe).
idioma(belgrado, serbio).
idioma(roma, italiano).

habla(pepe, bulgaro).
habla(pepe, italiano).
habla(juancho, arabe).
habla(juancho, italiano).
habla(juancho, espaniol).
habla(lucy, griego).


granCompanieroDeViaje(Persona, OtraPersona) :-
    tienenDestinoComun(Persona, OtraPersona),
    esIdiomaDelDestino(_, Destino),
    forall(esIdiomaDelDestino(Idioma, Destino), falopa(Idioma, OtraPersona, Persona)).
    
tienenDestinoComun(Persona, OtraPersona) :-
    destino(Persona, Destino),
    destino(OtraPersona, Destino),
    Persona \= OtraPersona.
  
esIdiomaDelDestino(Idioma, Destino) :-
    idioma(Destino, Idioma),
    destino(_, Destino).
  
falopa(Idioma, OtraPersona, Persona) :-
    habla(OtraPersona, Idioma),
    not(habla(Persona, Idioma)). 
    

    granCompanieroDeViaje(Persona, OtraPersona) :-
        tienenDestinoComun(Persona, OtraPersona),
        esDestino(Persona, Destino),
        esIdiomaDelDestino(_, Destino),
        forall(esIdiomaDelDestino(Idioma, Destino), falopa(Idioma, OtraPersona, Persona)).
        
    tienenDestinoComun(Persona, OtraPersona) :-
        destino(Persona, Destino),
        destino(OtraPersona, Destino),
        Persona \= OtraPersona.
      
    esIdiomaDelDestino(Idioma, Destino) :-
        idioma(Destino, Idioma),
        destino(_, Destino).
      
    falopa(Idioma, OtraPersona, Persona) :-
        habla(OtraPersona, Idioma),
        not(habla(Persona, Idioma)),
        Persona \= OtraPersona.
        
    esDestino(Destino, Persona) :-
      destino(Persona, Destino).
    
    
    
    
    
