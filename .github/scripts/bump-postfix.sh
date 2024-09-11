#!/bin/bash

# 引数チェック
if [ -z "$1" ]; then
    echo "シェルの実行引数を指定してください"
    exit 1
fi
API_OR_FRONT=$1
PREFIX=$2
LABEL=$3
RELEASE_NUM=$4

git fetch --tags

case $LABEL in
    "release")
        LATEST_TAG=$(git tag -l "${PREFIX}*" | grep -E "^${API_OR_FRONT}/${PREFIX}-[0-9]+\.[0-9]+\.[0-9]-snapshot" | sort -V | tail -n 1)
        ;;
    "main")
        LATEST_TAG=$(git tag -l "${PREFIX}*" | grep -E "^${API_OR_FRONT}/${PREFIX}-[0-9]+\.[0-9]+\.[0-9]-rc\.[0-9]+" | sort -V | tail -n 1)
        ;;
    *)
        LATEST_TAG=$(git tag -l "${PREFIX}*" | grep -E "^${API_OR_FRONT}/${PREFIX}-[0-9]+\.[0-9]+\.[0-9]-${LABEL}" | sort -V | tail -n 1)
        ;;
esac

if [ -z "$LATEST_TAG"]; then
    echo "指定したプレフィックスが無効です"
    exit 1
else
    echo "最新のタグは${LATEST_TAG}です。"

    VERSION=$(echo "$LATEST_TAG" | sed "s/^${API_OR_FRONT}/${PREFIX}-//")
    MAJOR=$(echo "$VERSION" | cut -d. -f1)
    MINOR=$(echo "$VERSION" | cut -d. -f2)
    PATCH=$(echo "$VERSION" | cut -d. -f3)

    if [ "$LABEL" == "release" ]; then
        NEW_TAG="${API_OR_FRONT}/${PREFIX}-${MAJOR}.${MINOR}.${PATCH}-rc.${RELEASE_NUM}"
        NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}-rc.${RELEASE_NUM}"
    elif [ "$LABEL" == "main" ]; then
        NEW_TAG="${API_OR_FRONT}/${PREFIX}-${MAJOR}.${MINOR}.${PATCH}"
        NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
    else
        NEW_TAG="${API_OR_FRONT}/${PREFIX}-${MAJOR}.${MINOR}.${PATCH}-${LABEL}"
        NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}-${LABEL}"
    fi
fi

git tag "$NEW_TAG"
git push origin "$NEW_TAG"
echo "新しいタグを作成しました"
echo "NEW_VERSION=$NEW_VERSION" >> $GITHUB_ENV
