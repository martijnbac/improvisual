import java.util.concurrent.CopyOnWriteArrayList;
import processing.sound.*;
import processing.sound.*;
import themidibus.*;
import controlP5.*;


int globalOffset = 0;
CopyOnWriteArrayList<Element> elements = new CopyOnWriteArrayList<Element>();
volatile boolean isBusy;
PFont font;
float fontSize;
boolean start = false;
boolean flag;
MidiBus myBus;

// sound variables
FFT fft;
AudioIn in;
int bands = 512;
int time;
float[] spectrum = new float[bands];

// controlp5 variables
ControlP5 cp5;
float rowHeight = 100;
int sliderValue = 100;

void setup() {
  size(500, 1000, P2D);//  size(700, 1400, P2D);

  rectMode(CORNER);
  pixelDensity(2); // retina screens 

  // mic 
  fft = new FFT(this, bands);
  in = new AudioIn(this,2);
  in.start(); 
  fft.input(in);
  time = 0;

  // midi
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, ""); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

  // text settings
  fontSize = width * 0.032;
  font = createFont("Univers LT 55", fontSize);
  textFont(font);
  textSize(fontSize);
  textAlign(CENTER);

  // controlP5
  //cp5 = new ControlP5(this);
  //cp5.addSlider("rowHeight")
  //  .setPosition(100, 50)
  //  .setRange(0, 255)
  //  ;
}

void draw() {
  // show framerate in title
  frameRateInTitle();

  // set window location
  //setLoc();

  // set background color
  background(#5A4141);

  // analyze microphone input
  analyzeMicrophone();

  // make sure to not write and access elements array at the same time
  isBusy = true;
  for (Element el : elements) { 
    el.display();
  }
  isBusy = false;
}

void setLoc() {
  if (!flag) {
    surface.setLocation(1860, 0);
    flag = true;
  }
}

void frameRateInTitle() {
  String title = str(round(frameRate));
  surface.setTitle(title);
}

void analyzeMicrophone() {
  fft.analyze(spectrum);
  for (int i = 0; i < bands; i++) {
    fill(0);
    stroke(255);
    //line(i, height, i, height - spectrum[i]*height*5 );

    // snare
    if (i > 25 && i < 400 && spectrum[i]*height*10 > 3 && millis() > time) {
      fill(255, 0, 0);


      float micValue = spectrum[i] * height * 10;
      micValue = micValue * (micValue*0.7);

      //if (elements.size() < 684) {
        drawDrum(micValue/2);
      //}
      // wait
      time = millis() + 200;
    }
  }
}

void drawElement() {
  // simulate mic/midi input with the keyboard, choose a random velocity value

  if (keyCode == ENTER) {
    int v = parseInt(random(4, 50));
    drawSynth(v, v);
  } else {
    int v = parseInt(random(4, 50));
    drawDrum(v);
  }
}

void drawDrum(float velocity) {
  // draw an element on every drum hit
  elements.add(new Element("drum", velocity, 0));
}

void drawSynth(float velocity, float pitch) {
  start = true;
  if (elements.size() < 136) {
    elements.add(new Element("synth", velocity, pitch));
  }
}

void keyPressed() {
  // reset on pressing x key
  if (keyCode == 88) {
    elements.clear();
  } 
  // draw element on random key (to test without mic or midi input)
  else {
    drawElement();
  }
}

void noteOn(int channel, int pitch, int velocity) {
    //println("Note on. C: "+channel+" P: "+pitch+" V: "+velocity);
  if (isBusy != true) {
    drawSynth(velocity, pitch);
  }
}
