// Agent player in project SI_2.mas2j

/* Initial beliefs and rules */
pensarJugada(X1,Y1,Dir):- 
	size(N)&
	.random(X11,10) &
	.random(Y11,10) &
	X1 = math.round((N-1)*X11) &
	Y1 = math.round((N-1)*Y11) &   
	(
	tablero(celda(X1,Y1,_),ficha(Color1,_)) &
	((tablero(celda(X1,Y1-1,_),ficha(Color2,_)) &
	(Color1 \== Color2 & Dir = "up")) | 
	(tablero(celda(X1,Y1+1,_),ficha(Color2,_)) &
	(Color1 \== Color2 & Dir = "down")) | 
	(tablero(celda(X1-1,Y1,_),ficha(Color2,_)) &
	(Color1 \== Color2 & Dir = "left")) | 
	(tablero(celda(X1+1,Y1,_),ficha(Color2,_)) &
	(Color1 \== Color2 & Dir = "right")))
	).

/* Initial goals */


/* Plans */


//Comienzo del turno
+puedesMover[source(judge)] <- !realizarJugada.


//Realización de la jugada
+!realizarJugada : pensarJugada(P1,P2,Dir) <- 
					//.send(judge, tell, moverDesdeEnDireccion(pos(1,1),up)); //DEBUG
					//.send(judge, untell, moverDesdeEnDireccion(pos(1,1),up)).
					.send(judge,tell,moverDesdeEnDireccion(pos(P1,P2),Dir)); // --- TODO --- Decisión de la jugada.
					.send(judge,untell,moverDesdeEnDireccion(pos(P1,P2),Dir)). 
					
//Movimiento realizado correctamente							
+valido[source(judge)] <-  .print("He realizado una Jugada Válida!").
							
//Movimiento realizado entre dos fichas del mismo color
+tryAgain[source(judge)] <- !realizarJugada. // ---- TODO --- No realizar siempre la misma jugada!!

//Movimiento realizado fuera del tablero
+invalido(fueraTablero,N)[source(judge)] : N<=3 <- 
								.print("Fuera de tablero nº ",N);
								!realizarJugada.

+invalido(fueraTablero,N)[source(judge)] : N>3 <- 
								.print("Paso Turno!");
								.send(judge,tell,pasoTurno);
								.send(judge,untell,pasoTurno).

//Movimiento realizado fuera de turno
+invalido(fueraTurno,N)[source(judge)] <- .print("Soy un tramposo!!!").

