// ---------- Terminal Process Class ----------- //

class TerminalProcess extends Thread{
    
    boolean running; // running or not
    String processID; // Process [>thread]'s ID
    String logFilename; // the name of the log file
    //Process theProcess; // the process we'll be watching [in case we don't use the logfile (..)]
    String commandPrefix; // the string we 'll use to prefix the command (..)
    String providedCmd; // the provided command to execute
    String[] cmd;// the actual command built including the provided part (..)
    boolean processFirstLoop; // to execute command once, and get logs results while still running (..)
    
    // Thread Constructor //
    TerminalProcess(String theID, String theFileName,String theCmdPrefix, String theCmd){
        running = false; // init running status (boolean)
        processID = theID; // set thread ID from provided String ID
        logFilename = theFileName; // set log file name from provided String logFileName
        commandPrefix = theCmdPrefix;
        providedCmd = theCmd; // the command provided
        cmd = new String[]{ // the actual command we'll run
            //"say",
            commandPrefix,
            theCmd
        };
        processFirstLoop = true; // init processFirstLoop (> we 're talking about the 'Processing Thread Process', wich monitor the actual Terminal process)
    }
    
    // "start()" override //
    void start(){
        running = true; // set its status to "running"
        println("Terminal Process started: ID > \"" + processID + "\" Log filename > \"" + logFilename + "\" command > \"" + providedCmd + "\"" );
        
        // if needed , do preliminary stuff [to be executed at thread start] here (..)
        // exec the cmd and start looking for logs (..)
        
        // if we can use 'theProcess' to monitor our commnd logs (..) > seems not form here (..)
//        try{
//            theProcess = Runtime.getRuntime().exec(cmd);
//        } catch(IOException e){
//            System.err.println(e);
//        }
        
        super.start(); // to set to be able to auto-call "run()"
    }
    
    // "run()" override //
    void run(){
        while(running){ // while the thread is running
        
            // do stuff ..
            try{
                
                if ( processFirstLoop == true ){ // first loop > we execute the cmd
                    
                    try{
                        //theProcess = Runtime.getRuntime().exec(cmd); // run the terminal command / setup(check/create) a log file / start listening on output(s)
                        Runtime.getRuntime().exec(cmd); // run process 'normally' 
                        processFirstLoop = false; // soooo important ;p > 1st loop: setup | other loops: read (..)
                    } catch(IOException e){
                        System.err.println(e);
                    }
                  
                } else { // not first loop > we lok for logs and print them if we cath some (..)    
              
                }
            
                // sleep a little before next execution
                try{
                    sleep((long)(3000));
                }catch(Exception e){
            
                }
              
            }catch(Exception e){
                System.err.println(e);
            }
        }
        
        // at this point, thread is done ad is gonna end
        System.out.println("Terminal Process  '" + processID + "' is done executing.");
    }
    
    // "quit" mthd, in case we want to interrupt the thread / stop it
    void quit(){
        System.out.println("Quitting Terminal Process  '" + processID + "'");
        running = false; // ends the loop in "run()"
        interrupt(); // in case the thread was waiting (..)
    }
    
    
    // THREAD METHODS //
    
    void setupLogFile(String logFilename){
        // get 'pwd'
        // check for a file with that name in there
        // if found, empty it
        // if not found ,create it
    }
    
    void updateLogBuffer(){
        // test if the logfile exists
            // if not, create it
            // if it does:
                // check if it 's empty
                    // if it is > good
                    // if not: 
                        //copy content to 'logBuffer'
                        // empty the log file
                        //set 'logsAvailable' to true
    }
    
    void killProcess(){
        // run a terminal command on a separate thread to list all the current processes
        // log the results to a log file (used only for this purpose > should have the name '[processID].killLog.log')
        // once results are fetched, use them to find the 'PID' corresponding to the object's 'providedCmd'
        // use this 'PID' and run a terminal command to kill the process
    }
    
  
} // end class CustomThread
