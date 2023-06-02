:- consult('../rules.pl').
:- consult('../database/suspeitos.pl').
:- consult('../database/objetos.pl').
:- consult('../database/vestigios.pl').
:- consult('../database/suspeitoObjeto.pl').
:- consult('../database/suspeitoVestigio.pl').
:- consult('../database/dicas.pl').


% ------------ Print dos suspeitos possiveis cadastrados com um contador para facilitar a escolha do usuario ------------------------

print_suspeitos :-
  write('\e[H\e[2J'),
  write('========= Selecione o suspeito '),
  write('========='), nl,
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


% --------------- Print dos objetos possiveis cadastrados com um contador para facilitar a escolha do usuario -----------------------

print_objeto :-
  write('\e[H\e[2J'),
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


% --------------- Print dos vestigios possiveis cadastrados com um contador para facilitar a escolha do usuario -------------------

print_vestigios :-
  write('\e[H\e[2J'),
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


% ---------------- Faz o print dos registros com um contador ---------------------------------------------------

print_records_with_counter([], _).
print_records_with_counter([Record|Rest], Counter) :-
  write(Counter),
  write('. '),
  write(Record),
  nl,
  NextCounter is Counter + 1,
  print_records_with_counter(Rest, NextCounter).


% ----------------- Mostra objetos de um suspeito ------------------------------------

show_suspect_objects(Suspect_name) :-
  write('\e[H\e[2J'),
  write('========= Objetos de  '),
  write(Suspect_name),
  write('========='), nl,
  findall(X, suspeitoObjeto(Suspect_name, _, X), SuspeitoObjeto),
  print_records_with_counter(SuspeitoObjeto, 1),
  nl.


% ------------------ Mostra vestigios de um suspeito ----------------------------------

show_suspect_vestigios(Suspect_name) :-
  write('\e[H\e[2J'),
  write('========= Objetos de  '),
  write(Suspect_name),
  write('========='), nl,
  findall(X, suspeitoVestigio(Suspect_name, _, X), SuspeitoVestigio),
  print_records_with_counter(SuspeitoVestigio, 1),
  nl.


% -------------------  Listagem de todas as dicas ja fornecidas ------------------------
list_hints :-
  write('\e[H\e[2J'),
  hints(X,Y),
  write(X),
  write(' ('),
  write(Y),
  write(')'),
  nl,
  fail.

% -------------- LISTAGENS -------------------

show_suspects :-
  write('\e[H\e[2J'),
  write('========= Selecione o suspeito '),
  write('========='), nl,
  findall(X, suspeito(_, X), Suspeitos),
  print_records_with_counter(Suspeitos, 1),
  nl.

show_objects_by_suspect(Name) :- 
  write('\e[H\e[2J'),
  write('========= Selecione o objeto '),
  write('========='), nl,
  findall(X, suspeitoObjeto(Name, _, X), Objetos),
  print_records_with_counter(Objetos, 1),
  nl.

show_vestigios_by_suspect(Name) :-
  write('\e[H\e[2J'),
  write('========= Selecione o vestigio deixado '),
  write('========='), nl,
  findall(X, suspeitoVestigio(Name, _, X), Vestigios),
  print_records_with_counter(Vestigios, 1),
  nl.


