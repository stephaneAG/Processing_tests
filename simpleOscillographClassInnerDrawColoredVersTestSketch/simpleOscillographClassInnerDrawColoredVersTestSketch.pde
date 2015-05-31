/*
*    Non-threaded Oscillograph class
*    by Stéphane Adam Garnier - 2012
*
*/

// Imports // -------- //

// Vars & Constants // ------ //
Oscillograph myGraph; // > our class in action ;p
Oscillograph myGraph2;

// NECESSARY FOR EXTERNAL 'draw()' (ex: in classes (..) )
PApplet app = this;

// Setup // -------- //
void setup(){
    size(600, 600);
    
    myGraph = new Oscillograph(500, 300, 50, 20, 1000, 2, 1, 1, color(150, 150, 150), color(50, 55, 100), color(255, 204, 0) ); // WARN: 'new' constructor [type 1] > width/height/positionX/positionY/range/refreshRate/boundsStrokeWeight/strokeWeight/boundsColor/bckgrndColor/strokeColor
    myGraph2 = new Oscillograph(550, 150, 25, 325, 2000, 3);
    
}
// Draw // ------ //
void draw(){
    background(0);
    
}

// Classes // -------- //

// Oscillograph class [simple, non-threaded (..) ]

// if defined other than 'public' , will throw a 'java.lang.IllegalAccessException' (..)
public class Oscillograph {
    
    PGraphics pgraph;
    
    int wid, hei;
    int posX, posY;
    
    float[] arrayValues;
    int range;
    
    int refreshSpeed; // useful to 'trick' processing to draw faster than in the 'main' sktech's 'draw()'
    
    int boundsStrkWei;
    int strokeWei;
    
    color boundsColor;
    color backgroundColor;
    color strokeColor;
    
    // Constructor 1
    Oscillograph(int w, int h, int poX, int poY, int r){
        
        pgraph = createGraphics(w, h, P2D); // 'hardcoded' P2D renderer for now (> maybe later an oscillograph in 3d ? ;p)
        wid = w;
        hei = h;
        posX = poX;
        posY = poY;
        range = r;
        
        refreshSpeed = 1; // 'harcoded' for normal constructor [> to specify it, see 2nd constructor (..) ]
        
        boundsStrkWei = 1;
        strokeWei = 1;
        
        boundsColor = color(0);
        backgroundColor = color(255);
        strokeColor = color(33);
        
        arrayValues = new float[wid]; // init the internal array 'arrayValues' with an index for each pixel of the 'bounds' (..)
       
       for(int i = 0; i < arrayValues.length; i++){
           arrayValues[i] = 0; // fill every index with '0'  for value (..)
       }
       
       
       // call a 'special/init' fcn at the end of the constructor
        drawBase(); // will draw the 'bounds' of the oscillograph (..)
        
        // REGISTER THE CLASS's 'draw()' using the reference to the Applet (nb: could also be pased in the constructor (..) )
        app.registerDraw(this);
        
      
    }
    
    // Constructor 2 > providing 'custom drawing refresh rate'
    Oscillograph(int w, int h, int poX, int poY, int r, int refreshR){
        
        pgraph = createGraphics(w, h, P2D); // 'hardcoded' P2D renderer for now (> maybe later an oscillograph in 3d ? ;p)
        wid = w;
        hei = h;
        posX = poX;
        posY = poY;
        range = r;
        refreshSpeed = refreshR; // 'harcoded' for normal constructor [> to specify it, see 2nd constructor (..) ]
        
        boundsStrkWei = 1;
        strokeWei = 1;
        
        boundsColor = color(0);
        backgroundColor = color(255);
        strokeColor = color(33);
        
        arrayValues = new float[wid]; // init the internal array 'arrayValues' with an index for each pixel of the 'bounds' (..)
       
       for(int i = 0; i < arrayValues.length; i++){
           arrayValues[i] = 0; // fill every index with '0'  for value (..)
       }
       
       
       // call a 'special/init' fcn at the end of the constructor
        drawBase(); // will draw the 'bounds' of the oscillograph (..)
        
        // REGISTER THE CLASS's 'draw()' using the reference to the Applet (nb: could also be pased in the constructor (..) )
        app.registerDraw(this);
        
      
    }
    
    // Constructor 3 > providing 'custom drawing colors & stuff'
    
    // Constructor 4 > providing 'custom drawing colors & stuff IN COLORS'
    Oscillograph(int w, int h, int poX, int poY, int r, int refreshR,int bndsStrkWei, int strkWei, color bndsColor, color bckgrndColor, color strkColor){
        
        pgraph = createGraphics(w, h, P2D); // 'hardcoded' P2D renderer for now (> maybe later an oscillograph in 3d ? ;p)
        wid = w;
        hei = h;
        posX = poX;
        posY = poY;
        range = r;
        refreshSpeed = refreshR; // 'harcoded' for normal constructor [> to specify it, see 2nd constructor (..) ]
        
        boundsStrkWei = bndsStrkWei;
        strokeWei = strkWei;
        
        boundsColor = bndsColor;
        backgroundColor = bckgrndColor;
        strokeColor = strkColor;
        
        arrayValues = new float[wid]; // init the internal array 'arrayValues' with an index for each pixel of the 'bounds' (..)
       
       for(int i = 0; i < arrayValues.length; i++){
           arrayValues[i] = 0; // fill every index with '0'  for value (..)
       }
       
       
       // call a 'special/init' fcn at the end of the constructor
        drawBase(); // will draw the 'bounds' of the oscillograph (..)
        
        // REGISTER THE CLASS's 'draw()' using the reference to the Applet (nb: could also be pased in the constructor (..) )
        app.registerDraw(this);
        
      
    }
    
    // end of Constructors
    
    //fcn called at the end of the constructor
    void drawBase(){
        pgraph.beginDraw();
            pgraph.noFill();
            pgraph.strokeWeight(boundsStrkWei);
            pgraph.stroke(boundsColor);
            pgraph.rect(0, 0, wid, hei);
        pgraph.endDraw();
    }
    
    // fcn making it possible to get the image of a 'PGraphics' that is within a custom class (..)
    PGraphics getPGraphics(){
        return pgraph;
    }
    
    // array fcns (..)
    void slideDownArray(){
        for( int i = 0; i < arrayValues.length - 1; i++ ){
            arrayValues[i] = arrayValues[i+1];
        }
    }
    
    void addToArray(float arrayValue){
        arrayValues[arrayValues.length - 1] = arrayValue;
    }
    
    // drawing fcn
    void drawGraph(){
        pgraph.beginDraw();
            pgraph.background(backgroundColor);
            pgraph.stroke(strokeColor);
            pgraph.strokeWeight(strokeWei);
            
            for( int i = 0; i < arrayValues.length; i++ ){
                
                if( (i+1 < arrayValues.length) && (arrayValues[i] != 0) ){
                    pgraph.line( i, ( hei/2 - map( arrayValues[i], 0, range, 0, (hei/2 - 2) ) ), i, ( hei/2 + map( arrayValues[i], 0, range, 0, (hei/2 - 2) ) ) );
                }
              
            }
            
        pgraph.endDraw();
    }
    
    public void updateGraphWithValue( float newValue ){
        drawGraph();
        slideDownArray();
        addToArray(newValue);
    }
    
    // Inner 'draw()' mthd
    void draw(){
        
          if( refreshSpeed == 1 ){ // same frame rate as the sketch's main 'draw()' fcn (..)
              updateGraphWithValue( random(0, range) ); // for the moment with fake values > could easily get values from a thread ;D
              image(getPGraphics(), posX, posY);
          } else if( refreshSpeed == 2 ){ // frame rate X2
              updateGraphWithValue( random(0, range) );
              image(getPGraphics(), posX, posY);
              updateGraphWithValue( random(0, range) );
              image(getPGraphics(), posX, posY);
          } else if ( refreshSpeed == 3 ){ // frame rate X3
              updateGraphWithValue( random(0, range) );
              image(getPGraphics(), posX, posY);
              updateGraphWithValue( random(0, range) );
              image(getPGraphics(), posX, posY);
              updateGraphWithValue( random(0, range) );
              image(getPGraphics(), posX, posY);
          }
          
          // maybe better with a 'if ( refreshCounter < refreshSpeed){do stuff & counter++}'
      
    }
    
    
  
}

