/*
*    Base of work for the 'Epoc experimetal protocol' project
*    this processing app make uses of 'selectOutput()' & 'createWriter()' (..)
*    
*    Stéphane Adam Garnier - 2012
*
*    R: to float over the OS toolbar as well (at least on Mac OS), be sure to edit the 'infos.plist' file inside the '.app',
*       and replace the '0' by a '4' in the right key, so that the setup finally looks like this:
*
*       <key>LSUIPresentationMode</key>
*           <integer>4</integer>
*
*
*/

// APP OVERRIDE : DON'T QUIT APP WHEN 'ESCAPE' KEY IS PRESSED //
void keyPressed(){
    if ( key == 27 ){ // don't quit if we hit 'escape'
        key = 0;
    } 
}

// -- // imports // -- //
import oscP5.*; // import the oscP5 lib >> commmented out cause now using 'EpocP5' ;D
import epocp5.*; // my own littl' lib ;p

// -- // constants // -- //

// -- // privates // -- //
String _selectedCompositionFile; // String holding the path of the file
String _selectedCsvFile; // String holding the path of the file

String[] _compositionFileLinesData;
int _compositionDuration;
String[] _compositionActions;
String _compositionGraph;

int[] _compositionTimestamps = {0,0};
String[] _compositionTimedActions= {"0","0"};

String _textToDisplay = "SESSION START: PREPARE YOUR WILL ..";

PrintWriter _outputStream; // used to write content to the output CSV file

// epoc related stuff //
String _actionFromEpoc = "NONE";
float _valueFromEpoc = 0;

boolean graphIsAllowed = false;
float _graphValue;
String _graphAction;

EpocThread epocTh; // declare our fresh 'EpocThread' class ;p

// timing - show time left
int _timeLeft;

// -- // app look & feel vars // -- //
int appWidth = 600; // i guess I'll use the code for a full screen window overlapping anything (..)
int appHeight = 400;

int frameWidth, frameHeight, framePosX, framePosY;

PFont fnt;


// debug/wip/tmp vars //
boolean inFirstLoop = true;// used to prevent printing 0's ( > if we were previously using 'beginCSV' in the 'setup()' )
int fakeCounter = 0;

// - // * SETUP * // -- //
void setup(){
    
    // basic setup
    //size(appWidth, appHeight);
    frameRate(30);
    smooth();
    fnt = createFont("Arial", 12, false);
    textFont(fnt);
    
    // * fullscreen hack part * //
    frameWidth = screen.width;
    frameHeight = screen.height;
    
    // initial position of frame
    framePosX = 0;
    framePosY = 0;
    
    size(frameWidth, frameHeight);
    // * end fullscreen hack part * //
    
    // * overwrite window's title * //
    if (frame != null){
        frame.setTitle("Title that appears in application title bar");
    }
    
    // request CSV files
    requestComposition(); // request an input CSV composition file | if cancelled, will use a default one
    requestCSV(); // request an output CSV file | if cancelled, will use a default file path
    
    // run appropriate setup(s)
    setupOutputStream();
    handleProvidedComposition();
    _timeLeft = _compositionDuration;
    
    // init the 'Epoc thread' ( allow data to be received from MindYourOsc over an UDP socket from the headset )
    epocTh = new EpocThread("EpocMainThread", 7400); // new way, with external OSC UDP port int in class constructor (> dynamic)
    epocTh.start(); // start our 'EpocThread' ;D
    
    // writing the headers to the output CSV file
    //beginCSV(); // moved in 'draw()'
    
}

// ------ // HACK: ALLOW FULLSCREEN // ------ //
void init(){
    //make it possible to change th e frame properties
    frame.removeNotify();
    //hides the frame 'chrome'
    frame.setUndecorated(true);
    //have the window 'float' above all others
    frame.setAlwaysOnTop(true);
    
    frame.setResizable(true);
    frame.addNotify();
    
    super.init(); // maje sure to call 'Applet.init()' for perper setup (..)
}

// -- // * DRAW * // -- //
void draw(){
  background(0);
  textSize(25);
  textAlign(RIGHT);
  int timeLeft = _timeLeft - frameCount;
  text( "time left:", (width - 80), 40 );
  text( timeLeft , (width - 20), 40); // debug: print frameCount
  
  // * fullscreen <indow hack part * //
  //resize & set initial location a few frames after the sketch start (..)
    if ( frameCount == 5 ){
        frame.resize(frameWidth, frameHeight);
        frame.setLocation( framePosX, framePosX);
    }
  // * end fullscreen window hack part * //
  
  if( inFirstLoop ==true ){
      beginCSV();
      inFirstLoop = false;
  }
  
  //if ( fakeCounter >= 10000 ){
  //    // finish the session
  //    closeCSV();
  //} else {
      
      updateEpocValues(); // update the sketch's value depending on what we received from the Epoc Thread
      String epocAction = _actionFromEpoc;
      int epocValue = _valueFromEpoc;
      println("Last data received from the Epoc headset: Action> " + _actionFromEpoc + " >> Value > " + _valueFromEpoc );
    
      // display the requested actions on the screen / quit the app if the composition duration has been reached
      handleTextAndDisplay();
    
      // write data caming from the headset if available ( > will be done using the 'EpocP5' library ;p )
      writeToCSV( frameCount + "," + _textToDisplay + "," + epocValue + "," + epocAction + "\n" );
      // for the moment, just write the mouse position ..
      //int theMouseX = mouseX;
      //int theMouseY = mouseY;
      //int theMouses = theMouseX + theMouseX;
      //writeToCSV( "mouse X:" + theMouseX + "," + "mouse Y:" + theMouseY + "," + "here the third param:" + theMouses + "\n" );
      //println( "mouse X:" + theMouseX + "," + "mouse Y:" + theMouseY + "," + "here the third param:" + theMouses + "\n"  );
      //println("Counter equals:" + fakeCounter);
      //fakeCounter++;
  //}

}

// -- // main fcns // -- //

// file opening

// ask user to provide a valid CSV 'composition' file
void requestCompositionV2(){
    //selectOutput("Please select an Epoc Protocol Composition '*.CSV' file", "compositionSelected"); // params: String msg, String callbackFcn
}

void requestComposition(){
    String selectedCompositionFile = selectOutput();  // Opens file chooser
    if (selectedCompositionFile == null) {
        // If a file was not selected
        println("No output file was selected...");
    } else {
        // If a file was selected, print path to folder
        println(selectedCompositionFile);
        _selectedCompositionFile = selectedCompositionFile;
    }
}

// handle the provided CSV 'composition' file
void compositionSelected(File selectedCompositionFile){
    if( selectedCompositionFile == null ){
        // use the default composition file ( 5 mins )
        println("User cancelled the composition file request > using default composition file ( 5 mins long ) .");
    } else {
        println("User selected the composition file: " + selectedCompositionFile.getAbsolutePath() );
        // write the path of the file in a private var
        _selectedCompositionFile = selectedCompositionFile.getAbsolutePath();
    }
}

// ask user to provide a CSV file for output ( if user cancels , the app will write the file into a default directory (..)
void requestCSVv2(){
    //selectOutput("Please select an output '*.CSV' file", "csvSelected"); // params: String msg, String callbackFcn
}

void requestCSV(){
    String selectedCsvFile = selectOutput();  // Opens file chooser
    if (selectedCsvFile == null) {
        // If a file was not selected
        println("No output file was selected...");
    } else {
        // If a file was selected, print path to folder
        println(selectedCsvFile);
        _selectedCsvFile = selectedCsvFile;
    }
}

// handle the provided CSV 'composition' file
void csvSelected(File selectedCsvFile){
    if( selectedCsvFile == null ){
        // use the default composition file ( 5 mins )
        println("User cancelled the output file request > using default folder & file path .");
    } else {
        println("User selected the composition file: " + selectedCsvFile.getAbsolutePath() );
        // write the path of the file in a private var
        _selectedCsvFile = selectedCsvFile.getAbsolutePath();
    }
}


// file handling

// setup the provided output CSV file  file path to use it as an text output stream ( allowing us to write to each in each 'draw()' loop (..) )
void setupOutputStream(){
    _outputStream = createWriter( _selectedCsvFile );
}

// write to the CSV file
void writeToCSV(String stringToWrite){
    _outputStream.println( stringToWrite );
}

// write the appropriate columns headers to the CSV file
void beginCSV(){
    _outputStream.println( "TIMESTAMP,INPUT,OUTPUT 1, OUTPUT 2" ); // the top most columns headers
    _outputStream.println( "Current time,Requested action,Output value, Output action" ); // the columns sub headers
}

// terminate writing to the CSV file as an stream output , in other words flush it and then close it
void closeCSV(){
    _outputStream.flush();
    _outputStream.close();
}

// data manipulation
void readFromEpoc(){}

// resize the arrays once we know the necessary array length
void resizeArrays(){
    int necessaryLength = getNecessaryArrayLength(); // get length from the composition file
    _compositionTimestamps = expand( _compositionTimestamps, necessaryLength ); // expand the '_compositionTimestamps' array
    _compositionTimedActions = expand( _compositionTimedActions, necessaryLength ); // expand the '_compositionTimedActions' array
    
}

// return a value that can be used to initiate the arrays (the one holding the timestamps and thoe one holding the related text to display)
int getNecessaryArrayLength(){
    String linesinFileMinusParams[] = loadStrings( _selectedCompositionFile );
    return (_compositionFileLinesData.length - 5);
}

// composition stuff

// open the provided CSV file ( wich is actually a special 'composition' file) & calls the following 3 fcns
void handleProvidedComposition(){
    
    _compositionFileLinesData = loadStrings( _selectedCompositionFile );
    println("there are " + _compositionFileLinesData.length + " lines in the provided Epoc Composition file");
  
    readCompositionParameters(); // uses the first lines of the provided 'composition' CSV file to setup the parameters to use within the app (  '_protocolDuration', '_movementsAllowed' ,maybe a bool '_displayIntensity' (..)   )
    resizeArrays(); // resize array before filling themn with the composition data
    getCompositionData(); // get all the lasting lines in the file and use them to fill an array '_compositionData'
    //getCompositionDataBuffered();
    randomizeComposition(); // based on the content fetched from opening the 'composition' CSV file that was written to the '_compositionData' array > shuffles elements
} 

// uses the first lines of the provided 'composition' CSV file to setup the parameters to use within the app (  '_protocolDuration', '_movementsAllowed' ,maybe a bool '_displayIntensity' (..)   )
void readCompositionParameters(){
    
    String[] durationDataLine = split( _compositionFileLinesData[1], "," );
    int compoFrameCountLength = int ( durationDataLine[1] ); // necessary step to cast the value (..)
    _compositionDuration = compoFrameCountLength;
    println(" '_compositionDuration' is " + _compositionDuration);
    
    String[] actionsDataLine = split( _compositionFileLinesData[2], "," );
    _compositionActions = split( actionsDataLine[1], ":" );
    println(" '_compositionActions' contains " + actionsDataLine[1]);
    
    String[] graphDataLine = split( _compositionFileLinesData[3], "," );
    _compositionGraph = graphDataLine[1];
    println(" '_compositionGraph' allowed ? :" + _compositionGraph);
}

// get all the lasting lines in the file and use them to fill an array '_compositionData'
void getCompositionData(){
    println("\n" + "##### Composition Data loaded:  #####" + "\n");
    for (int i = 5 ; i < _compositionFileLinesData.length; i++) {
        
        try {
                //println(_compositionFileLinesData[i]);
                
                String[] compoDataLine = split( _compositionFileLinesData[i], "," );
                println ("Composition DataLine content: " + "Timestamp > " + compoDataLine[0] + " Action > " + compoDataLine[1]);
                _compositionTimestamps[i-5] = int( compoDataLine[0] );
                println(" '_compositionTimestamps[" + (i-5) +"]' >> " + _compositionTimestamps[i-5] );
                _compositionTimedActions[i-5] = compoDataLine[1];
                println(" '_compositionTimedActions[" + (i-5) +"]' >> " + _compositionTimedActions[i-5] );
                println();
                
        } catch(Exception e){
                e.printStackTrace();
        }
        
    }
     println("\n" + "################################" + "\n");
}

void getCompositionDataBuffered(){
    BufferedReader reader = createReader( _selectedCompositionFile );
    String readerLine;
    int lineCounter = 0;
    
    for (int i = 5 ; i < _compositionFileLinesData.length; i++) {
    
        if( lineCounter >= 5 ){
            
            try {
                readerLine = reader.readLine();
            } catch(IOException ioe){
                ioe.printStackTrace();
                readerLine = null;
            }
    
            if( readerLine == null ){
                // stop reading
            } else {
                // do stuff with the data just read
                println( "Line just read:" + readerLine );
                //String[] compoDataLine = split( readerLine[i], "," );
                //_compositionTimestamps[i-5] = int( compoDataLine[0] );
                //_compositionTimedActions[i-5] = compoDataLine[1];
                //println( "Fetched composition data: Timestamp > " + _compositionTimestamps[0] + " >> Action > " + _compositionTimedActions[0] );
            }
          
        }
        lineCounter++;
    
    }
    
}

// based on the content fetched from opening the 'composition' CSV file that was written to the '_compositionData' array > shuffles elements
void randomizeComposition(){
    for (int i =0 ; i < _compositionTimedActions.length; i++) {
        
        if( _compositionTimedActions[i] .equals("ACTION CHANGE") ){
            // do nothing as we only want to give shuffled elements from the '_compositionTimedActions' array if the String corresponding to 'MOVEMENT'
        } else {
            _compositionTimedActions[i] = _compositionActions[ int( random( _compositionActions.length ) ) ];
            println("Composotion SHUFFLED timed action[" + i +"] :" + _compositionTimedActions[i] );
            //int index = int(random(words.length));
        }
        
    }
}

// text data handling & display

// use the 'frameCount' variable & the '_compositionTimestamps' array values to set the '_textToDisplay' variable accordingly
void handleTextAndDisplay(){
    for(int i = 0; i < _compositionTimestamps.length; i++){ // for all the timestamps present in '_compositionTimestamps' array
        if( frameCount == _compositionTimestamps[i] ){ // if a timestamp is set for the same value as the current 'frameCount' value
            _textToDisplay = _compositionTimedActions[i]; // set the '_textToDisplay' variable to the '_compositionTimedAction' corresponding to the '_compositionTimestamp'
            textSize(30);
            textAlign(CENTER);
            text( _textToDisplay, width/2, height/2 ); // display the text to the screen
        } else {
            // keep displaying the same text until a new 'timestamp' value is reached by the 'always-incremented-by-the-loop' 'frameCount' variable
            textSize(30);
            textAlign(CENTER);
            text( _textToDisplay, width/2, height/2 );
        }
    }
    
    // once all the timestamps have been 'used' ( > displayed to user ) ,check when to stop & quit the app
    if( frameCount == _compositionDuration ){ // the '_compositionDuration' value has been reached > quitting application
        delay(3000);
        _textToDisplay = "SESSION ENDED: QUITTING .."; // tell the user that the app is gonna quit & that is it completely normal
        println("SESSION ENDED: QUITTING ..");
        textSize(30);
        textAlign(CENTER);
        text( _textToDisplay, width/2, height/2 ); // display the text to the screen
        closeCSV(); // end writing to the output CSV file
        delay(3000); // delay app exit a little to let the user actually see the 'quitting application' message
        exit(); // quit app
    }
    
}

// Epoc related stuff //
// ------------------ //

void updateEpocValues(){
    
  // '/COG/' part //
  if ( epocTh.cogNeuAvailable() ){ //particular case > wil neder send a value other than 0 (thus, we still got an '/COG/NEUTRAL' osc message coming (..) )
      _valueFromEpoc = epocTh.epocCogNeu; // set sketch value from Epoc thread value > as we can guess from what is displayed in the 'EmoComposer' window, '/COG/NEUTRAL' never sends any other value than O, just its OSC-message
      if ( _valueFromEpoc == 0 ){ // so we can trick/hack/bypass [whatever the right term is ;p] that by checking if it equals 0 (what it 'll surely do), and then set it to 1 (so we have the same nice dreceasing effects as others sliders)
          _valueFromEpoc = 1;
      }
      
      _actionFromEpoc = "/COG/NEUTRAL"; // set sketch '' to the corresponding 'action OSC' (> could be stg else, but as it easier to identify & reuse ) 
      epocTh.cogNeuAvailable = false; // reset th Epoc Thread bool to be able to know when an ACTUALLY new message arrives (..)
      
      // HERE, arrange code so thant when we receive 'neutral', the cube tends to go in the center of the screen (..)      
  } else { // no new data
      // do nothing as all the values receuved from the Epoc get written to the same variables ( '_valueFromEpoc' & '_actionFromEpoc' )
  }
  
  if ( epocTh.cogLeftAvailable() ){ // new data is available from this 'OSC channel'
      _valueFromEpoc = epocTh.epocCogLeft; // set sketch value from Epoc thread value
      _actionFromEpoc = "/COG/LEFT"; // set sketch '' to the corresponding 'action OSC' (> could be stg else, but as it easier to identify & reuse ) 
      epocTh.cogLeftAvailable = false; // reset th Epoc Thread bool to be able to know when an ACTUALLY new message arrives (..)
  } else { // no new data
          //
  }
  
  if ( epocTh.cogRightAvailable() ){
      _valueFromEpoc = epocTh.epocCogRight;
      _actionFromEpoc = "/COG/RIGHT";
      epocTh.cogRightAvailable = false;
  } else {
          //cogRight = 0.0;
  }
  
  if ( epocTh.cogUpAvailable() ){
      _valueFromEpoc = epocTh.epocCogUp;
      _actionFromEpoc = "/COG/LIFT";
      epocTh.cogUpAvailable = false;
  } else {
          //cogUp = 0.0;
  }
  
  if ( epocTh.cogDownAvailable() ){
      _valueFromEpoc = epocTh.epocCogDown;
      _actionFromEpoc = "/COG/DROP";
      epocTh.cogDownAvailable = false;
  } else {
          //cogDown = 0.0;
  }
  
  if ( epocTh.cogPushAvailable() ){
      _valueFromEpoc = epocTh.epocCogPush;
      _actionFromEpoc = "/COG/PUSH";
      epocTh.cogPushAvailable = false;
  } else {
          //cogPush = 0.0;
  }
  
  if ( epocTh.cogPullAvailable() ){
      _valueFromEpoc = epocTh.epocCogPull;
      _actionFromEpoc = "/COG/PULL";
      epocTh.cogPullAvailable = false;
  } else {
          //cogPull = 0.0;
  }
  
  
  if ( epocTh.cogRotLeftAvailable() ){ // new data is available from this 'OSC channel'
      _valueFromEpoc = epocTh.epocCogRotLeft; // set sketch value from Epoc thread value
      _actionFromEpoc = "/COG/ROTATE_LEFT"; // set sketch '' to the corresponding 'action OSC' (> could be stg else, but as it easier to identify & reuse ) 
      epocTh.cogRotLeftAvailable = false; // reset th Epoc Thread bool to be able to know when an ACTUALLY new message arrives (..)
  } else { // no new data
          //cogRotLeft = 0.0;
  }
  
  if ( epocTh.cogRotRightAvailable() ){
      _valueFromEpoc = epocTh.epocCogRotRight;
      _actionFromEpoc = "/COG/ROTATE_RIGHT";
      epocTh.cogRotRightAvailable = false;
  } else {
          //cogRotRight = 0.0;
  }
  
  if ( epocTh.cogRotCWAvailable() ){
      _valueFromEpoc = epocTh.epocCogRotCW;
      _actionFromEpoc = "/COG/ROTATE_CLOCKWISE";
      epocTh.cogRotCWAvailable = false;
  } else {
          //cogRotCW = 0.0;
  }
  
  if ( epocTh.cogRotCCWAvailable() ){
      _valueFromEpoc = epocTh.epocCogRotCCW;
      _actionFromEpoc = "/COG/ROTATE_COUNTER_CLOCKWISE";
      epocTh.cogRotCCWAvailable = false;
  } else {
          //cogRotCCW = 0.0;
  }
  
  if ( epocTh.cogRotForAvailable() ){
      _valueFromEpoc = epocTh.epocCogRotFor;
      _actionFromEpoc = "/COG/ROTATE_FORWARD";
      epocTh.cogRotForAvailable = false;
  } else {
          //cogRotFor = 0.0;
  }
  
  if ( epocTh.cogRotRevAvailable() ){
      _valueFromEpoc = epocTh.epocCogRotRev;
      _actionFromEpoc = "/COG/ROTATE_REVERSE";
      epocTh.cogRotRevAvailable = false;
  } else {
          //cogRotRev = 0.0;
  }
  
  
}
