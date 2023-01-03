class chessboard{
  color beige, brown;
  chessboard(){
  beige = color(242,237,188);
  brown = color(144,119,77);
  }
  
  void display(){
   loadPixels();
   for(int x = 0; x < 8; x++){
     for(int y = 0; y <8; y++){
       if((y + x) %2 == 0){
       for(int i = x*scale; i < x*scale + scale; i++){
         for(int j = y*scale; j < y*scale + scale; j++){
           pixels[width * j + i ] = beige;
         }
       }
     }
     else{
       for(int i = x*scale; i < x*scale + scale; i++){
           for(int j = y*scale; j < y*scale + scale; j++){
             pixels[width*j + i] = brown;
           }
       }
     }
   }
  }
  updatePixels();

  }

}

  
