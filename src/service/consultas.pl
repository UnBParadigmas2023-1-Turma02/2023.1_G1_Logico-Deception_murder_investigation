:- consult('../database/suspeitos.pl').
:- consult('../database/objetos.pl').
:- consult('../database/suspeitoObjeto.pl').

consultarObjetos(Suspeito) :-
    suspeito(Suspeito),
    suspeitoObjeto(Suspeito, Objeto),
    write(Suspeito), write(' possui o objeto: '), write(Objeto), nl,
    fail.
consultarObjetos(_).