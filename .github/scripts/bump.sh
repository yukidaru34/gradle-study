#!/bin/bash

# 使用法: ./bump.sh <prefix>
# 例: ./bump.sh v

# 引数チェック
if [ -z "$1" ]; then
  echo "例: ./bump.sh v"
  exit 1
fi

PREFIX=$1
OCTET=$2


# 現在のタグ一覧を取得し、正規表現で該当するプレフィックスのタグを検索
git tag -l "${PREFIX}*"
LATEST_TAG=$(git tag -l "${PREFIX}*" | grep -E "^${PREFIX}-[0-9]+\.[0-9]+\.[0-9]+-snapshot$" | sort -V | tail -n 1)


# タグが存在しない場合の処理
if [ -z "$LATEST_TAG" ]; then
  echo "該当するタグが見つかりませんでした。${PREFIX}-0.1.0-snapshot を作成します。"
  NEW_TAG="${PREFIX}-0.1.0-snapshot"
  NEW_VERSION="0.1.0-snapshot"
else
  # 最新のタグのバージョン番号を分割
  echo "最新のタグは ${LATEST_TAG} です。"

  VERSION=$(echo "$LATEST_TAG" | sed "s/^${PREFIX}-//")
  MAJOR=$(echo "$VERSION" | cut -d. -f1)
  MINOR=$(echo "$VERSION" | cut -d. -f2)
  PATCH=$(echo "$VERSION" | cut -d. -f3)

  case "$OCTET" in
    major)
      MAJOR=$((MAJOR + 1))
      MINOR=0
      PATCH=0
      ;;
    minor)
      MINOR=$((MINOR + 1))
      PATCH=0
      ;;
    patch)
      PATCH=$((PATCH + 1))
      ;;
    *)
      echo "無効なオクテット指定です。'major', 'minor', 'patch' のいずれかを指定してください。"
      exit 1
      ;;
  esac

  # 新しいタグを作成
  NEW_TAG="${PREFIX}-${MAJOR}.${MINOR}.${PATCH}-snapshot"
  NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}-snapshot"
fi

# 新しいタグの作成と出力
git tag "$NEW_TAG"
git push origin "$NEW_TAG"
echo "新しいタグ ${NEW_TAG} を作成しました。"
echo "NEW_VERSION=$NEW_VERSION" >> $GITHUB_ENV


