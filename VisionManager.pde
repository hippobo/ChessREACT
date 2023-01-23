

class VisionManager{
  
TuioProcessing tuioClient;
//images of pieces
PImage wKing, bKing, wQueen, bQueen, wPawn, bPawn, wRook, bRook, wKnight, bKnight, wBishop, bBishop;
//matrix of square names for display
String [][] chessGridGame = {{"A8","B8","C8","D8","E8","F8","G8","H8"},
{"A7","B7","C7","D7","E7","F7","G7","H7"},
{"A6","B6","C6","D6","E6","F6","G6","H6"},
{"A5","B5","C5","D5","E5","F5","G5","H5"},
{"A4","B4","C4","D4","E4","F4","G4","H4"},
{"A3","B3","C3","D3","E3","E3","G3","H3"},
{"A2","B2","C2","D2","E2","F2","G2","H2"},
{"A1","B1","C1","D1","E1","F1","G1","H1"},
};

//matrix of images of pieces
PImage[][] board;
//assign to each markerID a chess Piece
HashMap<Integer,PImage> idDictionary = new HashMap<Integer, PImage>();
//matrix of markerIDs corresponding to chess pieces
int [][] chessGridGameState = new int [8][8];





VisionManager(TuioProcessing tuioClient){
  this.tuioClient = tuioClient;
  
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
  
  
  
 idDictionary.put(0, wKing);
 idDictionary.put(1, bKing);
 idDictionary.put(2, wQueen);
 idDictionary.put(3, bQueen);
 idDictionary.put(4, wPawn);
 idDictionary.put(5, bPawn);
 idDictionary.put(6, wRook);
 idDictionary.put(7, bRook);
 idDictionary.put(8, wKnight);
 idDictionary.put(9, bKnight);
 idDictionary.put(10,wBishop);
 idDictionary.put(11, bBishop);

  
  
}



void update(){
  ClearGameState();
       showBoard();

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
     //floor(tobj.getX()/0.125 normalizes each getX/getY value that are from 0 to 1, to 0 to 7 (for each square)
     //if marker inside board, put marker id (chessState) in square
     
     if(floor(tobj.getX()/0.125) < 8 && floor(tobj.getY()/0.125) < 8 && floor(tobj.getX()/0.125) > -1 && floor(tobj.getY()/0.125) > -1){
     chessGridGameState[floor(tobj.getY()/0.125)][floor(tobj.getX()/0.125)] = tobj.getSymbolID();
     }

   
      if(tobj.getMotionSpeed() > 0.2){
     
        s.restart();
        
      }
     if(tobj.getMotionSpeed() == 0 && s.time() > 999 && floor(tobj.getX()/0.125) < 8 && floor(tobj.getY()/0.125) < 8 && floor(tobj.getX()/0.125) > -1 && floor(tobj.getY()/0.125) > -1){
        chessGridGameState[floor(tobj.getY()/0.125)][floor(tobj.getX()/0.125)] = tobj.getSymbolID();
        s.restart(); 
        s.pause();
     }
       
     var angleS = map(s.time(),0,1000,0,PI*2);
     fill(255,255,255);
     push();
     translate(60,60);
     arc(floor(tobj.getX()/0.125) * 120, floor(tobj.getY()/0.125)*120, 50, 50, 0, angleS,PIE);
     pop();
      
    
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

void refreshDisplay(){
    
 for(int i = 0; i < 8; i++){
 for(int j = 0; j < 8; j++){
   //assign markerID to image from idDictionary
   board[i][j] = idDictionary.get(chessGridGameState[i][j]);
   chessGridGameState[i][j] = 100;
  
  
}
 }
}

void showBoard() {
  for (int i = 0; i<8; i++)
    for (int j = 0; j<8; j++) { 
      if ((i+j)%2 == 0){
        //color in squares
        fill(255, 206, 158);
      }
      else{ fill(209, 139, 71);
      }
      
      rect(i*width/8, j*height/8, width/8, height/8);//chessboard
      //display image
      if (board[j][i] != null) image(board[j][i], i*width/8, j*height/8);//piece
    
        }
        
        

      }
      
void ClearGameState(){
  
  for(int i = 0; i < 8; i++){
 for(int j = 0; j < 8; j++){
   //100 = empty value of chessBoard -> no piece on square
   chessGridGameState[i][j] = 100;
   
 }
  
}

 }
  

}
