# DOTFILES

## Visão Geral
Este repositório de dotfiles fornece uma configuração completa de ambiente de desenvolvimento para Ubuntu 22.04. Automatiza a instalação e configuração de ferramentas para:
- **Frontend**: NVM, Node.js, pacotes npm
- **Backend**: .NET, Python, Go
- **SRE/DevOps**: kubectl, terraform, ansible, AWS CLI, Docker

## Requisitos
- Ubuntu 22.04 (WSL ou nativo)
- Git
- Conexão com internet

## Instalação Rápida

**⚠️ Importante**: Você precisará interagir com o script para senha sudo e algumas confirmações de pacotes.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Zandler/dotfiles/refs/heads/main/install.sh)"
```

### O que o script faz:
1. Valida o ambiente Ubuntu
2. Clona este repositório para `~/.dotfiles`
3. Executa bootstrap.sh para configuração completa
4. Configura zsh com Oh My Zsh, plugins e prompt Starship

## Instalação Manual

```bash
git clone https://github.com/Zandler/dotfiles ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

## Ferramentas Instaladas

### Ferramentas de Desenvolvimento
- **Linguagens**: Node.js (via NVM), Python 3, .NET SDK, Go
- **Editores**: Vim, Helix
- **Controle de Versão**: Git com configuração personalizada

### Ferramentas DevOps/SRE
- **Container**: Docker, Docker Compose
- **Kubernetes**: kubectl, kubectx, k9s, helm
- **Infraestrutura**: Terraform, Terragrunt, Ansible
- **Cloud**: AWS CLI
- **Monitoramento**: htop, k6

### Melhorias do Terminal
- **Shell**: Zsh com Oh My Zsh
- **Prompt**: Starship
- **Listagem de arquivos**: eza (substituto moderno do ls)
- **Plugins**: autosuggestions, syntax highlighting, autocomplete

## Referência de Aliases

### Operações de Arquivo
| Alias | Comando | Descrição | Exemplo |
|-------|---------|-----------|---------|
| `ls` | `eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons` | Listagem aprimorada com ícones e status git | `ls` |
| `ll` | `eza --tree --level=2 --color=always --group-directories-first --icons` | Visualização em árvore de diretórios (2 níveis) | `ll` |

### Kubernetes - Obter Recursos
| Alias | Comando | Descrição | Exemplo |
|-------|---------|-----------|---------|
| `kgp` | `kubecolor get pods` | Lista todos os pods com cores | `kgp -n default` |
| `kgs` | `kubecolor get services` | Lista todos os serviços | `kgs --all-namespaces` |
| `kgd` | `kubecolor get deployments` | Lista todos os deployments | `kgd -o wide` |
| `kgn` | `kubecolor get nodes` | Lista todos os nós | `kgn` |
| `kgi` | `kubecolor get ingress` | Lista todos os recursos ingress | `kgi -n production` |
| `kgns` | `kubecolor get namespaces` | Lista todos os namespaces | `kgns` |

### Kubernetes - Deletar Recursos
| Alias | Comando | Descrição | Exemplo |
|-------|---------|-----------|---------|
| `kdp` | `kubecolor delete pod` | Deleta um pod | `kdp my-pod-123` |
| `kdd` | `kubecolor delete deployment` | Deleta um deployment | `kdd my-app` |
| `kds` | `kubecolor delete service` | Deleta um serviço | `kds my-service` |
| `kdns` | `kubecolor delete namespace` | Deleta um namespace | `kdns test-env` |
| `kdi` | `kubecolor delete ingress` | Deleta um ingress | `kdi my-ingress` |

### Kubernetes - Descrever Recursos
| Alias | Comando | Descrição | Exemplo |
|-------|---------|-----------|---------|
| `kdsp` | `kubecolor describe pod` | Descreve um pod | `kdsp my-pod-123` |
| `kdsd` | `kubecolor describe deployment` | Descreve um deployment | `kdsd my-app` |
| `kdsn` | `kubecolor describe node` | Descreve um nó | `kdsn worker-node-1` |
| `kdss` | `kubecolor describe service` | Descreve um serviço | `kdss my-service` |
| `kdsi` | `kubecolor describe ingress` | Descreve um ingress | `kdsi my-ingress` |
| `kdnsd` | `kubecolor describe namespace` | Descreve um namespace | `kdnsd production` |

### Kubernetes - Operações
| Alias | Comando | Descrição | Exemplo |
|-------|---------|-----------|---------|
| `kcr` | `kubecolor create -f` | Cria recursos a partir de arquivo | `kcr deployment.yaml` |
| `ked` | `kubecolor edit deployment` | Edita um deployment | `ked my-app` |
| `kep` | `kubecolor edit pod` | Edita um pod | `kep my-pod-123` |
| `krun` | `kubecolor run` | Executa um pod | `krun test --image=nginx` |
| `kexec` | `kubecolor exec` | Executa comando em pod | `kexec -it my-pod -- /bin/bash` |

## Arquivos de Configuração

- **Zsh**: `~/.zshrc` - Configuração do shell com plugins e aliases
- **Starship**: `~/.config/starship.toml` - Configuração do prompt do terminal
- **Helix**: `~/.config/helix/` - Configuração do editor de texto
- **Git**: Gitignore global e configurações do usuário

## Personalização

Para adicionar suas próprias configurações:
1. Faça um fork deste repositório
2. Modifique os arquivos de configuração em `home/` e `config/`
3. Atualize `install.conf.yaml` se necessário
4. Execute o script de instalação

## Contribuindo

Contribuições são bem-vindas! Por favor:
1. Faça um fork do repositório
2. Crie uma branch de feature
3. Faça suas alterações
4. Teste a instalação
5. Envie um pull request

## Solução de Problemas

- **Erros de permissão**: Certifique-se de ter acesso sudo
- **Problemas de rede**: Verifique a conexão com internet para downloads
- **Conflitos de pacotes**: Remova pacotes conflitantes antes da instalação
- **Shell não mudando**: Faça logout e login novamente após a instalação

---

**Autor**: Zandler  
**Email**: zandler@outlook.com  
**Licença**: MIT