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

  //Steak codes in grid model
  public static final int BLUESTEAK  = 16;
  public static final int REDSTEAK  = 32;
  public static final int GREENSTEAK  = 64;
  public static final int GRAYSTEAK  = 128;
  public static final int ORANGESTEAK  = 256;
  public static final int MAGENTASTEAK  = 512;

  private Logger logger = Logger.getLogger("Tablero.mas2j."+Tablero.class.getName());

  private TableroModel model;
  private TableroView  view;

  String [][] steakType = new String[GSize][GSize];

  @Override
  public void init(String[] args) {
    addPercept("judge",Literal.parseLiteral("size(" + GSize + ")"));
    model = new TableroModel();
    view  = new TableroView(model);
    model.setView(view);
    super.init(args);
  }

  @Override
  public void stop() {
    super.stop();
  }

  @Override
  public boolean executeAction(String agent, Structure message) {
    logger.info(agent + " doing: " + message); // --- TODO ---
    try {
      if (agent.equals("judge")) { //Recepcion de un mensaje procedente del juez
        String action= message.getFunctor();

        switch(action){
          case("exchange"):
          int c1 = (int)((NumberTerm)message.getTerm(0)).solve();
          int x1 = (int)((NumberTerm)message.getTerm(1)).solve();
          int y1 = (int)((NumberTerm)message.getTerm(2)).solve();
          int c2 = (int)((NumberTerm)message.getTerm(3)).solve();
          int x2 = (int)((NumberTerm)message.getTerm(4)).solve();
          int y2 = (int)((NumberTerm)message.getTerm(5)).solve();
          model.exchange(c1,x1,y1,c2,x2,y2);
          view.repaint(); //view.update(); //--- TODO --- update() vs repaint()
          break;
          case("delete"):
          int c = (int)((NumberTerm)message.getTerm(0)).solve();
          int x = (int)((NumberTerm)message.getTerm(1)).solve();
          int y = (int)((NumberTerm)message.getTerm(2)).solve();
          model.delete(c,x,y);
          view.repaint(); //view.update();
          break;
          case("put"):
          c = (int)((NumberTerm)message.getTerm(0)).solve();
          x = (int)((NumberTerm)message.getTerm(1)).solve();
          y = (int)((NumberTerm)message.getTerm(2)).solve();
          String t = message.getTerm(3).toString();
          model.put(c,x,y,t);
          view.repaint(); //view.update();
          break;
        }
      } else { //Recepcion de un mensaje de otro agente que no sea el juez
        logger.info("Se ha recibido una peticion ilegal. "+ agent +" no puede realizar la accion: "+ message);
        Literal ilegal = Literal.parseLiteral("accionIlegal(" + agent + ")"); // --- TODO ---
        addPercept("judge",ilegal);}
      } catch (Exception e) {
        e.printStackTrace();
      }
      return true;
    }



    class TableroModel extends GridWorldModel {

      Random random = new Random(System.currentTimeMillis());

      private TableroModel() {
        super(GSize, GSize, 3);
        int color = 16;
        for(int i = 0; i < GSize; i++){
          for(int j = 0; j < GSize; j++){
            steakType[i][j]="in";
            add(color,i,j); //Se anhade la ficha generada al tablero
            int judgeColor = getJudgeColor(color);
            addPercept("judge",Literal.parseLiteral("addTablero(celda(" + i + "," + j + ",0),ficha(" + judgeColor + ",in))"));//Le pasa al juez la información del tablero // --- TODO --- Generar tipo de ficha aleatorio
            if (color < 512) {color = color * 2;}//Itera sobre los colores de las fichas para asignar los colores secuencialmente
            else {color = 16;};
          };
          if (color < 512) {color = color * 2;}
          else {color = 16;};
        };
        addPercept("judge",Literal.parseLiteral("startGame")); // --- TODO --- Desplazar al juez??
      }

      void exchange(int c1, int x1, int y1, int c2, int x2, int y2) throws Exception { // --- TODO ---
        String aux = steakType[x1][y1];
        steakType[x1][y1] = steakType[x2][y2];
        steakType[x2][y2] = aux;
        int codColor1 = getEnvironmentColor(c1);
        int codColor2 = getEnvironmentColor(c2);
        set(codColor2,x1,y1);
        set(codColor1,x2,y2);
      }

      void delete(int color,int x, int y) throws Exception { // --- TODO ---
        steakType[x][y]="";
        int codColor = getEnvironmentColor(color);
        remove(codColor,x,y);
      }

      void put(int c, int x, int y,String t) throws Exception {
        steakType[x][y]=t;
				add(getEnvironmentColor(c),x,y); //Se anhade la ficha generada al tablero
      }

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

    public int getRandomColor(){ // --- TODO ---
        Random rand = new Random();
        int color = rand.nextInt(6);
        return color;
    }

    public boolean isEmpty(int i, int j){ //HERRAMIENTA
      return isFree(BLUESTEAK,i,j) && isFree(REDSTEAK,i,j) && isFree(GREENSTEAK,i,j) && isFree(GRAYSTEAK,i,j) && isFree(ORANGESTEAK,i,j) && isFree(MAGENTASTEAK,i,j);
    }

    public int getColour(int i, int j){ //HERRAMIENTA
      if(!isFree(BLUESTEAK,i,j)){
        return BLUESTEAK;
      }
      if(!isFree(REDSTEAK,i,j)){
        return REDSTEAK;
      }
      if(!isFree(GREENSTEAK,i,j)){
        return GREENSTEAK;
      }
      if(!isFree(GRAYSTEAK,i,j)){
        return GRAYSTEAK;
      }
      if(!isFree(ORANGESTEAK,i,j)){
        return ORANGESTEAK;
      }
      if(!isFree(MAGENTASTEAK,j)){
        return MAGENTASTEAK;
      }
      return 0; //Empty
    }
  } //End of Class [Tablero Model]



    class TableroView extends GridWorldView {

      public TableroView(TableroModel model) {
        super(model, "Tablero", 400);
        defaultFont = new Font("Arial", Font.BOLD, 12);
        setVisible(true);
        repaint();
      }

      @Override
      public void draw(Graphics g, int x, int y, int object) {
        if(steakType[x][y].equals("in")){
          switch (object) {
            case Tablero.BLUESTEAK: drawSteak(g, x, y, Color.blue);  break;
            case Tablero.REDSTEAK: drawSteak(g, x, y, Color.red);  break;
            case Tablero.GREENSTEAK: drawSteak(g, x, y, Color.green);  break;
            case Tablero.GRAYSTEAK: drawSteak(g, x, y, Color.gray);  break;
            case Tablero.ORANGESTEAK: drawSteak(g, x, y, Color.orange);  break;
            case Tablero.MAGENTASTEAK: drawSteak(g, x, y, Color.magenta);  break;
          }
        }
        else{
          switch (object) {
            case Tablero.BLUESTEAK: drawSpecialSteak(g, x, y, Color.blue);  break;
            case Tablero.REDSTEAK: drawSpecialSteak(g, x, y, Color.red);  break;
            case Tablero.GREENSTEAK: drawSpecialSteak(g, x, y, Color.green);  break;
            case Tablero.GRAYSTEAK: drawSpecialSteak(g, x, y, Color.gray);  break;
            case Tablero.ORANGESTEAK: drawSpecialSteak(g, x, y, Color.orange);  break;
            case Tablero.MAGENTASTEAK: drawSpecialSteak(g, x, y, Color.magenta);  break;
          }
        }
      }

      public void drawSteak(Graphics g, int x, int y, Color c) {
        g.setColor(c);
        g.fillOval(x * cellSizeW + 2, y * cellSizeH + 2, cellSizeW - 4, cellSizeH - 4);
      }

      public void drawSpecialSteak(Graphics g, int x, int y, Color c) {
        g.setColor(c);
        g.fillOval(x * cellSizeW + 2, y * cellSizeH + 2, cellSizeW - 4, cellSizeH - 4);
        g.setColor(Color.lightGray);
        g.fillOval(x * cellSizeW + 10, y * cellSizeH + 10, cellSizeW - 20, cellSizeH - 20);
        g.setColor(Color.black);
        drawString(g,x,y,defaultFont,steakType[x][y]); // --- TODO ---
      }
    } //End of Class [Tablero View]

  } // End of Class [Tablero Environment]
