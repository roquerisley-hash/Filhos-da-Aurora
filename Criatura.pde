class Criatura {
  DNA dna;
  
  Ilha ilhaAtual;
  ArrayList<Integer> caminho;
  Ilha ilhaDestino;
  
  float x, y;
  float velocidade;
  float eficiencia;
  float percepcao;
  float energia;
  
  boolean viva;
  
  int polinizacoes;   // usado na avaliação (aptidão)
  int recarga;        // quadros até poder polinizar de novo
  
  Criatura(DNA dna_, Ilha ilha) {
    this.x = ilha.x;
    this.y = ilha.y;
    this.dna = dna_;
    this.energia = ENERGIA;
    this.viva = true;
    this.polinizacoes = 0;
    this.recarga = 0;
    
    this.ilhaAtual = ilha;
    this.ilhaDestino = ilha;
    this.caminho = new ArrayList<Integer>();
    
    this.velocidade = map(dna.genes[GENE_VELOCIDADE], 0, 1, 2, 5);
    this.percepcao = map(dna.genes[GENE_PERCEPCAO], 0, 1, 300, 600);
    this.eficiencia = map(dna.genes[GENE_EFICIENCIA], 0, 1, 0.25, 0.75);
  }
  
  
  
  void procurarIlha(Ilha[] ilhas) {
    int distIlhaDestino = INFINITO;
    Ilha ilhaDestino = ilhaAtual; 
    ArrayList<Integer> menorCaminho = new ArrayList<>();
    
    PVector posicaoCriatura = new PVector(x, y);
    for(Ilha ilha : ilhas) {
      PVector posicaoIlha = new PVector(ilha.x, ilha.y);
      
      // só considera ilhas despertas com flores pendentes
      if(posicaoCriatura.dist(posicaoIlha) < percepcao && ilha.precisaPolinizacao()) {   
        ArrayList<Integer> caminhoCandidato = grafo.menorCaminho(ilhaAtual.id, ilha.id);   
        int distancia = grafo.custoCaminho(caminhoCandidato);
        
        if(!caminhoCandidato.isEmpty() && distancia < distIlhaDestino) {   
          distIlhaDestino = distancia;
          ilhaDestino = ilha;
          menorCaminho = caminhoCandidato;                           
        }
      }
    }
    this.ilhaDestino = ilhaDestino;
    this.caminho = menorCaminho;
  }
  
  void atualizar() {
    
    if(!viva) return;
    
    // só troca de ilha atual se ela faz parte do caminho (evita confusão
    // quando a linha da corrente cruza outra ilha)
    for(Ilha ilha : ilhas) {
      if(ilha.contem(x, y) && (caminho.isEmpty() || caminho.contains(ilha.id))) {
        ilhaAtual = ilha;
      }
    }
    
    if(!this.ilhaDestino.precisaPolinizacao() && ilhaAtual.contem(x, y)) {
      procurarIlha(ilhas);
    }
    
    if(ilhaAtual != ilhaDestino) {
      mover();
    } else {
      energia -= CUSTO_PARADO;    
      polinizar();
    }
    
    if(this.energia <= 0) {
      this.viva = false;
    } 

  }
  
  // coleta de flores: poliniza a ilha atual e ganha néctar (energia)
  void polinizar() {
    if(recarga > 0) {
      recarga--;
      return;
    }
    
    if(ilhaAtual.polinizar()) {
      polinizacoes++;
      energia = min(ENERGIA, energia + NECTAR_POR_POLINIZACAO);
      recarga = RECARGA_POLINIZACAO;
    }
  }
  
  void mover() {
    int posicaoCaminho = caminho.indexOf(ilhaAtual.id);
    
    // caminho inválido: desiste e procura outro destino
    if(posicaoCaminho < 0 || posicaoCaminho + 1 >= caminho.size()) {
      ilhaDestino = ilhaAtual;
      caminho = new ArrayList<Integer>();
      return;
    }
      
    Ilha proximaIlha = ilhas[caminho.get(posicaoCaminho + 1)];
    PVector posicaoProximaIlha = new PVector(proximaIlha.x, proximaIlha.y);
    PVector posicaoAtual = new PVector(x, y);
      
    PVector direcao = PVector.sub(posicaoProximaIlha, posicaoAtual);
    direcao.normalize();
    direcao.mult(velocidade);
      
    PVector proximaPosicao = PVector.add(posicaoAtual, direcao);
      
    this.x = proximaPosicao.x;
    this.y = proximaPosicao.y;
    
    float custoEnergia = grafo.matrizAdjacencia[ilhaAtual.id][proximaIlha.id]
                         * (1 - eficiencia) * FATOR_CUSTO_MOVIMENTO;
    energia -= custoEnergia;
  }
  
  // a cor da criatura reflete seus genes (R = velocidade, G = eficiência, B = percepção)
  void desenhar() {
    pushStyle();
    noStroke();
    if(viva) {
      fill(120 + dna.genes[GENE_VELOCIDADE] * 135,
           120 + dna.genes[GENE_EFICIENCIA] * 135,
           120 + dna.genes[GENE_PERCEPCAO] * 135);
    } else {
      fill(120, 120, 120, 100);
    }
    ellipse(x, y, RAIO_CRIATURA * 2, RAIO_CRIATURA * 2);
    popStyle();
  }
  
}
