% Faz a consulta nas bases do arquivo de regras, suspeitos, objetos e vestigios
:- consult('rules.pl').
:- consult('suspeito.pl').
:- consult('objetos.pl').
:- consult('vestigios.pl').

:-dynamic solucao_suspeito/1.
:-dynamic solucao_objeto/1.
:-dynamic solucao_vestigios/1.

is_suspeito_empty :-
  \+ solucao_suspeito(_).

is_objeto_empty :-
  \+ solucao_objeto(_).

is_vestigios_empty :-
  \+ solucao_vestigios(_).

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
  findall(Name, suspeito(Name), Records),
  print_records_with_counter(Records, 1),
  nl,
  read(X),
  X > 0,
  retractall(solucao_suspeito(_)),
  assert(solucao_suspeito(X)),
  scientist_menu.
% --------------------------------------------------------
% Print dos objetos possiveis cadastrados com um contador para 
% facilitar a escolha do usuario
print_objeto :-
  nl,
  findall(Name, objeto(Name), Records),
  print_records_with_counter(Records, 1),
  nl,
  read(X),
  X > 0,
  retractall(solucao_objeto(_)),
  assert(solucao_objeto(X)),
  scientist_menu.
% --------------------------------------------------------
% Print dos vestigios possiveis cadastrados com um contador para 
% facilitar a escolha do usuario
print_vestigios :-
  nl,
  findall(Name, vestigios(Name), Records),
  print_records_with_counter(Records, 1),
  nl,
  read(X),
  X > 0,
  retractall(solucao_vestigios(_)),
  assert(solucao_vestigios(X)),
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
  option_scientist_menu(X),
  !.

list_objects_from_suspect(Suspect) :-
  