% BASE DE CONHECIMENTO - TRIAGEM SNS24
% 47 Regras Manuais (Parte A) + ~102 Regras ML (Parte B) com Fatores de Certeza (CF)


:- encoding(utf8).
:- dynamic fluxo_ativo/1.

% FLUXOS DE TRIAGEM


% --- Comuns a todos os fluxos ---
fluxo(emergencia,              todos).
fluxo(doencas_cronicas,        todos).
fluxo(imunossuprimido,         todos).

% --- Fluxo Respiratorio ---
fluxo(sintomas_respiratorios,  respiratorio).
fluxo(dormir_sentado,          respiratorio).
fluxo(tosse_sangue,            respiratorio).
fluxo(pieira,                  respiratorio).
fluxo(inalador_sem_melhoria,   respiratorio).
fluxo(pieira_intensa,          respiratorio).
fluxo(tosse_cronica,           respiratorio).
fluxo(expectoracao_purulenta,  respiratorio).
fluxo(estridor,                respiratorio).
fluxo(olfato_paladar,          respiratorio).
fluxo(sintomas_gripais,        respiratorio).
fluxo(saturacao_baixa,         respiratorio).
fluxo(cianose,                 respiratorio).
fluxo(inchaco_face_labios,     respiratorio).

% --- Fluxo Febre / Geral ---
fluxo(febre,                   febre_geral).
fluxo(febre_nao_cede,          febre_geral).
fluxo(febre_3_dias,            febre_geral).
fluxo(gastricos_prolongados,   febre_geral).
fluxo(sinais_desidratacao,     febre_geral).
fluxo(nauseas,                 febre_geral).
fluxo(vomitos_sangue,          febre_geral).
fluxo(fezes_escuras,           febre_geral).
fluxo(dor_abdominal_intensa,   febre_geral).
fluxo(dor_abdominal_localizada,febre_geral).
fluxo(ictericia,               febre_geral).
fluxo(problema_garganta,       febre_geral).
fluxo(dor_garganta_intensa,    outros).
fluxo(garganta_exsudados,      outros).
fluxo(infecao_urinaria,        outros).
fluxo(infecao_urinaria_febre,  outros).
fluxo(crianca_febril,          outros).
fluxo(mordedura_animal,        outros).
fluxo(dor_dental_intensa,      outros).

% --- Fluxo Outros ---
fluxo(dor_peito_irradiada,     outros).
fluxo(dor_peito_repouso,       outros).
fluxo(palpitacoes_graves,      outros).
fluxo(edema_membros,           outros).
fluxo(assimetria_facial_fala,  outros).
fluxo(fraqueza_unilateral,     outros).
fluxo(cefaleia_subita,         outros).
fluxo(confusao_mental,         outros).
fluxo(rigidez_nuca,            outros).
fluxo(erupcao_purpura,         outros).
fluxo(traumatismo_craniano,    outros).
fluxo(dor_costas_irradiada,    outros).
fluxo(urina_sangue,            outros).
fluxo(dor_flanco,              outros).
fluxo(dor_articular,           outros).
fluxo(artrite_aguda,           outros).
fluxo(olho_vermelho_dor,       outros).
fluxo(gravidez,                outros).
fluxo(gravidez_sangramento,    outros).
fluxo(gravidez_dor,            outros).
fluxo(hipoglicemia,            outros).
fluxo(ansiedade_extrema,       outros).


% Predicado auxiliar
pergunta_no_fluxo(Sintoma) :-
    fluxo_ativo(FluxoAtivo),
    (fluxo(Sintoma, todos) ; fluxo(Sintoma, FluxoAtivo)), !.
pergunta_no_fluxo(_) :-
    \+ fluxo_ativo(_).


% 1. DICIONARIO DE PERGUNTAS


texto_pergunta(emergencia,              'Tem alguma das seguintes situacoes: alteracao da consciencia, convulsao, engasgamento, falta de ar grave, dor no peito ou acidente recente?').
texto_pergunta(sintomas_respiratorios,  'Tem algum sintoma respiratorio como falta de ar, tosse ou congestao nasal?').
texto_pergunta(problema_garganta,       'Tem algum problema na garganta?').
texto_pergunta(dormir_sentado,          'Tem de dormir sentado ou tem cansaco grave em atividades do dia-a-dia?').
texto_pergunta(tosse_sangue,            'Tem tosse com saida de sangue vivo?').
texto_pergunta(febre,                   'Tem temperatura igual ou superior a 37,8 graus?').
texto_pergunta(pieira,                  'Tem pieira (som tipo apito) ao respirar?').
texto_pergunta(inalador_sem_melhoria,   'Fez tratamento com inalador e nao melhorou?').
texto_pergunta(pieira_intensa,          'A pieira impede-o de fazer a sua vida normal?').
texto_pergunta(febre_nao_cede,          'Tomou medicamento para a febre ha mais de 2h e a febre continua?').
texto_pergunta(imunossuprimido,         'E doente imunossuprimido (ex: quimioterapia)?').
texto_pergunta(gastricos_prolongados,   'Tem vomitos ou diarreia ha mais de 12 horas?').
texto_pergunta(sinais_desidratacao,     'Tem urina reduzida, lingua seca ou tonturas?').
texto_pergunta(febre_3_dias,            'Tem febre ha mais de 3 dias completos?').
texto_pergunta(doencas_cronicas,        'Tem mais de 60 anos ou doencas cronicas (Diabetes, Asma, etc.)?').
texto_pergunta(sintomas_gripais,        'Tem corrimento nasal ou dores nos musculos?').
texto_pergunta(olfato_paladar,          'Apresenta alteracao do olfato ou do paladar?').
texto_pergunta(dor_peito_irradiada,     'Sente dor no peito que se espalha para o braco esquerdo, costas ou maxilar?').
texto_pergunta(assimetria_facial_fala,  'Tem a boca torta, dificuldade em falar ou falta de forca num dos bracos?').
texto_pergunta(dor_abdominal_intensa,   'Tem uma dor de barriga muito forte, subita e que nao passa?').
texto_pergunta(traumatismo_craniano,    'Bateu com a cabeca recentemente e sente tonturas, vomitos ou confusao?').
texto_pergunta(inchaco_face_labios,     'Sente a cara, labios ou lingua a inchar rapidamente?').
texto_pergunta(ansiedade_extrema,       'Sente uma ansiedade incontrolavel, ataque de panico ou tristeza profunda?').
texto_pergunta(cianose,                 'Tem os labios ou pontas dos dedos azulados ou cinzentos?').
texto_pergunta(saturacao_baixa,         'Tem oximetro e a saturacao de oxigenio esta abaixo de 92%?').
texto_pergunta(dor_peito_repouso,       'Tem dor no peito mesmo em repouso, sem irradiacao?').
texto_pergunta(palpitacoes_graves,      'Sente o coracao a bater muito rapido, irregular ou tem sensacao de paragem?').
texto_pergunta(edema_membros,           'Tem os tornozelos, pes ou pernas muito inchados?').
texto_pergunta(tosse_cronica,           'Tem tosse persistente ha mais de 3 semanas?').
texto_pergunta(expectoracao_purulenta,  'A tosse tem expetoracoes de cor amarela ou verde?').
texto_pergunta(estridor,               'Ouve um som agudo e aspero ao inspirar (estridor)?').
texto_pergunta(nauseas,                 'Tem nauseas ou sensacao de enjoo?').
texto_pergunta(vomitos_sangue,          'Vomitou sangue ou liquido com aspeto de borra de cafe?').
texto_pergunta(fezes_escuras,           'As suas fezes sao pretas, alcatroadas ou com sangue visivel?').
texto_pergunta(dor_abdominal_localizada,'A dor de barriga e mais intensa do lado direito inferior (zona do apendice)?').
texto_pergunta(ictericia,               'Tem a pele ou os olhos amarelados?').
texto_pergunta(rigidez_nuca,            'Tem dor ou rigidez intensa no pescoco ao tentar baixar o queixo ao peito?').
texto_pergunta(cefaleia_subita,         'Teve uma dor de cabeca muito forte e subita, a pior da sua vida?').
texto_pergunta(confusao_mental,         'Esta confuso, desorientado ou nao reconhece pessoas ou lugares?').
texto_pergunta(fraqueza_unilateral,     'Tem fraqueza ou dormencia repentina num lado do corpo?').
texto_pergunta(dor_costas_irradiada,    'Tem dor nas costas que irradia para a perna (tipo choque eletrico)?').
texto_pergunta(urina_sangue,            'A sua urina esta vermelha ou com sangue visivel?').
texto_pergunta(dor_flanco,              'Tem dor muito intensa na zona lombar lateral (rim)?').
texto_pergunta(erupcao_purpura,         'Tem manchas na pele de cor roxa que nao desaparecem ao pressionar?').
texto_pergunta(dor_articular,           'Tem dor, inchaço ou calor numa ou varias articulacoes?').
texto_pergunta(artrite_aguda,           'A articulacao esta muito inchada, vermelha e quente, com dor intensa ao toque?').
texto_pergunta(olho_vermelho_dor,       'Tem o olho muito vermelho com dor intensa e visao turva?').
texto_pergunta(gravidez,                'Esta gravida?').
texto_pergunta(gravidez_sangramento,    'Esta gravida e tem sangramento vaginal?').
texto_pergunta(gravidez_dor,            'Esta gravida e tem dores abdominais intensas ou contracoes regulares?').
texto_pergunta(hipoglicemia,            'Sente tremores, suores frios, confusao ou fraqueza extrema (possivel descida de acucar)?').
texto_pergunta(infecao_urinaria,        'Tem ardor ao urinar, necessidade urgente e frequente de urinar?').
texto_pergunta(infecao_urinaria_febre,  'Para alem dos sintomas urinarios, tem febre e dor nas costas?').
texto_pergunta(crianca_febril,          'A crianca tem menos de 3 meses e tem febre acima de 38 graus?').
texto_pergunta(mordedura_animal,        'Foi mordido por um animal (cao, gato, animal selvagem)?').
texto_pergunta(dor_dental_intensa,      'Tem dor de dentes muito intensa com inchaço na face ou febre?').
texto_pergunta(dor_garganta_intensa,    'A dor de garganta e tao forte que nao consegue engolir liquidos?').
texto_pergunta(garganta_exsudados,      'Tem manchas brancas ou pus visivel na garganta?').

% 2. REGRAS DE PRODUCAO COM FATORES DE CERTEZA (CF)

% BLOCO A: EMERGENCIA 112

% Regra E1: Sinais gerais de emergencia
encaminhamento(emergencia_112, 'Presenca de sinais de emergencia vital (alteracao da consciencia, convulsao, engasgamento, etc.).', CF_Final) :-
    verifica_exato(sintoma, emergencia, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra E2: Via Verde AVC
encaminhamento(emergencia_112, 'Sinais de alerta para Acidente Vascular Cerebral (AVC) - Via Verde.', CF_Final) :-
    verifica_exato(sintoma, assimetria_facial_fala, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra E3: Enfarte do Miocardio
encaminhamento(emergencia_112, 'Sinais suspeitos de Enfarte do Miocardio - dor irradiada.', CF_Final) :-
    verifica_exato(sintoma, dor_peito_irradiada, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra E4: Cianose
encaminhamento(emergencia_112, 'Cianose (labios ou dedos azulados) - sinal de hipoxia grave.', CF_Final) :-
    verifica_exato(sintoma, cianose, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.



% Regra E5: Saturacao critica
encaminhamento(emergencia_112, 'Saturacao de oxigenio abaixo de 92% - hipoxia grave.', CF_Final) :-
    verifica_exato(sintoma, saturacao_baixa, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.



% Regra E6: Cefaleia subita extrema
encaminhamento(emergencia_112, 'Cefaleia subita e extrema - suspeita de hemorragia subaracnoideia.', CF_Final) :-
    verifica_exato(sintoma, cefaleia_subita, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra E7: Meningite (triade classica)
encaminhamento(emergencia_112, 'Triada de meningite: rigidez da nuca, confusao e febre - emergencia neurologica.', CF_Final) :-
    verifica_exato(sintoma, rigidez_nuca, CF_Rigid),
    verifica_exato(sintoma, confusao_mental, CF_Conf),
    verifica_exato(sintoma, febre, CF_Febre),
    minimo(CF_Rigid, CF_Conf, T1),
    minimo(T1, CF_Febre, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra E8: Purpura (meningococcemia)
encaminhamento(emergencia_112, 'Erupcao purpurica que nao desaparece - suspeita de meningococcemia.', CF_Final) :-
    verifica_exato(sintoma, erupcao_purpura, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra E9: Bebe com febre
encaminhamento(emergencia_112, 'Bebe com menos de 3 meses e febre - emergencia pediatrica.', CF_Final) :-
    verifica_exato(sintoma, crianca_febril, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra E10: Vomito de sangue
encaminhamento(emergencia_112, 'Vomito com sangue - hemorragia digestiva alta.', CF_Final) :-
    verifica_exato(sintoma, vomitos_sangue, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.


% BLOCO B: URGENCIA HOSPITALAR

% Regra U1: Dificuldade respiratoria grave
encaminhamento(urgencia_hospitalar, 'Dificuldade respiratoria grave - necessidade de dormir sentado ou cansaco extremo.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_Nao_E),
    verifica_exato(sintoma, sintomas_respiratorios, CF_Resp),
    verifica_exato(sintoma, dormir_sentado, CF_Dormir),
    minimo(CF_Nao_E, CF_Resp, T1),
    minimo(T1, CF_Dormir, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.95,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U2: Hemoptise
encaminhamento(urgencia_hospitalar, 'Tosse com sangue (hemoptise) - sinal de alarme que requer avaliacao hospitalar.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_Nao_E),
    verifica_exato(sintoma, sintomas_respiratorios, CF_Resp),
    verifica_negativo(sintoma, dormir_sentado, CF_Nao_D),
    verifica_exato(sintoma, tosse_sangue, CF_Sangue),
    minimo(CF_Nao_E, CF_Resp, T1),
    minimo(T1, CF_Nao_D, T2),
    minimo(T2, CF_Sangue, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.95,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U3: Crise respiratoria sem melhoria
encaminhamento(urgencia_hospitalar, 'Crise respiratoria com febre e pieira que nao melhora com inalador.', CF_Final) :-
    verifica_exato(sintoma, sintomas_respiratorios, CF_Resp),
    verifica_exato(sintoma, febre, CF_Febre),
    verifica_exato(sintoma, pieira, CF_Pieira),
    verifica_exato(sintoma, inalador_sem_melhoria, CF_Inal),
    minimo(CF_Resp, CF_Febre, T1),
    minimo(T1, CF_Pieira, T2),
    minimo(T2, CF_Inal, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.90,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U4: Pieira incapacitante
encaminhamento(urgencia_hospitalar, 'Pieira intensa que impede as atividades normais.', CF_Final) :-
    verifica_exato(sintoma, pieira, CF_Pieira),
    verifica_negativo(sintoma, inalador_sem_melhoria, CF_Nao_Inal),
    verifica_exato(sintoma, pieira_intensa, CF_Intensa),
    minimo(CF_Pieira, CF_Nao_Inal, T1),
    minimo(T1, CF_Intensa, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.90,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U5: Imunossuprimido com febre
encaminhamento(urgencia_hospitalar, 'Doente imunossuprimido com febre - risco elevado de infecao grave.', CF_Final) :-
    verifica_exato(sintoma, febre, CF_Febre),
    verifica_exato(sintoma, imunossuprimido, CF_Imuno),
    minimo(CF_Febre, CF_Imuno, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.90,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U6: Desidratacao grave
encaminhamento(urgencia_hospitalar, 'Desidratacao grave com vomitos/diarreia prolongados.', CF_Final) :-
    verifica_exato(sintoma, gastricos_prolongados, CF_Gastr),
    verifica_exato(sintoma, sinais_desidratacao, CF_Desid),
    minimo(CF_Gastr, CF_Desid, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.90,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U7: Anafilaxia
encaminhamento(urgencia_hospitalar, 'Suspeita de anafilaxia com inchacao da face e dificuldade respiratoria.', CF_Final) :-
    verifica_exato(sintoma, inchaco_face_labios, CF_Inch),
    verifica_exato(sintoma, sintomas_respiratorios, CF_Resp),
    minimo(CF_Inch, CF_Resp, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.98,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U8: Traumatismo craniano
encaminhamento(urgencia_hospitalar, 'Traumatismo craniano com sinais de alarme neurologico.', CF_Final) :-
    verifica_exato(sintoma, traumatismo_craniano, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.95,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U9: Abdomen agudo
encaminhamento(urgencia_hospitalar, 'Dor abdominal intensa e subita - suspeita de abdomen agudo.', CF_Final) :-
    verifica_exato(sintoma, dor_abdominal_intensa, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.90,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U10: Apendicite suspeita
encaminhamento(urgencia_hospitalar, 'Dor localizada no quadrante inferior direito - suspeita de apendicite.', CF_Final) :-
    verifica_exato(sintoma, dor_abdominal_localizada, CF_Dor),
    verifica_exato(sintoma, febre, CF_Febre),
    minimo(CF_Dor, CF_Febre, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U11: Estridor
encaminhamento(urgencia_hospitalar, 'Estridor inspiratorio - obstrucao das vias aereas superiores.', CF_Final) :-
    verifica_exato(sintoma, estridor, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.95,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U12: Palpitacoes com dispneia
encaminhamento(urgencia_hospitalar, 'Palpitacoes graves com falta de ar - possivel arritmia com instabilidade.', CF_Final) :-
    verifica_exato(sintoma, palpitacoes_graves, CF_Palp),
    verifica_exato(sintoma, sintomas_respiratorios, CF_Resp),
    minimo(CF_Palp, CF_Resp, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U13: Dor toracica em repouso
encaminhamento(urgencia_hospitalar, 'Dor no peito em repouso - sindrome coronaria a excluir.', CF_Final) :-
    verifica_exato(sintoma, dor_peito_repouso, CF_Dor),
    verifica_negativo(sintoma, dor_peito_irradiada, CF_Nao_Irradia),
    minimo(CF_Dor, CF_Nao_Irradia, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.88,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U14: Dor renal com febre
encaminhamento(urgencia_hospitalar, 'Dor no flanco com febre - suspeita de pielonefrite ou colica renal complicada.', CF_Final) :-
    verifica_exato(sintoma, dor_flanco, CF_Flanco),
    verifica_exato(sintoma, febre, CF_Febre),
    minimo(CF_Flanco, CF_Febre, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.88,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U15: Artrite septica
encaminhamento(urgencia_hospitalar, 'Articulacao inflamada com febre - suspeita de artrite septica.', CF_Final) :-
    verifica_exato(sintoma, artrite_aguda, CF_Art),
    verifica_exato(sintoma, febre, CF_Febre),
    minimo(CF_Art, CF_Febre, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.90,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U16: Glaucoma agudo
encaminhamento(urgencia_hospitalar, 'Olho vermelho com dor intensa e visao turva - glaucoma agudo a excluir.', CF_Final) :-
    verifica_exato(sintoma, olho_vermelho_dor, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.88,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U17: Gravidez com dor
encaminhamento(urgencia_hospitalar, 'Gravida com dor abdominal intensa ou contracoes prematuras.', CF_Final) :-
    verifica_exato(sintoma, gravidez, CF_Grav),
    verifica_exato(sintoma, gravidez_dor, CF_Dor),
    minimo(CF_Grav, CF_Dor, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.95,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U18: Gravidez com sangramento
encaminhamento(urgencia_hospitalar, 'Gravida com sangramento vaginal - avaliacao obstetrica urgente.', CF_Final) :-
    verifica_exato(sintoma, gravidez, CF_Grav),
    verifica_exato(sintoma, gravidez_sangramento, CF_Sang),
    minimo(CF_Grav, CF_Sang, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.90,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U19: Hematuria com dor
encaminhamento(urgencia_hospitalar, 'Sangue na urina com dor intensa - litiase renal ou patologia urologica urgente.', CF_Final) :-
    verifica_exato(sintoma, urina_sangue, CF_Urina),
    verifica_exato(sintoma, dor_flanco, CF_Flanco),
    minimo(CF_Urina, CF_Flanco, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.88,
    CF_Final is CF_Premissa * CF_Regra.

% Regra U20: Mordedura com febre
encaminhamento(urgencia_hospitalar, 'Mordedura de animal com febre - risco de raiva e tetano.', CF_Final) :-
    verifica_exato(sintoma, mordedura_animal, CF_Mord),
    verifica_exato(sintoma, febre, CF_Febre),
    minimo(CF_Mord, CF_Febre, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.88,
    CF_Final is CF_Premissa * CF_Regra.

% BLOCO C: CONSULTA MEDICA

% Regra C1: Febre que nao cede
encaminhamento(consulta_medica, 'Febre que nao baixa com medicacao - avaliacao medica necessaria.', CF_Final) :-
    verifica_exato(sintoma, febre, CF_Febre),
    verifica_exato(sintoma, febre_nao_cede, CF_NaoCede),
    minimo(CF_Febre, CF_NaoCede, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.80,
    CF_Final is CF_Premissa * CF_Regra.

% Regra C2: Tosse cronica com expectoracao
encaminhamento(consulta_medica, 'Tosse prolongada com expectoracao purulenta - possivel infecao bacteriana.', CF_Final) :-
    verifica_exato(sintoma, tosse_cronica, CF_Tosse),
    verifica_exato(sintoma, expectoracao_purulenta, CF_Exp),
    minimo(CF_Tosse, CF_Exp, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.80,
    CF_Final is CF_Premissa * CF_Regra.

% Regra C3: Garganta com exsudados e febre
encaminhamento(consulta_medica, 'Garganta com pus e febre - amigdalite bacteriana requer antibiotico.', CF_Final) :-
    verifica_exato(sintoma, garganta_exsudados, CF_Exs),
    verifica_exato(sintoma, febre, CF_Febre),
    minimo(CF_Exs, CF_Febre, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.80,
    CF_Final is CF_Premissa * CF_Regra.

% Regra C4: Infecao urinaria com febre
encaminhamento(consulta_medica, 'Sintomas urinarios com febre - pielonefrite a tratar com antibiotico.', CF_Final) :-
    verifica_exato(sintoma, infecao_urinaria, CF_ITU),
    verifica_exato(sintoma, infecao_urinaria_febre, CF_Febre),
    minimo(CF_ITU, CF_Febre, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.80,
    CF_Final is CF_Premissa * CF_Regra.

% Regra C5: Dor dental com febre
encaminhamento(consulta_medica, 'Abcesso dentario com febre - celulite facial a tratar.', CF_Final) :-
    verifica_exato(sintoma, dor_dental_intensa, CF_Dental),
    verifica_exato(sintoma, febre, CF_Febre),
    minimo(CF_Dental, CF_Febre, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.78,
    CF_Final is CF_Premissa * CF_Regra.

% Regra C6: Dor articular sem inflamacao intensa
encaminhamento(consulta_medica, 'Dor articular sem sinais inflamatorios intensos - avaliacao reumatologica.', CF_Final) :-
    verifica_exato(sintoma, dor_articular, CF_Art),
    verifica_negativo(sintoma, artrite_aguda, CF_Nao_Art),
    verifica_negativo(sintoma, febre, CF_Nao_Febre),
    minimo(CF_Art, CF_Nao_Art, T1),
    minimo(T1, CF_Nao_Febre, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% Regra C7: Dor lombar irradiada sem fraqueza
encaminhamento(consulta_medica, 'Dor lombociatica sem perda de forca - hernia discal a tratar conservadoramente.', CF_Final) :-
    verifica_exato(sintoma, dor_costas_irradiada, CF_Dor),
    verifica_negativo(sintoma, fraqueza_unilateral, CF_Nao_Frac),
    minimo(CF_Dor, CF_Nao_Frac, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% BLOCO D: CONTACTO SNS24

% Regra S1: Gastricos sem desidratacao com febre 3 dias
encaminhamento(contacto_sns24, 'Febre ha mais de 3 dias com sintomas gastricos, sem desidratacao grave.', CF_Final) :-
    verifica_exato(sintoma, gastricos_prolongados, CF_Gastr),
    verifica_negativo(sintoma, sinais_desidratacao, CF_Nao_Desid),
    verifica_exato(sintoma, febre_3_dias, CF_Febre3d),
    minimo(CF_Gastr, CF_Nao_Desid, T1),
    minimo(T1, CF_Febre3d, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% Regra S2: Grupo de risco com febre
encaminhamento(contacto_sns24, 'Paciente com mais de 60 anos ou doencas cronicas com febre.', CF_Final) :-
    verifica_exato(sintoma, febre, CF_Febre),
    verifica_exato(sintoma, doencas_cronicas, CF_Risco),
    minimo(CF_Febre, CF_Risco, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% Regra S3: Infecao urinaria simples
encaminhamento(contacto_sns24, 'Sintomas de infecao urinaria sem febre - pode necessitar de antibiotico.', CF_Final) :-
    verifica_exato(sintoma, infecao_urinaria, CF_ITU),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_Nao_Febre),
    minimo(CF_ITU, CF_Nao_Febre, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.72,
    CF_Final is CF_Premissa * CF_Regra.

% Regra S4: Sintomas gripais com febre em grupo de risco
encaminhamento(contacto_sns24, 'Sintomas gripais com febre em doente cronico - aconselhamento medico.', CF_Final) :-
    verifica_exato(sintoma, sintomas_gripais, CF_Grip),
    verifica_exato(sintoma, febre, CF_Febre),
    verifica_exato(sintoma, doencas_cronicas, CF_Risco),
    minimo(CF_Grip, CF_Febre, T1),
    minimo(T1, CF_Risco, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.72,
    CF_Final is CF_Premissa * CF_Regra.

% Regra S5: Hipoglicemia ligeira
encaminhamento(contacto_sns24, 'Possivel hipoglicemia ligeira - aconselhamento para gestao da glicemia.', CF_Final) :-
    verifica_exato(sintoma, hipoglicemia, CF_Hipo),
    verifica_negativo(sintoma, confusao_mental, CF_Nao_Conf),
    minimo(CF_Hipo, CF_Nao_Conf, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.70,
    CF_Final is CF_Premissa * CF_Regra.

% BLOCO E: LINHA SAUDE MENTAL

% Regra M1: Ansiedade / panico
encaminhamento(linha_saude_mental, 'Crise de ansiedade ou panico - encaminhamento para apoio psicologico SNS24.', CF_Final) :-
    verifica_exato(sintoma, ansiedade_extrema, CF_Ans),
    verifica_negativo(sintoma, dor_peito_irradiada, CF_Nao_Peito),
    minimo(CF_Ans, CF_Nao_Peito, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.85,
    CF_Final is CF_Premissa * CF_Regra.

% BLOCO F: AUTOCUIDADOS COM VIGILANCIA

% Regra V1: Alteracao do olfato/paladar
encaminhamento(autocuidados_vigilancia, 'Alteracao do olfato ou paladar - possivel infecao viral, vigiar evolucao.', CF_Final) :-
    verifica_exato(sintoma, olfato_paladar, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.70,
    CF_Final is CF_Premissa * CF_Regra.

% Regra V2: Respiratorio com febre sem alarme
encaminhamento(autocuidados_vigilancia, 'Sintomas respiratorios com febre sem sinais de alarme - vigilancia em casa.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_Nao_E),
    verifica_exato(sintoma, sintomas_respiratorios, CF_Resp),
    verifica_exato(sintoma, febre, CF_Febre),
    verifica_negativo(sintoma, olfato_paladar, CF_Nao_Olf),
    minimo(CF_Nao_E, CF_Resp, T1),
    minimo(T1, CF_Febre, T2),
    minimo(T2, CF_Nao_Olf, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.60,
    CF_Final is CF_Premissa * CF_Regra.

% Regra V3: Sintomas gripais sem febre
encaminhamento(autocuidados_vigilancia, 'Sintomas gripais leves sem febre - repouso e hidratacao, vigiar evolucao.', CF_Final) :-
    verifica_exato(sintoma, sintomas_gripais, CF_Grip),
    verifica_negativo(sintoma, febre, CF_Nao_Febre),
    minimo(CF_Grip, CF_Nao_Febre, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.60,
    CF_Final is CF_Premissa * CF_Regra.

% BLOCO G: AUTOCUIDADOS

% Regra A1: Sem sintomas relevantes
encaminhamento(autocuidados, 'Ausencia de sintomas de emergencia, respiratorios ou de garganta.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_Nao_E),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_Nao_Resp),
    verifica_negativo(sintoma, problema_garganta, CF_Nao_Garg),
    minimo(CF_Nao_E, CF_Nao_Resp, T1),
    minimo(T1, CF_Nao_Garg, CF_Premissa),
    CF_Premissa >= 0.5,
    CF_Regra = 0.50,
    CF_Final is CF_Premissa * CF_Regra.

% 3. DICIONARIO DE MOTIVOS (EXPLICACAO)

motivo_pergunta(emergencia,             'Para despistar situacoes de risco de vida que exigem ativacao imediata do 112.').
motivo_pergunta(sintomas_respiratorios, 'Para avaliar a presenca de infecao ou compromisso do sistema respiratorio.').
motivo_pergunta(problema_garganta,      'Para identificar possiveis inflamacoes ou infecoes nas vias aereas superiores.').
motivo_pergunta(dormir_sentado,         'Para avaliar a gravidade da dificuldade respiratoria - criterio de urgencia.').
motivo_pergunta(tosse_sangue,           'Hemoptise e um sinal de alarme vermelho que implica considerar urgencia hospitalar.').
motivo_pergunta(febre,                  'A febre e um indicador chave de processo infecioso ou inflamatorio em curso.').
motivo_pergunta(pieira,                 'Para detetar obstrucao das vias aereas inferiores, como numa crise de asma.').
motivo_pergunta(inalador_sem_melhoria,  'Para perceber se a crise respiratoria e resistente ao tratamento habitual.').
motivo_pergunta(pieira_intensa,         'Para medir o impacto funcional da falta de ar e determinar o nivel de urgencia.').
motivo_pergunta(febre_nao_cede,         'Febre resistente a medicacao sugere quadro clinico que necessita de avaliacao medica.').
motivo_pergunta(imunossuprimido,        'Doentes imunodeprimidos tem risco muito maior de complicacoes severas.').
motivo_pergunta(gastricos_prolongados,  'Para detetar risco de desidratacao grave por perda prolongada de liquidos.').
motivo_pergunta(sinais_desidratacao,    'Desidratacao grave e emergencia medica que frequentemente necessita de fluidoterapia IV.').
motivo_pergunta(febre_3_dias,           'Febre prolongada pode indicar infecao bacteriana secundaria ou agravamento do quadro.').
motivo_pergunta(doencas_cronicas,       'Pessoas idosas ou com doencas cronicas sao grupo de risco para descompensacao.').
motivo_pergunta(sintomas_gripais,       'Para identificar quadros virais comuns de baixo risco.').
motivo_pergunta(olfato_paladar,         'Sintoma associado a infecoes virais especificas, ajudando a definir o isolamento.').
motivo_pergunta(dor_peito_irradiada,    'Dor irradiada no peito e o principal sinal de alarme para enfarte do miocardio.').
motivo_pergunta(assimetria_facial_fala, 'Sao os sinais da Via Verde AVC que exige socorro imediato.').
motivo_pergunta(dor_abdominal_intensa,  'Dor abdominal subita e intensa pode indicar apendicite, ulcera ou problema cirurgico urgente.').
motivo_pergunta(traumatismo_craniano,   'Bater com a cabeca e ter vomitos ou confusao indica possivel lesao cerebral.').
motivo_pergunta(inchaco_face_labios,    'Inchacao no rosto ou lingua pode bloquear a respiracao numa reacao alergica (anafilaxia).').
motivo_pergunta(ansiedade_extrema,      'O SNS24 tem linha especializada em apoio psicologico para crises de saude mental.').
motivo_pergunta(cianose,                'Labios ou dedos azulados indicam falta grave de oxigenio nos tecidos.').
motivo_pergunta(saturacao_baixa,        'Saturacao abaixo de 92% indica hipoxia grave que requer suporte de oxigenio urgente.').
motivo_pergunta(dor_peito_repouso,      'Dor toracica em repouso pode indicar sindrome coronaria aguda.').
motivo_pergunta(palpitacoes_graves,     'Palpitacoes intensas podem indicar arritmia com risco de paragem cardiaca.').
motivo_pergunta(edema_membros,          'Inchaco nos membros com dispneia pode indicar descompensacao cardiaca.').
motivo_pergunta(tosse_cronica,          'Tosse persistente mais de 3 semanas requer exclusao de tuberculose ou neoplasia.').
motivo_pergunta(expectoracao_purulenta, 'Expectoracao purulenta indica infecao bacteriana que pode necessitar antibiotico.').
motivo_pergunta(estridor,               'Estridor indica obstrucao das vias aereas superiores - pode ser fatal se nao tratado.').
motivo_pergunta(nauseas,                'Para avaliar se as nauseas estao associadas a outros sinais de alarme digestivo.').
motivo_pergunta(vomitos_sangue,         'Vomito com sangue indica hemorragia digestiva alta - emergencia cirurgica.').
motivo_pergunta(fezes_escuras,          'Fezes pretas ou com sangue indicam hemorragia digestiva que requer avaliacao urgente.').
motivo_pergunta(dor_abdominal_localizada,'Dor no quadrante inferior direito e o principal sinal de apendicite.').
motivo_pergunta(ictericia,              'Pele ou olhos amarelados indicam problema hepatico, biliar ou hemolitico a investigar.').
motivo_pergunta(rigidez_nuca,           'Rigidez da nuca com febre e sinal classico de meningite - emergencia neurologica.').
motivo_pergunta(cefaleia_subita,        'Cefaleia subita e extrema pode indicar hemorragia subaracnoideia - emergencia.').
motivo_pergunta(confusao_mental,        'Confusao repentina pode indicar AVC, sepsis, hipoglicemia ou outro estado critico.').
motivo_pergunta(fraqueza_unilateral,    'Fraqueza num lado do corpo e sinal classico de AVC - cada minuto conta.').
motivo_pergunta(dor_costas_irradiada,   'Dor que irradia para a perna indica compressao de nervo espinal.').
motivo_pergunta(urina_sangue,           'Sangue na urina pode indicar litiase, infecao grave ou neoplasia urologica.').
motivo_pergunta(dor_flanco,             'Dor intensa no flanco e tipica de colica renal ou pielonefrite.').
motivo_pergunta(erupcao_purpura,        'Manchas purpuricas que nao desaparecem sao sinal de meningococcemia - emergencia.').
motivo_pergunta(dor_articular,          'Para avaliar a causa da dor articular e excluir artrite septica ou doenca reumatologica.').
motivo_pergunta(artrite_aguda,          'Articulacao inflamada com febre pode indicar artrite septica - emergencia ortopedica.').
motivo_pergunta(olho_vermelho_dor,      'Olho vermelho com dor e visao turva pode indicar glaucoma agudo - emergencia oftalmologica.').
motivo_pergunta(gravidez,               'A gravidez altera os parametros normais e aumenta o risco de algumas complicacoes.').
motivo_pergunta(gravidez_sangramento,   'Sangramento na gravidez pode indicar ameaca de aborto ou placenta previa.').
motivo_pergunta(gravidez_dor,           'Dor abdominal na gravidez pode indicar trabalho de parto prematuro ou descolamento.').
motivo_pergunta(hipoglicemia,           'Descida de acucar no sangue pode levar a perda de consciencia se nao tratada.').
motivo_pergunta(infecao_urinaria,       'Sintomas tipicos de ITU que pode necessitar de antibiotico.').
motivo_pergunta(infecao_urinaria_febre, 'Febre associada a ITU sugere extensao ao rim - pielonefrite a tratar.').
motivo_pergunta(crianca_febril,         'Bebes com menos de 3 meses e febre tem sistema imunitario imaturo - risco elevado.').
motivo_pergunta(mordedura_animal,       'Mordeduras podem transmitir raiva e tetano - profilaxia urgente necessaria.').
motivo_pergunta(dor_dental_intensa,     'Dor dental com inchaco pode indicar abcesso que pode evoluir para celulite facial.').
motivo_pergunta(dor_garganta_intensa,   'Dor impeditiva de engolir pode indicar abcesso periamigdalino - complicacao grave.').
motivo_pergunta(garganta_exsudados,     'Pus na garganta com febre sugere amigdalite bacteriana que necessita antibiotico.').
motivo_pergunta(_,                      'Para ajudar o sistema a cruzar dados e determinar o melhor encaminhamento.').

% === INICIO REGRAS PARTE B (geradas por ML) ===
% Arvore de Decisao (scikit-learn) | 102 regras | Accuracy: 79.9%
% FICHEIRO GERADO AUTOMATICAMENTE — NAO EDITAR MANUALMENTE

% --- EMERGENCIA 112 (ML) ---
% Regra ML #1 (suporte:77, confianca:1.00)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_exato(sintoma, emergencia, CF_0),
    CF_Premissa = CF_0,
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #2 (suporte:14, confianca:1.00)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_exato(sintoma, cefaleia_subita, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #3 (suporte:14, confianca:1.00)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_exato(sintoma, assimetria_facial_fala, CF_7),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    CF_Premissa = T6,
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #4 (suporte:13, confianca:1.00)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_exato(sintoma, vomitos_sangue, CF_9),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    CF_Premissa = T8,
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #5 (suporte:8, confianca:1.00)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_exato(sintoma, crianca_febril, CF_10),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    CF_Premissa = T9,
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #6 (suporte:7, confianca:1.00)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_exato(sintoma, saturacao_baixa, CF_11),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    CF_Premissa = T10,
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #7 (suporte:6, confianca:1.00)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_negativo(sintoma, saturacao_baixa, CF_11),
    verifica_negativo(sintoma, febre_3_dias, CF_12),
    verifica_negativo(sintoma, hipoglicemia, CF_13),
    verifica_negativo(sintoma, cianose, CF_14),
    verifica_exato(sintoma, erupcao_purpura, CF_15),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    CF_Premissa = T14,
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #8 (suporte:6, confianca:1.00)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_negativo(sintoma, saturacao_baixa, CF_11),
    verifica_negativo(sintoma, febre_3_dias, CF_12),
    verifica_negativo(sintoma, hipoglicemia, CF_13),
    verifica_exato(sintoma, cianose, CF_14),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    CF_Premissa = T13,
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #9 (suporte:6, confianca:1.00)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, cianose, CF_3),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    CF_Premissa = T2,
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #10 (suporte:5, confianca:1.00)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_exato(sintoma, crianca_febril, CF_6),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    CF_Premissa = T5,
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #11 (suporte:4, confianca:1.00)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_exato(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, dor_peito_irradiada, CF_2),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    CF_Premissa = T1,
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #12 (suporte:3, confianca:1.00)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, olfato_paladar, CF_8),
    verifica_exato(sintoma, crianca_febril, CF_9),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    CF_Premissa = T8,
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #13 (suporte:3, confianca:1.00)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_exato(sintoma, confusao_mental, CF_7),
    verifica_exato(sintoma, traumatismo_craniano, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 1.0,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #14 (suporte:8, confianca:0.93)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_exato(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, traumatismo_craniano, CF_8),
    verifica_negativo(sintoma, imunossuprimido, CF_9),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    CF_Premissa = T8,
    CF_Premissa >= 0.5,
    CF_Regra = 0.933,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #15 (suporte:3, confianca:0.80)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_exato(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, traumatismo_craniano, CF_8),
    verifica_exato(sintoma, imunossuprimido, CF_9),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    CF_Premissa = T8,
    CF_Premissa >= 0.5,
    CF_Regra = 0.8,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #16 (suporte:4, confianca:0.67)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, crianca_febril, CF_6),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_7),
    verifica_negativo(sintoma, sintomas_gripais, CF_8),
    verifica_negativo(sintoma, fraqueza_unilateral, CF_9),
    verifica_negativo(sintoma, dor_flanco, CF_10),
    verifica_exato(sintoma, tosse_sangue, CF_11),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    CF_Premissa = T10,
    CF_Premissa >= 0.5,
    CF_Regra = 0.667,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #17 (suporte:4, confianca:0.67)
encaminhamento(emergencia_112, 'ML: Padrao de sintomas indica emergencia vital - ativar 112.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, crianca_febril, CF_6),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_7),
    verifica_negativo(sintoma, sintomas_gripais, CF_8),
    verifica_exato(sintoma, fraqueza_unilateral, CF_9),
    verifica_negativo(sintoma, urina_sangue, CF_10),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    CF_Premissa = T9,
    CF_Premissa >= 0.5,
    CF_Regra = 0.667,
    CF_Final is CF_Premissa * CF_Regra.

% --- URGENCIA HOSPITALAR (ML) ---
% Regra ML #18 (suporte:23, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_exato(sintoma, pieira, CF_4),
    verifica_negativo(sintoma, febre, CF_5),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    CF_Premissa = T4,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #19 (suporte:19, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_negativo(sintoma, saturacao_baixa, CF_11),
    verifica_negativo(sintoma, febre_3_dias, CF_12),
    verifica_negativo(sintoma, hipoglicemia, CF_13),
    verifica_negativo(sintoma, cianose, CF_14),
    verifica_negativo(sintoma, erupcao_purpura, CF_15),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_16),
    verifica_exato(sintoma, gravidez_dor, CF_17),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    minimo(T15, CF_17, T16),
    CF_Premissa = T16,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #20 (suporte:17, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_exato(sintoma, pieira, CF_4),
    verifica_exato(sintoma, febre, CF_5),
    verifica_exato(sintoma, inalador_sem_melhoria, CF_6),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    CF_Premissa = T5,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #21 (suporte:12, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, olfato_paladar, CF_8),
    verifica_negativo(sintoma, crianca_febril, CF_9),
    verifica_negativo(sintoma, garganta_exsudados, CF_10),
    verifica_negativo(sintoma, infecao_urinaria, CF_11),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_12),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_13),
    verifica_exato(sintoma, imunossuprimido, CF_14),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    CF_Premissa = T13,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #22 (suporte:12, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_negativo(sintoma, febre, CF_5),
    verifica_negativo(sintoma, olfato_paladar, CF_6),
    verifica_negativo(sintoma, tosse_cronica, CF_7),
    verifica_negativo(sintoma, pieira_intensa, CF_8),
    verifica_exato(sintoma, palpitacoes_graves, CF_9),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    CF_Premissa = T8,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #23 (suporte:7, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, olfato_paladar, CF_8),
    verifica_negativo(sintoma, crianca_febril, CF_9),
    verifica_negativo(sintoma, garganta_exsudados, CF_10),
    verifica_negativo(sintoma, infecao_urinaria, CF_11),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_12),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_13),
    verifica_negativo(sintoma, imunossuprimido, CF_14),
    verifica_exato(sintoma, dor_flanco, CF_15),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    CF_Premissa = T14,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #24 (suporte:7, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_negativo(sintoma, febre, CF_5),
    verifica_negativo(sintoma, olfato_paladar, CF_6),
    verifica_negativo(sintoma, tosse_cronica, CF_7),
    verifica_negativo(sintoma, pieira_intensa, CF_8),
    verifica_negativo(sintoma, palpitacoes_graves, CF_9),
    verifica_negativo(sintoma, tosse_sangue, CF_10),
    verifica_exato(sintoma, inchaco_face_labios, CF_11),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    CF_Premissa = T10,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #25 (suporte:7, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_negativo(sintoma, febre, CF_5),
    verifica_negativo(sintoma, olfato_paladar, CF_6),
    verifica_negativo(sintoma, tosse_cronica, CF_7),
    verifica_negativo(sintoma, pieira_intensa, CF_8),
    verifica_negativo(sintoma, palpitacoes_graves, CF_9),
    verifica_exato(sintoma, tosse_sangue, CF_10),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    CF_Premissa = T9,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #26 (suporte:7, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_exato(sintoma, pieira, CF_4),
    verifica_exato(sintoma, febre, CF_5),
    verifica_negativo(sintoma, inalador_sem_melhoria, CF_6),
    verifica_exato(sintoma, dormir_sentado, CF_7),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    CF_Premissa = T6,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #27 (suporte:5, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, olfato_paladar, CF_8),
    verifica_negativo(sintoma, crianca_febril, CF_9),
    verifica_negativo(sintoma, garganta_exsudados, CF_10),
    verifica_negativo(sintoma, infecao_urinaria, CF_11),
    verifica_exato(sintoma, dor_abdominal_localizada, CF_12),
    verifica_exato(sintoma, gastricos_prolongados, CF_13),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    CF_Premissa = T12,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #28 (suporte:4, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_negativo(sintoma, saturacao_baixa, CF_11),
    verifica_negativo(sintoma, febre_3_dias, CF_12),
    verifica_exato(sintoma, hipoglicemia, CF_13),
    verifica_exato(sintoma, dor_peito_repouso, CF_14),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    CF_Premissa = T13,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #29 (suporte:4, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, olfato_paladar, CF_8),
    verifica_negativo(sintoma, crianca_febril, CF_9),
    verifica_negativo(sintoma, garganta_exsudados, CF_10),
    verifica_negativo(sintoma, infecao_urinaria, CF_11),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_12),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_13),
    verifica_negativo(sintoma, imunossuprimido, CF_14),
    verifica_negativo(sintoma, dor_flanco, CF_15),
    verifica_exato(sintoma, mordedura_animal, CF_16),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    CF_Premissa = T15,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #30 (suporte:4, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, olfato_paladar, CF_8),
    verifica_negativo(sintoma, crianca_febril, CF_9),
    verifica_exato(sintoma, garganta_exsudados, CF_10),
    verifica_exato(sintoma, dor_abdominal_localizada, CF_11),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    CF_Premissa = T10,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #31 (suporte:4, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_exato(sintoma, febre, CF_5),
    verifica_negativo(sintoma, doencas_cronicas, CF_6),
    verifica_exato(sintoma, dormir_sentado, CF_7),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    CF_Premissa = T6,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #32 (suporte:3, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, olfato_paladar, CF_8),
    verifica_negativo(sintoma, crianca_febril, CF_9),
    verifica_negativo(sintoma, garganta_exsudados, CF_10),
    verifica_negativo(sintoma, infecao_urinaria, CF_11),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_12),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_13),
    verifica_negativo(sintoma, imunossuprimido, CF_14),
    verifica_negativo(sintoma, dor_flanco, CF_15),
    verifica_negativo(sintoma, mordedura_animal, CF_16),
    verifica_exato(sintoma, dor_abdominal_intensa, CF_17),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    minimo(T15, CF_17, T16),
    CF_Premissa = T16,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #33 (suporte:3, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, garganta_exsudados, CF_6),
    verifica_exato(sintoma, dor_abdominal_localizada, CF_7),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    CF_Premissa = T6,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #34 (suporte:3, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_exato(sintoma, febre, CF_5),
    verifica_exato(sintoma, doencas_cronicas, CF_6),
    verifica_negativo(sintoma, sintomas_gripais, CF_7),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    CF_Premissa = T6,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #35 (suporte:3, confianca:1.00)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_exato(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, dor_peito_irradiada, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, dor_articular, CF_4),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    CF_Premissa = T3,
    CF_Premissa >= 0.5,
    CF_Regra = 0.92,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #36 (suporte:5, confianca:0.80)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, crianca_febril, CF_6),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_7),
    verifica_negativo(sintoma, sintomas_gripais, CF_8),
    verifica_negativo(sintoma, fraqueza_unilateral, CF_9),
    verifica_exato(sintoma, dor_flanco, CF_10),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    CF_Premissa = T9,
    CF_Premissa >= 0.5,
    CF_Regra = 0.736,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #37 (suporte:3, confianca:0.67)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, olfato_paladar, CF_8),
    verifica_negativo(sintoma, crianca_febril, CF_9),
    verifica_negativo(sintoma, garganta_exsudados, CF_10),
    verifica_negativo(sintoma, infecao_urinaria, CF_11),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_12),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_13),
    verifica_negativo(sintoma, imunossuprimido, CF_14),
    verifica_negativo(sintoma, dor_flanco, CF_15),
    verifica_negativo(sintoma, mordedura_animal, CF_16),
    verifica_negativo(sintoma, dor_abdominal_intensa, CF_17),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    minimo(T15, CF_17, T16),
    CF_Premissa = T16,
    CF_Premissa >= 0.5,
    CF_Regra = 0.613,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #38 (suporte:3, confianca:0.67)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, olfato_paladar, CF_8),
    verifica_negativo(sintoma, crianca_febril, CF_9),
    verifica_negativo(sintoma, garganta_exsudados, CF_10),
    verifica_negativo(sintoma, infecao_urinaria, CF_11),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_12),
    verifica_exato(sintoma, infecao_urinaria_febre, CF_13),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    CF_Premissa = T12,
    CF_Premissa >= 0.5,
    CF_Regra = 0.613,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #39 (suporte:4, confianca:0.60)
encaminhamento(urgencia_hospitalar, 'ML: Padrao de sintomas requer avaliacao urgente em hospital.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, olfato_paladar, CF_8),
    verifica_negativo(sintoma, crianca_febril, CF_9),
    verifica_negativo(sintoma, garganta_exsudados, CF_10),
    verifica_negativo(sintoma, infecao_urinaria, CF_11),
    verifica_exato(sintoma, dor_abdominal_localizada, CF_12),
    verifica_negativo(sintoma, gastricos_prolongados, CF_13),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    CF_Premissa = T12,
    CF_Premissa >= 0.5,
    CF_Regra = 0.552,
    CF_Final is CF_Premissa * CF_Regra.

% --- CONSULTA MEDICA (ML) ---
% Regra ML #40 (suporte:41, confianca:1.00)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_exato(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, problema_garganta, CF_5),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    CF_Premissa = T4,
    CF_Premissa >= 0.5,
    CF_Regra = 0.82,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #41 (suporte:15, confianca:1.00)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_exato(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, infecao_urinaria_febre, CF_5),
    verifica_negativo(sintoma, doencas_cronicas, CF_6),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    CF_Premissa = T5,
    CF_Premissa >= 0.5,
    CF_Regra = 0.82,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #42 (suporte:11, confianca:1.00)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_negativo(sintoma, saturacao_baixa, CF_11),
    verifica_negativo(sintoma, febre_3_dias, CF_12),
    verifica_negativo(sintoma, hipoglicemia, CF_13),
    verifica_negativo(sintoma, cianose, CF_14),
    verifica_negativo(sintoma, erupcao_purpura, CF_15),
    verifica_exato(sintoma, expectoracao_purulenta, CF_16),
    verifica_exato(sintoma, tosse_cronica, CF_17),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    minimo(T15, CF_17, T16),
    CF_Premissa = T16,
    CF_Premissa >= 0.5,
    CF_Regra = 0.82,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #43 (suporte:4, confianca:1.00)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_negativo(sintoma, saturacao_baixa, CF_11),
    verifica_negativo(sintoma, febre_3_dias, CF_12),
    verifica_negativo(sintoma, hipoglicemia, CF_13),
    verifica_negativo(sintoma, cianose, CF_14),
    verifica_negativo(sintoma, erupcao_purpura, CF_15),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_16),
    verifica_negativo(sintoma, gravidez_dor, CF_17),
    verifica_exato(sintoma, dor_articular, CF_18),
    verifica_exato(sintoma, dor_costas_irradiada, CF_19),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    minimo(T15, CF_17, T16),
    minimo(T16, CF_18, T17),
    minimo(T17, CF_19, T18),
    CF_Premissa = T18,
    CF_Premissa >= 0.5,
    CF_Regra = 0.82,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #44 (suporte:4, confianca:1.00)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_exato(sintoma, garganta_exsudados, CF_6),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    CF_Premissa = T5,
    CF_Premissa >= 0.5,
    CF_Regra = 0.82,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #45 (suporte:3, confianca:1.00)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_exato(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, dor_peito_irradiada, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, hipoglicemia, CF_4),
    verifica_exato(sintoma, dor_articular, CF_5),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    CF_Premissa = T4,
    CF_Premissa >= 0.5,
    CF_Regra = 0.82,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #46 (suporte:6, confianca:0.83)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, crianca_febril, CF_6),
    verifica_exato(sintoma, expectoracao_purulenta, CF_7),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    CF_Premissa = T6,
    CF_Premissa >= 0.5,
    CF_Regra = 0.683,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #47 (suporte:11, confianca:0.82)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, olfato_paladar, CF_8),
    verifica_negativo(sintoma, crianca_febril, CF_9),
    verifica_exato(sintoma, garganta_exsudados, CF_10),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_11),
    verifica_negativo(sintoma, infecao_urinaria, CF_12),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    CF_Premissa = T11,
    CF_Premissa >= 0.5,
    CF_Regra = 0.671,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #48 (suporte:10, confianca:0.80)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_negativo(sintoma, saturacao_baixa, CF_11),
    verifica_negativo(sintoma, febre_3_dias, CF_12),
    verifica_negativo(sintoma, hipoglicemia, CF_13),
    verifica_negativo(sintoma, cianose, CF_14),
    verifica_negativo(sintoma, erupcao_purpura, CF_15),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_16),
    verifica_negativo(sintoma, gravidez_dor, CF_17),
    verifica_negativo(sintoma, dor_articular, CF_18),
    verifica_exato(sintoma, ictericia, CF_19),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    minimo(T15, CF_17, T16),
    minimo(T16, CF_18, T17),
    minimo(T17, CF_19, T18),
    CF_Premissa = T18,
    CF_Premissa >= 0.5,
    CF_Regra = 0.656,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #49 (suporte:5, confianca:0.80)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_exato(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, gastricos_prolongados, CF_7),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    CF_Premissa = T6,
    CF_Premissa >= 0.5,
    CF_Regra = 0.656,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #50 (suporte:7, confianca:0.71)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_negativo(sintoma, saturacao_baixa, CF_11),
    verifica_negativo(sintoma, febre_3_dias, CF_12),
    verifica_negativo(sintoma, hipoglicemia, CF_13),
    verifica_negativo(sintoma, cianose, CF_14),
    verifica_negativo(sintoma, erupcao_purpura, CF_15),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_16),
    verifica_negativo(sintoma, gravidez_dor, CF_17),
    verifica_exato(sintoma, dor_articular, CF_18),
    verifica_negativo(sintoma, dor_costas_irradiada, CF_19),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    minimo(T15, CF_17, T16),
    minimo(T16, CF_18, T17),
    minimo(T17, CF_19, T18),
    CF_Premissa = T18,
    CF_Premissa >= 0.5,
    CF_Regra = 0.586,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #51 (suporte:7, confianca:0.71)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_negativo(sintoma, febre, CF_5),
    verifica_negativo(sintoma, olfato_paladar, CF_6),
    verifica_exato(sintoma, tosse_cronica, CF_7),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    CF_Premissa = T6,
    CF_Premissa >= 0.5,
    CF_Regra = 0.586,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #52 (suporte:6, confianca:0.71)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_exato(sintoma, febre_nao_cede, CF_4),
    verifica_exato(sintoma, problema_garganta, CF_5),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    CF_Premissa = T4,
    CF_Premissa >= 0.5,
    CF_Regra = 0.586,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #53 (suporte:3, confianca:0.67)
encaminhamento(consulta_medica, 'ML: Padrao de sintomas requer consulta medica presencial.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, confusao_mental, CF_7),
    verifica_negativo(sintoma, olfato_paladar, CF_8),
    verifica_negativo(sintoma, crianca_febril, CF_9),
    verifica_exato(sintoma, garganta_exsudados, CF_10),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_11),
    verifica_exato(sintoma, infecao_urinaria, CF_12),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    CF_Premissa = T11,
    CF_Premissa >= 0.5,
    CF_Regra = 0.547,
    CF_Final is CF_Premissa * CF_Regra.

% --- CONTACTO SNS24 (ML) ---
% Regra ML #54 (suporte:15, confianca:1.00)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, garganta_exsudados, CF_6),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_7),
    verifica_negativo(sintoma, nauseas, CF_8),
    verifica_exato(sintoma, sintomas_gripais, CF_9),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    CF_Premissa = T8,
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #55 (suporte:7, confianca:1.00)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, garganta_exsudados, CF_6),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_7),
    verifica_negativo(sintoma, nauseas, CF_8),
    verifica_negativo(sintoma, sintomas_gripais, CF_9),
    verifica_exato(sintoma, problema_garganta, CF_10),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    CF_Premissa = T9,
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #56 (suporte:6, confianca:1.00)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, garganta_exsudados, CF_6),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_7),
    verifica_negativo(sintoma, nauseas, CF_8),
    verifica_negativo(sintoma, sintomas_gripais, CF_9),
    verifica_negativo(sintoma, problema_garganta, CF_10),
    verifica_exato(sintoma, infecao_urinaria_febre, CF_11),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    CF_Premissa = T10,
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #57 (suporte:4, confianca:1.00)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_exato(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_5),
    verifica_negativo(sintoma, dor_dental_intensa, CF_6),
    verifica_exato(sintoma, gastricos_prolongados, CF_7),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    CF_Premissa = T6,
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #58 (suporte:4, confianca:1.00)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, garganta_exsudados, CF_6),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_7),
    verifica_negativo(sintoma, nauseas, CF_8),
    verifica_negativo(sintoma, sintomas_gripais, CF_9),
    verifica_negativo(sintoma, problema_garganta, CF_10),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_11),
    verifica_negativo(sintoma, ictericia, CF_12),
    verifica_negativo(sintoma, febre_3_dias, CF_13),
    verifica_negativo(sintoma, infecao_urinaria, CF_14),
    verifica_negativo(sintoma, sinais_desidratacao, CF_15),
    verifica_exato(sintoma, gastricos_prolongados, CF_16),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    CF_Premissa = T15,
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #59 (suporte:4, confianca:1.00)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_exato(sintoma, febre, CF_5),
    verifica_exato(sintoma, doencas_cronicas, CF_6),
    verifica_exato(sintoma, sintomas_gripais, CF_7),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    CF_Premissa = T6,
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #60 (suporte:3, confianca:1.00)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_negativo(sintoma, saturacao_baixa, CF_11),
    verifica_exato(sintoma, febre_3_dias, CF_12),
    verifica_exato(sintoma, gastricos_prolongados, CF_13),
    verifica_exato(sintoma, febre_nao_cede, CF_14),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    CF_Premissa = T13,
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #61 (suporte:3, confianca:1.00)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_exato(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_5),
    verifica_negativo(sintoma, dor_dental_intensa, CF_6),
    verifica_negativo(sintoma, gastricos_prolongados, CF_7),
    verifica_exato(sintoma, dor_garganta_intensa, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #62 (suporte:3, confianca:1.00)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, garganta_exsudados, CF_6),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_7),
    verifica_negativo(sintoma, nauseas, CF_8),
    verifica_negativo(sintoma, sintomas_gripais, CF_9),
    verifica_negativo(sintoma, problema_garganta, CF_10),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_11),
    verifica_negativo(sintoma, ictericia, CF_12),
    verifica_negativo(sintoma, febre_3_dias, CF_13),
    verifica_exato(sintoma, infecao_urinaria, CF_14),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    CF_Premissa = T13,
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #63 (suporte:3, confianca:1.00)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, garganta_exsudados, CF_6),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_7),
    verifica_negativo(sintoma, nauseas, CF_8),
    verifica_negativo(sintoma, sintomas_gripais, CF_9),
    verifica_negativo(sintoma, problema_garganta, CF_10),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_11),
    verifica_negativo(sintoma, ictericia, CF_12),
    verifica_exato(sintoma, febre_3_dias, CF_13),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    CF_Premissa = T12,
    CF_Premissa >= 0.5,
    CF_Regra = 0.75,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #64 (suporte:16, confianca:0.97)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_exato(sintoma, febre_3_dias, CF_6),
    verifica_exato(sintoma, gastricos_prolongados, CF_7),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    CF_Premissa = T6,
    CF_Premissa >= 0.5,
    CF_Regra = 0.726,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #65 (suporte:9, confianca:0.94)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_exato(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_5),
    verifica_negativo(sintoma, dor_dental_intensa, CF_6),
    verifica_negativo(sintoma, gastricos_prolongados, CF_7),
    verifica_negativo(sintoma, dor_garganta_intensa, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 0.706,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #66 (suporte:8, confianca:0.93)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_negativo(sintoma, saturacao_baixa, CF_11),
    verifica_negativo(sintoma, febre_3_dias, CF_12),
    verifica_exato(sintoma, hipoglicemia, CF_13),
    verifica_negativo(sintoma, dor_peito_repouso, CF_14),
    verifica_negativo(sintoma, urina_sangue, CF_15),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    CF_Premissa = T14,
    CF_Premissa >= 0.5,
    CF_Regra = 0.7,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #67 (suporte:15, confianca:0.86)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, garganta_exsudados, CF_6),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_7),
    verifica_negativo(sintoma, nauseas, CF_8),
    verifica_negativo(sintoma, sintomas_gripais, CF_9),
    verifica_negativo(sintoma, problema_garganta, CF_10),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_11),
    verifica_negativo(sintoma, ictericia, CF_12),
    verifica_negativo(sintoma, febre_3_dias, CF_13),
    verifica_negativo(sintoma, infecao_urinaria, CF_14),
    verifica_negativo(sintoma, sinais_desidratacao, CF_15),
    verifica_negativo(sintoma, gastricos_prolongados, CF_16),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    CF_Premissa = T15,
    CF_Premissa >= 0.5,
    CF_Regra = 0.643,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #68 (suporte:8, confianca:0.86)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_negativo(sintoma, saturacao_baixa, CF_11),
    verifica_exato(sintoma, febre_3_dias, CF_12),
    verifica_exato(sintoma, gastricos_prolongados, CF_13),
    verifica_negativo(sintoma, febre_nao_cede, CF_14),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    CF_Premissa = T13,
    CF_Premissa >= 0.5,
    CF_Regra = 0.643,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #69 (suporte:3, confianca:0.80)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_negativo(sintoma, saturacao_baixa, CF_11),
    verifica_negativo(sintoma, febre_3_dias, CF_12),
    verifica_exato(sintoma, hipoglicemia, CF_13),
    verifica_negativo(sintoma, dor_peito_repouso, CF_14),
    verifica_exato(sintoma, urina_sangue, CF_15),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    CF_Premissa = T14,
    CF_Premissa >= 0.5,
    CF_Regra = 0.6,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #70 (suporte:3, confianca:0.80)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_exato(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_5),
    verifica_exato(sintoma, dor_dental_intensa, CF_6),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    CF_Premissa = T5,
    CF_Premissa >= 0.5,
    CF_Regra = 0.6,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #71 (suporte:3, confianca:0.80)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, garganta_exsudados, CF_6),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_7),
    verifica_negativo(sintoma, nauseas, CF_8),
    verifica_negativo(sintoma, sintomas_gripais, CF_9),
    verifica_negativo(sintoma, problema_garganta, CF_10),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_11),
    verifica_negativo(sintoma, ictericia, CF_12),
    verifica_negativo(sintoma, febre_3_dias, CF_13),
    verifica_negativo(sintoma, infecao_urinaria, CF_14),
    verifica_exato(sintoma, sinais_desidratacao, CF_15),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    CF_Premissa = T14,
    CF_Premissa >= 0.5,
    CF_Regra = 0.6,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #72 (suporte:3, confianca:0.80)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, garganta_exsudados, CF_6),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_7),
    verifica_negativo(sintoma, nauseas, CF_8),
    verifica_negativo(sintoma, sintomas_gripais, CF_9),
    verifica_negativo(sintoma, problema_garganta, CF_10),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_11),
    verifica_exato(sintoma, ictericia, CF_12),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    CF_Premissa = T11,
    CF_Premissa >= 0.5,
    CF_Regra = 0.6,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #73 (suporte:3, confianca:0.80)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_exato(sintoma, pieira, CF_4),
    verifica_exato(sintoma, febre, CF_5),
    verifica_negativo(sintoma, inalador_sem_melhoria, CF_6),
    verifica_negativo(sintoma, dormir_sentado, CF_7),
    verifica_exato(sintoma, sintomas_gripais, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 0.6,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #74 (suporte:3, confianca:0.80)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_exato(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, dor_peito_irradiada, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_exato(sintoma, hipoglicemia, CF_4),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    CF_Premissa = T3,
    CF_Premissa >= 0.5,
    CF_Regra = 0.6,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #75 (suporte:4, confianca:0.67)
encaminhamento(contacto_sns24, 'ML: Padrao de sintomas requer contacto com SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, garganta_exsudados, CF_6),
    verifica_negativo(sintoma, dor_abdominal_localizada, CF_7),
    verifica_exato(sintoma, nauseas, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 0.5,
    CF_Final is CF_Premissa * CF_Regra.

% --- LINHA SAUDE MENTAL (ML) ---
% Regra ML #76 (suporte:53, confianca:1.00)
encaminhamento(linha_saude_mental, 'ML: Padrao de sintomas sugere apoio psicologico SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_exato(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, dor_peito_irradiada, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, hipoglicemia, CF_4),
    verifica_negativo(sintoma, dor_articular, CF_5),
    verifica_negativo(sintoma, olho_vermelho_dor, CF_6),
    verifica_negativo(sintoma, gravidez, CF_7),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    CF_Premissa = T6,
    CF_Premissa >= 0.5,
    CF_Regra = 0.85,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #77 (suporte:7, confianca:1.00)
encaminhamento(linha_saude_mental, 'ML: Padrao de sintomas sugere apoio psicologico SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_exato(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, dor_peito_irradiada, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, hipoglicemia, CF_4),
    verifica_negativo(sintoma, dor_articular, CF_5),
    verifica_negativo(sintoma, olho_vermelho_dor, CF_6),
    verifica_exato(sintoma, gravidez, CF_7),
    verifica_negativo(sintoma, rigidez_nuca, CF_8),
    verifica_negativo(sintoma, artrite_aguda, CF_9),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    CF_Premissa = T8,
    CF_Premissa >= 0.5,
    CF_Regra = 0.85,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #78 (suporte:3, confianca:0.67)
encaminhamento(linha_saude_mental, 'ML: Padrao de sintomas sugere apoio psicologico SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_exato(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, dor_peito_irradiada, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, hipoglicemia, CF_4),
    verifica_negativo(sintoma, dor_articular, CF_5),
    verifica_negativo(sintoma, olho_vermelho_dor, CF_6),
    verifica_exato(sintoma, gravidez, CF_7),
    verifica_negativo(sintoma, rigidez_nuca, CF_8),
    verifica_exato(sintoma, artrite_aguda, CF_9),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    CF_Premissa = T8,
    CF_Premissa >= 0.5,
    CF_Regra = 0.567,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #79 (suporte:3, confianca:0.67)
encaminhamento(linha_saude_mental, 'ML: Padrao de sintomas sugere apoio psicologico SNS24.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_exato(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, dor_peito_irradiada, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, hipoglicemia, CF_4),
    verifica_negativo(sintoma, dor_articular, CF_5),
    verifica_negativo(sintoma, olho_vermelho_dor, CF_6),
    verifica_exato(sintoma, gravidez, CF_7),
    verifica_exato(sintoma, rigidez_nuca, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 0.567,
    CF_Final is CF_Premissa * CF_Regra.

% --- AUTOCUIDADOS VIGILANCIA (ML) ---
% Regra ML #80 (suporte:14, confianca:1.00)
encaminhamento(autocuidados_vigilancia, 'ML: Padrao de sintomas sugere autocuidados com vigilancia.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_exato(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, olfato_paladar, CF_7),
    verifica_negativo(sintoma, pieira, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 0.65,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #81 (suporte:10, confianca:1.00)
encaminhamento(autocuidados_vigilancia, 'ML: Padrao de sintomas sugere autocuidados com vigilancia.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_exato(sintoma, febre, CF_5),
    verifica_negativo(sintoma, doencas_cronicas, CF_6),
    verifica_negativo(sintoma, dormir_sentado, CF_7),
    verifica_exato(sintoma, inalador_sem_melhoria, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 0.65,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #82 (suporte:9, confianca:1.00)
encaminhamento(autocuidados_vigilancia, 'ML: Padrao de sintomas sugere autocuidados com vigilancia.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_exato(sintoma, febre, CF_3),
    verifica_negativo(sintoma, febre_nao_cede, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, febre_3_dias, CF_6),
    verifica_negativo(sintoma, confusao_mental, CF_7),
    verifica_exato(sintoma, olfato_paladar, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 0.65,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #83 (suporte:8, confianca:1.00)
encaminhamento(autocuidados_vigilancia, 'ML: Padrao de sintomas sugere autocuidados com vigilancia.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_exato(sintoma, pieira, CF_4),
    verifica_exato(sintoma, febre, CF_5),
    verifica_negativo(sintoma, inalador_sem_melhoria, CF_6),
    verifica_negativo(sintoma, dormir_sentado, CF_7),
    verifica_negativo(sintoma, sintomas_gripais, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 0.65,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #84 (suporte:4, confianca:1.00)
encaminhamento(autocuidados_vigilancia, 'ML: Padrao de sintomas sugere autocuidados com vigilancia.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_exato(sintoma, febre, CF_5),
    verifica_negativo(sintoma, doencas_cronicas, CF_6),
    verifica_negativo(sintoma, dormir_sentado, CF_7),
    verifica_negativo(sintoma, inalador_sem_melhoria, CF_8),
    verifica_negativo(sintoma, tosse_cronica, CF_9),
    verifica_exato(sintoma, sintomas_gripais, CF_10),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    CF_Premissa = T9,
    CF_Premissa >= 0.5,
    CF_Regra = 0.65,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #85 (suporte:4, confianca:1.00)
encaminhamento(autocuidados_vigilancia, 'ML: Padrao de sintomas sugere autocuidados com vigilancia.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_exato(sintoma, febre, CF_5),
    verifica_negativo(sintoma, doencas_cronicas, CF_6),
    verifica_negativo(sintoma, dormir_sentado, CF_7),
    verifica_negativo(sintoma, inalador_sem_melhoria, CF_8),
    verifica_exato(sintoma, tosse_cronica, CF_9),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    CF_Premissa = T8,
    CF_Premissa >= 0.5,
    CF_Regra = 0.65,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #86 (suporte:3, confianca:1.00)
encaminhamento(autocuidados_vigilancia, 'ML: Padrao de sintomas sugere autocuidados com vigilancia.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_negativo(sintoma, febre, CF_5),
    verifica_exato(sintoma, olfato_paladar, CF_6),
    verifica_negativo(sintoma, tosse_cronica, CF_7),
    verifica_exato(sintoma, pieira_intensa, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 0.65,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #87 (suporte:3, confianca:1.00)
encaminhamento(autocuidados_vigilancia, 'ML: Padrao de sintomas sugere autocuidados com vigilancia.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_negativo(sintoma, febre, CF_5),
    verifica_exato(sintoma, olfato_paladar, CF_6),
    verifica_exato(sintoma, tosse_cronica, CF_7),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    CF_Premissa = T6,
    CF_Premissa >= 0.5,
    CF_Regra = 0.65,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #88 (suporte:18, confianca:0.94)
encaminhamento(autocuidados_vigilancia, 'ML: Padrao de sintomas sugere autocuidados com vigilancia.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_exato(sintoma, febre, CF_5),
    verifica_negativo(sintoma, doencas_cronicas, CF_6),
    verifica_negativo(sintoma, dormir_sentado, CF_7),
    verifica_negativo(sintoma, inalador_sem_melhoria, CF_8),
    verifica_negativo(sintoma, tosse_cronica, CF_9),
    verifica_negativo(sintoma, sintomas_gripais, CF_10),
    verifica_negativo(sintoma, olfato_paladar, CF_11),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    CF_Premissa = T10,
    CF_Premissa >= 0.5,
    CF_Regra = 0.614,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #89 (suporte:11, confianca:0.91)
encaminhamento(autocuidados_vigilancia, 'ML: Padrao de sintomas sugere autocuidados com vigilancia.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_exato(sintoma, febre, CF_5),
    verifica_negativo(sintoma, doencas_cronicas, CF_6),
    verifica_negativo(sintoma, dormir_sentado, CF_7),
    verifica_negativo(sintoma, inalador_sem_melhoria, CF_8),
    verifica_negativo(sintoma, tosse_cronica, CF_9),
    verifica_negativo(sintoma, sintomas_gripais, CF_10),
    verifica_exato(sintoma, olfato_paladar, CF_11),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    CF_Premissa = T10,
    CF_Premissa >= 0.5,
    CF_Regra = 0.591,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #90 (suporte:12, confianca:0.83)
encaminhamento(autocuidados_vigilancia, 'ML: Padrao de sintomas sugere autocuidados com vigilancia.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_negativo(sintoma, febre, CF_5),
    verifica_exato(sintoma, olfato_paladar, CF_6),
    verifica_negativo(sintoma, tosse_cronica, CF_7),
    verifica_negativo(sintoma, pieira_intensa, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 0.542,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #91 (suporte:4, confianca:0.75)
encaminhamento(autocuidados_vigilancia, 'ML: Padrao de sintomas sugere autocuidados com vigilancia.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_exato(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, olfato_paladar, CF_7),
    verifica_exato(sintoma, pieira, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 0.488,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #92 (suporte:4, confianca:0.75)
encaminhamento(autocuidados_vigilancia, 'ML: Padrao de sintomas sugere autocuidados com vigilancia.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, crianca_febril, CF_6),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_7),
    verifica_exato(sintoma, sintomas_gripais, CF_8),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    CF_Premissa = T7,
    CF_Premissa >= 0.5,
    CF_Regra = 0.488,
    CF_Final is CF_Premissa * CF_Regra.

% --- AUTOCUIDADOS (ML) ---
% Regra ML #93 (suporte:8, confianca:1.00)
encaminhamento(autocuidados, 'ML: Padrao de sintomas indica tratamento em casa.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, crianca_febril, CF_6),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_7),
    verifica_negativo(sintoma, sintomas_gripais, CF_8),
    verifica_negativo(sintoma, fraqueza_unilateral, CF_9),
    verifica_negativo(sintoma, dor_flanco, CF_10),
    verifica_negativo(sintoma, tosse_sangue, CF_11),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_12),
    verifica_negativo(sintoma, garganta_exsudados, CF_13),
    verifica_negativo(sintoma, urina_sangue, CF_14),
    verifica_negativo(sintoma, edema_membros, CF_15),
    verifica_negativo(sintoma, confusao_mental, CF_16),
    verifica_negativo(sintoma, gravidez, CF_17),
    verifica_exato(sintoma, nauseas, CF_18),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    minimo(T15, CF_17, T16),
    minimo(T16, CF_18, T17),
    CF_Premissa = T17,
    CF_Premissa >= 0.5,
    CF_Regra = 0.55,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #94 (suporte:3, confianca:1.00)
encaminhamento(autocuidados, 'ML: Padrao de sintomas indica tratamento em casa.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, crianca_febril, CF_6),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_7),
    verifica_negativo(sintoma, sintomas_gripais, CF_8),
    verifica_negativo(sintoma, fraqueza_unilateral, CF_9),
    verifica_negativo(sintoma, dor_flanco, CF_10),
    verifica_negativo(sintoma, tosse_sangue, CF_11),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_12),
    verifica_negativo(sintoma, garganta_exsudados, CF_13),
    verifica_negativo(sintoma, urina_sangue, CF_14),
    verifica_negativo(sintoma, edema_membros, CF_15),
    verifica_negativo(sintoma, confusao_mental, CF_16),
    verifica_negativo(sintoma, gravidez, CF_17),
    verifica_negativo(sintoma, nauseas, CF_18),
    verifica_exato(sintoma, pieira, CF_19),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    minimo(T15, CF_17, T16),
    minimo(T16, CF_18, T17),
    minimo(T17, CF_19, T18),
    CF_Premissa = T18,
    CF_Premissa >= 0.5,
    CF_Regra = 0.55,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #95 (suporte:30, confianca:0.90)
encaminhamento(autocuidados, 'ML: Padrao de sintomas indica tratamento em casa.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, crianca_febril, CF_6),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_7),
    verifica_negativo(sintoma, sintomas_gripais, CF_8),
    verifica_negativo(sintoma, fraqueza_unilateral, CF_9),
    verifica_negativo(sintoma, dor_flanco, CF_10),
    verifica_negativo(sintoma, tosse_sangue, CF_11),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_12),
    verifica_negativo(sintoma, garganta_exsudados, CF_13),
    verifica_negativo(sintoma, urina_sangue, CF_14),
    verifica_negativo(sintoma, edema_membros, CF_15),
    verifica_negativo(sintoma, confusao_mental, CF_16),
    verifica_negativo(sintoma, gravidez, CF_17),
    verifica_negativo(sintoma, nauseas, CF_18),
    verifica_negativo(sintoma, pieira, CF_19),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    minimo(T15, CF_17, T16),
    minimo(T16, CF_18, T17),
    minimo(T17, CF_19, T18),
    CF_Premissa = T18,
    CF_Premissa >= 0.5,
    CF_Regra = 0.497,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #96 (suporte:4, confianca:0.75)
encaminhamento(autocuidados, 'ML: Padrao de sintomas indica tratamento em casa.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, crianca_febril, CF_6),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_7),
    verifica_negativo(sintoma, sintomas_gripais, CF_8),
    verifica_negativo(sintoma, fraqueza_unilateral, CF_9),
    verifica_negativo(sintoma, dor_flanco, CF_10),
    verifica_negativo(sintoma, tosse_sangue, CF_11),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_12),
    verifica_negativo(sintoma, garganta_exsudados, CF_13),
    verifica_negativo(sintoma, urina_sangue, CF_14),
    verifica_negativo(sintoma, edema_membros, CF_15),
    verifica_negativo(sintoma, confusao_mental, CF_16),
    verifica_exato(sintoma, gravidez, CF_17),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    minimo(T15, CF_17, T16),
    CF_Premissa = T16,
    CF_Premissa >= 0.5,
    CF_Regra = 0.413,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #97 (suporte:4, confianca:0.75)
encaminhamento(autocuidados, 'ML: Padrao de sintomas indica tratamento em casa.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_exato(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, cianose, CF_3),
    verifica_negativo(sintoma, pieira, CF_4),
    verifica_negativo(sintoma, febre, CF_5),
    verifica_negativo(sintoma, olfato_paladar, CF_6),
    verifica_negativo(sintoma, tosse_cronica, CF_7),
    verifica_negativo(sintoma, pieira_intensa, CF_8),
    verifica_negativo(sintoma, palpitacoes_graves, CF_9),
    verifica_negativo(sintoma, tosse_sangue, CF_10),
    verifica_negativo(sintoma, inchaco_face_labios, CF_11),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    CF_Premissa = T10,
    CF_Premissa >= 0.5,
    CF_Regra = 0.413,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #98 (suporte:6, confianca:0.71)
encaminhamento(autocuidados, 'ML: Padrao de sintomas indica tratamento em casa.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, crianca_febril, CF_6),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_7),
    verifica_negativo(sintoma, sintomas_gripais, CF_8),
    verifica_negativo(sintoma, fraqueza_unilateral, CF_9),
    verifica_negativo(sintoma, dor_flanco, CF_10),
    verifica_negativo(sintoma, tosse_sangue, CF_11),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_12),
    verifica_negativo(sintoma, garganta_exsudados, CF_13),
    verifica_negativo(sintoma, urina_sangue, CF_14),
    verifica_exato(sintoma, edema_membros, CF_15),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    CF_Premissa = T14,
    CF_Premissa >= 0.5,
    CF_Regra = 0.393,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #99 (suporte:5, confianca:0.67)
encaminhamento(autocuidados, 'ML: Padrao de sintomas indica tratamento em casa.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, crianca_febril, CF_6),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_7),
    verifica_negativo(sintoma, sintomas_gripais, CF_8),
    verifica_negativo(sintoma, fraqueza_unilateral, CF_9),
    verifica_negativo(sintoma, dor_flanco, CF_10),
    verifica_negativo(sintoma, tosse_sangue, CF_11),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_12),
    verifica_negativo(sintoma, garganta_exsudados, CF_13),
    verifica_exato(sintoma, urina_sangue, CF_14),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    CF_Premissa = T13,
    CF_Premissa >= 0.5,
    CF_Regra = 0.367,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #100 (suporte:3, confianca:0.67)
encaminhamento(autocuidados, 'ML: Padrao de sintomas indica tratamento em casa.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_negativo(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, sintomas_gripais, CF_6),
    verifica_negativo(sintoma, assimetria_facial_fala, CF_7),
    verifica_negativo(sintoma, cefaleia_subita, CF_8),
    verifica_negativo(sintoma, vomitos_sangue, CF_9),
    verifica_negativo(sintoma, crianca_febril, CF_10),
    verifica_negativo(sintoma, saturacao_baixa, CF_11),
    verifica_exato(sintoma, febre_3_dias, CF_12),
    verifica_negativo(sintoma, gastricos_prolongados, CF_13),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    CF_Premissa = T12,
    CF_Premissa >= 0.5,
    CF_Regra = 0.367,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #101 (suporte:3, confianca:0.67)
encaminhamento(autocuidados, 'ML: Padrao de sintomas indica tratamento em casa.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, crianca_febril, CF_6),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_7),
    verifica_negativo(sintoma, sintomas_gripais, CF_8),
    verifica_negativo(sintoma, fraqueza_unilateral, CF_9),
    verifica_negativo(sintoma, dor_flanco, CF_10),
    verifica_negativo(sintoma, tosse_sangue, CF_11),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_12),
    verifica_negativo(sintoma, garganta_exsudados, CF_13),
    verifica_negativo(sintoma, urina_sangue, CF_14),
    verifica_negativo(sintoma, edema_membros, CF_15),
    verifica_exato(sintoma, confusao_mental, CF_16),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    minimo(T12, CF_14, T13),
    minimo(T13, CF_15, T14),
    minimo(T14, CF_16, T15),
    CF_Premissa = T15,
    CF_Premissa >= 0.5,
    CF_Regra = 0.367,
    CF_Final is CF_Premissa * CF_Regra.

% Regra ML #102 (suporte:4, confianca:0.60)
encaminhamento(autocuidados, 'ML: Padrao de sintomas indica tratamento em casa.', CF_Final) :-
    verifica_negativo(sintoma, emergencia, CF_0),
    verifica_negativo(sintoma, ansiedade_extrema, CF_1),
    verifica_negativo(sintoma, sintomas_respiratorios, CF_2),
    verifica_negativo(sintoma, febre, CF_3),
    verifica_negativo(sintoma, infecao_urinaria, CF_4),
    verifica_exato(sintoma, doencas_cronicas, CF_5),
    verifica_negativo(sintoma, crianca_febril, CF_6),
    verifica_negativo(sintoma, expectoracao_purulenta, CF_7),
    verifica_negativo(sintoma, sintomas_gripais, CF_8),
    verifica_negativo(sintoma, fraqueza_unilateral, CF_9),
    verifica_negativo(sintoma, dor_flanco, CF_10),
    verifica_negativo(sintoma, tosse_sangue, CF_11),
    verifica_negativo(sintoma, infecao_urinaria_febre, CF_12),
    verifica_exato(sintoma, garganta_exsudados, CF_13),
    minimo(CF_0, CF_1, T0),
    minimo(T0, CF_2, T1),
    minimo(T1, CF_3, T2),
    minimo(T2, CF_4, T3),
    minimo(T3, CF_5, T4),
    minimo(T4, CF_6, T5),
    minimo(T5, CF_7, T6),
    minimo(T6, CF_8, T7),
    minimo(T7, CF_9, T8),
    minimo(T8, CF_10, T9),
    minimo(T9, CF_11, T10),
    minimo(T10, CF_12, T11),
    minimo(T11, CF_13, T12),
    CF_Premissa = T12,
    CF_Premissa >= 0.5,
    CF_Regra = 0.33,
    CF_Final is CF_Premissa * CF_Regra.

% === FIM REGRAS PARTE B (geradas por ML) ===
