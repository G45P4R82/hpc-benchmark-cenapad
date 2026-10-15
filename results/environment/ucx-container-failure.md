# Evidencia: falha do container UCX

O job combinado `1030256.ada` foi executado em dois nos PBS. A parte nativa
CH4:UCX iniciou, mas o container falhou ao abrir o provider verbs.

Evidencias observadas nos logs completos em
`results/raw/ucx-combined-1030256.ada/`:

```text
UCX WARN network device mlx5_0:1 is not available
UCX WARN transports rc,ud are not available
UCX ERROR no active messages transport
Fatal error in internal_Init
Destination is unreachable
```

O container enxergou interfaces TCP (`ib0` como TCP), mas nao enxergou o
dominio InfiniBand `mlx5_0`. Esses resultados nao foram tratados como
comunicacao InfiniBand e nao foram usados para calcular desempenho.

Os jobs finais `1029486.ada` e `1029489.ada` continuam aguardando recursos na
fila `parexp`. Enquanto eles nao iniciarem, nao ha logs finais UCX para
substituir esta evidencia do piloto.
