% ----------------------------------- creacion de la figura --------------------------------------

figura(F) :- bloque(B, F, X, Y, V). %guardamos aqui todas las figuras que debemos colocar en la grilla

1{core(X, Y, F) : grid(X, Y)}1 :-  figura(F).

% creamos el predicado "core", que a cada figura le va a añadir cierta posicion inicial 
% (algo así como tener un bloque base de cada figura y comenzar a contruir sobre esta el resto de bloques)


% solucion(X, Y, V, B, F)

% ahora vamos a armar toda la figura dentro de la grilla:

solucion(X, Y, V1, B1, F) :- bloque(B1, F, X1, Y1, V1), core(X2, Y2, F), X = X1 +X2, Y = Y1 + Y2.

% creamos con esto todos los bloques pedidos, con posiciones tales que conserven la forma de la figura

% ------------------------------------------- restricciones --------------------------------------

:- not grid(X, Y), solucion(X, Y, V, B, F). % no pueden haber soluciones fuera de la grilla

:- solucion(X, Y1, V1, B1, F1), solucion(X, Y2, V2, B2, F2), V1 = V2, B1 != B2, Y1 != Y2. % los valores de la grilla no se pueden repetir en columnas 
:- solucion(X1, Y, V1, B1, F1), solucion(X2, Y, V2, B2, F2), V1 = V2, B1 != B2, X1 != X2. % los valores de la grilla no se pueden repetir en filas

:- solucion(X1, Y1, V1, B1, F1), solucion(X2, Y2, V2, B2, F2), B1 = B2, X1 != X2. % un bloque no puede tener mas de una posición
:- solucion(X1, Y1, V1, B1, F1), solucion(X2, Y2, V2, B2, F2), B1 = B2, Y1 != Y2. % in bloque no puede tener mas de una posición
:- solucion(X, Y, V1, B1, F1), solucion(X, Y, V2, B2, F2), B1 != B2. % dos bloques solucion no pueden estar en el mismo sitio

 

%#show solucion/5.
