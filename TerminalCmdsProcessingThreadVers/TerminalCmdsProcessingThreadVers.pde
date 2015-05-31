/*
*  Terminal Commands in Processing Thread Vers v1a
*  by Stephane Adam Garnier - 2012
*/

TerminalProcess termP; // create a new terminal process obj


//String termCmd[] = "/bin/bash", "-c", "top";
String dummyTermCmd = "Hello World from Processing and with logs callbacks";

void setup(){
    size(400, 400);
    //thread("simpleThreadedFct"); // use function as thread ;p // WORKS
    
    termP = new TerminalProcess("myProcess", "myProcess.log", "say", dummyTermCmd); // create an instance of the CustomThread just created
    termP.start(); // start it
    
}

void draw(){
    background(255);
    fill(0);
    
}





