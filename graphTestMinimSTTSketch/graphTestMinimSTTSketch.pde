/*
*
*    First test of 'graph' visualisation possibilities of Pr + Minim + STT libs (..)
*    by Stephane Adam Garnier - 2012
*
*/

import ddf.minim.*; // Minim lib import
import com.getflourish.stt.*; // STT lib import
import terminalp5.*; // TerminalP5 import ;D

// TerminalP5 // ------ //

//TerminalP5 termP5;
TerminalProcess termProcess; // the process thread we will use to proceed voice commands (..)

// STT // ------ //

STT stt;
String result;

// Minim // ------ //
Minim minim; // Minim singleton Class instance
AudioInput in; // our audio input instance

// Program // ------ //
float audioNoiseTreshold = 8.0;
float[] audioLevelsValues;

boolean drawVolumeGraph = false;

void setup(){
    size(400, 200);
    smooth();
    
    // STT // ------ //
    stt = new STT(this);
    stt.enableDebug();
    stt.setLanguage("en");
    
    // text used to display the result [even if in my case, i prefer using the terminal to read it for me ;p]
    //PFont( createFont("Arial", 24) );
    result = "Say something";
    
    // Program // ------ //
    audioLevelsValues = new float[width];
    for(int i = 0; i < audioLevelsValues.length; i++){
        audioLevelsValues[i] = 0;
    }
    
    
    // Minim // ------ //
    //minim = new Minim(this);
    minim = stt.getMinimInstance(); // should go throught STT to find Minim [used inside STT (..)]
    //in = minim.getLineIn(Minim.STEREO, 512); // return an error (>logical, as STT already took on the input .. :/ )
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
    
    
    // Minim // ------ //
//    if ( (in.mix.level() * 1000) > audioNoiseTreshold && ( (in.mix.level() * 1000) < 150 ) ){
//        //println("Audio volume between 0 and 150 : " + in.mix.level() * 1000 );
//        // this might be an actual user voice! ^^!
//        //add a new random value to the array
//        audioLevelsValues[audioLevelsValues.length-1] = in.mix.level() * 1000;
//        
//    } else if ( (in.mix.level() * 1000) < audioNoiseTreshold ) {
//        //println("Audio volume CONSIDERED NOISE ! : " + in.mix.level() * 1000 );
//        audioLevelsValues[audioLevelsValues.length-1] = 0;
//    } else {
//        //println("Audio volume TOO LOUD! : " + in.mix.level() * 1000 );
//        audioLevelsValues[audioLevelsValues.length-1] = 0;
//    }
    
    // STT // ------ //
    //println( stt.getVolume() );
    if ( drawVolumeGraph == true ){ // if we a currently recording something, then we draw the voice levels graph (..)
        updateAudioLevelsArray();
    } else {
        audioLevelsValues[audioLevelsValues.length-1] = 0;
    }
    
    
    text(result, mouseX, mouseY); // display result at mouse location
    
    
}

void stop(){ // necessary for Minim to work properly (..)
    in.close();
    minim.stop();
    super.stop();
}

// PROGRAM > array handling // ------ //

void updateAudioLevelsArray(){
  
    if ( stt.getVolume() > audioNoiseTreshold && ( stt.getVolume() < 150 ) ){
        //println("Audio volume between 0 and 150 : " + in.mix.level() * 1000 );
        // this might be an actual user voice! ^^!
        //add a new random value to the array
        audioLevelsValues[audioLevelsValues.length-1] = stt.getVolume();
        
    } else if ( stt.getVolume() < audioNoiseTreshold ) {
        //println("Audio volume CONSIDERED NOISE ! : " + in.mix.level() * 1000 );
        audioLevelsValues[audioLevelsValues.length-1] = 0;
    } else {
        //println("Audio volume TOO LOUD! : " + in.mix.level() * 1000 );
        audioLevelsValues[audioLevelsValues.length-1] = 0;
    }
  
}

// PROGRAM > terminal commands handling // ------ //

void handleVoiceCommand(String voiceCmdString){
    String termRecorded = "Did you mean " + voiceCmdString + " ?"; // by now, simply create a sentence for the terminal to repeat (..)
    termProcess = new TerminalProcess("voiceCommandProcess", "voiceCommandProcess.log", "say", termRecorded); // create an instance of the CustomThread just created
    termProcess.start(); // start it
  
}

// STT // ------ //

// mthd called if a transcription was succesfull
void transcribe(String utterance, float confidence){
    println("utterance");
    result = utterance;
    handleVoiceCommand(utterance);
}

// STT | PROGRAM > using a key to begin/add a record | draw or not the voice graph // ------ //

public void keyPressed(){
    stt.begin();
    drawVolumeGraph = true;
}

public void keyReleased(){
    stt.end();
    drawVolumeGraph = false;
}
