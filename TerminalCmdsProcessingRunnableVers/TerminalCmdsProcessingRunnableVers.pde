/*
*  Terminal Commands in Processing v1b
*  by Stephane Adam Garnier - 2012
*/

TerminalProcess termP; // create a new terminal process obj

//String termCmd[] = "/bin/bash", "-c", "top";
String dummyTermCmd = "Hello World from Processing and with logs callbacks";
String rubyScriptCmd = "/Users/stephaneadamgarnier/processingDev/TerminalCmdsProcessingRunnableVers/data/dumbPrinter.rb";

void setup(){
    size(200, 300);
    //thread("simpleThreadedFct"); // use function as thread ;p // WORKS
    
    
//    try{
//        Runtime.getRuntime().exec(dummyTermCmd);
//    }catch(Exception e){
//      System.out.println( "error" + e );
//    }
    
    //termP = new TerminalProcess("sayThread", dummyTermCmd); // create an instance of the CustomThread just created
    termP = new TerminalProcess("sayThread", dummyTermCmd);
    //termP.start(); // start it
    
}

void draw(){
    background(255);
    fill(0);
    
}


// Classes //



