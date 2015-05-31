/*
  First Thread Ever(!^^)
  by Stephane Adam Garnier - 2012
*/

CustomThread myFirstThread;// 'yayy' ^^!

void setup(){
    size(400, 400);
    //thread("simpleThreadedFct"); // use function as thread ;p // WORKS
    
    myFirstThread = new CustomThread("myLittleThread"); // create an instance of the CustomThread just created
    myFirstThread.start(); // start it
}

void draw(){
    background(255);
    fill(0);
    
    int currentCount = myFirstThread.getCount(); // get count value from thread (remember, the counter starts at 0 ..)
    text(currentCount, 10, 50); // display count on screen
}


// ---------- SIMPLE THREAD ----------- //

void simpleThreadedFct(){
    while(1 == 1){ // aka "stupid-dummy loop"
         println("I come from a threaded function ;D !");
         delay(500);
    }
}

// ---------- CUSTOM THREAD(S) ----------- //

class CustomThread extends Thread{
    
    boolean running; // runnig or not
    String id; // thread's ID
    int count; // simple counter
    
    // Thread Constructor //
    CustomThread(String threadID){
        id = threadID; // set thread ID from provided String ID
        running = false; // init running status (boolean)
        count = 0; // init counter
    }
    
    // "start()" override //
    void start(){
        running = true; // set its status to "running"
        println("Custom Thread is running .. btw counter = " + count);
        
        // if needed , do preliminary stuff [to be executed at thread start] here (..)
        //
        
        super.start(); // to set to be able to auto-call "run()"
    }
    
    // "run()" override //
    void run(){
        while(running){ // while the thread is running
        
            // do stuff ..
            println("ID: " + id + " counter: " + count);
            count++;
            
            // sleep a little before next execution
            try{
              sleep((long)(3000));
            }catch(Exception e){
            
            }
        }
        
        // at this point, thread is done ad is gonna end
        System.out.println("CustomThread \"" + id + "\" is done executing. (thread counter reached " + count +")");
    }
    
    // "quit" mthd, in case we want to interrupt the thread / stop it
    void quit(){
        System.out.println("Quitting CustomThread \""+ id +"\"(thread counter reached " + count +")");
        running = false; // ends the loop in "run()"
        interrupt(); // in case the thread was waiting (..)
    }
    
    
    // THREAD METHODS //
    
    int getCount(){
        return count; // return "count" value
    }
    
  
} // end class CustomThread
