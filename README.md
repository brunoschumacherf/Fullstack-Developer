# Umanni — User Management

Aplicação fullstack de gerenciamento de usuários construída com **Ruby on Rails 8**, **React 19** e **Inertia.js**. Permite que administradores criem, editem e importem usuários em massa via CSV ou Excel, com progresso de importação em tempo real via ActionCable.

---

## Stack

| Camada | Tecnologia |
|---|---|
| Backend | Ruby 4 · Rails 8.1 · PostgreSQL 16 |
| Frontend | React 19 · TypeScript · Tailwind CSS 4 |
| Bridge | Inertia.js 3 · Vite 8 |
| Filas | Solid Queue |
| Cache | Solid Cache |
| WebSocket | Solid Cable + ActionCable |
| Testes (Ruby) | RSpec · Capybara · Selenium |
| Testes (JS) | Jest · Testing Library |
| Linter | RuboCop (omakase) · TypeScript strict |
| Deploy | Kamal 2 · Thruster |

---

## Pré-requisitos

- Docker & Docker Compose
- Node.js (para rodar Jest localmente, opcional)

---

## Setup

```bash
# 1. Clone o repositório
git clone <repo-url>
cd fullstack-developer

# 2. Copie as variáveis de ambiente
cp .env.example .env

# 3. Suba os containers e prepare o banco
docker compose up -d db
docker compose run --rm app bin/rails db:setup

# 4. Suba tudo
docker compose up
```

A aplicação estará disponível em **http://localhost:3000**.  
O servidor Vite (HMR) roda em **http://localhost:3036**.

---

## Desenvolvimento

```bash
# Subir todos os serviços (Rails + Vite + Solid Queue)
docker compose up

# Rodar um comando avulso dentro do container
docker compose run --rm app <comando>

# Console Rails
docker compose run --rm app bin/rails console

# Migrar banco
docker compose run --rm app bin/rails db:migrate

# Instalar gem nova (após editar o Gemfile)
docker compose run --rm app bundle install
```

---

## Testes

### Ruby — RSpec

```bash
# Suite completa
docker compose run --rm app bundle exec rspec

# Arquivo ou spec específica
docker compose run --rm app bundle exec rspec spec/serializers/user_serializer_spec.rb
docker compose run --rm app bundle exec rspec spec/services/user_imports/

# Com seed fixo (reproduzir falhas)
docker compose run --rm app bundle exec rspec --seed 1234
```

> O relatório de cobertura é gerado em `coverage/index.html` (mínimo configurado: 90% de linhas e branches).

### JavaScript — Jest

```bash
# Suite completa
npm test

# Com cobertura
npm run test:coverage

# Watch mode
npx jest --watch
```

### Verificação de tipos TypeScript

```bash
npm run check
```

---

## Linter

```bash
# RuboCop (verifica e corrige automaticamente o que for seguro)
docker compose run --rm app bundle exec rubocop
docker compose run --rm app bundle exec rubocop -a
```

---

## CI — comando completo

```bash
docker compose run --rm app bundle exec rspec && docker compose run --rm app bundle exec rubocop
```

---

## Arquitetura

```
app/
├── controllers/
│   ├── admin/
│   │   ├── dashboard_controller.rb   # Painel admin
│   │   ├── user_imports_controller.rb
│   │   └── users_controller.rb
│   ├── profiles_controller.rb
│   ├── registrations_controller.rb
│   └── sessions_controller.rb
├── models/
│   ├── user.rb
│   ├── user_import.rb
│   └── session.rb
├── serializers/
│   ├── user_serializer.rb            # ActiveModel::Serializer
│   └── user_import_serializer.rb
├── services/
│   ├── dashboard/
│   │   ├── stats.rb                  # Agrega métricas do painel
│   │   └── broadcaster.rb            # Broadcast via ActionCable
│   └── user_imports/
│       ├── parser_factory.rb         # Seleciona CSV ou Excel parser
│       ├── csv_parser.rb
│       ├── excel_parser.rb
│       └── processor.rb              # Orquestra a importação
└── jobs/
    └── process_user_import_job.rb    # Job assíncrono de importação
```

### Fluxo de importação de usuários

```
Upload CSV/XLSX
      │
      ▼
UserImportsController#create
      │  salva arquivo (Active Storage)
      ▼
ProcessUserImportJob (Solid Queue)
      │
      ▼
UserImports::Processor
      │
      ├── ParserFactory.parse(path, extension)
      │       ├── CsvParser     (.csv)
      │       └── ExcelParser   (.xlsx / .xls / .ods)
      │
      └── import_row → User.create
                │
                └── broadcast_progress → ActionCable → frontend
```

---

## Variáveis de ambiente

| Variável | Descrição | Padrão |
|---|---|---|
| `POSTGRES_USER` | Usuário do banco | `postgres` |
| `POSTGRES_PASSWORD` | Senha do banco | `password` |
| `DB_HOST` | Host do PostgreSQL | `localhost` |
| `DB_PORT` | Porta do PostgreSQL | `5432` |
| `DATABASE_URL` | URL completa (produção) | — |
| `RAILS_MASTER_KEY` | Chave de credenciais Rails | — |
| `INERTIA_SSR` | Habilita SSR do Inertia | `false` |
| `INERTIA_SSR_URL` | URL do servidor SSR | `http://127.0.0.1:13714` |
| `RUBY_ZJIT_ENABLE` | Habilita o ZJIT do Ruby 4 | `0` |

---

## Arquivos de exemplo para importação

Na raiz do projeto há dois arquivos de exemplo prontos para testar o upload:

| Arquivo | Formato |
|---|---|
| `example_users_import.csv` | CSV |
| `example_users_import.xlsx` | Excel |

Colunas suportadas: `full_name`, `email`, `role` (`admin` / `member`), `avatar_url`.

---

## Deploy

O projeto usa **Kamal 2** para deploy via Docker. Consulte `.kamal/` para a configuração de servidores e secrets.

Aplicação publicada: [acessar tela de login](https://fullstack-developer-jhrp.onrender.com/login).

```bash
# Primeiro deploy
kamal setup

# Deploys subsequentes
kamal deploy
```

---

## Desenvolvido com IA — Google Gemini

Este projeto foi desenvolvido com o auxílio do **[Google Gemini](https://gemini.google.com/)** integrado ao editor via **[Antigravity IDE](https://antigravity.dev/)**, o que transformou a forma como o código foi escrito, revisado e testado.

### Autocomplete de código

O Gemini atuou como um par de programação em tempo real ao longo de todo o desenvolvimento. Sugestões de código foram aceitas, adaptadas ou descartadas com senso crítico — a IA acelerou a escrita de boilerplate, mas as decisões de arquitetura, nomes de método e estrutura de pastas foram sempre revisadas e ajustadas manualmente para garantir coerência com o restante do projeto.

Exemplos práticos de onde o autocomplete economizou tempo:

- Geração dos parsers `CsvParser` e `ExcelParser` com a lógica de normalização de cabeçalhos
- Estrutura inicial dos serializers com `ActiveModel::Serializer`
- Corpo dos specs de RSpec (fixtures, `let`, `subject`, contextos)

### Setup de testes

Os specs deste projeto foram escritos **com assistência direta da IA**. O fluxo foi:

1. Escrever o código de produção
2. Pedir ao Gemini para gerar os casos de teste correspondentes
3. Revisar cada spec — ajustar fixtures, corrigir edge cases e garantir que os testes realmente validam o comportamento esperado, não apenas que o código roda

Esse processo revelou bugs reais: a ordem de `create!` vs `attach` no `UserImportSerializer` spec, por exemplo, foi identificada exatamente porque a IA gerou um spec que tentou criar o registro antes do arquivo estar anexado — forçando a correção para `new` + `attach` + `save!`.

### Refatorações guiadas por conversa

Parte das refatorações deste projeto — como a extração da lógica de parsing para a `ParserFactory` e a migração do `to_props` dos models para serializers dedicados — foram propostas, discutidas e implementadas em conversa direta com o Gemini. O processo se assemelha a um code review interativo: a IA propõe um plano, o desenvolvedor questiona, aprova ou rejeita partes, e a execução acontece de forma incremental.

> A IA não substituiu o julgamento técnico — ela amplificou a velocidade de execução enquanto o desenvolvedor manteve o controle das decisões de design.

