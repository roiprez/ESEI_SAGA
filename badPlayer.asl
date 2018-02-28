// Agent player in project ESEI_SAGA.mas2j

//Modificacion de prueba

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
	(Color1 \== Color2 & Dir = "right")) | Dir = "up")
	).

//Situaciones de Error que lanzo	
meEquivocoDeDireccion(1,19,"down").

meEchan(1,8,"down").

meSalgoDelTablero(-1,8,"up").

intentoIrAlMismoColor(X1,Y1,Dir):- 
	size(N)&
	.random(X11,10) &
	.random(Y11,10) &
	X1 = math.round((N-1)*X11) &
	Y1 = math.round((N-1)*Y11) &   
	(
	tablero(celda(X1,Y1,_),ficha(Color1,_)) &
	((tablero(celda(X1,Y1-1,_),ficha(Color2,_)) &
	(Color1 == Color2 & Dir = "up")) | 
	(tablero(celda(X1,Y1+1,_),ficha(Color2,_)) &
	(Color1 == Color2 & Dir = "down")) | 
	(tablero(celda(X1-1,Y1,_),ficha(Color2,_)) &
	(Color1 == Color2 & Dir = "left")) | 
	(tablero(celda(X1+1,Y1,_),ficha(Color2,_)) &
	(Color1 == Color2 & Dir = "right")) | Dir = "up")
	).
//juegoCuandoNoMeToca().


/* Initial goals */

//Intenta jugar como objetivo principal y el juez deniega ese primer movimiento
!realizarJugada.

/* Plans */


//Comienzo del turno
+puedesMover[source(judge)] <- !realizarJugada.


//Intenta salirse del tablero desde dentro
+!realizarJugada : meEquivocoDeDireccion(P1,P2,Dir) <-
					-meEquivocoDeDireccion(P1,P2,Dir);
					.send(judge,tell,moverDesdeEnDireccion(pos(P1,P2),Dir));
					.send(judge,untell,moverDesdeEnDireccion(pos(P1,P2),Dir)).

//Hace una jugada desde fuera del tablero					
+!realizarJugada : meSalgoDelTablero(P1,P2,Dir) <-
					-meSalgoDelTablero(P1,P2,Dir);
					.send(judge,tell,moverDesdeEnDireccion(pos(P1,P2),Dir));
					.send(judge,untell,moverDesdeEnDireccion(pos(P1,P2),Dir)).             
	
//Pudiendo elegir dirección, intenta ir a la de la ficha del mismo color
//Si no está rodeada de ninguna ficha del mismo color se mueve hacia arriba por defecto
+!realizarJugada : intentoIrAlMismoColor(P1,P2,Dir) <-
					-intentoIrAlMismoColor(P1,P2,Dir);
					.send(judge,tell,moverDesdeEnDireccion(pos(P1,P2),Dir));
					.send(judge,untell,moverDesdeEnDireccion(pos(P1,P2),Dir)).					

//Realzaciï¿½n de la jugada válida
+!realizarJugada : pensarJugada(P1,P2,Dir) <- 
					.send(judge,tell,moverDesdeEnDireccion(pos(P1,P2),Dir)); // --- TODO --- Decisiï¿½n de la jugada.
					.send(judge,untell,moverDesdeEnDireccion(pos(P1,P2),Dir)). 
					
//Movimiento realizado correctamente							
+valido[source(judge)] <-  .print("He realizado una Jugada Vï¿½lida!").
							
//Movimiento realizado entre dos fichas del mismo color
+tryAgain[source(judge)] <- !realizarJugada. // ---- TODO --- No realizar siempre la misma jugada!!

//Movimiento realizado fuera del tablero
+invalido(fueraTablero,N)[source(judge)] : N<=3 <- 
								.print("Fuera de tablero nï¿½ ",N);
								!realizarJugada.

+invalido(fueraTablero,N)[source(judge)] : N>3 <- 
								.print("Paso Turno!");
								.send(judge,tell,pasoTurno);
								.send(judge,untell,pasoTurno).

//Movimiento realizado fuera de turno
+invalido(fueraTurno,N)[source(judge)] <- .print("Soy un tramposo!!!").

