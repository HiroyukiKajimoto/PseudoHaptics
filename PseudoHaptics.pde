
final int WINDOWX=1200, WINDOWY=800;
PImage cursor,bump;
int[][] img = new int[WINDOWY][WINDOWX];
final int MODE_NUM = 6;
int mode = 0;
String[] imgFiles = {"Bumps1.jpg","Bumps2.jpg","Bumps3.jpg","Pencils.jpg","Fish.jpg","Sushi.jpg"};

PVector CursorPos = new PVector(0,0);
PVector Force = new PVector(0,0);
PVector Accel = new PVector(0,0);
PVector Velocity = new PVector(0,0);
PVector Distance = new PVector(0,0);
float KSpring = 1.0, KDamper = 0.5, Mass = 1.0,KGradient=4.0,dT=0.5;


void settings(){
  size(WINDOWX, WINDOWY);
}


void initImage(){
  int x,y,r,g,b,v;

  bump = loadImage(imgFiles[mode]);
  bump.loadPixels();
  for (y = 0; y < WINDOWY; y++) {
    for (x = 0; x < WINDOWX; x++) {
      v = bump.pixels[y*WINDOWX + x];
      r = (v & 0x00ff0000) >> 16;
      g = (v & 0x0000ff00) >> 8;
      b =  v & 0x000000ff;
      img[y][x] = (int)(0.2126 * (float)r + 0.7152 * (float)g + 0.0722 * (float)b);
    }
  }
}

void setup() {
  background(0);   
  cursor = loadImage("cursor.gif");
  initImage();
  frameRate(60);
  noCursor();
}


void draw() {
  int x,y;
  float distance;
  background(0);
  image(bump, 0,0);

  PVector MousePos = new PVector(mouseX,mouseY);
  //Calculate gradient
  PVector Gradient = new PVector(0,0);
  if((int)CursorPos.x > 0 && (int)CursorPos.x < WINDOWX-1 && (int)CursorPos.y > 0 && (int)CursorPos.y < WINDOWY-1){
    Gradient.x = img[(int)CursorPos.y][(int)CursorPos.x+1] - img[(int)CursorPos.y][(int)CursorPos.x-1];
    Gradient.y = img[(int)CursorPos.y+1][(int)CursorPos.x] - img[(int)CursorPos.y-1][(int)CursorPos.x];
  }
  //println(Gradient.x+","+Gradient.y);
  Distance = PVector.sub(MousePos,CursorPos);
  if(Distance.mag() >100){
    CursorPos = MousePos;
  }else{
    Force = PVector.add(Distance.mult(KSpring),Velocity.mult(-KDamper)); 
    Force.add(Gradient.mult(-KGradient));
    Accel = Force.div(Mass);
    Velocity = PVector.add(Velocity, Accel.mult(dT));
    CursorPos = PVector.add(CursorPos,Velocity.mult(dT));
   // println(Force.x+","+Accel.x+","+Velocity.x+","+CursorPos.x);
  }
  image(cursor, (int)CursorPos.x, (int)CursorPos.y);
  //println(frameRate);
}

void keyPressed() {
  if(key == 'm'){
    mode = (mode + 1) % MODE_NUM; //0,1,2,3,4,0,1,2,3,...
    initImage();
  }
    
}
