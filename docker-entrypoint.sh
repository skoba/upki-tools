#!/bin/bash
set -e

echo "🚀 UPKI証明書管理システムを開始しています..."

# Bundlerの設定
echo "📦 Bundlerを設定中..."
bundle config set --local path 'vendor/bundle'

# 依存関係のインストール
echo "💎 Ruby gemをインストール中..."
bundle install

# Node.jsの依存関係をインストール
if [ -f "package.json" ]; then
    echo "📦 Node.js依存関係をインストール中..."
    npm install
fi

# データベースの準備
echo "🗄️ データベースを準備中..."
bundle exec rails db:prepare

# アセットのプリコンパイル
echo "🎨 アセットをプリコンパイル中..."
bundle exec rails assets:precompile

# ログディレクトリの権限設定
mkdir -p log tmp
chmod 755 log tmp

echo "✅ セットアップ完了！"
echo "🌐 アプリケーションは http://localhost:3000 でアクセス可能です"

# メインコマンドを実行
exec "$@"