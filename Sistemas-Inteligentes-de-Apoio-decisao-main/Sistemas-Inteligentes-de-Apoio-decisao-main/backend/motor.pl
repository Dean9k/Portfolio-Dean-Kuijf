% Motor de inferência com factores de certeza

:- encoding(utf8).

minimo(A, B, Min) :- A =< B, Min = A.
minimo(A, B, Min) :- A > B, Min = B.

obter_motivo(Valor, Motivo) :-
    motivo_pergunta(Valor, Motivo), !.
obter_motivo(_, 'Para ajudar a determinar o melhor encaminhamento.').

verifica_incerteza(Atributo, Valor, CF) :-
    Facto =.. [Atributo, Valor, CF], call(Facto), !.
verifica_incerteza(_, Valor, _) :-
    nao_tem(Valor), !, fail.
verifica_incerteza(_, Valor, _) :-
    \+ pergunta_no_fluxo(Valor), !, fail.
verifica_incerteza(_, Valor, _) :-
    texto_pergunta(Valor, TextoPergunta),
    obter_motivo(Valor, Motivo),
    throw(question(Valor, TextoPergunta, scale, Motivo)).

verifica_exato(Atributo, Valor, 1.0) :-
    Facto =.. [Atributo, Valor, 1.0], call(Facto), !.
verifica_exato(_, Valor, _) :-
    nao_tem(Valor), !, fail.
verifica_exato(_, Valor, _) :-
    \+ pergunta_no_fluxo(Valor), !, fail.
verifica_exato(_, Valor, 1.0) :-
    texto_pergunta(Valor, TextoPergunta),
    obter_motivo(Valor, Motivo),
    throw(question(Valor, TextoPergunta, sn, Motivo)).

verifica_negativo(_, Valor, 1.0) :-
    nao_tem(Valor), !.
verifica_negativo(Atributo, Valor, _) :-
    Facto =.. [Atributo, Valor, 1.0], call(Facto), !, fail.
verifica_negativo(_, Valor, 1.0) :-
    \+ pergunta_no_fluxo(Valor), !.   % fora do fluxo = assume ausente, sucesso
verifica_negativo(_, Valor, 1.0) :-
    texto_pergunta(Valor, TextoPergunta),
    obter_motivo(Valor, Motivo),
    throw(question(Valor, TextoPergunta, sn, Motivo)).