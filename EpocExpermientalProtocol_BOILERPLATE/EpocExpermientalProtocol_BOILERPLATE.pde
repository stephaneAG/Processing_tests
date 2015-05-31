/*
    Base of work for the 'Epoc experimetal protocol' project
    this processing app make uses of 'selectOutput()' & 'createWriter()' (..)
    
    Stéphane Adam Garnier - 2012

*/

// -- // imports // -- //

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


// -- // vars // -- //
int appWidth = 600; // i guess I'll use the code for a full screen window overlapping anything (..)
int appHeight = 400;

// debug/wip/tmp vars //
boolean inFirstLoop = true;// used to prevent printing 0's ( > if we were previously using 'beginCSV' in the 'setup()' )
int fakeCounter = 0;

// - // * SETUP * // -- //
void setup(){
    
    // basic setup
    size(appWidth, appHeight);
    frameRate(30);
    textAlign(CENTER);
    
    // request CSV files
    requestComposition(); // request an input CSV composition file | if cancelled, will use a default one
    requestCSV(); // request an output CSV file | if cancelled, will use a default file path
    
    // run appropriate setup(s)
    setupOutputStream();
    handleProvidedComposition();
    
    // writing the headers to the output CSV file
    //beginCSV(); // moved in 'draw()'
    
}

// -- // * DRAW * // -- //
void draw(){
  background(0);
  textSize(32);
  text(frameCount, 30, 30); // debug: print frameCount
  
  if( inFirstLoop ==true ){
      beginCSV();
      inFirstLoop = false;
  }
  
  //if ( fakeCounter >= 10000 ){
  //    // finish the session
  //    closeCSV();
  //} else {
      
      // display the requested actions on the screen / quit the app if the composition duration has been reached
      handleTextAndDisplay();
    
      // write data caming from the headset if available ( > will be done using the 'EpocP5' library ;p )
      // for the moment, just write the mouse position ..
      int theMouseX = mouseX;
      int theMouseY = mouseY;
      int theMouses = theMouseX + theMouseX;
      writeToCSV( "mouse X:" + theMouseX + "," + "mouse Y:" + theMouseY + "," + "here the third param:" + theMouses + "\n" );
      println( "mouse X:" + theMouseX + "," + "mouse Y:" + theMouseY + "," + "here the third param:" + theMouses + "\n"  );
      println("Counter equals:" + fakeCounter);
      fakeCounter++;
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
    _outputStream.println( "INPUT,OUTPUT 1, OUTPUT 2" ); // the top most columns headers
    _outputStream.println( "Requested action,Output value, Output action" ); // the columns sub headers
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
            textSize(20);
            text( _textToDisplay, width/2, height/2 ); // display the text to the screen
        } else {
            // keep displaying the same text until a new 'timestamp' value is reached by the 'always-incremented-by-the-loop' 'frameCount' variable
            textSize(20);
            text( _textToDisplay, width/2, height/2 );
        }
    }
    
    // once all the timestamps have been 'used' ( > displayed to user ) ,check when to stop & quit the app
    if( frameCount == _compositionDuration ){ // the '_compositionDuration' value has been reached > quitting application
        delay(3000);
        _textToDisplay = "SESSION ENDED: QUITTING .."; // tell the user that the app is gonna quit & that is it completely normal
        println("SESSION ENDED: QUITTING ..");
        textSize(20);
        text( _textToDisplay, width/2, height/2 ); // display the text to the screen
        closeCSV(); // end writing to the output CSV file
        delay(3000); // delay app exit a little to let the user actually see the 'quitting application' message
        exit(); // quit app
    }
    
}

