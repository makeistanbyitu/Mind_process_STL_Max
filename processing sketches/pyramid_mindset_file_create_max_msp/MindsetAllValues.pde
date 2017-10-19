
import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;

MindSet mindSet;

class PWindow extends PApplet {
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

 void settings() {
    size(800, 800);
  }
SampleWidget attentionWidget;
SampleWidget meditationWidget;
SampleWidget signalWidget;

SampleWidget deltaWidget;
SampleWidget thetaWidget;
SampleWidget lowAlphaWidget;
SampleWidget highAlphaWidget;
SampleWidget lowBetaWidget;
SampleWidget highBetaWidget;
SampleWidget lowGammaWidget;
SampleWidget midGammaWidget;

void setup() {

 //mindSet = new MindSet(this, "COM12");

  attentionWidget = new SampleWidget(400, false, 100);
  meditationWidget = new SampleWidget(100, false, 100);
  signalWidget = new SampleWidget(50, false, 200);

  deltaWidget = new SampleWidget(400, true, 0);
  thetaWidget = new SampleWidget(400, true, 0);
  lowAlphaWidget = new SampleWidget(400, true, 0);
  highAlphaWidget = new SampleWidget(400, true, 0);
  lowBetaWidget = new SampleWidget(400, true, 0);
  highBetaWidget = new SampleWidget(400, true, 0);
  lowGammaWidget = new SampleWidget(400, true, 0);
  midGammaWidget = new SampleWidget(400, true, 0);
}


void draw() {
  background(0);

  //simulate();

  //text("Attention Level", 10, 10);
  //attentionWidget.draw(10, 10+20, 200, 150);

//  text("Meditation Level", 10, 200);
  //meditationWidget.draw(10, 200+20, 200, 150);

  //text("Signal quality", 10, height-10-20-100);
 // signalWidget.draw(10, height-100-10, 200, 100);

{
  deltaWidget.add(delta_);
  thetaWidget.add(theta_);
  lowAlphaWidget.add(low_alpha_);
  highAlphaWidget.add(high_alpha_);
  lowBetaWidget.add(low_beta_);
  highBetaWidget.add(high_beta_);
  lowGammaWidget.add(low_gamma_);
  midGammaWidget.add(mid_gamma_);
  attentionWidget.add(attention_);
  meditationWidget.add(meditation_);
}
  int h = height/10;
  text("Delta", width/100, 10+h/2);
  deltaWidget.draw(width/10, 10, (width-(width/10)), height/12);

  text("Theta", width/100, 10+(h+10) + h/2);
  thetaWidget.draw(width/10, 10+(h+10), (width-(width/10)), height/12);

  text("Low alpha", width/100, 10+(h+10)*2 + h/2);
  lowAlphaWidget.draw(width/10, 10+(h+10)*2, (width-(width/10)), height/12);

  text("High alpha", width/100, 10+(h+10)*3 + h/2);
  highAlphaWidget.draw(width/10, 10+(h+10)*3, (width-(width/10)), height/12);

  text("Low beta", width/100, 10+(h+10)*4 + h/2);
  lowBetaWidget.draw(width/10, 10+(h+10)*4, (width-(width/10)), height/12);

  text("High beta", width/100, 10+(h+10)*5 + h/2);
  highBetaWidget.draw(width/10, 10+(h+10)*5, (width-(width/10)), height/12);  

  text("Low gamma", width/100, 10+(h+10)*6 + h/2);
  lowGammaWidget.draw(width/10, 10+(h+10)*6, (width-(width/10)), height/12);    

  text("Mid gamma", width/100, 10+(h+10)*7 + h/2);
  midGammaWidget.draw(width/10, 10+(h+10)*7, (width-(width/10)), height/12);
  
  text("Attention", width/100, 10+(h+10)*8 + h/2);
  attentionWidget.draw(width/10, 10+(h+10)*8, (width-(width/10)), height/12);

  //  
  //  fill(255, 0, 0, 100);
  //  stroke(255, 100);
  //  rect(width/2-50, height-attention*height/100.0, 100, attention*height/100.0);
  //
  //  //signal strength
  //  stroke(255);
  //  line(0, 50, 50, 50); 
  //  fill(0, 255, 0);
  //  rect(12, 50, 25, -(50-strength*50/200.0));
}

/*void simulate() {
  poorSignalEvent(int(random(200)));
  attentionEvent(int(random(100)));
  meditationEvent(int(random(100)));
  eegEvent(int(random(20000)), int(random(20000)), int(random(20000)), 
  int(random(20000)), int(random(20000)), int(random(20000)), 
  int(random(20000)), int(random(20000)) );
}
*/

void exit() {
  println("Exiting");
  mindSet.quit();
  super.exit();
}


public void poorSignalEvent(int sig) {
  println(sig);
  signalWidget.add(200-sig);
}

//public void attentionEvent(int attentionLevel) {
  
//}


public void meditationEvent(int meditationLevel) {
  meditationWidget.add(meditationLevel);
}

//public void eegEvent(int delta, int theta, int low_alpha, 
//int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma)

class SampleWidget {

  private int[] samples;
  private int index;
  private int maximum;
  private float average;
  private boolean autoScale;
  private int maxValue;
  
  public SampleWidget(int nSamples, boolean autoScale, int maxValue) {
    this.autoScale = autoScale;
    this.maxValue = maxValue;
    samples = new int[nSamples];

    index = 0;
  }

  public void add(int v) {
    samples[index] = v;

    index = (index+1)%samples.length;
  }

  void update() {
    maximum = -1000000;
    average = 0;
    for (int i = 0; i < samples.length; i++) {
      average += samples[i];
      if ( samples[i] > maximum ) {
        maximum = samples[i];
      }
    }
  }

  public void draw(int x, int y, int width, int height) {
    update();
    pushStyle();
    
    int max = maximum;
    if ( max == 0 ) {
      max = 100;
    }
    if (!autoScale) {
      max = maxValue;
    }
    
    float w = width*1.0/samples.length;
    noFill();
    stroke(255);
    for (int i = 0; i < samples.length; i++) {
      line(x+i*w, y+height, x+i*w, y+height-samples[i]*height/max);
    }
    popStyle();
  }
}}