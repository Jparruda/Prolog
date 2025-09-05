\documentclass[12pt]{article}

\usepackage{indentfirst}
\usepackage{sbc-template}
\usepackage{float}
\usepackage{graphicx,url}
\usepackage[utf8]{inputenc} 
\usepackage{multicol}
\usepackage{mathtools}
\DeclarePairedDelimiter\ceil{\lceil}{\rceil}
\DeclarePairedDelimiter\floor{\lfloor}{\rfloor}
\usepackage{xurl}
\usepackage{booktabs}
\usepackage{comment}
\usepackage[brazil]{babel}
\usepackage[T1]{fontenc}
\usepackage[latin1]{inputenc} 
\usepackage{listings}
\usepackage{xcolor}
\usepackage[table]{xcolor}

\definecolor{codegreen}{rgb}{0,0.6,0}
\definecolor{codegray}{rgb}{0.5,0.5,0.5}
\definecolor{codepurple}{rgb}{0.8,0,0.2}
\definecolor{backcolour}{rgb}{.95,.95,1}
\setcounter{secnumdepth}{4}
\setcounter{tocdepth}{4}

\lstdefinestyle{mystyle}{
    backgroundcolor=\color{backcolour},   
    commentstyle=\color{codegreen},
    keywordstyle=\color{blue},
    numberstyle=\tiny\color{codegray},
    stringstyle=\color{codepurple},
    basicstyle=\ttfamily\footnotesize,
    breakatwhitespace=false,         
    breaklines=true,                 
    captionpos=b,                    
    keepspaces=true,                 
    numbers=left,                    
    numbersep=5pt,                  
    showspaces=false,                
    showstringspaces=false,
    showtabs=false,                  
    tabsize=2
}

\lstset{style=mystyle}
\sloppy

\title{Trabalho de Programação em Lógica -- Agente de Limpeza}

\author{João Pedro Souza Arruda\inst{1}}

\address{
Instituto de Ciências Exatas e Naturais -- Universidade Federal do Pará (UFPA)\\
Caixa Postal 479 -- Belém -- PA -- Brasil
\email{joao.arruda@icen.ufpa.br}
}

\begin{document} 

\maketitle

\begin{abstract}
Este trabalho apresenta a construção de um agente de limpeza em Prolog. O agente é capaz de se mover entre salas, coletar resíduos, armazenar itens no lixo, reabastecer materiais e informar sua posição atual. As ações do agente fornecem mensagens de retorno detalhadas, garantindo maior controle e monitoramento das operações. O código completo está disponível ao final do documento.
\end{abstract}
     
\begin{resumo} 
Este trabalho descreve a implementação de um agente de limpeza autônomo em Prolog, destacando a manipulação de fatos dinâmicos, atualização do ambiente e comunicação de ações realizadas. O agente interage com salas, coleta resíduos, repõe materiais e mantém rastreabilidade de suas atividades. O código-fonte completo encontra-se ao final.
\end{resumo}

\section{Definição do agente}
O agente de limpeza é capaz de:

\begin{itemize}
    \item Perceber seu ambiente e posição atual.
    \item Coletar resíduos em salas visitadas, mantendo registro no lixo.
    \item Repor materiais em salas, mesmo que não esteja presente na sala.
    \item Atualizar o estado do ambiente dinamicamente.
    \item Informar status do lixo, das salas e de sua posição.
\end{itemize}

As decisões são tomadas com base no estado atual armazenado em fatos dinâmicos do Prolog, garantindo consistência entre percepção e ação.

\section{Definição do ambiente}
O ambiente é composto por salas numeradas e um depósito (sala 0). Cada sala possui três tipos de resíduos: apagador, papel e provas. O agente inicia no depósito e se move entre salas para executar tarefas.  

A base de conhecimento é dinâmica, permitindo:

\begin{itemize}
    \item Adição e remoção de salas.
    \item Atualização de resíduos e materiais.
    \item Consulta de status das salas, lixo e posição do agente.
\end{itemize}

\begin{lstlisting}[language=Prolog, caption=Definições iniciais do ambiente]
qtd_residuos(3). % [apagador, papel, provas]

:- dynamic qtd_salas/1.
qtd_salas(0).

:- dynamic sala/2. % sala(NumSala, [residuos])

:- dynamic pos/1.
pos(0).

:- dynamic lixo/1.
lixo([0,0,0]).
\end{lstlisting}

\section{Predicados do agente}

\begin{lstlisting}[language=Prolog, caption=Manipulação do ambiente e ações do agente]
criar_sala(NumSala, Residuos) :-
    retract(qtd_salas(Qtd)),
    QtdNovo is Qtd + 1,
    assertz(qtd_salas(QtdNovo)),
    assertz(sala(NumSala, Residuos)),
    write('Sala '), write(NumSala), write(' criada com conteúdo: '), writeln(Residuos)).

lixo_inicial :-
    retractall(lixo(_)),
    assertz(lixo([0,0,0])),
    writeln('Lixo reinicializado.').

att_lixo(Itens) :-
    lixo(Atual),
    soma_listas(Atual, Itens, Novo),
    retract(lixo(Atual)),
    assertz(lixo(Novo)),
    write('Itens coletados: '), writeln(Itens),
    write('Lixo atual: '), writeln(Novo).

soma_listas([], [], []).
soma_listas([X|Xs], [Y|Ys], [Z|Zs]) :-
    Z is X + Y,
    soma_listas(Xs, Ys, Zs).

mover(Dest) :-
    pos(Origem),
    Origem =:= Dest,
    write('Agente já está na posição '), writeln(Dest), !.
mover(Dest) :-
    retract(pos(Origem)),
    assertz(pos(Dest)),
    write('Agente moveu-se de '), write(Origem), write(' para '), writeln(Dest).

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

repor_materiais(NumSala, Materiais) :-
    sala(NumSala, Residuos),
    soma_listas(Residuos, Materiais, Novo),
    retract(sala(NumSala, _)),
    assertz(sala(NumSala, Novo)),
    write('Materiais '), write(Materiais),
    write(' adicionados à sala '), writeln(NumSala),
    write('Novo estado da sala: '), writeln(Novo).

descartar_lixo :-
    mover(0),
    lixo_inicial,
    writeln('Lixo descartado no depósito com sucesso.').

status_lixo :-
    lixo(L),
    write('Saco de lixo contém: '), writeln(L).

status_sala(NumSala) :-
    sala(NumSala, Conteudo),
    write('Sala '), write(NumSala), write(' contém: '), writeln(Conteudo).

status_posicao :-
    pos(P),
    write('Agente está na posição: '), writeln(P).

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
\end{lstlisting}

\section{Exemplo de uso}

\begin{lstlisting}[language=Prolog, caption=Exemplo completo de execução]
?- criar_sala(1, [0,1,2]).
?- criar_sala(2, [2,0,1]).
?- status_posicao.
?- mover(1).
?- fazer_limpeza(1).
?- status_lixo.
?- repor_materiais(2, [1,0,2]).
?- status_sala(2).
?- descartar_lixo.
?- status_lixo.
\end{lstlisting}

\section{Conclusão}
O agente implementado é capaz de:

\begin{itemize}
    \item Limpar salas apenas se estiver presente nelas.
    \item Repor materiais em qualquer sala, independentemente de sua posição.
    \item Informar status do lixo, das salas e sua posição atual.
    \item Atualizar dinamicamente o ambiente e fornecer mensagens de retorno detalhadas em cada ação.
\end{itemize}

A implementação demonstra conceitos de lógica de predicados, manipulação de fatos dinâmicos e modelagem de agentes autônomos em Prolog, garantindo rastreabilidade e controle das operações.

O código completo está disponível no repositório:

\url{https
