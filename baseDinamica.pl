% Declaramos que o predicado "lampada/1" pode mudar dinamicamente
:- dynamic lampada/1.

% Estado inicial da lâmpada
lampada(apagada).

% Liga a lâmpada
liga :- 
    retract(lampada(_)),        % remove o estado atual (acesa ou apagada)
    asserta(lampada(acesa)).    % adiciona o novo estado

% Desliga a lâmpada
desliga :- 
    retract(lampada(_)),        
    asserta(lampada(apagada)).

% Mostra o estado atual
estado :- 
    lampada(X),
    format('A lâmpada está ~w.~n', [X]).
