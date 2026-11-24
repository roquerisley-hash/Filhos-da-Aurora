// =============== CONSTANTES GLOBAIS ======================

final int LARGURA_TELA = 1000;
final int ALTURA_TELA = 650;
final int QUANTIDADE_ILHAS = 6;

final int SEM_ILHA = -1;
final int SEM_CORRENTE = 0;
final int INFINITO = 9999999;

final int PROGRESSO_INICIAL = 0;
final int SEM_FLORES_PENDENTES = 0;
final int PROGRESSO_POR_POLINIZACAO = 1;

final int QUANTIDADE_FLORES_INICIAL = 20;
final int POLINIZACOES_POR_FLOR = 3;

// IDENTIFICADORES DAS ILHAS

final int ILHA_GIRASSOL = 0;
final int ILHA_LAVANDA = 1;
final int ILHA_MARGARIDA = 2;
final int ILHA_HIBISCO = 3;
final int ILHA_JASMIM = 4;
final int ILHA_DALIA = 5;

// POSIÇÕES DAS ILHAS

final float POS_GIRASSOL_X = 0.18;
final float POS_GIRASSOL_Y = 0.62;

final float POS_LAVANDA_X = 0.38;
final float POS_LAVANDA_Y = 0.35;

final float POS_MARGARIDA_X = 0.42;
final float POS_MARGARIDA_Y = 0.72;

final float POS_HIBISCO_X = 0.64;
final float POS_HIBISCO_Y = 0.30;

final float POS_JASMIM_X = 0.68;
final float POS_JASMIM_Y = 0.68;

final float POS_DALIA_X = 0.85;
final float POS_DALIA_Y = 0.48;

// CUSTOS DAS CORRENTES

final int CUSTO_GIRASSOL_LAVANDA = 3;
final int CUSTO_GIRASSOL_MARGARIDA = 4;
final int CUSTO_LAVANDA_MARGARIDA = 2;
final int CUSTO_LAVANDA_HIBISCO = 5;
final int CUSTO_MARGARIDA_HIBISCO = 6;
final int CUSTO_MARGARIDA_JASMIM = 4;
final int CUSTO_HIBISCO_JASMIM = 2;
final int CUSTO_HIBISCO_DALIA = 4;
final int CUSTO_JASMIM_DALIA = 3;

// APARÊNCIA

final float LARGURA_ILHA = 115;
final float ALTURA_ILHA = 82;

final float DIVISOR_DIAMETRO = 2.0;
final float LIMITE_ELIPSE = 1.0;

final int PARTES_TRACEJADO = 14;
final int PASSO_TRACEJADO = 2;

final int ESPESSURA_CORRENTE_ATIVA = 4;
final int ESPESSURA_CORRENTE_INATIVA = 2;
final int ESPESSURA_ILHA = 2;

final int COR_FUNDO_R = 40;
final int COR_FUNDO_G = 55;
final int COR_FUNDO_B = 100;

final int COR_BRANCO = 255;
final int COR_TEXTO = 255;

final int COR_CORRENTE_ATIVA_R = 145;
final int COR_CORRENTE_ATIVA_G = 220;
final int COR_CORRENTE_ATIVA_B = 255;

final int COR_CORRENTE_INATIVA_R = 150;
final int COR_CORRENTE_INATIVA_G = 165;
final int COR_CORRENTE_INATIVA_B = 180;

// CONSTANTES DA CRIATURA

final float ENERGIA = 100;

final int GENE_VELOCIDADE = 0;
final int GENE_PERCEPCAO = 1;
final int GENE_EFICIENCIA = 2;

final float CUSTO_PARADO = 2;

Ilha[] ilhas;
Grafo grafo;
Ambiente ambiente;
Jogador jogador;
Interface painel;
Sprites sprites;

void settings() {
  size(LARGURA_TELA, ALTURA_TELA);
}

void setup() {
  criarMapa();
  ambiente = new Ambiente(ilhas, new Populacao());
  jogador = new Jogador(grafo, ILHA_GIRASSOL, ambiente);
  painel = new Interface();
  sprites = new Sprites();
}

void draw() {
  ambiente.atualizar();
  background(COR_FUNDO_R, COR_FUNDO_G, COR_FUNDO_B);

  grafo.desenhar();
  sprites.desenharCorrentes(grafo);

  for (Ilha ilha : ilhas) {
    ilha.desenhar();
  }
  ambiente.desenharCriaturas();
  sprites.desenharRecursos(grafo, jogador);
  jogador.desenhar();

  painel.desenhar(jogador, ambiente.populacao, ambiente.contarVivas());
  sprites.desenharLegenda(width - 370, 46);
}

void mousePressed() {
  jogador.clicar(mouseX, mouseY, mouseButton);
}

void keyPressed() {
  jogador.tecla(key);
}

void criarMapa() {

  ilhas = new Ilha[QUANTIDADE_ILHAS];

  ilhas[ILHA_GIRASSOL] = new Ilha(
    ILHA_GIRASSOL, "Girassol",
    width * POS_GIRASSOL_X, height * POS_GIRASSOL_Y,
    QUANTIDADE_FLORES_INICIAL, POLINIZACOES_POR_FLOR, true
  );

  ilhas[ILHA_LAVANDA] = new Ilha(
    ILHA_LAVANDA, "Lavanda",
    width * POS_LAVANDA_X, height * POS_LAVANDA_Y,
    QUANTIDADE_FLORES_INICIAL, POLINIZACOES_POR_FLOR, true
  );

  ilhas[ILHA_MARGARIDA] = new Ilha(
    ILHA_MARGARIDA, "Margarida",
    width * POS_MARGARIDA_X, height * POS_MARGARIDA_Y,
    QUANTIDADE_FLORES_INICIAL, POLINIZACOES_POR_FLOR, true
  );

  ilhas[ILHA_HIBISCO] = new Ilha(
    ILHA_HIBISCO, "Hibisco",
    width * POS_HIBISCO_X, height * POS_HIBISCO_Y,
    QUANTIDADE_FLORES_INICIAL, POLINIZACOES_POR_FLOR, false
  );

  ilhas[ILHA_JASMIM] = new Ilha(
    ILHA_JASMIM, "Jasmim",
    width * POS_JASMIM_X, height * POS_JASMIM_Y,
    QUANTIDADE_FLORES_INICIAL, POLINIZACOES_POR_FLOR, false
  );

  ilhas[ILHA_DALIA] = new Ilha(
    ILHA_DALIA, "Dália",
    width * POS_DALIA_X, height * POS_DALIA_Y,
    QUANTIDADE_FLORES_INICIAL, POLINIZACOES_POR_FLOR, false
  );

  grafo = new Grafo(ilhas);

  //correntes inicialmente ativas

  grafo.adicionarCorrente(
    ILHA_GIRASSOL, ILHA_LAVANDA,
    CUSTO_GIRASSOL_LAVANDA, true
  );

  grafo.adicionarCorrente(
    ILHA_GIRASSOL, ILHA_MARGARIDA,
    CUSTO_GIRASSOL_MARGARIDA, true
  );

  grafo.adicionarCorrente(
    ILHA_LAVANDA, ILHA_MARGARIDA,
    CUSTO_LAVANDA_MARGARIDA, true
  );

  // correntes inicialmente inativas

  grafo.adicionarCorrente(
    ILHA_LAVANDA, ILHA_HIBISCO,
    CUSTO_LAVANDA_HIBISCO, false
  );

  grafo.adicionarCorrente(
    ILHA_MARGARIDA, ILHA_HIBISCO,
    CUSTO_MARGARIDA_HIBISCO, false
  );

  grafo.adicionarCorrente(
    ILHA_MARGARIDA, ILHA_JASMIM,
    CUSTO_MARGARIDA_JASMIM, false
  );

  grafo.adicionarCorrente(
    ILHA_HIBISCO, ILHA_JASMIM,
    CUSTO_HIBISCO_JASMIM, false
  );

  grafo.adicionarCorrente(
    ILHA_HIBISCO, ILHA_DALIA,
    CUSTO_HIBISCO_DALIA, false
  );

  grafo.adicionarCorrente(
    ILHA_JASMIM, ILHA_DALIA,
    CUSTO_JASMIM_DALIA, false
  );
}
