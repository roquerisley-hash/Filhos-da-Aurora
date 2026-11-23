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

  // cruzamento uniforme: cada gene vem de um dos pais com 50% de chance
  DNA cruzar(DNA parceiro) {
    float[] genesfilho = new float[genes.length];
    for (int i = 0; i < genes.length; i++) {
      genesfilho[i] = random(1) < 0.5 ? genes[i] : parceiro.genes[i];
    }
    return new DNA(genesfilho);
  }

  // mutação: pequeno deslocamento aleatório, mantendo o gene entre 0 e 1
  void mutar(float taxa) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < taxa) {
        genes[i] = constrain(genes[i] + random(-PASSO_MUTACAO, PASSO_MUTACAO), 0, 1);
      }
    }
  }
}
