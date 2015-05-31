/*
*
*    Background Looping Sound in Processing Test Sketch
*    by Stéphane Adam Garnier - 2012
*
*/

// libs imports // ------ //
import ddf.minim.*; // Minim, the Pr audio lib

// class instances & vars  // ------ //
Minim minim;
AudioPlayer player;

// setup // ------ //
void setup(){
    size(512, 200, P2D);
    smooth();
    
    minim = new Minim(this);
    player = minim.loadFile("test.mp3", 2048);
    player.play();
    
}
// draw // ------ //
void draw(){
    //background(44);
    player.play();
}
// main fcns // ------ //

// other fcns // ------ //
void stop(){
    player.close();
    minim.stop();
    super.stop();
}
