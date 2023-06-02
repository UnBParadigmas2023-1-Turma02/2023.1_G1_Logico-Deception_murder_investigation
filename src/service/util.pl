:- consult('../rules.pl').
:- consult('../database/suspeitos.pl').
:- consult('../database/objetos.pl').
:- consult('../database/vestigios.pl').
:- consult('../database/suspeitoObjeto.pl').
:- consult('../database/suspeitoVestigio.pl').
:- consult('../database/dicas.pl').
:- consult('util.pl').

% ---------------- Faz o print dos registros com um contador ---------------------------------------------------

print_records_with_counter([], _).
print_records_with_counter([Record|Rest], Counter) :-
  write(Counter),
  write('. '),
  write(Record),
  nl,
  NextCounter is Counter + 1,
  print_records_with_counter(Rest, NextCounter).

% ---------------------- Escolha do suspeito ---------------------
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


% ----------------------------------- O usuario escolhe quem foi o assassino, o objeto usado e o vestigio deixado por ele.
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


% ----------- verifica se o palpite bate com a solucao --------------

check_solution(Suspect, Object, Vestigio) :-
  solucao_suspeito(Suspect),
  solucao_objeto(Object),
  solucao_vestigios(Vestigio).


% ----------- reseta a solucao apra um novo jogo --------------

reset_solution :-
  retractall(solucao_suspeito(_)),
  retractall(solucao_objeto(_)),
  retractall(solucao_vestigios(_)).