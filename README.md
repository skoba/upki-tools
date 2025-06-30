# UPKI証明書管理システム

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/skoba/upki-tools/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Ruby](https://img.shields.io/badge/ruby-3.4.4-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/rails-8.0.2-red.svg)](https://rubyonrails.org/)

日本の大学PKI（UPKI）システム用のSSL証明書管理Webアプリケーションです。証明書の申請、発行、更新、失効管理を効率的に行うことができます。

## 概要

本システムは医療オープンソースソフトウェア協議会において、大学PKIインフラストラクチャ内でのSSL証明書ライフサイクル管理を目的として開発されました。

### 主な機能

- **証明書申請**: CSR（証明書署名要求）と秘密鍵の自動生成
- **証明書管理**: 発行、更新、失効の一元管理
- **バッチ処理**: 複数証明書の一括操作
- **TSV連携**: UPKI系統との連携のためのTSV形式データ処理
- **ファイル管理**: 証明書・秘密鍵のZIPアーカイブ配布
- **ドメイン管理**: SSL証明書対象ドメインの管理
- **操作者管理**: 証明書管理者の登録・管理

## システム要件

### 必要なソフトウェア

- **Ruby**: 3.4.4
- **Rails**: 8.0.2
- **データベース**: SQLite3 2.7
- **Node.js**: 推奨版（パッケージ管理用）

### 依存ライブラリ

主要なライブラリとその役割：

- **Puma 6.0**: Webサーバー
- **Bootstrap 5.3**: UIフレームワーク
- **Importmap-rails**: JavaScriptモジュール管理
- **Turbo-rails**: SPA風ナビゲーション
- **Stimulus-rails**: プログレッシブ拡張JavaScriptフレームワーク
- **RSpec**: テストフレームワーク
- **Guard**: 開発自動化ツール

## セットアップ手順

### 🐳 Dockerを使用した簡単セットアップ（推奨）

**最も簡単な方法**：Dockerがインストールされていれば、すぐに試用できます。

```bash
# リポジトリのクローン
git clone https://github.com/skoba/upki-tools.git
cd upki-tools

# Dockerで起動（初回は自動でビルド）
docker-compose up

# バックグラウンドで起動する場合
docker-compose up -d
```

アプリケーションは http://localhost:3000 でアクセス可能です。

**オプション機能**：
```bash
# データベースブラウザも同時起動（開発用）
docker-compose --profile tools up

# データベースブラウザ: http://localhost:8080
```

**停止方法**：
```bash
# 停止
docker-compose down

# データも含めて完全削除
docker-compose down -v
```

### 💻 ローカル環境でのセットアップ

#### 1. リポジトリのクローン

```bash
git clone https://github.com/skoba/upki-tools.git
cd upki-tools
```

#### 2. 依存関係のインストール

```bash
# Ruby gem のインストール
bundle install

# JavaScript パッケージのインストール
npm install
```

#### 3. データベースの準備

```bash
# データベースの作成とマイグレーション実行
bin/rails db:prepare
```

#### 4. 設定ファイルの確認

PKI固有の設定は `config/profile.yml` で管理されています：

```yaml
# 組織情報の設定例
DN:
  C: JP
  ST: Tokyo
  L: Tokyo
  O: 医療オープンソースソフトウェア協議会
```

#### 5. 開発サーバーの起動

```bash
# Rails サーバーの起動
bin/rails server

# 自動化開発環境の起動（推奨）
guard start
```

アプリケーションは http://localhost:3000 でアクセス可能です。

## 開発ワークフロー

### テストの実行

```bash
# 全テストの実行
bin/rspec

# 特定のテストファイルの実行
bin/rspec spec/models/certificate_spec.rb

# 継続的テスト実行
guard start
```

### コード品質チェック

```bash
# RuboCop による静的解析
bundle exec rubocop

# 自動修正
bundle exec rubocop -a
```

### データベース操作

```bash
# マイグレーション実行
bin/rails db:migrate

# データベースリセット
bin/rails db:reset

# シード データの読み込み
bin/rails db:seed
```

## アーキテクチャ

### データモデル

- **Certificate**: 証明書の基本情報とライフサイクル管理
- **Domain**: SSL証明書対象ドメインの管理
- **Person**: 証明書管理者・操作者の情報
- **関係性**: Person → Domain → Certificates（一対多）

### セキュリティ機能

- **RSA 2048ビット**: 暗号化キー生成
- **SHA-256**: 署名アルゴリズム
- **CSRF保護**: クロスサイトリクエストフォージェリ対策
- **一時ファイル自動削除**: セキュリティ向上のための自動クリーンアップ

### フロントエンド

Rails 8の現代的なフロントエンド技術を採用：

- **Importmap**: バンドル不要のJavaScriptモジュール管理
- **Turbo**: サーバーサイドレンダリングによる高速ナビゲーション
- **Stimulus**: 軽量なJavaScriptフレームワーク
- **Bootstrap 5.3**: レスポンシブUIコンポーネント

## 運用

### ログ管理

開発環境のログは `log/development.log` に出力されます。

### バックアップ

SQLite3データベースファイル `db/development.sqlite3` を定期的にバックアップしてください。

### 証明書ファイル管理

- 証明書と秘密鍵は一時的にメモリ上で生成
- ZIPアーカイブとして安全にダウンロード提供
- ファイルシステム上には永続保存しない設計

### セキュリティとプライバシー

**重要**: 以下のディレクトリ・ファイルには機密情報が含まれるため、Gitリポジトリには含まれません：

- `log/` - アプリケーションログ（アクセス履歴、操作履歴等）
- `db/*.sqlite3` - データベースファイル（証明書情報、個人情報等）
- `*.key`, `*.pem`, `*.crt` - 証明書関連ファイル
- `config/secrets.yml`, `.env` - 設定ファイル（パスワード、APIキー等）

本番環境では適切なバックアップとアクセス制御を実施してください。

## トラブルシューティング

### よくある問題

1. **sqlite3 インストール エラー**
   ```bash
   gem install pkg-config
   bundle install
   ```

2. **JavaScript エラー**
   ```bash
   bin/importmap pin @hotwired/turbo-rails
   ```

3. **データベース接続エラー**
   ```bash
   bin/rails db:reset
   ```

### Docker関連の問題

1. **ポート3000が使用中**
   ```bash
   # 使用中のプロセスを確認
   lsof -i :3000
   
   # 別のポートで起動
   docker-compose run --service-ports -e PORT=3001 upki-tools
   ```

2. **ボリュームのリセット**
   ```bash
   # 全データをリセット
   docker-compose down -v
   docker-compose up --build
   ```

3. **イメージの再ビルド**
   ```bash
   docker-compose build --no-cache
   docker-compose up
   ```

## 貢献方法

このプロジェクトへの貢献を歓迎します！詳細は[CONTRIBUTING.md](CONTRIBUTING.md)を参照してください。

### 簡単な貢献方法
- 🐛 バグ報告や機能要求は[Issues](https://github.com/skoba/upki-tools/issues)へ
- 💡 改善提案や質問は[Discussions](https://github.com/skoba/upki-tools/discussions)へ
- 🔒 セキュリティ関連の報告は直接メール（skoba@moss.gr.jp）へ

### ⚠️ セキュリティ警告
**重要**: Issues報告時は**絶対に秘密鍵・実際の証明書・パスワード**を含めないでください。詳細は[CONTRIBUTING.md](CONTRIBUTING.md#️-セキュリティ関連の重要な注意事項)を必読。

## 免責事項

### ⚠️ 重要な注意事項

本ソフトウェアは**現状のまま（AS IS）**提供され、以下の点にご注意ください：

#### セキュリティと責任について
- **本番環境での使用は自己責任**で行ってください
- **セキュリティ監査**を実施してから運用することを強く推奨します
- **重要な証明書の管理**には十分な検証とテストを行ってください
- **データのバックアップ**は運用者の責任で実施してください

#### 証明書管理の特殊性
- PKI証明書の紛失や不正利用は**重大なセキュリティインシデント**につながる可能性があります
- **証明書の有効期限管理**は運用者が責任を持って行ってください
- **秘密鍵の保護**は最重要事項です

#### サポートと保証
- **動作保証はありません** - 各環境での動作検証は利用者が実施
- **技術サポートは限定的** - コミュニティベースでの支援
- **データ損失等の損害** - 開発者・貢献者は一切の責任を負いません

### 🏥 大学・医療機関での利用について

- **情報セキュリティポリシー**に準拠した利用を行ってください
- **個人情報保護**に関する法令を遵守してください
- **システム管理者**による適切な運用管理が必要です

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細は[LICENSE](LICENSE)ファイルを参照してください。

このソフトウェアは、大学・研究機関での自由な利用、改変、再配布を推奨しています。商用利用も含めて制限はありません。

**MITライセンスの免責条項**: 本ソフトウェアは無保証で提供され、開発者は一切の責任を負いません。

## 連絡先

開発・保守に関するお問い合わせ：
- 開発者: KOBAYASHI Shinji
- 組織: 医療オープンソースソフトウェア協議会
- 所在地: 日本

## 更新履歴

- **2025年**: Rails 8.0.2へのアップグレード、モダンフロントエンド技術への移行
- **従来版**: Rails 6.x/7.x、Webpacker使用版