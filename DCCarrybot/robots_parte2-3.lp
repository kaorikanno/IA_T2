% Tiempo desde 1 hasta bound
time(1..bound).

% Acciones disponibles para el robot
action(up).
action(down).
action(left).
action(right).
action(wait).
action(liftBox).
action(turn_left).        %         añadimos la opción de girar
action(turn_right).

% ------------------------ añadimos la direccion a robotOn según hacia donde se mueva ----------------------------
% Un robot puede desplazarse en las direcciones de: arriba, abajo, izquierda, derecha y esperar y debe mirar esa direccion
% ------------------------------ añadimos las direcciones a las que puede girar ------------------------

% Un robot puede desplazarse en las direcciones de: arriba, abajo, izquierda, derecha y esperar
robotOn(R, X, Y - 1, T + 1, 1, E-1) :- exec(R, up, T), robotOn(R, X, Y, T, 1, E), time(T + 1).
robotOn(R, X, Y + 1, T + 1, 2, E-1) :- exec(R, down, T), robotOn(R, X, Y, T, 2, E), time(T + 1).
robotOn(R, X - 1, Y, T + 1, 3, E-1) :- exec(R, left, T), robotOn(R, X, Y, T, 3, E), time(T + 1).
robotOn(R, X + 1, Y, T + 1, 4, E-1) :- exec(R, right, T), robotOn(R, X, Y, T, 4, E), time(T + 1).
robotOn(R, X, Y, T + 1, D, E) :- exec(R, wait, T), robotOn(R, X, Y, T, D, E), time(T + 1).

robotOn(R, X, Y, T + 1, 1, E-1) :- exec(R, turn_right, T), robotOn(R, X, Y, T, 4, E), time(T + 1).
robotOn(R, X, Y, T + 1, 2, E-1) :- exec(R, turn_left, T), robotOn(R, X, Y, T, 4, E), time(T + 1).

robotOn(R, X, Y, T + 1, 4, E-1) :- exec(R, turn_right, T), robotOn(R, X, Y, T, 1, E), time(T + 1).
robotOn(R, X, Y, T + 1, 3, E-1) :- exec(R, turn_left, T), robotOn(R, X, Y, T, 1, E), time(T + 1).

robotOn(R, X, Y, T + 1, 3, E-1) :- exec(R, turn_right, T), robotOn(R, X, Y, T, 2, E), time(T + 1).
robotOn(R, X, Y, T + 1, 4, E-1) :- exec(R, turn_left, T), robotOn(R, X, Y, T, 2, E), time(T + 1).

robotOn(R, X, Y, T + 1, 2, E-1) :- exec(R, turn_right, T), robotOn(R, X, Y, T, 3, E), time(T + 1).
robotOn(R, X, Y, T + 1, 1, E-1) :- exec(R, turn_left, T), robotOn(R, X, Y, T, 3, E), time(T + 1).

% La caja pasa a estar en la posición del robot, levantada y este último mantiene su localización. Se indica que hay una caja encima del robot.
% aquí le añadimos un gasto energetico al acto de levantar la caja.
3{boxOn(B, X - 1, Y, 1, T + 1); robotOn(R, X - 1, Y, T + 1, D, E-1); boxOnRobot(B, R, T + 1)}3 :- robotLiftBox(R, B, T), robotOn(R, X - 1, Y, T, D, E), time(T + 1), boxOn(B, X, Y, Z, T), robot(R), Z = 0. 
3{boxOn(B, X + 1, Y, 1, T + 1); robotOn(R, X + 1, Y, T + 1, D, E-1); boxOnRobot(B, R, T + 1)}3 :- robotLiftBox(R, B, T), robotOn(R, X + 1, Y, T, D, E), time(T + 1), boxOn(B, X, Y, Z, T), robot(R), Z = 0.
3{boxOn(B, X, Y - 1, 1, T + 1); robotOn(R, X, Y - 1, T + 1, D, E-1); boxOnRobot(B, R, T + 1)}3 :- robotLiftBox(R, B, T), robotOn(R, X, Y - 1, T, D, E), time(T + 1), boxOn(B, X, Y, Z, T), robot(R), Z = 0. 
3{boxOn(B, X, Y + 1, 1, T + 1); robotOn(R, X, Y + 1, T + 1, D, E-1); boxOnRobot(B, R, T + 1)}3 :- robotLiftBox(R, B, T), robotOn(R, X, Y + 1, T, D, E), time(T + 1), boxOn(B, X, Y, Z, T), robot(R), Z = 0. 

% Si hay una caja encima de un robot, hay una caja recogida. Si no está recogida la caja está en el piso
boxPickedUp(B, T) :- boxOnRobot(B, R, T). 
boxOn(B, X, Y, 0, T + 1) :- boxOn(B, X, Y, Z, T), Z = 0, not boxPickedUp(B, T + 1), time(T + 1), box(B).

% Si el robot se mueve, la caja también.
boxOn(B, X, Y, 1, T) :- robotOn(R, X, Y, T, D, E), boxOnRobot(B, R, T), time(T).
boxOnRobot(B, R, T + 1) :- boxOnRobot(B, R, T), time(T + 1).

% Un robot es capaz de levantar una caja, únicamente si está adyacente a él. Se define que es que esté adyacente.
% añadiremos que el robot debe mirar hacia la caja añadiendo las direcciones que se deben mirar en cada caso
boxAdjacentToRobot(B, R, T) :- robotOn(R, X - 1, Y, T, 4, E), boxOn(B, X, Y, Z, T), robot(R), time(T), box(B), Z = 0.
boxAdjacentToRobot(B, R, 0) :- robotOn(R, X - 1, Y, 0, 4, E), boxOn(B, X, Y, Z, 0), robot(R), box(B), Z = 0.
boxAdjacentToRobot(B, R, T) :- robotOn(R, X + 1, Y, T, 3, E), boxOn(B, X, Y, Z, T), robot(R), time(T), box(B), Z = 0.
boxAdjacentToRobot(B, R, 0) :- robotOn(R, X + 1, Y, 0, 3, E), boxOn(B, X, Y, Z, 0), robot(R), box(B), Z = 0.
boxAdjacentToRobot(B, R, T) :- robotOn(R, X, Y - 1, T, 2, E), boxOn(B, X, Y, Z, T), robot(R), time(T), box(B), Z = 0.
boxAdjacentToRobot(B, R, 0) :- robotOn(R, X, Y - 1, 0, 2, E), boxOn(B, X, Y, Z, 0), robot(R), box(B), Z = 0.
boxAdjacentToRobot(B, R, T) :- robotOn(R, X, Y + 1, T, 1, E), boxOn(B, X, Y, Z, T), robot(R), time(T), box(B), Z = 0.
boxAdjacentToRobot(B, R, 0) :- robotOn(R, X, Y + 1, 0, 1, E), boxOn(B, X, Y, Z, 0), robot(R), box(B), Z = 0.

% Cantidad de cajas adyacentes
boxesAdjactentToRobot(R, T, N) :- robot(R), N = #count{B : boxAdjacentToRobot(B, R, T)}, time(T).
boxesAdjactentToRobot(R, 0, N) :- robot(R), N = #count{B : boxAdjacentToRobot(B, R, 0)}.

% Un robot ejecuta una acción en cada tiempo.
1 {exec(R, A, T) : action(A)} 1 :- robot(R), time(T + 1).

% Se levanta la caja
1{robotLiftBox(R, B, T): boxAdjacentToRobot(B, R, T)}1 :- exec(R, liftBox, T), time(T + 1), robot(R).

% No se puede levantar la caja si el robot no esta adyacente
:- robotLiftBox(R, B, T), boxesAdjactentToRobot(R, T, N), N = 0.

% Un robot no puede llevar más de una caja al mismo tiempo
:- robotLiftBox(R1, B, T), robotLiftBox(R2, B, T), R1 != R2. 

% Una caja puede ser llevada por un único robot.
:- boxOnRobot(B1, R, T), boxOnRobot(B2, R, T), B1 != B2.

% Un robot no estar encima por un obstáculo, o afuera del mapa, al igual que la caja.
:- robotOn(R, X, Y, T, D, E), not rangeX(X).
:- robotOn(R, X, Y, T, D, E), not rangeY(Y).
:- boxOn(B, X, Y, Z, T), not rangeX(X).
:- boxOn(B, X, Y, Z, T), not rangeY(Y).
:- robotOn(R, X, Y, T, D, E), obstacle(X, Y).
:- boxOn(B, X, Y, Z, T), obstacle(X, Y).

% No puede haber más de un robot en la misma casilla y más de una caja en la misma casilla.
:- robotOn(R1, X, Y, T, D1, E1), robotOn(R2, X, Y, T, D2, E2), R1 != R2.
:- boxOn(B1, X, Y, Z, T), boxOn(B2, X, Y, Z, T), B1 != B2, Z = 0.

% No se pueden cruzar robots. No puede estar un robot y una caja sin levantar en la misma casilla.
:- robotOn(R1, X, Y, T, D1, E1), robotOn(R2, X + 1, Y, T, D2, E2), robotOn(R2, X, Y, T + 1, D2, E2), robotOn(R1, X + 1, Y, T + 1, D1, E1).
:- robotOn(R1, X, Y, T, D1, E1), robotOn(R2, X, Y + 1, T, D2, E2), robotOn(R2, X, Y, T + 1, D2, E2), robotOn(R1, X, Y + 1, T + 1, D1, E1).
:- robotOn(R, X, Y, T, D, E), boxOn(B, X, Y, Z, T), Z = 0, box(B), time(T).

% Caja esta en un objetivo en el tiempo T.
at_goal(B, T) :- boxOn(B, X, Y, Z, T), goal(X, Y).
:- box(B), not at_goal(B, bound).

% --------------------- la energia no puede ser menor a 0 ----------------------

:- robotOn(R, X, Y, T, D, E), E < 0.

% --------------------- Visualizador -----------------------------------

% Mediante la siguiente línea de comandos se ejecutará el programa original con un test antiguo
% Si python3 no funciona, reemplazar por python
% clingo robot1.lp tests/old.lp -c bound=14 | python process.py

% El resto de los tests deberán ser probados mediante la línea (con N el número máximo de pasos para resolver el problema)
% clingo robot3.lp tests/TESTNAME.lp -c bound=N | python3 process.py
%E4: b = 6; E5: b = 9; E6: b = 8; E7: b= 10. 
% ------------------------- #show --------------------------------------

#show time/1.
#show boxOn/5.
#show obstacle/2.
#show rangeX/1.
#show rangeY/1.
#show goal/2.
#show robotOn/5.
#show robotOn/6.