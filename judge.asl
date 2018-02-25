// Agent judge in project ESEI_SAGA.mas2j

/* Initial beliefs and rules */

contador(100).

size(10).

plNumb(A,PlNumb):-
	(A == player1 & PlNumb = 1) | (A == player2 & PlNumb = 2).

nextMove(P1,P2,NX,NY,Dir):-
	(
	(Dir == "up" & NX = P1 & NY= (P2 + 1)) |
	(Dir == "down" & NX = P1 & NY = (P2 - 1)) |
	(Dir == "right" & NX = (P1 + 1) & NY = P2) |
	(Dir == "left" & NX = (P1 - 1) & NY = P2) 
	).

actual(player1).

valido(P1,P2,Dir):-
	not fueraTablero(P1,P2,Dir).

fueraTablero(P1,P2,Dir):-
	size(N) & ((Dir == "up" & P2 == N-1)| (Dir == "right" & (P1+1) == N) | 
	(Dir == "left" & negativo(P1-1)) | (Dir == "down" & negativo(P2-1))).

negativo(X):- X < 0.

/* Initial goals */

!startGame.

/* Plans */

+!startGame : actual(Player) & contador(N) & size(Size) & N>=0 <-
	if(N == 100){
		for ( .range(I,0,(Size-1)) ) {
			for ( .range(J,0,(Size-1)) ) {
				.random(Color,10); 
				+estructura(ficha(math.round(5*Color),in),celda(I,J,0));
			};
		 };
		 -+contador(N-1);
		 !startGame;
	} else {
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
		.send(Player,untell,puedesMover);

	}.
	
+moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)] : actual(A) & nextMove(P1,P2,NX,NY,Dir) & plNumb(A,PlNumb) & valido(P1,P2,Dir) & estructura(X,celda(J,K,Own))  <- 
	-moverDesdeEnDireccion(pos(P1,P2),Dir)[source(A)];  

	.print("Acabo de verificar el movimiento jugador: ",A);
	.print("Jugador: ", A, " Ficha: " ,P1,", ",P2," en direccion ", Dir);
	.send(A,tell,valido);
	
	if (A = player1) 
		{
		-+actual(player2);
		}                        
	else 
		{
		-+actual(player1);		
		};
		
	.print(estructura(X1,celda(P1,P2,Own1)));
	.print(estructura(X2,celda(NX,NY,Own2)));	
	-estructura(X1,celda(P1,P2,Own1));                         
	-estructura(X2,celda(NX,NY,Own2));
	+estructura(X1,celda(NX,NY,PlNumb));		
	+estructura(X2,celda(P1,P2,PlNumb));
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
					
