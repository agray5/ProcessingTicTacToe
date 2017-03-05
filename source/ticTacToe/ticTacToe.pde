/* If bigger/varible grid size is used player turn will need to be updated */

import java.util.Arrays;

PFont f;
final char compMarker = 'O';
final char playerMarker = 'X';
char markers[] = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '};
ArrayList<Integer> emptySpaces = new ArrayList<Integer>(); // will hold the possible spaces for the computer to choose
int turn; // 0 for computer, 1 for player
boolean nextTurn; //only redraw when it is the next turn
boolean gameOver;
int winner; // 0 for comp, 1 for player, -1 for tie
int c = 0;

void setup(){
  size(640, 740);
  f = createFont("Candara", 24);
  textFont(f);
  textAlign(CENTER, CENTER);
  gameOver = false;
  
  //initlize emptySpaces
  for(int i = 0; i < markers.length; i++){
     emptySpaces.add(i); // all positions in grid start as empty
  }
  
  //who goes first?
  float coinFlip = random(2); // will be 0 or 1
  turn = (int)coinFlip;
  
  //Game begins
  nextTurn = true;
}

void draw(){
  if(nextTurn == true){
    c++;
     drawGrid();
     println("draw grid 1, c:" + c);
       if(gameOver){
         
         nextTurn =  false;
         timer();
         
        println("win");
         
         winScreen();
     }
   } 
   

    if(!gameOver){
       nextTurn = false;
       if(turn == 0){
         
         compTurn();
      }
    }
  }




 void mousePressed(){
   if (turn == 1 && nextTurn == false && !gameOver){ // It is the players turn
     float x = mouseX;
     float y = mouseY;
     int block; // can be between 0-8
     
     int h = height - 100; //as if the board where 640 x640
     
     //assume 3 X 3 array
     //Choose grid block based on x and y of players click
     if(x < width/3){
       if(y < h/3 + 100)
         block = 0;
       else if(y < 2*h/3 + 100)
         block = 3;
       else
         block = 6;
     }
     else if(x < 2*width/3){
       if(y < h/3+ 100)
         block = 1;
       else if(y < 2*h/3 + 100)
         block = 4;
       else
         block = 7;
     }
     else{
       if(y < h/3 + 100)
         block = 2;
       else if(y < 2*h/3 + 100)
         block = 5;
       else
         block = 8;
     }
     
     //if the space is empty on the grid it is the next turn
     if(emptySpaces.contains(block)){
       placeMarker(block);
     }
       println("Player Turn");
   } 
   
 }
 
 void compTurn(){
  // timer(); //pause befor comp turn 
   
   //choose a random number based on empty spaces
   float choice = random((float)emptySpaces.size());
   
   placeMarker(emptySpaces.get((int)choice)); // pick choice from empty spaces list
   
   println("CompTun");
 }
 
 void placeMarker(int choice){
   char mark;
   int nextPlayer;
   
   //choose marker and choose next player
   if(turn == 0){
     mark = compMarker;
     nextPlayer = 1;
   }
   else{
     mark = playerMarker;
     nextPlayer = 0;
   }
   
   markers[choice] = mark; //place the marker into the array of markers
   emptySpaces.remove(Integer.valueOf(choice)); //space is no longer empty
   
   if(checkForWin())
     gameOver = true;

     turn = nextPlayer;
     nextTurn = true;
 }
 
 
boolean checkForWin(){
  char mark;
  if(turn == 0){
    mark = compMarker;
  }
  else{
    mark = playerMarker;
  }
  
  //Check Board for win
  if(emptySpaces.size() == 0){
    winner = -1;
    return true;
  }
  else{
    //check for diagonal win
     if (markers[0] == mark && markers[4] == mark && markers[8] == mark || markers[2] == mark && markers[4] == mark && markers[6] == mark){ 
       winner = turn; 
       return true; 
     }
     //check for horizontal or vertical win
     else{
       for(int i = 0; i < 3; i++){
         int j = i * 3; // to get the row number
         if(markers[j] == mark && markers[j+1] == mark && markers[j+2] == mark
            || markers[i] == mark && markers[i+3] == mark && markers[i+6] == mark){
            winner = turn; 
            return true;
            }
       }

    }
  }
    
  return false;
}

void drawGrid(){
  String turnText;
  
  if(turn == 1)
    timer();
  
   background(50);
   stroke(255);
   
   switch(turn){
   case 0: turnText = "Computer"; break;
   case 1: turnText = "Player"; break;
   default: turnText = "Error";
   }
    
    text("Turn: "+ turnText, 100, 50);
    
    int t = height - 100;
    //draw grid
   line(width/3, 100, width/3, height);
   line(2*width/3, 100, 2*width/3, height);
   line(0, t/3 + 100, width, t/3 + 100);
   line(0, 2*t/3 + 100, width, 2*t/3 + 100);
   
   //fill in grid
   int h, w;
   int counter = 0;
   int multw = 1; // to set proper width 
   int multh = 1; // to set proper height;
   for(int i = 0; i < markers.length / 3; i++){
     h = ((height - 100)/6 * multh) + 100;
     multw = 1; // reset multw for next row, so that it starts at the begining of row
     for(int j = 0; j < 3; j++){
       w = width/6 * multw;
        text(markers[counter], w, h);
        counter++;
        multw += 2;
        
     }
     multh += 2;
   }
}


void winScreen(){
  println("Win Screen");
  
  String winText;
  fill(30,144,255);
   //background(0);
   
   switch(winner){
   case 0: winText = "Sorry the computer wins this round! :("; break;
   case 1: winText = "Congrats!! You Win!! :D"; break;
   case -1: winText = "Looks like a tie..."; break;
   default: winText = "This is an error message. It should not be this"; 
   }
   text(winText, width/2, height/2);
}

void timer(){
  float startTime = millis();
  while(millis() - startTime < 1000){};
}