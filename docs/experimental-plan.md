# Plano Experimental

## 1. Pergunta

Qual é a diferença de desempenho entre executar os OSU Micro-Benchmarks

## 2. Ambiente a registrar

Antes da instalação e dos testes, registrar:

- distribuição e kernel dos nós CPU;
- arquitetura e modelo do processador;
- versão do GCC;
- versão do Spack;
- versão do MPICH e sua especificação concretizada;
- versão do UCX;
- versão e caminho das bibliotecas de usuário Mellanox OFED;
- versão do Apptainer ou Singularity;
- versão do HPCCM;
- versão do OSU Micro-Benchmarks;
- nomes dos nós utilizados e configuração PBS;
- informações de `ibstat`, `ibv_devinfo` e do dispositivo UCX.

## 3. Instalação nativa

O ambiente Spack deverá instalar MPICH com:

- compilador GCC;
- dispositivo de comunicação CH4;
- netmod UCX;
- suporte às bibliotecas de usuário InfiniBand disponíveis no cluster.

O OSU Micro-Benchmarks será compilado usando os wrappers do MPICH instalado

## 4. Contêiner

A receita HPCCM deverá usar Ubuntu 24.04 como base e produzir, no mínimo:

- a receita Python HPCCM;
- uma definição Singularity/Apptainer gerada;
- documentação do comando de geração;
- documentação do comando de construção;
- versão compatível de GCC, MPICH, UCX, OFED e OSU.

Os drivers do kernel não serão instalados no contêiner. O contêiner deverá

## 5. Execução

Cada cenário será executado pelo PBS com dois processos MPI, um por nó:

1. `osu_bw` nativo;
2. `osu_bw` no contêiner;
3. `osu_latency` nativo;
4. `osu_latency` no contêiner.

Cada combinação terá pelo menos três repetições. Os nós, a afinidade, os

O launcher MPI do host iniciará os processos do contêiner. A compatibilidade

## 6. Verificação da rede

Os logs deverão incluir, quando disponíveis:

- `ibstat` ou `ibv_devinfo`;
- `ucx_info -v` e informações dos transports;
- versão/configuração do MPICH;
- variáveis UCX e MPICH relevantes;
- identificação dos nós e ranks;
- evidência de que o transporte selecionado não foi TCP.

## 7. Análise

Para cada tamanho de mensagem, calcular média e desvio-padrão ou intervalo

- largura de banda versus tamanho da mensagem;
- latência versus tamanho da mensagem.

O eixo do tamanho da mensagem poderá usar escala logarítmica. A comparação

```text
100 Gb/s = 12.500 MB/s (MB decimal)
percentual teórico = largura_de_banda_MB_s / 125
```

O relatório discutirá o crescimento da latência, a saturação da largura de

## 8. Decisões pendentes

- versão exata do MPICH disponível no momento da instalação;
- versão do UCX e do Mellanox OFED no cluster;
- versão estável do OSU usada no experimento;
- versão do Apptainer/Singularity e permissões de construção;
- nós CPU autorizados para o experimento;
- parâmetros PBS, afinidade e política de exclusividade;
- tamanhos de mensagem e parâmetros finais dos benchmarks.
