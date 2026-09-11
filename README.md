# Umanni — User Management

A fullstack user management application built with **Ruby on Rails 8**, **React 19**, and **Inertia.js**. Administrators can create, edit, and bulk-import users via CSV or Excel files, with real-time import progress delivered through ActionCable WebSockets.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Ruby 4 · Rails 8.1 · PostgreSQL 16 |
| Frontend | React 19 · TypeScript · Tailwind CSS 4 |
| Bridge | Inertia.js 3 · Vite 8 |
| Background jobs | Solid Queue |
| Cache | Solid Cache |
| WebSocket | Solid Cable + ActionCable |
| Ruby tests | RSpec · Capybara · Selenium |
| JS tests | Jest · Testing Library |
| Linter | RuboCop (omakase) · TypeScript strict |
| Deployment | Kamal 2 · Thruster |

---

## Prerequisites

- [Docker](https://www.docker.com/) and Docker Compose
- Node.js ≥ 20 (only required to run Jest locally; optional)

---

## Setup & Running

### 1. Clone the repository

```bash
git clone <repo-url>
cd fullstack-developer
```

### 2. Configure environment variables

```bash
cp .env.example .env
```

Edit `.env` if you need to change database credentials or other settings.

### 3. Build the Docker image

```bash
docker compose build
```

### 4. Set up the database

This command creates the database, runs all migrations, and seeds initial data:

```bash
docker compose run --rm app bin/rails db:setup
```

To run only migrations on an existing database:

```bash
docker compose run --rm app bin/rails db:migrate
```

### 5. Start the application

```bash
docker compose up
```

| Service | URL |
|---|---|
| Rails application | http://localhost:3000 |
| Vite dev server (HMR) | http://localhost:3036 |

The stack runs three processes simultaneously (Rails server, Vite, and Solid Queue worker) as defined in `Procfile.dev`.

---

## Development

```bash
# Open a Rails console
docker compose run --rm app bin/rails console

# Install a new gem (after editing Gemfile)
docker compose run --rm app bundle install

# Generate and run a new migration
docker compose run --rm app bin/rails generate migration AddColumnToTable column:type
docker compose run --rm app bin/rails db:migrate

# Run any one-off command inside the container
docker compose run --rm app <command>
```

---

## Testing

### Ruby — RSpec

```bash
# Run the full test suite
docker compose run --rm app bundle exec rspec

# Run a specific file or directory
docker compose run --rm app bundle exec rspec spec/serializers/user_serializer_spec.rb
docker compose run --rm app bundle exec rspec spec/services/user_imports/

# Reproduce a failure with a fixed seed
docker compose run --rm app bundle exec rspec --seed 1234
```

> Coverage reports are generated at `coverage/index.html`. The project enforces a minimum of **90% line and branch coverage** via SimpleCov.

### JavaScript — Jest

```bash
# Run the full suite
npm test

# Run with coverage
npm run test:coverage

# Watch mode
npx jest --watch
```

### TypeScript type checking

```bash
npm run check
```

### Development sample users

The admin listing searches partial names and complete email addresses, preserving the filter while paginating.
Populate the development database with 100 sample users using the idempotent script:

```bash
docker compose run --rm app bundle exec rails runner script/create_users.rb
```

---

## Linting

```bash
# Check for offenses
docker compose run --rm app bundle exec rubocop

# Auto-fix safe offenses
docker compose run --rm app bundle exec rubocop -a
```

---

## CI — Full check command

```bash
docker compose run --rm app bundle exec rspec && docker compose run --rm app bundle exec rubocop
```

---

## Architecture

```
app/
├── controllers/
│   ├── admin/
│   │   ├── dashboard_controller.rb    # Admin panel
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
│   ├── user_serializer.rb             # ActiveModel::Serializer
│   └── user_import_serializer.rb
├── services/
│   ├── dashboard/
│   │   ├── stats.rb                   # Aggregates dashboard metrics
│   │   └── broadcaster.rb             # Broadcasts via ActionCable
│   └── user_imports/
│       ├── parser_factory.rb          # Selects CSV or Excel parser
│       ├── csv_parser.rb
│       ├── excel_parser.rb
│       └── processor.rb              # Orchestrates the import
└── jobs/
    └── process_user_import_job.rb     # Async import job
```

### User import flow

```
CSV / XLSX upload
       │
       ▼
UserImportsController#create
       │  persists file via Active Storage
       ▼
ProcessUserImportJob  (Solid Queue)
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

## Environment Variables

| Variable | Description | Default |
|---|---|---|
| `POSTGRES_USER` | Database user | `postgres` |
| `POSTGRES_PASSWORD` | Database password | `password` |
| `DB_HOST` | PostgreSQL host | `localhost` |
| `DB_PORT` | PostgreSQL port | `5432` |
| `DATABASE_URL` | Full connection URL (production) | — |
| `RAILS_MASTER_KEY` | Rails credentials key | — |
| `INERTIA_SSR` | Enable Inertia SSR | `false` |
| `INERTIA_SSR_URL` | SSR server URL | `http://127.0.0.1:13714` |
| `RUBY_ZJIT_ENABLE` | Enable Ruby 4 ZJIT compiler | `0` |

---

## Sample Import Files

Two ready-to-use files are included at the project root for testing the bulk import feature:

| File | Format |
|---|---|
| `example_users_import.csv` | CSV |
| `example_users_import.xlsx` | Excel |

Supported columns: `full_name`, `email`, `role` (`admin` or `member`), `avatar_url`.

---

## Deployment

The project uses **Kamal 2** for zero-downtime Docker-based deployments. See `.kamal/` for server and secrets configuration.

```bash
# First deploy
kamal setup

# Subsequent deploys
kamal deploy
```

---

## AI Usage Declaration

This project was developed with the assistance of **[Google Gemini](https://gemini.google.com/)**, integrated directly into the editor via **[Antigravity IDE](https://antigravity.dev/)**.

### Code autocomplete

Gemini acted as a real-time pair programmer throughout development. Suggestions were accepted, adapted, or discarded with critical judgment — AI accelerated the writing of boilerplate and repetitive patterns, while architecture decisions, method names, and folder structure were always reviewed and adjusted manually to ensure consistency with the rest of the project.

Concrete examples where autocomplete saved meaningful time:

- Initial structure of `CsvParser` and `ExcelParser` with header normalization logic
- Serializer scaffolding using `ActiveModel::Serializer`
- RSpec spec bodies — fixtures, `let`, `subject`, and context blocks

### Test setup

All specs in this project were written **with direct AI assistance**. The workflow was:

1. Write the production code
2. Ask Gemini to generate the corresponding test cases
3. Review every spec — adjust fixtures, fix edge cases, and ensure tests actually validate behavior rather than just confirming the code runs

This process uncovered real bugs: the ordering of `create!` vs `file.attach` in the `UserImportSerializer` spec, for instance, was caught precisely because the AI-generated test attempted to persist the record before attaching the file — forcing the correction to `new` + `attach` + `save!`.

### Conversation-driven refactoring

Several refactorings in this project — including the extraction of parsing logic into `ParserFactory` and the migration of `to_props` from models into dedicated serializers — were proposed, discussed, and implemented through direct conversation with Gemini. The process resembles an interactive code review: the AI proposes a plan, the developer questions, approves, or rejects parts of it, and execution happens incrementally with full visibility at each step.

> AI did not replace technical judgment — it amplified execution speed while the developer retained full control over design decisions.
