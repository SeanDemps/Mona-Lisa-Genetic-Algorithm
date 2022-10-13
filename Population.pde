class Population {

  float mutationRate;           // Mutation rate
  DNA[] population;             // Array to hold the current population
  ArrayList<DNA> matingPool;    // ArrayList which we will use for our "mating pool"
  float[] target;                // Target 
  //boolean finished;             // Are we finished evolving?
  int generation;
  int perfectScore;


  Population(float[] target, float mutationRate, int popmax) {
    this.target = target;
    this.mutationRate = mutationRate;
    population = new DNA[popmax];
    for (int i = 0; i < population.length; i++) {
      population[i] = new DNA();
    }
    calcFitness();
    matingPool = new ArrayList<DNA>();

    perfectScore = popmax*2; //int(pow(2, 380));
    generation = 0;
  }


  void calcFitness() {
    for (int i = 0; i < population.length; i++) {
      population[i].fitness(target);
    }
  }


  // Generate a mating pool
  void naturalSelection() {
    // Clear the ArrayList
    matingPool.clear();

    float maxFitness = 0;
    for (int i = 0; i < population.length; i++) {
      if (population[i].fitness > maxFitness) {
        maxFitness = population[i].fitness;
        // println("max", maxFitness);
        // println(i, ":", population[i].fitness);
      }
    }

    // Based on fitness, each member will get added to the mating pool a certain number of times
    // a higher fitness = more entries to mating pool = more likely to be picked as a parent
    // a lower fitness = fewer entries to mating pool = less likely to be picked as a parent
    for (int i = 0; i < population.length; i++) {

      float fitness = map(population[i].fitness, 0, maxFitness, 1, 0);
      // println("fitness", fitness);
      int n = int(fitness * 100);  // Arbitrary multiplier, we can also use monte carlo method
      for (int j = 0; j < n; j++) {              // and pick two random numbers
        matingPool.add(population[i]);
      }
    }
  }

  // Create a new generation
  void generate() {
    // Refill the population with children from the mating pool
    //println(matingPool.size());
    for (int i = 0; i < population.length; i++) {
      int a = int(random(matingPool.size()));
      int b = int(random(matingPool.size()));
      //println(a);
      DNA partnerA = matingPool.get(a);
      DNA partnerB = matingPool.get(b);
      DNA child = partnerA.crossover(partnerB);
      child.mutate(mutationRate);
      population[i] = child;
    }

    for (int i = 0; i < population.length; i++) {
      //uncomment line below if you want to see the whole population and each individual values rgb 
      // println(population[i].genes.x, population[i].genes.y, population[i].genes.z );
    }
    
    generation++;
  }

  void drawBest() {
    double worldrecord = Double.POSITIVE_INFINITY;
    int index = 0;
    for (int i = 0; i < population.length; i++) {
      if (population[i].fitness < worldrecord) {
        index = i;
        worldrecord = population[i].fitness;
      }
    }

    if (worldrecord == perfectScore ) finished = true;
    population[index].paint();
  }

  //boolean finished() {
  //  return finished;
  //}
  
  //  int getGenerations() {
  //  return generation;
  //}
}
