% Servidor Web SNS24
% Combina regras manuais (Parte A) + regras ML (Parte B, injetadas em conhecimento.pl)

:- encoding(utf8).

% Diretorio relativo de trabalho (para imports e CSVs)
:- prolog_load_context(directory, Dir),
   working_directory(_, Dir).

:- consult('conhecimento.pl').       % Regras de triagem (manuais + ML)
:- consult('motor.pl').              % Inferência com factores de certeza
:- consult('identificacao.pl').      % Utentes e persistência CSV

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).
:- use_module(library(http/http_json)).

:- multifile user:file_search_path/2.
:- dynamic user:file_search_path/2.
user:file_search_path(frontend, '../frontend').
user:file_search_path(ml_dir,   '../ml').
user:file_search_path(docs,     '../docs').

:- carregar_utentes.

parar :-
    Port = 8000,
    catch(http_stop_server(Port, []),
          error(existence_error(http_server, Port), _),
          true),
    format('~n*** Servidor na porta ~w parado. ***~n', [Port]).

iniciar :-
    parar,
    Port = 8000,
    http_server(http_dispatch, [port(Port)]),
    format('~n*** Servidor SNS24 em http://localhost:~w ***~n', [Port]),
    format('*** Base de conhecimento: Parte A (manual) + Parte B (ML) ***~n', []),
    thread_create(ciclo_auto_treino, _, [alias(auto_treino), detached(true)]),
    format('*** Auto-treino ML ativo (verifica a cada 5 minutos) ***~n', []),
    thread_create(compilar_qlf_se_necessario, _, [alias(compilar_qlf), detached(true)]),
    iniciar_servidor_rag.

% Compila conhecimento.pl → .qlf em background se o .pl for mais recente.
% Na próxima execução o consult carrega o binário e fica ~50% mais rápido.
compilar_qlf_se_necessario :-
    (   exists_file('conhecimento.qlf'),
        time_file('conhecimento.pl',  T_pl),
        time_file('conhecimento.qlf', T_qlf),
        T_qlf >= T_pl
    ->  true
    ;   catch(
            (qcompile('conhecimento.pl'),
             format('[QLF] conhecimento.qlf compilado — próximo arranque será mais rápido.~n')),
            Erro,
            format('[QLF] Erro na compilação: ~w~n', [Erro])
        )
    ).

iniciar_servidor_rag :-
    absolute_file_name('../chatbot', ChatbotDir, [file_type(directory), access(read)]),
    atomic_list_concat([ChatbotDir, '/servidor_rag_gpu.py'], RagScript),
    thread_create(
        catch(
            (   process_create(path(python), [RagScript],
                    [cwd(ChatbotDir),
                     stdout(null), stderr(null),
                     process(PID)]),
                process_wait(PID, _)
            ),
            Erro,
            format('[RAG] Excepcao: ~w~n', [Erro])
        ),
        _, [alias(servidor_rag), detached(true)]),
    format('*** Servidor RAG a iniciar em http://localhost:8001 ***~n', []).

% Auto-treino: verifica a cada 5 minutos se há 15+ novos registos, retreina se necessário
ciclo_auto_treino :-
    sleep(300),
    catch(verificar_e_retreinar, Erro, format('[Auto-treino] Erro: ~w~n', [Erro])),
    ciclo_auto_treino.

verificar_e_retreinar :-
    (   exists_file('../ml/auto_treino.py') ->
        process_create(path(python3), ['../ml/auto_treino.py'],
            [cwd('../ml'), stdout(null), stderr(null), process(PID)]),
        process_wait(PID, Status),
        (Status == exit(0) ->
            format('[Auto-treino] Verificacao concluida.~n') ;
            format('[Auto-treino] Status: ~w~n', [Status]))
    ;   true
    ).

% Rotas HTTP
:- http_handler(root(.),            http_reply_from_files(frontend('.'), []), [prefix]).
:- http_handler('/Logo-SNS.png',    http_reply_file(docs('Logo-SNS.png'), []), []).
:- http_handler('/logo-SNS.png',    http_reply_file(docs('Logo-SNS.png'), []), []).
:- http_handler('/logo-sns.png',    http_reply_file(docs('Logo-SNS.png'), []), []).
:- http_handler('/favicon.ico',     http_reply_file(docs('Logo-SNS.png'), []), []).
:- http_handler(root(metricas_img), http_reply_from_files(ml_dir('metricas_img'), []), [prefix]).
:- http_handler('/api/user',        handle_user_api,    [method(post)]).
:- http_handler('/api/triage',      handle_triage_api,  [method(post)]).
:- http_handler('/api/history',     handle_history_api, [method(post)]).
:- http_handler('/api/metricas_ml', handle_metricas_ml, [method(get)]).

limpa_memoria_triagem :-
    retractall(sintoma(_, _)),
    retractall(risco(_, _)),
    retractall(nao_tem(_)),
    retractall(fluxo_ativo(_)).

% Gestão de utentes (check NIF, registo novo)
handle_user_api(Request) :-
    http_read_json_dict(Request, JSON_In),
    (   JSON_In.action == "check" ->
        (   number_string(NIF_Num, JSON_In.nif),
            doente_registo(NIF_Num, Nome, DataNascimento) ->
            calcular_idade(DataNascimento, Idade),
            reply_json_dict(_{found: true, user: _{nome: Nome, idade: Idade}})
        ;   reply_json_dict(_{found: false})
        )
    ;   JSON_In.action == "register" ->
        (   number_string(NIF_Num, JSON_In.nif),
            (   doente_registo(NIF_Num, _, _) ->
                reply_json_dict(_{success: false, error: "NIF ja registado"})
            ;   DataNascimento = JSON_In.data_nascimento,
                guardar_utente_csv(NIF_Num, JSON_In.nome, DataNascimento),
                assertz(doente_registo(NIF_Num, JSON_In.nome, DataNascimento)),
                reply_json_dict(_{success: true})
            )
        )
    ).

% Triagem: motor percorre encaminhamento/3 pela ordem de definição (Parte A depois B)
handle_triage_api(Request) :-
    http_read_json_dict(Request, JSON_In),
    number_string(NIF_Num, JSON_In.nif),
    nb_delete(already_replied),
    limpa_memoria_triagem,
    (   get_dict(fluxo, JSON_In, FluxoStr) ->
        atom_string(FluxoAtom, FluxoStr),
        assertz(fluxo_ativo(FluxoAtom))
    ;   true
    ),
    processa_respostas(JSON_In.answers),
    catch(
        (   encaminhamento(Destino, Justificacao, CF_Final), !,
            build_result_json(NIF_Num, Destino, Justificacao, CF_Final, JSON_Out),
            reply_json_dict(JSON_Out)
        ),
        question(Code, Text, Type, Reason),
        (   build_question_json(Code, Text, Type, Reason, JSON_Out),
            reply_json_dict(JSON_Out),
            nb_setval(already_replied, true)
        )
    ),
    (   \+ nb_current(already_replied, true) ->
        build_error_json(NIF_Num, JSON_Out),
        reply_json_dict(JSON_Out)
    ;   true
    ).

build_question_json(Code, Text, Type, Reason,
    _{type: "question", question: _{code: Code, text: Text, q_type: Type, reason: Reason}}).

build_result_json(NIF, Destino, Justificacao, CF_Final, JSON_Out) :-
    doente_registo(NIF, Nome, DataNascimento),
    calcular_idade(DataNascimento, Idade),
    CF_Percentagem is CF_Final * 100,
    guardar_triagem_csv(NIF, 'triagem', Destino, CF_Percentagem),
    guardar_treino_csv(Destino),   % Dataset para re-treino automático
    JSON_Out = _{type: "result", result: _{
        destination: Destino, justification: Justificacao,
        certainty: CF_Percentagem,
        user: _{nif: NIF, nome: Nome, idade: Idade}
    }},
    nb_setval(already_replied, true).

build_error_json(NIF, JSON_Out) :-
    doente_registo(NIF, Nome, DataNascimento),
    calcular_idade(DataNascimento, Idade),
    JSON_Out = _{type: "result", result: _{
        destination: "error",
        justification: "Nao foi possivel determinar encaminhamento. Contacte o SNS24.",
        user: _{nif: NIF, nome: Nome, idade: Idade}
    }}.

processa_respostas(Answers) :-
    dict_pairs(Answers, _, Pairs),
    forall(member(Code-Answer, Pairs), assert_resposta(Code, Answer)).

assert_resposta(Code, "s") :- assertz(sintoma(Code, 1.0)).
assert_resposta(Code, "n") :- assertz(nao_tem(Code)).
assert_resposta(Code, Answer) :-
    number_string(Num, Answer),
    CF is Num / 10,
    (   atom_string(Code, S), sub_string(S, _, _, _, "risco_") ->
        assertz(risco(Code, CF))
    ;   assertz(sintoma(Code, CF))
    ).

handle_history_api(Request) :-
    http_read_json_dict(Request, JSON_In),
    number_string(NIF_Num, JSON_In.nif),
    ler_historico_utente(NIF_Num, History),
    reply_json_dict(_{history: History}).

handle_metricas_ml(Request) :-
    (   exists_file('metricas_ml.json') ->
        http_reply_file(docs('metricas_ml.json'), [], Request)
    ;   exists_file('../ml/metricas_ml.json') ->
        http_reply_file(ml_dir('metricas_ml.json'), [], Request)
    ;   reply_json_dict(_{error: "Modelo ML ainda nao treinado. Execute treinar_modelo.py na pasta ml/."})
    ).