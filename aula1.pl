% Definição de homens
homem(ivo).
homem(rai).
homem(noe).
homem(gil).
homem(ary).

% Definição de mulheres
mulher(ana).
mulher(eva).
mulher(bia).
mulher(clo).
mulher(lia).
mulher(gal).

% Definição de pais
pai(ivo, eva).
pai(rai, noe).
pai(gil, clo).
pai(gil, rai).
pai(gil, ary).
pai(ary, gal).

% Definição de maes
mae(ana, eva).
mae(eva, noe).
mae(bia, clo).
mae(bia, rai).
mae(bia, ary).
mae(lia, gal).

gerou(X, Y) :- pai(X, Y);
			   mae(X, Y).
