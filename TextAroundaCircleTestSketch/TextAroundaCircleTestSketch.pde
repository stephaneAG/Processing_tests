/*
*
*    Text around a circle Test Sketch
*    by Stéphane Adam Garnier - 2012
*/

float zoom = 1;

ArrayList<Node> allNodes = new ArrayList(); // list of node objects

PFont nodeFont;

float nodeFontSize = 6 * zoom;
float nodeFontColor = 0;
float nodeRadius = 400 * zoom;

//int totalNodes = 150;
int totalNodes = 50;


void setup(){
    
    float dim = 1200 * zoom;
    
    //size( int(dim), int(dim) ); // text goes weirdly (..)
    //size( int(dim), int(dim), P3D ); // seems to work
    size( int(dim), int(dim), P2D );
    frameRate(60);
    background(255);
    smooth();
    colorMode(HSB, 1000);
    
    // fill the nodes with dummy content
    for( int i = 0; i < totalNodes; i++){
        Node n = new Node("This is the Node Text!      uuu");
        allNodes.add( n );
    }
    
    //nodeFont = createFont("Helvetica", nodeFontSize, true);
    nodeFont = createFont("Helvetica", nodeFontSize);
    
    noLoop();
}

void draw(){
    
    textFont(nodeFont, nodeFontSize);
    
    for( int i = 0; i < allNodes.size(); i++){
        Node n = (Node) allNodes.get( i );
        
        pushMatrix();
            //move origin to the center of the viewport minus the size of the font/2
            translate(width/2, height/2 - nodeFontSize/2);
            
            // to avoid upsidedown text
            int passedMiddle = allNodes.size() / 2;
            println(passedMiddle + " | " + i);
            if( i >= passedMiddle ){
                //rotate( radians( ( 360.0 / allNodes.size() ) + 180.0 ) * i );
                rotate( radians( 360.0 / allNodes.size() ) * i );
                //rotate( (radians( 360.0 / allNodes.size() ) * i ) + (radians( 180.0 / allNodes.size() ) * i ) );
            } else {
                rotate( radians( 360.0 / allNodes.size() ) * i );
            }
            
            //rotate( radians( 360.0 / allNodes.size() ) * i );
            fill( nodeFontColor );
            text( n.nodeName, nodeRadius, nodeFontSize/2 ); // draw the text
        popMatrix();
    }
  
}

// class 'Node'

class Node {
    String nodeName;
    // constructor
    Node(String n){
        nodeName = n;
    }
}
