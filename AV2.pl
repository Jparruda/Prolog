qtd_residuos(3).

:- dynamic qtd_salas/1.
qtd_salas(0).

:- dynamic sala/2.

:- dynamic pos/1.
pos(0).

:- dynamic lixo/1.
lixo([0,0,0]).

% Criar nova sala
criar_sala(NumSala, Residuos) :-
    retract(qtd_salas(Qtd)),
    QtdNovo is Qtd + 1,
    assertz(qtd_salas(QtdNovo)),
    assertz(sala(NumSala, Residuos)),
    write('Sala '), write(NumSala), write(' criada com conteúdo: '), writeln(Residuos).

% Inicializa lixo
lixo_inicial :-
    retractall(lixo(_)),
    assertz(lixo([0,0,0])),
    writeln('Lixo reinicializado.')

% Atualiza lixo do agente
att_lixo(Itens) :-
    lixo(Atual),
    soma_listas(Atual, Itens, Novo),
    retract(lixo(Atual)),
    assertz(lixo(Novo)),
    write('Itens coletados: '), writeln(Itens),
    write('Lixo atual: '), writeln(Novo).

% Soma elemento a elemento duas listas
soma_listas([], [], []).
soma_listas([X|Xs], [Y|Ys], [Z|Zs]) :-
    Z is X + Y,
    soma_listas(Xs, Ys, Zs).

% Move agente
mover(Dest) :-
    pos(Origem),
    Origem =:= Dest,
    write('Agente já está na posição '), writeln(Dest), !.

mover(Dest) :-
    retract(pos(Origem)),
    assertz(pos(Dest)),
    write('Agente moveu-se de '), write(Origem), write(' para '), writeln(Dest).

% Coleta resíduos apenas se estiver na sala
fazer_limpeza(NumSala) :-
    pos(NumSala), !,
    sala(NumSala, Residuos),
    att_lixo(Residuos),
    retract(sala(NumSala, _)),
    assertz(sala(NumSala, [0,0,0])),
    write('Sala '), write(NumSala), writeln(' limpa com sucesso.').

fazer_limpeza(NumSala) :-
    pos(Pos),
    Pos =\= NumSala,
    write('Erro: o agente não está na sala '), writeln(NumSala), !.

% Repor materiais em qualquer sala
repor_materiais(NumSala, Materiais) :-
    sala(NumSala, Residuos),
    soma_listas(Residuos, Materiais, Novo),
    retract(sala(NumSala, _)),
    assertz(sala(NumSala, Novo)),
    write('Materiais '), write(Materiais),
    write(' adicionados à sala '), writeln(NumSala),
    write('Novo estado da sala: '), writeln(Novo).

% Descartar lixo no depósito
descartar_lixo :-
    mover(0),
    lixo_inicial,
    writeln('Lixo descartado no depósito com sucesso.').

% Mostrar lixo
status_lixo :-
    lixo(L),
    write('Saco de lixo contém: '), writeln(L).

% Mostrar estado de uma sala
status_sala(NumSala) :-
    sala(NumSala, Conteudo),
    write('Sala '), write(NumSala), write(' contém: '), writeln(Conteudo).

% Mostrar posição atual do agente
status_posicao :-
    pos(P),
    write('Agente está na posição: '), writeln(P).

% Menu de ajuda
h :-
    writeln('Comandos disponíveis:'),
    writeln('criar_sala(NumSala, [apagador,papel,provas])'),
    writeln('fazer_limpeza(NumSala)'),
    writeln('descartar_lixo'),
    writeln('status_lixo'),
    writeln('status_sala(NumSala)'),
    writeln('mover(NumSala)'),
    writeln('status_posicao'),
    writeln('repor_materiais(NumSala, [apagador,papel,provas])').
