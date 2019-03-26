import java.util.concurrent.CopyOnWriteArrayList;
import processing.sound.*;

int globalOffset = 0;
CopyOnWriteArrayList<Element> elements = new CopyOnWriteArrayList<Element>();
volatile boolean isBusy;
boolean start = false;
int time;
FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];
PFont font;

void setup() {
  size(700, 1400, P2D);
  rectMode(CORNER);
  pixelDensity(2); // retina screens 

  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  in.start();
  fft.input(in);
  time = 0;

  // text settings
  font = createFont("Univers LT 55", 24);
  textFont(font);
  textSize(24);
  textAlign(CENTER);
}

void draw() {
  // show framerate in title
  String title = str(round(frameRate));
  surface.setTitle(title);

  // set background color
  background(0);

  // analyze microphone input
  fft.analyze(spectrum);
  for (int i = 0; i < bands; i++) {
    fill(0);
    // snare
    if (i > 25 && i < 400 && spectrum[i]*height*10 > 3 && millis() > time) {
      fill(255, 0, 0);

      if (elements.size() < 684) {
        drawDrum(spectrum[i]*height*10);
      }
      // wait
      time = millis() + 200;
    }
  }

  // make sure to not write and access elements array at the same time
  isBusy = true;
  for (Element el : elements) { 
    el.display();
  }
  isBusy = false;
}


void drawElement() {
  // simulate mic/midi input with the keyboard, choose a random velocity value
  int v = parseInt(random(4, 50));
  drawDrum(v);
}

void drawDrum(float velocity) {
  // draw an element on every drum hit
  elements.add(new Element("drum", velocity, 0));
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
