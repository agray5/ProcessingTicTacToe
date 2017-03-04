import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Arrays; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ticTacToe extends PApplet {

/* If bigger/varible grid size is used player turn will need to be updated */



PFont f;
final char compMarker = 'O';
final char playerMarker = 'X';
char markers[] = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '};
ArrayList<Integer> emptySpaces = new ArrayList<Integer>(); // will hold the possible spaces for the computer to choose
int turn; // 0 for computer, 1 for player
boolean nextTurn; //only redraw when it is the next turn
int start; //store curret time for timer
boolean gameOver = false;
int winner; // 0 for comp, 1 for player, -1 for tie

public void setup(){
  
  f = createFont("Candara", 24);
  textFont(f);
  textAlign(CENTER, CENTER);
  start = millis();
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

public void draw(){
  if(nextTurn == true){
    background(50);
    
    stroke(255);
    
    //draw grid
   line(width/3, 0, width/3, height);
   line(2*width/3, 0, 2*width/3, height);
   line(0, height/3, width, height/3);
   line(0, 2*height/3, width, 2*height/3);
   
   //fill in grid
   int h, w;
   int counter = 0;
   int multw = 1; // to set proper width 
   int multh = 1; // to set proper height;
   for(int i = 0; i < markers.length / 3; i++){
     h = height/6 * multh;
     multw = 1; // reset multw for next row, so that it starts at the begining of row
     for(int j = 0; j < 3; j++){
       w = width/6 * multw;
        text(markers[counter], w, h);
        counter++;
        multw += 2;
        
     }
     multh += 2;
   } 
     if(gameOver)
       winScreen();
    else{
       nextTurn = false;
       if(turn == 0){
         compTurn();
       }
    }
  }
}


 public void mousePressed(){
   if (turn == 1 && nextTurn == false && !gameOver){ // It is the players turn
     float x = mouseX;
     float y = mouseY;
     int block; // can be between 0-8
     
     //assume 3 X 3 array
     //Choose grid block based on x and y of players click
     if(x < width/3){
       if(y < height/3)
         block = 0;
       else if(y < 2*height/3)
         block = 3;
       else
         block = 6;
     }
     else if(x < 2*width/3){
       if(y < height/3)
         block = 1;
       else if(y < 2*height/3)
         block = 4;
       else
         block = 7;
     }
     else{
       if(y < height/3)
         block = 2;
       else if(y < 2*height/3)
         block = 5;
       else
         block = 8;
     }
     
     //if the space is empty on the grid it is the next turn
     if(emptySpaces.contains(block)){
       placeMarker(block);
     }
       
   } 
   println("Player Turn");
 }
 
 public void compTurn(){
  // timer(); //pause befor comp turn 
   
   //choose a random number based on empty spaces
   float choice = random((float)emptySpaces.size());
   
   placeMarker(emptySpaces.get((int)choice)); // pick choice from empty spaces list
   
   println("CompTun");
 }
 
 public void placeMarker(int choice){
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
 
public boolean checkForWin(){
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
     if (markers[0] == mark && markers[5] == mark && markers[8] == mark){ winner = turn; return true; }
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


public void winScreen(){
  println("Win");
  timer();
  String winText;
  
   background(0);
   
   switch(winner){
   case 0: winText = "Sorry the computer wins this round! :("; break;
   case 1: winText = "Congrats!! You Win!! :D"; break;
   case -1: winText = "Looks like a tie..."; break;
   default: winText = "This is an error message. It should not be this"; 
   }
   text(winText, width/2, height/2);
}

public void timer(){
  float startTime = millis();
  while(millis() - startTime < 2000){};
}
  public void settings() {  size(640, 360); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ticTacToe" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
