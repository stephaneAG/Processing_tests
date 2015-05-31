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

void setup(){
    minim = new Minim(this);
    
    in = minim.getLineIn(Minim.STEREO, 512);
}

void draw(){
  
    if ( (in.mix.level() * 1000) > audioNoiseTreshold && ( (in.mix.level() * 1000) < 150 ) ){
        println("Audio volume between 0 and 150 : " + in.mix.level() * 1000 );
    } else if ( (in.mix.level() * 1000) < audioNoiseTreshold ) {
        println("Audio volume CONSIDERED NOISE ! : " + in.mix.level() * 1000 );
    } else {
        println("Audio volume TOO LOUD! : " + in.mix.level() * 1000 );
    }
    
}

void stop(){ // necessary for Minim to work properly (..)
    in.close();
    minim.stop();
    super.stop();
}
