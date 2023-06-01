% Faz a consulta nas bases do arquivo de regras, suspeitos, objetos e vestigios
:- consult('rules.pl').
:- consult('database/suspeitos.pl').
:- consult('database/objetos.pl').
:- consult('database/vestigios.pl').
:- consult('database/suspeitoObjeto.pl').
:- consult('database/suspeitoVestigio.pl').
:- consult('database/dicas.pl').

% --------------------------------------------------------

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

:- dynamic hint_counter/1.
hint_counter(0).

get_hint_counter(Count) :-
  hint_counter(Count).

increment_hint_counter :-
  retract(hint_counter(OldCount)),
  NewCount is OldCount + 1,
  assert(hint_counter(NewCount)).

% --------------------------------------------------------

:- dynamic hints/2.
add_hint(Hint, Type) :-
  assert(hints(Hint, Type)).

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
  write('2. Listar dicas'), nl,
  write('3. Listar objetos e vestigios de um suspeito'), nl,
  write('4. Realizar acusação'), nl,
  write('0. Voltar'), nl, nl,
  read(X),
  option_detective_menu(X),
  !.

option_detective_menu(0) :- nl, scientist_menu. % Opção 0 - Voltar ao menu de cientista
option_detective_menu(1) :- get_hint_counter(Count), nl, ( Count < 7 -> hint_menu ; write('Você não pode mais pedir dicas!'), nl, detective_menu ), !.
option_detective_menu(2) :- get_hint_counter(Count), nl, ( Count > 0 -> list_hints ; write('Nenhuma dica disponivel') ), nl, detective_menu, !. % Opção 2 - Listar objetos e vestigios de um suspeito
option_detective_menu(4) :- accuse_suspect, initial_menu. % Opção 4 - Realizar acusação

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

% Menu de dica
hint_menu :-
  nl,
  % Obtem dois tipos aleatórios dos possiveis: causa_de_morte, local_crime, clima, acontecimento_repentino, 
  % vitima_fazia, ocupacao_da_vitima, duracao_crime, roupas_da_vitima, impressao_geral, estado_da_cena,
  % vestigio_na_cena, relacionamento_social, condicao_do_corpo, indicacao_no_corpo, motivacao_do_crime,
  % porte_da_vitima, dia_do_crime, evidencia_deixada, identidade_vitima, expressao_da_vitima
  get_random_hints(HintAType, HintBType),
  increment_hint_counter,
  write('=== SELECAO DE DICA ==='), nl,
  write('1. '),
  write(HintAType), nl,
  write('2. '),
  write(HintBType), nl, 
  nl,
  read(HintChoice),
  ( HintChoice == 1 -> findall(X, tipoDeDica(X, _, HintAType), Records), SelectedHintType = HintAType ; findall(X, tipoDeDica(X, _, HintBType), Records), SelectedHintType = HintBType ),
  print_records_with_counter(Records, 1),
  nl,
  read(Y),
  tipoDeDica(Hint, Y, SelectedHintType),
  add_hint(Hint, SelectedHintType),
  nl,
  detective_menu.

% Obtem dois tipos diferentes de dicas
get_random_hints(HintAType, HintBType) :-
  repeat,
	findall((X, Y), tipoDeDica(X, _, Y), Hints),
  random_select((_, HintAType), Hints, RemainingHints),
  random_select((_, HintBType), RemainingHints, _),
  dif(HintAType, HintBType),
	!.

% Listagem de todas as dicas ja fornecidas
list_hints :-
  hints(X,Y),
  write(X),
  write(' ('),
  write(Y),
  write(')'),
  nl,
  fail.

% O usuario escolhe quem foi o assassino, o objeto usado e o vestigio deixado por ele.
accuse_suspect :-
  write("Escolha o Assassino:"), nl,
  show_suspects,  
  read(X),
  suspeito(X, PlayerSuspect),

  write("Escolha o Objeto:"), nl,
  show_objects,
  read(Y),
  objeto(Y, PlayerObject),
  
  write("Escolha o Vestigio"), nl,
  show_vestigios,
  read(Z),
  vestigios(Z, PlayerVestigio),
  nl,
  ( 
    check_solution(PlayerSuspect, PlayerObject, PlayerVestigio) -> 
      write('Correto!! Parabéns :D') 
      ; 
      solucao_suspeito(SuspectSolution), solucao_objeto(ObjectSolution), solucao_vestigios(VestigioSolution), write('Errado =('), nl, write('Resposta: '), write('O assassino foi '), write(SuspectSolution), write(' com '), write(ObjectSolution), write(' deixando '), write(VestigioSolution), write(' como vestigio') 
  ),
  nl,
  nl.

show_suspects :-
  findall(X, suspeito(_, X), Suspeitos),
  print_records_with_counter(Suspeitos, 1),
  nl.

show_objects :- 
  findall(X, objeto(_, X), Objetos),
  print_records_with_counter(Objetos, 1),
  nl.

show_vestigios :-
  findall(X, vestigios(_, X), Vestigios),
  print_records_with_counter(Vestigios, 1),
  nl.

check_solution(Suspect, Object, Vestigio) :-
  solucao_suspeito(Suspect),
  solucao_objeto(Object),
  solucao_vestigios(Vestigio).