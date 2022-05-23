class Timer {
AudioPlayer un, deux, trois, soleil;
AudioPlayer[] track123;

  void countDown(){
    un = minim.loadFile("data/music/123Soleil.mp3");
    deux = minim.loadFile("data/music/123Soleil.mp3");
    trois = minim.loadFile("data/music/123Soleil.mp3");
    soleil = minim.loadFile("data/music/123Soleil.mp3");
    
    track123 = new AudioPlayer[un, deux, trois, soleil];
    
    background(255);


    //Changement des attributs chaque secondes
    if(time > tmpTime +1000){
      tmpTime = time; 
                

      track123.play();

      if(indexText<3){
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
