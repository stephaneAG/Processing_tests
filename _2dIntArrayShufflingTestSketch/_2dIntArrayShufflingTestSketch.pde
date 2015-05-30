/*
*
*    Array Shuffling Test Sketch
*    by Stéphane Adam Garnier - 2012
*
*
*/

int[][] theArray = {
                    {1, 2, 3},
                    {4, 5, 6},
                    {7, 8, 9}
                    };
int theArrayLen = theArray.length; // [n] members, starting at 0
                    
void setup(){
  
    // print out to the console the current 'look' of our 2d int array
    printArrayAsMatrix( theArray );
    
    // loop through theArray and shuffle the elements (int values)
    for( int i = 0; i < theArrayLen; i++ ){ // for all indexes in the 'Column' indexes array
        
        int currColIndexLen = theArray[i].length; // length of the current index's array ( again, [n] members, starting at 0 )
        
        for( int j = 0; j < currColIndexLen; j++ ){ // for each int value element in the current index's array
            
            int tempCurrInt = theArray[i][j]; // hold the original int at [n][n]
            
            int randColIndex = int( random( theArrayLen ) ); // the random column index [i]
            int randRowIndex = int( random( theArrayLen ) ); // the random row index [j]
            
            int tempRandInt = theArray[ randColIndex ][ randRowIndex ]; // hold the randomly found int at [random i][random j]
            
            // actually swap the values respectively held by the array's elements in the two previous different indexes
            theArray[i][j] = tempRandInt; // replace the current element's value with the random element'one
            theArray[ randColIndex ][ randRowIndex ] = tempCurrInt; // replace a random element's value with the current element'one
            
        }
        
    }
    
    
    // print out to the console the current 'look' of our 2d int array
    printArrayAsMatrix( theArray );
  
}

void draw(){
    
}

// fcn that print out the array to the console //

void printArrayAsMatrix(int[][] int2dArray  ){
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
