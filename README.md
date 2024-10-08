# CI 設計(ECS)

## Checkstyle のワークフローサンプル

```
name: Checkstyle

on:
  push:
    branches:
      - *

jobs:
  checkstyle:
    runs-on: code build pj

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Set up JDK 11
      uses: actions/setup-java@v2
      with:
        distribution: 'adopt'
        java-version: '11'

    - name: Install Gradle
      uses: gradle/gradle-build-action@v2
      with:
        gradle-version: 7.0 # 必要なバージョンを指定してください

    - name: Run Checkstyle
      run: gradle check

    - name: Archive Checkstyle reports
      if: always()
      uses: actions/upload-artifact@v2
      with:
        name: checkstyle-reports
        path: app/build/reports/checkstyle/
```

リポジトリ設定で、失敗したチェックをブロックするように設定できます：

1.GitHub リポジトリに移動します。  
2.「Settings」タブをクリックします。  
3.左サイドバーの「Branches」をクリックします。  
4.「Branch protection rules」セクションで、「Add rule」をクリックします。  
5.保護したいブランチ名（例：main）を入力し、「Require status checks to pass before merging」を有効にします。  
6.追加したチェック（例：Checkstyle）を選択します。

## Trivy でできること

- 対応する OS のパッケージ情報から脆弱性を検出する。
- アプリケーションの依存関係解決ツールでインストールされるライブラリの脆弱性をスキャンする。
- 診断の結果を標準出力、テキストに出力する。

## Trivy でやること

- 前述した項目全て実施する。
- 診断の結果を pull request でコメントとして出力することも可能っぽそう。やる必要あるかは要検討。  
  （出力することで、CI の時間が著しく遅くなる、出力される内容を誰が見るか、などの観点で要否の判断を行う）
- github Action で実施するため、trivy-action を使用する。  
  https://github.com/aquasecurity/trivy-action

# CD 設計(ECS)

## 基本ワークフロー

![基本ワークフロ](/image/基本ワークフロー.jpg)
仮でワークフローファイルの側を作成。
