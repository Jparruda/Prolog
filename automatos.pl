% Transições: q(estado_atual, leitura_fita, desempilha, empilha, proximo_estado).
q(1, 'e', 'e', '$', 2).
q(2, '0', 'e', '0', 2).
q(2, '1', '0', 'e', 3).
q(3, '1', '0', 'e', 3).
q(3, 'e', '$', 'e', 4).

inicio(1).
final(4).

teste(X) :- string_chars(X, Fita),
            inicio(No),
            reconhecedor(No, Fita, []), !.

reconhecedor(No, [], []) :- final(No), !.
reconhecedor(De,[], Pilha) :- q(De, e, L, E, Para),
    atualiza_pilha(Pilha, L, E, Nova_Pilha),
    reconhecedor(Para, [], Nova_Pilha).
reconhecedor(De,Fita, Pilha) :- q(De, X, L, E, Para),
    X \== e,
    caminha(X, Fita, Nova_Fita),
    atualiza_pilha(Pilha, L, E, Nova_Pilha),
    reconhecedor(Para, Nova_Fita, Nova_Pilha).
reconhecedor(De,Fita, Pilha) :- q(De, e, L, E, Para),
    atualiza_pilha(Pilha, L, E, Nova_Pilha),
    reconhecedor(Para, Fita, Nova_Pilha).

caminha(H,[H | T],T).

atualiza_pilha(Pilha, L, D, Nova_Pilha) :- atualiza_leitura(Pilha, L, P1),
       atualiza_escrita(P1, D, Nova_Pilha).
atualiza_leitura([L | Pilha], L, Pilha).
atualiza_leitura(Pilha, e, Pilha).
atualiza_escrita(Pilha, e, Pilha) :- !.
atualiza_escrita(Pilha, E, [E | Pilha]).



inicio(q1).
final(q2).

p(q1,'0',q1).
p(q1,'1',q2).
p(q2,'0',q3).
p(q2,'1',q2).
p(q3,'0',q2).
p(q3,'1',q2).

teste(X) :- string_chars(X, Fita),
            inicio(No),
            reconhecedor(No, Fita), !.

reconhecedor(No,[]) :- final(No), !.
reconhecedor(De,Fita) :- p(De, X, Para),
                         caminha(X, Fita, Nova_Fita),
                         reconhecedor(Para, Nova_Fita).

caminha(H,[H | T],T).

inicio(q0).
final(q2).

p(q0,a,q0).
p(q0,ε,q1).
p(q1,b,q1).
p(q1,ε,q2).
p(q2,a,q2).

teste(X) :- string_chars(X, Fita),
            inicio(No),
            reconhecedor(No, Fita), !.

reconhecedor(No,[]) :- final(No), !.
reconhecedor(De,[]) :-   p(De, ε, Para),
                         reconhecedor(Para, []).
reconhecedor(De,Fita) :- (p(De, X, Para); p(De, ε, Para)),
                         caminha(X, Fita, Nova_Fita),
                         reconhecedor(Para, Nova_Fita).

caminha(H,[H | T],T).
