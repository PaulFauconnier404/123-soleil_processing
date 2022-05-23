class Timer {

  int indexAudio = 0;
  
  
  void countDown(){
    
    
    
    background(255);


    //Changement des attributs chaque secondes
    if(time > tmpTime +1000){
      tmpTime = time; 
            
  
       switch(indexAudio) {
          case 0: 
                      un.rewind(); // xDoes not execute

            un.play(); // xDoes not execute
            break;
          case 1: 
            deux.play();  // Does not execute
            break;
          case 2: 
            trois.play();  // Does not execute
            break;
          case 3: 
            soleil.play();  // Does not execute
            break;
       }
       
       if(indexText<4){
        
        indexAudio = indexAudio +1;
            deux.rewind();  // Does not execute
            trois.rewind();  // Does not execute
            soleil.rewind();  // Does not execute
        if(indexText<=4){
        indexText = indexText+1;
        }
      }
      sizeToReturn = 100;
    }
    
    //Font du texte
    textFont(FontCountDown, growText());
  
    //Positionnement du texte
    text(valueToDisplay[indexText], width/2, height/2);
    fill(32,32,32);
  
    textAlign(CENTER, CENTER);
    
    //Positionnement de l'ombre
    text(valueToDisplay[indexText], (width/2), (height/2)-7 );
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
