class DNA {
  float fitness;
  PGraphics painting = createGraphics(IMAGE_WIDTH, IMAGE_HEIGHT); // phenotype
  ColorRect[] rectangles = new ColorRect[50]; // geneotype
  
  int rectMin = 5;
  int rectMax = 70;
  

  DNA() {
    painting.beginDraw();
    painting.noStroke();
    //scale(SCALE_FACTOR);
    for(int i = 0; i < rectangles.length; i++){
      float bnw = random(255);
      int colour = color(bnw, bnw, bnw, 255*max(random(1)*random(1), 0.2));
      rectangles[i] = new ColorRect(createShape(RECT, random(width), random(height), random(rectMin, rectMax), random(rectMin, rectMax)), colour);
    }
    this.fillGraphics();
  }
  
  void fillGraphics() {
   painting.beginDraw();
   noStroke();
   //scale(SCALE_FACTOR);
    for(int i = 0; i < rectangles.length; i++){
      fill(rectangles[i].colour);
      this.painting.shape(rectangles[i].rectangle);
     }
    this.painting.endDraw();
    this.painting.loadPixels();
    this.painting.updatePixels();
  }

  void fitness(float[] target) {
    float score = 0;
    
    for(int i = 0; i < this.painting.pixels.length; i++) {
      float paintingBrightness = brightness(this.painting.pixels[i]);
      
      // get absolute brightness difference between taget pixel and our DNA
      score += abs(target[i] - paintingBrightness);
    }
      
    fitness = pow(score, 2); // lower scores are better, cubed to help weight fitter DNA more
  }

  // Crossover
  DNA crossover(DNA partner) {
    // A new child
    DNA child = new DNA();
        
    // randomize which genes get chosen from parents
    for (int i = 0; i < this.rectangles.length; i++) {
      if (random(1) > 0.5) child.rectangles[i] = this.rectangles[i];
      else              child.rectangles[i] = partner.rectangles[i];
    }
    return child;
 
  }

  // Based on a mutation probability, picks a new random character
  void mutate(float mutationRate) {
     for (int i = 0; i < rectangles.length; i++) {
      if (random(1) < mutationRate) {
        float bnw = random(255);
        int colour = color(bnw, bnw, bnw, 255*max(random(1)*random(1), 0.2));
        rectangles[i] = new ColorRect(createShape(RECT, random(width), random(height), random(rectMin, rectMax), random(rectMin, rectMax)), colour);
      }
    }
    this.fillGraphics();
  }
  
  void paint() {
    image(this.painting, 0, 0);
  }
}
