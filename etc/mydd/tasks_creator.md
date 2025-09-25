---
name: tasks_creator
description: spec DDでタスクを定義する
---

## 実装計画書の例

````markdown
# [一言説明] 実装計画書

## 実装タスク一覧

### 1. 事前準備
- [ ] 1.1 `api/routes/foo.ts`の`/download`エンドポイントの実装を確認して参考にする
- [ ] 1.2 Fooモデルのスキーマ構造を確認する

### 2. 依存関係の追加
- [ ] 2.1 `api/routes/foo.ts`のファイル冒頭にmomentをimportする
  ```javascript
  const moment = require('moment');
  ```

### 3. エンドポイントの実装

#### 3.1 エンドポイントの追加
- [ ] 3.1.1 `api/routes/foo.ts`に新規エンドポイント`router.get('/download', ...)`を追加
  - 既存の`/download/:id`エンドポイントの**前**に配置する（ルーティング優先順位のため）

#### 3.2 バリデーション処理
- [ ] 3.2.1 リクエストパラメータの存在確認を実装
  ```javascript
  if (!req.query.book_id || !req.query.from || !req.query.to) {
    return res.json({ error: '不正なパラメーターです' });
  }
  ```

#### 3.3 データ取得処理
- [ ] 3.3.1 日付範囲の処理を実装
  - `from`: moment(from).startOf('day')で開始日の00:00:00に設定
  - `to`: moment(to).endOf('day')で終了日の23:59:59に設定

- [ ] 3.3.2 MongoDBクエリを実装
  ```javascript
  const log = await StockOperationLog.find({
    '$and': [
      { book_id: req.query.book_id },
      { createdAt: { $gte: moment(req.query.from).startOf('day') }},
      { createdAt: { $lte: moment(req.query.to).endOf('day') }}
    ]
  })
  .sort({ createdAt: 'desc' })
  .populate('book_id', 'name')
  .populate('user_id', 'username');
  ```

#### 3.4 エラーハンドリング
- [ ] 3.4.1 try-catchブロックでエラー処理を実装
  ```javascript
  try {
    // メイン処理
  } catch (e) {
    console.info(e);
    throw Error(e);
  }
  ```

#### 3.5 レスポンス処理
- [ ] 3.5.1 取得したログデータをJSON形式で返却する実装
  ```javascript
  res.json(log);
  ```

### 4. テストファイルの実装
- [ ] `__tests__/e2e/stock_operation_log/`ディレクトリを作成（存在しない場合）
- [ ] `getStockOperationLogDownload.test.ts`ファイルを作成

<!-- こんな感じで実行方法も書いておく -->
```typescript
npm run test __tests__/e2e/stock_operation_log/getStockOperationLogDownload.test.ts
```

#### 4.1 テストファイルの基本構造
- [ ] 4.1.1 必要なモジュールをimport
- [ ] 4.1.2 テストデータの作成

#### 4.2 テストケースの実装
- [ ] 正常系テスト
  - [ ] `正常系_有効なパラメータでログ取得`
  - [ ] `正常系_該当データなし`

- [ ] 異常系テスト
  - [ ] `異常系_book_id不足`

- [ ] 境界値テスト
  - [ ] `境界値_開始日と終了日が同じ`
  - [ ] `境界値_1日だけのデータ取得`

### 5. テスト実行と確認
- [ ] テストを実行
- [ ] 全テストケースがパスすることを確認


## 注意事項

- t_wadaさんのテスト駆動開発をする
- **重要**: `/download`エンドポイントは`/download/:id`より**前**に配置すること（ルーティングの優先順位）
- populateで取得するフィールドは最小限に留める（パフォーマンス考慮）
- エラーレスポンスの形式は既存のAPIと統一する
````

## 指示
次の順に従ってください。`YYYY-MM-DD-BRIEF-DESC`の部分は事前に指示されます。

- `./.mywork/specs/YYYY-MM-DD-BRIEF-DESC/requirements.md`を読み込む
- `./.mywork/specs/YYYY-MM-DD-BRIEF-DESC/design.md`を読み込む
- 要件定義・設計書に基づき、上記の例のような実装計画書を `./.mywork/specs/YYYY-MM-DD-BRIEF-DESC/tasks.md` として書く

補足：
- テストの実装がある場合は「t_wadaさんのテスト駆動開発をする」の旨を書きます
- 実装・修正箇所の行番号はなるべく書かない。ファイルを編集すると行番号はズレるため
