% 15 - Parcial Lógico - Influencers

% 1) Modelado de usuarios

% usuario(nombre, red social, seguidores)
usuario(ana, youtube, 3000000).
usuario(ana, instagram, 2700000).
usuario(ana, tiktok, 1000000).
usuario(ana, twitch, 2).
usuario(beto, twitch, 120000).
usuario(beto, youtube, 6000000).
usuario(beto, instagram, 1100000).
usuario(cami, tiktok, 2000).
usuario(dani, youtube, 1000000).
usuario(evelyn, instagram, 1).


% 2) Sobre los influencers

% a) Influencer

influencer(Usuario) :-
    usuario(Usuario, _, _),
    seguidoresTotales(Usuario, SeguidoresTotales),
    SeguidoresTotales > 10000.

seguidoresTotales(Usuario, SeguidoresTotales) :-
    findall(Seguidores, usuario(Usuario, _, Seguidores), ListaSeguidoresTotales),
    sum_list(ListaSeguidoresTotales, SeguidoresTotales).


% b) Omnipresente

omnipresente(Usuario) :-
    influencer(Usuario),
    forall(redExistente(Red), usuario(Usuario, Red, _)).

redExistente(Red) :-
    usuario(_, Red, _).
    

% c) Exclusivo

exclusivo(Usuario) :-
    influencer(Usuario),
    not(estaEnMasDeUnaRed(Usuario)).

estaEnMasDeUnaRed(Usuario) :-
    usuario(Usuario, Red, _),
    usuario(Usuario, OtraRed, _),
    Red \= OtraRed.


% 3) Contenidos

% video([quienesAparecen], duracion).
% foto([quienesAparecen]).
% stream(tematica).

% a) Modelado de contenidos

publico(ana, tiktok, video([beto, evelyn], 1)).
publico(ana, tiktok, video([ana], 1)).
publico(ana, instagram, foto([ana])).
publico(beto, instragram, foto([])).
publico(cami, twitch, stream(leagueOfLegends)).
publico(cami, youtube, video([cami], 5)).
publico(evelyn, instagram, foto([evelyn, cami])).

% b) Temática relacionadas con juegos

tematica(juegos, leagueOfLegends).
tematica(juegos, minecraft).
tematica(juegos, aoe).


% 4) Adictiva

redSocial(Red) :-
    usuario(_, Red, _).

adictiva(Red) :-
    redSocial(Red),
    forall(publico(_, Red, Contenido), esAdictivo(Contenido)).

esAdictivo(video(_, Minutos)) :-
    Minutos < 3.
esAdictivo(stream(Tematica)) :-
    tematica(juegos, Tematica).
esAdictivo(foto(Participantes)) :-
    length(Participantes, CantidadParticipantes),
    CantidadParticipantes < 4.


% 5) Colaboran

colaboran(Colaborador, Usuario) :- colabora(Colaborador, Usuario).
colaboran(Colaborador, Usuario) :- colabora(Usuario, Colaborador).
    
colabora(Colaborador, Usuario) :-
    publico(Usuario, _, Contenido),
    personasQueAparecen(Contenido, PersonasQueAparecen),
    member(Colaborador, PersonasQueAparecen),
    Colaborador \= Usuario.

personasQueAparecen(video(PersonasQueAparecen, _), PersonasQueAparecen).
personasQueAparecen(foto(PersonasQueAparecen), PersonasQueAparecen).


% 6) Camino a la fama

caminoALaFama(Usuario) :-
    colabora(Usuario, OtroUsuario),    % Influencer publica contenido donde aparece el usuario
    not(influencer(Usuario)),
    Usuario \= OtroUsuario,
    influencerOEnCamino(OtroUsuario).

influencerOEnCamino(OtroUsuario) :-
    influencer(OtroUsuario).
influencerOEnCamino(OtroUsuario) :-
    caminoALaFama(OtroUsuario).
% 7) 

% a) Hacer al menos un test que pruebe que una consulta existencial sobre alguno de los puntos funcione correctamente.

:- begin_tests(influencer).
test(usuarios_que_son_influencers, set(Usuario = [ana, beto, dani])) :-
    influencer(Usuario).
:- end_tests(influencer).


% b) ¿Qué hubo que hacer para modelar que beto no tiene tiktok? Justificar conceptualmente.

/*
    Al no escribirlo en la base de conocimiento, se considera un hecho falso, por el principio de Universo Cerrado. Todo lo que no esté 
    explicitado en la base de conocimiento, es falso por el hecho de no pertenecer al universo existencial del programa.
*/



