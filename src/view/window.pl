:- use_module(library(pce)).

:- pce_begin_class(minha_janela, frame).

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
  
  Listar objetos e vestigios de um suspeito: são listados todos os objetos e  
  vestígios que um suspeito possui. Os detetives devem considerar esses itens para
  estabelecer uma relação com as dicas obtidas com a ajuda do cientista forense.

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
    send(DialogGroup, append, new(Botao1, button('Novo Jogo'))),
    send(DialogGroup, append, new(Botao2, button('Regras', message(@prolog, criar_pagina_regras)))),
    send(Menu, append, button('Fechar', message(Menu, destroy))),
    
    send(Menu, open).

