/*
*
*    First test of 'graph' visualisation possibilities of Pr + Minim lib (..)
*    by Stephane Adam Garnier - 2012
*
*/

import ddf.minim.*; // Minim lib import

Minim minim; // Minim singleton Class instance
AudioInput in; // our audio input instance

float audioNoiseTreshold = 8.0;

float[] audioLevelsValues;

void setup(){
    size(400, 200);
    smooth();
    
    audioLevelsValues = new float[width];
    for(int i = 0; i < audioLevelsValues.length; i++){
        audioLevelsValues[i] = 0;
    }
    
    minim = new Minim(this);
    in = minim.getLineIn(Minim.STEREO, 512);
}

void draw(){
    
    // PROGRAM CODE > generates a 'spectrum-like' baseed on the input level (..)
    background(255);
    stroke(0);
    
    //draw lines connecting all points
    for(int i = 0; i < audioLevelsValues.length; i++){
        stroke(0);
        strokeWeight(2);
  
        if ( ( i+1 < audioLevelsValues.length ) && ( audioLevelsValues[i] != 0) ){ //if ( i+1 < audioLevelsValues.length){ // will draw even if values[i] ==0
            strokeWeight(1);
            line(i, (height/2 - map(audioLevelsValues[i], 0, 150, 0, (height/2 - 15) ) ), i, (height/2 + map(audioLevelsValues[i], 0, 150, 0, (height/2 - 15 ) ) ) ); // even nicer ? ;D
        }
        
    }
    
    //slide everything down in the array
    for(int i = 0; i < audioLevelsValues.length-1; i++){
        audioLevelsValues[i] = audioLevelsValues[i+1];
    }
    
    
    // SOMETHING TO FEED IT ;p
    if ( (in.mix.level() * 1000) > audioNoiseTreshold && ( (in.mix.level() * 1000) < 150 ) ){
        println("Audio volume between 0 and 150 : " + in.mix.level() * 1000 );
        // this might be an actual user voice! ^^!
        //add a new random value to the array
        audioLevelsValues[audioLevelsValues.length-1] = in.mix.level() * 1000;
        
    } else if ( (in.mix.level() * 1000) < audioNoiseTreshold ) {
        println("Audio volume CONSIDERED NOISE ! : " + in.mix.level() * 1000 );
        audioLevelsValues[audioLevelsValues.length-1] = 0;
    } else {
        println("Audio volume TOO LOUD! : " + in.mix.level() * 1000 );
        audioLevelsValues[audioLevelsValues.length-1] = 0;
    }
    
    
    
}

void stop(){ // necessary for Minim to work properly (..)
    in.close();
    minim.stop();
    super.stop();
}
