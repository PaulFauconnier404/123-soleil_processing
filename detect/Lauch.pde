class Launch {  
  
  void Launcher(){
  
    background(255);
    
    textFont(FontCountDown, 100);
    textAlign(CENTER, CENTER);

    text("Lancer le jeu !", (width/2)-300, height/2);
    fill(32,32,32);

    text("Lancer le jeu !", (width/2)-300,(height/2)-7);
    fill(180,180,180);
    
     image(affiche, (width/2)+200, (height/2)-350, 500, 750);

  }





 }//end class 
