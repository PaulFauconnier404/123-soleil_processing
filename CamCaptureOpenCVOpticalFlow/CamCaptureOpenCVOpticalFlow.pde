import processing.video.*;
import gab.opencv.*;
import java.awt.*;

Capture cam_;
OpenCV opencv_;

// Définition format vidéo
int videoWidth_ = 1280;
int videoHeight_ = 720;
// Tableau des frames images de 2
PImage[] frames_ = new PImage[2];
int currentFrameIndex_ = 0;
boolean first_ = true;
int scale_ = 6;
PImage fullFrame_ = new PImage(videoWidth_*scale_,videoHeight_*scale_); // Création de la fullFrame

Flow flow_ = null;
HotSpot[] hotSpots_ = new HotSpot[6];
float flowMagMin_ = 3.0; // Magnitude minimum consignée paramètre de déclenchement de la détection

//============
void setup() {
  
  //fullScreen();
  size(1280,720);

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
    cam_ = new Capture(this, videoWidth_, videoHeight_, "Caméra FaceTime HD (intégrée)", 30);
    
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
    hotSpots_[0] = new HotSpot(x,y,w,h);
    
    x = videoWidth_ / 2 - w / 2;
    hotSpots_[1] = new HotSpot(x,y,w,h);
    
    x = videoWidth_ - m - w;
    hotSpots_[2] = new HotSpot(x,y,w,h);
    
    x = m;
    y = videoHeight_ - m - h;
    hotSpots_[3] = new HotSpot(x,y,w,h);
    
    x = videoWidth_ / 2 - w / 2;
    hotSpots_[4] = new HotSpot(x,y,w,h);
    
    x = videoWidth_ - m - w;
    hotSpots_[5] = new HotSpot(x,y,w,h);
    
    cam_.start();     
  }      
}

//===========
void draw() {
  
  synchronized(this) {
  
    background(0,0,0);
    
    if ( frames_[currentFrameIndex_] != null ) {
      
      //frames_[currentFrameIndex_].resize(640*scale,360*scale); // slow...
      
      frames_[currentFrameIndex_].loadPixels();
      fullFrame_.loadPixels();
      for (int j = 0; j < fullFrame_.height ; j+=2) {
        for ( int i = 0 ; i < fullFrame_.width ; i++ ) {
          int index_src = ( j / scale_ ) * frames_[currentFrameIndex_].width + ( i / scale_ );
          int index_dst = j * fullFrame_.width + i;
          fullFrame_.pixels[index_dst] = frames_[currentFrameIndex_].pixels[index_src];
        }
      }
      fullFrame_.updatePixels();
      
      tint(255, 255, 255, 255);
      image(fullFrame_, 0, 0);
      stroke(255,0,0);
      strokeWeight(1.);
      scale(scale_);
      opencv_.drawOpticalFlow();
      
      noFill(); // Contour rectange seulement
      stroke(0,255,0); // Couleur rectange
      strokeWeight(1.); // Largeur contour rectange
      for ( int i = 0 ; i < 6 ; i++ ) {
        PVector p = flow_.getAverageFlowInRegion(hotSpots_[i].x,hotSpots_[i].y,hotSpots_[i].w,hotSpots_[i].h); // Création des vecteurs avec leur magnitude
        if ( p.mag() > flowMagMin_ ) { // Detection du seuil de la magnitude du vecteur mouvement
          rect(hotSpots_[i].x,hotSpots_[i].y,hotSpots_[i].w,hotSpots_[i].h); // Si oui, création du rectange de détection signalant le mouvement (rapide car traitement de chaque frame)
        }
      }
     
    }
    
    first_ = false;
    
  }
}

//============================
void captureEvent(Capture c) {
  
  synchronized(this) {
    
    c.read();
    opencv_.useColor(RGB);
    //opencv_.useGray();
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
   
}
