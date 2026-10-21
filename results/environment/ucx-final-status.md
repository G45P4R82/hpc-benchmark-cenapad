# Status final do protocolo CH4:UCX

## Nativo

O job `1032214.ada` terminou com `Exit_status=0` em dois nos PBS (`adano24`
e `adano09`). Os seis logs completos foram preservados em
`results/raw/ucx-final-native-1032214/`.

O job usou MPICH 4.1.1 compilado com `--with-device=ch4:ucx`, UCX 1.15.0 e
OSU Micro-Benchmarks 7.5.2.

## Container

O job `1032298.ada` terminou, mas nenhum dos seis arquivos contém uma medida
OSU valida. O UCX dentro do SIF nao encontrou o provider verbs `mlx5_0` e
abortou o MPI com `Destination is unreachable`. Os logs completos da falha
estao em `results/raw/ucx-final-container-1032298/`.

A falha foi preservada como evidencia. TCP fallback nao foi tratado como
resultado de InfiniBand.

## Conclusao

O protocolo original tem resultado nativo UCX valido, mas nao tem resultado
comparavel de container UCX. O relatorio deve apresentar essa assimetria e nao
inventar valores para o container.
