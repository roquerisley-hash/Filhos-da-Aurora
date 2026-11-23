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
  
  Criatura(DNA dna_, Ilha ilha) {
    this.x = ilha.x;
    this.y = ilha.y;
    this.dna = dna_;
    this.energia = ENERGIA;
    this.viva = true;
    
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
      
      if(posicaoCriatura.dist(posicaoIlha) < percepcao && ilha.pendentes() > 0) {   
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
    
    for(Ilha ilha : ilhas) {
      if(ilha.contem(x, y)) ilhaAtual = ilha;
    }
    
    if(this.ilhaDestino.pendentes() == 0 && ilhaAtual.contem(x, y)) {
      procurarIlha(ilhas);
    }
    
    if(ilhaAtual != ilhaDestino) {
      mover();
    } else {
      energia -= CUSTO_PARADO;    
      // coleta de flores (não é minha parte)
    }
    
    // this.desenhar(x, y);
    
    if(this.energia <= 0) {
      this.viva = false;
    } 

  }
  
  void mover() {
    int posicaoCaminho = 0;
      
    for(int i = 0; i < caminho.size(); i++) {
      if(caminho.get(i) == ilhaAtual.id) {
        posicaoCaminho = i;
      }
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
    
    float custoEnergia = grafo.matrizAdjacencia[ilhaAtual.id][proximaIlha.id] * (1 - eficiencia);
    energia -= custoEnergia;
  }
  
}
