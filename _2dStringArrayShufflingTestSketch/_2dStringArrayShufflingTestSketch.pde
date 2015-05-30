/*
*
*    Array Shuffling Test Sketch
*    by Stéphane Adam Garnier - 2012
*
*
*/

String[][] theArray = {
                    {"je", "suis", "tres"},
                    {"content", "lorsque", "mes"},
                    {"algorithmes", "marchent", "correctement"}
                    };
//int theArrayLen = theArray.length; // [n] members, starting at 0
                    
void setup(){
  
    // print out to the console the current 'look' of our 2d int array
    printArrayAsMatrix( theArray );
    
    // loop through theArray and shuffle the elements (int values)
    for( int i = 0; i < theArray.length; i++ ){ // for all indexes in the 'Column' indexes array
        
        //int currColIndexLen = theArray[i].length; // length of the current index's array ( again, [n] members, starting at 0 )
        
        for( int j = 0; j < theArray[i].length; j++ ){ // for each int value element in the current index's array
            
            String tempCurrString = theArray[i][j]; // hold the original int at [n][n]
            
            int randColIndex = int( random( theArray.length ) ); // the random column index [i]
            int randRowIndex = int( random( theArray[i].length ) ); // the random row index [j]
            //int randRowIndex = int( random( theArrayLen ) ); // the random row index [j]
            
            String tempRandString = theArray[ randColIndex ][ randRowIndex ]; // hold the randomly found int at [random i][random j]
            
            // actually swap the values respectively held by the array's elements in the two previous different indexes
            theArray[i][j] = tempRandString; // replace the current element's value with the random element'one
            theArray[ randColIndex ][ randRowIndex ] = tempCurrString; // replace a random element's value with the current element'one
            
        }
        
    }
    
    
    // print out to the console the current 'look' of our 2d int array
    printArrayAsMatrix( theArray );
  
}

void draw(){
    
}

// fcn that print out the array to the console //

void printArrayAsMatrix(String[][] int2dArray  ){
    System.out.println();
    System.out.println("### INT 2D ARRAY ###");
    System.out.println();
    
    for(int i = 0; i < int2dArray.length; i++ ){
        for( int j = 0; j < int2dArray[i].length; j++ ){
            System.out.print(int2dArray[i][j] + " ");
        }
        System.out.println("\n");
    }
    
    
    System.out.println();
    System.out.println("### END INT 2D ARRAY ###");
    System.out.println();
}
