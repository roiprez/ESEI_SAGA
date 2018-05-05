// Agent player in project ESEI_SAGA.mas2j

/*
* Su objetivo es alcanzar la mayor puntiacion posible en cada movimiento
*/

/* Initial beliefs and rules */

actualPatternOwner(0).  //Determina el owner actual del patrón.
playerOwner(0).			//Es el número que le corresponde al player como valor de Owner, se actualizará en el nivel 3

patternOwner(SteakOwner, Owner):-
	/*.print("SteakOwner: ",SteakOwner) &*/
	actualPatternOwner(ActualPatternOwner) & (
	(ActualPatternOwner="none" & Owner="none") |   //Si el patrón no se asignó a nadie sigue sin asignar
	(ActualPatternOwner=0 & Owner=SteakOwner) |   //Si el patrón no tiene dueño, se convierte en dueño el dueño de la ficha
	(SteakOwner=0 & Owner=ActualPatternOwner) |   //Si no hay dueño de la ficha, se mantiene el owner del patrón
	(ActualPatternOwner=SteakOwner & Owner=ActualPatternOwner) |   //Si el dueño del patrón es el mismo que el de la ficha se queda como está
	(Owner="none")									//Si el dueño del patrón y el de la ficha no coinciden, el patrón no es para ninguno
	).
	
//Comprueba qué celdas ha conseguido cada uno de los patrones, y calcula el saldo entre ambas
comprobarCeldas(Owner1,Celdas1,Owner2,Celdas2,Saldo) :-
	playerOwner(PlayerOwner) & (((not Owner1=0 & not Owner2=0) & (					//Si ambos patrones tienen un owner
	(PlayerOwner=Owner1 & PlayerOwner=Owner2 & Saldo=Celdas1+Celdas2) |
	(not PlayerOwner=Owner1 & PlayerOwner=Owner2 & Saldo=Celdas2-Celdas1) |
	(PlayerOwner=Owner1 & not PlayerOwner=Owner2 & Saldo=Celdas1-Celdas2) |
	(not PlayerOwner=Owner1 & not PlayerOwner=Owner2 & Saldo=-Celdas1-Celdas2)
	)) | ((Owner1=PlayerOwner | Owner2=PlayerOwner) & Saldo=Celdas1+Celdas2)		//Si uno de los patrones es para el jugador y el otro no tiene dueño
	| ((not Owner1=PlayerOwner | not Owner2=PlayerOwner) & Saldo=-Celdas1-Celdas2)	//Si uno de los patrones no es para el jugador y el otro no tiene dueño
	| Saldo=0																		//Ninguno de los patrones tiene dueño
	) /*& .print(Celdas1,", ",Celdas2)*/.

//Da una jugada aleatoria desde las coordenadas X1,Y1 y en direcci?n Dir
pensarJugadaAleatoria(X1,Y1,Dir):-
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

//Comprueba todos los patrones, si el de mayor prioridad se cumple es el que devuelve
comprobarPatrones(Color,X,Y,StartsAtX,StartAtY,Direction,Pattern) :-
	((pattern5inLineW(Color,X,Y,StartsAtX,StartAtY) & Pattern = "5inLineW" & Direction="none") |
	(pattern5inLineH(Color,X,Y,StartsAtX,StartAtY) & Pattern = "5inLineH" & Direction="none") |
	(patternT(Color,X,Y,Direction) & Pattern = "T" & StartAtY = Y & StartsAtX = X) |
	(patternSquare(Color,X,Y,StartsAtX,StartAtY) & Pattern = "Square" & Direction="none") |
	(pattern4inLineW(Color,X,Y,StartsAtX,StartAtY) & Pattern = "4inLineW" & Direction="none") |
	(pattern4inLineH(Color,X,Y,StartsAtX,StartAtY) & Pattern = "4inLineH" & Direction="none") |
	(pattern3inLineW(Color,X,Y,StartsAtX,StartAtY) & Pattern = "3inLineW" & Direction="none") |
	(pattern3inLineH(Color,X,Y,StartsAtX,StartAtY) & Pattern = "3inLineH" & Direction="none") |
	(Pattern = "none" & StartsAtX = X & StartAtY = Y & Direction="none")).


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




/* Initial goals */


/* Plans */


//Comienzo del turno
+puedesMover[source(judge)] <- !realizarJugada.


//Realizacion de la jugada
+!realizarJugada  <-
	!pensarJugada;
	!comunicarJugada.

//Envia al juez la jugada que quiere realizar
+!comunicarJugada : cordX(X) & cordY(Y) & dirMax(Dir)<-
	.print("Quiero mover desde posicion (",X,",",Y,") en direccion ",Dir);
	.send(judge,tell,moverDesdeEnDireccion(pos(X,Y),Dir));
	.send(judge,untell,moverDesdeEnDireccion(pos(X,Y),Dir)).

+!comunicarJugada.

//Comprueba el estado del tablero para buscar la jugada optima, si no hay una jugada que de puntuaci?n, hace una aleatoria.
//celdasMax s?lo se utilizar? para el nivel(3)
+!pensarJugada  <-
	-+celdasMax(0);
	-+celdasAct(0);
	-+puntosMax(0);
	-+puntos(0);
	-+direction("none");
	.findall(celda(X,Y,Own),tablero(celda(X,Y,Own),_),Lista);
	!comprobarTablero(Lista,0);
	!comprobarCeroPuntos.

//Comprueba de forma recursiva cada posici?n del tablero y las posibilidades de jugada
+!comprobarTablero(Lista,N) : .length(Lista,Length) & N<Length <-
	.nth(N,Lista,celda(X,Y,Own));
	!comprobarDireccion(X,Y);
	!comprobarPuntos(X,Y);
	!comprobarTablero(Lista,N+1).

+!comprobarTablero(Lista,N).

//Comprueba los puntos que ofrece el desplazamiento de la ficha hacia abajo o hacia la derecha
+!comprobarDireccion(X,Y): Y<9 & X<9 <-

	//Caso "down"
	!abolishExplotada;
	!comprobarDown(X,Y);
	!comprobarPuntosDown(X,Y);

	//Caso "right"
	!abolishExplotada;
	!comprobarRight(X,Y);
	!comprobarPuntosRight(X,Y).

+!comprobarDireccion(X,Y).  

+!abolishExplotada <- 
	.abolish(explotada(X,Y)).

//Comprueba las consecuencias de un movimiento hacia abajo de la ficha en X,Y+1
+!comprobarDown(X,Y) : tablero(celda(X,Y+1,_),ficha(ColorDown,TipoDown)) & tablero(celda(X,Y,_),ficha(Color,Tipo))<-

	-tablero(celda(X,Y+1,_),ficha(ColorDown,TipoDown));
	-tablero(celda(X,Y,_),ficha(Color,Tipo));
	+tablero(celda(X,Y+1,0),ficha(Color,Tipo));
	+tablero(celda(X,Y,0),ficha(ColorDown,TipoDown));

	?comprobarPatrones(ColorDown,X,Y,StartsAtX1,StartsAtY1,Direction1,Pattern1);
	?comprobarPatrones(Color,X,Y+1,StartsAtX2,StartsAtY2,Direction2,Pattern2);

	-+celdasTotalJugada(0);
	-+puntosTotalJugada(0);
	
	-+actualPatternOwner(0);  //Determina el owner actual del patrón
	!handlePattern(ColorDown,StartsAtX1,StartsAtY1,Direction1,Pattern1);
	?actualPatternOwner(Owner1);
		/*.print("Owner2: ",Owner2);*/
	?celdasTotalJugada(Celdas1);
		/*.print("Owner2: ",Owner2);*/
	
	-+actualPatternOwner(0);  //Determina el owner actual del patrón
	!handlePattern(Color,StartsAtX2,StartsAtY2,Direction2,Pattern2);
	?actualPatternOwner(Owner2);
	/*.print("Owner2: ",Owner2);*/
	?celdasTotalJugada(Celdas2);
	/*.print("Owner2: ",Owner2);*/
	
	?comprobarCeldas(Owner1,Celdas1,Owner2,Celdas2,Saldo);
	-+celdasTotalJugada(Saldo);

	-tablero(celda(X,Y+1,_),ficha(Color,Tipo));
	-tablero(celda(X,Y,_),ficha(ColorDown,TipoDown));
	+tablero(celda(X,Y+1,0),ficha(ColorDown,TipoDown));
	+tablero(celda(X,Y,0),ficha(Color,Tipo)).

+!comprobarDown(X,Y).

//Comprueba las consecuencias de un movimiento hacia la derecha de la ficha en X+1,Y
+!comprobarRight(X,Y) : tablero(celda(X+1,Y,_),ficha(ColorRight,TipoRight)) & tablero(celda(X,Y,_),ficha(Color,Tipo))<-

	-tablero(celda(X+1,Y,_),ficha(ColorRight,TipoRight));
	-tablero(celda(X,Y,_),ficha(Color,Tipo));
	+tablero(celda(X+1,Y,0),ficha(Color,Tipo));
	+tablero(celda(X,Y,0),ficha(ColorRight,TipoRight));

	?comprobarPatrones(ColorRight,X,Y,StartsAtX1,StartsAtY1,Direction1,Pattern1);
	?comprobarPatrones(Color,X+1,Y,StartsAtX2,StartsAtY2,Direction2,Pattern2);

	-+celdasTotalJugada(0);
	-+puntosTotalJugada(0);
	
	-+actualPatternOwner(0);  //Determina el owner actual del patrón
	!handlePattern(ColorRight,StartsAtX1,StartsAtY1,Direction1,Pattern1);
	?actualPatternOwner(Owner1);
	?celdasTotalJugada(Celdas1);
	
	-+actualPatternOwner(0);  //Determina el owner actual del patrón
	!handlePattern(Color,StartsAtX2,StartsAtY2,Direction2,Pattern2);
	?actualPatternOwner(Owner2);
	?celdasTotalJugada(Celdas2);
	
	?comprobarCeldas(Owner1,Celdas1,Owner2,Celdas2,Saldo);
	-+celdasTotalJugada(Saldo);

	-tablero(celda(X+1,Y,_),ficha(Color,Tipo));
	-tablero(celda(X,Y,_),ficha(ColorRight,TipoRight));
	+tablero(celda(X+1,Y,0),ficha(ColorRight,TipoRight));
	+tablero(celda(X,Y,0),ficha(Color,Tipo)).

+!comprobarRight(X,Y).

+!comprobarPuntosDown(X,Y) : nivel(3) & puntosTotalJugada(PuntosDown) & celdasTotalJugada(Celdas) & celdasAct(Cact) & Celdas > Cact <-
	.print(Celdas);
	-+celdasAct(Celdas);
	-+puntos(PuntosDown);
	-+direction("down").
	
+!comprobarPuntosDown(X,Y) : nivel(3) & celdasTotalJugada(Celdas) & celdasAct(Cact) & Celdas = Cact 
		& puntosTotalJugada(PuntosDown) &  puntos(Puntos) & PuntosDown > Puntos <-
	-+puntos(PuntosDown);
	-+direction("down").
	
//Comprueba si la jugada hacia abajo ha superado la jugada anterior de m?s puntos
+!comprobarPuntosDown(X,Y) : not nivel(3) & puntosTotalJugada(PuntosDown) & puntos(Puntos) & PuntosDown > Puntos <-
	-+puntos(PuntosDown);
	-+direction("down").

+!comprobarPuntosDown(X,Y).

+!comprobarPuntosRight(X,Y) : nivel(3) & puntosTotalJugada(PuntosRight) & celdasTotalJugada(Celdas) & celdasAct(Cact) & Celdas > Cact <-
	.print(Celdas);	
	-+celdasAct(Celdas);
	-+puntos(PuntosRight);
	-+direction("right").
	
+!comprobarPuntosRight(X,Y) : nivel(3) & celdasTotalJugada(Celdas) & celdasAct(Cact) & Celdas = Cact 
		& puntosTotalJugada(PuntosRight) &  puntos(Puntos) & PuntosRight > Puntos <-
	-+puntos(PuntosRight);
	-+direction("right").

//Comprueba si la jugada hacia la derecha ha superado la jugada anterior de m?s puntos
+!comprobarPuntosRight(X,Y) : not nivel(3) & puntosTotalJugada(PuntosRight) & puntos(Puntos) & PuntosRight > Puntos <-
	-+puntos(PuntosRight);
	-+direction("right").

+!comprobarPuntosRight(X,Y).

//Si el n?mero de celdas que se consiguen es superior al anterior se actualizan los valores
+!comprobarPuntos(X,Y) : nivel(3) & puntos(Puntos) & direction(Dir) & celdasMax(Cmax) & celdasAct(Cact) & Cact > Cmax <-
	.print("Cmax nuevo: ", Cact);
	.print("Puntos: ", Puntos);
	-+cordX(X);
	-+cordY(Y);
	-+celdasMax(Cact);
	-+puntosMax(Puntos);
	-+dirMax(Dir).

//Si el n?mero de celdas es el mismo, pero el n?mero de puntos es mayor se actualizan los valores
+!comprobarPuntos(X,Y) : nivel(3) & puntos(Puntos) & direction(Dir) & puntosMax(PuntosMax) & Puntos > PuntosMax & 
		celdasMax(Cmax) & celdasAct(Cact) & Cact = Cmax <-
	.print("Cmax invariable: ", Cact);
	.print("Puntos: ", Puntos);
	-+cordX(X);
	-+cordY(Y);
	-+puntosMax(Puntos);
	-+dirMax(Dir).

//Comprueba que se ha mejorado la puntuaci?n con la comprobaci?n anterior y se guardan los datos de esta
+!comprobarPuntos(X,Y) : not nivel(3) & puntos(Puntos) & direction(Dir) & puntosMax(PuntosMax) & Puntos > PuntosMax <-
	-+cordX(X);
	-+cordY(Y);
	-+puntosMax(Puntos);
	-+dirMax(Dir).

+!comprobarPuntos(X,Y).

//Comprueba que no se pudieron hacer puntos en ninguna jugada, y guarda una aleatoria.
+!comprobarCeroPuntos: puntosMax(N) & N = 0 & pensarJugadaAleatoria(X,Y,Dir) <-
	-+cordX(X);
	-+cordY(Y);
	-+dirMax(Dir).

+!comprobarCeroPuntos.

//Gestion de patrones. Comprueba las explosiones de cada una de las fichas involucradas.
+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "3inLineH" <-

	!getPatternOwnership(StartsAtX,StartsAtY);
	!getPatternOwnership(StartsAtX,StartsAtY+1);
	!getPatternOwnership(StartsAtX,StartsAtY+2);

	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX,StartsAtY+1);
	!explosion(StartsAtX,StartsAtY+2).

+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "3inLineW" <-

	!getPatternOwnership(StartsAtX,StartsAtY);
	!getPatternOwnership(StartsAtX+1,StartsAtY);
	!getPatternOwnership(StartsAtX+2,StartsAtY);
	
	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX+1,StartsAtY);
	!explosion(StartsAtX+2,StartsAtY).

+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "4inLineH" & puntosTotalJugada(P) <-
	-+puntosTotalJugada(P+2);
	
	!getPatternOwnership(StartsAtX,StartsAtY);
	!getPatternOwnership(StartsAtX,StartsAtY+1);
	!getPatternOwnership(StartsAtX,StartsAtY+2);
	!getPatternOwnership(StartsAtX,StartsAtY+3);
	
	
	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX,StartsAtY+1);
	!explosion(StartsAtX,StartsAtY+2);
	!explosion(StartsAtX,StartsAtY+3).

+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "4inLineW" & puntosTotalJugada(P) <-
	-+puntosTotalJugada(P+2);
	
	!getPatternOwnership(StartsAtX,StartsAtY);
	!getPatternOwnership(StartsAtX+1,StartsAtY);
	!getPatternOwnership(StartsAtX+2,StartsAtY);
	!getPatternOwnership(StartsAtX+3,StartsAtY);
	
	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX+1,StartsAtY);
	!explosion(StartsAtX+2,StartsAtY);
	!explosion(StartsAtX+3,StartsAtY).

+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "5inLineH" & puntosTotalJugada(P)<-
	-+puntosTotalJugada(P+8);
	
	!getPatternOwnership(StartsAtX,StartsAtY);
	!getPatternOwnership(StartsAtX,StartsAtY+1);
	!getPatternOwnership(StartsAtX,StartsAtY+2);
	!getPatternOwnership(StartsAtX,StartsAtY+3);
	!getPatternOwnership(StartsAtX,StartsAtY+4);
	
	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX,StartsAtY+1);
	!explosion(StartsAtX,StartsAtY+2);
	!explosion(StartsAtX,StartsAtY+3);
	!explosion(StartsAtX,StartsAtY+4).

+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "5inLineW" & puntosTotalJugada(P) <-
	-+puntosTotalJugada(P+8);
	
	!getPatternOwnership(StartsAtX,StartsAtY);
	!getPatternOwnership(StartsAtX+1,StartsAtY);
	!getPatternOwnership(StartsAtX+2,StartsAtY);
	!getPatternOwnership(StartsAtX+3,StartsAtY);
	!getPatternOwnership(StartsAtX+4,StartsAtY);
	
	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX+1,StartsAtY);
	!explosion(StartsAtX+2,StartsAtY);
	!explosion(StartsAtX+3,StartsAtY);
	!explosion(StartsAtX+4,StartsAtY).

+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "Square" & puntosTotalJugada(P) <-
	-+puntosTotalJugada(P+4);
	
	!getPatternOwnership(StartsAtX,StartsAtY);
	!getPatternOwnership(StartsAtX+1,StartsAtY);
	!getPatternOwnership(StartsAtX,StartsAtY+1);
	!getPatternOwnership(StartsAtX+1,StartsAtY+1);
	
	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX+1,StartsAtY);
	!explosion(StartsAtX,StartsAtY+1);
	!explosion(StartsAtX+1,StartsAtY+1).

+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "T" & puntosTotalJugada(P)<-
	-+puntosTotalJugada(P+6);
	!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern).

+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern).

//Manejo de las particularidades del patr?n en T
+!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern) : Direction = "standing" <-
	
	!getPatternOwnership(StartsAtX,StartsAtY);
	!getPatternOwnership(StartsAtX+1,StartsAtY);
	!getPatternOwnership(StartsAtX-1,StartsAtY);
	!getPatternOwnership(StartsAtX,StartsAtY+1);
	!getPatternOwnership(StartsAtX,StartsAtY+2);

	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX+1,StartsAtY);
	!explosion(StartsAtX-1,StartsAtY);
	!explosion(StartsAtX,StartsAtY+1);
	!explosion(StartsAtX,StartsAtY+2).

+!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern) : Direction = "upside-down" <-

	!getPatternOwnership(StartsAtX,StartsAtY);
	!getPatternOwnership(StartsAtX+1,StartsAtY);
	!getPatternOwnership(StartsAtX-1,StartsAtY);
	!getPatternOwnership(StartsAtX,StartsAtY-1);
	!getPatternOwnership(StartsAtX,StartsAtY-2);
	
	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX+1,StartsAtY);
	!explosion(StartsAtX-1,StartsAtY);
	!explosion(StartsAtX,StartsAtY-1);
	!explosion(StartsAtX,StartsAtY-2).

+!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern) : Direction = "pointing-right" <-
	!getPatternOwnership(StartsAtX,StartsAtY);
	!getPatternOwnership(StartsAtX,StartsAtY+1);
	!getPatternOwnership(StartsAtX,StartsAtY-1);
	!getPatternOwnership(StartsAtX+1,StartsAtY);
	!getPatternOwnership(StartsAtX+2,StartsAtY);

	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX,StartsAtY+1);
	!explosion(StartsAtX,StartsAtY-1);
	!explosion(StartsAtX+1,StartsAtY);
	!explosion(StartsAtX+2,StartsAtY).

+!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern) : Direction = "pointing-left" <-

	!getPatternOwnership(StartsAtX,StartsAtY);
	!getPatternOwnership(StartsAtX,StartsAtY+1);
	!getPatternOwnership(StartsAtX,StartsAtY-1);
	!getPatternOwnership(StartsAtX-1,StartsAtY);
	!getPatternOwnership(StartsAtX-2,StartsAtY);
	
	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX,StartsAtY+1);
	!explosion(StartsAtX,StartsAtY-1);
	!explosion(StartsAtX-1,StartsAtY);
	!explosion(StartsAtX-2,StartsAtY).
	
//Comprueba una ficha del patrón y quién va a ser el dueño de la jugada en caso de que se produzca
+!getPatternOwnership(X,Y): tablero(celda(X,Y,SteakOwner),ficha(Color,Tipo)) & patternOwner(SteakOwner, Owner)<-
	-+actualPatternOwner(Owner); //Actualiza el dueño actual del patrón 
.

+!getPatternOwnership(X,Y).

//Calculo del numero de puntos por explosion y consecuencias
+!explosion(X,Y) : tablero(celda(X,Y,SteakOwner),ficha(C,T)) & direction(D) & puntosTotalJugada(P) & not explotada(X,Y) & patternOwner(SteakOwner, Owner) <-
	+explotada(X,Y);
	!specialExplosion(X,Y,C,T,D).

+!specialExplosion(X,Y,C,T,D) : T = in & puntosTotalJugada(P) & nivel(3) & tablero(celda(X,Y,Owner),ficha(Color,Tipo)) 
		& actualPatternOwner(ActualOwner) & not (ActualOwner=0 | Owner = ActualOwner | ActualOwner="none") & celdasTotalJugada(C) <-
	.print("*************Incrementamos en uno los puntos de celda");
    -+puntosTotalJugada(P+1);
	-+celdasTotalJugada(C+1).	
	
+!specialExplosion(X,Y,C,T,D) : T = in & puntosTotalJugada(P)<-
    -+puntosTotalJugada(P+1).
	
+!specialExplosion(X,Y,C,T,D) : T = ip  & (D="up" | D="down") & puntosTotalJugada(P) & nivel(3) & tablero(celda(X,Y,Owner),ficha(Color,Tipo)) 
		& actualPatternOwner(ActualOwner) & not (ActualOwner=0 | Owner = ActualOwner | ActualOwner="none") & celdasTotalJugada(C)<-     //Explosion en linea vertical
	+explotada(X,Y);
	-+celdasTotalJugada(C+1);
	-+puntosTotalJugada(P+2);
	.findall(tablero(celda(X,NY,_),ficha(NC,_)),tablero(celda(X,NY,_),ficha(NC,_)),Lista);
	for(.member(tablero(celda(X,NY,_),ficha(NC,_)),Lista)){
		!explosion(X,NY);
	}.

+!specialExplosion(X,Y,C,T,D) : T = ip  & (D="up" | D="down") & puntosTotalJugada(P)<-     //Explosion en linea vertical
	+explotada(X,Y);
	-+puntosTotalJugada(P+2);
	.findall(tablero(celda(X,NY,_),ficha(NC,_)),tablero(celda(X,NY,_),ficha(NC,_)),Lista);
	for(.member(tablero(celda(X,NY,_),ficha(NC,_)),Lista)){
		!explosion(X,NY);
	}.
	
+!specialExplosion(X,Y,C,T,D) : T = ip  & (D="left" | D="right") & puntosTotalJugada(P) & nivel(3) & tablero(celda(X,Y,Owner),ficha(Color,Tipo)) 
		& actualPatternOwner(ActualOwner) & not (ActualOwner=0 | Owner = ActualOwner | ActualOwner="none") & celdasTotalJugada(C)<-     //Explosion en linea horizontal
	+explotada(X,Y);
	-+celdasTotalJugada(C+1);
	-+puntosTotalJugada(P+2);
	.findall(tablero(celda(NX,Y,_),ficha(NC,_)),tablero(celda(NX,Y,_),ficha(NC,_)),Lista);
	for(.member(tablero(celda(NX,Y,_),ficha(NC,_)),Lista)){
		!explosion(NX,Y);
	}.

+!specialExplosion(X,Y,C,T,D) : T = ip  & (D="left" | D="right") & puntosTotalJugada(P)<-     //Explosion en linea horizontal
	+explotada(X,Y);
	-+puntosTotalJugada(P+2);
	.findall(tablero(celda(NX,Y,_),ficha(NC,_)),tablero(celda(NX,Y,_),ficha(NC,_)),Lista);
	for(.member(tablero(celda(NX,Y,_),ficha(NC,_)),Lista)){
		!explosion(NX,Y);
	}.
	
+!specialExplosion(X,Y,C,T,D) : T = gs & tablero(celda(NX,NY,_),ficha(C,_)) & not X=NX & not Y=NY & puntosTotalJugada(P) & nivel(3)
		& tablero(celda(X,Y,Owner),ficha(Color,Tipo)) & actualPatternOwner(ActualOwner) & not (ActualOwner=0 | Owner = ActualOwner | ActualOwner="none") & celdasTotalJugada(C)<-	 //Explosion de una ficha del mismo color (distinta a si misma)
	-+celdasTotalJugada(C+1);
	-+puntosTotalJugada(P+4);
	!explosion(NX,NY).

+!specialExplosion(X,Y,C,T,D) : T = gs & tablero(celda(NX,NY,_),ficha(C,_)) & not X=NX & not Y=NY & puntosTotalJugada(P)<-	 //Explosion de una ficha del mismo color (distinta a si misma)
	-+puntosTotalJugada(P+4);
	!explosion(NX,NY).

+!specialExplosion(X,Y,C,T,D) : T = co & puntosTotalJugada(P) & nivel(3)
		& tablero(celda(X,Y,Owner),ficha(Color,Tipo)) & actualPatternOwner(ActualOwner) & not (ActualOwner=0 | Owner = ActualOwner | ActualOwner="none") & celdasTotalJugada(C)<-  			//Explosion en cuadrado 3x3
	-+celdasTotalJugada(C+1);
	-+puntosTotalJugada(P+6);
	for ( .range(I,-1,1) ) {
		for ( .range(J,-1,1) ) {
			!coExplosion(X+I,Y+J);
		};
	}.
	
+!specialExplosion(X,Y,C,T,D) : T = co & puntosTotalJugada(P)<-  			//Explosion en cuadrado 3x3
	-+puntosTotalJugada(P+6);
	for ( .range(I,-1,1) ) {
		for ( .range(J,-1,1) ) {
			!coExplosion(X+I,Y+J);
		};
	}.

+!coExplosion(X,Y) : tablero(celda(X,Y,_),ficha(C,_)) <-
	  !explosion(X,Y).

+!coExplosion(X,Y).

+!specialExplosion(X,Y,C,T,D) : T = ct & puntosTotalJugada(P) & nivel(3)
		& tablero(celda(X,Y,Owner),ficha(Color,Tipo)) & actualPatternOwner(ActualOwner) & not (ActualOwner=0 | Owner = ActualOwner | ActualOwner="none") & celdasTotalJugada(C) <-     //Explosion de todas las fichas de ese color
	+explotada(X,Y);
	-+celdasTotalJugada(C+1);
	-+puntosTotalJugada(P+8);
	.findall(tablero(celda(NX,NY,_),ficha(C,_)),tablero(celda(NX,NY,_),ficha(C,_)),Lista);
	for(.member(tablero(celda(NX,NY,_),ficha(C,_)),Lista)){
		!explosion(NX,NY);
	}.

+!specialExplosion(X,Y,C,T,D) : T = ct & puntosTotalJugada(P) <-     //Explosion de todas las fichas de ese color
	+explotada(X,Y);
	-+puntosTotalJugada(P+8);
	.findall(tablero(celda(NX,NY,_),ficha(C,_)),tablero(celda(NX,NY,_),ficha(C,_)),Lista);
	for(.member(tablero(celda(NX,NY,_),ficha(C,_)),Lista)){
		!explosion(NX,NY);
	}.

+!specialExplosion(X,Y,C,T,D).
+!explosion(X,Y).


//Borrado de todas las creencias sobre el tablero para poder hacer una actualizacion limpia
+deleteTableroBB [source(judge)]<-
	.abolish(tablero(X,Y)).


//Recepcion de la informacion de una posicion del tablero
+tablero(Celda,Ficha)[source(judge)] <-  //Actua como interface para que las creencias contenidas en la base del conocimiento sean "self" y evitar posibles errores en las tomas de decisiones
	-tablero(Celda,Ficha)[source(judge)];
	+tablero(Celda,Ficha).
	
+nivel(N)[source(judge)] <-  
	-nivel(N)[source(judge)];
	+nivel(N).

+playerOwner(N)[source(judge)] <-  
	-playerOwner(N)[source(judge)];
	+playerOwner(N).	

//Movimiento realizado correctamente
+valido[source(judge)] <- .print("He hecho una buena jugada!").


//Movimiento realizado entre dos fichas del mismo color
+tryAgain[source(judge)] <- .print("Me he equivocado al comprobar el color de las fichas. Pensare otra jugada");
	!realizarJugada.

//Movimiento realizado fuera del tablero
+invalido(fueraTablero,N)[source(judge)] : N<=3 <-
	.print("Me he equivocado y he intentado mover una ficha hacia fuera del tablero");
	!realizarJugada.

+invalido(fueraTablero,N)[source(judge)] : N>3 <-
	.print("Me he equivocado demasiadas veces intentando mover fichas hacia fuera del tablero. Paso Turno!");
	.send(judge,tell,pasoTurno);
	.send(judge,untell,pasoTurno).

//Movimiento realizado fuera de turno
+invalido(fueraTurno,N)[source(judge)] <- .print("Soy un tramposo!!! Intente realizar una jugada fuera de mi turno y el Juez me ha pillado").

//Plan por defecto a ejecutar en caso desconocido.
+Default[source(A)]: not A=self  & not tablero(C,F) & not size(N)<- .print("El agente ",A," se comunica conmigo, pero no lo entiendo! (",Default,")").


