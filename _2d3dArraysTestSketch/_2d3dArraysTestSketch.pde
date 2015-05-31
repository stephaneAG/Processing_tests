import java.net.InetAddress;

void setup(){
  
  // -- // TESTS USING INTS 1D ARRAYS // -- //
  System.out.println("# TESTS USING INTS 1D ARRAYS #");
  System.out.println();
  
  int[] myArray = {0, 1, 2, 3, 4, 5, 6, 7}; // a simple 1 dimension array
  
  System.out.println("Original 1d array");
  for( int i = 0; i < myArray.length; i++ ){
      System.out.print(myArray[i] + " ");
  }
  System.out.print("\n");
  
  int[] myShuffledArray = {0, 1, 2, 3, 4, 5, 6, 7};
  
  for( int i = 0; i < myShuffledArray.length; i++ ){
      int j = int(random(myShuffledArray.length) );
      int tempi = myShuffledArray[i];
      int tempj = myShuffledArray[j];
      
      myShuffledArray[i] = tempj;
      myShuffledArray[j] = tempi;
  }
  
  System.out.println("Shuffled 1d array");
  for( int i = 0; i < myShuffledArray.length; i++ ){
      System.out.print(myShuffledArray[i] + " ");
  }
  System.out.print("\n");
  
  
  // -- // TESTS USING INTS 2D ARRAYS // -- //
  System.out.println("# TESTS USING INTS 2D ARRAYS #");
  System.out.println();
  
  int[][] my2dArray = { {0,1,2,3}, {3,2,1,0}, {3,5,6,1}, {3,8,3,4} };
  
  int[][] myMatrixArray = {  {0, 1, 2, 3},
                     {3, 2, 1, 0},
                     {3, 5, 6, 1},
                     {3, 8, 3, 4}  };
                     
   
   // testing the nested loops (..)
   int dummyInt = 0;
   int cols = 10;
   int rows = 10;
   int[][] myCustomArray = new int[cols][rows];
   int[][] myInvertedArray = new int[rows][cols];

   // Two nested loops allow us to visit every spot in a 2D array.     
   // For every column I, visit every row J.
   for (int i = 0; i < cols; i++) {
       for (int j = 0; j < rows; j++) {
           //myCustomArray[i][j] = 0;
           myCustomArray[i][j] = dummyInt;
           //println(myCustomArray[i][j]);
           dummyInt++;
       }
   }
   
   // traspose the array
   for( int i = 0; i < rows; i++ ){
       for( int j = 0; j < cols; j++ ){
           int temp = myCustomArray[i][j];
           myInvertedArray[i][j] = myCustomArray[j][i];
           myInvertedArray[j][i] = temp; 
       }
   }
   
   
   // 'matrix' prints
   
   // original 2d array
   System.out.println("Original 2d array");
   for (int i = 0; i < myCustomArray.length; i++) {
       for (int j = 0; j < myCustomArray[i].length; j++) {
           System.out.print(myCustomArray[i][j] + " ");
       }
       System.out.print("\n");
   }
   
   println();
   
   // transposed 2d array
   System.out.println("Transposed 2d array");
   for (int i = 0; i < myInvertedArray.length; i++) {
       for (int j = 0; j < myInvertedArray[i].length; j++) {
           System.out.print(myInvertedArray[i][j] + " ");
       }
       System.out.print("\n");
   }
   
   System.out.println();
   System.out.println();
   System.out.println("## Shuffling a 2d array ##");
   System.out.println();
   System.out.println("Original ints 2d array");
   // trying to 'shuffle' a 2d ints array
   int[][] mySuffledMatrixArray = {  {0, 1, 2, 3},
                     {4, 5, 6, 7},
                     {8, 9, 10, 11},
                     {12, 13, 14, 15}  };
  
   for (int i = 0; i < mySuffledMatrixArray.length; i++) {
       for (int j = 0; j < mySuffledMatrixArray[i].length; j++) {
           System.out.print(mySuffledMatrixArray[i][j] + " ");
       }
       System.out.print("\n");
   }
   
   // actually 'shuffle' the array
   /*
   for (int i = 0; i < mySuffledMatrixArray.length; i++) {
       int tmpJ = mySuffledMatrixArray[i].length;
       for (int j = 0; j < mySuffledMatrixArray[i].length; j++) {
           //int k = int(random(myShuffledArray.length) );
           int k = int(random(tmpJ) );
           println("K: " + k);
           //int tempi = myShuffledArray[i][j];
           System.out.println(mySuffledMatrixArray[i][j] + " ");
           int theI = mySuffledMatrixArray[i][j];
           //int tempj = myShuffledArray[i][k];
           int theJ = mySuffledMatrixArray[i][k];
      
           //myShuffledArray[i][j] = tempj;
           //myShuffledArray[i][k] = tempi;
           myShuffledArray[i][j] = theJ;
           myShuffledArray[i][k] = theI;
       }
   }
   */
   
  // 'matrix' prints //
   
   println();
   System.out.println("Shuffled ints 2d array");
   for (int i = 0; i < mySuffledMatrixArray.length; i++) {
       for (int j = 0; j < mySuffledMatrixArray[i].length; j++) {
           System.out.print(mySuffledMatrixArray[i][j] + " ");
       }
       System.out.print("\n");
   }
   
   
   // -- // TESTS USING STRINGS 2D ARRAYS // -- //
   System.out.println();
   System.out.println("# TESTS USING STRINGS 2D ARRAYS #");
   System.out.println();
   
   String[][] myStrMatrixArray = {  {"je", "me", "dis", "souvent"},
                     {"que", "ce", "que", "je"},
                     {"fait", "n'amuse", "que", "moi"},
                     {"mais", "je", "veux", "continuer"}  };
                     
   int strArrayWidth = 0; // will hold the claculated length of the strArray
   
   // calculate maximum length of the srtArray
   for( int i = 0; i < myStrMatrixArray.length; i++ ){
       String[] parts = myStrMatrixArray[i];
       if( parts.length > strArrayWidth ){
           strArrayWidth = parts.length;
       }
   }
   
   String[][] invertedStrArray = new String[strArrayWidth][myStrMatrixArray.length];
   
   // traspose the array
   for( int i = 0; i < strArrayWidth; i++ ){
       for( int j = 0; j < myStrMatrixArray.length; j++ ){
           String temp = myStrMatrixArray[i][j];
           invertedStrArray[i][j] = myStrMatrixArray[j][i];
           invertedStrArray[j][i] = temp; 
       }
   }
   
   // 'matrix' prints //
   
   // original 2d array
   System.out.println("Original 2d array");
   for (int i = 0; i < myStrMatrixArray.length; i++) {
       for (int j = 0; j < myStrMatrixArray[i].length; j++) {
           System.out.print(myStrMatrixArray[i][j] + " ");
       }
       System.out.print("\n");
   }
   
   println();
   
   // transposed 2d array
   System.out.println("Transposed 2d array");
   for (int i = 0; i < invertedStrArray.length; i++) {
       for (int j = 0; j < invertedStrArray[i].length; j++) {
           System.out.print(invertedStrArray[i][j] + " ");
       }
       System.out.print("\n");
   }
  
   // my IP adres ;p
   println();
   println("btw my ip adress:");
   try{
       System.out.println(InetAddress.getLocalHost());
   } catch(Exception e){
       e.printStackTrace();
   }
   
  
}

void draw(){

}
