// Agent player in project ESEI_SAGA.mas2j


//Cargarse comprobación izquierda y arriba

/*
* Su objetivo es alcanzar la mayor puntiaciï¿½n posible en cada movimiento
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
	

	
//Reconocimiento de patrones
//Los Patrones que devuelven mas puntos son los primeros.
//Meter los puntos que aportan las fichas especiales ---- TODO ----
//T apuntando para arriba no funciona ---- TODO ----
comprobarPatrones(Color,X,Y,Puntos) :-
	((pattern5inLineW(Color,X,Y) & Puntos=5) |
	(pattern5inLineH(Color,X,Y) & Puntos=5) |
	(patternT(Color,X,Y) & Puntos=5) |
	(patternSquare(Color,X,Y) & Puntos=4)|
	(pattern4inLineW(Color,X,Y) & Puntos=4)|
	(pattern4inLineH(Color,X,Y) & Puntos=4) |
	(pattern3inLineW(Color,X,Y) & Puntos=3) |
	(pattern3inLineH(Color,X,Y) & Puntos=3) | 
	(Puntos=0)).

	
pattern5inLineH(Color,X,Y) :- 
	(tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+2,_),ficha(Color,_)) & 
	tablero(celda(X,Y+3,_),ficha(Color,_)) &
	tablero(celda(X,Y+4,_),ficha(Color,_))) |
	(tablero(celda(X,Y-4,_),ficha(Color,_)) & 
	tablero(celda(X,Y-3,_),ficha(Color,_)) & 
	tablero(celda(X,Y-2,_),ficha(Color,_)) & 
	tablero(celda(X,Y-1,_),ficha(Color,_))) |
	(tablero(celda(X,Y-3,_),ficha(Color,_)) & 
	tablero(celda(X,Y-2,_),ficha(Color,_)) & 
	tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_))) |
	(tablero(celda(X,Y-2,_),ficha(Color,_)) & 
	tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+2,_),ficha(Color,_))) | 
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+2,_),ficha(Color,_)) & 
	tablero(celda(X,Y+3,_),ficha(Color,_))).

		
pattern5inLineW(Color,X,Y) :- 
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+2,Y,_),ficha(Color,_)) & 
	tablero(celda(X+3,Y,_),ficha(Color,_)) &
	tablero(celda(X+4,Y,_),ficha(Color,_))) |
	(tablero(celda(X-4,Y,_),ficha(Color,_)) & 
	tablero(celda(X-3,Y,_),ficha(Color,_)) & 
	tablero(celda(X-2,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_))) |
	(tablero(celda(X-3,Y,_),ficha(Color,_)) & 
	tablero(celda(X-2,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_))) |
	(tablero(celda(X-2,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+2,Y,_),ficha(Color,_))) | 
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+2,Y,_),ficha(Color,_)) & 
	tablero(celda(X+3,Y,_),ficha(Color,_))).

patternT(Color,X,Y) :- 
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+2,_),ficha(Color,_)) & .wait(10000)) |
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y-2,_),ficha(Color,_)) & .wait(10000)) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+2,Y,_),ficha(Color,_)) & .wait(10000)) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X-2,Y,_),ficha(Color,_)) & .wait(10000)).

	
patternSquare(Color,X,Y) :- 
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y+1,_),ficha(Color,_))) |
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_))) | 
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_))) | 
	(tablero(celda(X-1,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_))).	
	
pattern4inLineH(Color,X,Y) :- 
	(tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+2,_),ficha(Color,_)) & 
	tablero(celda(X,Y+3,_),ficha(Color,_))) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y-2,_),ficha(Color,_)) & 
	tablero(celda(X,Y-3,_),ficha(Color,_))) | 
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+2,_),ficha(Color,_))) | 
	(tablero(celda(X,Y-2,_),ficha(Color,_)) & 
	tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_))).

pattern4inLineW(Color,X,Y) :- 
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+2,Y,_),ficha(Color,_)) & 
	tablero(celda(X+3,Y,_),ficha(Color,_))) |
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X-2,Y,_),ficha(Color,_)) & 
	tablero(celda(X-3,Y,_),ficha(Color,_))) | 
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+2,Y,_),ficha(Color,_))) | 
	(tablero(celda(X-2,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_))).
	
	
//Reconoce un patron de 3 en horizontal, devuelve las coordenadas en las que se inicia el patr?n
pattern3inLineW(Color,X,Y) :- 
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & tablero(celda(X+2,Y,_),ficha(Color,_))) | 
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & tablero(celda(X-2,Y,_),ficha(Color,_))) | 
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & tablero(celda(X+1,Y,_),ficha(Color,_))).

pattern3inLineH(Color,X,Y) :- 
	(tablero(celda(X,Y+1,_),ficha(Color,_)) & tablero(celda(X,Y+2,_),ficha(Color,_))) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & tablero(celda(X,Y-2,_),ficha(Color,_))) |  
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & tablero(celda(X,Y+1,_),ficha(Color,_))).

	


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
	-+puntosDown(0);
	
	!comprobarDown(X,Y);	
	!comprobarPuntosDown(X,Y);                         
	                      
	
	//Caso "right"
	-+puntosRight(0);

	!comprobarRight(X,Y);
	!comprobarPuntosRight(X,Y).
	
+!comprobarDireccion(X,Y).

	
+!comprobarDown(X,Y) : tablero(celda(X,Y+1,_),ficha(ColorDown,TipoDown)) & tablero(celda(X,Y,_),ficha(Color,Tipo))<-		

		-tablero(celda(X,Y+1,_),ficha(ColorDown,TipoDown));
		-tablero(celda(X,Y,_),ficha(Color,Tipo));
		+tablero(celda(X,Y+1,0),ficha(Color,Tipo));
		+tablero(celda(X,Y,0),ficha(ColorDown,TipoDown));
		
		?comprobarPatrones(ColorDown,X,Y,Puntos1);
		?comprobarPatrones(Color,X,Y+1,Puntos2);

		-+puntosJugada(Puntos1 + Puntos2);
		//Sumamos los puntos de explosiones a los del movimiento
		!explosion(X,Y,"down",Puntos1);
		!explosion(X,Y+1,"up",Puntos2);
		
		?puntosJugada(P);
		-+puntosDown(P);
		                                            
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
				
		?comprobarPatrones(ColorRight,X,Y,Puntos1);	
		?comprobarPatrones(Color,X+1,Y,Puntos2);
				
		-+puntosJugada(Puntos1 + Puntos2);
		//Sumamos los puntos de explosiones a los del movimiento	
		!explosion(X,Y,"right",Puntos1);
		!explosion(X+1,Y,"left",Puntos2);
		
		?puntosJugada(P);
		-+puntosRight(P);
		
		-tablero(celda(X+1,Y,_),ficha(Color,Tipo));
		-tablero(celda(X,Y,_),ficha(ColorRight,TipoRight));
		+tablero(celda(X+1,Y,0),ficha(ColorRight,TipoRight));
		+tablero(celda(X,Y,0),ficha(Color,Tipo)).
		
+!comprobarRight(X,Y).
		
+!comprobarPuntosDown(X,Y) : puntosDown(PuntosDown) & puntos(Puntos) & PuntosDown > Puntos <-
		.print("Había: ",Puntos," puntos");
		.print("Con esta jugada hago: ",PuntosDown);

		-+puntos(PuntosDown);
		-+direction("down").
		
+!comprobarPuntosDown(X,Y).

+!comprobarPuntosRight(X,Y) : puntosRight(PuntosRight) & puntos(Puntos) & PuntosRight > Puntos <-
		.print("Había: ",Puntos," puntos");
		.print("Con esta jugada hago: ",PuntosRight);

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

//Explosion va a comprobar que alguna de las fichas que se mueve es una ficha especial, pero no va a comprobar que forme asociación con una ficha que explote.
//Los bucles de explosión dan problemas, ya que al no borrarse la ficha especial la va a volver a encontrar y va a generar un bucle infinito.
+!explosion(X,Y,D,P) : P = 0.
		
//Gestion de exlosiones especiales y puntuaciones
+!explosion(X,Y,D,P) : tablero(celda(X,Y,_),ficha(C,T)) & puntosJugada(P)<- 
			-tablero(celda(X,Y,Own),Ficha);//Pimero se elimina la ficha seleccionada, luego las otras fichas afectadas en caso de ser necesario
			+tablero(celda(X,Y,0),e);
			!specialExplosion(X,Y,C,T,D,P);
			-tablero(celda(X,Y,0),e);
			+tablero(celda(X,Y,Own),Ficha).

+!explosion(X,Y,D,P).

+!specialExplosion(X,Y,C,T,D,P) : T = in <-      
    .print("Entro y pongo un +1 a: ", P);  
    -+puntosJugada(P+1). 
	
+!specialExplosion(X,Y,C,T,D,P) : T = ip  & (D="up" | D="down")<-     //Explosion en linea 
			.print("ip up o down");
			
			-+puntosJugada(P+2);
			for( tablero(celda(X,NY,_),ficha(NC,_))){
					.print("Bucle ip");
					!explosion(X,NY,D,P+2);                                                                                                                                                             
				}.
				
+!specialExplosion(X,Y,C,T,D,P) : T = ip  & (D="left" | D="right")<-     //Explosion en linea horizontal
.print("ip left o right");
			-+puntosJugada(P+2);
			for( tablero(celda(NX,Y,_),ficha(NC,_))){
					.print("Bucle ip");
				 	!explosion(NX,Y,D,P+2);
				}.  
			
+!specialExplosion(X,Y,C,T,D,P) : T = gs & tablero(celda(NX,NY,_),ficha(C,_)) & not X=NX & not Y=NY <-	 //Explosion de una ficha del mismo color  
.print("gs");
			-+puntosJugada(P+4);
			!explosion(NX,NY,D,P+4).		                                      
			
+!specialExplosion(X,Y,C,T,D,P) : T = co <-  			//Explosion en cuadrado 3x3 
.print("co");
			-+puntosJugada(P+6);                   
			for ( .range(I,-1,1) ) {
				for ( .range(J,-1,1) ) {
					!coExplosion(X+I,Y+J,D,P+6);	
				};
			}.

+!coExplosion(X,Y,D,P) : tablero(celda(X,Y,_),ficha(C,_)) <-
			  !explosion(X,Y,D,P).
			  
+!specialExplosion(X,Y,C,T,D,P) : T = ct <-     //Explosion de todas las fichas de ese color  
.print("ct");
			-+puntosJugada(P+8);
			for( tablero(celda(NX,NY,_),ficha(C,_))){                                        
				 	!explosion(NX,NY,D,P+8);	
			}.                                                                                                                                                                

+!specialExplosion(X,Y,C,T,D,P) <- .print("ERROR en +specialExplosion()").


		
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



