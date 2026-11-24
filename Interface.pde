class Interface {
  void desenhar(Jogador jogador, Populacao populacao, int criaturasVivas) {
    pushStyle();
    rectMode(CORNER);
    noStroke();
    fill(22, 32, 66);
    rect(16, 14, width - 32, 94, 10);
    rect(16, height - 100, width - 32, 86, 10);

    textAlign(LEFT, TOP);
    textSize(22);
    fill(255);
    text("Filhos da Aurora", 32, 24);

    textSize(16);
    fill(255, 221, 121);
    text("Luz: " + jogador.getLuz() + "  |  Ilha: " + jogador.getIlha().nome, 250, 29);

    textSize(14);
    fill(225, 235, 255);
    if (populacao != null) {
      text("Geração: " + populacao.geracao, 32, 59);
      if (populacao.individuos.size() > 0) {
        text("Médias  |  Velocidade: " + nf(populacao.mediaGene(GENE_VELOCIDADE), 1, 2)
          + "  |  Eficiência: " + nf(populacao.mediaGene(GENE_EFICIENCIA), 1, 2)
          + "  |  Percepção: " + nf(populacao.mediaGene(GENE_PERCEPCAO), 1, 2), 32, 81);
      }
    }
    if (criaturasVivas >= 0) {
      text("Criaturas vivas: " + criaturasVivas, 165, 59);
    } else if (populacao != null) {
      text("População: " + populacao.individuos.size(), 165, 59);
    }
    if (populacao == null && criaturasVivas < 0) {
      text("Estatísticas da população aguardam integração.", 32, 67);
    }

    text("Clique esquerdo: viajar por corrente ativa  |  E: coletar luz  |  F: plantar flor ("
      + CUSTO_FLOR_AMBIENTE + " de luz)", 32, height - 90);
    text("Clique direito na ilha de destino: restaurar corrente entre ilhas despertas ("
      + CUSTO_RESTAURACAO_AMBIENTE + " de luz)", 32, height - 69);

    fill(255, 221, 121);
    text(jogador.getMensagem(), 32, height - 44);
    popStyle();
  }
}
