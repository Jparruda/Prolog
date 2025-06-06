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

% regras

gerou(X, Y) :- pai(X, Y);
			   mae(X, Y).

irmão(X, Y) :- homem(X),
			   gerou(Z, X),
			   gerou(Z, Y),
			   X \== Y.

irmã(X, Y) :- mulher(X),
			  gerou(Z, X),
			  gerou(Z, Y),
			  X \== Y.

avô(X, Y) :- homem(X),
    		 pai(X, Z),
    		 (pai(Z, Y); mae(Z, Y)).

avó(X, Y) :- mulher(X),
    		 mae(X, Z),
    		 (pai(Z, Y); mae(Z, Y)).

tio(X, Y) :- homem(X),
             (pai(Z, Y); mae(Z, Y)), 
             irmão(X, Z).

tia(X, Y) :- mulher(X),
             (pai(Z, Y); mae(Z, Y)), 
             irmã(X, Z).

casal(X, Y) :- (pai(X, Z), mae(Y, Z));
			    (mae(X, Z), pai(Y, Z)).

feliz(X) :- gerou(X, _).

% o cut é usado para podar a ávore de verificação (!)