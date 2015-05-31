import terminalp5.*; // nb: 'lib' is only .jar files in the [current] sketch 'code' folder ( ProcessingDev/[CurrentSketchName]/code/)
                     // > comment just above: still true but now also works with the *.jar in its own directory inside the Pr libraries folder
TerminalP5 termP5;

TerminalProcess termProcess;
String dummyTermCmd = "Hello World from Processing and with logs callbacks";
int processPID;

void setup(){
    size(400, 400);
    termP5 = new TerminalP5();
    termP5.helloWorld();
    
    termProcess = new TerminalProcess("myProcess", "myProcess.log", "say", dummyTermCmd); // create an instance of the CustomThread just created
    termProcess.start(); // start it
    
    // debug/wip > print the dataPath
    String filename = "process.killLog.log";
    File logFile = new File( dataPath(filename) );
    
    if( logFile.exists() ){
        println("the log file exists in the dataPath!");
        println("the file's absolute path is: " + logFile.getAbsolutePath() );
    } else {
        println("the log file doesn't exist in the dataPath!");
    }
    
    println("\r\n ----------------------- \r\n");
    
    // debug/wip > print the sketchPath
    String filename2 = "processKiller.killLog.log";
    File logFile2 = new File( sketchPath(filename2) );
    
    if( logFile2.exists() ){
        println("the log file exists in the sketchPath!");
        println("the file's absolute path is: " + logFile2.getAbsolutePath() );
    } else {
        println("the log file doesn't exist in the sketchPath! > creating log file ..");
        
        try {
            logFile2.createNewFile();
            println("the log file 2 now exists in the sketchPath!");
            println("the file's absolute path is: " + logFile2.getAbsolutePath() );
        } catch (IOException e){
            System.err.println("Error creating the file: " + logFile2.getAbsolutePath() );
        }
    }
    
    println("\r\n ----------------------- \r\n");
    
    // debug/wip > read&println each line from currentProcesses.log
    String filename3 = "currentProcesses.log";
    String[] processesList;
    String runningCmd = "ruby dumbPrinter.rb";
    //int processPID;
    File logFile3 = new File( dataPath(filename3) );
    
    if( logFile3.exists() ){
        println("the currentProcesses log file exists in the dataPath!");
        println("the file's absolute path is: " + logFile.getAbsolutePath() );
        
        processesList = loadStrings(logFile3);
        println("Processes from logFile: ");
        
        for( int i = 0; i < processesList.length; i++ ){
            println("ProcessLine: " + processesList[i]);
            
            if( processesList[i].contains(runningCmd) ){
                println("Running command PID found: Process" + processesList[i] );
                
                String[] runningProcessParts = split(processesList[i], " ");
                processPID += int(runningProcessParts[0]); // typcasting String to int ;p
                println("running command Process ID (PID) should be: " + processPID);
            }
        }
        
    } else {
        println("the log file doesn't exist in the dataPath!");
    }
    
    
}

void draw(){
    background(200);
    fill(0);
}

