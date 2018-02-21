// Agent player in project ESEI_SAGA.mas2j

/* Initial beliefs and rules */
	
valido(X1,Y1,Dir):-
	.random(X11,10) &
	.random(Y11,10) &
	X1 = math.round(9*X11) &
	Y1 = math.round(9*Y11) &      
	((X1 == 9 & Dir = "left") | (Y1 == 9 & Dir = "down") | (Dir = "up")) .

/* Initial goals */

/* Plans */

+puedesMover[source(judge)] : valido(P1,P2, Dir) <- 
	.print("Acabo de recibir del juez el testigo de mover");
	-valido(P1,P2);	
	.send(judge,tell,moverDesdeEnDireccion(pos(P1,P2),Dir)).

+invalido(fueraTablero)[source(judge)] : valido(P1,P2, Dir) <-
	.print("Acabo de recibir del juez que he intentado mover fuera del tablero 1 vez");
	-valido(P1,P2);
	.send(judge,tell,moverDesdeEnDireccion(pos(P1,P2),Dir)).
	
+invalido(fueraTablero)[source(judge)].

+valido[source(judge)] <- .print("Mi ultimo movimiento ha sido valido").


