:- consult('rules.pl').

initial_menu :-
    repeat,
    write('=== MENU ==='), nl,
    write('1. Novo Jogo'), nl,
    write('2. Regras'), nl,
    write('0. Fechar'), nl,
    read(X),
    option(X),
    X == 0,
    !.

option(0) :- !.
option(1) :- write('Iniciar Jogo'), nl, !.
option(2) :- show_rules, !.
option(_) :- write('Opção inválida. Tente novamente.'), nl, !.