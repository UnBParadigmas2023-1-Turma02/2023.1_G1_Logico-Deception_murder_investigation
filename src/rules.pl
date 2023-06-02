show_rules :- 
  nl,
  write('====================================== REGRAS DO JOGO ======================================'), nl, nl,
  write('O jogo é baseado em Deception: Murder in Hong Kong, com algumas alterações. Nossa versão'), nl,
  write('possui algumas diferenças em relação ao jogo original. Nela, há um mínimo de 2 jogadores,'), nl,
  write('podendo chegar a até 6 rodadas (no jogo original, o mínimo são 4 jogadores, com um máximo'), nl,
  write('de 3 rodadas).'), nl,
  nl,
  write('Um jogador assumirá o papel de cientista forense, enquanto os demais assumirão o papel de'), nl,
  write('detetive(s). O papel do cientista forense consiste em ajudar os detetives responsáveis por'), nl,
  write('descobrir o assassino, sendo também responsável por definir a solução.'), nl,
  nl,
  write('O jogo inicia com o cientista forense definindo o assassino, a arma utilizada e o vestígio'), nl,
  write('deixado por ele. Após a definição desses três valores, é possível prosseguir. Após'), nl,
  write('confirmar suas escolhas, será possível acessar o menu do detetive. Nele, é possível:'), nl,

  tab(4), write('Pedir dica: Ao solicitar uma dica, o jogador deverá passar o controle para o'), nl,
  write('cientista forense. Serão sorteados dois tipos de dicas, dos quais o cientista forense'), nl,
  write('deverá selecionar um que melhor ilustre a solução. O jogador poderá solicitar um máximo de'), nl, 
  write('6 dicas.'), nl,
  
  tab(4), write('Listar dicas: lista as dicas fornecidas no formato DICA (TIPO DE DICA).'), nl,
  
  tab(4), write('Listar objetos e vestigios de um suspeito: são listados todos os objetos e '), nl, 
  write('vestígios que um suspeito possui. Os detetives devem considerar esses itens para'), nl,
  write('estabelecer uma relação com as dicas obtidas com a ajuda do cientista forense.'), nl,

  tab(4), write('Realizar acusação: o detetive faz uma acusação contra algum dos suspeitos, devendo'), nl,
  write('também mencionar o objeto usado no crime e o vestígio deixado pelo assassino. É importante'), nl,
  write('ressaltar que, para vencer o jogo, é necessário que o SUSPEITO, OBJETO e VESTÍGIO'), nl,
  write('escolhidos pelos detetives estejam corretos. Caso contrário, é fim de jogo!'), nl,
  nl,
  write('============================================================================================'),
  nl.