# Rails 8.0.2 + Ruby 3.4.4 環境でUPKI証明書管理システムを構築
# 注意: 本番環境では適切なセキュリティ設定をしてください
FROM ruby:3.4.4

# 必要なパッケージのインストール
RUN apt-get update -qq && \
    apt-get install -y \
        build-essential \
        pkg-config \
        libsqlite3-dev \
        nodejs \
        npm \
        curl \
        git \
        vim \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# Gemfile と Gemfile.lock をコピー
COPY Gemfile Gemfile.lock ./

# Bundler のインストールと gem の インストール
RUN gem install bundler:2.6.9
RUN bundle install

# package.json があれば npm install も実行
COPY package*.json ./
RUN npm install 2>/dev/null || echo "package.json not found, skipping npm install"

# アプリケーションコードをコピー
COPY . .

# データベースの初期化とアセットのプリコンパイル
RUN bundle exec rails db:prepare RAILS_ENV=development
RUN bundle exec rails assets:precompile RAILS_ENV=development

# ポート3000を公開
EXPOSE 3000

# 起動時のヘルスチェック
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# サーバー起動コマンド
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]