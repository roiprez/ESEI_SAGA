// Environment code for project player.mas2j

import jason.asSyntax.*;
import jason.environment.Environment;
import jason.environment.grid.GridWorldModel;
import jason.environment.grid.GridWorldView;
import jason.environment.grid.Location;

import java.util.*;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.util.Random;
import java.util.logging.Logger;

public class Tablero extends Environment {

    public static final int GSize = 10; // grid size
    public static final int STEAK  = 16; // steak code in grid model
	public static final int REDSTEAK  = 32; // steak code in grid model
	public static final int GREENSTEAK  = 64; // steak code in grid model
	public static final int BLACKSTEAK  = 128; // steak code in grid model
	public static final int ORANGESTEAK  = 256; // steak code in grid model
	public static final int MAGENTASTEAK  = 512; // steak code in grid model
	

    private Logger logger = Logger.getLogger("Tablero.mas2j."+Tablero.class.getName());

    private TableroModel model;
    private TableroView  view;
    
	String label = "  ";
    /** Called before the MAS execution with the args informed in .mas2j */
    @Override
    public void init(String[] args) {
		//Le pasamos el tamanho del tablero al juez
		addPercept("judge",Literal.parseLiteral("size(" + GSize + ")"));	
		//Creamos el modelo del tablero	
        model = new TableroModel();
		//Creamos la vista, en principio esta parte no debería ser necesario alterarla
        view  = new TableroView(model);
        model.setView(view);
        super.init(args);		
    }

    @Override
    public boolean executeAction(String ag, Structure action) {	
        logger.info(ag + " doing: " + action);
        try {
             if (ag.equals("judge")) {
				 // REVIEW No implementado
				 //Recibe del judge una ficha a colocar en el tablero
				 //La usaremos para las nuevas fichas que se incluyen después de una explosión, o las generadas por esta
				 if (action.getFunctor().equals("put")) {
					 int x = (int)((NumberTerm)action.getTerm(0)).solve();
					 int y = (int)((NumberTerm)action.getTerm(1)).solve();
					 int color = (int)((NumberTerm)action.getTerm(2)).solve();
					 int steak = (int)((NumberTerm)action.getTerm(3)).solve();
					 if (steak == 0) { label = "  ";} else
					 if (steak == 1) { label = "ip";} else
					 if (steak == 2) { label = "ct";} else
					 if (steak == 3) { label = "gs";} else
					 if (steak == 4) { label = "co";} else
					 //TT debe ser un valor indefinido
					 {label = "TT";};
					 model.put(x,y,color,label);
				 //Intercambia los colores c1 y c2 de casilla en el modelo
				 } else if(action.getFunctor().equals("exchange")){
					 int color1 = (int)((NumberTerm)action.getTerm(0)).solve();
					 int x = (int)((NumberTerm)action.getTerm(1)).solve();
					 int nextX = (int)((NumberTerm)action.getTerm(2)).solve();
					 int color2 = (int)((NumberTerm)action.getTerm(3)).solve();
					 int y = (int)((NumberTerm)action.getTerm(4)).solve();
					 int nextY = (int)((NumberTerm)action.getTerm(5)).solve();
					 model.exchange(color1,x,nextX,color2,y,nextY);
				// REVIEW No implementado
				 } else if(action.getFunctor().equals("deleteSteak")){
					 int color = (int)((NumberTerm)action.getTerm(0)).solve();
					 int x = (int)((NumberTerm)action.getTerm(1)).solve();
					 int y = (int)((NumberTerm)action.getTerm(2)).solve();
					 model.deleteSteak(color,x,y);
				// REVIEW No implementado
				 } else if(action.getFunctor().equals("moveSteaks")){
					 model.moveSteaks();
				 }
			} else {
				logger.info("Recibido una peticion ilegal. "+ ag +" no puede realizar la accion: "+ action);
				Literal ilegal = Literal.parseLiteral("accionIlegal(" + ag + ")");
			addPercept("judge",ilegal);}
        } catch (Exception e) {
            e.printStackTrace();
        }
        updatePercepts();

        try {
            Thread.sleep(100);
        } catch (Exception e) {}
        informAgsEnvironmentChanged();
        return true;
    }

	// REVIEW No implementado
    /** creates the agents perception based on the MarsModel */
    void updatePercepts() {
        //Location r1Loc = model.getAgPos(0);
        Literal newMov = Literal.parseLiteral("done");
		addPercept("judge",newMov);    
    }

    class TableroModel extends GridWorldModel {
        
        Random random = new Random(System.currentTimeMillis());
		
		String label = "";

		//Crea el tablero
        private TableroModel() {
            super(GSize, GSize, 3);
			//String label = label;
            // initial location of agents
            try {
                setAgPos(0, 0, 0);
            } catch (Exception e) {
                e.printStackTrace();
            }
			//set(4,GSize/2,GSize/2);
			int color = 16;
			for(int i = 0; i < GSize; i++){
				for(int j = 0; j < GSize; j++){
					add(color,i,j);
					int judgeColor = getJudgeColor(color);
					//Le pasa al juez la información del tablero				
					addPercept("judge",Literal.parseLiteral("addTablero(celda(" + i + "," + j + ",0),ficha(" + judgeColor + ",in))"));
					//Itera sobre los colores de las fichas para asignar los colores secuencialmente
					if (color < 512) {color = color * 2;}
					else {color = 16;};
				};
				if (color < 512) {color = color * 2;}
				else {color = 16;};
			};
			//Esto ordena al juez empezar con el juego
			addPercept("judge",Literal.parseLiteral("startGame"));
        }

		//Esta funcion nos devuelve el codigo de color que lleva el juez a partir del que tiene el modelo
		public int getJudgeColor(int color){
			switch(color){
				case 16: return 0;
				case 32: return 1;
				case 64: return 2;
				case 128: return 3;
				case 256: return 4;
				case 512: return 5;
			}
			return 0;
		}

		//Esta funcion nos devuelve el codigo de color que lleva el modelo a partir del que tiene el juez
		public int getEnvironmentColor(int color){
			switch(color){
				case 0: return 16;
				case 1: return 32;
				case 2: return 64;
				case 3: return 128;
				case 4: return 256;
				case 5: return 512;
			}
			return 0;
		}

		// REVIEW No implementado
		void put(int x, int y, int c, String steak) throws Exception {
			removePerceptsByUnif("judge",Literal.parseLiteral("cell(Color, pos(" + x + "," + y + "), Type, Own)"));
			if (isFreeOfObstacle(x,y)) {
				set(c,x,y);
				label = steak;
				logger.info(" Percepcion eliminada..................................."+label+"...."+steak);				
				if (steak == "  "){
					addPercept("judge",Literal.parseLiteral("cell(" + c + ", pos(" + x + "," + y + "), in, 0)"));
					logger.info(" Entro por aquiiiiiiiiiii...................");}
				else {	
				addPercept("judge",Literal.parseLiteral("cell(" + c + ", pos(" + x + "," + y + "),"+label+", 0)"));};
				//addPercept("judge",Literal.parseLiteral("steak(" + c + "," + x + "," + y + ")"));
			};
        }
		
		//Intercambia los colores color1 y color2 de casilla en el modelo		
		void exchange(int color1, int x, int nextX, int color2, int y, int nextY) throws Exception {
			int codColor1 = getEnvironmentColor(color1);
			int codColor2 = getEnvironmentColor(color2);

			remove(codColor1,new Location(x,y));
			remove(codColor2,new Location(nextX,nextY));

			set(codColor2,x,y);
			set(codColor1,nextX,nextY);

			/*Aquí en principio sería un buen sitio para comprobar si se ha realizado alguna asociación
			* Lo ideal sería enviar al juez que busque si existe alguna asociación para las dos fichas
			* que se han movido*/

			addPercept("judge",Literal.parseLiteral("patternMatch(" + x + "," + y + ")"));		
			addPercept("judge",Literal.parseLiteral("patternMatch(" + nextX + "," + nextY + ")"));

			//Estas líneas en principio lo que hacen es borrarlo al instante, no da tiempo a ejecutar el plan
			//removePercept("judge",Literal.parseLiteral("patternMatch(" + x + "," + y + ")"));
			//removePercept("judge",Literal.parseLiteral("patternMatch(" + nextX + "," + nextY + ")"));
		}

		
		// REVIEW No comprobado
		void deleteSteak(int color,int x, int y) throws Exception {
			remove(color,new Location(x,y));
			//removePercept("judge",Literal.parseLiteral("steak("+ color +"," + x + "," + y + ")"));
		}
		
		// REVIEW No implementado
		void moveSteaks()throws Exception {
			for(int i = 0; i < GSize; i++){
				for(int j = 0; j < GSize; j++){
					if(	!(hasObject(STEAK,i,j) || hasObject(REDSTEAK,i,j) ||
						hasObject(GREENSTEAK,i,j) || hasObject(BLACKSTEAK,i,j) ||
			        	hasObject(ORANGESTEAK,i,j) || hasObject(MAGENTASTEAK,i,j))){
						for(int k = j - 1; k >= 0;k--){
							int c = 0;
							if(hasObject(STEAK,i,k)){
								c = STEAK;
							}else if(hasObject(REDSTEAK,i,k)){
								c = REDSTEAK;
							}else if(hasObject(GREENSTEAK,i,k)){
								c = GREENSTEAK;
							}else if(hasObject(BLACKSTEAK,i,k)){
								c = BLACKSTEAK;
							}else if(hasObject(ORANGESTEAK,i,k)){
								c = ORANGESTEAK;
							}else if(hasObject(MAGENTASTEAK,i,k)){
								c = MAGENTASTEAK;
							}
							if(c != 0){
								remove(c,new Location(i,k));
								//removePercept("judge",Literal.parseLiteral("steak("+ c +"," + i + "," + k + ")"));
								
								add(c,new Location(i,k + 1));
								//addPercept("judge",Literal.parseLiteral("steak(" + c + "," + i + "," + (k + 1) + ")"));
							}
							
						}	
					}
				} 
			} 
		
		}
        
    }
    
	//En principio esta clase no hace falta tocarla, ya que sólo es representación gráfica, al menos para el funcionamiento no cambia nada
    class TableroView extends GridWorldView {
		
        public TableroView(TableroModel model) {
            super(model, "Tablero", 400);
            defaultFont = new Font("Arial", Font.BOLD, 18); // change default font
            setVisible(true);
			String label = model.label;
			/*
			if (model.label == "CO" | model.label =="PP"){
				logger.info(" la etiqueta que debo dibujar es: "+ label+" o quiza: "+model.label);		
			};			
            *///repaint();
        }

        /** draw application objects */
        @Override
        public void draw(Graphics g, int x, int y, int object) {
			if (label == "CO" | label =="PP"){
				logger.info(" la etiqueta que debo dibujar es: "+ label);		
			};
            switch (object) {
                case Tablero.STEAK: drawSTEAK(g, x, y, Color.blue, label);  break;
				case Tablero.REDSTEAK: drawSTEAK(g, x, y, Color.red, label);  break;
				case Tablero.GREENSTEAK: drawSTEAK(g, x, y, Color.green, label);  break;
				case Tablero.BLACKSTEAK: drawSTEAK(g, x, y, Color.lightGray, label);  break;
				case Tablero.ORANGESTEAK: drawSTEAK(g, x, y, Color.orange, label);  break;
				case Tablero.MAGENTASTEAK: drawSTEAK(g, x, y, Color.magenta, label);  break;
            };
        }

        @Override
        public void drawAgent(Graphics g, int x, int y, Color c, int id) {
            //String label = "R"+(id+1);
            c = Color.white;
            //super.drawAgent(g, x, y, c, -1);
			//drawGarb(g, x, y);
		}
		
		public void drawSTEAK(Graphics g, int x, int y, Color c, String label) {
			g.setColor(c);
			g.fillOval(x * cellSizeW + 2, y * cellSizeH + 2, cellSizeW - 4, cellSizeH - 4);
			g.setColor(Color.black);
			drawString(g,x,y,defaultFont,label);
		}

        public void drawGarb(Graphics g, int x, int y) {
            super.drawObstacle(g, x, y);
            g.setColor(Color.blue);
            drawString(g, x, y, defaultFont, "G");
        }

    }    

    /** Called before the end of MAS execution */
    @Override
    public void stop() {
        super.stop();
    }
}


