// AMBIENTE: cada ilha é um vértice do grafo e guarda as flores a polinizar.
// Ilhas adormecidas não podem ser polinizadas. Ao completar a polinização
// de todas as flores, a ilha "desperta" as ilhas vizinhas (Aurora).

class Ilha {

  int id;
  String nome;

  float x, y;
  float largura = LARGURA_ILHA;
  float altura = ALTURA_ILHA;

  boolean desbloqueada;

  int flores;
  int polinizacaoPorFlor;
  int polinizadas = PROGRESSO_INICIAL;

  Ilha(int id, String nome, float x, float y,
       int flores, int polinizacaoPorFlor, boolean desbloqueada) {

    this.id = id;
    this.nome = nome;
    this.x = x;
    this.y = y;
    this.flores = flores;
    this.polinizacaoPorFlor = polinizacaoPorFlor;
    this.desbloqueada = desbloqueada;
  }

  int floresCompletas() {
    return polinizadas / polinizacaoPorFlor;
  }

  int pendentes() {
    return flores - floresCompletas();
  }

  boolean completa() {
    return pendentes() <= SEM_FLORES_PENDENTES;
  }

  // só vale a pena ir até uma ilha desperta que ainda tenha flores pendentes
  boolean precisaPolinizacao() {
    return desbloqueada && !completa();
  }

  // as flores voltam a precisar de polinização a cada nova geração
  // (ilhas despertas, flores plantadas e correntes restauradas permanecem)
  void reiniciarRodada() {
    polinizadas = PROGRESSO_INICIAL;
  }

  // Polinização

  boolean polinizar() {

    if (!precisaPolinizacao()) {
      return false;
    }

    polinizadas += PROGRESSO_POR_POLINIZACAO;

    if (completa()) {
      grafo.despertarVizinhas(id);
    }
    return true;
  }

  // Desenho da ilha

  void desenhar() {

    if (desbloqueada) {
      fill(COR_ILHA_DESPERTA_R, COR_ILHA_DESPERTA_G, COR_ILHA_DESPERTA_B, 150);
      stroke(COR_BRANCO);
    } else {
      fill(COR_ILHA_ADORMECIDA_R, COR_ILHA_ADORMECIDA_G, COR_ILHA_ADORMECIDA_B, 170);
      stroke(COR_CORRENTE_INATIVA_R, COR_CORRENTE_INATIVA_G, COR_CORRENTE_INATIVA_B);
    }
    strokeWeight(ESPESSURA_ILHA);
    ellipse(x, y, largura, altura);

    if (desbloqueada) {
      desenharProgresso();
    }

    // Nome e contagem de flores

    noStroke();
    fill(COR_TEXTO);

    textAlign(CENTER, TOP);
    textSize(13);

    text(nome, x, y + altura / 2 + 5);

    if (desbloqueada) {
      text(
        "Flores: " + floresCompletas() + "/" + flores,
        x, y + altura / 2 + 21
      );
    } else {
      text("Adormecida", x, y + altura / 2 + 21);
    }
  }

  // barra de progresso da polinização dentro da ilha
  void desenharProgresso() {

    float larguraBarra = largura * 0.6;
    float proporcao = flores > 0 ? constrain(floresCompletas() / (float) flores, 0, 1) : 1;

    noStroke();
    fill(COR_BARRA_FUNDO_R, COR_BARRA_FUNDO_G, COR_BARRA_FUNDO_B);
    rect(x - larguraBarra / 2, y + 10, larguraBarra, ALTURA_BARRA, 3);

    fill(COR_BARRA_PROGRESSO_R, COR_BARRA_PROGRESSO_G, COR_BARRA_PROGRESSO_B);
    rect(x - larguraBarra / 2, y + 10, larguraBarra * proporcao, ALTURA_BARRA, 3);
  }

  // Verifica se um ponto está dentro da ilha

  boolean contem(float px, float py) {

    float dx = (px - x) / (largura / DIVISOR_DIAMETRO);
    float dy = (py - y) / (altura / DIVISOR_DIAMETRO);

    return dx * dx + dy * dy <= LIMITE_ELIPSE;
  }
}
