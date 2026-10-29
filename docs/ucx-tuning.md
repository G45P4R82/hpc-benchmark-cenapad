# MPICH CH4/UCX: plano de ajuste

O piloto OFI atingiu aproximadamente 26% dos 100 Gb/s teóricos. Ele não é o
resultado final solicitado: o módulo institucional usava `CH4:OFI/libfabric`.
Este procedimento deve ser executado pelo técnico no cluster com o MPICH
compilado como `CH4:UCX`.

## Especificação

Usar um ambiente Spack separado e preservar o lockfile:

```text
mpich@4.1.1%gcc@9.4.0 device=ch4 netmod=ucx
ucx@1.15.0 +verbs +rdmacm
```

Confirmar no `spack.lock` que o MPICH não está usando OFI como netmod e que o
UCX foi construído com verbs/RDMA.

## Variáveis de execução

O script `pbs/run_ucx_benchmarks.pbs` fixa, por padrão:

```bash
UCX_TLS=rc,sm,self
UCX_NET_DEVICES=mlx5_0:1
UCX_LOG_LEVEL=warn
```

Para diagnóstico, usar `UCX_LOG_LEVEL=info` em uma execução curta. Os logs
devem mostrar `rc_mlx5` ou outro transporte RDMA e não `tcp`.

## Faixa e repetições

Executar três repetições dos dois benchmarks, de 1 byte até 64 MiB. O script
permite alterar a faixa e as iterações sem editar o arquivo:

```bash
export MESSAGE_RANGE=1:67108864
export WARMUP=100
export ITERATIONS=1000
```

Se o teste de 64 MiB não progredir, repetir por faixas menores e registrar o
erro. Não substituir silenciosamente o resultado por OFI.

## Compilações a comparar

Para identificar a causa da baixa banda, registrar separadamente:

1. MPICH do módulo (`CH4:OFI`) como baseline histórico.
2. MPICH Spack `CH4:UCX` com otimização padrão.
3. MPICH Spack `CH4:UCX` com `-O3`, se permitido.

Não usar `-march` específico sem confirmar que os dois nós têm o mesmo modelo
de CPU. Para cada caso, guardar `mpichversion`, `mpicc -show`, `ucx_info -v`,
`ucx_info -d`, `fi_info` e o log completo.

## Critério de validade

Host e contêiner devem usar a mesma construção CH4/UCX, os mesmos dois nós,
launcher, afinidade, faixa de mensagens e variáveis UCX. O relatório deve
separar claramente o piloto OFI dos resultados finais UCX.
