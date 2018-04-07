// Agent player in project ESEI_SAGA.mas2j


//Cargarse comprobaci?n izquierda y arriba

/*
* Su objetivo es alcanzar la mayor puntiaci?n posible en cada movimiento
*/

/* Initial beliefs and rules */
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


	//Reconoce un patron de 3 en horizontal, devuelve las coordenadas en las que se inicia el patron
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

+!comunicarJugada : cordX(X) & cordY(Y) & dirMax(Dir) <-
	.print("Quiero mover desde posicion (",X,",",Y,") en direccion ",Dir);
	.send(judge,tell,moverDesdeEnDireccion(pos(X,Y),Dir));
	.send(judge,untell,moverDesdeEnDireccion(pos(X,Y),Dir)).

+!comunicarJugada.

+!pensarJugada  <-
	-+puntosMax(0);
	-+puntos(0);
	-+direction("none");
	.findall(celda(X,Y,Own),tablero(celda(X,Y,Own),_),Lista);
	!comprobarTablero(Lista,0);
	/*for ( .member(tablero(celda(X,Y,_),_),Lista)) {  ---- TODO ----
		+comprobarDireccion(X,Y);
		-comprobarDireccion(X,Y);
		+comprobarPuntos(X,Y);
		-comprobarPuntos(X,Y);
	 }; */
	!comprobarCeroPuntos.


+!comprobarTablero(Lista,N) : .length(Lista,Length) & N<Length <-
	.nth(N,Lista,celda(X,Y,Own));
	!comprobarDireccion(X,Y);
	!comprobarPuntos(X,Y);

	!comprobarTablero(Lista,N+1).

+!comprobarTablero(Lista,N).

//Problema al reasignar una variable
+!comprobarDireccion(X,Y): Y<9 & X<9 <-

	//Caso "down"
	!comprobarDown(X,Y);
	!comprobarPuntosDown(X,Y);


	//Caso "right"
	!comprobarRight(X,Y);
	!comprobarPuntosRight(X,Y).

+!comprobarDireccion(X,Y).


+!comprobarDown(X,Y) : tablero(celda(X,Y+1,_),ficha(ColorDown,TipoDown)) & tablero(celda(X,Y,_),ficha(Color,Tipo))<-

	  -tablero(celda(X,Y+1,_),ficha(ColorDown,TipoDown));
		-tablero(celda(X,Y,_),ficha(Color,Tipo));
		+tablero(celda(X,Y+1,0),ficha(Color,Tipo));
		+tablero(celda(X,Y,0),ficha(ColorDown,TipoDown));

		?comprobarPatrones(ColorDown,X,Y,StartsAtX1,StartsAtY1,Direction1,Pattern1);
		?comprobarPatrones(Color,X,Y+1,StartsAtX2,StartsAtY2,Direction2,Pattern2);

		-+puntosTotalJugada(0);
		!handlePattern(ColorDown,StartsAtX1,StartsAtY1,Direction1,Pattern1);
		!handlePattern(Color,StartsAtX2,StartsAtY2,Direction2,Pattern2);

		-tablero(celda(X,Y+1,_),ficha(Color,Tipo));
		-tablero(celda(X,Y,_),ficha(ColorDown,TipoDown));
		+tablero(celda(X,Y+1,0),ficha(ColorDown,TipoDown));
		+tablero(celda(X,Y,0),ficha(Color,Tipo)).

+!comprobarDown(X,Y).

+!comprobarRight(X,Y) : tablero(celda(X+1,Y,_),ficha(ColorRight,TipoRight)) & tablero(celda(X,Y,_),ficha(Color,Tipo))<-

		-tablero(celda(X+1,Y,_),ficha(ColorRight,TipoRight));
		-tablero(celda(X,Y,_),ficha(Color,Tipo));
		+tablero(celda(X+1,Y,0),ficha(Color,Tipo));
		+tablero(celda(X,Y,0),ficha(ColorRight,TipoRight));

		?comprobarPatrones(ColorRight,X,Y,StartsAtX1,StartsAtY1,Direction1,Pattern1);
		?comprobarPatrones(Color,X+1,Y,StartsAtX2,StartsAtY2,Direction2,Pattern2);

		-+puntosTotalJugada(0);
		!handlePattern(ColorRight,StartsAtX1,StartsAtY1,Direction1,Pattern1);
		!handlePattern(Color,StartsAtX2,StartsAtY2,Direction2,Pattern2);

		-tablero(celda(X+1,Y,_),ficha(Color,Tipo));
		-tablero(celda(X,Y,_),ficha(ColorRight,TipoRight));
		+tablero(celda(X+1,Y,0),ficha(ColorRight,TipoRight));
		+tablero(celda(X,Y,0),ficha(Color,Tipo)).

+!comprobarRight(X,Y).

+!comprobarPuntosDown(X,Y) : puntosTotalJugada(PuntosDown) & puntos(Puntos) & PuntosDown > Puntos <-
		.print("Con esta jugada(",X,",",Y,") hago: ",PuntosDown);
		-+puntos(PuntosDown);
		-+direction("down").

+!comprobarPuntosDown(X,Y).

+!comprobarPuntosRight(X,Y) : puntosTotalJugada(PuntosRight) & puntos(Puntos) & PuntosRight > Puntos <-
		.print("Con esta jugada(",X,",",Y,") hago: ",PuntosRight);
		-+puntos(PuntosRight);
		-+direction("right").

+!comprobarPuntosRight(X,Y).

+!comprobarPuntos(X,Y) : puntos(Puntos) & direction(Dir) & puntosMax(PuntosMax) & Puntos > PuntosMax <-
				-+cordX(X);
				-+cordY(Y);
				-+puntosMax(Puntos);
				-+dirMax(Dir).

+!comprobarPuntos(X,Y).

+!comprobarCeroPuntos: puntosMax(N) & N = 0 & pensarJugadaAleatoria(X,Y,Dir) <-
		-+cordX(X);
		-+cordY(Y);
		-+dirMax(Dir).

+!comprobarCeroPuntos.

//Gestion de patrones
+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "3inLineH" <-
		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX,StartsAtY+1);
		!explosion(StartsAtX,StartsAtY+2).

+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "3inLineW" <-
		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX+1,StartsAtY);
		!explosion(StartsAtX+2,StartsAtY).


+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "4inLineH" <-
		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX,StartsAtY+1);
		!explosion(StartsAtX,StartsAtY+2);
		!explosion(StartsAtX,StartsAtY+3).


+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "4inLineW" <-
		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX+1,StartsAtY);
		!explosion(StartsAtX+2,StartsAtY);
		!explosion(StartsAtX+3,StartsAtY).


+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "5inLineH"<-
		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX,StartsAtY+1);
		!explosion(StartsAtX,StartsAtY+2);
		!explosion(StartsAtX,StartsAtY+3);
		!explosion(StartsAtX,StartsAtY+4).


+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "5inLineW" <-
		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX+1,StartsAtY);
		!explosion(StartsAtX+2,StartsAtY);
		!explosion(StartsAtX+3,StartsAtY);
		!explosion(StartsAtX+4,StartsAtY).


+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "Square" <-
		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX+1,StartsAtY);
		!explosion(StartsAtX,StartsAtY+1);
		!explosion(StartsAtX+1,StartsAtY+1).


+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "T"<-
	!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern).

+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern).

+!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern) : Direction = "standing" <-
	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX+1,StartsAtY);
	!explosion(StartsAtX-1,StartsAtY);
	!explosion(StartsAtX,StartsAtY+1);
	!explosion(StartsAtX,StartsAtY+2).

+!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern) : Direction = "upside-down" <-
	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX+1,StartsAtY);
	!explosion(StartsAtX-1,StartsAtY);
	!explosion(StartsAtX,StartsAtY-1);
	!explosion(StartsAtX,StartsAtY-2).


+!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern) : Direction = "pointing-right" <-

	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX,StartsAtY+1);
	!explosion(StartsAtX,StartsAtY-1);
	!explosion(StartsAtX+1,StartsAtY);
	!explosion(StartsAtX+2,StartsAtY).

+!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern) : Direction = "pointing-left" <-

	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX,StartsAtY+1);
	!explosion(StartsAtX,StartsAtY-1);
	!explosion(StartsAtX-1,StartsAtY);
	!explosion(StartsAtX-2,StartsAtY).

//Explosion va a comprobar que alguna de las fichas que se mueve es una ficha especial, pero no va a comprobar que forme asociaci?n con una ficha que explote.

//Si la jugada no ha generado puntos por patrón ya no hacemos nada
/*+!explosion(X,Y,D,Entrada) : puntosJugada(P) & P = 0.

//Si es la primera explosión, y la ficha que se comprueba es in, quitamos un punto para que no sume un punto extra
+!explosion(X,Y,D,Entrada) : puntosTotalJugada(PT) & puntosJugada(P) & tablero(celda(X,Y,_),ficha(C,T)) & T = in <-
			-+puntosJugada(P-1);
			-+puntosTotalJugada(PT-1);
			-tablero(celda(X,Y,Own),Ficha);
			+tablero(celda(X,Y,0),e);
			!specialExplosion(X,Y,C,T,D);
			-tablero(celda(X,Y,0),e);
			+tablero(celda(X,Y,Own),Ficha).

//Si la primera ficha no es una in, entramos en explosión normal
+!explosion(X,Y,D,Entrada) : puntosJugada(P) & tablero(celda(X,Y,_),ficha(C,T)) <-
						!explosion(X,Y,D).

+!explosion(X,Y,D,Entrada).

//Gestion de exlosiones especiales y puntuaciones
//En la explosión hacemos borrado de la ficha y luego la recuperamos para la base del conocimiento
+!explosion(X,Y,D) : puntosJugada(P) & tablero(celda(X,Y,_),ficha(C,T))<-
			-tablero(celda(X,Y,Own),Ficha);
			+tablero(celda(X,Y,0),e);
			!specialExplosion(X,Y,C,T,D);
			-tablero(celda(X,Y,0),e);
			+tablero(celda(X,Y,Own),Ficha).

+!explosion(X,Y,D).

+!specialExplosion(X,Y,C,T,D) : puntosTotalJugada(PT) & puntosJugada(P) & T = in <-
    -+puntosJugada(P+1);
		-+puntosTotalJugada(PT+1).

+!specialExplosion(X,Y,C,T,D) : puntosTotalJugada(PT) & puntosJugada(P) & T = ip  & (D="up" | D="down")<-     //Explosion en linea
			.print("ip up o down");
			-+puntosJugada(P+2);
			-+puntosTotalJugada(PT+2);
			for( tablero(celda(X,NY,_),ficha(NC,_))){
					.print("Bucle ip");
					!explosion(X,NY,D);
				}.

+!specialExplosion(X,Y,C,T,D) : puntosTotalJugada(PT) & puntosJugada(P) & T = ip  & (D="left" | D="right")<-     //Explosion en linea horizontal
			.print("ip left o right");
			-+puntosJugada(P+2);
			-+puntosTotalJugada(PT+2);
			for( tablero(celda(NX,Y,_),ficha(NC,_))){
					.print("Bucle ip");
				 	!explosion(NX,Y,D);
				}.

+!specialExplosion(X,Y,C,T,D) : puntosTotalJugada(PT) & puntosJugada(P) & T = gs & tablero(celda(NX,NY,_),ficha(C,_)) & not X=NX & not Y=NY <-	 //Explosion de una ficha del mismo color
			.print("gs");
			-+puntosJugada(P+4);
			-+puntosTotalJugada(PT+4);
			!explosion(NX,NY,D).

+!specialExplosion(X,Y,C,T,D) : puntosTotalJugada(PT) & puntosJugada(P) & T = co <-  			//Explosion en cuadrado 3x3
			.print("co");
			-+puntosJugada(P+6);
			-+puntosTotalJugada(PT+6);
			for ( .range(I,-1,1) ) {
				for ( .range(J,-1,1) ) {
					!coExplosion(X+I,Y+J,D);
				};
			}.

+!coExplosion(X,Y,D) : puntosJugada(P) & tablero(celda(X,Y,_),ficha(C,_)) <-
			  !explosion(X,Y,D).

+!specialExplosion(X,Y,C,T,D) : puntosTotalJugada(PT) & puntosJugada(P) & T = ct <-     //Explosion de todas las fichas de ese color
			.print("ct");
			-+puntosJugada(P+8);
			-+puntosTotalJugada(PT+8);
			for( tablero(celda(NX,NY,_),ficha(C,_))){
				 	!explosion(NX,NY,D);
			}.

+!specialExplosion(X,Y,C,T,D) <- .print("ERROR en +specialExplosion()").*/

//Cálculo del número de puntos por explosion y consecuencias
+!explosion(X,Y) : tablero(celda(X,Y,_),ficha(C,T)) & direction(D) & puntosTotalJugada(P)<-
		!specialExplosion(X,Y,C,T,D).

+!specialExplosion(X,Y,C,T,D) : T = in & puntosTotalJugada(P)<-
    -+puntosTotalJugada(P+1).


+!specialExplosion(X,Y,C,T,D) : T = ip  & (D="up" | D="down") & puntosTotalJugada(P)<-     //Explosion en linea vertical
			-tablero(celda(X,Y,Own),ficha(C,T));
			-+puntosTotalJugada(P+2);
			for( tablero(celda(X,NY,_),ficha(NC,_))){
					!explosion(X,NY);
				};
			+tablero(celda(X,Y,Own),ficha(C,T)).

+!specialExplosion(X,Y,C,T,D) : T = ip  & (D="left" | D="right") & puntosTotalJugada(P)<-     //Explosion en linea horizontal
			-tablero(celda(X,Y,Own),ficha(C,T));
			-+puntosTotalJugada(P+2);
			for( tablero(celda(NX,Y,_),ficha(NC,_))){
				 	!explosion(NX,Y);
				};
			+tablero(celda(X,Y,Own),ficha(C,T)).

+!specialExplosion(X,Y,C,T,D) : T = gs & tablero(celda(NX,NY,_),ficha(C,_)) & not X=NX & not Y=NY & puntosTotalJugada(P)<-	 //Explosion de una ficha del mismo color (distinta a si misma)
			-+puntosTotalJugada(P+4);
			!explosion(NX,NY).


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

+!specialExplosion(X,Y,C,T,D) : T = ct & puntosTotalJugada(P) <-     //Explosion de todas las fichas de ese color
			-tablero(celda(X,Y,Own),ficha(C,T));
			-+puntosTotalJugada(P+8);
			for( tablero(celda(NX,NY,_),ficha(C,_))){
				 	!explosion(NX,NY);
			};
			+tablero(celda(X,Y,Own),ficha(C,T)).

+!specialExplosion(X,Y,C,T,D).
+!explosion(X,Y).


//Borrado de todas las creencias sobre el tablero para poder hacer una actualizacion limpia /* CODIGO NUEVO */
+deleteTableroBB [source(judge)]<-
	.abolish(tablero(X,Y)).


//Recepcion de la informacion de una posicion del tablero
+tablero(Celda,Ficha)[source(judge)] <-  //Actua como interface para que las creencias contenidas en la base del conocimiento sean "self" y evitar posibles errores en las tomas de decisiones
				-tablero(Celda,Ficha)[source(judge)];
				+tablero(Celda,Ficha).

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
+Default[source(A)]: not A=self  & not tablero(C,F) <- .print("El agente ",A," se comunica conmigo, pero no lo entiendo!").

