//Sketch by StephaneAG 2012

//simple socket server

import processing.net.*;
Server myServer;
Client myClient;
int val = 0;

//for the color version
//int valRed = 0;

float valRed = 0;
float valGreen = 0;
float valBlue = 0;
String valRedInString;
String valGreenInString;
String valBlueInString;

//String[] rgbColors = concat(string1, string2);
String[] rgbColor = { "0", "0", "0" }; 

void setup(){
  frameRate(1);
  size(320,320);
  //start server on port
  myServer = new Server(this, 80);
}

void draw(){
  val = (val +1) %255; // grayscale basic test
  valRed =  ((val +0.5) + random(255)) %255; //random(255); //(val +1) %255;
  valGreen = ((val +0.5) + random(255)) %255;//(val +0.5) %255; // random(255); //(val +1) %255;
  valBlue =  ((val +0.5) + random(255)) %255; //(val +0.5) %255; //random(255); //(val +1) %255;
  
  
  //background(valRed,valGreen,valBlue);
  //background(3,60,30);
  background( floor(valRed), floor(valGreen), floor(valBlue));
  
  //valRedInString = str(valRed); //toString(valRed);
  //valGreenInString = str(valGreen);
  //valBlueInString = str(valBlue);
  
  //myServer.write(valRed + " " + valGreen + " " + valBlue + "\n\n"); // write a single line to clients
  //myServer.write(3 + " " + 60 + " " + 30 + "\n\n");
  myServer.write( floor(valRed) + " " +  floor(valGreen) + " " +  floor(valBlue) + "\n");
  //println( floor(valRed) + " " +  floor(valGreen) + " " +  floor(valBlue) + "\n");
  
  
  //background(val); // original grayscale environement ()
  //myServer.write(val);
}
