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
% TODO:ORGANIZAR AS QUESTÕES
joga(ana,volei).
joga(bia,tenis).
joga(ivo,basquete).
joga(eva,volei).
joga(leo,tenis).

nomes = ['Ana', 'Bia', 'Ivo', 'Lia', 'Eva', 'Ary']
sexo = [fem, fem, masc, fem, fem, masc]
idade = [23, 19, 22, 17, 28, 25]
altura = [1.55, 1.71, 1.80, 1.85, 1.75, 1.72]
peso = [56.0, 61.3, 70.5, 57.3, 68.7, 68.9]

num(N,positivo) :- N>0.
num(0,nulo).
num(N,negativo) :- N<0.
