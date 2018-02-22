// Agent judge in project ESEI_SAGA.mas2j

/* Initial beliefs and rules */
ficha(Color,Tipo).
celda(X,Y,Own).
estructura(ficha,celda).

estructura(ficha(1,in),celda(0,0,0)).
estructura(ficha(3,in),celda(0,1,0)).
estructura(ficha(4,in),celda(0,2,0)).
estructura(ficha(5,in),celda(0,3,0)).
estructura(ficha(2,in),celda(0,4,0)).
estructura(ficha(3,in),celda(0,5,0)).
estructura(ficha(4,in),celda(0,6,0)).
estructura(ficha(1,in),celda(0,7,0)).
estructura(ficha(0,in),celda(0,8,0)).
estructura(ficha(3,in),celda(0,9,0)).

estructura(ficha(1,in),celda(1,0,0)).
estructura(ficha(3,in),celda(1,1,0)).
estructura(ficha(2,in),celda(1,2,0)).
estructura(ficha(1,in),celda(1,3,0)).
estructura(ficha(0,in),celda(1,4,0)).
estructura(ficha(3,in),celda(1,5,0)).
estructura(ficha(5,in),celda(1,6,0)).
estructura(ficha(4,in),celda(1,7,0)).
estructura(ficha(1,in),celda(1,8,0)).
estructura(ficha(0,in),celda(1,9,0)).

estructura(ficha(2,in),celda(2,0,0)).
estructura(ficha(4,in),celda(2,1,0)).
estructura(ficha(5,in),celda(2,2,0)).
estructura(ficha(0,in),celda(2,3,0)).
estructura(ficha(0,in),celda(2,4,0)).
estructura(ficha(1,in),celda(2,5,0)).
estructura(ficha(2,in),celda(2,6,0)).
estructura(ficha(0,in),celda(2,7,0)).
estructura(ficha(3,in),celda(2,8,0)).
estructura(ficha(3,in),celda(2,9,0)).

estructura(ficha(3,in),celda(3,0,0)).
estructura(ficha(4,in),celda(3,1,0)).
estructura(ficha(4,in),celda(3,2,0)).
estructura(ficha(5,in),celda(3,3,0)).
estructura(ficha(1,in),celda(3,4,0)).
estructura(ficha(1,in),celda(3,5,0)).
estructura(ficha(2,in),celda(3,6,0)).
estructura(ficha(0,in),celda(3,7,0)).
estructura(ficha(3,in),celda(3,8,0)).
estructura(ficha(0,in),celda(3,9,0)).

estructura(ficha(1,in),celda(4,0,0)).
estructura(ficha(0,in),celda(4,1,0)).
estructura(ficha(1,in),celda(4,2,0)).
estructura(ficha(0,in),celda(4,3,0)).
estructura(ficha(2,in),celda(4,4,0)).
estructura(ficha(3,in),celda(4,5,0)).
estructura(ficha(1,in),celda(4,6,0)).
estructura(ficha(4,in),celda(4,7,0)).
estructura(ficha(5,in),celda(4,8,0)).
estructura(ficha(5,in),celda(4,9,0)).

estructura(ficha(5,in),celda(5,0,0)).
estructura(ficha(5,in),celda(5,1,0)).
estructura(ficha(2,in),celda(5,2,0)).
estructura(ficha(3,in),celda(5,3,0)).
estructura(ficha(0,in),celda(5,4,0)).
estructura(ficha(1,in),celda(5,5,0)).
estructura(ficha(0,in),celda(5,6,0)).
estructura(ficha(2,in),celda(5,7,0)).
estructura(ficha(0,in),celda(5,8,0)).
estructura(ficha(3,in),celda(5,9,0)).

estructura(ficha(0,in),celda(6,0,0)).
estructura(ficha(1,in),celda(6,1,0)).
estructura(ficha(1,in),celda(6,2,0)).
estructura(ficha(2,in),celda(6,3,0)).
estructura(ficha(2,in),celda(6,4,0)).
estructura(ficha(0,in),celda(6,5,0)).
estructura(ficha(3,in),celda(6,6,0)).
estructura(ficha(0,in),celda(6,7,0)).
estructura(ficha(4,in),celda(6,8,0)).
estructura(ficha(5,in),celda(6,9,0)).

estructura(ficha(5,in),celda(7,0,0)).
estructura(ficha(0,in),celda(7,1,0)).
estructura(ficha(4,in),celda(7,2,0)).
estructura(ficha(1,in),celda(7,3,0)).
estructura(ficha(2,in),celda(7,4,0)).
estructura(ficha(0,in),celda(7,5,0)).
estructura(ficha(3,in),celda(7,6,0)).
estructura(ficha(4,in),celda(7,7,0)).
estructura(ficha(1,in),celda(7,8,0)).
estructura(ficha(0,in),celda(7,9,0)).

estructura(ficha(2,in),celda(8,0,0)).
estructura(ficha(2,in),celda(8,1,0)).
estructura(ficha(3,in),celda(8,2,0)).
estructura(ficha(1,in),celda(8,3,0)).
estructura(ficha(0,in),celda(8,4,0)).
estructura(ficha(0,in),celda(8,5,0)).
estructura(ficha(1,in),celda(8,6,0)).
estructura(ficha(5,in),celda(8,7,0)).
estructura(ficha(4,in),celda(8,8,0)).
estructura(ficha(4,in),celda(8,9,0)).

estructura(ficha(2,in),celda(9,0,0)).
estructura(ficha(3,in),celda(9,1,0)).
estructura(ficha(3,in),celda(9,2,0)).
estructura(ficha(1,in),celda(9,3,0)).
estructura(ficha(1,in),celda(9,4,0)).
estructura(ficha(1,in),celda(9,5,0)).
estructura(ficha(2,in),celda(9,6,0)).
estructura(ficha(4,in),celda(9,7,0)).
estructura(ficha(5,in),celda(9,8,0)).
estructura(ficha(3,in),celda(9,9,0)).

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
	.findall(estructura(X,Y),estructura(X,Y),Lista);
	for ( .member(Estructure,Lista) ) {
        .send(Player,tell,Estructure);
     };
	.send(Player,tell,puedesMover); 
	for ( .member(Estructure,Lista) ) {
		.send(Player,untell,Estructure);
     };
	.send(Player,untell,puedesMover).   

	
+moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)] : actual(A) & valido(P1,P2,Dir) <- 
	-moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)];
	.print("Acabo de verificar el movimiento jugador: ",A);
	.print("Jugador: ", A, " Ficha: " ,P1,", ",P2," en direccion ", Dir);
	.send(A,tell,valido);
	if (A = player1) 
		{-+actual(player2);} 
	else 
		{-+actual(player1);};
	.send(A,untell,valido);
	!startGame.

+moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)] : actual(A) & fueraTablero(P1,P2,Dir) <-
	-moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)];
	.print("Jugador: ", A, " Acabo de comprobar que hay una posicion fuera del tablero");
	.print("Jugador: ", A, " Ficha: " ,P1,", ",P2," en direccion ", Dir);
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
					
