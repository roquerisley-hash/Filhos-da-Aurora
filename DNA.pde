class DNA {
  float[] genes = new float[3];

  DNA() {
    for (int x = 0; x < genes.length; x++) {
      genes[x] = random(0, 1);
    }
  }

  // construtor de descendentes
  DNA(float[] novosgenes) {
    genes = new float[novosgenes.length];
    for (int x = 0; x < novosgenes.length; x++) {
      genes[x] = novosgenes[x];
    }
  }
  DNA cruzar(DNA parceiro){
    float[] genesfilho = new float[genes.length];

  }
}
