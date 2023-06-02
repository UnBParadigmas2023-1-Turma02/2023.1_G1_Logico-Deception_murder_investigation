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
:-dynamic quantidade_de_palpites/1.

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
  read(Option),
  option_initial_menu(Option),
  !.

option_initial_menu(0) :- reset_solution, !.
option_initial_menu(1) :- write('\e[H\e[2J'), scientist_menu, nl, !.
option_initial_menu(2) :- write('\e[H\e[2J'), show_rules, initial_menu, !.
option_initial_menu(_) :- write('\e[H\e[2J'), write('Opção inválida. Tente novamente.'), nl, fail.

% --------------------------------------------------------
% Menu de cientista forense
scientist_menu :-
  repeat,
  nl,
  write('=== MENU DO CIENTISTA FORENSE ==='), nl,
  write('1. Selecionar ou alterar assassino'), nl,
  write('2. Selecionar ou alterar arma do crime'), nl,
  write('3. Selecionar ou alterar prova do crime'), nl,
  (
    not(is_suspeito_empty),
    not(is_objeto_empty),
    not(is_vestigios_empty) ->
    write('4. Confirmar selecao e inicar partida'), nl
  ;
    true 
  ),
  write('0. Fechar'), nl, nl,
  read(Option),
  option_scientist_menu(Option),
  !.

option_scientist_menu(0) :- !.
option_scientist_menu(1) :- write('\e[H\e[2J'), select_suspeitos, !.
option_scientist_menu(2) :- write('\e[H\e[2J'), select_objeto, !.
option_scientist_menu(3) :- write('\e[H\e[2J'), select_vestigios, !.
option_scientist_menu(4) :- 
  ((not(is_suspeito_empty),not(is_objeto_empty),not(is_vestigios_empty)) ->
    detective_menu,
    true
  ;
    write('\e[H\e[2J'),
    option_scientist_menu(_),
    fail
  ).
option_scientist_menu(_) :- write('Opção inválida. Tente novamente.'), nl, fail.

% --------------------------------------------------------
% Print dos suspeitos possiveis cadastrados com um contador para 
% facilitar a escolha do usuario

select_suspeitos :-
  write('\e[H\e[2J'),
  write('========= Selecione o suspeito ========='), nl,
  nl,
  findall(Name, suspeito(_, Name), Records),
  print_records_with_counter(Records, 1),
  nl,
  read(Index),
  Index > 0,
  retractall(solucao_suspeito(_)),
  suspeito(Index, Name),
  assert(solucao_suspeito(Name)),
  write('\e[H\e[2J'),
  scientist_menu.

% --------------------------------------------------------
% Print dos objetos possiveis cadastrados com um contador para 
% facilitar a escolha do usuario

select_objeto :-
  write('\e[H\e[2J'),
  write('========= Qual arma o assassino usou? ========='), nl,
  nl,
  solucao_suspeito(Name),
  findall(X, suspeitoObjeto(Name, _, X), Records),
  print_records_with_counter(Records, 1),
  nl,
  read(Index),
  Index > 0,
  retractall(solucao_objeto(_)),
  suspeitoObjeto(Name, Index, ObjectName),
  assert(solucao_objeto(ObjectName)),
  write('\e[H\e[2J'),
  scientist_menu.

% --------------------------------------------------------
% Print dos vestigios possiveis cadastrados com um contador para 
% facilitar a escolha do usuario

select_vestigios :-
  write('\e[H\e[2J'),
  write('========= Que vestigio o assassino deixou para trás? ========='), nl,
  nl,
  solucao_suspeito(Name),
  findall(X, suspeitoVestigio(Name, _, X), Records),
  print_records_with_counter(Records, 1),
  nl,
  read(X),
  X > 0,
  retractall(solucao_vestigios(_)),
  suspeitoVestigio(Name, X, VestigioName),
  assert(solucao_vestigios(VestigioName)),
  write('\e[H\e[2J'),
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
  hint_counter(Hints),
  write('Dicas restantes: '),
  Rh is 7 - Hints,
  write(Rh), nl,
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
option_detective_menu(3) :- choose_suspect, initial_menu. % Opção 3 - Listar Objetos de um Suspeito
option_detective_menu(4) :- choose_difficulty, reset_solution, initial_menu. % Opção 4 - Realizar acusação

% Escolha suspeito %
choose_suspect :-
  write('\e[H\e[2J'),
  show_suspects,
  read(Suspect_number),
  nl,
  Suspect_number > 0,
  suspeito(Suspect_number, Suspect_name),
  show_suspect_cards(Suspect_name),
  write('\e[H\e[2J'),
  nl.

% Menu de informacoes dos suspeitos  %
show_suspect_cards(Suspect_name) :-
  write('1. Listar objetos do(a): '),
  write(Suspect_name), nl,
  write('2. Listar vestigios do(a): '),
  write(Suspect_name), nl,
  write('3. Escolher outro suspeito'), nl,
  write('4. Voltar ao menu do detetive'), nl,
  read(X), nl,
  option_type_object(X, Suspect_name),
  show_suspect_cards(Suspect_name).


% Trata as escolhas d menu de informacoes dos suspeitos %
option_type_object(1, Suspect):- show_suspect_objects(Suspect), nl.
option_type_object(2, Suspect):- show_suspect_vestigios(Suspect), nl.
option_type_object(3, _):- choose_suspect.
option_type_object(0, _):- initial_menu.

% Mostra objetos de um suspeito %
show_suspect_objects(Suspect_name) :-
  write('\e[H\e[2J'),
  write('========= Objetos de  '),
  write(Suspect_name),
  write(' ========='), nl,
  findall(X, suspeitoObjeto(Suspect_name, _, X), SuspeitoObjeto),
  print_records_with_counter(SuspeitoObjeto, 1),
  nl.

% Mostra vestigios de um suspeito %
show_suspect_vestigios(Suspect_name) :-
  write('\e[H\e[2J'),
  write('========= Vestigios de '),
  write(Suspect_name),
  write(' ========='), nl,
  findall(X, suspeitoVestigio(Suspect_name, _, X), SuspeitoVestigio),
  print_records_with_counter(SuspeitoVestigio, 1),
  nl.


% --------------------------------------------------------
% Compara o palpite com as soluções fornecidas

palpite :-
  write('\e[H\e[2J'),
  nl,
  write('\e[H\e[2J'),
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
  write('\e[H\e[2J'),
  nl,
  % Obtem dois tipos aleatórios dos possiveis: causa_de_morte, local_crime, clima, acontecimento_repentino, 
  % vitima_fazia, ocupacao_da_vitima, duracao_crime, roupas_da_vitima, impressao_geral, estado_da_cena,
  % vestigio_na_cena, relacionamento_social, condicao_do_corpo, indicacao_no_corpo, motivacao_do_crime,
  % porte_da_vitima, dia_do_crime, evidencia_deixada, identidade_vitima, expressao_da_vitima
  get_random_hints(HintAType, HintBType),
  increment_hint_counter,
  write('\e[H\e[2J'),
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
  write('\e[H\e[2J'),
  hints(X,Y),
  write(X),
  write(' ('),
  write(Y),
  write(')'),
  nl,
  fail.

% O usuario escolhe quem foi o assassino, o objeto usado e o vestigio deixado por ele.
accuse_suspect :-
  write('\e[H\e[2J'),
  show_suspects,  
  write("Escolha o Assassino:"), nl,
  read(X),
  suspeito(X, PlayerSuspect),
  write('\e[H\e[2J'),
  show_objects_by_suspect(PlayerSuspect),
  write("Escolha o Objeto:"), nl,
  read(Y),
  suspeitoObjeto(PlayerSuspect, Y, PlayerObject),
  write('\e[H\e[2J'),
  show_vestigios_by_suspect(PlayerSuspect),
  write("Escolha o Vestigio"), nl,
  read(Z),
  suspeitoVestigio(PlayerSuspect, Z, PlayerVestigio),
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
  write('\e[H\e[2J'),
  write('========= Selecione o suspeito '),
  write('========='), nl,
  findall(X, suspeito(_, X), Suspeitos),
  print_records_with_counter(Suspeitos, 1),
  nl.

show_objects_by_suspect(Name) :- 
  write('\e[H\e[2J'),
  write('========= Selecione o objeto usado como arma '),
  write('========='), nl,
  findall(ObjectName, suspeitoObjeto(Name, _, ObjectName), Objetos),
  print_records_with_counter(Objetos, 1),
  nl.

show_vestigios_by_suspect(Name) :-
  write('\e[H\e[2J'),
  write('========= Selecione o vestigio deixado para tras '),
  write('========='), nl,
  findall(VestigioName, suspeitoVestigio(Name, _, VestigioName), Vestigios),
  print_records_with_counter(Vestigios, 1),
  nl.

check_solution(Suspect, Object, Vestigio) :-
  solucao_suspeito(Suspect),
  solucao_objeto(Object),
  solucao_vestigios(Vestigio).

reset_solution :-
  retractall(solucao_suspeito(_)),
  retractall(solucao_objeto(_)),
  retractall(solucao_vestigios(_)).

choose_difficulty :-
  nl,
  write('=== NÍVEL DE DIFICULDADE ==='), nl,
  write('1. Fácil'), nl,
  write('2. Médio'), nl,
  write('3. Difícil'), nl,
  nl,
  read(Option),
  option_choose_difficulty(Option),
  !.

option_choose_difficulty(3) :- loop_accuse(1).
option_choose_difficulty(2) :- loop_accuse(3).
option_choose_difficulty(1) :- loop_accuse(6).


loop_accuse(Option) :-
  Option > 0,
  Next_option is Option - 1, 
  write('Acusação '), write(Option), write(':'), 
  accuse_suspect, loop_accuse(Next_option).