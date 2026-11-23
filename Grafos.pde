/* cada ilha é um vértice, cada corrente uma aresta

   matrizPossivel   = todas as correntes que existem no mapa (com o custo)
   matrizAdjacencia = só as correntes ativas (as únicas que podem ser percorridas)
   
   ativa: está em matrizAdjacencia
   restaurável: existe, não está ativa e as duas ilhas já despertaram (o jogador pode ativar)
   bloqueada: existe, mas alguma das ilhas ainda está adormecida */

class Grafo {

  int qtd;
  Ilha[] ilhas;

  int[][] matrizAdjacencia;
  int[][] matrizPossivel;

  Grafo(Ilha[] ilhas) {

    this.ilhas = ilhas;
    this.qtd = ilhas.length;

    matrizAdjacencia = new int[qtd][qtd];
    matrizPossivel = new int[qtd][qtd];
  }

  boolean indiceValido(int ilha) {
    return ilha >= 0 && ilha < qtd;
  }
  
  void adicionarCorrente(int a, int b, int custo, boolean ativa) {

    if (!indiceValido(a) || !indiceValido(b) ||
        a == b || custo <= SEM_CORRENTE) {
      return;
    }

    matrizPossivel[a][b] = custo;
    matrizPossivel[b][a] = custo;

    if (ativa) {
      matrizAdjacencia[a][b] = custo;
      matrizAdjacencia[b][a] = custo;
    }
  }

  void despertarIlha(int ilha) {

    if (indiceValido(ilha)) {
      ilhas[ilha].desbloqueada = true;
    }
  }

  // verifica se uma corrente pode ser restaurada
  boolean correnteRestauravel(int a, int b) {

    return indiceValido(a) && indiceValido(b)
      && matrizPossivel[a][b] > SEM_CORRENTE
      && matrizAdjacencia[a][b] == SEM_CORRENTE
      && ilhas[a].desbloqueada
      && ilhas[b].desbloqueada;
  }

  boolean ativarCorrente(int a, int b) {

    if (!correnteRestauravel(a, b)) {
      return false;
    }

    int custo = matrizPossivel[a][b];

    matrizAdjacencia[a][b] = custo;
    matrizAdjacencia[b][a] = custo;

    return true;
  }

  // retorna a ilha localizada em determinado ponto 
  int ilhaEm(float px, float py) {

    for (int i = 0; i < qtd; i++) {

      if (ilhas[i].contem(px, py)) {
        return i;
      }
    }

    return SEM_ILHA;
  }

  boolean estaoConectadas(int a, int b) {

    return indiceValido(a) && indiceValido(b)
      && matrizAdjacencia[a][b] > SEM_CORRENTE;
  }

  ArrayList<Integer> obterVizinhas(int ilha) {

    ArrayList<Integer> vizinhas = new ArrayList<Integer>();

    if (indiceValido(ilha)) {

      for (int i = 0; i < qtd; i++) {

        if (matrizAdjacencia[ilha][i] > SEM_CORRENTE) {
          vizinhas.add(i);
        }
      }
    }

    return vizinhas;
  }

  // DIJKSTRA

  int[] dijkstra(int origem, int[] anterior) {

    int[] distancia = new int[qtd];
    boolean[] visitado = new boolean[qtd];

    for (int i = 0; i < qtd; i++) {

      distancia[i] = INFINITO;
      anterior[i] = SEM_ILHA;
    }

    if (!indiceValido(origem)) {
      return distancia;
    }

    distancia[origem] = SEM_CORRENTE;

    for (int rodada = 0; rodada < qtd; rodada++) {

      int atual = SEM_ILHA;
      int menor = INFINITO;

      for (int i = 0; i < qtd; i++) {

        if (!visitado[i] && distancia[i] < menor) {

          menor = distancia[i];
          atual = i;
        }
      }

      if (atual == SEM_ILHA) {
        break;
      }

      visitado[atual] = true;

      for (int v = 0; v < qtd; v++) {

        if (matrizAdjacencia[atual][v] > SEM_CORRENTE
            && !visitado[v]) {

          int novaDistancia =
            distancia[atual] + matrizAdjacencia[atual][v];

          if (novaDistancia < distancia[v]) {

            distancia[v] = novaDistancia;
            anterior[v] = atual;
          }
        }
      }
    }

    return distancia;
  }

  int[] dijkstra(int origem) {
    return dijkstra(origem, new int[qtd]);
  }

  // retorna o menor caminho entre duas ilhas

  ArrayList<Integer> menorCaminho(int origem, int destino) {

    ArrayList<Integer> caminho = new ArrayList<Integer>();

    if (!indiceValido(origem) || !indiceValido(destino)) {
      return caminho;
    }

    int[] anterior = new int[qtd];
    int[] distancia = dijkstra(origem, anterior);

    if (distancia[destino] == INFINITO) {
      return caminho;
    }

    for (int atual = destino;
         atual != SEM_ILHA;
         atual = anterior[atual]) {

      caminho.add(0, atual);
    }

    return caminho;
  }

  // calcula o custo de um caminho

  int custoCaminho(ArrayList<Integer> caminho) {

    int custo = SEM_CORRENTE;

    for (int i = 0; i < caminho.size() - 1; i++) {

      custo += matrizAdjacencia[
        caminho.get(i)
      ][
        caminho.get(i + 1)
      ];
    }

    return custo;
  }

  // DESENHO DAS CORRENTES

  void desenhar() {

    for (int i = 0; i < qtd; i++) {

      for (int j = i + 1; j < qtd; j++) {

        if (matrizPossivel[i][j] == SEM_CORRENTE) {
          continue;
        }

        if (matrizAdjacencia[i][j] > SEM_CORRENTE) {

          stroke(
            COR_CORRENTE_ATIVA_R,
            COR_CORRENTE_ATIVA_G,
            COR_CORRENTE_ATIVA_B
          );

          strokeWeight(ESPESSURA_CORRENTE_ATIVA);

          line(
            ilhas[i].x, ilhas[i].y,
            ilhas[j].x, ilhas[j].y
          );

        } else {

          stroke(
            COR_CORRENTE_INATIVA_R,
            COR_CORRENTE_INATIVA_G,
            COR_CORRENTE_INATIVA_B
          );

          strokeWeight(ESPESSURA_CORRENTE_INATIVA);

          desenharTracejado(
            ilhas[i].x, ilhas[i].y,
            ilhas[j].x, ilhas[j].y
          );
        }
      }
    }
  }

  // Desenha uma linha tracejada

  void desenharTracejado(float x1, float y1, float x2, float y2) {

    for (int i = 0; i < PARTES_TRACEJADO; i += PASSO_TRACEJADO) {

      float t1 = i / (float) PARTES_TRACEJADO;
      float t2 = (i + 1) / (float) PARTES_TRACEJADO;

      line(
        lerp(x1, x2, t1),
        lerp(y1, y2, t1),
        lerp(x1, x2, t2),
        lerp(y1, y2, t2)
      );
    }
  }
}
