class Timer {

void countDown(){
    
    
    
    background(255);


    //Changement des attributs chaque secondes
    if(time > tmpTime +1000){
      tmpTime = time; 


       switch(indexAudio) {
          case 0: 
            un.rewind(); 
            un.play(); 
            break;
          case 1:             
            deux.rewind();
            deux.play();
            break;
          case 2: 
            trois.rewind();
            trois.play();
            break;
          case 3: 
            soleil.rewind();
            soleil.play();
            break;
       }
       
       if(indexText<4){
        
        indexAudio = indexAudio +1;

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
