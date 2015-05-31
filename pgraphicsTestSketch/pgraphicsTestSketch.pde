/*
*
*    PGraphics | custom window | image fcn Test Sketch
*    by Stéphane Adam Garnier - 2012
*
*
*/

// Imports // ------ //

// Vars & Constants // ------ //
PImage overlay1;
PImage overlay2;

//simple test vars
float x, y;


// simplest use of PGraphics
PGraphics pg;
// PGraphics used from within a custom class
Drawing myDrawing;

// Setup // ------ //
void setup(){
    size(600, 500, P2D);
    smooth();
    overlay1 = loadImage("singleHole.png");
    overlay2 = loadImage("singleHole2.png");
    
    pg = createGraphics(width, height, P2D);
    
    myDrawing = new Drawing(600, 500); // create an instance of 'Drawing'
}

// Draw // ------ //
void draw(){
    background(255);
    
    // draw/do something
    noStroke();
    //strokeWeight(1);
    fill(0);
    ellipse(mouseX, mouseY, 55, 55);
    
    
    // use our 'PGraphics' instance
    pg.beginDraw();
    pg.background(200, 200, 200, 0); // 4th parameter to make it transparent
    pg.stroke(40);
    pg.line( 40, 40, mouseX, mouseY);
    pg.endDraw();
    //image(pg, 0, 0);
    
    // Add the overlay(s)
    //image(overlay1, 0, 0);
    image(overlay2, 0, 0);
    
    // draw OVER the first overlay
    fill(150);
    ellipse(mouseX, mouseY, 25, 25);
    
    image(pg, 0, 0);
    
    // test the 'Drawing' class above everything else
    //myDrawing.drawBase();
    //image(myDrawing.getPGraphic(), 0, 0);
    image(myDrawing.getPGraphic(), (mouseX - myDrawing.wid/2), 0);
}
// Main Functions // ------ //

// Classes & extras // ------ //
class Drawing{
    PGraphics p;
    int wid, hei;
    
    Drawing(int w, int h){
        p = createGraphics(w, h, P2D);
        wid = w;
        hei = h;
        drawBase();
    }
    
    void drawBase(){
        p.beginDraw();
            //p.fill(220, 0);
            p.noFill();
            p.stroke(33);
            p.rect(0, 0, 200, 400);
        p.endDraw();
    }
    
    PGraphics getPGraphic(){
        return p;
    }
}
