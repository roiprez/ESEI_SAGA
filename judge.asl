// Agent judge in project ESEI_SAGA.mas2j

/* Initial beliefs and rules */

contador(100).

size(10).

actual(player1).

valido(P1,P2,Dir):-
	not fueraTablero(P1,P2,Dir).

fueraTablero(P1,P2,Dir):-
	size(N) &
	((Dir == "up" & P2+1 >= N) | (Dir == "right" & P1+1 >= N) | 
	(Dir == "left" & negativo(P1-1)) | (Dir == "down" & negativo(P2-1))).

negativo(X):- X < 0.

/* Initial goals */

!startGame.

/* Plans */

+!startGame : actual(Player) & contador(N) & N>0 <-
	-+contador(N-1);
	.print(N);
	.send(Player,tell,puedesMover);
	.send(Player,untell,puedesMover).

	
+moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)] : actual(A) & valido(P1,P2,Dir) <- 
	-moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)];
	.print("Acabo de verificar el movimiento jugador: ",A);
	.print("Jugador: ", A, " Ficha: " ,P1,", ",P2," en dirección ", Dir);
	.send(A,tell,valido);
	if (A = player1) 
		{-+actual(player2);} 
	else 
		{-+actual(player1);};
	.send(A,untell,valido);
	!startGame.

+moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)] : actual(A) & fueraTablero(P1,P2,Dir) <-
	-moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)];
	.print("Jugador: ", A, " Acabo de comprobar que hay una posición fuera del tablero");
	.print("Jugador: ", A, " Ficha: " ,P1,", ",P2," en dirección ", Dir);
	.send(A,tell,invalido(fueraTablero));
	.send(A,untell,invalido(fueraTablero)).

+moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)] : not actual (A)<-
	-moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)];
	.print("Movimiento no experado del jugador: ",A).

+moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)] : actual (A)<-
	-moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)];
	.print("Movimiento no controlado del jugador: ",A).
	
+moverDesdeEnDireccion(pos(P1,P2),Dir) <-
	-moverDesdeEnDireccion(pos(P1,P2),Dir);
	.print("Movimiento indeterminado").
					
