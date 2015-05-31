/*
*    Non-threaded Oscillograph class
*    by Stéphane Adam Garnier - 2012
*
*/

// Imports // -------- //

// Vars & Constants // ------ //
Oscillograph myGraph; // > our class in action ;p
Oscillograph myGraph2; // > and another for the fun ;D
Oscillograph myGraph3; // > and anoth for the fun ;D

// Setup // -------- //
void setup(){
    size(600, 600);
    
    myGraph = new Oscillograph(200, 100, 150); // create a new 'Oscillograph', with 200 px wide, 100 px tall, and with a value(s) range of 150 (nb, by now 0 <-> 150 (..) )
    myGraph2 = new Oscillograph(500, 300, 500);
    myGraph3 = new Oscillograph(600, 50, 1000);
    
}
// Draw // ------ //
void draw(){
    background(0);
    
    //update the oscillograph displayed in the sketch (..)
    myGraph.updateGraphWithValue( random(0, 150) ); // updates the graph array values/ manage array/ draw graph
    image(myGraph.getPGraphics(), 200, 0); // display the 'current visual state' of the graph, where we want it on the sketch ;p
    
    myGraph2.updateGraphWithValue( random(0, 500) );
    image(myGraph2.getPGraphics(), 50, 102);
    
    // here we repeat it twice to increase the 'update speed' by 2 ;p
    myGraph3.updateGraphWithValue( random(0, 1000) ); // updates the graph array values/ manage array/ draw graph
    image(myGraph3.getPGraphics(), 0, 550);
    myGraph3.updateGraphWithValue( random(0, 1000) ); // updates the graph array values/ manage array/ draw graph
    image(myGraph3.getPGraphics(), 0, 550);
    
}

// Classes // -------- //

// Oscillograph class [simple, non-threaded (..) ]

class Oscillograph {
    
    PGraphics pgraph;
    
    int wid, hei;
    
    float[] arrayValues;
    int range;
    
    // Constructor
    Oscillograph(int w, int h, int r){
        
        pgraph = createGraphics(w, h, P2D); // 'hardcoded' P2D renderer for now (> maybe later an oscillograph in 3d ? ;p)
        wid = w;
        hei = h;
        range = r;
        
        arrayValues = new float[wid]; // init the internal array 'arrayValues' with an index for each pixel of the 'bounds' (..)
       
       for(int i = 0; i < arrayValues.length; i++){
           arrayValues[i] = 0; // fill every index with '0'  for value (..)
       }
       
       
       // call a 'special/init' fcn at the end of the constructor
        drawBase(); // will draw the 'bounds' of the oscillograph (..)
      
    }
    // end of Constructor
    
    //fcn called at the end of the constructor
    void drawBase(){
        pgraph.beginDraw();
            pgraph.noFill();
            pgraph.stroke(33);
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
            pgraph.background(255);
            pgraph.stroke(33);
            pgraph.strokeWeight(1);
            
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
    
    
  
}

