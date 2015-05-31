class TerminalProcess implements Runnable{
    boolean running;
    String processID;
    Process theProcess;
    String[] cmd;
    boolean processFirstLoop; // to execute command once, and get logs results while still running (..)
    
    TerminalProcess(String theID, String theScript){ // Constructor
        running = true;
        processID= theID;
//        cmd = new String[]{
//            "/bin/bash",
//            "-c",
//            theScript
//        };
        cmd = new String[]{
            //"/bin/bash",
            "say", // to use with 'dummyTermCmd'
            //"ruby",
            theScript
        };
        processFirstLoop = true;
        new Thread(this).start();
    }
    
    public void run(){
        println("Terminal Process Running ..");
        
        while(running){
            
            try{
                
                Thread.sleep(0);
                
                if ( processFirstLoop == true ){ // first loop > we execute the cmd
                    
                    try{
                        theProcess = Runtime.getRuntime().exec(cmd);
                        processFirstLoop = false; // soooo important ;p
                    } catch(IOException e){
                        System.err.println(e);
                    }
                  
                } else { // not first loop > we lok for logs and print them if we cath some (..)
                    
                    try{
                    
                        String theString;
                        DataInputStream theInput = new DataInputStream( theProcess.getInputStream() );
                    
                        try{
                            println("Recent log:");
                            while( ( theString = theInput.readLine() ) != null ){
                                println("TerminalProcess '"+processID+"' log: " + theString);
                            }
                      
                        } catch(IOException e){
                            System.err.println(e);
                        }
                    
                    
                    }catch(Exception e){
                        System.err.println(e);
                    }
                    
                }
                
                
            } catch(InterruptedException e){
                System.err.println(e);
            }
          
        }
        
    }
}
