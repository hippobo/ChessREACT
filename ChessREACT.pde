// import the TUIO library
import TUIO.*;
import java.util.*;
// declare a TuioProcessing client
TuioProcessing tuioClient;
PImage wKing, bKing, wQueen, bQueen, wPawn, bPawn, wRook, bRook, wKnight, bKnight, wBishop, bBishop;
// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 720;
float scale_factor = 1;
PFont font;
String [][] chessGridGame = {{"A8","B8","C8","D8","E8","F8","G8","H8"},
{"A7","B7","C7","D7","E7","F7","G7","H7"},
{"A6","B6","C6","D6","E6","F6","G6","H6"},
{"A5","B5","C5","D5","E5","F5","G5","H5"},
{"A4","B4","C4","D4","E4","F4","G4","H4"},
{"A3","B3","C3","D3","E3","E3","G3","H3"},
{"A2","B2","C2","D2","E2","F2","G2","H2"},
{"A1","B1","C1","D1","E1","F1","G1","H1"},
};
PImage[][] board;
//chessboard chessboardGraphics = new chessboard();
HashMap<Integer,PImage> idDictionary = new HashMap<Integer, PImage>();


int [][] chessGridGameState = new int [8][8];


boolean verbose = true; // print console debug messages
boolean callback = true; // updates only after callbacks

int scale= 120;
 //<>//
void setup()
{
 ClearGameState();

  board = new PImage[8][8];


  wKing = loadImage("KingW.png");
  bKing = loadImage("KingB.png");
  wQueen = loadImage("QueenW.png");
  bQueen = loadImage("QueenB.png");
  wPawn = loadImage("PawnW.png");
  bPawn = loadImage("PawnB.png");
  wRook = loadImage("RookW.png");
  bRook = loadImage("RookB.png");
  wKnight = loadImage("KnightW.png");
  bKnight = loadImage("KnightB.png");
  wBishop = loadImage("BishopW.png");
  bBishop = loadImage("BishopB.png");
  wKing.resize(width/8, height/8);
  bKing.resize(width/8, height/8);
  wQueen.resize(width/8, height/8);
  bQueen.resize(width/8, height/8);
  wPawn.resize(width/8, height/8);
  bPawn.resize(width/8, height/8);
  wRook.resize(width/8, height/8);  
  bRook.resize(width/8, height/8); 
  wKnight.resize(width/8, height/8);
  bKnight.resize(width/8, height/8);
  wBishop.resize(width/8, height/8);  
  bBishop.resize(width/8, height/8);
  
 idDictionary.put(0, wKing );
 idDictionary.put(1, bKing );
 idDictionary.put(2, wQueen );
 idDictionary.put(3, bQueen );
 idDictionary.put(4, wPawn );
 idDictionary.put(5, bPawn );
 idDictionary.put(6, wRook );
 idDictionary.put(7, bRook );
 idDictionary.put(8, wKnight );
 idDictionary.put(9, bKnight );
 idDictionary.put(10,wBishop );
 idDictionary.put(11, bBishop );

  
  //startPosition();
  // GUI setup
  noCursor();
  //size(displayWidth,displayHeight);
  size(960,960);

  noStroke();
  fill(0);
  
  // periodic updates
  if (!callback) {
    loop();
    frameRate(60); //<>//
  } else noLoop(); // or callback updates 
  
  font = createFont("Arial", 12);
  scale_factor = height/table_size;
  
  // finally we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods in this class (see below)
  tuioClient  = new TuioProcessing(this);
}

// within the draw method we retrieve an ArrayList of type <TuioObject>, <TuioCursor> or <TuioBlob>
// from the TuioProcessing client and then loops over all lists to draw the graphical feedback.
void draw()
{
  
  background(0,0,64);
  
  showBoard();
  textFont(font,12*scale_factor);
  float obj_size = object_size*scale_factor; 
  float cur_size = cursor_size*scale_factor; 
   
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0;i<tuioObjectList.size();i++) {
     TuioObject tobj = tuioObjectList.get(i);
     stroke(64,0,0);
     fill(64,0,0);
     pushMatrix();
     translate(tobj.getScreenX(width),tobj.getScreenY(height));
     rotate(tobj.getAngle());
     rect(-obj_size/2,-obj_size/2,obj_size,obj_size);
     popMatrix();
     fill(255);
     text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));
     chessGridGameState[floor(tobj.getY()/0.125)][floor(tobj.getX()/0.125)] = tobj.getSymbolID();
     
     
   }
   

   
   ArrayList<TuioCursor> tuioCursorList = tuioClient.getTuioCursorList();
   for (int i=0;i<tuioCursorList.size();i++) {
      TuioCursor tcur = tuioCursorList.get(i);
      ArrayList<TuioPoint> pointList = tcur.getPath();
      
      if (pointList.size()>0) {
        stroke(0,0,255);
        TuioPoint start_point = pointList.get(0);
        for (int j=0;j<pointList.size();j++) {
           TuioPoint end_point = pointList.get(j);
           line(start_point.getScreenX(width),start_point.getScreenY(height),end_point.getScreenX(width),end_point.getScreenY(height));
           start_point = end_point;
        }
        
        stroke(64,0,64);
        fill(64,0,64);
        ellipse( tcur.getScreenX(width), tcur.getScreenY(height),cur_size,cur_size);
        fill(0);
        text(""+ tcur.getCursorID(),  tcur.getScreenX(width)-5,  tcur.getScreenY(height)+5);
      }
   }
   
  ArrayList<TuioBlob> tuioBlobList = tuioClient.getTuioBlobList();
  for (int i=0;i<tuioBlobList.size();i++) {
     TuioBlob tblb = tuioBlobList.get(i);
     stroke(64);
     fill(64);
     pushMatrix();
     translate(tblb.getScreenX(width),tblb.getScreenY(height));
     rotate(tblb.getAngle());
     ellipse(0,0, tblb.getScreenWidth(width), tblb.getScreenHeight(height));
     popMatrix();
     fill(255);
     text(""+tblb.getBlobID(), tblb.getScreenX(width), tblb.getScreenY(height));
   }
   
   
refreshDisplay();
}

void showBoard() {
  for (int i = 0; i<8; i++)
    for (int j = 0; j<8; j++) { 
      if ((i+j)%2 == 0) fill(255, 206, 158);
      else fill(209, 139, 71);
      rect(i*width/8, j*height/8, width/8, height/8);//chessboard
      if (board[j][i] != null) image(board[j][i], i*width/8, j*height/8);//piece
    
        }
      }
    


void startPosition() {

  board[0][0] = bRook;
  board[0][1] = bKnight;
  board[0][2] = bBishop;
  board[0][3] = bQueen;
  board[0][4] = bKing;
  board[0][5] = bBishop;
  board[0][6] = bKnight;
  board[0][7] = bRook;
  board[1][0] = bPawn;
  board[1][1] = bPawn;
  board[1][2] = bPawn; 
  board[1][3] = bPawn;
  board[1][4] = bPawn;
  board[1][5] = bPawn;
  board[1][6] = bPawn;
  board[1][7] = bPawn;

  board[7][0] = wRook;
  board[7][1] = wKnight;
  board[7][2] = wBishop;
  board[7][3] = wQueen;
  board[7][4] = wKing;
  board[7][5] = wBishop;
  board[7][6] = wKnight;
  board[7][7] = wRook;
  board[6][0] = wPawn;
  board[6][1] = wPawn;
  board[6][2] = wPawn;
  board[6][3] = wPawn;
  board[6][4] = wPawn;
  board[6][5] = wPawn;
  board[6][6] = wPawn;
  board[6][7] = wPawn;
  
}

void ClearGameState(){
  
  for(int i = 0; i < 8; i++){
 for(int j = 0; j < 8; j++){
   chessGridGameState[i][j] = 100;
   
 }
  
}

 }
 
void refreshDisplay(){
  
 for(int i = 0; i < 8; i++){
 for(int j = 0; j < 8; j++){
   board[i][j] = idDictionary.get(chessGridGameState[i][j]);
   chessGridGameState[i][j] = 100;
   
   
 }
}
  
  
}

// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
  

}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
          +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
          
  if (verbose) println("obj grid pos " + chessGridGame[floor(tobj.getY()/0.125)][floor(tobj.getX()/0.125)]);
 
  

  // if (tobj.getMotionSpeed() < 0.0001){
    //  board[floor(tobj.getY()/0.125)][floor(tobj.getX()/0.125)] = idDictionary.get(tobj.getSymbolID());
   //}
  
  
  
   

}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
   

  
}

// --------------------------------------------------------------
// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
  //redraw();
}



// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
          +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  //redraw();
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called when a blob is added to the scene
void addTuioBlob(TuioBlob tblb) {
  if (verbose) println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());
  //redraw();
}

// called when a blob is moved
void updateTuioBlob (TuioBlob tblb) {
  if (verbose) println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
          +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());
  //redraw()
}

// called when a blob is removed from the scene
void removeTuioBlob(TuioBlob tblb) {
  if (verbose) println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}
