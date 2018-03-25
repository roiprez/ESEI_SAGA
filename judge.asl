// Agent judge in project ESEI_SAGA.mas2j
//Roi Perez Lopez, Martin Puga Egea
/* ----- Initial beliefs and rules ------ */

/*
* El juez debe controlar las puntuaciones
* El juez debe controlar los ganadores de cada nivel y de la partida

*/
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

//Parte de la generacion aleatoria del tipo de ficha
randomFicha(Rand,Ficha):-
	(Rand == 0 & Ficha = ip) | (Rand == 1 & Ficha = in) | (Rand == 2 & Ficha = ct) | (Rand == 3 & Ficha = gs)
	| (Rand == 4 & Ficha = co).

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
//Los Patrones que devuelven mï¿½s puntos son los primeros.
comprobarPatrones(Color,X,Y,StartsAtX,StartAtY,Pattern) :-
	(patternSquare(Color,X,Y,StartsAtX,StartAtY) & Pattern = "Square") |
	(pattern4inLineW(Color,X,Y,StartsAtX,StartAtY) & Pattern = "4inLineW") |
	(pattern4inLineH(Color,X,Y,StartsAtX,StartAtY) & Pattern = "4inLineH") |
	(pattern3inLineW(Color,X,Y,StartsAtX,StartAtY) & Pattern = "3inLineW") |
	(pattern3inLineH(Color,X,Y,StartsAtX,StartAtY) & Pattern = "3inLineH") | 
	Pattern = "none".

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
	
	
//Reconoce un patron de 3 en horizontal, devuelve las coordenadas en las que se inicia el patrón
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





+startGame <- //+generacionTablero;
				//-generacionTablero;
				.print("Tablero de juego generado!");
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
	-addTablero(Celda,Ficha)[source(percept)]; //--- TODO -- Revisar tiempos asincronos
	+tablero(Celda,Ficha).
	
	
//DEBUG: ya no es necesario
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

//DEBUG: ya no es necesario
/*+crearCeldaTablero(I,J,Color,Ficha) :  randomFicha(Ficha, TipoFicha) <-
		+tablero(celda(I,J,0),ficha(Color,TipoFicha)).
*/


 //Comunicacion del tablero al jugador indicado.
+mostrarTablero(P) : size(N) <- .findall(tablero(X,Y),tablero(X,Y),Lista);
		for ( .member(Estructure,Lista) ) {
			.send(P,tell,Estructure);
		 };
		 .send(P,tell,size(N)).


		 
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
								.wait(100); //--- TODO --- Ajusta la velocidad del juego
								//Identifica el Patrï¿½n, guarda en StartsAt la posicion mï¿½s 
								//cercana al 0 a borrar, y en Pattern el patrï¿½n que se ha cumplido
								+patternMatch(C2,X1,Y1,StartsAtX,StartAtY,Pattern); 
								//Recoge los datos del patrï¿½n anterior y ejecuta los deletes
								+handlePattern(C2,StartsAtX,StartAtY,Pattern);
								.print(Pattern);
								+patternMatch(C1,X2,Y2,StartsAtX2,StartAtY2,Pattern2); 
								//Recoge los datos del patrï¿½n anterior y ejecuta los deletes
								+handlePattern(C1,StartsAtX2,StartAtY2,Pattern2);
								.print(Pattern2);
								.print("Se han intercambiado las fichas entre las posiciones (",X1,",",Y1,") y (",X2,",",Y2,")").

								
								                
//Deteccion de patrones
+patternMatch(Color,X,Y,StartsAtX,StartAtY,Pattern) : comprobarPatrones(Color,X,Y,StartsAtX,StartAtY,Pattern) <-  // --- TODO ---
	-patternMatch(Color,X,Y,StartsAtX,StartAtY,Pattern). 

//Este serï¿½a un buen sitio para implementar el incremento de puntuaciï¿½n
//Quedarï¿½a por implementar el borrado en el juez
//Quedarï¿½a por implementar la caï¿½da de fichas
+handlePattern(Color,StartsAtX,StartsAtY,Pattern) /*: Points(N)*/ <-
	-handlePattern(Color,StartsAt,Pattern);
	if(Pattern == "3inLineH"){
		//-+Points(N+300);
		delete(Color,StartsAtX,StartsAtY);	
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX,StartsAtY+2);
	}
	if(Pattern == "3inLineW"){
		//-+Points(N+300);
		delete(Color,StartsAtX,StartsAtY);	
		delete(Color,StartsAtX+1,StartsAtY);
		delete(Color,StartsAtX+2,StartsAtY);
	}
	if(Pattern == "4inLineH"){
		delete(Color,StartsAtX,StartsAtY);	
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX,StartsAtY+2);
		delete(Color,StartsAtX,StartsAtY+3);
	}
	if(Pattern == "4inLineW"){
		delete(Color,StartsAtX,StartsAtY);	
		delete(Color,StartsAtX+1,StartsAtY);
		delete(Color,StartsAtX+2,StartsAtY);
		delete(Color,StartsAtX+3,StartsAtY);
	}
	if(Pattern == "5inLineH"){
		delete(Color,StartsAtX,StartsAtY);	
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX,StartsAtY+2);
		delete(Color,StartsAtX,StartsAtY+3);
		delete(Color,StartsAtX,StartsAtY+4);
	}
	if(Pattern == "5inLineW"){
		delete(Color,StartsAt,StartsAtY);	
		delete(Color,StartsAt+1,StartsAtY);
		delete(Color,StartsAt+2,StartsAtY);
		delete(Color,StartsAt+3,StartsAtY);
		delete(Color,StartsAt+4,StartsAtY);
	}
	if(Pattern == "Square"){
		delete(Color,StartsAtX,StartsAtY);
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX+1,StartsAtY);
		delete(Color,StartsAtX+1,StartsAtY+1);
	}
	.print("Pattern Handled").
	
//Plan por defecto a ejecutar en caso desconocido.
+Default[source(A)]: not A=self  <- .print("He recibido el mensaje '",Default, "', pero no lo entiendo!");
									-Default[source(A)].


