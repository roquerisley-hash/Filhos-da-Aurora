class Jogador {
  final int CUSTO_FLOR = 3;
  final int CUSTO_RESTAURACAO = 5;
  final int LUZ_POR_ILHA = 8;

  private Grafo mapa;
  private int ilhaAtual;
  private int luz;
  private boolean[] luzColetada;
  private String mensagem = "Explore as ilhas despertas para coletar luz.";

  Jogador(Grafo mapa, int ilhaInicial) {
    this.mapa = mapa;
    ilhaAtual = ilhaInicial;
    luzColetada = new boolean[mapa.qtd];
  }

  int getLuz() {
    return luz;
  }

  Ilha getIlha() {
    return mapa.ilhas[ilhaAtual];
  }

  String getMensagem() {
    return mensagem;
  }

  void clicar(float x, float y, int botao) {
    int destino = mapa.ilhaEm(x, y);
    if (destino == SEM_ILHA) {
      return;
    }
    if (botao == LEFT) {
      viajar(destino);
    } else if (botao == RIGHT) {
      restaurarCorrente(destino);
    }
  }

  void tecla(char teclaPressionada) {
    char comando = Character.toLowerCase(teclaPressionada);
    if (comando == 'e') {
      coletarLuz();
    } else if (comando == 'f') {
      plantarFlor();
    }
  }

  boolean viajar(int destino) {
    if (destino == ilhaAtual) {
      mensagem = "Você já está em " + getIlha().nome + ".";
      return false;
    }
    if (!mapa.estaoConectadas(ilhaAtual, destino)) {
      mensagem = "Não há corrente ativa até essa ilha.";
      return false;
    }
    ilhaAtual = destino;
    mensagem = "Você chegou a " + getIlha().nome + ".";
    return true;
  }

  boolean coletarLuz() {
    if (!getIlha().desbloqueada || luzColetada[ilhaAtual]) {
      mensagem = "Não há luz disponível nesta ilha.";
      return false;
    }
    luzColetada[ilhaAtual] = true;
    luz += LUZ_POR_ILHA;
    mensagem = "Você coletou " + LUZ_POR_ILHA + " de luz.";
    return true;
  }

  boolean plantarFlor() {
    Ilha ilha = getIlha();
    if (!ilha.desbloqueada) {
      mensagem = "A ilha precisa despertar para receber flores.";
      return false;
    }
    if (luz < CUSTO_FLOR) {
      mensagem = "Plantar uma flor custa " + CUSTO_FLOR + " de luz.";
      return false;
    }
    ilha.flores++;
    luz -= CUSTO_FLOR;
    mensagem = "Flor plantada em " + ilha.nome + ".";
    return true;
  }

  boolean restaurarCorrente(int destino) {
    if (!mapa.correnteRestauravel(ilhaAtual, destino)) {
      mensagem = "A corrente precisa existir, estar inativa e ligar ilhas despertas.";
      return false;
    }
    if (luz < CUSTO_RESTAURACAO) {
      mensagem = "Restaurar uma corrente custa " + CUSTO_RESTAURACAO + " de luz.";
      return false;
    }
    if (!mapa.ativarCorrente(ilhaAtual, destino)) {
      mensagem = "A corrente não pôde ser restaurada.";
      return false;
    }
    luz -= CUSTO_RESTAURACAO;
    mensagem = "Corrente restaurada até " + mapa.ilhas[destino].nome + ".";
    return true;
  }

  void desenhar() {
    Ilha ilha = getIlha();
    pushStyle();
    ellipseMode(CENTER);
    stroke(62, 44, 23);
    strokeWeight(2);
    fill(255, 221, 121);
    ellipse(ilha.x, ilha.y - 15, 20, 20);
    noStroke();
    fill(54, 40, 24);
    textAlign(CENTER, CENTER);
    textSize(12);
    text("J", ilha.x, ilha.y - 16);
    popStyle();
  }
}
