import processing.video.*;
import gab.opencv.*;
import java.awt.*;
import lord_of_galaxy.timing_utils.*;
import ddf.minim.*;

Minim minim;
AudioPlayer detect, ambiance;
AudioPlayer un, deux, trois, soleil;

Boolean gameStart = false;

Capture cam_;
OpenCV opencv_;

Stopwatch s;//Declare

// Définition format vidéo
// Valeures par défaut : H: 180 W: 320
int indexAudio = 0;

float speed = 1.2;
float value = 0.0;
int MAX = 255;
int counter = 0;
int videoWidth_ = 300;
int videoHeight_ = 180;
// Tableau des frames images de 2
PImage[] frames_ = new PImage[2];
int currentFrameIndex_ = 0;
boolean first_ = true;
int scale_ = 6;
PImage fullFrame_ = new PImage(videoWidth_*scale_, videoHeight_*scale_); // Création de la fullFrame

Flow flow_ = null;
HotSpot[] hotSpots_ = new HotSpot[6];
float flowMagMin_ = 0.45; // Magnitude minimum consignée paramètre de déclenchement de la détection

//Creation de shape
PShape H0;
PShape H1;
PShape H2;
int lifeCircle = 0;

//Initiatialisation des variables 
int indexText, time, tmpTime, tmpTimeMain;
int sizeToReturn = 100;

String[] valueToDisplay = {"1","2","3", "Soleil"};
PFont FontCountDown;


Timer T1 = new Timer();
Loose L1 = new Loose();
Launch LA1 = new Launch();
PointLoose P1 = new PointLoose();

//============
void setup() {
  //Creating a stopwatch to keep time
  s = new Stopwatch(this);
  
  
  
  minim = new Minim(this);
  detect = minim.loadFile("data/music/Unlock.mp3");
  ambiance = minim.loadFile("data/music/moodSong.mp3");
  ambiance.setGain(-10);
  detect.setGain(16);
  ambiance.loop();
  
  
  //Start the stopwatch
  s.start();
  smooth();

  fullScreen();
  // Ajouter les mêmes valeurs que les variables videoWidth_ et videoHeight_ dans les paramètres de size()
  //size(1280,720);
  H0 = loadShape("data/coeur.svg");
  H1 = loadShape("data/coeur.svg");
  H2 = loadShape("data/coeur.svg");

  un = minim.loadFile("data/music/1.mp3");
  deux = minim.loadFile("data/music/2.mp3");
  trois = minim.loadFile("data/music/3.mp3");
  soleil = minim.loadFile("data/music/Soleil.mp3");

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an
    // element from the array returned by list():
    cam_ = new Capture(this, videoWidth_, videoHeight_, cameras[0], 30);

    opencv_ = new OpenCV(this, videoWidth_, videoHeight_); // Création de l'objet OpenCV qui prend en paramètre les mensuration de la vidéo

    flow_ = opencv_.flow; // Init nécéssaire au fonctionnement d'OpticalFlow d'OpenCV
    // Def des paramètres
    flow_.setPyramidScale(0.5); // default : 0.5
    flow_.setLevels(1); // default : 4
    flow_.setWindowSize(8); // default : 8
    flow_.setIterations(1); // default : 2
    flow_.setPolyN(3); // default : 7
    flow_.setPolySigma(1.5); // default : 1.5

    int m = 10;
    int w = 90;
    int h = 70;

    int x = m;
    int y = m;
    // Définition des pointsChauds dans l'espace vectoriel
    hotSpots_[0] = new HotSpot(x, y, w, h);

    x = videoWidth_ / 2 - w / 2;
    hotSpots_[1] = new HotSpot(x, y, w, h);

    x = videoWidth_ - m - w;
    hotSpots_[2] = new HotSpot(x, y, w, h);

    x = m;
    y = videoHeight_ - m - h;
    hotSpots_[3] = new HotSpot(x, y, w, h);

    x = videoWidth_ / 2 - w / 2;
    hotSpots_[4] = new HotSpot(x, y, w, h);

    x = videoWidth_ - m - w;
    hotSpots_[5] = new HotSpot(x, y, w, h);

    cam_.start();
  }
  
  FontCountDown = createFont("data/Oleo_Script/OleoScript-Regular.ttf", 100);
  tmpTimeMain = 0;
  indexText = 0;
}

//===========
void draw() {

    time = millis();



    if(lifeCircle >= 3 && gameStart == true){
       L1.Looser();
    }
    if(gameStart == false){
      LA1.Launcher();
    }
    
   if(time > tmpTimeMain +5000 && time < tmpTimeMain +5100 && gameStart == true){
     indexText = 0;

   }
   if(time > tmpTimeMain +5000 && time < tmpTimeMain +9000 && lifeCircle < 3 && gameStart == true){ 
            
     T1.countDown();

   }else if (lifeCircle < 3 && gameStart == true){
      indexAudio = 0;
      Detection();
     
   }
   if(time > tmpTimeMain +9000 && gameStart == true){
      tmpTimeMain = time; 

   }
                 

}

void Detection(){

  synchronized(this) {


    if ( frames_[currentFrameIndex_] != null ) {

      //frames_[currentFrameIndex_].resize(640*scale,360*scale); // slow...

      frames_[currentFrameIndex_].loadPixels();
      fullFrame_.loadPixels();
      for (int j = 0; j < fullFrame_.height; j+=2) {
        for ( int i = 0; i < fullFrame_.width; i++ ) {
          int index_src = ( j / scale_ ) * frames_[currentFrameIndex_].width + ( i / scale_ );
          int index_dst = j * fullFrame_.width + i;
          fullFrame_.pixels[index_dst] = frames_[currentFrameIndex_].pixels[index_src];
        }
      }
      fullFrame_.updatePixels();

      tint(255, 255, 255, 255);
      image(fullFrame_, 0, 0);
      stroke(255, 0, 0);
      strokeWeight(1.);
      scale(scale_);
      //opencv_.drawOpticalFlow();

      noFill(); // Contour rectange seulement
      stroke(0, 255, 0); // Couleur rectange
      strokeWeight(1.); // Largeur contour rectange
      for ( int i = 0; i < 6; i++ ) {
        PVector p = flow_.getAverageFlowInRegion(hotSpots_[i].x, hotSpots_[i].y, hotSpots_[i].w, hotSpots_[i].h); // Création des vecteurs avec leur magnitude
        if ( p.mag() > flowMagMin_ ) { // Detection du seuil de la magnitude du vecteur mouvement
          //
          counter ++;
          String message = "Attention !";
          textSize(20);
          fill(255, 255, 255);
          textAlign(CENTER, CENTER);
          text(message, 160, 60);
          noFill();
          // For log purposes
          print("The subject has moved \n");
          // For log purposes
          rect(hotSpots_[i].x, hotSpots_[i].y, hotSpots_[i].w, hotSpots_[i].h); // Si oui, création du rectange de détection signalant le mouvement (rapide car traitement de chaque frame)
        }
      }
      int standard = (width/2)-100;
      //Draw hearts (Coeur, ecart gauche a droite, hauteur, taille)
      shape(H0, videoWidth_-20, 10, 15, 15);
      shape(H1, videoWidth_-40, 10, 15, 15);
      shape(H2, videoWidth_-60, 10, 15, 15);
    }
    first_ = false;
  }

  if ( counter >= 100) {
    detect.rewind();
    detect.play();
    fill(255, 255, 255);
    
    
    for ( int i = 0; i < 1000; i++ ) {
              P1.Point();

        }

    
    counter=0;
    
    if(lifeCircle == 0){
      H2.setVisible(false);
      
    }
    if(lifeCircle == 1){
      H1.setVisible(false);
    }
    if(lifeCircle == 2){
      H0.setVisible(false);
    }
    lifeCircle++;
  }
  // User Dashboard
  fill(255, 255, 255);
  noFill();
  stroke(#1560a5);
  strokeWeight(0.6);
  rect(6, 7.6, 108, 15.6, 2);
  String detectionevel = "Seuil de détection : ";
  fill(255, 255, 255);
  textSize(10);
  textAlign(LEFT, BOTTOM);
  text(detectionevel, 10, 22);
  text(counter, 91, 22);
  text("%", 103, 22);
  //Use s.time() to get current time in milliseconds
  textSize(7);
 
}

//============================
void captureEvent(Capture c) {

  synchronized(this) {

    c.read();
    opencv_.useColor(RGB);
    opencv_.useGray();
    opencv_.loadImage(cam_);
    opencv_.flip(OpenCV.HORIZONTAL);
    opencv_.calculateOpticalFlow();

    frames_[currentFrameIndex_] = opencv_.getSnapshot();
  }
}

//=================
void keyPressed() {
  if ( (keyCode == ESC) || ( keyCode == 'q' ) || ( keyCode == 'Q' )) {
    cam_.stop();
    exit();
  }
  switch(key) {
    case 'v':
      gameStart = true;
    break;
  case 'p':
    if (!s.isPaused()) {
      s.pause();//Check if the stopwatch is paused. Pause the stopwatch
      println("StopWatch is now paused...");
    } else s.start();//Resuming the stopwatch is also done by start
    break;
  case 'r':
    s.restart();//Restart the stopwatch and the game
    println("Game restarted...");
    counter = 0;
    break;
  case 'h':
    H0.setVisible(true);
    H1.setVisible(true);
    H2.setVisible(true);
    lifeCircle = 0;
    break;
  case ' ':
    s.reset();//Reset the stopwatch to zero, but don't start it yet
    background(255);
    println("Game reset...");
    counter = 0;
    break;
  default:
    println("Press 'P' to pause/resume, 'R' to restart and SPACEBAR to reset");
  }
}





void stop() {
  minim.stop();
  super.stop();
}
