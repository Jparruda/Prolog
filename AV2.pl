% Define a quantidade de tipos de resíduos/produtos
qtd_residuos(3).  % [apagador, papel, provas]

% Guarda a quantidade de salas existentes
:- dynamic qtd_salas/1.
qtd_salas(0).

% Define cada sala e seus conteúdos
:- dynamic sala/2.

% Controla a posição atual do agente (0 = depósito)
:- dynamic pos/1.
pos(0).

% Define o lixo do agente
:- dynamic lixo/1.
lixo([0,0,0]).

% Inicializa o lixo
lixo_inicial :-
    retractall(lixo(_)),
    assertz(lixo([0,0,0])).

% Adiciona itens ao lixo, somando por tipo
att_lixo(Itens) :-
    lixo(Atual),
    soma_listas(Atual, Itens, Novo),
    retract(lixo(Atual)),
    assertz(lixo(Novo)).

% Descarrega o lixo no depósito
descarregar_lixo :-
    lixo_inicial,
    writeln('Lixo esvaziado no depósito!').

% Mostra o conteúdo do lixo
status_lixo :-
    lixo(Itens),
    write('Lixo contém: '), writeln(Itens).

% Movimentação do agente
mover(Dest) :- pos(Origem), Origem =:= Dest, !.
mover(Dest) :- pos(Origem), Origem =:= 0,
    retract(pos(Origem)), assertz(pos(Dest)),
    write('Agente saiu do depósito para a sala '), writeln(Dest), !.
mover(Dest) :- pos(Origem), Dest =:= 0,
    retract(pos(Origem)), assertz(pos(Dest)),
    write('Agente saiu da sala '), write(Origem), writeln(' e voltou ao depósito'), !.
mover(Dest) :- pos(Origem),
    retract(pos(Origem)), assertz(pos(Dest)),
    write('Agente foi da sala '), write(Origem),
    write(' para a sala '), writeln(Dest).

% Executa a limpeza de uma lista de tarefas [apagador, papel, provas]
fazer_limpeza(Tarefas) :-
    qtd_residuos(Qtd),
    length(Tarefas, Qtd),
    lixo_inicial,
    writeln('Tarefas de limpeza recebidas! Planejando rota...'),
    encontrar_salas(Tarefas, Candidatos),
    writeln('Rotas possíveis encontradas!'),
    write_candidatos(Candidatos),
    writeln('Selecionando melhor rota...'),
    calc_valor(Candidatos, ValorCandidatos),
    max_valor(ValorCandidatos, _-MelhorRota),
    writeln('Melhor rota escolhida!'),
    write_rota(MelhorRota),
    cursar_rota(Tarefas, MelhorRota),
    writeln('Limpeza concluída!'),
    status_lixo, !.

% Descartar lixo e retornar ao depósito
descartar_lixo :-
    descarregar_lixo,
    mover(0).

% Reabastecer sala com novos materiais [apagador, papel, provas]
reabastecer_sala(NumSala, Materiais) :-
    lixo_inicial,
    write('Reposição de materiais na sala '), write(NumSala), writeln(' iniciada...'),
    att_lixo(Materiais),
    writeln('Materiais coletados!'),
    sala(NumSala, Antigos),
    mover(NumSala),
    soma_listas(Antigos, Materiais, Atualizados),
    retract(sala(NumSala, Antigos)),
    assertz(sala(NumSala, Atualizados)),
    descarregar_lixo,
    write('Sala '), write(NumSala), writeln(' reabastecida com sucesso!').

% Remove uma sala da base de conhecimento
remover_sala(NumSala) :-
    sala(NumSala, Conteudo),
    retract(sala(NumSala, Conteudo)),
    qtd_salas(QtdAtual),
    NovoQtd is QtdAtual - 1,
    retract(qtd_salas(QtdAtual)),
    assertz(qtd_salas(NovoQtd)),
    write('Sala '), write(NumSala), writeln(' removida com sucesso!').

remover_sala(NumSala) :-
    \+ sala(NumSala, _),
    write('Erro: Sala '), write(NumSala), writeln(' não existe.').

% Funções auxiliares
write_candidatos([]).
write_candidatos([C|Cs]) :- writeln(C), write_candidatos(Cs).

write_rota(Rota) :- write('Rota escolhida: '), writeln(Rota).

soma_listas([], [], []).
soma_listas([H1|T1], [H2|T2], [H3|T3]) :-
    H3 is H1 + H2,
    soma_listas(T1, T2, T3).

encontrar_salas(_, [[1,2],[2,3]]).

calc_valor(Rotas, Valores) :-
    findall(V-R, (member(R, Rotas), length(R, V)), Valores).

max_valor([V-R|T], Max) :- max_valor(T, V-R, Max).
max_valor([], Max, Max).
max_valor([V-R|T], V1-R1, Max) :-
    (V > V1 -> max_valor(T, V-R, Max) ; max_valor(T, V1-R1, Max)).

% Coletar resíduos de uma sala, sem pegar mais do que existe
coletar_residuos_sala(NumSala, Tarefas) :-
    sala(NumSala, ConteudoAtual),
    limitar_tarefas(Tarefas, ConteudoAtual, ColetaReal),
    att_lixo(ColetaReal),
    subtrair_listas(ConteudoAtual, ColetaReal, ConteudoNovo),
    retract(sala(NumSala, ConteudoAtual)),
    assertz(sala(NumSala, ConteudoNovo)),
    write('Agente coletou '), writeln(ColetaReal),
    write('Sala '), write(NumSala), write(' agora contém: '), writeln(ConteudoNovo).

limitar_tarefas([], [], []).
limitar_tarefas([T|Ts], [C|Cs], [R|Rs]) :-
    R is min(T, C),
    limitar_tarefas(Ts, Cs, Rs).

subtrair_listas([], [], []).
subtrair_listas([C|Cs], [R|Rs], [N|Ns]) :-
    N is C - R,
    subtrair_listas(Cs, Rs, Ns).

% Atualiza cursa_rota para usar coleta realista
cursar_rota(_, []).
cursar_rota(Tarefas, [S|Ss]) :-
    mover(S),
    coletar_residuos_sala(S, Tarefas),
    cursar_rota(Tarefas, Ss).

% Menu de ajuda
h :-
    writeln('===== AJUDA DO AGENTE DE LIMPEZA ====='),
    writeln('Comandos principais:'),
    writeln('  ?- fazer_limpeza(Lista).       % Executa a limpeza conforme a lista [apagador, papel, provas]'),
    writeln('  ?- status_lixo.                % Mostra o que o agente coletou no lixo'),
    writeln('  ?- descartar_lixo.             % Descarte os resíduos coletados no depósito'),
    writeln('  ?- reabastecer_sala(N,Itens). % Reabastece a sala N com materiais [apagador, papel, provas]'),
    writeln('  ?- remover_sala(N).            % Remove a sala N da base de conhecimento'),
    writeln('  ?- mover(Dest).                % Move o agente até uma sala (ou 0 = depósito)'),
    writeln('Digite h. para exibir esta ajuda novamente.'),
    writeln('======================================='). 
