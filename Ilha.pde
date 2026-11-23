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


  // Polinização

  boolean polinizar() {

    if (!desbloqueada || pendentes() == SEM_FLORES_PENDENTES) {
      return false;
    }

    polinizadas += PROGRESSO_POR_POLINIZACAO;
    return true;
  }

  // Desenho da ilha

  void desenhar() {

    noFill();
    stroke(COR_BRANCO);
    strokeWeight(ESPESSURA_ILHA);

    ellipse(x, y, largura, altura);

    // Nome e contagem de flores

    noStroke();
    fill(COR_TEXTO);

    textAlign(CENTER, TOP);
    textSize(13);

    text(nome, x, y + altura / 2 + 5);

    text(
      "Flores: " + floresCompletas() + "/" + flores,
      x, y + altura / 2 + 21
    );
  }

  // Verifica se um ponto está dentro da ilha

  boolean contem(float px, float py) {

    float dx = (px - x) / (largura / DIVISOR_DIAMETRO);
    float dy = (py - y) / (altura / DIVISOR_DIAMETRO);

    return dx * dx + dy * dy <= LIMITE_ELIPSE;
  }
}
