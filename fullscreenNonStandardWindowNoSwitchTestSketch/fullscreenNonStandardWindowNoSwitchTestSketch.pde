/*
*    Fulscreen non-standard window test sketch
*    by Stéphane Adam Garnier - 2012
*
*    R: to float over the OS toolbar as well (at least on Mac OS), be sure to edit the 'infos.plist' file inside the '.app',
*       and replace the '0' by a '4' in the right key, so that the setup finally looks like this:
*
*       <key>LSUIPresentationMode</key>
*           <integer>4</integer>
*/


PFont fnt;
int w, h, pX, pY;

boolean cmdIsPressed = false;
boolean tabIsPressed = false;

void setup(){
    // w & h are the desired size of the frame
    // here modified to be full screen
    w = screen.width;
    h = screen.height;
    
    // initial position of frame
    pX = 0;
    pY = 0;
    
    size(w, h);
    
    fnt = createFont("Arial", 12, false);
}

// ------ // HACK // ------ //
void init(){
    //make it possible to change th e frame properties
    frame.removeNotify();
    //hides the frame 'chrome'
    frame.setUndecorated(true);
    //have the window 'float' above all others
    frame.setAlwaysOnTop(true);
    
    frame.setResizable(true);
    frame.addNotify();
    
    super.init(); // maje sure to call 'Applet.init()' for perper setup (..)
}


void draw(){
    background(0);
    
    //resize & set initial location a few frames after the sketch start (..)
    // > ex: our window will be tinier thazn normal and location at psecified location (pX | pY)
    if ( frameCount == 5 ){
        frame.resize(w, h);
        frame.setLocation( pX, pY);
    }
    
    // draw window outline
    noStroke();
    
    fill(255, 100, 0);
    rect(0, 0, width, height);
    fill(0);
    rect(3, 3, width - 6, height - 6);
    
    textFont(fnt);
    
    fill(255, 255, 0);
    
    text(frameCount/10 + " | " + frame.getLocation().x + ", " + frame.getLocation().y, 16, 24);
}


void keyPressed(){
    
    // don't quit if we hit 'escape'
    if ( key == 27 ){
        key = 0;
    } 
  
    println("Key pressed: " + key);
    
    if ( key == TAB ){
            println("TAB was just pressed");
            if( cmdIsPressed == true ){
                //do something and prevent app switching (..)
                key = 0;
                tabIsPressed = true;
            } else {
                tabIsPressed = true;
            }
    }
            
    if ( keyCode == 157 ){
        println("CMD was just pressed");
        cmdIsPressed = true;
    }
}

void keyReleased(){
  
    println("Key released: " + key);
    
    if ( key == TAB ){
        println("TAB was just released");
        tabIsPressed = false;
    }
    
    if ( keyCode == 157 ){
        println("CMD was just released");
        cmdIsPressed = false;
    }
  
}
