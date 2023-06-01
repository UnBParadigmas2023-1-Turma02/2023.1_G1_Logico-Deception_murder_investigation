% Faz a consulta nas bases do arquivo de regras, suspeitos, objetos e vestigios
:- consult('rules.pl').
:- consult('database/suspeitos.pl').
:- consult('database/objetos.pl').
:- consult('database/vestigios.pl').
:- consult('database/suspeitoObjeto.pl').
:- consult('database/suspeitoVestigio.pl').

:-dynamic solucao_suspeito/1.
:-dynamic solucao_objeto/1.
:-dynamic solucao_vestigios/1.

is_suspeito_empty :-
  \+ solucao_suspeito(_).

is_objeto_empty :-
  \+ solucao_objeto(_).

is_vestigios_empty :-
  \+ solucao_vestigios(_).

get_nth_value(Predicate, N, Value) :-
  findall(X, call(Predicate, X), List),
  nth1(N, List, Value).

% --------------------------------------------------------
% Menu inicial da aplicação
initial_menu :-
  repeat,
  nl,
  write('=== MENU ==='), nl,
  write('1. Novo Jogo'), nl,
  write('2. Regras'), nl,
  write('0. Fechar'), nl, nl,
  read(X),
  option_initial_menu(X),
  !.

option_initial_menu(0) :- !.
option_initial_menu(1) :- scientist_menu, nl, !.
option_initial_menu(2) :- show_rules, !.
option_initial_menu(_) :- write('Opção inválida. Tente novamente.'), nl, fail.
% --------------------------------------------------------
% Menu de cientista forense
scientist_menu :-
  repeat,
  nl,
  write('=== MENU DO CIENTISTA FORENSE ==='), nl,
  write('1. Selecionar assassino'), nl,
  write('2. Selecionar arma do crime'), nl,
  write('3. Selecionar prova do crime'), nl,
  (
    not(is_suspeito_empty),
    not(is_objeto_empty),
    not(is_vestigios_empty) ->
    write('4. Continuar'), nl
  ;
    true 
  ),
  write('0. Fechar'), nl, nl,
  read(X),
  option_scientist_menu(X),
  !.
option_scientist_menu(0) :- !.
option_scientist_menu(1) :- print_suspeitos, !.
option_scientist_menu(2) :- print_objeto, !.
option_scientist_menu(3) :- print_vestigios, !.
option_scientist_menu(4) :- 
  ((not(is_suspeito_empty),not(is_objeto_empty),not(is_vestigios_empty)) ->
    detective_menu,
    true
  ;
    option_scientist_menu(_),
    fail
  ).
option_scientist_menu(_) :- write('Opção inválida. Tente novamente.'), nl, fail.
% --------------------------------------------------------
% Print dos suspeitos possiveis cadastrados com um contador para 
% facilitar a escolha do usuario
print_suspeitos :-
  nl,
  findall(Name, suspeito(_, Name), Records),
  print_records_with_counter(Records, 1),
  nl,
  read(X),
  X > 0,
  retractall(solucao_suspeito(_)),
  suspeito(X, Name),
  assert(solucao_suspeito(Name)),
  scientist_menu.
% --------------------------------------------------------
% Print dos objetos possiveis cadastrados com um contador para 
% facilitar a escolha do usuario
print_objeto :-
  nl,
  solucao_suspeito(Y),
  findall(X, suspeitoObjeto(Y, _, X), Records),
  print_records_with_counter(Records, 1),
  nl,
  read(X),
  X > 0,
  retractall(solucao_objeto(_)),
  suspeitoObjeto(Y, X, ObjectName),
  assert(solucao_objeto(ObjectName)),
  scientist_menu.
% --------------------------------------------------------
% Print dos vestigios possiveis cadastrados com um contador para 
% facilitar a escolha do usuario
print_vestigios :-
  nl,
  solucao_suspeito(Y),
  findall(X, suspeitoVestigio(Y, _, X), Records),
  print_records_with_counter(Records, 1),
  nl,
  read(X),
  X > 0,
  retractall(solucao_vestigios(_)),
  suspeitoVestigio(Y, X, VestigioName),
  assert(solucao_vestigios(VestigioName)),
  scientist_menu.

% --------------------------------------------------------
% Faz o print dos registros com um contador
print_records_with_counter([], _).
print_records_with_counter([Record|Rest], Counter) :-
  write(Counter),
  write('. '),
  write(Record),
  nl,
  NextCounter is Counter + 1,
  print_records_with_counter(Rest, NextCounter).
% --------------------------------------------------------
detective_menu :-
  repeat,
  nl,
  write('=== MENU DO DETETIVE ==='), nl,
  write('1. Pedir dica'), nl,
  write('2. Listar objetos e vestigios de um suspeito'), nl,
  write('3. Realizar acusação'), nl,
  write('0. Voltar'), nl, nl,
  read(X),
  option_detective_menu(X),
  !.

% --------------------------------------------------------
option_detective_menu(0) :- nl,  % Opção 0 - Voltar ao menu de cientista
scientist_menu.
option_detective_menu(1) :- % Opção 1 - Pedir dica
  % Lógica para pedir dica
  nl,
  write('Pedindo dica...'), nl,
  detective_menu.
option_detective_menu(2) :- % Opção 2 - Listar objetos e vestigios de um suspeito
  nl,
  option_scientist_menu(2), % Lógica para listar objetos e vestigios através da option_scientist_menu, com valor atômico 2 
  detective_menu.
option_detective_menu(3) :- % Opção 3 - Realizar acusação
  palpite, % Chamada da função palpite
  detective_menu.
option_detective_menu(_) :- % Opção inválida
  write('Opção inválida. Tente novamente.'), nl,
  fail.

% --------------------------------------------------------
% Compara o palpite com as soluções fornecidas

palpite :-
  nl,
  write('=== PALPITE ==='), nl,
  write('Digite seu palpite para suspeito: '), nl,
  read(PalpiteSuspeito),
  write('Digite seu palpite para objeto: '), nl,
  read(PalpiteObjeto),
  write('Digite seu palpite para vestígio: '), nl,
  read(PalpiteVestigio),
  nl,
  (
    solucao_suspeito(PalpiteSuspeito),
    solucao_objeto(PalpiteObjeto),
    solucao_vestigios(PalpiteVestigio) ->
    write('Você ACERTOU o palpite!'), nl
  ;
    write('Você ERROU o palpite!'), nl
  ),
  nl,
  write('=== FIM DO JOGO ==='), nl, initial_menu.
