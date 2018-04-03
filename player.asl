// Agent player in project ESEI_SAGA.mas2j

/*
* Su objetivo es alcanzar la mayor puntiaci�n posible en cada movimiento
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
comprobarPatrones(Color,X,Y,Puntos) :-
	(pattern5inLineW(Color,X,Y) & Puntos=1000) |
	(pattern5inLineH(Color,X,Y) & Puntos=1050) |
	(patternT(Color,X,Y) & Puntos=800) |
	(patternSquare(Color,X,Y) & Puntos=600)|
	(pattern4inLineW(Color,X,Y) & Puntos=400)|
	(pattern4inLineH(Color,X,Y) & Puntos=450) |
	(pattern3inLineW(Color,X,Y) & Puntos=200) |
	(pattern3inLineH(Color,X,Y) & Puntos=250) | 
	(Puntos=0).

	
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
	tablero(celda(X,Y+2,_),ficha(Color,_))) |
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y-2,_),ficha(Color,_))) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	tablero(celda(X+2,Y,_),ficha(Color,_))) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & 
	tablero(celda(X,Y+1,_),ficha(Color,_)) & 
	tablero(celda(X-1,Y,_),ficha(Color,_)) & 
	tablero(celda(X-2,Y,_),ficha(Color,_))).

	
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
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & tablero(celda(X+2,Y,_),ficha(Color,_)) &
	.print(tablero(celda(X,Y,_),ficha(Color,_))) &
	.print(tablero(celda(X+1,Y,_),ficha(Color,_))) &
	.print(tablero(celda(X+2,Y,_),ficha(Color,_)))
	) | 
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & tablero(celda(X-2,Y,_),ficha(Color,_)) & 
	.print("Empezamos el 3 en l�nea2: ",Color,", ",X,", ",Y)) | 
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & tablero(celda(X+1,Y,_),ficha(Color,_)) & 
	.print("Empezamos el 3 en l�nea3: ",Color,", ",X,", ",Y)).

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
					+pensarJugada;
					-pensarJugada;
					 			 
					?cordX(X);
					?cordY(Y);
					?dirMax(Dir);
					.print("Quiero mover desde posicion (",X,",",Y,") en direccion ",Dir);
					.send(judge,tell,moverDesdeEnDireccion(pos(X,Y),Dir));
					.send(judge,untell,moverDesdeEnDireccion(pos(X,Y),Dir)).

+pensarJugada : size(N)  <- 
	-+puntosMax(0);
	-+puntos(0);
	-+direction("none");
	for ( .range(V,0,(N-1)) ) {                                                                                              
		for ( .range(W,0,(N-1)) ) {
			+comprobarDireccion(V,W);
			-comprobarDireccion(V,W);
			
			?puntos(Puntos);
			?direction(Dir);
			?puntosMax(PuntosMax);
			if(Puntos > PuntosMax){
				-+cordX(V);                          
				-+cordY(W);            
				-+puntosMax(Puntos);
				-+dirMax(Dir);
			}
		}
	}                                     
	?puntosMax(PuntosMax);
	if(PuntosMax == 0){
		?pensarJugadaAleatoria(X1,Y1,Dir1);
		-+cordX(X1);
		-+cordY(Y1);
		-+dirMax(Dir1);
	}.
	
//Problema al reasignar una variable
+comprobarDireccion(X,Y) <-
	
	//Caso "up"
	if(Y>0){
		-+puntosUp(0);
		+comprobarUp(X,Y);
		-comprobarUp(X,Y);
		
		
		?puntosUp(PuntosUp);
		?puntos(Puntos1);
		if(PuntosUp > Puntos1){
			.print("Coordenadas: ",X,", ",Y," hacia up");
			.print(PuntosUp);
			.print(Puntos1);
			-+puntos(PuntosUp);
			-+direction("up");
		};
	}

	
	
	//Caso "down"
	if(Y<9){
		-+puntosDown(0);
		+comprobarDown(X,Y);
		-comprobarDown(X,Y);
		
		
		?puntosDown(PuntosDown);
		?puntos(Puntos2);
		if(PuntosDown > Puntos2){
			.print("Coordenadas: ",X,", ",Y," hacia down");
			.print(PuntosDown);
			.print(Puntos2);
			-+puntos(PuntosDown);
			-+direction("down");
		};                            
	}
	                      
	
	//Caso "right"
	if(X<9){
		-+puntosRight(0);
		+comprobarRight(X,Y);
		-comprobarRight(X,Y);
		
			
		?puntosRight(PuntosRight);
		?puntos(Puntos3);
		if(PuntosRight > Puntos3){
			.print("Coordenadas: ",X,", ",Y," hacia right");
			.print(PuntosRight);
			.print(Puntos3);
			-+puntos(PuntosRight);
			-+direction("right");
		};
	}                                 
	
	//Caso "left"
	if(X>0){
		-+puntosLeft(0);
		+comprobarLeft(X,Y);
		-comprobarLeft(X,Y);
		

		?puntosLeft(PuntosLeft);
		?puntos(Puntos4);
		if(PuntosLeft > Puntos4){
			.print("Coordenadas: ",X,", ",Y," hacia left");
			.print(PuntosLeft);
			.print(Puntos4);
			-+puntos(PuntosLeft);
			-+direction("left");
		}
	}.
	
+comprobarUp(X,Y): tablero(celda(X,Y-1,_),ficha(ColorUp,TipoUp)) & tablero(celda(X,Y,_),ficha(Color,Tipo)) <-

		-tablero(celda(X,Y-1,_),ficha(ColorUp,TipoUp));
		-tablero(celda(X,Y,_),ficha(Color,Tipo));
		+tablero(celda(X,Y-1,0),ficha(Color,Tipo));
		+tablero(celda(X,Y,0),ficha(ColorUp,TipoUp));
		
		?comprobarPatrones(ColorUp,X,Y,PuntosUp1);
		?comprobarPatrones(Color,X,Y-1,PuntosUp2);
		
		PuntosUp = PuntosUp1 + PuntosUp2;
		-+puntosUp(PuntosUp);
		
		-tablero(celda(X,Y-1,_),ficha(Color,Tipo));
		-tablero(celda(X,Y,_),ficha(ColorUp,TipoUp));
		+tablero(celda(X,Y-1,0),ficha(ColorUp,TipoUp));
		+tablero(celda(X,Y,0),ficha(Color,Tipo)).
	
+comprobarDown(X,Y) : tablero(celda(X,Y+1,_),ficha(ColorDown,TipoDown)) & tablero(celda(X,Y,_),ficha(Color,Tipo))<-		

		-tablero(celda(X,Y+1,_),ficha(ColorDown,TipoDown));
		-tablero(celda(X,Y,_),ficha(Color,Tipo));
		+tablero(celda(X,Y+1,0),ficha(Color,Tipo));
		+tablero(celda(X,Y,0),ficha(ColorDown,TipoDown));
		
		?comprobarPatrones(ColorDown,X,Y,PuntosDown1);
		?comprobarPatrones(Color,X,Y+1,PuntosDown2);
		
		PuntosDown = PuntosDown1 + PuntosDown2;
		-+puntosDown(PuntosDown);
		
		-tablero(celda(X,Y+1,_),ficha(Color,Tipo));
		-tablero(celda(X,Y,_),ficha(ColorDown,TipoDown));
		+tablero(celda(X,Y+1,0),ficha(ColorDown,TipoDown));
		+tablero(celda(X,Y,0),ficha(Color,Tipo)).
		
+comprobarRight(X,Y) : tablero(celda(X+1,Y,_),ficha(ColorRight,TipoRight)) & tablero(celda(X,Y,_),ficha(Color,Tipo))<-
		
		-tablero(celda(X+1,Y,_),ficha(ColorRight,TipoRight));
		-tablero(celda(X,Y,_),ficha(Color,Tipo));
		+tablero(celda(X+1,Y,0),ficha(Color,Tipo));
		+tablero(celda(X,Y,0),ficha(ColorRight,TipoRight));
		
		
		?comprobarPatrones(ColorRight,X,Y,PuntosRight1);	
		?comprobarPatrones(Color,X+1,Y,PuntosRight2);
		
		
		
		PuntosRight = PuntosRight1 + PuntosRight2;
		-+puntosRight(PuntosRight);
		
		-tablero(celda(X+1,Y,_),ficha(Color,Tipo));
		-tablero(celda(X,Y,_),ficha(ColorRight,TipoRight));
		+tablero(celda(X+1,Y,0),ficha(ColorRight,TipoRight));
		+tablero(celda(X,Y,0),ficha(Color,Tipo)).

+comprobarLeft(X,Y) : tablero(celda(X-1,Y,_),ficha(ColorLeft,TipoLeft)) & tablero(celda(X,Y,_),ficha(Color,Tipo))<-
		
		-tablero(celda(X-1,Y,_),ficha(ColorLeft,TipoLeft));
		-tablero(celda(X,Y,_),ficha(Color,Tipo));
		+tablero(celda(X-1,Y,0),ficha(Color,Tipo));
		+tablero(celda(X,Y,0),ficha(ColorLeft,TipoLeft));
		
		?comprobarPatrones(ColorLeft,X,Y,PuntosLeft1);
		?comprobarPatrones(Color,X-1,Y,PuntosLeft2);
		
		PuntosLeft = PuntosLeft1 + PuntosLeft2;
		-+puntosLeft(PuntosLeft);
		
		-tablero(celda(X-1,Y,_),ficha(Color,Tipo));  
		-tablero(celda(X,Y,_),ficha(ColorLeft,TipoLeft));
		+tablero(celda(X-1,Y,0),ficha(ColorLeft,TipoLeft));
		+tablero(celda(X,Y,0),ficha(Color,Tipo)).
		
//Borrado de todas las creencias sobre el tablero para poder hacer una actualizacion limpia /* CODIGO NUEVO */ 
+deleteTableroBB [source(judge)]<-
				for ( tablero(X,Y) ) {
					-tablero(X,Y); 
					}.  
                                                                
//Recepcion de la informacion de una posicion del tablero     /* CODIGO NUEVO */
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



