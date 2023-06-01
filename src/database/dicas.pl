tipoDeDica(sufocamento, 1, causa_de_morte).
tipoDeDica(envenenamento, 2, causa_de_morte).
tipoDeDica(ferimento_grave, 3, causa_de_morte).
tipoDeDica(acidente, 4, causa_de_morte).
tipoDeDica(enfermidade, 5, causa_de_morte).

tipoDeDica(parque_de_diversao, 1, local_crime).
tipoDeDica(sala_de_aula, 2, local_crime).
tipoDeDica(dormitorio, 3, local_crime).
tipoDeDica(cafeteria, 4, local_crime).
tipoDeDica(elevador, 5, local_crime).
tipoDeDica(hospital, 6, local_crime).
tipoDeDica(cozinha, 7, local_crime).
tipoDeDica(banheiro, 8, local_crime).
tipoDeDica(varanda, 9, local_crime).

tipoDeDica(ensolarado, 1, clima).
tipoDeDica(tempestade, 2, clima).
tipoDeDica(seco, 3, clima).
tipoDeDica(umido, 4, clima).
tipoDeDica(frio, 5, clima).
tipoDeDica(quente, 6, clima).

tipoDeDica(falta_de_energia, 1, acontecimento_repentino).
tipoDeDica(fogo, 2, acontecimento_repentino).
tipoDeDica(conflitos, 3, acontecimento_repentino).
tipoDeDica(gritos, 4, acontecimento_repentino).
tipoDeDica(nada, 5, acontecimento_repentino).

tipoDeDica(entretendo, 1, vitima_fazia).
tipoDeDica(relaxando, 2, vitima_fazia).
tipoDeDica(reuniao, 3, vitima_fazia).
tipoDeDica(negociando, 4, vitima_fazia).
tipoDeDica(jantando, 5, vitima_fazia).

tipoDeDica(chef, 1, ocupacao_da_vitima).
tipoDeDica(autonomo, 2, ocupacao_da_vitima).
tipoDeDica(trabalhador, 3, ocupacao_da_vitima).
tipoDeDica(estudante, 4, ocupacao_da_vitima).
tipoDeDica(desempregado, 5, ocupacao_da_vitima).

tipoDeDica(breve, 1, duracao_crime).
tipoDeDica(prolongado, 2, duracao_crime).
tipoDeDica(incerto, 3, duracao_crime).
tipoDeDica(gradual, 4, duracao_crime).
tipoDeDica(instantaneo, 5, duracao_crime).

tipoDeDica(arrumadas, 1, roupas_da_vitima).
tipoDeDica(desarrumadas, 2, roupas_da_vitima).
tipoDeDica(elegantes, 3, roupas_da_vitima).
tipoDeDica(usadas, 4, roupas_da_vitima).
tipoDeDica(sem_roupa, 5, roupas_da_vitima).

tipoDeDica(cruel, 1, impressao_geral).
tipoDeDica(criativo, 2, impressao_geral).
tipoDeDica(suspeito, 3, impressao_geral).
tipoDeDica(dramatico, 4, impressao_geral).
tipoDeDica(horrivel, 5, impressao_geral).

tipoDeDica(cinzas, 1, estado_da_cena).
tipoDeDica(mancha_de_agua, 2, estado_da_cena).
tipoDeDica(rachado, 3, estado_da_cena).
tipoDeDica(desorganizado, 4, estado_da_cena).
tipoDeDica(organizado, 5, estado_da_cena).

tipoDeDica(digitais, 1, vestigio_na_cena).
tipoDeDica(pegada, 2, vestigio_na_cena).
tipoDeDica(mancha_de_sangue, 3, vestigio_na_cena).
tipoDeDica(fluido_corporal, 4, vestigio_na_cena).
tipoDeDica(pelos, 5, vestigio_na_cena).

tipoDeDica(pais, 1, relacionamento_social).
tipoDeDica(amigos, 2, relacionamento_social).
tipoDeDica(colegas, 3, relacionamento_social).
tipoDeDica(empregado_ou_empregado, 4, relacionamento_social).
tipoDeDica(amantes, 5, relacionamento_social).
tipoDeDica(estranhos, 6, relacionamento_social).

tipoDeDica(ainda_quente, 1, condicao_do_corpo).
tipoDeDica(rigido, 2, condicao_do_corpo).
tipoDeDica(apodrecido, 3, condicao_do_corpo).
tipoDeDica(intacto, 4, condicao_do_corpo).
tipoDeDica(retorcido, 5, condicao_do_corpo).
tipoDeDica(imcompleto, 6, condicao_do_corpo).

tipoDeDica(tronco, 1, indicacao_no_corpo).
tipoDeDica(cabeca, 2, indicacao_no_corpo).
tipoDeDica(braco, 3, indicacao_no_corpo).
tipoDeDica(perna, 4, indicacao_no_corpo).
tipoDeDica(todo_o_corpo, 5, indicacao_no_corpo).
tipoDeDica(corpo_parcialmente, 6, indicacao_no_corpo).

tipoDeDica(ciume, 1, motivacao_do_crime).
tipoDeDica(poder, 2, motivacao_do_crime).
tipoDeDica(justica, 3, motivacao_do_crime).
tipoDeDica(odio, 4, motivacao_do_crime).
tipoDeDica(dinheiro, 5, motivacao_do_crime).

tipoDeDica(grande, 1, porte_da_vitima).
tipoDeDica(alto, 2, porte_da_vitima).
tipoDeDica(magro, 3, porte_da_vitima).
tipoDeDica(pequeno, 4, porte_da_vitima).
tipoDeDica(baixo, 5, porte_da_vitima).
tipoDeDica(gordo, 6, porte_da_vitima).
tipoDeDica(em_forma, 7, porte_da_vitima).

tipoDeDica(dia_de_semana, 1, dia_do_crime).
tipoDeDica(fim_de_semana, 2, dia_do_crime).
tipoDeDica(primavera, 3, dia_do_crime).
tipoDeDica(verao, 4, dia_do_crime).
tipoDeDica(outono, 5, dia_do_crime).
tipoDeDica(inverno, 6, dia_do_crime).

tipoDeDica(natural, 1, evidencia_deixada).
tipoDeDica(artistica, 2, evidencia_deixada).
tipoDeDica(escrita, 3, evidencia_deixada).
tipoDeDica(pessoal, 4, evidencia_deixada).
tipoDeDica(nao_relacionado, 5, evidencia_deixada).

tipoDeDica(crianca, 1, identidade_vitima).
tipoDeDica(idoso, 2, identidade_vitima).
tipoDeDica(adulto, 3, identidade_vitima).
tipoDeDica(jovem, 4, identidade_vitima).

tipoDeDica(serena, 1, expressao_da_vitima).
tipoDeDica(lutando, 2, expressao_da_vitima).
tipoDeDica(assustado, 3, expressao_da_vitima).
tipoDeDica(com_dor, 4, expressao_da_vitima).
tipoDeDica(sem_expressao, 5, expressao_da_vitima).


/* Para testes: 
local:-
        write('Digite "1." para o local:'), read(N), N is 1,tipoDeDica(X, local_crime), write(X), nl, fail.
clima:- 
        write('Digite "2." para o clima: '), read(C), C is 2,tipoDeDica(X, clima), write(X), nl, fail.
*/
