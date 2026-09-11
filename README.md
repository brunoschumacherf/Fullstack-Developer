# Testes

A suíte usa RSpec, com fixtures em `spec/fixtures` e cobertura mínima de 90% de linhas e branches via SimpleCov.

Com Ruby e PostgreSQL configurados, instale as dependências com `bundle install` e `npm ci`.

```sh
RAILS_ENV=test bin/rails db:test:prepare
bundle exec rspec
```

Para executar somente os testes sem navegador:

```sh
bundle exec rspec --exclude-pattern 'spec/system/**/*_spec.rb'
```

Os testes de sistema usam Chrome headless e podem ser executados com `bundle exec rspec spec/system`.
Para executar um arquivo específico, use, por exemplo, `bundle exec rspec spec/models/user_spec.rb`.

Com Docker Compose (a imagem inclui Chromium e ChromeDriver):

```sh
docker compose build app
docker compose run --rm app bundle exec rspec
docker compose run --rm app bundle exec rubocop
```

O entrypoint seleciona o ambiente de teste para RSpec e prepara `user_management_test`.
