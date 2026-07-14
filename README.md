# 🐛 BugTrace DB - Rastreador de Bugs e Auditoria

O **BugTrace DB** é um modelo de banco de dados relacional robusto e otimizado, projetado para gerenciar o ciclo de vida de tarefas, bugs e auditoria de alterações em um fluxo de desenvolvimento de software (estilo "mini-Jira").

Este projeto foi construído utilizando **MariaDB (10.11)** dentro de **Containers Docker**, facilitando a portabilidade e permitindo que qualquer desenvolvedor suba o ambiente completo localmente com apenas um comando.

---

## 🛠️ Arquitetura e Decisões de Modelagem

O design do banco foi pensado para simular cenários de alta concorrência e exigência de consistência de dados do mundo real.

### 1. Modelo de Entidades e Relacionamentos
* **`users`**: Registra os membros da equipe de desenvolvimento.
* **`issues`**: Registra as tarefas ou bugs. Possui um relacionamento **1:N** (Um para Muitos) com a tabela de usuários através do campo `reporter_id` (quem abriu o chamado).
* **`issue_history`**: Tabela de auditoria utilizada para registrar o histórico de alteração de status de cada tarefa, permitindo rastreabilidade total do ciclo de vida das demandas.

### 2. Automação com Triggers (Gatilhos de Banco)
Para garantir a integridade dos dados e evitar que a aplicação backend precise gerenciar logs manualmente, implementamos uma **Trigger (`tg_clean_issues_status_history`)** na tabela `issues`.
* Sempre que o `status` de uma tarefa é atualizado, o banco de dados insere de forma 100% automática o registro de histórico de transição na tabela `issue_history`.

### 3. Otimização de Performance (Índices)
* Criamos o índice `idx_issues_status` na tabela `issues` para acelerar consultas filtradas pelo estado das tarefas (como exibir apenas demandas abertas no dashboard), evitando escaneamentos completos de tabela (*Table Scans*) em ambientes com milhões de registros.

### 4. Camada de Abstração (Views)
* Criamos a View **`v_issue_history_report`** para encapsular uma query complexa com múltiplos `INNER JOINs`. Isso simplifica a vida do desenvolvedor, permitindo extrair relatórios de histórico legíveis com simples comandos `SELECT`.

---

## 🚀 Como Executar o Projeto Localmente

Graças ao Docker, você não precisa instalar o MariaDB fisicamente na sua máquina.

### Pré-requisitos
* [Docker](https://docs.docker.com/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/install/)

### Passo a Passo

1. **Clone este repositório:**
   ```bash
   git clone [https://github.com/seu-usuario/bugtrace-db.git](https://github.com/seu-usuario/bugtrace-db.git)
   cd bugtrace-db