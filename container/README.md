# Contêiner

## Geração

Execute no ambiente que possui HPCCM:

```bash
hpccm --version
hpccm --recipe container/recipe.py --format singularity > container/Singularity.def
hpccm --recipe container/recipe.py --format docker > container/Dockerfile
```

Ou use:

```bash
bash container/build.sh singularity
```

Os argumentos da receita são definidos por `--userarg`, por exemplo:

```bash
hpccm --recipe container/recipe.py --format singularity \
  --userarg mpich=4.2.3 \
  --userarg ucx=1.18.1 \
  --userarg osu=7.5.2 \
  --userarg ofed_url=https://servidor.cluster/ofed-userspace.tar.gz \
  > container/Singularity.def
```

O `ofed_url` deve apontar para um pacote de espaço de usuário aprovado pelo
administrador e compatível com o driver do cluster. Não substitua o driver do
kernel do host dentro do contêiner. Se `ofed_url` ficar vazio, a receita usa os
pacotes RDMA do Ubuntu, o que serve apenas como fallback e precisa ser validado
antes de qualquer medição.

## Construção

```bash
apptainer build container/osu-mpich-ucx.sif container/Singularity.def
```

Em ambientes sem privilégio, use o mecanismo de construção autorizado pelo
cluster, como `--fakeroot` ou uma máquina de build aprovada.

## Construção offline

Para respeitar o requisito de usar somente artefatos existentes no CENAPAD,
use `recipe-offline.py` e um `offline-bundle` fornecido pelo cluster. Essa
receita não baixa imagens, pacotes ou fontes e não executa `apt-get`.

```bash
export BASE_IMAGE=/caminho/local/ubuntu-24.04.sif
export OFFLINE_BUNDLE=/caminho/local/offline-bundle
bash container/build-offline.sh singularity
```

Se Apptainer não estiver disponível na máquina local, o script gera
`container/Singularity.offline.def`; transfira esse arquivo e o bundle para o
cluster e execute a construção com a versão autorizada do Singularity.
