# Spack

Este diretório contém o modelo e o instalador do MPICH nativo. A especificação
final deve ser escolhida no cluster, pois os nomes das variantes são
dependentes da versão do Spack.

## Procedimento

```bash
spack info mpich
spack info ucx
spack compiler list

export MPICH_SPEC='mpich@VERSAO %gcc@VERSAO [variantes confirmadas em spack info]'
bash spack/install.sh
```

Depois da instalação, versionar os arquivos gerados:

```text
spack/env/spack.yaml -> spack/spack.yaml
spack/env/spack.lock -> spack/spack.lock
spack/concretized-spec.txt
spack/installed.txt
spack/install.log
```

Não substitua o `spack.lock` real por um exemplo. O arquivo deve ser gerado
pela mesma versão do Spack usada no cluster.
