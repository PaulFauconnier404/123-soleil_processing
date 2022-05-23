class Timer {

  int indexAudio = 0;
  
  
  void countDown(){
    un = minim.loadFile("data/music/1.mp3");
    deux = minim.loadFile("data/music/2.mp3");
    trois = minim.loadFile("data/music/3.mp3");
    soleil = minim.loadFile("data/music/Soleil.mp3");
    
    
    background(255);


    //Changement des attributs chaque secondes
    if(time > tmpTime +1000){
      tmpTime = time; 
      
   
       switch(indexAudio) {
          case 0: 
            un.rewind();  // Does not execute
            un.play(); // Does not execute
            break;
          case 1: 
            deux.rewind();  // Does not execute
            deux.play();  // Does not execute
            break;
          case 2: 
            trois.rewind();  // Does not execute
            trois.play();  // Does not execute
            break;
          case 3: 
            soleil.rewind(); 
            soleil.play();  // Does not execute
            break;
       }
       
       if(indexText<3){
        
        indexAudio = indexAudio +1;
        
        indexText = indexText+1;
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
