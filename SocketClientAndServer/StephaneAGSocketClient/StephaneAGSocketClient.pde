//Sketch by StephaneAG 2012

//simple socket client

import processing.net.*;
Client myClient;
int dataIn;

//for multiple colors
//float valRed = 0;
//float valGreen = 0;
//float valBlue = 0;
String input;
int data[];

//necessaire pour les couleurs
int colorsArrayRed;

void setup(){
  size(320,320);
  //listen to host
  myClient = new Client(this,"192.168.1.7",5204);
}

void draw(){
  
  if (myClient.available() > 0){
    
    try {
    input = myClient.readString();
    input = input.substring(0, input.indexOf("\n")); //read only up to new line
    //data = int(split(input, ' ')); // split values into array
    data = int(split(input, ' ')); // split values into array
    println("data recupérée: ");
    
    float valRed = data[0];
    float valGreen = data[1];
    float valBlue = data[2];
    
    println(data[0] + "," + data[1] + "," + data[2]);
    //println(data[0] + "," + valGreen + "," + valBlue);
    
    background(data[0], data[1], data[2]);
    } catch(Exception e){
      println("overflow escaped");
    }
    
  }
  
  
} 
