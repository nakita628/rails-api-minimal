# rails-api-minimal

[Ruby on Rails](https://rubyonrails.org/) の最小構成の REST API です。
`GET /hello` を 1 つだけ持ち、リクエストスペックから [rswag](https://github.com/rswag/rswag) で
**OpenAPI 3.0.1 のドキュメントを生成**します。
Dockerfile も [dockerfile-rails](https://github.com/rubys/dockerfile-rails) で**自動生成**します。

DB は使いません（`--skip-active-record`）。Active Record / Active Job / Action Mailer /
Action Cable / Active Storage はどれも読み込みません。

## セットアップ

Ruby のバージョンは `mise.toml` で固定しています（[mise](https://mise.jdx.dev/)）。

```bash
mise install      # Ruby 3.4.10
bundle install
```

## 起動

```bash
bin/rails server
```

```bash
curl http://localhost:3000/hello
# => {"message":"Hello, World!"}
```

## テスト

```bash
bundle exec rspec
```

## OpenAPI ドキュメントの生成

`spec/requests/**/*_spec.rb` を実行して `swagger/v1/swagger.yaml` を生成します。

```bash
bundle exec rake rswag:specs:swaggerize
```

## Dockerfile の生成

`Dockerfile` / `.dockerignore` / `bin/docker-entrypoint` は手書きせず、ジェネレータで生成します。

```bash
bin/rails generate dockerfile
```

オプションは `config/dockerfile.yml` に保存されるので、引数なしで何度でも再生成できます
（このプロジェクトでは DB が無いため `--no-prepare` を指定済み）。

```bash
docker build -t rails-api-minimal .

docker run -d -p 3000:3000 --name rails-api-minimal \
  -e SECRET_KEY_BASE=$(openssl rand -hex 64) \
  rails-api-minimal
```

コンテナは `RAILS_ENV=production` で動きます。

```bash
curl http://localhost:3000/hello
# => {"message":"Hello, World!"}
```

## ファイル構成

```
mise.toml                            # Ruby 3.4.10 の固定 + GEM_HOME の分離
Gemfile                              # railties, actionpack, puma, json, rspec-rails, rswag-specs, dockerfile-rails
Gemfile.lock
Rakefile
config.ru
Dockerfile                           # 生成物 (bin/rails generate dockerfile)
.dockerignore                        # 生成物
app/controllers/hello_controller.rb  # GET /hello
bin/
  rails
  docker-entrypoint                  # 生成物
config/
  application.rb                     # 15 行。action_controller の require と設定 4 つだけ
  environment.rb
  routes.rb
  dockerfile.yml                     # ジェネレータのオプション
  database.yml                       # 中身は無し。理由はファイル内のコメント参照
spec/
  swagger_helper.rb                  # OpenAPI のメタ情報・components.schemas
  requests/hello_spec.rb             # テスト兼 OpenAPI の定義元
swagger/v1/swagger.yaml              # 生成される OpenAPI ドキュメント
```

`config/environments/` はありません。`config/application.rb` に残しているのは
`load_defaults` / `api_only` / `eager_load` と、production の stdout ログだけです。
HTTPS の強制 (`force_ssl`) は設定していないので、TLS 終端は前段のプロキシに任せてください。

## エンドポイントを追加する

1. `app/controllers/` にコントローラを作り、`config/routes.rb` にルートを追加する
2. `spec/requests/` に rswag の DSL でスペックを書く
   （レスポンスのスキーマは `spec/swagger_helper.rb` の `components.schemas` に追加）
3. `bundle exec rake rswag:specs:swaggerize` で OpenAPI を再生成する

## 補足

- Rails 7.2 の JSON エンコーダは `json` gem の 3.x と非互換（`quirks_mode` が削除された）のため、
  Gemfile で `gem "json", "~> 2.7"` を固定しています。
- 生成される Dockerfile には `DATABASE_URL` と `VOLUME /data` が含まれます。
  dockerfile-rails は DB 無しの構成を想定しておらず（`deploy_database` の既定値が `sqlite3`)、
  これを抑制するオプションがありません。Active Record を読み込んでいないので実害はありません。
- Swagger UI で表示したい場合は `rswag-ui` / `rswag-api` を追加してください
  （生成そのものには不要なので含めていません）。
