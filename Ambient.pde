class Ambiente {
  Ilha[] ilhas;
  Populacao populacao;
  ArrayList<Criatura> criaturas;
  boolean[] luzColetada;
  int quadrosDaGeracao;

  Ambiente(Ilha[] ilhas, Populacao populacao) {
    this.ilhas = ilhas;
    this.populacao = populacao;
    criaturas = new ArrayList<Criatura>();
    luzColetada = new boolean[ilhas.length];
    iniciarGeracao();
  }

  void iniciarGeracao() {
    criaturas.clear();
    quadrosDaGeracao = 0;

    Ilha inicio = ilhas[ILHA_GIRASSOL];
    for (int i = 0; i < ilhas.length; i++) {
      if (ilhas[i].desbloqueada) {
        inicio = ilhas[i];
        break;
      }
    }

    for (int i = 0; i < populacao.individuos.size(); i++) {
      criaturas.add(new Criatura(populacao.individuos.get(i), inicio));
    }
  }

  void atualizar() {
    for (int i = 0; i < criaturas.size(); i++) {
      criaturas.get(i).atualizar();
    }

    quadrosDaGeracao++;

    if (quadrosDaGeracao >= DURACAO_GERACAO ||
        contarVivas() == 0 || !existemFloresPendentes()) {
      proximaGeracao();
    }
  }

  boolean existemFloresPendentes() {
    for (int i = 0; i < ilhas.length; i++) {
      if (ilhas[i].precisaPolinizacao()) {
        return true;
      }
    }
    return false;
  }

  float calcularAptidao(Criatura criatura) {
    float pontosFlores = criatura.polinizacoes * PONTOS_POR_POLINIZACAO;
    float energiaRestante = max(0, criatura.energia);
    float pontosEnergia = energiaRestante / ENERGIA * PONTOS_POR_ENERGIA;
    return max(0, pontosFlores + pontosEnergia);
  }

  void proximaGeracao() {
    float[] aptidoes = new float[criaturas.size()];

    for (int i = 0; i < criaturas.size(); i++) {
      aptidoes[i] = calcularAptidao(criaturas.get(i));
    }

    populacao.criarProximaGeracao(aptidoes);

    for (int i = 0; i < ilhas.length; i++) {
      ilhas[i].reiniciarRodada();
    }

    iniciarGeracao();
  }

  int contarVivas() {
    int total = 0;
    for (int i = 0; i < criaturas.size(); i++) {
      if (criaturas.get(i).viva) {
        total++;
      }
    }
    return total;
  }

  void desenharCriaturas() {
    for (int i = 0; i < criaturas.size(); i++) {
      criaturas.get(i).desenhar();
    }
  }

  boolean temLuzNaIlha(int indice) {
    return indice >= 0 && indice < ilhas.length &&
      ilhas[indice].desbloqueada && !luzColetada[indice];
  }

  int coletarLuz(int indice) {
    if (!temLuzNaIlha(indice)) {
      return 0;
    }
    luzColetada[indice] = true;
    return LUZ_POR_ILHA_AMBIENTE;
  }

  boolean plantarFlor(int indice) {
    if (indice < 0 || indice >= ilhas.length || !ilhas[indice].desbloqueada) {
      return false;
    }
    ilhas[indice].flores++;
    return true;
  }
}
