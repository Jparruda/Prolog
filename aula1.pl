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

% Definição de mães
mãe(ana, eva).
mãe(eva, noe).
mãe(bia, clo).
mãe(bia, rai).
mãe(bia, ary).
mãe(lia, gal).

gerou(X, Y) :- pai(X, Y);
			   mãe(X, Y).
