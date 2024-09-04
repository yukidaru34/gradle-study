#!/bin/bash

# ファイル名: bump.sh

# バージョンを変更する部品名を取得
COMPONENT_NAME=$1
# バージョンタイプ（major, minor, patch）を取得
VERSION_TYPE=$2

# 指定された形式のタグを解析する正規表現パターンを定義
TAG_PATTERN="^${COMPONENT_NAME}:([0-9]+)\.([0-9]+)\.([0-9]+)-snapshot$"

# 最新のバージョンタグを初期化
LATEST_TAG=""
LATEST_VERSION=(0 0 0)

# すべてのタグを取得し、最新のバージョンを見つける
for TAG in $(git tag); do
  if [[ $TAG =~ $TAG_PATTERN ]]; then
    MAJOR=${BASH_REMATCH[1]}
    MINOR=${BASH_REMATCH[2]}
    PATCH=${BASH_REMATCH[3]}
    
    # 現在のタグのバージョンを配列に格納
    CURRENT_VERSION=($MAJOR $MINOR $PATCH)
    
    # 現在のバージョンが最新のバージョンより新しい場合、最新のバージョンを更新
    for i in {0..2}; do
      if (( CURRENT_VERSION[i] > LATEST_VERSION[i] )); then
        LATEST_VERSION=(${CURRENT_VERSION[@]})
        LATEST_TAG=$TAG
        break
      elif (( CURRENT_VERSION[i] < LATEST_VERSION[i] )); then
        break
      fi
    done
  fi
done

# タグが存在するか確認
if [[ -z "$LATEST_TAG" ]]; then
  echo "No tags found in the repository that match the specified format."
  exit 1
fi

# 最新のバージョンを取得
MAJOR=${LATEST_VERSION[0]}
MINOR=${LATEST_VERSION[1]}
PATCH=${LATEST_VERSION[2]}

# バージョンをインクリメント
case $VERSION_TYPE in
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
    echo "Unknown version type: $VERSION_TYPE"
    exit 1
    ;;
esac

# 新しいバージョンを組み立て
NEW_TAG="${COMPONENT_NAME}:${MAJOR}.${MINOR}.${PATCH}-snapshot"
NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}-snapshot"

# Gitタグを作成してプッシュ
git tag -a "$NEW_TAG" -m "Version $NEW_TAG"
git push origin "$NEW_TAG"

# GitHub Actions用の環境変数ファイルに書き込む
echo "NEW_VERSION=${NEW_VERSION}" >> $GITHUB_ENV

echo "Successfully bumped version to $NEW_VERSION"