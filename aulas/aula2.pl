f(X, 0) :- X < 5.
f(X, 1) :- X >= 5, X =< 9.
f(X, 2) :- X > 9.

% para forçar os termos complexos a se unificarem, forçando-os aritméticamente, pode-se utilizar o "is"

%func(Código, Nome, Salário)
func(1, ana, 1000.90).
func(2, bia, 1200.00).
func(3, ivo, 903.50).
% dep(Código, Nome)
dep(1, ary).
dep(3, raí).
dep(3, eva).

joga(ana,volei).
joga(bia,tenis).
joga(ivo,basquete).
joga(eva,volei).
joga(leo,tenis).