#!/bin/bash
# Скачивает и распаковывает 1С-Битрикс в APP_PATH, если каталога bitrix ещё нет.
# APP_PATH — корень репозитория (volume ./:${APP_PATH}), поэтому docker-compose.yml,
# makefile, README, .env и .gitignore не перезаписываются.

if [[ -d "$APP_PATH/bitrix" ]]; then
  log success "Битрикс уже есть в $APP_PATH — скачивать не нужно"
else
  log info "Скачиваю Битрикс ($BUILD_BITRIX_VERSION), это может занять несколько минут…"
  wget -q --show-progress -O "/tmp/$BUILD_BITRIX_VERSION.zip" "https://www.1c-bitrix.ru/download/${BUILD_BITRIX_VERSION}.zip"
  mkdir -p /tmp/bitrix-app
  unzip -qo "/tmp/$BUILD_BITRIX_VERSION.zip" -d /tmp/bitrix-app
  # -n: не затираем файлы репозитория, уже лежащие в корне (compose, .env, README)
  cp -an /tmp/bitrix-app/. "$APP_PATH/"
  rm -rf /tmp/bitrix-app "/tmp/$BUILD_BITRIX_VERSION.zip"
  log success "Дистрибутив распакован в $APP_PATH"
fi
