// Agent judge in project ESEI_SAGA.mas2j

/* ----- Initial beliefs and rules ------ */ 

size(20).

jugadasRestantes(100).

jugadasPlayer(player1,0).
jugadasPlayer(player2,0).

turnoActual(player1).

turnoActivado(0). //Permite controlar si alg�n jugador con turno intenta jugar antes de que se le de la orden. // --- TODO -- DUDA!!

fueraTablero(0).

fueraTurno(player1,0).
fueraTurno(player2,0).

jugadorDescalificado(player1,0).
jugadorDescalificado(player2,0).

//Comprobaci�n completa de las condiciones de un movimiento correcto: Selecci�n, movimiento y color
movimientoValido(pos(X,Y),Dir):- tablero(celda(X,Y,_),ficha(COrigen,_)) & validacion(X,Y,Dir,COrigen). 
validacion(X,Y,"up",COrigen) :- tablero(celda(X,Y-1,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"down",COrigen) :- tablero(celda(X,Y+1,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"left",COrigen) :- tablero(celda(X-1,Y,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"right",COrigen) :- tablero(celda(X+1,Y,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino). 
mismoColor(COrigen,CDestino) :- COrigen=CDestino.

//Comprobaci�n de Movimiento
direccionCorrecta(pos(X,Y),Dir):- tablero(celda(X,Y,_),_) & movimiento(X,Y,Dir). 
movimiento(X,Y,"up") :- tablero(celda(X,Y-1,_),_).
movimiento(X,Y,"down") :- tablero(celda(X,Y+1,_),_).
movimiento(X,Y,"left") :- tablero(celda(X-1,Y,_),_).
movimiento(X,Y,"right") :- tablero(celda(X+1,Y,_),_).

//Comprobaci�n de Color
colorFichasDistintos(pos(X,Y),Dir):- tablero(celda(X,Y,_),ficha(COrigen,_)) & validacion(X,Y,Dir,COrigen). 
validacion(X,Y,"up",COrigen) :- tablero(celda(X,Y-1,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"down",COrigen) :- tablero(celda(X,Y+1,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"left",COrigen) :- tablero(celda(X-1,Y,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"right",COrigen) :- tablero(celda(X+1,Y,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino). 
mismoColor(COrigen,CDestino) :- COrigen=CDestino.

//A partir de un n�mero aleatorio Rand, devuelve un tipo de ficha Ficha.
randomFicha(Rand,Ficha):-
	(Rand == 0 & Ficha = ip) | (Rand == 1 & Ficha = in) | (Rand == 2 & Ficha = ct) | (Rand == 3 & Ficha = gs)
	| (Rand == 4 & Ficha = co).

//Devuelve el entero que corresponde al due?o de la jugada  // - * - TODO: Comunicaci�n del tablero a los Jugadores
plNumb(A,PlNumb):-
	(A == player1 & PlNumb = 1) | (A == player2 & PlNumb = 2).

//Devuelve las coordenadas NX,NY del siguiente movimiento a realizar en funci?n 
//de las coordenadas de la ficha a mover y la direcci?n
nextMove(P1,P2,NX,NY,Dir):-
	(
	(Dir == "up" & NX = P1 & NY= (P2 - 1)) |
	(Dir == "down" & NX = P1 & NY = (P2 + 1)) |
	(Dir == "right" & NX = (P1 + 1) & NY = P2) |
	(Dir == "left" & NX = (P1 - 1) & NY = P2) 
	).

 /*//BLOQUE DEBUG: movimientoValido()
//tablero(celda(1,0,0),ficha(1,ct)).//Up valido!
//tablero(celda(1,1,1),ficha(3,ct)).//POSICION ACTUAL
//tablero(celda(1,2,2),ficha(3,ct)).//Down invalido ->mismo color
//tablero(celda(0,1,1),ficha(5,ct)).//Left valido!
								  //Right invalido -> no existe
*/

//--- TODO --- Prints

/* ----- Initial goals ----- */

!startGame.     


/* ----- Plans ----- */ 


+!startGame <- +generacionTablero;
				-generacionTablero;
				+mostrarTablero(player1);
				-mostrarTablero(player1);
				+mostrarTablero(player2);
				-mostrarTablero(player2);
				!comienzoTurno.

// - * - TODO: Generaci�n autom�tica aleatoria del tablero y fichas.
//--- Owner y Tipo de ficha
//--- Generar tipos diferentes
+generacionTablero : size(N)<- 
		for ( .range(I,0,(N-1)) ) {
			for ( .range(J,0,(N-1)) ) {
				.random(Color,10);
				.random(Ficha,10);
				+crearCeldaTablero(I,J,Color,math.round(4*Ficha));
				-crearCeldaTablero(I,J,Color,math.round(4*Ficha));
			};
		 }.
+crearCeldaTablero(I,J,Color,Ficha) :  randomFicha(Ficha, TipoFicha) <- 
		+tablero(celda(I,J,0),ficha(math.round(5*Color),TipoFicha)).
		 
 // - * - TODO: Comunicaci�n del tablero a los Jugadores
+mostrarTablero(P) : size(N) <- .findall(tablero(X,Y),tablero(X,Y),Lista);		
		for ( .member(Estructure,Lista) ) {
			.send(P,tell,Estructure);
		 };
		 .send(P,tell,size(N)).
		 
		 
//Comienzo del turno
+!comienzoTurno : jugadorDescalificado(player1,1) & jugadorDescalificado(player2,1) <-
			.print("FIN DE LA PARTIDA: Ambos jugadores han sido descalificados. TRAMPOSOS!!!").

+!comienzoTurno : turnoActual(P) & jugadasRestantes(N) & N>0 & jugadasPlayer(P,J) & J<50 <-  
	//--- TODO ---- Activar turno
	.send(P,tell,puedesMover);                                             
	.send(P,untell,puedesMover).

+!comienzoTurno : jugadasRestantes(N) & N=0 <- .print("FIN DE LA PARTIDA: Se ha realizado el n�mero m�ximo de jugadas"). 
	
	
+!comienzoTurno : turnoActual(P) & jugadasPlayer(P,J) & J>=50 <- .print("FIN DE LA PARTIDA: ",P," ha realizado el m�ximo de jugadas por jugador (50)"). 
	
                                                  
+!comienzoTurno <- .print("DEBUG: Error en +!comienzoTurno"). // --- DEBUG ---
	                                                   

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
					.print("Jugadas restantes: ", N-1);
					.print("--- jugadas completadas ",P," ", J+1).


+cambioTurno(P,N,J) : P = player2 <-
					-cambioTurno(P,N,J);
					-+turnoActual(player1);
					-+jugadasRestantes(N-1);
					-jugadasPlayer(player2,J);
					+jugadasPlayer(player2,J+1);
					.print("Jugadas restantes: ", N-1);
					.print("--- jugadas completadas",P," ", J+1).					
					
//Cambio de turno con un jugador descalificado					
+cambioTurnoMismoJugador(P):jugadasRestantes(N) & jugadasPlayer(P,J)<-
				-cambioTurnoMismoJugador(P);
				+cambioTurnoMismoJugador(P,N,J).				
+cambioTurnoMismoJugador(P,N,J) <-
					-cambioTurnoMismoJugador(P,N,J);
					-+jugadasRestantes(N-1);
					-jugadasPlayer(P,J);
					+jugadasPlayer(P,J+1);
					.print("Jugadas restantes: ", N-1);
					.print("--- jugadas completadas ",P," ", J+1).

//DEBUG
//+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] <- .print("Jugada: moverDesdeEnDireccion(pos(",X,",",Y,"),",Dir,")" ).
					
					
//An�lisis del movimiento solicitado por un jugador
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : turnoActual(P) & movimientoValido(pos(X,Y),Dir) <-
												-moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)];
												.send(P,tell,valido);
												.send(P,untell,valido);
												// intercambiarFichas
												+intercambiarFichas(X,Y,Dir,P);
												-intercambiarFichas(X,Y,Dir,P);
												// --- TODO --- Desactivar turno??
												-+turnoTerminado(P);
												!comienzoTurno.
												
+turnoTerminado(P): jugadorDescalificado(J,B) & B=1 <- +cambioTurnoMismoJugador(P).
+turnoTerminado(P) <- +cambioTurno(P).

+intercambiarFichas(X,Y,Dir,P) : nextMove(X,Y,NX,NY,Dir) & plNumb(P,PlNumb) <-
								-tablero(celda(X,Y,Own1),X1);                         
								-tablero(celda(NX,NY,Own2),X2);
								.send(player1,untell,tablero(celda(X,Y,Own1),X1));
								.send(player1,untell,tablero(celda(NX,NY,Own2),X2));
								.send(player2,untell,tablero(celda(X,Y,Own1),X1));
								.send(player2,untell,tablero(celda(NX,NY,Own2),X2));
								+tablero(celda(NX,NY,PlNumb),X1);		
								+tablero(celda(X,Y,PlNumb),X2);
								.send(player1,tell,tablero(celda(NX,NY,PlNumb),X1));
								.send(player1,tell,tablero(celda(X,Y,PlNumb),X2));			
								.send(player2,tell,tablero(celda(NX,NY,PlNumb),X1));
								.send(player2,tell,tablero(celda(X,Y,PlNumb),X2)).
								
								
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : turnoActual(P) & not movimientoValido(pos(X,Y),Dir) <-
												 +movimientoInvalido(pos(X,Y),Dir,P).
												 
												 
//Movimiento realizado por un jugador fuera de su turno					 
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : not turnoActual(P) & fueraTurno(P,N) <- // --- TODO ---
												.print("Fuera de turno jugador: ", P);
												.send(P,tell,invalido(fueraTurno,N+1));
												.send(P,untell,invalido(fueraTurno,N+1));
												-fueraTurno(P,N);
												+fueraTurno(P,N+1).
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : not turnoActual(P) & not fueraTurno(P,N) <- // --- TODO ---
												.print("Un jugador externo est� intentando jugar: ", P).
												
+fueraTurno(P,N) : N>3 <- 
					-jugadorDescalificado(P,0);
					+jugadorDescalificado(P,1);
					.print("AVISO: ",P," ha sido descalificado por tramposo!!!").												


+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] <- .print("DEBUG: Error en +moverDesdeEnDireccion. Source", P). // --- DEBUG ---                                                                                 
                           



//Comprobacion de la falta cometida por mover una ficha hacia una posici�n fuera del tablero, intentar mover una ficha de una posici�n inexistente, o realizar un tipo de movimiento desconocido
+movimientoInvalido(pos(X,Y),Dir,P) :fueraTablero(V) & not direccionCorrecta(pos(X,Y),Dir)  <-
													-movimientoInvalido(pos(X,Y),Dir,P);
													.print("Invalido: fueraTablero"); 
													.send(P,tell,invalido(fueraTablero,V+1));
													.send(P,untell,invalido(fueraTablero,V+1));
													-+fueraTablero(V+1).

//Comprobaci�n de la falta cometida por intercambiar dos fichas del mismo color 													
+movimientoInvalido(pos(X,Y),Dir,P) : not colorFichasDistintos(pos(X,Y),Dir) <-
										-movimientoInvalido(pos(X,Y),Dir,P);
										.print("mismoColor");
										.send(P,tell,tryAgain);
										.send(P,untell,tryAgain).

+movimientoInvalido(pos(X,Y),Dir,P) <- .print("DEBUG: Error en +movimientoInvalido").


//Recepci�n del aviso de que un jugador pasa turno por haber realizado un movimiento fuera del tablero mas de 3 veces
+pasoTurno[source(P)] : turnoActual(P) <-
						-+fueraTablero(0);
						.print("Cambio de turno desde ",P);
						+cambioTurno(P);
						!startGame.

+Default[source(A)]: not A=self  <- .print("Esta respuesta no est� contemplada por el agente"). // --- DEBUG --- 


