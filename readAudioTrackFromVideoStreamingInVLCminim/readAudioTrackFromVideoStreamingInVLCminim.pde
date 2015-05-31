/*
*
*    Read Audio track from a video streaming in VLC in Processing Test Sketch
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
    player = minim.loadFile("http://127.0.0.1:1234", 2048);
    player.play();
    
}
// draw // ------ //
void draw(){
    background(44);
    stroke(255);
    
    //draw the waveforms
    for( int i = 0; i < player.bufferSize() - 1; i++ ){
        float x1 = map(i, 0, player.bufferSize(), 0, width);
        float x2 = map(i+1, 0, player.bufferSize(), 0, width);
        
        line(x1, 50 + player.left.get(i) * 50, x2, 50 + player.left.get(i+1) * 50);
        line(x1, 150 + player.right.get(i) * 50, x2, 150 + player.right.get(i+1) * 50);
        
    }
    
}
// main fcns // ------ //

// other fcns // ------ //
void stop(){
    player.close();
    minim.stop();
    super.stop();
}
