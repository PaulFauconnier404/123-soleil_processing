class Timer {

  void countDown(){
    background(255);
    //Changement des attributs chaque secondes
    if(time > tmpTime +1000){
      tmpTime = time; 
      
      if(indexText<3){
        indexText = indexText+1;
      }
      
      sizeToReturn = 100;
    }
    
    //Font du texte
    textFont(FontCountDown, growText());
  
    //Positionnement du texte
    text(valueToDisplay[indexText], windowHeight_/2, windowWidth_/2);
    fill(32,32,32);
  
    textAlign(CENTER, CENTER);
    
    //Positionnement de l'ombre
    text(valueToDisplay[indexText], (windowHeight_/2), (windowWidth_/2)-7 );
    fill(180,180,180);
     
  
    
  }
  
  // Fonction dédié à agrandir le texte
  int growText() {  
    if (sizeToReturn < 200){
        sizeToReturn = sizeToReturn + 1; 
        return sizeToReturn;
    }else{
        return sizeToReturn;
    }
  }




 }//end class 
