:- use_module(library(pce)).

:- pce_begin_class(minha_janela, frame).

:- dynamic solucao_suspeito/1.

initialise(F, Label) :->
    send_super(F, initialise(Label)),
    send(F, size, size(300, 200)).

:- pce_end_class.

:- pce_begin_class(botao_prolog, button).

initialise(B, Label) :->
    send_super(B, initialise(Label)),
    send(B, message, message(@prolog, escrever_mensagem)).

escrever_mensagem(_) :->
    write('O botão foi pressionado!'), nl.

:- pce_end_class.

criar_pagina_regras :-
    new(PaginaRegras, dialog('Regras')),
    new(TituloRegras, text('Regras')),
    send(TituloRegras, font, font(bold, italic, 28)),
    send(PaginaRegras, append, TituloRegras),
    send(PaginaRegras, append, new(TextoRegras, text(
  'O jogo é baseado em Deception: Murder in Hong Kong, com algumas alterações. Nossa versão
  possui algumas diferenças em relação ao jogo original. Nela, há um mínimo de 2 jogadores,
  podendo chegar a até 6 rodadas (no jogo original, o mínimo são 4 jogadores, com um máximo
  de 3 rodadas).

  Um jogador assumirá o papel de cientista forense, enquanto os demais assumirão o papel de
  detetive(s). O papel do cientista forense consiste em ajudar os detetives responsáveis por
  descobrir o assassino, sendo também responsável por definir a solução.

  O jogo inicia com o cientista forense definindo o assassino, a arma utilizada e o vestígio
  deixado por ele. Após a definição desses três valores, é possível prosseguir. Após
  confirmar suas escolhas, será possível acessar o menu do detetive. Nele, é possível:

  Pedir dica: Ao solicitar uma dica, o jogador deverá passar o controle para o
  cientista forense. Serão sorteados dois tipos de dicas, dos quais o cientista forense
  deverá selecionar um que melhor ilustre a solução. O jogador poderá solicitar um máximo de 
  6 dicas.
  
  Listar dicas: lista as dicas fornecidas no formato DICA (TIPO DE DICA).
      send(DialogGroup, append, new(Botao1, button(Novo Jogo, message(@prolog, menu_cientista), message(Menu, destroy)))),e.

  Realizar acusação: o detetive faz uma acusação contra algum dos suspeitos, devendo
  também mencionar o objeto usado no crime e o vestígio deixado pelo assassino. É importante
  ressaltar que, para vencer o jogo, é necessário que o SUSPEITO, OBJETO e VESTÍGIO
  escolhidos pelos detetives estejam corretos. Caso contrário, é fim de jogo!'
    ))),
    send(PaginaRegras, append, button('Fechar', message(PaginaRegras, destroy))),
    
    send(PaginaRegras, open).

criar_menu :-
    new(Menu, dialog('Deception Murder Investigation')),
    new(Titulo, text('Deception Murder Investigation')),
    send(Titulo, font, font(bold, italic, 28)),
    send(Menu, append, Titulo),
    send(Menu, append, new(DialogGroup, dialog_group)),
    send(DialogGroup, label, ''),
    send(DialogGroup, alignment, center),
    send(DialogGroup, append, new(Botao1, button('Novo Jogo', message(@prolog, menu_cientista)))),
    send(DialogGroup, append, new(Botao2, button('Regras', message(@prolog, criar_pagina_regras)))),
    send(Menu, append, button('Fechar', message(Menu, destroy))),
    
    send(Menu, open).

menu_cientista :-

    new(MenuCientista, dialog('Menu Cientista')),
    new(TituloCientista, text('Menu Cientista')),
    send(TituloCientista, font, font(bold, italic, 28)),
    send(MenuCientista, append, TituloCientista),
    send(MenuCientista, append, new(DialogG, dialog_group)),
    send(DialogG, label, ''),
    send(DialogG, alignment, center),
    send(DialogG, append, new(Botao1, button('Assassino', message(@prolog, lista_assassino)))),
    send(DialogG, append, new(Botao2, button('Arma do Crime', message(@prolog, lista_arma)))),
    send(DialogG, append, new(Botao3, button('Prova do Crime', message(@prolog, lista_prova)))),
    send(MenuCientista, append, new(Botao4, button('Confirmar', message(MenuCientista, destroy)))),
    (
        not(is_suspeito_empty)
        ->
        send(Botao4, active, @on)
        ;
        send(Botao4, active, @off)
    ),
    send(MenuCientista, append, button('Fechar', message(MenuCientista, destroy))),

    send(MenuCientista, open).

lista_assassino :-
    new(SelecaoAssassino, dialog('Seleção Assassino')),
    new(TituloAssassino, text('Selecione o assassino')),
    send(TituloAssassino, font, font(bold, italic, 22)),
    send(SelecaoAssassino, append, TituloAssassino),
    send(SelecaoAssassino, append, new(DialogG2, dialog_group)),
    send(DialogG2, label, ''),
    send(DialogG2, alignment, center),
    send(DialogG2, append, new(Botao1, button('Maria', message(@prolog, forward, select_assassino, maria)))),
    send(DialogG2, append, new(Botao2, button('João', message(@prolog, forward, select_assassino, joao)))),
    send(DialogG2, append, new(Botao3, button('Pedro', message(@prolog, forward, select_assassino, pedro)))),
    send(DialogG2, append, new(Botao4, button('Ana', message(@prolog, forward, select_assassino, ana)))),
    send(DialogG2, append, new(Botao5, button('Carlos', message(@prolog, forward, select_assassino, carlos)))),

    send(SelecaoAssassino, open).

select_assassino(Name) :-
    assert(solucao_suspeito(Name)).

is_suspeito_empty :-
    \+ solucao_suspeito(_).

lista_arma :-
    new(SelecaoArma, dialog('Seleção Arma')),
    new(TituloArma, text('Selecione a arma do crime')),
    send(TituloArma, font, font(bold, italic, 22)),
    send(SelecaoArma, append, TituloArma),
    send(SelecaoArma, append, new(DialogG2, dialog_group)),
    send(DialogG2, label, ''),
    send(DialogG2, alignment, center),
    send(DialogG2, append, new(Botao1, button('Injeção', message(@prolog, forward, select_assassino, maria)))),
    send(DialogG2, append, new(Botao2, button('Corda', message(@prolog, forward, select_assassino, joao)))),
    send(DialogG2, append, new(Botao3, button('Guarda-Chuva', message(@prolog, forward, select_assassino, pedro)))),
    send(DialogG2, append, new(Botao4, button('Explosivo', message(@prolog, forward, select_assassino, ana)))),
    send(DialogG2, append, new(Botao5, button('Motossera', message(@prolog, forward, select_assassino, carlos)))),

    send(SelecaoArma, open).

lista_prova :-
    new(SelecaoProva, dialog('Seleção Prova')),
    new(TituloAssassino, text('Selecione o prova do crime')),
    send(TituloAssassino, font, font(bold, italic, 22)),
    send(SelecaoProva, append, TituloAssassino),
    send(SelecaoProva, append, new(DialogG2, dialog_group)),
    send(DialogG2, label, ''),
    send(DialogG2, alignment, center),
    send(DialogG2, append, new(Botao1, button('Diamante', message(@prolog, forward, select_assassino, maria)))),
    send(DialogG2, append, new(Botao2, button('Caneca', message(@prolog, forward, select_assassino, joao)))),
    send(DialogG2, append, new(Botao3, button('Dinheiro', message(@prolog, forward, select_assassino, pedro)))),
    send(DialogG2, append, new(Botao4, button('Computdor', message(@prolog, forward, select_assassino, ana)))),
    send(DialogG2, append, new(Botao5, button('Cabelo', message(@prolog, forward, select_assassino, carlos)))),

    send(SelecaoProva, open).

