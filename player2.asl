// Agent player in project ESEI_SAGA.mas2j

/* Initial beliefs and rules */

//Funciona, pero si la casilla elegida est� rodeada no va a devolver un valor para Dir
valido(X1,Y1,Dir):-
	.random(X11,10) &
	.random(Y11,10) &
	X1 = math.round(9*X11) &
	Y1 = math.round(9*Y11) &   
	(
	tablero(ficha(Color1,_),celda(X1,Y1,_)) &
	((tablero(ficha(Color2,_),celda(X1,Y1+1,_)) &
	(Color1 \== Color2 & Dir = "up")) | 
	(tablero(ficha(Color2,_),celda(X1,Y1-1,_)) &
	(Color1 \== Color2 & Dir = "down")) | 
	(tablero(ficha(Color2,_),celda(X1+1,Y1,_)) &
	(Color1 \== Color2 & Dir = "left")) | 
	(tablero(ficha(Color2,_),celda(X1-1,Y1,_)) &
	(Color1 \== Color2 & Dir = "right")))
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


