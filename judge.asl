// Agent judge in project ESEI_SAGA.mas2j

//Autores: Roi Perez Lopez, Martin Puga Egea

/* ----- Initial beliefs and rules ------ */

jugadasRestantes(100).

jugadasPlayer(player1,0).
jugadasPlayer(player2,0).

turnoActual(player1).

turnoActivado(0).

fueraTablero(0).

fueraTurno(player1,0).
fueraTurno(player2,0).

jugadorDescalificado(player1,0).
jugadorDescalificado(player2,0).

flag(1). //Flag que permite la recursividad en el algoritmo de explosion-gravedad-rellenado

//Comprobacion completa de las condiciones de un movimiento correcto: Seleccion, movimiento y color
movimientoValido(pos(X,Y),Dir):- tablero(celda(X,Y,_),ficha(COrigen,_)) & validacion(X,Y,Dir,COrigen).
validacion(X,Y,"up",COrigen) :- tablero(celda(X,Y-1,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"down",COrigen) :- tablero(celda(X,Y+1,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"left",COrigen) :- tablero(celda(X-1,Y,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"right",COrigen) :- tablero(celda(X+1,Y,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
mismoColor(COrigen,CDestino) :- COrigen=CDestino.

//Comprobacion de Movimiento
direccionCorrecta(pos(X,Y),Dir):- tablero(celda(X,Y,_),_) & movimiento(X,Y,Dir).
movimiento(X,Y,"up") :- tablero(celda(X,Y-1,_),_).
movimiento(X,Y,"down") :- tablero(celda(X,Y+1,_),_).
movimiento(X,Y,"left") :- tablero(celda(X-1,Y,_),_).
movimiento(X,Y,"right") :- tablero(celda(X+1,Y,_),_).

//Comprobacion de Color
colorFichasDistintos(pos(X,Y),Dir):- tablero(celda(X,Y,_),ficha(COrigen,_)) & validacion(X,Y,Dir,COrigen).

//Generacion aleatoria del tipo de ficha
randomType(RandomNumber,Type):-
	(RandomNumber == 0 & Type = ip) | (RandomNumber == 1 & Type = in) | (RandomNumber == 2 & Type = ct) | (RandomNumber == 3 & Type = gs)
	| (RandomNumber == 4 & Type = co).

//Duenho de la jugada
plNumb(A,PlNumb):-
	(A == player1 & PlNumb = 1) | (A == player2 & PlNumb = 2).


//Calculo de coordenadas para un movimiento
nextMove(P1,P2,NX,NY,Dir):-
	(
	(Dir == "up" & NX = P1 & NY= (P2 - 1)) |
	(Dir == "down" & NX = P1 & NY = (P2 + 1)) |
	(Dir == "right" & NX = (P1 + 1) & NY = P2) |
	(Dir == "left" & NX = (P1 - 1) & NY = P2)
	).
	

//Reconocimiento de patrones
//Los Patrones que devuelven mas puntos son los primeros.
comprobarPatrones(Color,X,Y,StartsAtX,StartAtY,Direction,Pattern) :-
	(pattern5inLineW(Color,X,Y,StartsAtX,StartAtY) & Pattern = "5inLineW" & Direction="none") |
	(pattern5inLineH(Color,X,Y,StartsAtX,StartAtY) & Pattern = "5inLineH" & Direction="none") |
	(patternT(Color,X,Y,Direction) & Pattern = "T" & StartAtY = Y & StartsAtX = X) |
	(patternSquare(Color,X,Y,StartsAtX,StartAtY) & Pattern = "Square" & Direction="none") |
	(pattern4inLineW(Color,X,Y,StartsAtX,StartAtY) & Pattern = "4inLineW" & Direction="none") |
	(pattern4inLineH(Color,X,Y,StartsAtX,StartAtY) & Pattern = "4inLineH" & Direction="none") |
	(pattern3inLineW(Color,X,Y,StartsAtX,StartAtY) & Pattern = "3inLineW" & Direction="none") |
	(pattern3inLineH(Color,X,Y,StartsAtX,StartAtY) & Pattern = "3inLineH" & Direction="none") | 
	(Pattern = "none" & StartsAtX = X & StartAtY = Y & Direction="none").

	
pattern5inLineH(Color,X,Y,StartsAtX,StartAtY) :- 
	(tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+2,_),ficha(Color,_)) & 
	tablero(celda(X,Y+3,_),ficha(Color,_)) &
	tablero(celda(X,Y+4,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X) |
	(tablero(celda(X,Y-4,_),ficha(Color,_)) & 
	tablero(celda(X,Y-3,_),ficha(Color,_)) & 
	tablero(celda(X,Y-2,_),ficha(Color,_)) & 
	tablero(celda(X,Y-1,_),ficha(Color,_)) & StartAtY = (Y-4) & StartsAtX = X) |
	(tablero(celda(X,Y-3,_),ficha(Color,_)) & 
	tablero(celda(X,Y-2,_),ficha(Color,_)) & 
	tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & StartAtY = (Y-3) & StartsAtX = X) |
	(tablero(celda(X,Y-2,_),ficha(Color,_)) & 
	tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+2,_),ficha(Color,_)) & StartAtY = (Y-2) & StartsAtX = X) | 
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+2,_),ficha(Color,_)) & 
	tablero(celda(X,Y+3,_),ficha(Color,_)) & StartAtY = (Y-1) & StartsAtX = X).

		
pattern5inLineW(Color,X,Y,StartsAtX,StartAtY) :- 
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+2,Y,_),ficha(Color,_)) & 
	tablero(celda(X+3,Y,_),ficha(Color,_)) &
	tablero(celda(X+4,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X) |
	(tablero(celda(X-4,Y,_),ficha(Color,_)) & 
	tablero(celda(X-3,Y,_),ficha(Color,_)) & 
	tablero(celda(X-2,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = (X-4)) |
	(tablero(celda(X-3,Y,_),ficha(Color,_)) & 
	tablero(celda(X-2,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = (X-3)) |
	(tablero(celda(X-2,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+2,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = (X-2)) | 
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+2,Y,_),ficha(Color,_)) & 
	tablero(celda(X+3,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = (X-1)).

patternT(Color,X,Y,Direction) :- 
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+2,_),ficha(Color,_)) & Direction = "standing") |
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y-2,_),ficha(Color,_)) & Direction = "upside-down") |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+2,Y,_),ficha(Color,_)) & Direction = "pointing-right") |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X-2,Y,_),ficha(Color,_)) & Direction = "pointing-left").

	
patternSquare(Color,X,Y,StartsAtX,StartAtY) :- 
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y+1,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X) |
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X) | 
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X) | 
	(tablero(celda(X-1,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X).	
	
pattern4inLineH(Color,X,Y,StartsAtX,StartAtY) :- 
	(tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+2,_),ficha(Color,_)) & 
	tablero(celda(X,Y+3,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y-2,_),ficha(Color,_)) & 
	tablero(celda(X,Y-3,_),ficha(Color,_)) & StartAtY = (Y-3) & StartsAtX = X) | 
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+2,_),ficha(Color,_)) & StartAtY = (Y-1) & StartsAtX = X) | 
	(tablero(celda(X,Y-2,_),ficha(Color,_)) & 
	tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & StartAtY = (Y-2) & StartsAtX = X).

pattern4inLineW(Color,X,Y,StartsAtX,StartAtY) :- 
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+2,Y,_),ficha(Color,_)) & 
	tablero(celda(X+3,Y,_),ficha(Color,_)) & StartsAtX = X & StartAtY = Y) |
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X-2,Y,_),ficha(Color,_)) & 
	tablero(celda(X-3,Y,_),ficha(Color,_)) & StartsAtX = (X-3) & StartAtY = Y) | 
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+2,Y,_),ficha(Color,_)) & StartsAtX = (X-1) & StartAtY = Y) | 
	(tablero(celda(X-2,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_)) & StartsAtX = (X-2) & StartAtY = Y).
	
	
//Reconoce un patron de 3 en horizontal, devuelve las coordenadas en las que se inicia el patr?n
pattern3inLineW(Color,X,Y,StartsAtX,StartAtY) :- 
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & tablero(celda(X+2,Y,_),ficha(Color,_)) & 
	StartsAtX = X & StartAtY = Y) | 
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & tablero(celda(X-2,Y,_),ficha(Color,_)) & 
	StartsAtX = (X-2) & StartAtY = Y) | 
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	StartsAtX = (X-1) & StartAtY = Y).

pattern3inLineH(Color,X,Y,StartsAtX,StartAtY) :- 
	(tablero(celda(X,Y+1,_),ficha(Color,_)) & tablero(celda(X,Y+2,_),ficha(Color,_)) & 
	StartAtY = Y & StartsAtX = X) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & tablero(celda(X,Y-2,_),ficha(Color,_)) & 
	StartAtY = (Y-2) & StartsAtX = X) |  
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	StartAtY = (Y-1) & StartsAtX = X).

//Reconocimiento de posicion vacia bajo una ficha para el algoritmo de caida
emptyUnder(X,Y) :- tablero(celda(X,Y,_),ficha(_,_)) & tablero(celda(X,Y+1,_),e).


                             
/* ----- Initial goals ----- */

/* ----- Plans ----- */

/* ----------------------------------------------------- COMIENZO INTOCABLE ----------------------------------------------------- */

//Comienzo del turno de un jugador.
+!comienzoTurno : jugadorDescalificado(player1,1) & jugadorDescalificado(player2,1) <-
			.print("FIN DE LA PARTIDA: Ambos jugadores han sido descalificados. TRAMPOSOS!!!").

+!comienzoTurno : turnoActual(P) & jugadasRestantes(N) & N>0 & jugadasPlayer(P,J) & J<50 <-
	.print("Turno de: ",P,"!");
	-+turnoActivado(1);
	.print(P,", puedes mover");
	.send(P,tell,puedesMover);
	.send(P,untell,puedesMover).

+!comienzoTurno : jugadasRestantes(N) & N=0 <- .print("FIN DE LA PARTIDA: Se ha realizado el numero maximo de jugadas").


+!comienzoTurno : turnoActual(P) & jugadasPlayer(P,J) & J>=50 <- .print("FIN DE LA PARTIDA: ",P," ha realizado el maximo de jugadas por jugador (50)").


+!comienzoTurno <- .print("DEBUG: Error en +!comienzoTurno"). //Salvaguarda

+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : 
	turnoActual(P) & movimientoValido(pos(X,Y),Dir) & turnoActivado(1) <-
			-+turnoActivado(0);
			-moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)];
			.print("Jugada valida!")
			.send(P,tell,valido);
			.send(P,untell,valido);
			+intercambiarFichas(X,Y,Dir,P);
			-intercambiarFichas(X,Y,Dir,P);
			-+turnoTerminado(P);
			!comienzoTurno.

//Movimiento Incorrecto
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : 
	turnoActual(P) & not movimientoValido(pos(X,Y),Dir) & turnoActivado(1)<-
			-+turnoActivado(0);
			+movimientoInvalido(pos(X,Y),Dir,P).

//Movimiento realizado por un jugador que tiene el turno pero el juez aun no le ha ordenado mover
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : 
	turnoActual(P) & turnoActivado(0) <-
			.print("Agente ",P,", espera mi orden para realizar el siguiente movimiento. No intentes mover mas de una vez.").


//Movimiento realizado por un jugador fuera de su turno
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : 
	not turnoActual(P) & fueraTurno(P,N) <-
		.print(P," Has intentado realizar un movimiento fuera de tu turno. ", N+1," aviso");
		.send(P,tell,invalido(fueraTurno,N+1));
		.send(P,untell,invalido(fueraTurno,N+1));
		-fueraTurno(P,N);
		+fueraTurno(P,N+1).

//Descalificacion de un jugador
+fueraTurno(P,N) : N>3 <-
		-jugadorDescalificado(P,0);
		+jugadorDescalificado(P,1);
		.print("AVISO: ",P," ha sido descalificado por tramposo!!!").



//Deteccion de un agente externo a la partida (distinto a player1 y player 2) que esta intentando jugar.
// Esta regla la podeis adecuar a vuestras necesidades

+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : 
	not turnoActual(P) & not fueraTurno(P,N) <- // --- TODO ---
		.print("El agente ",P," externo a la partida est? intentando jugar.").

// Esta regla la podeis adecuar a vuestras necesidades
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] <- 
	.print("DEBUG: Error en +moverDesdeEnDireccion. Source", P). //Salvaguarda

//Comprobacion de la falta cometida por mover una ficha hacia una posicion fuera del tablero, intentar mover una ficha de una posicion inexistente, o realizar un tipo de movimiento desconocido
+movimientoInvalido(pos(X,Y),Dir,P):
	fueraTablero(V) & not direccionCorrecta(pos(X,Y),Dir)  <-
		-movimientoInvalido(pos(X,Y),Dir,P);
		.print("Movimiento Invalido. Has intentado mover una ficha fuera del tablero");
		.send(P,tell,invalido(fueraTablero,V+1));
		.send(P,untell,invalido(fueraTablero,V+1));
		-+turnoActivado(1);
		-+fueraTablero(V+1).

//Comprobacion de la falta cometida por intercambiar dos fichas del mismo color
+movimientoInvalido(pos(X,Y),Dir,P) : 
	not colorFichasDistintos(pos(X,Y),Dir) <-
		-movimientoInvalido(pos(X,Y),Dir,P);
		.print("Movimiento Invalido. Has intentado  intercambiar dos fichas del mismo color");
		-+turnoActivado(1);
		.print("Intentalo de nuevo!");
		.send(P,tell,tryAgain);
		.send(P,untell,tryAgain).

// Esta regla la podeis adecuar a vuestras necesidades
+movimientoInvalido(pos(X,Y),Dir,P) <- 
	.print("DEBUG: Error en +movimientoInvalido").


//Recepcion del aviso de que un jugador pasa turno por haber realizado un movimiento fuera del tablero mas de 3 veces
+pasoTurno[source(P)] : turnoActual(P) <-
		-+fueraTablero(0);
		.print(P," ha pasado turno");
		+cambioTurno(P);
		!comienzoTurno.

/* ----------------------------------------------------- FIN INTOCABLE ----------------------------------------------------- */





+startGame : size(N) <- 	//+generacionTablero;
				//-generacionTablero;
				.print("Tablero de juego generado!");
				.send(player1,tell,size(N));
				.send(player2,tell,size(N));
				+mostrarTablero(player1);
				-mostrarTablero(player1);
				+mostrarTablero(player2);
				-mostrarTablero(player2);
				.print("EMPIEZA EL JUEGO!")
				!comienzoTurno.

				
//Recepcion del tamanho del tablero
+size(N).

//Recepcion de la informacion de una posicion del tablero
+addTablero(Celda,Ficha)[source(percept)] <- 
				-addTablero(Celda,Ficha)[source(percept)];
				+tablero(Celda,Ficha).
	
	
//DEBUG: ya no es necesario, se realiza en el modelo
/*//Generacion aleatoria del tablero y fichas.
+generacionTablero : size(N)<-
		for ( .range(I,0,(N-1)) ) {
			for ( .range(J,0,(N-1)) ) {
				.random(Color,10);
				.random(Ficha,10);
				+crearCeldaTablero(I,J,math.round(5*Color),math.round(4*Ficha));
				-crearCeldaTablero(I,J,math.round(5*Color),math.round(4*Ficha));
			};
		 }.
*/


 //Comunicacion del tablero al jugador indicado.
+mostrarTablero(P) : size(N) <- .findall(tablero(X,Y),tablero(X,Y),Lista);
		for ( .member(Estructure,Lista) ) {
			.send(P,tell,Estructure);
		 }.
		 
+borrarTablero(P) : size(N) <- .findall(tablero(X,Y),tablero(X,Y),Lista);
		for ( .member(Estructure,Lista) ) {
			.send(P,untell,Estructure);
		 }.
		 


		 
//Cambio de turno de un jugador a otro
+cambioTurno(P) : jugadasRestantes(N) & jugadasPlayer(P,J)<-
				-cambioTurno(P);
				+cambioTurno(P,N,J).


+cambioTurno(P,N,J) : P = player1 | jugadorDescalificado(player1,1) <-
					-cambioTurno(P,N,J);
					-+turnoActual(player2);
					-+jugadasRestantes(N-1);
					-jugadasPlayer(player1,J);
					+jugadasPlayer(player1,J+1);
					.print("[ Jugadas restantes: ", N-1," || Jugadas completadas ",P,": ", J+1," ]").


+cambioTurno(P,N,J) : P = player2 <-
					-cambioTurno(P,N,J);
					-+turnoActual(player1);
					-+jugadasRestantes(N-1);
					-jugadasPlayer(player2,J);
					+jugadasPlayer(player2,J+1);
					.print("[ Jugadas restantes: ", N-1," || Jugadas completadas ",P,": ", J+1," ]").


//Cambio de turno cuando hay un jugador descalificado
+cambioTurnoMismoJugador(P):jugadasRestantes(N) & jugadasPlayer(P,J)<-
				-cambioTurnoMismoJugador(P);
				+cambioTurnoMismoJugador(P,N,J).
+cambioTurnoMismoJugador(P,N,J) <-
					-cambioTurnoMismoJugador(P,N,J);
					-+jugadasRestantes(N-1);
					-jugadasPlayer(P,J);
					+jugadasPlayer(P,J+1);
					.print("[ Jugadas restantes: ", N-1," || Jugadas completadas ",P,": ", J+1," ]").

+turnoTerminado(P): jugadorDescalificado(J,B) & B=1 <- +cambioTurnoMismoJugador(P).
+turnoTerminado(P) <- +cambioTurno(P).

//Analisis del movimiento solicitado por un jugador
//Movimiento correcto
+intercambiarFichas(X1,Y1,Dir,P) : nextMove(X1,Y1,X2,Y2,Dir) & plNumb(P,PlNumb) <- 			// --- TODO ---							
								-tablero(celda(X1,Y1,0),ficha(C1,TipoFicha1));
								-tablero(celda(X2,Y2,0),ficha(C2,TipoFicha2));
								.send(player1,untell,tablero(celda(X1,Y1,0),ficha(C1,TipoFicha1)));
								.send(player1,untell,tablero(celda(X2,Y2,0),ficha(C2,TipoFicha2)));
								.send(player2,untell,tablero(celda(X1,Y1,0),ficha(C1,TipoFicha1)));
								.send(player2,untell,tablero(celda(X2,Y2,0),ficha(C2,TipoFicha2))); 
								+tablero(celda(X2,Y2,0),ficha(C1,TipoFicha1)); 
								+tablero(celda(X1,Y1,0),ficha(C2,TipoFicha2)); 
								.send(player1,tell,tablero(celda(X2,Y2,0),ficha(C1,TipoFicha1)));
								.send(player1,tell,tablero(celda(X1,Y1,0),ficha(C2,TipoFicha2)));
								.send(player2,tell,tablero(celda(X2,Y2,0),ficha(C1,TipoFicha1)));
								.send(player2,tell,tablero(celda(X1,Y1,0),ficha(C2,TipoFicha2)));
								
								exchange(C1,X1,Y1,C2,X2,Y2); //Intercambio de fichas en el tablero grafico
								.print("Se han intercambiado las fichas entre las posiciones (",X1,",",Y1,") y (",X2,",",Y2,")");
								.wait(250); //--- TODO --- Ajusta la velocidad del intercambio de fichas
								
								-+flag(1);//Deteci�n y borrado de todos los patrones, aplicacion del algoritmo de caida y rellenado            
								+fullPatternMatch;   
								-fullPatternMatch;
								                  
								 //.wait(750);  
								 
								 
								 +updatePlayersTableroBB;
								 -updatePlayersTableroBB.





								
								
								    
//Deteccion de patrones en todo el tablero
+fullPatternMatch : flag(1) & size(N) <-
					-fullPatternMatch;
					-+flag(0);
					for ( .range(X,0,(N-1)) ) {                                                                                              
									for ( .range(Y,0,(N-1)) ) {
										+patternMatchPosition(X,Y); 
										-patternMatchPosition(X,Y);
									}
								}
								+gravity;
								-gravity;
								+refill;
								-refill;
								+fullPatternMatch;
								-fullPatternMatch.

+patternMatchPosition(X,Y) : tablero(celda(X,Y,Own),ficha(C,T)) <-
								+patternMatch(C,X,Y); 
								-patternMatch(C,X,Y).	                                      
                           
+patternMatch(C,X,Y): comprobarPatrones(C,X,Y,StartsAtX,StartAtY,Direction,Pattern) <-       
   if(Pattern \== "none"){
	.print(Pattern);
	+handlePattern(C,StartsAtX,StartAtY,Direction,Pattern);
	-handlePattern(C,StartsAtX,StartAtY,Direction,Pattern);
	-+flag(1);
}.  

//Algoritmo de caida 
+gravity : emptyUnder(_,_) & size(N) <-
					-gravity;
					for ( .range(X,0,(N-1)) ) {     
									for ( .range(Y,0,(N-1)) ) {
										+fall(X,Y);
										-fall(X,Y);     
									}      
								}
								+gravity;
								-gravity;                                                                                                                            
								.wait(100).
								      
                                                                                      
+fall(X,Y) : emptyUnder(X,Y) & size(N) & tablero(celda(X,Y,Owner),ficha(Color,Tipo)) <- // --- TODO --- Caida en diagonal
	-tablero(celda(X,Y,Owner),ficha(Color,Tipo));   
	-tablero(celda(X,Y+1,Owner),e);                                                                                                                
    +tablero(celda(X,Y,Owner),e);  
	+tablero(celda(X,Y+1,Owner),ficha(Color,Tipo));
	delete(Color,X,Y);            
	put(Color,X,Y+1);
	+fall(X,Y+1);   
	-fall(X,Y+1).
                                              
+refill : tablero(celda(_,0,_),e) & size(N) <- // --- TODO --- Tipo in
		-refill;
		for ( .range(X,0,(N-1)) ) { 
			.random(Color,10);     
			.random(RandomNumber,10);
	       	+refillSteak(X,math.round(5*Color),math.round(5*RandomNumber));
			-refillSteak(X,math.round(5*Color),math.round(5*RandomNumber));                                                                                                                
			};                                                                                                                               
		+gravity;           
		-gravity;  
		.wait(50);
		+refill;
		-refill. 
	
+refillSteak(X,Color,RandomNumber) : tablero(celda(X,0,_),e) & randomType(RandomNumber,Type) <-					
					put(Color,X,0);
					-tablero(celda(X,0,_),e);     
					+tablero(celda(X,0,0),ficha(Color,Type)).                                                                  

//Actualizacion de los BB tras todas las acciones ocurridas sobre el tablero despu�s de que el jugador realice movimiento
+updatePlayersTableroBB <- 
			//+deletePlayersTableroBB;
			//-deletePlayersTableroBB;
			+borrarTablero(player1);
			-borrarTablero(player1);
			+borrarTablero(player2);
			-borrarTablero(player2);
			//+addPlayersTableroBB;
			//-addPlayersTableroBB.
			+mostrarTablero(player1);
			-mostrarTablero(player1);
			+mostrarTablero(player2);
			-mostrarTablero(player2).
			
			
			
/*					                                    
//Borrado de los BB correspondientes al tablero
+deletePlayersTableroBB : size(N) <-                           //---------- !!!
							for ( .range(X,0,(N*N-1)) ) {
								.send(player1,untell,tablero(C,F));
								.send(player2,untell,tablero(C,F));
								}.  	         
//Adicion de los nuevos BB
+addPlayersTableroBB : size(N) <- // ---- NECESARIO ????
        					for ( .range(X,0,(N-1)) ) {
								for ( .range(Y,0,(N-1)) ) {
									+tellBelief(X,Y);
									-tellBelief(X,Y);
									};
								}.
+tellBelief(X,Y) : tablero(celda(X,Y,Own),ficha(C,T)) <-
								.send(player1,tell,tablero(celda(X,Y,Own),ficha(C,T)));
								.send(player2,tell,tablero(celda(X,Y,Own),ficha(C,T))).
								
*/								
								
								
+handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern)<-   
	if(Pattern == "3inLineH"){                                       
		delete(Color,StartsAtX,StartsAtY);	                                                     
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX,StartsAtY+2);  
		-tablero(celda(StartsAtX,StartsAtY,_),_);                       
		-tablero(celda(StartsAtX,StartsAtY+1,_),_);                                                 
		-tablero(celda(StartsAtX,StartsAtY+2,_),_);
		+tablero(celda(StartsAtX,StartsAtY,0),e);  // e == empty
		+tablero(celda(StartsAtX,StartsAtY+1,0),e);         
		+tablero(celda(StartsAtX,StartsAtY+2,0),e);  
		}                 
	if(Pattern == "3inLineW"){	                                             
		//Borramos en el modelo
		delete(Color,StartsAtX,StartsAtY);	
		delete(Color,StartsAtX+1,StartsAtY);                 
		delete(Color,StartsAtX+2,StartsAtY);		  
		//Borramos en la base del conocimiento		
		-tablero(celda(StartsAtX,StartsAtY,_),_);    
		-tablero(celda((StartsAtX+1),StartsAtY,_),_);
		-tablero(celda((StartsAtX+2),StartsAtY,_),_);
		+tablero(celda(StartsAtX,StartsAtY,0),e);    
		+tablero(celda((StartsAtX+1),StartsAtY,0),e);
		+tablero(celda((StartsAtX+2),StartsAtY,0),e);
	}                                               
	if(Pattern == "4inLineH"){
		//Borramos en el modelo
		delete(Color,StartsAtX,StartsAtY);	
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX,StartsAtY+2);
		delete(Color,StartsAtX,StartsAtY+3);
		//Borramos en la base del conocimiento
		-tablero(celda(StartsAtX,StartsAtY,_),_);
		-tablero(celda(StartsAtX,StartsAtY+1,_),_);
		-tablero(celda(StartsAtX,StartsAtY+2,_),_);
		-tablero(celda(StartsAtX,StartsAtY+3,_),_);
		+tablero(celda(StartsAtX,StartsAtY,0),e);    
		+tablero(celda(StartsAtX,StartsAtY+1,0),e);
		+tablero(celda(StartsAtX,StartsAtY+2,0),e);
		+tablero(celda(StartsAtX,StartsAtY+3,0),e);
	}
	if(Pattern == "4inLineW"){
		//Borramos en el modelo
		delete(Color,StartsAtX,StartsAtY);	
		delete(Color,StartsAtX+1,StartsAtY);                 
		delete(Color,StartsAtX+2,StartsAtY);
		delete(Color,StartsAtX+3,StartsAtY);
		//Borramos en la base del conocimiento		
		-tablero(celda(StartsAtX,StartsAtY,_),_);       
		-tablero(celda((StartsAtX+1),StartsAtY,_),_);
		-tablero(celda((StartsAtX+2),StartsAtY,_),_);
		-tablero(celda((StartsAtX+3),StartsAtY,_),_);
		+tablero(celda(StartsAtX,StartsAtY,0),e);    
		+tablero(celda((StartsAtX+1),StartsAtY,0),e);
		+tablero(celda((StartsAtX+2),StartsAtY,0),e);
		+tablero(celda((StartsAtX+3),StartsAtY,0),e);
	}                               
	if(Pattern == "5inLineH"){ 
		//Borramos en el modelo
		delete(Color,StartsAtX,StartsAtY);	
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX,StartsAtY+2);
		delete(Color,StartsAtX,StartsAtY+3);
		delete(Color,StartsAtX,StartsAtY+4); 
		//Borramos en la base del conocimiento
		-tablero(celda(StartsAtX,StartsAtY,_),_);
		-tablero(celda(StartsAtX,StartsAtY+1,_),_); 
		-tablero(celda(StartsAtX,StartsAtY+2,_),_); 
		-tablero(celda(StartsAtX,StartsAtY+3,_),_); 
		-tablero(celda(StartsAtX,StartsAtY+4,_),_); 
		+tablero(celda(StartsAtX,StartsAtY,0),e);  
		+tablero(celda(StartsAtX,StartsAtY+1,0),e); 
		+tablero(celda(StartsAtX,StartsAtY+2,0),e);         
		+tablero(celda(StartsAtX,StartsAtY+3,0),e);
		+tablero(celda(StartsAtX,StartsAtY+4,0),e);      
	}
	if(Pattern == "5inLineW"){		
		//Borramos en el modelo
		delete(Color,StartsAtX,StartsAtY);	
		delete(Color,StartsAtX+1,StartsAtY);                 
		delete(Color,StartsAtX+2,StartsAtY);
		delete(Color,StartsAtX+3,StartsAtY);
		delete(Color,StartsAtX+4,StartsAtY);
		//Borramos en la base del conocimiento		
		-tablero(celda(StartsAtX,StartsAtY,_),_);        
		-tablero(celda((StartsAtX+1),StartsAtY,_),_);                                                            
		-tablero(celda((StartsAtX+2),StartsAtY,_),_);
		-tablero(celda((StartsAtX+3),StartsAtY,_),_);                  
		-tablero(celda((StartsAtX+4),StartsAtY,_),_);
		+tablero(celda(StartsAtX,StartsAtY,0),e);    
		+tablero(celda((StartsAtX+1),StartsAtY,0),e);
		+tablero(celda((StartsAtX+2),StartsAtY,0),e);
		+tablero(celda((StartsAtX+3),StartsAtY,0),e);
		+tablero(celda((StartsAtX+4),StartsAtY,0),e);      
	}
	if(Pattern == "Square"){                         
	  	//Borramos en el modelo
		delete(Color,StartsAtX,StartsAtY);	
		delete(Color,StartsAtX+1,StartsAtY);                                                  
		delete(Color,StartsAtX,StartsAtY+1);	
		delete(Color,StartsAtX+1,StartsAtY+1);  
		//Borramos en la base del conocimiento		
		-tablero(celda(StartsAtX,StartsAtY,_),_);        
		-tablero(celda((StartsAtX+1),StartsAtY,_),_);
		-tablero(celda(StartsAtX,StartsAtY+1,_),_);
		-tablero(celda(StartsAtX+1,StartsAtY+1,_),_);
		+tablero(celda(StartsAtX,StartsAtY,0),e);       
		+tablero(celda((StartsAtX+1),StartsAtY,0),e);
		+tablero(celda(StartsAtX,StartsAtY+1,0),e);
		+tablero(celda(StartsAtX+1,StartsAtY+1,0),e);			
	}
	if(Pattern == "T"){ // --- TODO ---
		+handleT(Color,StartsAtX,StartsAtY,Direction);
		-handleT(Color,StartsAtX,StartsAtY,Direction);
	}
	.wait(350). //Tiempo de espera tras una explosion
	
	
+handleT(Color,StartsAtX,StartsAtY,Direction) <- // --- TODO ---
	-handleT(Color,StartsAtX,StartsAtY,Direction)
	if(Direction == "standing"){
		//Borramos en el modelo
		delete(Color,StartsAtX,StartsAtY);
		delete(Color,StartsAtX+1,StartsAtY);
		delete(Color,StartsAtX-1,StartsAtY);
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX,StartsAtY+2);
 
		//Borramos en la base del conocimiento		
		-tablero(celda(StartsAtX,StartsAtY,_),_);        
		-tablero(celda((StartsAtX+1),StartsAtY,_),_);
		-tablero(celda(StartsAtX-1,StartsAtY,_),_);
		-tablero(celda(StartsAtX,StartsAtY+1,_),_);
		-tablero(celda(StartsAtX,StartsAtY+2,_),_);	
		+tablero(celda(StartsAtX,StartsAtY,0),e);        
		+tablero(celda((StartsAtX+1),StartsAtY,0),e);
		+tablero(celda(StartsAtX-1,StartsAtY,0),e);
		+tablero(celda(StartsAtX,StartsAtY+1,0),e);
		+tablero(celda(StartsAtX,StartsAtY+2,0),e);	
	}
	if(Direction == "upside-down"){
		delete(Color,StartsAtX,StartsAtY);
		delete(Color,StartsAtX+1,StartsAtY);
		delete(Color,StartsAtX-1,StartsAtY);
		delete(Color,StartsAtX,StartsAtY-1);
		delete(Color,StartsAtX,StartsAtY-2);
		
		//Borramos en la base del conocimiento		
		-tablero(celda(StartsAtX,StartsAtY,_),_);        
		-tablero(celda((StartsAtX+1),StartsAtY,_),_);
		-tablero(celda(StartsAtX-1,StartsAtY,_),_);
		-tablero(celda(StartsAtX,StartsAtY-1,_),_);
		-tablero(celda(StartsAtX,StartsAtY-2,_),_);	
		+tablero(celda(StartsAtX,StartsAtY,0),e);        
		+tablero(celda((StartsAtX+1),StartsAtY,0),e);
		+tablero(celda(StartsAtX-1,StartsAtY,0),e);
		+tablero(celda(StartsAtX,StartsAtY-1,0),e);
		+tablero(celda(StartsAtX,StartsAtY-2,0),e);	
	}
	if(Direction == "pointing-right"){
		delete(Color,StartsAtX,StartsAtY);
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX,StartsAtY-1);
		delete(Color,StartsAtX+1,StartsAtY);
		delete(Color,StartsAtX+2,StartsAtY);
		
		//Borramos en la base del conocimiento		
		-tablero(celda(StartsAtX,StartsAtY,_),_);        
		-tablero(celda(StartsAtX,StartsAtY+1,_),_);
		-tablero(celda(StartsAtX,StartsAtY-1,_),_);
		-tablero(celda(StartsAtX+1,StartsAtY,_),_);
		-tablero(celda(StartsAtX+2,StartsAtY,_),_);	
		+tablero(celda(StartsAtX,StartsAtY,0),e);        
		+tablero(celda(StartsAtX,StartsAtY+1,0),e);
		+tablero(celda(StartsAtX,StartsAtY-1,0),e);
		+tablero(celda(StartsAtX+1,StartsAtY,0),e);
		+tablero(celda(StartsAtX+2,StartsAtY,0),e);	
	}
	if(Direction == "pointing-left"){
		delete(Color,StartsAtX,StartsAtY);
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX,StartsAtY-1);
		delete(Color,StartsAtX-1,StartsAtY);
		delete(Color,StartsAtX-2,StartsAtY);
		
		//Borramos en la base del conocimiento		
		-tablero(celda(StartsAtX,StartsAtY,_),_);        
		-tablero(celda(StartsAtX,StartsAtY+1,_),_);
		-tablero(celda(StartsAtX,StartsAtY-1,_),_);
		-tablero(celda(StartsAtX-1,StartsAtY,_),_);
		-tablero(celda(StartsAtX-2,StartsAtY,_),_);	
		+tablero(celda(StartsAtX,StartsAtY,0),e);        
		+tablero(celda(StartsAtX,StartsAtY+1,0),e);
		+tablero(celda(StartsAtX,StartsAtY-1,0),e);
		+tablero(celda(StartsAtX-1,StartsAtY,0),e);
		+tablero(celda(StartsAtX-2,StartsAtY,0),e);	
	}.

+crearCeldaTablero(I,J,Color) <-
		.random(C,10);
		Color = math.round(5*C);
		+tablero(celda(I,J,0),ficha(Color,in)).	// --- TODO --- Asignar tipo aleatorio                        

	
//Plan por defecto a ejecutar en caso desconocido.
+Default[source(A)]: not A=self  <- .print("He recibido el mensaje '",Default, "', pero no lo entiendo!");
									-Default[source(A)].



