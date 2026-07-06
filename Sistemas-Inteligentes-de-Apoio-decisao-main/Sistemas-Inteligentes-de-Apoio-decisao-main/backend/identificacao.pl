% Identificação e persistência de utentes

:- encoding(utf8).
:- dynamic doente_registo/3.

% Carrega utentes de dois CSVs: data/ (principal) e backend/ (locais), evitando duplicados
carregar_utentes :-
    (exists_file('../data/utentes.csv') ->
        setup_call_cleanup(
            open('../data/utentes.csv', read, S),
            processar_linhas_csv(S),
            close(S))
    ; true),
    (exists_file('utentes.csv') ->
        setup_call_cleanup(
            open('utentes.csv', read, S),
            processar_linhas_csv(S),
            close(S))
    ; true),
    (\+ doente_registo(_, _, _) ->
        nl, write('AVISO: Nenhum utente carregado.'), nl ; true).

processar_linhas_csv(Stream) :-
    read_line_to_string(Stream, Line),
    (   Line == end_of_file -> true
    ;   (   split_string(Line, ",", "\"", [NIF_Str, Nome, DataNascimento]),
            NIF_Str \= "",
            Nome \= "",
            DataNascimento \= "",
            number_string(NIF, NIF_Str),
            \+ doente_registo(NIF, _, _),
            assertz(doente_registo(NIF, Nome, DataNascimento))
        ;   true
        ),
        processar_linhas_csv(Stream)
    ).

guardar_utente_csv(NIF, Nome, DataNascimento) :-
    open('../data/utentes.csv', append, Stream),
    format(Stream, '~w,"~w",~w~n', [NIF, Nome, DataNascimento]),
    close(Stream).

guardar_triagem_csv(NIF, Sintoma, Destino, Certeza) :-
    get_time(T), stamp_date_time(T, DT, local),
    format_time(string(DH), '%Y-%m-%d %H:%M', DT),
    setup_call_cleanup(
        open('../data/triagens.csv', append, Stream),
        format(Stream, '~w,"~w","~w","~w",~2f~n', [NIF, DH, Sintoma, Destino, Certeza]),
        close(Stream)
    ).

ler_historico_utente(NIF_Num, ListaHistorico) :-
    (   exists_file('../data/triagens.csv') ->
        setup_call_cleanup(
            open('../data/triagens.csv', read, Stream),
            ler_linhas_historico(Stream, NIF_Num, ListaHistorico),
            close(Stream)
        )
    ;   ListaHistorico = []
    ).

ler_linhas_historico(Stream, NIF_Num, Lista) :-
    read_line_to_string(Stream, Line),
    (   Line == end_of_file ->
        Lista = []
    ;   ler_linhas_historico(Stream, NIF_Num, Resto),
        (   split_string(Line, ",", "\"", [NIF_Str, Data, Sintoma, Destino, CertezaStr]),
            number_string(NIF_Linha, NIF_Str),
            NIF_Linha == NIF_Num
        ->  number_string(CertezaNum, CertezaStr),
            Entrada = _{data:Data, sintoma:Sintoma, destino:Destino, certeza:CertezaNum},
            Lista = [Entrada|Resto]
        ;   Lista = Resto
        )
    ).

calcular_idade(DataNascimentoStr, Idade) :-
    (atom(DataNascimentoStr) -> atom_string(DataNascimentoStr, DS) ; DS = DataNascimentoStr),
    split_string(DS, "-", "", [AnoStr, MesStr, DiaStr]),
    number_string(AnoNasc, AnoStr),
    number_string(MesNasc, MesStr),
    number_string(DiaNasc, DiaStr),
    get_time(TimeStamp),
    stamp_date_time(TimeStamp, DateTime, local),
    date_time_value(year,  DateTime, AnoAtual),
    date_time_value(month, DateTime, MesAtual),
    date_time_value(day,   DateTime, DiaAtual),
    (   (MesAtual > MesNasc ; (MesAtual =:= MesNasc, DiaAtual >= DiaNasc))
    ->  Idade is AnoAtual - AnoNasc
    ;   Idade is AnoAtual - AnoNasc - 1
    ).

% Features para o dataset de treino (sincronizadas com gerar_dataset.py)
features_treino([
    emergencia, doencas_cronicas, imunossuprimido,
    sintomas_respiratorios, dormir_sentado, tosse_sangue, pieira,
    inalador_sem_melhoria, pieira_intensa, tosse_cronica, expectoracao_purulenta,
    estridor, olfato_paladar, sintomas_gripais, saturacao_baixa, cianose,
    inchaco_face_labios,
    febre, febre_nao_cede, febre_3_dias, gastricos_prolongados, sinais_desidratacao,
    nauseas, vomitos_sangue, fezes_escuras, dor_abdominal_intensa,
    dor_abdominal_localizada, ictericia, problema_garganta, dor_garganta_intensa,
    garganta_exsudados, infecao_urinaria, infecao_urinaria_febre, crianca_febril,
    mordedura_animal, dor_dental_intensa,
    dor_peito_irradiada, dor_peito_repouso, palpitacoes_graves, edema_membros,
    assimetria_facial_fala, fraqueza_unilateral, cefaleia_subita, confusao_mental,
    rigidez_nuca, erupcao_purpura, traumatismo_craniano, dor_costas_irradiada,
    urina_sangue, dor_flanco, dor_articular, artrite_aguda, olho_vermelho_dor,
    gravidez, gravidez_sangramento, gravidez_dor, hipoglicemia, ansiedade_extrema
]).

valor_feature(Feature, 1) :- sintoma(Feature, CF), CF >= 0.5, !.
valor_feature(_, 0).

guardar_treino_csv(Destino) :-
    features_treino(Features),
    maplist(valor_feature, Features, Valores),
    setup_call_cleanup(
        open('../data/dataset_treino.csv', append, Stream),
        (   atomic_list_concat(Valores, ',', ValoresStr),
            format(Stream, '~w,~w~n', [ValoresStr, Destino])
        ),
        close(Stream)
    ).