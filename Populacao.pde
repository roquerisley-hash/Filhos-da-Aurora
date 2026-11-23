class Populacao {
  ArrayList<DNA> individuos;
  int tamanho = 20;
  int geracao = 1;
  float taxaMutacao = 0.05;

  Populacao() {
    individuos = new ArrayList<DNA>();
    for (int i = 0; i < tamanho; i++) {
      individuos.add(new DNA());
    }
  }


  DNA selecionar(float[] aptidoes) {
    float total = 0;
    for (int i = 0; i < aptidoes.length; i++) {
      total += aptidoes[i];
    }


    if (total <= 0) {
      return individuos.get(int(random(individuos.size())));
    }

    float sorteio = random(total);
    float acumulado = 0;
    for (int i = 0; i < aptidoes.length; i++) {
      acumulado += aptidoes[i];
      if (acumulado > sorteio) {
        return individuos.get(i);
      }
    }
    return individuos.get(individuos.size() - 1);
  }

  void criarProximaGeracao(float[] aptidoes) {
    ArrayList<DNA> novaGeracao = new ArrayList<DNA>();

    for (int i = 0; i < tamanho; i++) {
      DNA pai = selecionar(aptidoes);
      DNA mae = selecionar(aptidoes);
      DNA filho = pai.cruzar(mae);
      filho.mutar(taxaMutacao);
      novaGeracao.add(filho);
    }

    individuos = novaGeracao;
    geracao++;
  }


  float mediaGene(int posicao) {
    float soma = 0;
    for (int i = 0; i < individuos.size(); i++) {
      soma += individuos.get(i).genes[posicao];
    }
    return soma / individuos.size();
  }
}
