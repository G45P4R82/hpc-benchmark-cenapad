# Reprodutibilidade e Segurança

O repositório deve conter comandos, versões, checksums, especificações
concretizadas e parâmetros PBS suficientes para repetir o estudo.

Não versionar:

- tokens, senhas ou chaves SSH;
- nomes de nós se forem informação restrita;
- URLs internas que exponham credenciais;
- imagens grandes se a política do GitHub não permitir;
- logs que contenham dados sensíveis.

Os resultados de desempenho, por outro lado, devem ser preservados quando não
contiverem informação restrita. Se o cluster não permitir publicar logs crus,
publique uma versão sanitizada e documente a transformação.

As versões devem ser registradas no momento da execução, não inferidas da
versão atual dos sites. O arquivo `spack.lock` é a fonte de reprodução do
ambiente Spack; a receita HPCCM é a fonte de reprodução da imagem.
