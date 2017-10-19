//   /// //<>//
import unlekker.modelbuilder.*; //<>//
import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5; //object to convert data into osc format
NetAddress myRemoteLocation; //address to be used to send osc data to max

PWindow win;

public void settings() {
  size(800, 800, P3D);

}



UGeometry model; //Object for 3d model created

int attention; //This value is non-zero when in use by a person
int meditation;
int numSamples = 60; //takes in 60 samples from mindwave before displaying
boolean togglevar=true; //variable to initiate file creation only when headset is put on
boolean currentvar=true; //variable's value is checked before the headset data starts to log
String fname; //file name is saved in this variable for stl file as well as the csv file

int delta_; //variable where value of delta from the eegEvent is saved
int theta_; //variable where value of theta from the eegEvent is saved
int low_alpha_; //variable where value of low_alpha from the eegEvent is saved
int high_alpha_; //variable where value of high_alpha from the eegEvent is saved
int low_beta_; //variable where value of low_beta from the eegEvent is saved
int high_beta_; //variable where value of high_beta from the eegEvent is saved
int low_gamma_; //variable where value of low_gamma from the eegEvent is saved
int mid_gamma_; //variable where value of mid_gamma from the eegEvent is saved
int attention_;
int meditation_;

double sum_of_delta = 0;
double sum_of_theta = 0;
double sum_of_low_alpha = 0;
double sum_of_high_alpha = 0;
double sum_of_low_beta = 0;
double sum_of_high_beta = 0;
double sum_of_low_gamma = 0;
double sum_of_mid_gamma = 0;
double sum_of_attention = 0;

int    count_of_all  = 0;
float delta_mapped; //mapped value of delta to be used for 3d model creation
float theta_mapped; //mapped value of theta to be used for 3d model creation
float low_alpha_mapped; //mapped value of low_alpha to be used for 3d model creation
float high_alpha_mapped; //mapped value of high_alpha to be used for 3d model creation
float low_beta_mapped; //mapped value of low_beta to be used for 3d model creation
float high_beta_mapped; //mapped value of high_beta to be used for 3d model creation
float low_gamma_mapped; //mapped value of low_gamma to be used for 3d model creation
float mid_gamma_mapped; //mapped value of mid_gamma to be used for 3d model creation

double delta_ave; //mapped value of delta to be used for 3d model creation
double theta_ave; //mapped value of theta to be used for 3d model creation
double low_alpha_ave; //mapped value of low_alpha to be used for 3d model creation
double high_alpha_ave; //mapped value of high_alpha to be used for 3d model creation
double low_beta_ave; //mapped value of low_beta to be used for 3d model creation
double high_beta_ave; //mapped value of high_beta to be used for 3d model creation
double low_gamma_ave; //mapped value of low_gamma to be used for 3d model creation
double mid_gamma_ave; //mapped value of mid_gamma to be used for 3d model creation
double attention_ave; 

PrintWriter output; //output file instance created for the csv file
int baseProportion;//3d model parameter
int wallThickness; //3d model parameter
int gridSize; //3d model parameter
ArrayList attSamples, medSamples; //

void setup() {

  win = new PWindow();
  attSamples = new ArrayList();
  baseProportion = 100;
  wallThickness = 20;
  gridSize = 3;

  oscP5 = new OscP5(this,7400);
  mindSet = new MindSet(this, "COM17"); //needs to be set to whichever COM port the mindest is communicating to
  myRemoteLocation = new NetAddress("127.0.0.1",7400);

}

void draw() {
  background(0);
  fill(255);
    text((float)delta_ave, 600,600);
    text((float)theta_ave, 600,620);
    text((float)low_alpha_ave, 600,640);
    text((float)high_alpha_ave, 600,660);
    text((float)low_beta_ave, 600,680);
    text((float)high_beta_ave, 600,700);
    text((float)low_gamma_ave, 600,720);
    text((float)mid_gamma_ave, 600,740);
    text((float)attention_ave, 600,760);
  //print("ATTENTION 0  "); 
  //println(attention); //outputs attention value

if(togglevar==true)
{
  if(attention==0)
  {
  //togglevar=false;
  currentvar=false; //data is not written to file when this variable is false
  }
}
if(attention!=0)
{
build(); //3d model is built
if(togglevar==true)
{
createdatafile();
}
togglevar=false;
currentvar=true; //data is written to file when this is true
 //else {return;}
  // rotate the canvas when the mouse moves
  rotateX(map(mouseY, 0, height, -PI/2, PI/2)); 
  rotateY(map(mouseX, 0, width, -PI/2, PI/2));
  // start in the middle
  translate(width/2, height/2, 0);
  model.draw(this);
  //Data is being sent to Max in the following instruction
 //Use either one of the following two instructions at a time for sending data to max instructions
   OscMessage myMessage = new OscMessage(str(delta_mapped) + ", " + str(theta_mapped) + ", " + str(low_alpha_mapped) + ", " + str(high_alpha_mapped) + ", " + str(low_beta_mapped) + ", " + str(high_beta_mapped) + ", " + str(low_gamma_mapped) + ", " + str(mid_gamma_mapped) + ", " + str(attention_));//, , ); 
  //OscMessage myMessage = new OscMessage(str((float)delta_ave) + ", " + str((float)theta_ave) + ", " + str((float)low_alpha_ave) + ", " + str((float)high_alpha_ave) + ", " + str((float)low_beta_ave) + ", " + str((float)high_beta_ave) + ", " + str((float)low_gamma_ave) + ", " + str((float)mid_gamma_ave) + ", " + str((float)attention_ave));//, , );
  
  oscP5.send(myMessage, myRemoteLocation);
  print("data to max: ");
  println(str(delta_mapped) + ", " + str(theta_mapped) + ", " + str(low_alpha_mapped) + ", " + str(high_alpha_mapped) + ", " + str(low_beta_mapped) + ", " + str(high_beta_mapped) + ", " + str(low_gamma_mapped) + ", " + str(mid_gamma_mapped) + ", " + str(attention_));
}

  if(attention!=0)
{
 
return;
  }
else
  {
  if(currentvar==true)
  {
    
  togglevar=true; 
  model.writeSTL(this, fname + ".stl");
    println("STL written");
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    sum_of_delta = 0;
sum_of_theta = 0;
sum_of_low_alpha = 0;
sum_of_high_alpha = 0;
sum_of_low_beta = 0;
sum_of_high_beta = 0;
sum_of_low_gamma = 0;
sum_of_mid_gamma = 0;
sum_of_attention = 0;
count_of_all=0;
  }
}

}
 
  

//Function that is called by build() function
void drawPyramid(int pyrSize, float peakAngle) {  
  // the pyramid has 4 sides, each drawn as a separate triangle made of 3 vertices

  float peak = pyrSize * tan(radians(peakAngle)); // where in space it should go based on the angle
  UVec3 peakPt = new UVec3(0, 0, peak); // top of the pyramid

  // four corners
  UVec3 ptA = new UVec3(-pyrSize, -pyrSize, 0);
  UVec3 ptB = new UVec3(pyrSize, -pyrSize, 0);
  UVec3 ptC = new UVec3(pyrSize, pyrSize, 0);
  UVec3 ptD = new UVec3(-pyrSize, pyrSize, 0);

  UVec3[][] faces = {{ptA, ptB, peakPt}, 
    {ptB, ptC, peakPt}, 
    {ptC, ptD, peakPt}, 
    {ptD, ptA, peakPt}};

  model.beginShape(TRIANGLES);
  for (int i = 0; i < faces.length; i++) {
    model.addFace(faces[i]);
  }
  model.endShape();
}

//Function that is called by build() function
void drawBase() {
  // base is made of 4 rectangles that cap off the bottoms of the pyramids, connecting the inner and the outer

  UGeometry[] rectangles = {UPrimitive.rect(baseProportion, wallThickness), 
    UPrimitive.rect(baseProportion, wallThickness), 
    UPrimitive.rect(wallThickness, baseProportion), 
    UPrimitive.rect(wallThickness, baseProportion)};

  // UPrimitive's rectangles only take a width and a height, so to position them in space we need to translate                   
  UVec3 positions[] = {new UVec3(0, -baseProportion + wallThickness, 0), 
    new UVec3(0, baseProportion - wallThickness, 0), 
    new UVec3(baseProportion - wallThickness, 0, 0), 
    new UVec3(-baseProportion + wallThickness, 0, 0)};

  for (int i = 0; i < rectangles.length; i++) {
    rectangles[i].translate(positions[i]);
    model.add(rectangles[i]);
  }
}

int gridOffset(int d) {
  return (baseProportion - wallThickness * 2) * 2 * d;
}

void build() {
  model = new UGeometry();
  for (int x = 0; x < gridSize; x++) {
    for (int y = 0; y < gridSize; y++) {
   
      //values for delta, theta, alpha and gamma is being passed to the 3d model script here through the global variables created i.e. delta_ etc.
      float[] peakAngle = {(((float)delta_ave)*0.2), (((float)theta_ave)*0.2), (((float)low_alpha_ave)*0.5), (((float)high_alpha_ave)*0.5), (((float)low_beta_ave)*0.5), (((float)high_beta_ave)*0.5), (((float)low_gamma_ave)*0.5), (((float)mid_gamma_ave)*0.2), (((float)attention_ave))};//random(25, 65); // steepness of the pyramd
      model.translate(gridOffset(x), gridOffset(y), 0);
      drawPyramid(baseProportion, peakAngle[x+y]); // outer pyramid
      drawPyramid(baseProportion - (wallThickness * 2), peakAngle[x+y]); // inner
      drawBase();
      model.translate(gridOffset(-x), gridOffset(-y), 0); // reset it back to the center
    }
  }
}

public void keyPressed() {
    exit(); // Stops the program 
}


public void eegEvent(int delta, int theta, int low_alpha, 
  int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
  print(delta);
  print(", ");
  print(theta);
  print(", ");
  print(low_alpha);
  print(", ");
  print(high_alpha);
  print(", ");
  print(low_beta);
  print(", ");
  print(high_beta);
  print(", ");
  print(low_gamma);
  print(", ");
  println(mid_gamma);
  print(", ");

if(attention!=0 && currentvar==true){
  output.print(day()+ "." + month()+ "." +year()+ "_"+ hour()+ "." + minute()+ "." + second() + "\t"); //prints time and date in column 1 of the csv file
  output.print(delta + "\t");
  output.print(theta + "\t");
  output.print(low_alpha + "\t");
  output.print(high_alpha + "\t");
  output.print(low_beta + "\t");
  output.print(high_beta + "\t");
  output.print(low_gamma + "\t");
  output.print(mid_gamma + "\t");
  output.print(attention_);
  
  output.print(delta_ave + "\t");
  output.print(theta_ave + "\t");
  output.print(low_alpha_ave + "\t");
  output.print(high_alpha_ave + "\t");
  output.print(low_beta_ave + "\t");
  output.print(high_beta_ave + "\t");
  output.print(low_gamma_ave + "\t");
  output.print(mid_gamma_ave + "\t");
  output.println(attention_ave);
  
  
  
  
  //stores the values in global variables




//mapped values to be used for 3d model
delta_mapped=(map(float(delta), 150,4600000,0,1000));
delta_mapped=upperlimit(delta_mapped);
theta_mapped=(map(float(theta), 150,2200000,0,1000));
theta_mapped=upperlimit(theta_mapped);
low_alpha_mapped=(map(float(low_alpha), 100,740000,0,1000));
low_alpha_mapped=upperlimit(low_alpha_mapped);
high_alpha_mapped=(map(float(high_alpha), 100,640000,0,1000));
high_alpha_mapped=upperlimit(high_alpha_mapped);
low_beta_mapped=(map(float(low_beta), 100,470000,0,1000));
low_beta_mapped=upperlimit(low_beta_mapped);
high_beta_mapped=(map(float(high_beta), 100,810000,0,1000));
high_beta_mapped=upperlimit(high_beta_mapped);
low_gamma_mapped=(map(float(low_gamma), 100,560000,0,1000));
low_gamma_mapped=upperlimit(low_gamma_mapped);
mid_gamma_mapped=(map(float(mid_gamma), 150,2600000,0,1000));
mid_gamma_mapped=upperlimit(mid_gamma_mapped);
if(delta_mapped-(sum_of_delta/count_of_all)<200)
{sum_of_delta += delta_mapped;}
else
{sum_of_delta += 100;}
if(theta_mapped-(sum_of_theta/count_of_all)<200)
{sum_of_theta += theta_mapped;}
else
{sum_of_theta +=100;}
if(low_alpha_mapped-(sum_of_low_alpha/count_of_all)<200)
{sum_of_low_alpha += low_alpha_mapped;}
else
{sum_of_low_alpha +=100;}
if(high_alpha_mapped-(sum_of_high_alpha/count_of_all)<200)
{sum_of_high_alpha += high_alpha_mapped;}
else
{sum_of_high_alpha +=100;}
if(low_beta_mapped-(sum_of_low_beta/count_of_all)<200)
{sum_of_low_beta += low_beta_mapped;}
else
{sum_of_low_beta +=100;}
if(high_beta_mapped-(sum_of_high_beta/count_of_all)<200)
{sum_of_high_beta += high_beta_mapped;}
else
{sum_of_high_beta +=100;}
if(low_gamma_mapped-(sum_of_low_gamma/count_of_all)<200)
{sum_of_low_gamma += low_gamma_mapped;}
else
{sum_of_low_gamma +=100;}
if(mid_gamma_mapped-(sum_of_mid_gamma/count_of_all)<200)
{sum_of_mid_gamma += mid_gamma_mapped;}
else
{sum_of_mid_gamma +=100;}

count_of_all++;

delta_=delta;
theta_=theta;
low_alpha_=low_alpha;
high_alpha_=high_alpha;
low_beta_=low_beta;
high_beta_=high_beta;
low_gamma_=low_gamma;
mid_gamma_=mid_gamma;

delta_ave=(sum_of_delta/count_of_all);
theta_ave=(sum_of_theta/count_of_all);
low_alpha_ave=(sum_of_low_alpha/count_of_all);
high_alpha_ave=(sum_of_high_alpha/count_of_all);
low_beta_ave=(sum_of_low_beta/count_of_all);
high_beta_ave=(sum_of_high_beta/count_of_all);
low_gamma_ave=(sum_of_low_gamma/count_of_all);
mid_gamma_ave=(sum_of_mid_gamma/count_of_all);
}
} 

public void attentionEvent(int attentionLevel) {
  //println("Attention Level: " + attentionLevel);
  attention = attentionLevel;//This variable was created to be used in other parts of the code to detect if attention value was zero or not
  attSamples.add(new Integer(attention));
  //print("ATTENTION");
  //println(attention);
  attention_=attention;
  sum_of_attention+=attention_;
  attention_ave=sum_of_attention/count_of_all;
  if (attSamples.size() > numSamples) {
    attSamples.remove(0);
  }
}

public void meditationEvent(int meditationLevel) {
  //println("Attention Level: " + attentionLevel);
  attention = meditationLevel;//This variable was created to be used in other parts of the code to detect if attention value was zero or not
  medSamples.add(new Integer(meditation));
  //print("ATTENTION");
  //println(attention);
  meditation_=meditation;
  if (medSamples.size() > numSamples) {
    medSamples.remove(0);
  }
}

//this function creates new csv file
public void createdatafile()
{
fname= (day()+ "." + month()+ "." +year()+ "_"+ hour()+ "." + minute()+ "." + second());
  output = createWriter(fname + ".tsv");
  output.print("date_time" + "\t");
  output.print("delta" + "\t");
  output.print("theta" + "\t");
  output.print("low_alpha" + "\t");
  output.print("high_alpha" + "\t");
  output.print("low_beta" + "\t");
  output.print("high_beta" + "\t");
  output.print("low_gamma" + "\t");
  output.print("mid_gamma" + "\t");
  output.print("attention" + "\t");
  
  output.print("delta_ave" + "\t");
  output.print("theta_ave" + "\t");
  output.print("low_alpha_ave" + "\t");
  output.print("high_alpha_ave" + "\t");
  output.print("low_beta_ave" + "\t");
  output.print("high_beta_ave" + "\t");
  output.print("low_gamma_ave" + "\t");
  output.print("mid_gamma_ave" + "\t");
  output.println("attention_ave");
  
}
/*
public float thresholding(float n_val)

{
if(n_val<0.2)
{
n_val=n_val*2;
}
else if(n_val>0.8)
{
}
return n_val;
}
*/
public float upperlimit(float releventa)
{
if(releventa>1000)
{releventa=1000;}
return releventa;
}