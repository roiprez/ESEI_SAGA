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

  public static final int OBSTACLE  = 1024;


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
    //logger.info(agent + " doing: " + message); // --- TODO ---
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
          //view.repaint(); //view.update(); //--- TODO --- update() vs repaint()
          break;
          case("delete"):
          int c = (int)((NumberTerm)message.getTerm(0)).solve();
          int x = (int)((NumberTerm)message.getTerm(1)).solve();
          int y = (int)((NumberTerm)message.getTerm(2)).solve();
          model.delete(c,x,y);
          //view.repaint(); //view.update();
          break;
          case("put"):
          c = (int)((NumberTerm)message.getTerm(0)).solve();
          x = (int)((NumberTerm)message.getTerm(1)).solve();
          y = (int)((NumberTerm)message.getTerm(2)).solve();
          String t = message.getTerm(3).toString();
          model.put(c,x,y,t);
          //view.repaint(); //view.update();
          break;
          case("resetTablero"):
          model.reset();
          //view.repaint(); //view.update();
          break;
          case("putObstacle"):
          x = (int)((NumberTerm)message.getTerm(0)).solve();
          y = (int)((NumberTerm)message.getTerm(1)).solve();
          model.putObstacle(x,y);
          break;
        }
      } else { //Recepcion de un mensaje de otro agente que no sea el juez
        logger.info("Se ha recibido una peticion ilegal. "+ agent +" no puede realizar la accion: "+ message);
        Literal ilegal = Literal.parseLiteral("accionIlegal(" + agent + ")");
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
        reset();
        addPercept("judge",Literal.parseLiteral("startGame"));
      }

      void reset(){ //Generacion del tablero de juego y envio al juez
        removePerceptsByUnif("judge",Literal.parseLiteral("addTablero(X,Y)"));
        int color = 16;
        for(int i = 0; i < GSize; i++){
          for(int j = 0; j < GSize; j++){
            steakType[i][j]="in";
            set(color,i,j);
            int judgeColor = getJudgeColor(color);
            addPercept("judge",Literal.parseLiteral("addTablero(celda(" + i + "," + j + ",0),ficha(" + judgeColor + ",in))"));
            if (color < 512) {color = color * 2;}
            else {color = 16;};
          };
          if (color < 512) {color = color * 2;}
          else {color = 16;};
        };
      }

      void exchange(int c1, int x1, int y1, int c2, int x2, int y2) throws Exception {
        String aux = steakType[x1][y1];
        steakType[x1][y1] = steakType[x2][y2];
        steakType[x2][y2] = aux;
        int codColor1 = getEnvironmentColor(c1);
        int codColor2 = getEnvironmentColor(c2);
        set(codColor2,x1,y1);
        set(codColor1,x2,y2);
      }

      void delete(int color,int x, int y) throws Exception {
        steakType[x][y]="";
        int codColor = getEnvironmentColor(color);
        remove(codColor,x,y);
      }

      void put(int c, int x, int y,String t) throws Exception {
        steakType[x][y]=t;
				set(getEnvironmentColor(c),x,y);
      }

      void putObstacle(int x, int y){
        steakType[x][y]="obstacle";
        set(OBSTACLE,x,y);
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
            case Tablero.OBSTACLE: drawObstacle(g,x,y); break;
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
        drawString(g,x,y,defaultFont,steakType[x][y].toUpperCase());
      }

      public void drawObstacle(Graphics g, int x, int y){
        g.setColor(Color.darkGray);
        g.fillRoundRect(x*cellSizeW,y*cellSizeH,cellSizeW,cellSizeH,15,15);
        g.setColor(Color.black);
        //drawString(g,x,y,new Font("Arial", Font.BOLD, 50),"*"); //Descomentar si se desea relleno de los obstáculos
      }
    } //End of Class [Tablero View]

  } // End of Class [Tablero Environment]

