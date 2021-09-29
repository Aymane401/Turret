import processing.sound.*;

boolean gameover = false; 
SoundFile son;
boolean saveVideo = false;


int cooldown = 0 ;


Vaisseau v;
int Lives = 3 ;
ArrayList<Mover> flock;
int flockSize =7;

boolean debug = false;


ArrayList<Projectile> bullets;
int maxBullets = 10;

void setup() {
  size (1300,800);
  
    son= new SoundFile (this, "sons/smb_bowserfalls.wav");
  bullets = new ArrayList<Projectile>();
  
   currentTime = millis();
  previousTime = millis();
  
  v = new Vaisseau();
  v.location.x = width / 2;
  v.location.y = height / 2;
  
    //fullScreen(P2D);


  flock = new ArrayList<Mover>();
  
  for (int i = 0; i < flockSize; i++) {
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-2, 2), random(-2, 2)));
    m.fillColor = color(random(255), random(255), random(255));
    flock.add(m);
  }

 
  
}

int currentTime;
int previousTime = 0;
int deltaTime;

void draw() {
  
 if (gameover==false)
 {
  textSize(80);
text(Lives, 330, 120); 

  
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;
  
  update(deltaTime);
  render();
  
  
    currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;

  
  update(deltaTime);
  
 
 }
 else 
 {
   fill(255);
     textSize(200);
text("Game Over",280,332); 
 }
  
  
}

PVector thrusters = new PVector(0, -0.02);

float angle = 0;

void update (float deltaTime ) {
  
 if (Lives <= 0 )
 {
    gameover = true;
 
 }
  
  
  
  v.update();
  
      
    textSize(40);
text("Life(s): "+  Lives, 550,80); 
fill(0, 408, 612);

  
  for ( Projectile p : bullets) {
    p.update(deltaTime);
  }
   if (keyPressed) {
    switch (key) {
      case ' ':
        v.thrust();
        break;
      case CODED:
        if (keyCode == LEFT) v.pivote(-.03);
        if (keyCode == RIGHT) v.pivote(.03);
        break;
    }
  }
  
    
  for (Mover m : flock) {
    m.flock(flock);
    m.update(deltaTime);
     collisionCheckVaisseau(v,m,m.r , v.getSize());
  }
  
  v.update(deltaTime);

}

void render() {
  background(0);
    v.display();
  
  for ( Projectile p : bullets) {
    p.display();
  }
  
  v.display();
  
  
  for (Mover m : flock) {
    m.display();
  }
  
}



//Saving frames for video
//Put saveVideo to true;
int savingAcc = 0;
int nbFrames = 0;

void savingFrames(int forMS, int deltaTime) {
  
  if (!saveVideo) return;
  
  savingAcc += deltaTime;
  
  if (savingAcc < forMS) {
    saveFrame("frames/####.tiff");
  nbFrames++;
  } else {
  println("Saving frames done! " + nbFrames + " saved");
    saveVideo = false;
  }
}



void keyReleased() {
    switch (key) {
      case ' ':
        v.noThrust();
        break;
    }  
}
void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
    
    }
  }
  
  if (key == 'p') {
    fire (v);
  }
}

void fire(GraphicObject m) {
  Vaisseau v= (Vaisseau)m;
  
  if (bullets.size() < maxBullets) {
    Projectile p = new Projectile();
    
    p.location = v.getVaisseauTip().copy();
    p.topSpeed = 5;
    p.velocity.x = cos(v.heading-HALF_PI) * p.topSpeed;
        p.velocity.y=  sin(v.heading-HALF_PI) * p.topSpeed;
    p.activate();
    
    bullets.add(p);
  } else {
    for ( Projectile p : bullets) {
      if (!p.isVisible) {
        p.location.x = v.getVaisseauTip().x;
        p.location.y = v.getVaisseauTip().y;
        p.velocity.x = cos(v.heading-HALF_PI) * p.topSpeed;
        p.velocity.y=  sin(v.heading-HALF_PI) * p.topSpeed;
        p.velocity.mult(p.topSpeed);
        p.activate();
        
       
        break;
      }
    }
  }
  
}





boolean collisionCheckVaisseau(GraphicObject g, GraphicObject m, float msize, float gsize) {

    if(PVector.dist(g.location, m.location) < msize + gsize)
    {
      
   
      if (cooldown <= 0 ) 
      {
         son.play();
        cooldown = 1000; 
           Lives--;
      }
   
      return true;
    }
    else { 
  //    v.fill= color (150);
       cooldown -- ;
      return false ;
  
         }
    
     
  
  
}
