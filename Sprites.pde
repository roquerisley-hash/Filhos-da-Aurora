class Sprites {
  void desenharCorrentes(Grafo mapa) {
    for (int origem = 0; origem < mapa.qtd; origem++) {
      for (int destino = origem + 1; destino < mapa.qtd; destino++) {
        if (mapa.matrizPossivel[origem][destino] > SEM_CORRENTE) {
          Ilha a = mapa.ilhas[origem];
          Ilha b = mapa.ilhas[destino];
          corrente((a.x + b.x) / 2, (a.y + b.y) / 2,
            mapa.estaoConectadas(origem, destino), mapa.correnteRestauravel(origem, destino));
        }
      }
    }
  }

  void desenharRecursos(Grafo mapa, Jogador jogador) {
    float balanco = 2 * sin(frameCount * 0.08f);
    for (int i = 0; i < mapa.qtd; i++) {
      Ilha ilha = mapa.ilhas[i];
      if (jogador.temLuzNaIlha(i)) {
        luz(ilha.x + 28, ilha.y + 8 + balanco);
      }
      if (ilha.precisaPolinizacao()) {
        flor(ilha.x - 27, ilha.y + 8, jogador.plantouAgora(i) ? 1.3f : 1);
      }
    }
  }

  void desenharLegenda(float x, float y) {
    luz(x, y);
    flor(x + 103, y, 1);
    corrente(x, y + 25, true, false);
    corrente(x + 103, y + 25, false, true);
    corrente(x + 216, y + 25, false, false);

    pushStyle();
    fill(225, 235, 255);
    textAlign(LEFT, CENTER);
    textSize(12);
    text("Luz disponível", x + 15, y);
    text("Flor", x + 15 + 103, y);
    text("Ativa", x + 16, y + 25);
    text("Restaurável", x + 16 + 103, y + 25);
    text("Bloqueada", x + 16 + 216, y + 25);
    popStyle();
  }

  void luz(float x, float y) {
    pushStyle();
    ellipseMode(CENTER);
    noStroke();
    fill(255, 195, 89, 56);
    ellipse(x, y, 21, 21);
    stroke(112, 67, 38);
    strokeWeight(1.5f);
    fill(255, 199, 83);
    quad(x, y - 8, x + 6, y, x, y + 8, x - 6, y);
    noStroke();
    fill(255, 244, 194);
    quad(x, y - 5, x + 3, y, x, y + 4, x - 2, y);
    popStyle();
  }

  void flor(float x, float y, float tamanho) {
    pushMatrix();
    translate(x, y);
    scale(tamanho);
    pushStyle();
    ellipseMode(CENTER);
    stroke(33, 93, 83);
    strokeWeight(2);
    line(0, 0, 0, 9);
    noStroke();
    fill(125, 220, 173);
    ellipse(-3, 6, 7, 4);
    ellipse(3, 7, 7, 4);
    fill(247, 155, 172);
    ellipse(-4, -1, 8, 7);
    ellipse(4, -1, 8, 7);
    ellipse(0, -5, 8, 8);
    fill(255, 223, 130);
    ellipse(0, -2, 6, 6);
    popStyle();
    popMatrix();
  }

  void corrente(float x, float y, boolean ativa, boolean restauravel) {
    pushStyle();
    rectMode(CENTER);
    noStroke();
    fill(25, 37, 70);
    rect(x, y, 23, 16, 6);
    strokeWeight(1.5f);
    if (ativa) {
      stroke(145, 220, 255);
      line(x - 6, y - 2, x + 6, y - 2);
      line(x - 4, y + 2, x + 4, y + 2);
    } else if (restauravel) {
      stroke(255, 221, 121);
      line(x - 5, y, x + 5, y);
      line(x, y - 4, x, y + 4);
    } else {
      stroke(177, 184, 204);
      line(x - 5, y, x - 2, y);
      line(x + 2, y, x + 5, y);
    }
    popStyle();
  }
}
