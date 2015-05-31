/*
*  Terminal Commands in Processing v1a
*  by Stephane Adam Garnier - 2012
*/

// TerminalProcess termP; // create a new terminal process obj

Process myProcess;
//String termCmd[] = "/bin/bash", "-c", "top";
String dummyTermCmd = "say Hello World from Processing and with logs callbacks";

void setup(){
    size(400, 400);
    //thread("simpleThreadedFct"); // use function as thread ;p // WORKS
    
    //termP = new TerminalProcess("myLittleThread"); // create an instance of the CustomThread just created
    //termP.start(); // start it
    try{
        Runtime.getRuntime().exec(dummyTermCmd);
    }catch(Exception e){
      System.out.println( "error" + e );
    }
}

void draw(){
    background(255);
    fill(0);
    
}

