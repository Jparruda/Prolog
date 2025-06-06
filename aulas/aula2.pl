f(X, 0) :- X < 5.
f(X, 1) :- X >= 5, X =< 9.
f(X, 2) :- X > 9.

% para forçar os termos complexos a se unificarem, forçando-os aritméticamente, pode-se utilizar o "is"