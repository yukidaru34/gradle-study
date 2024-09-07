#!/bin/bash

# ファイル名: bump.sh

# バージョンを変更する部品名を取得
COMPONENT_NAME=$1
# バージョンタイプ（major, minor, patch）を取得
VERSION_TYPE=$2


# 最新のバージョンタグを取得
LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))

# タグが存在するか確認
if [[ -z "$LATEST_TAG" ]]; then
  echo "No tags found in the repository."
  exit 1
fi

# 現在のバージョンを解析（例: zsy:1.1.0-snapshot）
if [[ $LATEST_TAG =~ $COMPONENT_NAME:([0-9]+)\.([0-9]+)\.([0-9]+)-snapshot ]]; then
  MAJOR=${BASH_REMATCH[1]}
  MINOR=${BASH_REMATCH[2]}
  PATCH=${BASH_REMATCH[3]}
else
  echo "The latest tag does not match the expected format."
  exit 1
fi

# 新しいバージョンを組み立て
NEW_VERSION="zsy:${MAJOR}.${MINOR}.${PATCH}-snapshot"

# Gitタグを作成してプッシュ
git tag -a "$NEW_VERSION" -m "Version $NEW_VERSION"
git push origin --tags

echo "Successfully bumped version to $NEW_VERSION"