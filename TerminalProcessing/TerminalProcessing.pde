/*
  TerminalProcessing - v1a
  by Stéphane Adam Garnier - 2012
    
  simple sketch calling Terminal commands directly from Processing  
    
*/

TerminalLogger tl; // create a 'Terminal Logger' instance

void setup(){
    size(400, 400); // basic sketch window size
    tl = new TerminalLogger(this);
}

void keyPressed(){
    if( key == 'r' ){
        
    }
}

void draw(){}

// Classes //

class TerminalLogger implements Runnable{
    boolean running;
    String theScript;
    Process theProcess;
    String[] cmd;
    int theValue;
    
    TerminalLogger(String theScript){ // Constructor
        running = true;
        cmd = new String[]{
            "/bin/bash",
            "-c",
            theScript
        };
        new Thread(this).start();
    }
    
    public void run(){
        println("Terminal Logger Running ..");
    }
}

