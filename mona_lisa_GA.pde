import processing.pdf.*;
import java.lang.reflect.Method;

int popmax;
float mutationRate;
Population population;
int newgendraw;
int IMAGE_WIDTH = 100; // must be set to image width
int IMAGE_HEIGHT = 149; // must be set to image height
PImage img;

int SCALE_FACTOR = 1; //not yet working

float[] targetBrightness = new float[IMAGE_WIDTH*IMAGE_HEIGHT];

void settings() {
    size(IMAGE_WIDTH*SCALE_FACTOR, IMAGE_HEIGHT*SCALE_FACTOR);
}

void setup() {
  img = loadImage("small_lisa.jpg");  // Load the image into the program

  popmax = 100;
  mutationRate = 0.004;
  
  // set up an array with brightness level for each pixel of target image already calculated
  for(int i = 0; i < this.img.pixels.length; i++) {
    targetBrightness[i] = brightness(this.img.pixels[i]);
  }

  population = new Population(targetBrightness, mutationRate, popmax);
}



void draw() {
  background(0);

  // Generate mating pool
  population.naturalSelection();
  // Create next generation
  population.generate();
  // Calculate fitness
  population.calcFitness();

  // Draw the fittest image
  population.drawBest();
}

void keyPressed() {
  if (key == 'r') {
    saveFrame("v3/gen_######.png");
    println(frameCount);
  }
}
