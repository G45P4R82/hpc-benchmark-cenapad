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
