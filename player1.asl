// Agent player in project ESEI_SAGA.mas2j

/* Initial beliefs and rules */

//Funciona, pero si la casilla elegida est� rodeada no va a devolver un valor para Dir
valido(X1,Y1,Dir):-
	.random(X11,10) &
	.random(Y11,10) &
	X1 = math.round(9*X11) &
	Y1 = math.round(9*Y11) &   
	(
	estructura(ficha(V1,W1),celda(X1,Y1,0)) &
	estructura(ficha(V2,W2),celda(X1,Y1+1,0)) &
	((not(V1 == V2 & W1 == W2) & Dir = "up")) | 
	estructura(ficha(V1,W1),celda(X1,Y1,0)) &
	estructura(ficha(V2,W2),celda(X1,Y1-1,0)) &
	((not(V1 == V2 & W1 == W2) & Dir = "down")) | 
	estructura(ficha(V1,W1),celda(X1,Y1,0)) &
	estructura(ficha(V2,W2),celda(X1+1,Y1,0)) &
	((not(V1 == V2 & W1 == W2) & Dir = "left")) | 
	estructura(ficha(V1,W1),celda(X1,Y1,0)) &
	estructura(ficha(V2,W2),celda(X1-1,Y1,0)) &
	((not(V1 == V2 & W1 == W2) & Dir = "right"))
	).

/* Initial goals */

/* Plans */

+puedesMover[source(judge)] : valido(P1,P2, Dir) <- 
	.print("Acabo de recibir del juez el testigo de mover");	
	.send(judge,tell,moverDesdeEnDireccion(pos(P1,P2),Dir)).

+invalido(fueraTablero)[source(judge)] : valido(P1,P2, Dir) <-
	-invalido(fueraTablero)[source(judge)];
	.print("Acabo de recibir del juez que he intentado mover fuera del tablero 1 vez");
	.send(judge,tell,moverDesdeEnDireccion(pos(P1,P2),Dir)).
	
+invalido(fueraTablero)[source(judge)].

+valido[source(judge)] <- .print("Mi ultimo movimiento ha sido valido").


